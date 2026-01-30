#!/usr/bin/env zsh

# Claude Code CLI integration for zsh
# Inspired by Myzel394/zsh-copilot but adapted for Claude Code CLI using Haiku 4.5

# Default key binding - Ctrl+Z
(( ! ${+ZSH_CLAUDE_KEY} )) &&
    typeset -g ZSH_CLAUDE_KEY='^z'

# Configuration options
# Context adds latency - disabled by default for speed
(( ! ${+ZSH_CLAUDE_SEND_CONTEXT} )) &&
    typeset -g ZSH_CLAUDE_SEND_CONTEXT=false

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
Complete shell commands or suggest new ones. Format:
- New command: prefix with = (e.g., '=ls')
- Completion: prefix with + (e.g., '+p')
Return ONLY the prefix + command/completion. No explanations, no newlines. Examples:
'list files' → '=ls'
'cd /tm' → '+p'
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
        # Simplified context - only essential info, using shell variables when possible
        context_info="Context: $(whoami) in $(pwd). $OSTYPE."
    fi

    ##### Get input
    rm -f /tmp/zsh_claude_suggestion /tmp/.zsh_claude_error
    local input=$(echo "${BUFFER:0:$CURSOR}" | tr '\n' ';')
    input=$(echo "$input" | sed 's/"/\\"/g')

    # Clear any existing autosuggestions
    if (( ${+functions[_zsh_autosuggest_clear]} )); then
        _zsh_autosuggest_clear
    fi

    # Combine system prompt and context (newline removal not needed with shorter prompt)
    local full_prompt="$ZSH_CLAUDE_SYSTEM_PROMPT $context_info"

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
