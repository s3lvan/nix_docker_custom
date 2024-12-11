#!/bin/bash

# Define the image name
IMAGE_NAME="nix_docker_custom"

# Check if the image already exists
EXISTING_IMAGE_ID=$(docker images -q $IMAGE_NAME)

if [ -z "$EXISTING_IMAGE_ID" ]; then
    echo "No existing image with the name $IMAGE_NAME found. Building new image."
    # Build the new image
    docker build -t $IMAGE_NAME .
else
    echo "Image with the name $IMAGE_NAME already exists. No action taken."
fi

# Uncomment the following line to build without using cache if the image doesn't exist
# docker build --no-cache -t $IMAGE_NAME .
