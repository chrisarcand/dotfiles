#!/usr/bin/env zsh

# Claude Code CLI integration for zsh
# Inspired by Myzel394/zsh-copilot but adapted for Claude Code CLI using Haiku 4.5

# Default key binding - Ctrl+Z
(( ! ${+ZSH_CLAUDE_KEY} )) &&
    typeset -g ZSH_CLAUDE_KEY='^z'

# Configuration options
(( ! ${+ZSH_CLAUDE_SEND_CONTEXT} )) &&
    typeset -g ZSH_CLAUDE_SEND_CONTEXT=true

(( ! ${+ZSH_CLAUDE_DEBUG} )) &&
    typeset -g ZSH_CLAUDE_DEBUG=false

# Check if claude CLI is available
if ! command -v claude &> /dev/null; then
    echo "Claude Code CLI not found. Please visit https://github.com/anthropics/claude-code"
    return 1
fi

# System prompt for Claude
if [[ -z "$ZSH_CLAUDE_SYSTEM_PROMPT" ]]; then
read -r -d '' ZSH_CLAUDE_SYSTEM_PROMPT <<- EOM
You will be given the raw input of a shell command.
Your task is to either complete the command or provide a new command that you think the user is trying to type.
If you return a completely new command for the user, prefix it with an equal sign (=).
If you return a completion for the user's command, prefix it with a plus sign (+).
MAKE SURE TO ONLY INCLUDE THE REST OF THE COMPLETION!!!
Do not write any leading or trailing characters except if required for the completion to work.

Only respond with either a completion or a new command, not both.
Your response may only start with either a plus sign or an equal sign.
Your response MAY NOT start with both! This means that your response IS NOT ALLOWED to start with '+=' or '=+'.

Your response MAY NOT contain any newlines!
Do NOT add any additional text, comments, or explanations to your response.
Do not ask for more information, you won't receive it.

Your response will be run in the user's shell.
Make sure input is escaped correctly if needed so.
Your input should be able to run without any modifications to it.
DO NOT INTERACT WITH THE USER IN NATURAL LANGUAGE! If you do, you will be banned from the system.
Note that the double quote sign is escaped. Keep this in mind when you create quotes.
Here are two examples:
  * User input: 'list files in current directory'; Your response: '=ls' (ls is the builtin command for listing files)
  * User input: 'cd /tm'; Your response: '+p' (/tmp is the standard temp folder on linux and mac).
EOM
fi

if [[ "$ZSH_CLAUDE_DEBUG" == 'true' ]]; then
    touch /tmp/zsh-claude.log
fi

