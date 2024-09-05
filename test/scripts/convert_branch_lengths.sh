#!/bin/bash

# Check if the number of arguments is correct
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <input_tree_file> <num_sites> <output_tree_file>"
    exit 1
fi

# Input file containing trees in Newick format
input_file="$1"

# Number of sites in the input alignment
num_sites="$2"

# Output file to write converted trees
output_file="$3"

# Python script to convert branch lengths
python_script=$(cat << 'END'
import sys
import re

def convert_branch_lengths(tree, num_sites):
    # Regular expression to find branch lengths
    pattern = re.compile(r':(\d+\.\d+)')

    def replace_lengths(match):
        length = float(match.group(1))
        # Convert branch length to substitutions per site
        return ":" + str(length / num_sites)

    # Replace branch lengths in the tree string
    tree = re.sub(pattern, replace_lengths, tree)
    return tree

def convert_trees(input_file, output_file, num_sites):
    with open(input_file, 'r') as f:
        trees = f.readlines()

    converted_trees = []
    for tree in trees:
        converted_tree = convert_branch_lengths(tree, num_sites)
        converted_trees.append(converted_tree)

    with open(output_file, 'w') as f:
        f.writelines(converted_trees)

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python3 convert_tree.py input_file output_file num_sites")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]
    num_sites = int(sys.argv[3])

    convert_trees(input_file, output_file, num_sites)
END
)

# Save the Python script to a temporary file
python_script_file=$(mktemp)
echo "$python_script" > "$python_script_file"

# Run the Python script
python3 "$python_script_file" "$input_file" "$output_file" "$num_sites"

# Remove the temporary Python script file
rm "$python_script_file"


