#!/bin/bash

# Log file for errors
ERROR_LOG="errors.log"

# Display help message
display_help() {
    cat <<EOF
  -d <directory> Directory to search recursively for files containing the keyword.
  -k <keyword>   Keyword to search for.
  -f <file>      File to search directly for the keyword.
  --help         Display this help menu.

Examples:
  -d <directory> -k <keyword>   Search a directory for a keyword.
  -f <file> -k <keyword>        Search a file for a keyword.
EOF
}

# Log errors to a log file
log_error() {
    echo "Error: $1" >> "$ERROR_LOG"
    echo "Error: $1" >&2
}

# Recursive function to search for the keyword in a directory and its subdirectories
search_directory() {
    local dir="$1"
    local keyword="$2"
    local found=false  # Track if the keyword is found in any file

    for file in "$dir"/*; do
        if [[ -f "$file" && $(grep -l "$keyword" "$file") ]]; then
            echo "Found '$keyword' in $file"
            found=true  
        elif [[ -d "$file" ]]; then
            search_directory "$file" "$keyword"
        fi
    done

    if [[ "$found" == false ]]; then
        echo "'$keyword' not found in '$dir'"
    fi
}


# Search the specified file for the keyword
search_file() {
    local file="$1"
    local keyword="$2"
    if grep -q "$keyword" "$file"; then
        echo "'$keyword' found in '$file'"
    else
        echo "'$keyword' not found in '$file'"
    fi
}

# Validate if the file exists using regular expression
validate_file() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        log_error "File '$file' does not exist."
        exit 1
    fi
}

# Validate if the directory exists using regular expression
validate_directory() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        log_error "Directory '$dir' does not exist."
        exit 1
    fi
}

# Main function to process inputs
main() {
    local directory=""
    local keyword=""
    local file=""

    while getopts "d:k:f:-:" opt; do
        case "$opt" in
            d) directory="$OPTARG" ;;
            k) keyword="$OPTARG" ;;
            f) file="$OPTARG" ;;
            -) 
                if [[ "$OPTARG" == "help" ]]; then
                    display_help
                    exit 0
                else
                    log_error "Invalid option."
                    exit 1
                fi
                ;;
            *) 
                log_error "Invalid option."
                exit 1
                ;;
        esac
    done

    if [[ -z "$directory" && -z "$file" && -z "$keyword" ]]; then
        display_help
        exit 0
    fi

    if [[ -n "$directory" ]]; then
        validate_directory "$directory"
    fi
    if [[ -n "$file" ]]; then
        validate_file "$file"
    fi

    if [[ -n "$directory" && -n "$keyword" ]]; then
        search_directory "$directory" "$keyword"
    elif [[ -n "$file" && -n "$keyword" ]]; then
        search_file "$file" "$keyword"
    else
        log_error "Invalid arguments. Use --help for more information."
        exit 1
    fi
}

main "$@"