function _fetch_claude_suggestion() {
    local input="$1"
    local system_prompt="$2"

    # Call Claude Code CLI with --print flag (non-interactive mode)
    # Using Haiku 4.5 model for fast, cost-effective completions
    local response=$(claude --print --model haiku --system-prompt "$system_prompt" --output-format text "$input" 2>&1)
    local response_code=$?

    if [[ "$ZSH_CLAUDE_DEBUG" == 'true' ]]; then
        echo "{\"date\":\"$(date)\",\"log\":\"Called Claude Code CLI\",\"input\":\"$input\",\"response\":\"$response\",\"response_code\":\"$response_code\"}" >> /tmp/zsh-claude.log
    fi

    if [[ $response_code -ne 0 ]]; then
        echo "Error fetching suggestions from Claude Code CLI." > /tmp/.zsh_claude_error
        return 1
    fi

    # With --output-format text, Claude returns clean output without stats
    # Just trim whitespace
    local message=$(echo "$response" | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')

    if [[ "$ZSH_CLAUDE_DEBUG" == 'true' ]]; then
        echo "{\"date\":\"$(date)\",\"log\":\"Extracted message\",\"message\":\"$message\"}" >> /tmp/zsh-claude.log
    fi

    echo "$message" > /tmp/zsh_claude_suggestion || return 1
}

function _show_loading_animation() {
    local pid=$1
    local interval=0.1
    local animation_chars=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    local i=1

    cleanup() {
        kill $pid 2>/dev/null
        echo -ne "\e[?25h"
    }
    trap cleanup SIGINT

    while kill -0 $pid 2>/dev/null; do
        # Display current animation frame
        zle -R "${animation_chars[i]}"

        # Update index, make sure it starts at 1
        i=$(( (i + 1) % ${#animation_chars[@]} ))

        if [[ $i -eq 0 ]]; then
            i=1
        fi

        sleep $interval
    done

    echo -ne "\e[?25h"
    trap - SIGINT
}

function _suggest_claude_ai() {
    #### Prepare environment
    local context_info=""
    if [[ "$ZSH_CLAUDE_SEND_CONTEXT" == 'true' ]]; then
        local system

        if [[ "$OSTYPE" == "darwin"* ]]; then
            system="Your system is macOS $(sw_vers -productVersion 2>/dev/null || echo 'unknown')."
        else
            system="Your system is $(cat /etc/*-release 2>/dev/null | grep PRETTY_NAME | cut -d'"' -f2 || echo 'Linux')."
        fi

        context_info="Context: You are user $(whoami) with id $(id -u) in directory $(pwd).
            Your shell is $(echo $SHELL) and your terminal is $(echo $TERM) running on $(uname -s).
            $system"
    fi

    ##### Get input
    rm -f /tmp/zsh_claude_suggestion /tmp/.zsh_claude_error
    local input=$(echo "${BUFFER:0:$CURSOR}" | tr '\n' ';')
    input=$(echo "$input" | sed 's/"/\\"/g')

    # Clear any existing autosuggestions
    if (( ${+functions[_zsh_autosuggest_clear]} )); then
        _zsh_autosuggest_clear
    fi

    local full_prompt=$(echo "$ZSH_CLAUDE_SYSTEM_PROMPT $context_info" | tr -d '\n')

    ##### Fetch message
    # Suppress job control messages
    setopt local_options no_notify no_monitor
    _fetch_claude_suggestion "$input" "$full_prompt" &
    local pid=$!

    _show_loading_animation $pid
    wait $pid
    local response_code=$?

    if [[ "$ZSH_CLAUDE_DEBUG" == 'true' ]]; then
        echo "{\"date\":\"$(date)\",\"log\":\"Fetched message\",\"input\":\"$input\",\"response_code\":\"$response_code\"}" >> /tmp/zsh-claude.log
    fi

    if [[ ! -f /tmp/zsh_claude_suggestion ]]; then
        if (( ${+functions[_zsh_autosuggest_clear]} )); then
            _zsh_autosuggest_clear
        fi
        zle -M "$(cat /tmp/.zsh_claude_error 2>/dev/null || echo 'No suggestion available at this time. Please try again later.')"
        return 1
    fi

    local message=$(cat /tmp/zsh_claude_suggestion)

    ##### Process response
    local first_char=${message:0:1}
    local suggestion=${message:1:${#message}}

    if [[ "$ZSH_CLAUDE_DEBUG" == 'true' ]]; then
        echo "{\"date\":\"$(date)\",\"log\":\"Suggestion extracted.\",\"input\":\"$input\",\"first_char\":\"$first_char\",\"suggestion\":\"$suggestion\"}" >> /tmp/zsh-claude.log
    fi

    ##### Show the suggestion to the user!
    if [[ "$first_char" == '=' ]]; then
        # Reset user input and insert new command
        BUFFER="$suggestion"
        CURSOR=${#BUFFER}
    elif [[ "$first_char" == '+' ]]; then
        # Append completion to current buffer
        if (( ${+functions[_zsh_autosuggest_suggest]} )); then
            _zsh_autosuggest_suggest "$suggestion"
        else
            # Fallback if zsh-autosuggestions not available
            BUFFER="${BUFFER}${suggestion}"
            CURSOR=${#BUFFER}
        fi
    else
        # If response doesn't have proper prefix, just append it
        BUFFER="${BUFFER}${message}"
        CURSOR=${#BUFFER}
    fi

    zle redisplay
}

function zsh-claude() {
    echo "ZSH Claude Code CLI is now active. Press $ZSH_CLAUDE_KEY to get suggestions."
    echo ""
    echo "Configurations:"
    echo "    - ZSH_CLAUDE_KEY: Key to press to get suggestions (default: ^z, value: $ZSH_CLAUDE_KEY)."
    echo "    - ZSH_CLAUDE_SEND_CONTEXT: If \`true\`, will send context information (whoami, shell, pwd, etc.) to Claude (default: true, value: $ZSH_CLAUDE_SEND_CONTEXT)."
    echo "    - ZSH_CLAUDE_SYSTEM_PROMPT: System prompt to use for the AI model (uses a built-in prompt by default)."
    echo "    - ZSH_CLAUDE_DEBUG: Enable debug logging to /tmp/zsh-claude.log (default: false, value: $ZSH_CLAUDE_DEBUG)."
    echo ""
    echo "Using Claude Haiku 4.5 model for fast, cost-effective shell completions."
}

zle -N _suggest_claude_ai
bindkey "$ZSH_CLAUDE_KEY" _suggest_claude_ai
