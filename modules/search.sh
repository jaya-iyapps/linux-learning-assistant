
#!/bin/bash

# Locate the command library
SEARCH_MODULE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd -- "$SEARCH_MODULE_DIR/.." && pwd)"

COMMANDS_FILE="$PROJECT_DIR/data/commands.txt"

# Convert text into searchable words
normalize_search_text() {

    local text="${1,,}"

    # Replace punctuation with spaces
    text="${text//[^a-z0-9]/ }"

    printf '%s\n' "$text"
}

# Search the command library
search_commands() {

    local query="$1"
    local normalized_query
    local command
    local category
    local description
    local syntax
    local example
    local searchable_text
    local matched
    local term_found
    local count=0

    local -a query_terms
    local -a search_terms

    # Convert search input into individual words
    normalized_query="$(normalize_search_text "$query")"
    read -r -a query_terms <<< "$normalized_query"

    if (( ${#query_terms[@]} == 0 )); then
        echo "Please enter a valid search keyword."
        return
    fi

    # Read command library
    while IFS='|' read -r command category description syntax example
    do

        # Ignore empty lines and comments
        [[ -z "$command" || "$command" == \#* ]] && continue

        # Prepare searchable information
        searchable_text="$(normalize_search_text \
            "$command $category $description $syntax $example")"

        read -r -a search_terms <<< "$searchable_text"

        matched=1

        # Every search word must match
        for query_term in "${query_terms[@]}"
        do
            term_found=0

            for search_term in "${search_terms[@]}"
            do

                # Exact word match
                if [[ "$search_term" == "$query_term" ]]; then
                    term_found=1
                    break

                # Allow longer descriptive words
                elif (( ${#query_term} >= 4 )) &&
                     [[ "$search_term" == "$query_term"* ]]; then
                    term_found=1
                    break
                fi

            done

            if (( term_found == 0 )); then
                matched=0
                break
            fi

        done

        # Display matching command
        if (( matched == 1 )); then

            ((count += 1))

            echo
            echo "=========================================="
            echo "MATCH $count"
            echo "=========================================="
            echo "COMMAND     : $command"
            echo "CATEGORY    : $category"
            echo "DESCRIPTION : $description"
            echo "SYNTAX      : $syntax"
            echo "EXAMPLE     : $example"

        fi

    done < "$COMMANDS_FILE"

    echo
    echo "=========================================="

    if (( count == 0 )); then
        echo "No matching commands found."
        echo "Try another command or keyword."
    else
        echo "Total matching commands: $count"
    fi

    echo "=========================================="
}

# Main Search Mode
search_mode() {

    local query

    if [[ ! -f "$COMMANDS_FILE" ]]; then
        echo "Command library not found!"
        return 1
    fi

    while true
    do
        echo
        echo "=========================================="
        echo "             COMMAND SEARCH"
        echo "=========================================="
        echo "Search by command name or description."
        echo "Example: grep, memory, directory"
        echo "Enter 0 to return to main menu."
        echo

        read -r -p "Enter search keyword: " query

        if [[ "$query" == "0" ]]; then
            return
        fi

        if [[ -z "${query//[[:space:]]/}" ]]; then
            echo "Please enter a search keyword."
            continue
        fi

        search_commands "$query"

    done
}
