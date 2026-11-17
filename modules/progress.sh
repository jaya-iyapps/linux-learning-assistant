
#!/bin/bash

# Locate the project progress file
PROGRESS_MODULE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd -- "$PROGRESS_MODULE_DIR/.." && pwd)"
PROGRESS_FILE="$PROJECT_DIR/data/progress.txt"

# Main Progress Tracker
progress_mode() {

    local attempts=0
    local total_correct=0
    local total_questions=0
    local best_score=0
    local last_date="No records yet"
    local last_score=0
    local last_total=0
    local avg_percentage

    local record_type
    local timestamp
    local score
    local total

    echo
    echo "=========================================="
    echo "          MY LEARNING PROGRESS"
    echo "=========================================="

    # Check whether progress records exist
    if [[ ! -f "$PROGRESS_FILE" ]]; then

        echo
        echo "No quiz records found."
        echo "Attempt a quiz to start tracking progress!"
        echo "=========================================="
        return

    fi

    # Read quiz records
    while IFS='|' read -r record_type timestamp score total
    do

        # Process only valid quiz records
        [[ "$record_type" == "QUIZ" ]] || continue

        [[ "$score" =~ ^[0-9]+$ ]] || continue
        [[ "$total" =~ ^[1-9][0-9]*$ ]] || continue
        (( score <= total )) || continue

        ((attempts += 1))

        ((total_correct += score))
        ((total_questions += total))

        # Calculate best score percentage
        if (( score * 100 / total > best_score )); then
            best_score=$((score * 100 / total))
        fi

        last_date="$timestamp"
        last_score="$score"
        last_total="$total"

    done < "$PROGRESS_FILE"

    # Handle empty or invalid records
    if (( attempts == 0 )); then

        echo
        echo "No valid quiz records found."
        echo "=========================================="
        return

    fi

    # Calculate average percentage
    avg_percentage=$(awk -v correct="$total_correct" \
        -v total="$total_questions" \
        'BEGIN { printf "%.1f", (correct / total) * 100 }')

    # Display summary
    echo
    echo "TOTAL QUIZZES ATTEMPTED : $attempts"
    echo "TOTAL CORRECT ANSWERS  : $total_correct"
    echo "BEST SCORE             : $best_score%"
    echo "AVERAGE SCORE          : $avg_percentage%"
    echo "LATEST QUIZ SCORE      : $last_score / $last_total"
    echo "LAST ATTEMPT           : $last_date"

    # Display recent history
    echo
    echo "=========================================="
    echo "             RECENT QUIZZES"
    echo "=========================================="

    awk -F'|' '
        $1 == "QUIZ" &&
        $3 ~ /^[0-9]+$/ &&
        $4 ~ /^[1-9][0-9]*$/ {
            printf "%-22s %s/%s\n", $2, $3, $4
        }
    ' "$PROGRESS_FILE" | tail -n 5

    echo
    echo "=========================================="

    # Display learning feedback
    if (( best_score == 100 )); then
        echo "Excellent! You achieved a perfect score."
    elif (( best_score >= 60 )); then
        echo "Good progress! Keep practising."
    else
        echo "Keep learning. You can improve!"
    fi

    echo "=========================================="

}
