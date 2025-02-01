#!/bin/bash

INPUT_FILE="/home/kamalavalli/Downloads/input.txt"
OUTPUT_FILE="output.txt"

echo -n > "$OUTPUT_FILE"

params=("frame.time" "wlan.fc.type" "wlan.fc.subtype")

while read -r line; do
    for param in "${params[@]}"; do
        if [[ $line =~ \"$param\" ]]; then
            value=$(echo "$line" | awk -F': ' '{print $2}')
            case $param in
                "frame.time")
                    echo "\"frame.time\": $value" >> "$OUTPUT_FILE"
                    ;;
                "wlan.fc.type")
                    echo "\"wlan.fc.type\": $value" >> "$OUTPUT_FILE"
                    ;;
                "wlan.fc.subtype")
                    echo "\"wlan.fc.subtype\": $value" >> "$OUTPUT_FILE"
                    ;;
            esac
        fi
    done
done < "$INPUT_FILE"


