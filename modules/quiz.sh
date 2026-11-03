
#!/bin/bash

# Locate project files
QUIZ_MODULE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd -- "$QUIZ_MODULE_DIR/.." && pwd)"

QUESTIONS_FILE="$PROJECT_DIR/data/questions.txt"
PROGRESS_FILE="$PROJECT_DIR/data/progress.txt"

# Display and check one quiz question
ask_quiz_question() {

    local number="$1"
    local line="$2"

    local question
    local option_a
    local option_b
    local option_c
    local option_d
    local correct
    local explanation
    local answer

    IFS='|' read -r question option_a option_b option_c option_d correct explanation <<< "$line"

    correct="${correct^^}"

    echo
    echo "=========================================="
    echo "QUESTION $number"
    echo "=========================================="
    echo "$question"
    echo
    echo "A. $option_a"
    echo "B. $option_b"
    echo "C. $option_c"
    echo "D. $option_d"
    echo

    # Accept only valid option letters
    while true
    do
        read -r -p "Your answer (A/B/C/D): " answer
        answer="${answer^^}"

        case "$answer" in
            A|B|C|D)
                break
                ;;
            *)
                echo "Invalid choice! Enter A, B, C or D."
                ;;
        esac
    done

    if [[ "$answer" == "$correct" ]]; then
        echo
        echo "Correct answer!"
        echo "Explanation: $explanation"
        return 0
    else
        echo
        echo "Incorrect answer!"
        echo "Correct answer: $correct. $(case "$correct" in
            A) printf '%s' "$option_a" ;;
            B) printf '%s' "$option_b" ;;
            C) printf '%s' "$option_c" ;;
            D) printf '%s' "$option_d" ;;
        esac)"
        echo "Explanation: $explanation"
        return 1
    fi
}

# Main Quiz Mode
quiz_mode() {

    local score=0
    local total=5
    local number=1
    local line

    local -a all_questions
    local -a selected_questions

    echo
    echo "=========================================="
    echo "                 QUIZ MODE"
    echo "=========================================="
    echo "Test your Linux knowledge!"
    echo "Number of questions: $total"
    echo

    # Check question bank
    if [[ ! -f "$QUESTIONS_FILE" ]]; then
        echo "Question bank not found!"
        return 1
    fi

    # Load non-empty, non-comment question lines
    mapfile -t all_questions < <(
        grep -vE '^[[:space:]]*(#|$)' "$QUESTIONS_FILE"
    )

    if (( ${#all_questions[@]} < total )); then
        echo "Not enough questions in the question bank."
        return 1
    fi

    # Check randomization utility
    if ! command -v shuf > /dev/null 2>&1; then
        echo "The shuf command is not available."
        return 1
    fi

    # Randomly select five different questions
    mapfile -t selected_questions < <(
        printf '%s\n' "${all_questions[@]}" | shuf -n "$total"
    )

    echo "Five random questions have been selected."
    read -r -p "Press Enter to begin..."

    # Ask all selected questions
    for line in "${selected_questions[@]}"
    do
        if ask_quiz_question "$number" "$line"; then
            ((score += 1))
        fi

        ((number += 1))
    done

    # Display final results
    echo
    echo "=========================================="
    echo "               QUIZ RESULTS"
    echo "=========================================="
    echo "Total questions : $total"
    echo "Correct answers : $score"
    echo "Incorrect       : $((total - score))"
    echo "Final score     : $score / $total"

    if (( score == total )); then
        echo "Excellent! Perfect score!"
    elif (( score >= 3 )); then
        echo "Good job! Keep practising."
    else
        echo "Keep learning. You can improve!"
    fi

    echo "=========================================="

    # Save quiz result for the Progress Tracker
    mkdir -p "$PROJECT_DIR/data"

    if printf 'QUIZ|%s|%s|%s\n' \
        "$(date '+%Y-%m-%d %H:%M:%S')" \
        "$score" "$total" >> "$PROGRESS_FILE"; then

        echo
        echo "Quiz result saved successfully!"
    else
        echo
        echo "Warning: Unable to save quiz result."
    fi
}
