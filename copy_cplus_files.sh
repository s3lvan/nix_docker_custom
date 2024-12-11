#!/bin/bash

# Source directory (relative to the script's location)
SRC_DIR="../nix/src"

# Destination directory (in the current working directory)
DEST_DIR="./src2"

# Create the destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Find and copy .cc and .hh files while preserving the directory structure
find "$SRC_DIR" -type f \( -name "*.cc" -o -name "*.hh" \) | while read -r file; do
    # Get the directory of the file relative to the source directory
    relative_dir=$(dirname "${file#$SRC_DIR/}")
    # Create the corresponding directory in the destination
    mkdir -p "$DEST_DIR/$relative_dir"
    # Copy the file to the destination directory
    cp "$file" "$DEST_DIR/$relative_dir"
done
