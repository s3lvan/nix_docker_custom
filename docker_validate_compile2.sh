#!/bin/bash

# Define variables for paths and container name
SOURCE_DIR="$(pwd)/src2"
CONTAINER_WORKDIR="/usr/src/app/nix/src2"
CONTAINER_STARTDIR="/usr/src/app/nix"
IMAGE_NAME="nix_docker_custom:latest"  # Ensure this is correctly defined

# Check if the source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: Source directory '$SOURCE_DIR' does not exist."
  exit 1
fi

# Check if the image name is set
if [ -z "$IMAGE_NAME" ]; then
  echo "Error: IMAGE_NAME is not set."
  exit 1
fi

# Run the Docker container with the source code mounted as a volume
docker run -it --rm \
  -v "$SOURCE_DIR:$CONTAINER_WORKDIR" \
  -w "$CONTAINER_STARTDIR" \
  "$IMAGE_NAME" /bin/bash -c "/bin/bash /etc/profile.d/nix.sh && nix develop --extra-experimental-features nix-command --extra-experimental-features flakes && mesonConfigurePhase"
