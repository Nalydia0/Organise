#!/usr/bin/bash

# Prompt the user to input the directory
# Firstly we need to create our download dir
echo -e "Please input the full directory you want to sort into folders \n for windows systems, please surround your directory in " " " 
read -r organise_dir
# Strip quotes if present
organise_dir=${organise_dir//\"/}
organise_dir=${organise_dir//\'/}

# Convert the Windows path to a format Bash can understand
organise_dir=${organise_dir//\\//}
organise_dir=${organise_dir//C:/\/c}

if [[ ! -d "$organise_dir" ]] ; then
    echo "This Directory does not exist or has been inputted incorrectly"
    exit 1
else
    cd "$organise_dir"
fi



#This allows reading and also (by using -p which means promp) we can output a promp and store
#use An ifs VARIABLE to tell Bash to use the , delimite -a used to ensure words separated by ifs are in separate array
#indexies
#-a tells it to store comma separates values in between IFS in an array starting from index one
IFS="," read -a folder_array -p $"Hello there, today we will be sorting the downloads directory.\nPlease enter the folders you'd like to make, i.e. Documents, Videos, Compressed,Executables, Images, Audio separated by commas:"

#We need to trim any whitespace for the folder name in case of user input being different i.e ",videos " or ",   videos "
#We want to default it to ",[foldername]"
#We will use xargs to trim the whitespace

#Loop through indicies or the array and trim their whitespace
 #Using Command substituion to do the xargs then store the result in the folder array index

for j in "${!folder_array[@]}"; do
    folder_array[$j]=$(xargs <<< "${folder_array[$j]}")
done

#Map folders with their extensions using an associative array use declare -A to create an associative array

declare -A folder_map 

#Map Folders i.e pdf,txt,docx, doc, odt with the syntax arrayName[key1]=value1,value 2 etc 
folder_map[Documents]="pdf,txt,docx,doc,odt,csv"
folder_map[Images]="png,img,jpeg,jpg,svg,gif,tiff,tif,webp,bmp"
folder_map[Videos]="mp4,webm,mkv,avchd,flv,mov,avi"
folder_map[Audio]="m4a,mp3,wav"
folder_map[Compressed]="rar,zip,7z"
folder_map[Executables]="exe"

#Create Folders by using a for loop to loop through the input array
#Loop through each element and create a folder, don't if it already exists

for folders in "${folder_array[@]}";
    do
    #Esnure that the folders  don't already exist by using test and -d
    #Test -d returns true if the following argument is a directory, so we 
    if  ! test -d "$folders"; then
        #-p so what if it already exists it won't throw and error
        echo "Creating a $folders folder"
        mkdir -p "$folders"
    
    fi
        
    done
    #Loop over all the folder types they have selected
for folder in "${!folder_map[@]}"; do
    #Check to ensure that the folder is in the list of folders
    if [[ " ${folder_array[*]} " == *" $folder"* ]]; then
            #Get the comma separated extensions from the current element into an array <<< asigns a string from after to the thing before
            IFS="," read -a extensions <<< "${folder_map[$folder]}" #!Needed to access the keys of an associative array
            
        for ext in "${extensions[@]}"; do #Loop through the extensions moving as we go 
                    #Move any files that match the extension into the folder
                    echo "Moving all files that use the $ext extension"
                    echo "$folder" 
                    mv *."$ext" "$folder"  
            done
        else
        #We need to handle the case wherein a folder is not found
        echo "The folder: "$folder" is not in the list of folders provided"
        fi
    done













