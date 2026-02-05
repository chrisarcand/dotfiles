#!/usr/bin/env bash

# Pure bash implementation of ccstatusline
# Reads Claude Code status from stdin and formats it

# Bedrock Pricing (as of 1/29/26) - per 1M tokens:
# +------------------------------+-------------------------+----------------------------------+----------------------------------+
# | Model Name                   | Bedrock Cost (1M Tok)   | Role                             | Best Use Case                    |
# +------------------------------+-------------------------+----------------------------------+----------------------------------+
# | Claude Opus 4.5              | In: $5.00 | Out: $25.00 | Powerhouse (Deepest Thinker)     | "Bet the company" decisions,     |
# |                              |                         |                                  | research, complex architecture.  |
# +------------------------------+-------------------------+----------------------------------+----------------------------------+
# | Claude Sonnet 4.5            | In: $3.00 | Out: $15.00 | Workhorse (Standard Default)     | Daily coding, production apps,   |
# |                              |                         |                                  | general reasoning & writing.     |
# +------------------------------+-------------------------+----------------------------------+----------------------------------+
# | Claude Haiku 4.5             | In: $1.00 | Out: $5.00  | Speedster (Fast & Cheap)         | High volume tasks, simple logic, |
# |                              |                         |                                  | extraction, autocomplete.        |
# +------------------------------+-------------------------+----------------------------------+----------------------------------+
# | *Thinking Mode* (Any Model)  | Same rates per 1M       | Enhanced Logic                   | Hard math/bugs.                  |
# |                              | (Pays as Output tokens) |                                  | WARNING: Burns 2x-5x more tokens |
# +------------------------------+-------------------------+----------------------------------+----------------------------------+

# ANSI color codes
ORANGE='\033[38;5;208m'      # Orange for model name
CYAN='\033[96m'              # Bright cyan for window context
BOLD_CYAN='\033[1;96m'       # Bold cyan for output numbers
GREEN='\033[92m'             # Green for session totals
YELLOW='\033[93m'            # Yellow for cache numbers
BOLD_YELLOW='\033[1;93m'     # Bold yellow for cache read (↓)
BOLD_LIGHT_BLUE='\033[1;96m' # Bold light cyan for cost (bold + bright cyan)
DIM_GRAY='\033[38;5;245m'    # Dim gray for directory (more visible than bright black)
WHITE='\033[97m'
BOLD_WHITE='\033[1;97m'      # Bold white for output numbers
RESET='\033[0m'

# Progress bar colors (for context window usage)
BAR_GREEN='\033[38;5;46m'      # Bright green (low usage)
BAR_LIME='\033[38;5;82m'       # Lime green
BAR_YELLOW='\033[38;5;226m'    # Yellow
BAR_ORANGE='\033[38;5;208m'    # Orange
BAR_RED='\033[38;5;196m'       # Bright red (high usage)

# Read JSON from stdin once
STATUS=$(cat)

