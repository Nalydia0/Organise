#!/usr/bin/bash

#Firstly we need to create our download dir
download_dir="C:\Users\Dylan#\Downloads"

#We must now cd to the download dir
cd "$download_dir"

#This allows reading and also (by using -p which means promp) we can output a promp and store
#use An ifs VARIABLE to tell Bash to use the , delimite -a used to ensure words separated by ifs are in separate array
#indexies
#-a tells it to store comma separates values in between IFS in an array starting from index one
IFS="," read -a folder_array -p $"Hello there, today we will be sorting the downloads directory.\nPlease enter the folders you'd like to make, i.e. Documents, Videos, Compressed,Executables, Images separated by commas:"

#Map folders with their extensions using an associative array use declare -a to create an associative array

declare -a folder_map

#Map Folders i.e pdf,txt,docx, doc, odt with the syntax arrayName[key1]=value1,value 2 etc 
folder_map[Documents]="pdf,txt,docx,doc,odt,csv"
folder_map[Images]="png,img,jpeg,jpg,svg,gif,tiff,tif,webp,bmp"
folder_map[Videos]="mp4,webm,mkv,avchd,flv,mov,avi"
folder_map[Audio]="m4a,mp3,wav"
folder_map[Compressed]="rar,zip,7z"
folder_map[Executables]="exe"

#Create Folders by using a for loop to loop through the input array
##Loop through each element and create a folder, don't if it already exists

for folders in "${folder_array[@]}";
    do
        #-p so what if it already exists it won't throw and error
        mkdir -p "$folders"
        
    done

for folder in "${!folder_map[@]}";
    do
    if [[ " ${folder_array[*]} " == *" $folder"* ]]; then
            #Get the comma separated extensions from the current element into an array <<< asigns a string from after to the thing before
            IFS="," read -a extensions <<< "${folder_map[$folder]}" #!Needed to access the keys of an associative array
            echo "test" "$folder"
        for ext in "${extensions[@]}"; #Loop through the extensions moving as we go
                do
                    #Move any files that match the extension into the folder
                    echo "tes2t" "$ext"
                    mv *."$ext" "$folder"  
        done
        fi
    done













