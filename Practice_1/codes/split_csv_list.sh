#!/bin/sh

# Get the absolute path to the directory containing the script
script_location_dir="$(cd "$(dirname "$0")" && pwd)"

# Go up one level to the project root directory (e.g., /path/to/project)
root_dir="$(dirname "${script_location_dir}")"

# Set csv_files.txt as the input file
filenames_list="${root_dir}/lists/csv_files.txt"

# Create the /lists/ directory if it's missing
if [ ! -d "${root_dir}/lists" ]; then
    mkdir -p "${root_dir}/lists"
fi

# Initialize the list file number and the read line in csv_files.txt
file_number=1
line_number=0

# Read csv_files.txt and split into n files of 5 lines
while read line; do
    echo "$line" >> "${root_dir}/lists/list_${file_number}.txt"
    line_number=$((line_number + 1))
    if [ "$line_number" -eq 5 ]; then
        file_number=$((file_number + 1))
        line_number=0
    fi
done < "$filenames_list"

echo "csv_files.txt has been split into $((file_number - 1)) files."