# Extract values using jq - output as bash variable assignments for speed
eval "$(echo "$STATUS" | jq -r '@sh "
MODEL=\(.model.display_name // "Unknown")
MODEL_ID=\(.model.id // "")
CONTEXT_SIZE=\(.context_window.context_window_size // 0)
REMAINING_PCT=\(.context_window.remaining_percentage // 0)
USED_PCT=\(.context_window.used_percentage // 0)
CURRENT_INPUT=\(if .context_window.current_usage then .context_window.current_usage.input_tokens else 0 end)
CURRENT_OUTPUT=\(if .context_window.current_usage then .context_window.current_usage.output_tokens else 0 end)
CACHE_CREATED=\(if .context_window.current_usage then .context_window.current_usage.cache_creation_input_tokens else 0 end)
CACHE_READ=\(if .context_window.current_usage then .context_window.current_usage.cache_read_input_tokens else 0 end)
TOTAL_INPUT=\(.context_window.total_input_tokens // 0)
TOTAL_OUTPUT=\(.context_window.total_output_tokens // 0)
CWD=\(.workspace.current_dir // "")
"')"

# Append "(Bedrock)" if model ID indicates Bedrock usage
# Bedrock IDs contain "anthropic." (e.g., "global.anthropic.claude-..." or "anthropic.claude-...")
[[ "$MODEL_ID" == *"anthropic."* ]] && MODEL="${MODEL} (Bedrock)"

# Determine pricing and calculate cost in a single awk call for performance
TOTAL_COST=$(awk -v model_id="$MODEL_ID" -v total_in="$TOTAL_INPUT" -v total_out="$TOTAL_OUTPUT" 'BEGIN {
    # Determine pricing based on model
    if (index(model_id, "opus") > 0) {
        input_price = 5.00
        output_price = 25.00
    } else if (index(model_id, "sonnet") > 0) {
        input_price = 3.00
        output_price = 15.00
    } else if (index(model_id, "haiku") > 0) {
        input_price = 1.00
        output_price = 5.00
    } else {
        input_price = 3.00
        output_price = 15.00
    }

    # Calculate total cost
    input_cost = (total_in / 1000000.0) * input_price
    output_cost = (total_out / 1000000.0) * output_price
    printf "%.2f", input_cost + output_cost
}')

# Format used percentage (use bash printf instead of external command)
USED_DISPLAY=$(printf "%.0f%%" "${USED_PCT}")

# Inline number formatting functions for performance
# Format with commas: 1234567 -> 1,234,567
format_number() {
    printf "%'d" "$1" 2>/dev/null || echo "$1"
}

# Format large numbers: 200000 -> 200k, 1000000 -> 1M
format_large_number() {
    local num=$1
    if [ "$num" -ge 1000000 ]; then
        echo "$((num / 1000000))M"
    elif [ "$num" -ge 1000 ]; then
        echo "$((num / 1000))k"
    else
        echo "$num"
    fi
}

# Generate colored bar and get color (combined for efficiency)
# Calculates once, outputs both bar and color
# Convert percentage to integer (handle decimals and empty values)
if [[ "$USED_PCT" == *.* ]]; then
    USED_PCT_INT=${USED_PCT%.*}  # Strip decimal part
else
    USED_PCT_INT=$USED_PCT
fi
USED_PCT_INT=${USED_PCT_INT:-0}  # Default to 0 if empty

# Determine color based on usage
if [ "$USED_PCT_INT" -lt 30 ]; then
    USAGE_COLOR="$BAR_GREEN"
elif [ "$USED_PCT_INT" -lt 50 ]; then
    USAGE_COLOR="$BAR_LIME"
elif [ "$USED_PCT_INT" -lt 70 ]; then
    USAGE_COLOR="$BAR_YELLOW"
elif [ "$USED_PCT_INT" -lt 85 ]; then
    USAGE_COLOR="$BAR_ORANGE"
else
    USAGE_COLOR="$BAR_RED"
fi

# Build bar (avoid awk, use bash arithmetic)
BAR_WIDTH=10
FILLED=$(( (USED_PCT_INT * BAR_WIDTH) / 100 ))
BAR_CONTENT=""
for ((i=0; i<BAR_WIDTH; i++)); do
    if [ "$i" -lt "$FILLED" ]; then
        BAR_CONTENT="${BAR_CONTENT}▰"
    else
        BAR_CONTENT="${BAR_CONTENT}▱"
    fi
done
USAGE_BAR="${USAGE_COLOR}${BAR_CONTENT}${RESET} "

# Format all numbers at once
CONTEXT_SIZE_FMT=$(format_large_number "$CONTEXT_SIZE")
CURRENT_IN_FMT=$(format_number "$CURRENT_INPUT")
CURRENT_OUT_FMT=$(format_number "$CURRENT_OUTPUT")
CACHE_CREATED_FMT=$(format_number "$CACHE_CREATED")
CACHE_READ_FMT=$(format_number "$CACHE_READ")
TOTAL_IN_FMT=$(format_number "$TOTAL_INPUT")
TOTAL_OUT_FMT=$(format_number "$TOTAL_OUTPUT")

# Build status line (3 lines)
# Line 1: Model • window size • usage % with bar • (path)
LINE1="${ORANGE}${MODEL}${RESET} • ${DIM_GRAY}${CONTEXT_SIZE_FMT} window${RESET} • ${USAGE_COLOR}${USED_DISPLAY} used${RESET} ${USAGE_BAR} • ${DIM_GRAY}${CWD}${RESET}"

# Line 2: Last turn metrics
LINE2="${CYAN}Turn:${RESET} ${CYAN}↑ ${CURRENT_IN_FMT}${RESET} ${BOLD_CYAN}↓ ${CURRENT_OUT_FMT}${RESET} • ${YELLOW}Cache:${RESET} ${YELLOW}↑ ${CACHE_CREATED_FMT}${RESET} ${BOLD_YELLOW}↓ ${CACHE_READ_FMT}${RESET}"

# Line 3: Session totals with cost estimate
LINE3="${WHITE}Session:${RESET} ${WHITE}↑ ${TOTAL_IN_FMT}${RESET} ${BOLD_WHITE}↓ ${TOTAL_OUT_FMT}${RESET} • ${BOLD_LIGHT_BLUE}~\$${TOTAL_COST}${RESET}"

# Output with newlines
echo -e "$LINE1"
echo -e "$LINE2"
echo -e "$LINE3"
