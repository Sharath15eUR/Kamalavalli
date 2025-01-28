
#!/bin/bash


#Command-line Arguments 
src_dir=$1
bkp_dir=$2
file_ext=$3


#Environment variable 
export BACKUP_COUNT=0

#Checking if source directory is empty 
if [ ! -d "$src_dir" ]; then
    echo "Error: Source directory '$src_dir' does not exist."
    exit 1
fi

#Globbing and storing the files as an array
file_list=("$src_dir"/*"$file_ext")

# Checking the source directory contains no matching files
if [ ${#file_list[@]} -eq 0 ]; then
    echo "No files with extension '$file_ext' found in the source directory."
    exit 0
fi

#checking the backup directory's existence and creating if it is not already there
if [ ! -d "$bkp_dir" ]; then
    mkdir "$bkp_dir" 
fi

total_size=0
echo "Files in the source directory:" 
for src_file in "${file_list[@]}"; do
   file_size=$(ls -l "$src_file" | awk '{print $5}')
   file_name=$(echo "$src_file" | awk -F'/' '{print $NF}')
   total_size=$((total_size + file_size))
   echo "File: $file_name, Size: $file_size bytes" #Print the names of the files along with their sizes before performing the backup.
done

#Backing up
for src_file in "${file_list[@]}"; do
    file_name=$(echo "$src_file" | awk -F'/' '{print $NF}')
    dest_file="$bkp_dir/$file_name"

    if [ -e "$dest_file" ]; then #If the file is already present
        if [ "$src_file" -nt "$dest_file" ]; then
            cp "$src_file" "$dest_file"
            BACKUP_COUNT=$((BACKUP_COUNT + 1))
        fi
    else
        cp "$src_file" "$dest_file"
        BACKUP_COUNT=$((BACKUP_COUNT + 1))
    fi
done

report_log="$bkp_dir/backup_report.log"
echo "Total files processed: $BACKUP_COUNT" >> "$report_log"
echo "Total size of files backed up: $total_size bytes" >> "$report_log"
echo "Backup directory: $bkp_dir" >> "$report_log"

echo "Total files processed: $BACKUP_COUNT"
echo "Total size of files backed up: $total_size bytes"
echo "Backup directory: $bkp_dir"
