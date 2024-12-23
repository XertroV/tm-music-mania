#!/usr/bin/env bash

# Loop through all .zip files in the current directory
for zip_file in /home/xertrov/OpenplanetTurbo/Extract/Media/Sounds/TMConsole/Loops/*.zip; do
  # Extract the filename without extension
  dir_name="${zip_file%.zip}"

  # Create the extraction directory if it doesn't exist
  mkdir -p "$dir_name"

  # Extract the contents of the zip file into the new directory
  unzip "$zip_file" -d "$dir_name"
done
