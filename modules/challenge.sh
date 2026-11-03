
#!/bin/bash

# Normalize commands for answer comparison
normalize_command() {

    local value="${1,,}"

    # Ignore quotation marks
    value="$(printf '%s' "$value" | tr -d "\"'")"

    # Normalize extra spaces
    local -a parts
    read -r -a parts <<< "$value"

    printf '%s' "${parts[*]}"
}

# Ask a multiple-choice question
ask_mcq() {

    local question="$1"
    local option1="$2"
    local option2="$3"
    local option3="$4"
    local option4="$5"
    local correct="$6"
    local explanation="$7"
    local answer

    echo
    echo "------------------------------------------"
    echo "$question"
    echo "------------------------------------------"
    echo "A. $option1"
    echo "B. $option2"
    echo "C. $option3"
    echo "D. $option4"
    echo

    read -r -p "Enter your answer (A/B/C/D): " answer

    answer="${answer,,}"

    if [[ "$answer" == "$correct" ]]; then
        echo
        echo "Correct answer!"
        echo "Explanation: $explanation"
        return 0
    else
        echo
        echo "Incorrect answer!"
        echo "Correct answer: ${correct^^}"
        echo "Explanation: $explanation"
        return 1
    fi
}

# Ask the user to type a complete command
ask_typed() {

    local question="$1"
    local expected="$2"
    local explanation="$3"
    local answer
    local normalized_answer
    local normalized_expected

    echo
    echo "------------------------------------------"
    echo "TYPING CHALLENGE"
    echo "------------------------------------------"
    echo "$question"
    echo

    read -r -p "Enter the complete command: " answer

    normalized_answer="$(normalize_command "$answer")"
    normalized_expected="$(normalize_command "$expected")"

    if [[ "$normalized_answer" == "$normalized_expected" ]]; then
        echo
        echo "Correct command!"
        echo "Explanation: $explanation"
        return 0
    else
        echo
        echo "Incorrect command!"
        echo "Expected: $expected"
        echo "Explanation: $explanation"
        return 1
    fi
}

# Display final score
show_results() {

    local score="$1"
    local total=5

    echo
    echo "=========================================="
    echo "             CHALLENGE RESULTS"
    echo "=========================================="
    echo "Total questions : $total"
    echo "Correct answers : $score"
    echo "Incorrect       : $((total - score))"
    echo "Final score     : $score / $total"

    if (( score == total )); then
        echo "Excellent! Perfect score!"
    elif (( score >= 3 )); then
        echo "Good work! Keep practising."
    else
        echo "Keep learning. You can improve!"
    fi

    echo "=========================================="
}

# MCQ Challenge Mode
mcq_mode() {

    local score=0

    echo
    echo "=========================================="
    echo "          MCQ - IDENTIFY THE COMMAND"
    echo "=========================================="
    echo "Select the correct Linux command."
    echo

    read -r -p "Press Enter to start..."

    if ask_mcq \
        "Which command displays the current working directory?" \
        "ls" "pwd" "cd" "mkdir" \
        "b" "pwd displays the present working directory."; then
        ((score += 1))
    fi

    if ask_mcq \
        "Which command lists files and directories?" \
        "touch" "ls" "cat" "pwd" \
        "b" "ls lists files and directories."; then
        ((score += 1))
    fi

    if ask_mcq \
        "Which command creates a new directory?" \
        "cp" "mv" "mkdir" "rm" \
        "c" "mkdir creates directories."; then
        ((score += 1))
    fi

    if ask_mcq \
        "Which command displays the current username?" \
        "whoami" "uname" "hostname" "date" \
        "a" "whoami displays the current username."; then
        ((score += 1))
    fi

    if ask_mcq \
        "Which command searches for text inside a file?" \
        "sort" "wc" "head" "grep" \
        "d" "grep searches for matching text in files."; then
        ((score += 1))
    fi

    show_results "$score"
}

# Typing Challenge Mode
typing_mode() {

    local score=0

    echo
    echo "=========================================="
    echo "          TYPE THE COMPLETE COMMAND"
    echo "=========================================="
    echo "Write the complete Linux command."
    echo

    read -r -p "Press Enter to start..."

    if ask_typed \
        "Which command displays your current working directory?" \
        "pwd" \
        "pwd displays your current working directory."; then
        ((score += 1))
    fi

    if ask_typed \
        "Write a command to display hidden files using ls." \
        "ls -a" \
        "The -a option displays hidden files."; then
        ((score += 1))
    fi

    if ask_typed \
        "Create a directory named practice." \
        "mkdir practice" \
        "mkdir creates a directory with the given name."; then
        ((score += 1))
    fi

    if ask_typed \
        "Count the number of lines in notes.txt." \
        "wc -l notes.txt" \
        "The -l option of wc counts lines."; then
        ((score += 1))
    fi

    if ask_typed \
        "Search for the word ERROR in system.log." \
        'grep "ERROR" system.log' \
        "grep searches for matching text inside a file."; then
        ((score += 1))
    fi

    show_results "$score"
}

# Main Challenge Mode menu
challenge_mode() {

    local choice

    while true
    do
        echo
        echo "=========================================="
        echo "              CHALLENGE MODE"
        echo "=========================================="
        echo "1. MCQ - Identify the Command"
        echo "2. Typing - Write the Command"
        echo "0. Return to Main Menu"
        echo "=========================================="
        echo

        read -r -p "Enter your choice: " choice

        case "$choice" in

            1) mcq_mode ;;

            2) typing_mode ;;

            0)
                return
                ;;

            *)
                echo "Invalid choice! Please try again."
                ;;

        esac

    done
}
