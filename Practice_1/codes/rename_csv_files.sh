#!/bin/sh

# Get the absolute path to the directory containing the script
script_location_dir="$(cd "$(dirname "$0")" && pwd)"

# Go up one level to the project root directory (e.g., /path/to/project)
root_dir="$(dirname "${script_location_dir}")"

# Set the csv and fits files directory
csv_dir="${root_dir}/csv"
fits_dir="${root_dir}/fits"

# Get sorted list of FITS filenames without extensions
fits_names=$(ls "${fits_dir}"/*.fits | sort | xargs -n 1 basename | sed 's/\.fits$//')

i=1
for fits_name in $fits_names; do
    csv_file="${csv_dir}/${i}.csv"
    new_csv_file="${csv_dir}/${fits_name}.csv"

    if [ -f "$csv_file" ]; then
        mv "$csv_file" "$new_csv_file"
        echo "Renamed $csv_file -> $new_csv_file"
    else
        echo "CSV file $csv_file not found" >&2
    fi
    i=$((i + 1))
done