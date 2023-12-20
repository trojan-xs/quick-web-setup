#!/bin/bash

# Get the current filepath
current_filepath=$(pwd)

# Define the paths to the scripts
install_script="$current_filepath/install.sh"
update_script="$current_filepath/update.sh"

# Function to apply execute permissions to a script
apply_execute_permissions() {
    local script_path=$1
    if [ -f "$script_path" ]; then
        chmod +x "$script_path"
        echo "chmod +x applied to $script_path in the current working directory."
    else
        echo "Error: $script_path not found in the current working directory."
    fi
}

# Apply execute permissions to both install.sh and update.sh
apply_execute_permissions "$install_script"
apply_execute_permissions "$update_script"

# Execute update.sh
if [ -f "$update_script" ]; then
    echo "Executing $update_script..."
    /bin/bash "$update_script"
else
    echo "Error: $update_script not found in the current working directory."
fi
