#!/bin/bash
# Check if at least the target workspace and a command were provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <TARGET_WORKSPACE> <COMMAND> [ARG1] [ARG2]..."
    echo "Example 1 (Single command): $0 5 alacritty"
    echo "Example 2 (Command with args): $0 Web 'firefox --private-window'"
    exit 1
fi

TARGET_WORKSPACE="$1"
COMMAND_TO_RUN="${@:2}"

ORIGINAL_WORKSPACE=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused) | .name')

# Safety check
if [ -z "$ORIGINAL_WORKSPACE" ]; then
    echo "Error: Could not determine the current workspace. Aborting."
    exit 1
fi

echo "Running: $COMMAND_TO_RUN in $TARGET_WORKSPACE"
swaymsg "workspace $TARGET_WORKSPACE"

sway-on-new-window &
WAITER_PID=$!

sleep 0.1

echo "Running command.."
$COMMAND_TO_RUN &
PID=$!

cleanup() {
    kill -SIGTERM $PID
}

trap cleanup EXIT TERM INT

echo "WAITING m1..."
wait $WAITER_PID
echo "Swithcing back to $ORIGINAL_WORKSPACE"
swaymsg "workspace \"$ORIGINAL_WORKSPACE\""

wait $PID
