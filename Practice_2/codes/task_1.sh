#!/bin/sh

# Get the absolute path to the directory containing the script
script_location_dir="$(cd "$(dirname "$0")" && pwd)"

# Go up one level to the project root directory (e.g., /path/to/project)
root_dir="$(dirname "${script_location_dir}")"

# Set the folder with the CSV files
folder="$root_dir/csv"

# Check if the folder exists
if [ ! -d "$folder" ]; then
    echo "Error: Directory '$folder' not found."
    exit 1
fi

echo "Starting modification of files in '$folder'..."

# 1. Change delimiter from ',' to ' '
echo "1. Changing delimiter from ',' to ' '..."
find "$folder" -type f -name "*.csv" -exec sed -i -e 's/,/\ /g' {} \;
echo "    Delimiter change complete."

# 2. Change the file extension from '.csv' to '.lc'
echo "2. Changing file extension from '.csv' to '.lc'..."
find "$folder" -type f -name "*.csv" | while read -r file; do
    new_name="${file%.csv}.lc"
    mv "$file" "$new_name"
done
echo "    Extension change complete."

# 3. Remove all columns that are not part of a light curve plot
echo "3. Removing extra columns (keeping 'TIME', 'PDCSAP_FLUX', and 'PDCSAP_FLUX_ERR')..."
find "$folder" -type f -name "*.lc" | while read -r file; do
    # Create a temporary file
    temp_file=$(mktemp)
    # Cut the desired columns (1, 8, 9) and redirect to the temporary file
    cut -d' ' -f1,8,9 "$file" > "$temp_file"
    # Overwrite the original file with the content of the temporary file
    mv "$temp_file" "$file"
done
echo "    Column removal complete."

echo "All specified modifications have been applied to the files."