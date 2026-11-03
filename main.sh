#!/bin/bash

# ==========================================
# INTERACTIVE LINUX COMMAND LEARNING ASSISTANT
# Main Application
# ==========================================

# Get the directory where this script is located
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Load all application modules
for module in "$SCRIPT_DIR"/modules/*.sh
do
    if [[ -f "$module" ]]; then
        source "$module"
    fi
done

# Display application heading
show_banner() {
    echo "=============================================="
    echo "       LINUX COMMAND LEARNING ASSISTANT"
    echo "=============================================="
    echo "          Learn Linux. Practise Linux."
    echo "=============================================="
}

# Display main menu
show_menu() {
    echo
    echo "1. Beginner Mode"
    echo "2. Challenge Mode"
    echo "3. Safe Practice Mode"
    echo "4. Quiz Mode"
    echo "5. My Learning Progress"
    echo "6. Search Commands"
    echo "7. Exit"
    echo
}

# Wait before returning to the menu
pause() {
    echo
    read -r -p "Press Enter to continue..."
}

# Open the selected module when it is implemented
run_module() {
    local module_name="$1"

    if declare -F "$module_name" > /dev/null; then
        "$module_name"
    else
        echo
        echo "This module is currently under development."
    fi
}

# Main application function
main() {

    local choice

    while true
    do
        show_banner
        show_menu

        read -r -p "Enter your choice: " choice

        case "$choice" in

            1)
                run_module beginner_mode
                ;;

            2)
                run_module challenge_mode
                ;;

            3)
                run_module practice_mode
                ;;

            4)
                run_module quiz_mode
                ;;

            5)
                run_module progress_mode
                ;;

            6)
                run_module search_mode
                ;;

            7)
                echo
                echo "Thank you for using Linux Command Learning Assistant!"
                echo "Keep learning Linux!"
                break
                ;;

            *)
                echo
                echo "Invalid choice! Please enter a number between 1 and 7."
                ;;

        esac

        if [[ "$choice" != "7" ]]; then
            pause
        fi

    done
}

# Start the application
main
