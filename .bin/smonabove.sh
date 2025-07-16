#!/bin/bash

#!/bin/bash

# Ensure jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: 'jq' is not installed. Please install it (e.g., sudo apt install jq)."
    exit 1
fi

# Get output information from Sway
outputs_json=$(swaymsg -t get_outputs)

# --- Define External Output Priority ---
# The script will only enable and position the FIRST one found from this list.
# Other connected external monitors will be ignored by this script.
declare -a external_priority=("DP-1" "DP-2" "HDMI-A-1")

# --- Initialize Variables ---
laptop_output_name="eDP-1"
first_active_external_name="" # To store the name of the first external monitor found

# --- Detect and Collect Info for the First Active External Output ---
echo "Detecting connected outputs and gathering their information..."

first_external_width=0
first_external_height=0
first_external_scale=1.0 # Default in case none are found

for output_name in "${external_priority[@]}"; do
    output_data=$(echo "$outputs_json" | jq -r --arg name "$output_name" '.[] | select(.name == $name)')

    if [[ -n "$output_data" ]]; then
        echo "Found active external output (priority): $output_name"
        first_active_external_name="$output_name"

        width=$(echo "$output_data" | jq -r '.current_mode.width')
        height=$(echo "$output_data" | jq -r '.current_mode.height')
        scale=$(echo "$output_data" | jq -r '.scale')

        # Calculate logical dimensions (resolution / scale)
        first_external_width=$((width / $(printf "%.0f" "$scale")))
        first_external_height=$((height / $(printf "%.0f" "$scale")))
        first_external_scale="$scale"

        break # Found the first priority external, no need to check others
    else
        echo "External output '$output_name' not detected."
    fi
done

# --- Get Info for the Laptop Screen (eDP-1) ---
laptop_width=0
laptop_height=0
laptop_scale=1.0

laptop_data=$(echo "$outputs_json" | jq -r --arg name "$laptop_output_name" '.[] | select(.name == $name)')
if [[ -n "$laptop_data" ]]; then
    echo "Found laptop output: $laptop_output_name"
    laptop_width=$(echo "$laptop_data" | jq -r '.current_mode.width')
    laptop_height=$(echo "$laptop_data" | jq -r '.current_mode.height')
    laptop_scale=$(echo "$laptop_data" | jq -r '.scale')

    # Calculate logical dimensions
    logical_laptop_width=$((laptop_width / $(printf "%.0f" "$laptop_scale")))
    logical_laptop_height=$((laptop_height / $(printf "%.0f" "$laptop_scale")))
else
    echo "Warning: Laptop output ($laptop_output_name) not detected. This script assumes it's always active."
    # If eDP-1 is truly not found, you might want to adjust behavior or exit.
    # For now, we'll proceed, but positioning will be off.
    logical_laptop_width=1920 # Fallback for calculations
    logical_laptop_height=1080 # Fallback
fi

# --- Apply Positions ---
echo "Applying monitor positions..."

# 1. Position the first active external monitor (if found)
if [[ -n "$first_active_external_name" ]]; then
    echo "Configuring $first_active_external_name: pos 0 0, scale $first_external_scale"
    swaymsg "output $first_active_external_name pos 0 0 scale $first_external_scale"
else
    echo "No external monitor found from the preferred list. Laptop will be at (0,0)."
    # If no external monitor is found, max_external_height remains 0
fi

# 2. Position the laptop screen (eDP-1) below the external monitor
# If no external monitor was found, laptop_pos_y will be 0.
laptop_pos_x=0 # Align left with the external monitor, or at 0 if no external
laptop_pos_y="$first_external_height" # Place directly below the external monitor (or 0 if no external)

# If you want to center the laptop under the external, adjust laptop_pos_x:
# laptop_pos_x=$(( (first_external_width / 2) - (logical_laptop_width / 2) ))
# if (( laptop_pos_x < 0 )); then laptop_pos_x=0; fi # Ensure it doesn't go off-screen

echo "Configuring $laptop_output_name: pos $laptop_pos_x $laptop_pos_y, scale $laptop_scale"
swaymsg "output $laptop_output_name pos $laptop_pos_x $laptop_pos_y scale $laptop_scale"


echo "Monitor configuration complete."
exit 0


# Get output information
outputs_json=$(swaymsg -t get_outputs)

# Parse output (using jq for JSON parsing - install if you don't have it)
laptop_output=$(echo "$outputs_json" | jq -r '.[] | select(.name == "eDP-1")')
external_output=$(echo "$outputs_json" | jq -r '.[] | select(.name == "HDMI-A-1")')

# Extract dimensions and scale
laptop_width=$(echo "$laptop_output" | jq -r '.current_mode.width')
laptop_height=$(echo "$laptop_output" | jq -r '.current_mode.height')
laptop_scale=$(echo "$laptop_output" | jq -r '.scale')

external_width=$(echo "$external_output" | jq -r '.current_mode.width')
external_height=$(echo "$external_output" | jq -r '.current_mode.height')
external_scale=$(echo "$external_output" | jq -r '.scale')

# Calculate logical dimensions (resolution / scale)
logical_laptop_width=$((laptop_width / $(printf "%.0f" "$laptop_scale")))
logical_laptop_height=$((laptop_height / $(printf "%.0f" "$laptop_scale")))

logical_external_width=$((external_width / $(printf "%.0f" "$external_scale")))
logical_external_height=$((external_height / $(printf "%.0f" "$external_scale")))

# Define positions
# External monitor is at (0,0)
external_x=0
external_y=0

# Laptop monitor is to the right of external, aligned at the top (y=0)
laptop_x=0
laptop_y=$logical_external_height

# Send commands to Sway
swaymsg "output HDMI-A-1 pos $external_x $external_y"
swaymsg "output eDP-1 pos $laptop_x $laptop_y"

# Optional: You can also set preferred modes and scaling here
# swaymsg "output HDMI-A-1 mode 1920x1080@60Hz scale 1"
# swaymsg "output eDP-1 mode 1920x1080@60Hz scale 1.25" # Example with scaling
