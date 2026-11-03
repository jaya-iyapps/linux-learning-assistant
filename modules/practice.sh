
#!/bin/bash

# Locate the project's practice workspace
PRACTICE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../workspace" && pwd)"

# Validate filenames to prevent directory traversal
valid_filename() {
    [[ "$1" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]]
}

# Display practice workspace location
show_workspace() {
    echo
    echo "PRACTICE WORKSPACE"
    echo "------------------------------"
    echo "$PRACTICE_DIR"
}

# List files in workspace
list_files() {
    echo
    echo "FILES IN PRACTICE WORKSPACE"
    echo "------------------------------"
    ls -lah -- "$PRACTICE_DIR"
}

# Create a directory
create_directory() {
    local name

    read -r -p "Enter directory name: " name

    if ! valid_filename "$name"; then
        echo "Invalid directory name!"
        return
    fi

    if [[ -e "$PRACTICE_DIR/$name" || -L "$PRACTICE_DIR/$name" ]]; then
        echo "A file or directory with this name already exists."
        return
    fi

    if mkdir -- "$PRACTICE_DIR/$name"; then
        echo "Directory created successfully!"
    else
        echo "Unable to create directory."
    fi
}

# Create a text file
create_file() {
    local name
    local content

    read -r -p "Enter file name: " name

    if ! valid_filename "$name"; then
        echo "Invalid file name!"
        return
    fi

    if [[ -e "$PRACTICE_DIR/$name" || -L "$PRACTICE_DIR/$name" ]]; then
        echo "A file or directory with this name already exists."
        return
    fi

    read -r -p "Enter some text: " content

    if printf '%s\n' "$content" > "$PRACTICE_DIR/$name"; then
        echo "File created successfully!"
    else
        echo "Unable to create file."
    fi
}

# Display file contents
view_file() {
    local name
    local filepath

    read -r -p "Enter file name: " name

    if ! valid_filename "$name"; then
        echo "Invalid file name!"
        return
    fi

    filepath="$PRACTICE_DIR/$name"

    if [[ -f "$filepath" && ! -L "$filepath" ]]; then
        echo
        echo "FILE CONTENTS"
        echo "------------------------------"
        cat -- "$filepath"
    else
        echo "File not found or not a regular file!"
    fi
}

# Search for text inside a file
search_file() {
    local name
    local pattern
    local filepath

    read -r -p "Enter file name: " name

    if ! valid_filename "$name"; then
        echo "Invalid file name!"
        return
    fi

    filepath="$PRACTICE_DIR/$name"

    if [[ ! -f "$filepath" || -L "$filepath" ]]; then
        echo "File not found or not a regular file!"
        return
    fi

    read -r -p "Enter text to search: " pattern

    if [[ -z "$pattern" ]]; then
        echo "Search text cannot be empty."
        return
    fi

    echo
    echo "SEARCH RESULTS"
    echo "------------------------------"

    if grep -Fni -- "$pattern" "$filepath"; then
        echo "Search completed."
    else
        echo "No matching text found."
    fi
}

# Display basic system information
system_information() {
    echo
    echo "SYSTEM INFORMATION"
    echo "------------------------------"

    echo "Current User:"
    whoami

    echo
    echo "Current Date:"
    date

    echo
    echo "Kernel Information:"
    uname -srm

    echo
    echo "Disk Information:"
    df -h "$PRACTICE_DIR"
}

# Main Safe Practice Mode
practice_mode() {
    local choice

    mkdir -p "$PRACTICE_DIR"

    while true
    do
        echo
        echo "=========================================="
        echo "             SAFE PRACTICE MODE"
        echo "=========================================="
        echo "1. Show Practice Directory"
        echo "2. List Files"
        echo "3. Create Directory"
        echo "4. Create Text File"
        echo "5. View File Contents"
        echo "6. Search Inside a File"
        echo "7. System Information"
        echo "0. Return to Main Menu"
        echo "=========================================="
        echo

        read -r -p "Enter your choice: " choice

        case "$choice" in
            1) show_workspace ;;
            2) list_files ;;
            3) create_directory ;;
            4) create_file ;;
            5) view_file ;;
            6) search_file ;;
            7) system_information ;;
            0) return ;;
            *) echo "Invalid choice! Please try again." ;;
        esac

        echo
        read -r -p "Press Enter to continue..."
    done
}
