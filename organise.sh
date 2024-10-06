#!/usr/bin/bash

# Prompt the user to input the directory
echo -e "Please input the full directory you want to sort into folders "
read -r organise_dir

# Strip quotes if present
organise_dir=${organise_dir//\"/}
organise_dir=${organise_dir//\'/}

# Convert the Windows path to a format Bash can understand
organise_dir=${organise_dir//\\//}
organise_dir=${organise_dir//C:/\/c}

if [[ ! -d "$organise_dir" ]]; then
    echo "This Directory does not exist or has been inputted incorrectly"
    exit 1
else
    cd "$organise_dir" || exit
fi

# Read user input for file types and folder names
IFS="," read -r -p $"Hello there, today we will be sorting the $organise_dir directory.\nPlease enter the file types and folder names separated by commas: " folder_input

# Create an array from the input string
IFS=',' read -ra folder_array <<< "$folder_input"

declare -A folder_map 
folder_map[Documents]="pdf,txt,docx,doc,odt,csv"
folder_map[Images]="png,img,jpeg,jpg,svg,gif,tiff,tif,webp,bmp"
folder_map[Videos]="mp4,webm,mkv,avchd,flv,mov,avi"
folder_map[Audio]="m4a,mp3,wav"
folder_map[Compressed]="rar,zip,7z"
folder_map[Executables]="exe"

# Loop through each pair of entries in the folder array
for ((i=0; i<${#folder_array[@]}; i+=2)); do
    folder_type=${folder_array[i]}
    folder_name=${folder_array[i+1]}

    # Trim whitespace for both name and type
    folder_type=$(xargs <<< "$folder_type")
    folder_name=$(xargs <<< "$folder_name")

    # Check if both folder_type and folder_name are not empty
    if [[ -z "$folder_type" || -z "$folder_name" ]]; then
        echo "Invalid entry: folder type or folder name is empty."
        continue
    fi

    # Check if the folder type exists in the folder map
    if [[ -v folder_map[$folder_type] ]]; then
        # Check if the folder already exists; create it if it doesn't
        if [[ ! -d "$folder_name" ]]; then
            echo "Creating a $folder_name folder"
            mkdir "$folder_name" || { echo "Failed to create $folder_name"; continue; }
        else
            echo "$folder_name already exists, skipping creation."
        fi
        
        # Move files into the created folder
        IFS=',' read -r -a extensions <<< "${folder_map[$folder_type]}"
        for ext in "${extensions[@]}"; do
            echo "Moving all files that use the $ext extension"
            mv *."$ext" "$folder_name/" 2>/dev/null || echo "No files with the .$ext extension found."
        done
    else
        # Handle case where folder type is not found
        echo "The folder: $folder_type is not in the list of folders provided"
    fi
done