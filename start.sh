#!/bin/bash

# Get the current filepath
current_filepath=$(pwd)

# Define the paths to the scripts
install_script="$current_filepath/install.sh"
update_script="$current_filepath/update.sh"

# Function to apply execute permissions and execute a script
apply_permissions_and_execute() {
    local script_path=$1
    if [ -f "$script_path" ]; then
        chmod +x "$script_path"
        echo "chmod +x applied to $script_path in the current working directory."
        echo "Executing $script_path..."
        /bin/bash "$script_path"
    else
        echo "Error: $script_path not found in the current working directory."
    fi
}

# Apply execute permissions to install.sh and update.sh
apply_permissions_and_execute "$install_script"
apply_permissions_and_execute "$update_script"
