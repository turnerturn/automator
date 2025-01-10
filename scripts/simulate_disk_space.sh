#!/bin/bash

# if fallocate is not installed, echo error message with instruction to install it before proceeding and exit 1
if ! command -v fallocate &> /dev/null; then
    echo "fallocate is not installed. Please install it before proceeding."
    exit 1
fi

# read input for input_directory and input_percent
read -p "Enter the directory path: " input_directory
# if input_directory does not exist, echo error message and exit 1
if [ ! -d "$input_directory" ]; then
    echo "Directory $input_directory does not exist."
    exit 1
fi

read -p "Enter the desired disk usage percentage: " input_percent
# if input_percent is not a number or if it is less than 0 or greater than 100, echo error message and exit 1
if ! [[ "$input_percent" =~ ^[0-9]+$ ]] || [ "$input_percent" -lt 0 ] || [ "$input_percent" -gt 100 ]; then
    echo "Invalid percentage. Please enter a number between 0 and 100."
    exit 1
fi

# if df -h indicates ${input_directory} is greater than ${input_percent} echo info message that ${input_directory} is already greater than ${input_percent} and exit 0
current_percent=$(df "$input_directory" | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$current_percent" -ge "$input_percent" ]; then
    echo "The disk usage of $input_directory is already greater than or equal to $input_percent%."
    exit 0
fi


echo "Current disk usage (before simulation): $current_percent%"
# while df "$input_directory" | awk 'NR==2 {print $5}' | sed 's/%//' is less than ${input_percent}
fallocate_gb=1
fallocate_gb_interval=1
while [ "$current_percent" -lt "$input_percent" ]; do
    fallocate -l ${fallocate_gb}G $input_directory/fill_temp_file
    current_percent=$(df "$input_directory" | awk 'NR==2 {print $5}' | sed 's/%//')
    echo "Current disk usage: $current_percent%"
    # we increment this by ${fallocate_gb_interval} each time until we find the threshold needed to simulate the desired disk usage
    fallocate_gb=$((fallocate_gb + fallocate_gb_interval))
done
echo "Current disk usage (after simulation): $current_percent%"

# echo instruction to remove /workspaces/fill_temp_file and exit 0
echo "Disk usage has reached the desired percentage. Please remove $input_directory/fill_temp_file to free up space."
exit 0
