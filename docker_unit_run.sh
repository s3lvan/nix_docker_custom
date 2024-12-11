#!/bin/bash

# Define the paths
EXECUTABLE_PATH="md_processor_Release/Release/md_processor"
DATA_DIR="md_processor_Release/data"
STATS_FILE="$DATA_DIR/md-test.C-M.stats"
CSV_FILE="$DATA_DIR/md-test-2.C-M.csv"

# Check if the executable exists
if [ ! -f "$EXECUTABLE_PATH" ]; then
  echo "Error: Executable $EXECUTABLE_PATH not found. Please build the project first."
  exit 1
fi

# Check if the data directory exists
if [ ! -d "$DATA_DIR" ]; then
  echo "Error: Data directory $DATA_DIR not found."
  exit 1
fi

# Run the Docker container with the executable and data directory mounted
docker run -it --rm \
  -v "$(pwd)/md_processor_Release/Release:/usr/src/app/md_processor_Release/Release" \
  -v "$(pwd)/$DATA_DIR:/usr/src/app/$DATA_DIR" \
  -w /usr/src/app \
  md_processor /bin/bash -c "
    # Run the command
    if $EXECUTABLE_PATH --p=C --d=M --f=$DATA_DIR/md-test-2.json 2> $STATS_FILE > $CSV_FILE; then
      # Check if the CSV file was created
      if [ -f $CSV_FILE ]; then
        # Print the top 10 lines of the CSV file
        echo 'Top 10 lines of $CSV_FILE:'
        head -n 10 $CSV_FILE

        # Remove the .stats and .csv files
        rm $STATS_FILE $CSV_FILE
        echo 'Removed $STATS_FILE and $CSV_FILE'
      else
        echo 'Error: CSV file $CSV_FILE was not created.'
        exit 1
      fi
    else
      echo 'Error: Command failed to execute.'
      exit 1
    fi
  "

# Check the exit status of the Docker command
#if [ $? -ne 0 ]; then
#  echo "Error: Docker command failed."
#  exit 1
#fi
