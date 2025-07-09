#!/bin/sh

# Get the absolute path to the directory containing the script
script_location_dir="$(cd "$(dirname "$0")" && pwd)"

# Go up one level to the project root directory (e.g., /path/to/project)
root_dir="$(dirname "${script_location_dir}")"

# Set the csv files directory
csv_dir="${root_dir}/csv"

# Create the /lists/ directory if it's missing
if [ ! -d "${root_dir}/lists" ]; then
    mkdir -p "${root_dir}/lists"
fi

# Create/clear the text file in the lists directory
output_file="${lists_dir}/csv_files.txt"
> "${output_file}"

# Get the list of CSV files and add them to the text file
for csv_file in "${csv_dir}"/*.csv; do
    # Skip if no files matched
    [ -e "$csv_file" ] || continue
    echo "$(basename "$csv_file")" >> "${root_dir}/lists/csv_files.txt"
done

echo "CSV files saved to ${output_file}"