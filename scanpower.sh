#!/bin/bash

# Function to generate a random IP address
generate_random_ip() {
    echo "$(($RANDOM%256)).$(($RANDOM%256)).$(($RANDOM%256)).$(($RANDOM%256))"
}

# Check if both arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: ./scanpower.sh <website> <nmap_severity>"
    exit 1
fi

# Capture the arguments
website=$1
nmap_severity=$2

# Generate a random source IP address
random_ip=$(generate_random_ip)

# Determine Nmap scan arguments based on severity
case "$nmap_severity" in
    "shh")
        nmap_ports="-p1-10"
        nmap_options="-T2 --randomize-hosts --randomize-ports -S $random_ip"
        ;;
    "rpg")
        nmap_ports="-p- -sX --flood --max-parallelism 100"
        ;;
    *)
        echo "Invalid Nmap severity. Exiting script."
        exit 1
        ;;
esac

# Run Nmap scan
nmap_output="nmap_output.txt"
nmap_command="nmap $nmap_ports $nmap_options $website"
$nmap_command > $nmap_output

# Combine Nmap output into a formatted text file
combined_output="combined_output.txt"
mv "$nmap_output" "$combined_output"

echo "Scan completed. Results stored in $combined_output."
