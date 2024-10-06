#!/usr/bin/bash

# Prompt the user to input the directory
# Firstly we need to create our download dir
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
    cd "$organise_dir"
fi



#This allows reading and also (by using -p which means promp) we can output a promp and store
#use An ifs VARIABLE to tell Bash to use the , delimite -a used to ensure words separated by ifs are in separate array
#indexies
#-a tells it to store comma separates values in between IFS in an array starting from index one
IFS="," read -r -p $"Hello there, today we will be sorting the $organise_dir directory.\nPlease enter the file types and folder names separted by commas i.e Documents,Docs,Images,Media,Videos,Vids,Compressed,rars,Executables,exes,Audio,Sound: " folder_input 
#Create an array from this input string
IFS=',' read -ra folder_array <<< "$folder_input"


#Map folders with their extensions using an associative array use declare -A to create an associative array

declare -A folder_map 

#Map Folders i.e pdf,txt,docx, doc, odt with the syntax arrayName[key1]=value1,value 2 etc 
folder_map[Documents]="pdf,txt,docx,doc,odt,csv"
folder_map[Images]="png,img,jpeg,jpg,svg,gif,tiff,tif,webp,bmp"
folder_map[Videos]="mp4,webm,mkv,avchd,flv,mov,avi"
folder_map[Audio]="m4a,mp3,wav"
folder_map[Compressed]="rar,zip,7z"
folder_map[Executables]="exe"


#We now need to loop through every entry in our folder array
for ((i=0; i<${#folder_array[@]}; i+=2)); do
    folder_type=${folder_array[i]}
    folder_name=${folder_array[i+1]}

    
    #We need to trim any whitespace for the folder name in case of user input being different i.e ",videos " or ",   videos "
    #We want to default it to have no spaces
    #We will use xargs to trim the whitespace
    
    #trim whitespace for both name and type
    folder_type=$(xargs <<< "$folder_type")
    folder_name=$(xargs <<< "$folder_name")

   #Check if the folder type exists in the folder mapp
    if [[ -v folder_map[$folder_type] ]];  then #-v checks to ensure the variable exists i.e folder_types exists in folder map
        #If the folder doesn't already exist we want to create it
        #so check if iut does
    if  ! test -d "$folder_name"; then
        #-p so what if it already exists it won't throw and error
        echo "Creating a $folder_name folder"
        mkdir "$folder_name" #mkdir -p not needed anymore because we're checking the existence
    else
    echo "$folder_name already exists skipping creation"
    fi
    #Move our files
        IFS=',' read -r -a extensions <<< "${folder_map[$folder_type]}" #-r says to treat backslashes as literal -a says to store result in an array called extensions
        for ext in "${extensions[@]}"; do #Loop through the extensions moving as we go 
                    #Move any files that match the extension into the folder
                    echo "Moving all files that use the $ext extension"
                    
                    mv *."$ext" "$folder_name/"  #Added / in case folder nname has spaces
            done
        else
        #We need to handle the case wherein a folder is not found
        echo "The folder: "$folder_type" is not in the list of folders provided"
        fi
    done













