#!/bin/bash

# Check if the sqlite3 utility is installed
if ! command -v sqlite3 &> /dev/null; then
    echo "sqlite3 is not installed. Please install it first."
    exit 1
fi

# Set Variables
input_dir="/PATH/TO/INPUT"
output_dir="/PATH/TO/OUTPUT"
file_extension=".db"

# Find all .db files in the input directory
found_files=$(find "$input_dir" -type f -name "*$file_extension")

# Check if any matching files were found
if [ -n "$found_files" ]; then
    for db_file in $found_files; do
        echo "Found .db file: $db_file"

        # Extract the file name without directory path
        db_file_name=$(basename "$db_file")

        # Create the corresponding directory structure in the output directory
        db_output_dir="$output_dir/${db_file_name%$file_extension}"


        # Check if the directory exists
        if [ -d "$db_output_dir" ]; then
         echo "The directory '$db_output_dir' already exists. Exiting."
        continue
        fi

        #If the directory doesn't exist, you can proceed with your script here
        echo "The directory '$db_output_dir' doesn't exist. You can proceed with your script."

        mkdir -p "$db_output_dir"
        echo "Created directory: $db_output_dir"

        # Get a list of all table names in the database
        table_names=$(sqlite3 "$db_file" ".tables")

        # Loop through each table and export it to CSV
        for table_name in $table_names; do
            # Form the CSV file name based on the table name
            csv_file="${db_output_dir}/${table_name}.csv"

            # Run the SQLite query to export data to CSV
            sqlite3 -header -csv "$db_file" "SELECT * FROM $table_name;" > "$csv_file"

            # Check if the export was successful
            if [ $? -eq 0 ]; then
                echo "Exported table $table_name from $db_file to $csv_file."
            else
                echo "Export of table $table_name from $db_file failed."
            fi
        done
    done
else
    echo "No matching files found in $input_dir with the extension $file_extension."
fi
