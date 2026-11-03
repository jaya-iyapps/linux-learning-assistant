
#!/bin/bash

# Display information about a Linux command
show_command() {

    local cmd="$1"
    local description="$2"
    local syntax="$3"
    local example="$4"

    echo
    echo "=========================================="
    echo "COMMAND: $cmd"
    echo "=========================================="
    echo
    echo "DESCRIPTION:"
    echo "$description"
    echo
    echo "SYNTAX:"
    echo "$syntax"
    echo
    echo "EXAMPLE:"
    echo "$example"
    echo
    read -r -p "Press Enter to continue..."

}

# Category 1: File and Directory Management
file_commands() {

    while true
    do
        echo
        echo "====== FILE AND DIRECTORY MANAGEMENT ======"
        echo "1. pwd"
        echo "2. ls"
        echo "3. cd"
        echo "4. mkdir"
        echo "5. touch"
        echo "6. cp"
        echo "7. mv"
        echo "0. Back"
        echo

        read -r -p "Select a command: " choice

        case "$choice" in
            1) show_command "pwd" \
                "Displays the current working directory." \
                "pwd" "pwd" ;;

            2) show_command "ls" \
                "Lists files and directories." \
                "ls [options] [directory]" "ls -l" ;;

            3) show_command "cd" \
                "Changes the current directory." \
                "cd [directory]" "cd ~/Documents" ;;

            4) show_command "mkdir" \
                "Creates a new directory." \
                "mkdir [directory_name]" "mkdir practice_folder" ;;

            5) show_command "touch" \
                "Creates an empty file." \
                "touch [file_name]" "touch notes.txt" ;;

            6) show_command "cp" \
                "Copies files or directories." \
                "cp [source] [destination]" \
                "cp notes.txt backup.txt" ;;

            7) show_command "mv" \
                "Moves or renames files and directories." \
                "mv [source] [destination]" \
                "mv old.txt new.txt" ;;

            0) return ;;

            *) echo "Invalid choice!" ;;
        esac
    done
}

# Category 2: File Viewing
view_commands() {

    while true
    do
        echo
        echo "=========== FILE VIEWING ==========="
        echo "1. cat"
        echo "2. head"
        echo "3. tail"
        echo "4. less"
        echo "0. Back"
        echo

        read -r -p "Select a command: " choice

        case "$choice" in
            1) show_command "cat" \
                "Displays the contents of a file." \
                "cat [file_name]" "cat notes.txt" ;;

            2) show_command "head" \
                "Displays the first lines of a file." \
                "head [options] [file_name]" \
                "head -n 5 notes.txt" ;;

            3) show_command "tail" \
                "Displays the last lines of a file." \
                "tail [options] [file_name]" \
                "tail -n 5 notes.txt" ;;

            4) show_command "less" \
                "Displays file contents one screen at a time." \
                "less [file_name]" "less notes.txt" ;;

            0) return ;;

            *) echo "Invalid choice!" ;;
        esac
    done
}

# Category 3: System Information
system_commands() {

    while true
    do
        echo
        echo "=========== SYSTEM INFORMATION ==========="
        echo "1. uname"
        echo "2. date"
        echo "3. uptime"
        echo "4. df"
        echo "5. free"
        echo "0. Back"
        echo

        read -r -p "Select a command: " choice

        case "$choice" in
            1) show_command "uname" \
                "Displays system and kernel information." \
                "uname [options]" "uname -a" ;;

            2) show_command "date" \
                "Displays the current date and time." \
                "date [options]" "date" ;;

            3) show_command "uptime" \
                "Displays how long the system has been running." \
                "uptime" "uptime" ;;

            4) show_command "df" \
                "Displays filesystem disk space usage." \
                "df [options]" "df -h" ;;

            5) show_command "free" \
                "Displays memory usage." \
                "free [options]" "free -h" ;;

            0) return ;;

            *) echo "Invalid choice!" ;;
        esac
    done
}

# Category 4: User Information
user_commands() {

    while true
    do
        echo
        echo "=========== USER INFORMATION ==========="
        echo "1. whoami"
        echo "2. id"
        echo "3. hostname"
        echo "0. Back"
        echo

        read -r -p "Select a command: " choice

        case "$choice" in
            1) show_command "whoami" \
                "Displays the current username." \
                "whoami" "whoami" ;;

            2) show_command "id" \
                "Displays user and group identification." \
                "id [username]" "id" ;;

            3) show_command "hostname" \
                "Displays the system hostname." \
                "hostname" "hostname" ;;

            0) return ;;

            *) echo "Invalid choice!" ;;
        esac
    done
}

# Category 5: Searching and Filtering
search_commands() {

    while true
    do
        echo
        echo "=========== SEARCHING AND FILTERING ==========="
        echo "1. grep"
        echo "2. find"
        echo "3. sort"
        echo "4. wc"
        echo "0. Back"
        echo

        read -r -p "Select a command: " choice

        case "$choice" in
            1) show_command "grep" \
                "Searches for a pattern inside files." \
                "grep [pattern] [file_name]" \
                'grep "hello" notes.txt' ;;

            2) show_command "find" \
                "Searches for files and directories." \
                "find [path] [options]" \
                'find . -name "notes.txt"' ;;

            3) show_command "sort" \
                "Sorts lines in a file." \
                "sort [file_name]" "sort names.txt" ;;

            4) show_command "wc" \
                "Counts lines, words and characters." \
                "wc [options] [file_name]" \
                "wc -l notes.txt" ;;

            0) return ;;

            *) echo "Invalid choice!" ;;
        esac
    done
}

# Category 6: Process Management
process_commands() {

    while true
    do
        echo
        echo "=========== PROCESS MANAGEMENT ==========="
        echo "1. ps"
        echo "2. top"
        echo "3. pgrep"
        echo "4. kill"
        echo "0. Back"
        echo

        read -r -p "Select a command: " choice

        case "$choice" in
            1) show_command "ps" \
                "Displays information about running processes." \
                "ps [options]" "ps aux" ;;

            2) show_command "top" \
                "Displays live system process information." \
                "top" "top" ;;

            3) show_command "pgrep" \
                "Finds process IDs using a process name." \
                "pgrep [process_name]" "pgrep bash" ;;

            4) show_command "kill" \
                "Sends a signal to a process." \
                "kill [PID]" "kill 1234" ;;

            0) return ;;

            *) echo "Invalid choice!" ;;
        esac
    done
}

# Main Beginner Mode
beginner_mode() {

    local choice

    while true
    do
        echo
        echo "=========================================="
        echo "              BEGINNER MODE"
        echo "=========================================="
        echo "1. File and Directory Management"
        echo "2. File Viewing"
        echo "3. System Information"
        echo "4. User Information"
        echo "5. Searching and Filtering"
        echo "6. Process Management"
        echo "0. Return to Main Menu"
        echo

        read -r -p "Enter your choice: " choice

        case "$choice" in
            1) file_commands ;;
            2) view_commands ;;
            3) system_commands ;;
            4) user_commands ;;
            5) search_commands ;;
            6) process_commands ;;
            0) return ;;
            *) echo "Invalid choice! Please try again." ;;
        esac
    done
}

