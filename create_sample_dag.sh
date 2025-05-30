#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <samples_list> <netid>"
    exit 1
fi

SAMPLES_LIST="$1"
NETID="$2"


# Check if the samples list and template file exist
if [ ! -f "$SAMPLES_LIST" ]; then
    echo "Error: Samples list file '$SAMPLES_LIST' does not exist."
    exit 1
fi

# Define the placeholder word to be replaced (change this to your specific word)
PLACEHOLDER="PLACEHOLDER_WORD"
NETID_PLACEHOLDER="NETID_PLACEHOLDER"

# Read each sample from the samples list
while IFS= read -r SAMPLE; do
    # Trim any leading/trailing whitespace
    SAMPLE=$(echo "$SAMPLE" | xargs)
    NETID=$(echo "$NETID" | xargs)

    # Check if the sample is not empty
    if [ -z "$SAMPLE" ]; then
        continue
    fi

    # Create a new filename based on the sample name
    NEW_DAG_FILE="assembly_${SAMPLE}.dag"

    # Use sed to replace the placeholder and write to the new file
    sed "s|$PLACEHOLDER|$SAMPLE|g;s|$NETID_PLACEHOLDER|$NETID|g" template.dag > "$NEW_DAG_FILE"

    echo "Created $NEW_DAG_FILE"
    
done < "$SAMPLES_LIST"

echo "All files have been created."