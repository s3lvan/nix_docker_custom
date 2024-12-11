#!/bin/bash

# Check if the number of iterations is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <number_of_iterations>"
  exit 1
fi

# Get the number of iterations from the first argument
iterations=$1

# Check if the input is a valid positive integer
if ! [[ "$iterations" =~ ^[0-9]+$ ]]; then
  echo "Error: The input must be a positive integer."
  exit 1
fi

# Define the paths
EXECUTABLE_PATH="md_processor_Release/Release/md_processor"
DATA_DIR="md_processor_Release/data"
STATS_FILE="$DATA_DIR/md-test.C-M.stats"
CSV_FILE="$DATA_DIR/md-test-2.C-M.csv"

# Check if the executable exists
if [ ! -f "$EXECUTABLE_PATH" ]; then
  echo "Executable $EXECUTABLE_PATH not found. Please build the project first."
  exit 1
fi

# Loop to run the command the specified number of times
for ((i=1; i<=iterations; i++))
do
  echo "Running iteration $i..."

  # Run the Docker container with the executable and data directory mounted
  docker run -it --rm \
    -v "$(pwd)/md_processor_Release/Release:/usr/src/app/md_processor_Release/Release" \
    -v "$(pwd)/$DATA_DIR:/usr/src/app/$DATA_DIR" \
    -w /usr/src/app \
    md_processor /bin/bash -c "
      # Run the command
      $EXECUTABLE_PATH --p=C --d=M --f=$DATA_DIR/md-test-2.json 2> $STATS_FILE > $CSV_FILE

      # Check if the command was successful
      if [ \$? -eq 0 ]; then
        # Print the top 10 lines of the CSV file
        echo 'Top 10 lines of $CSV_FILE:'
        head -n 10 $CSV_FILE

        # Remove the .stats and .csv files
        rm $STATS_FILE $CSV_FILE
        echo 'Removed $STATS_FILE and $CSV_FILE'
      else
        echo 'Command failed to execute.'
        exit 1
      fi
    "

  # Check if the Docker command was successful
  #if [ $? -ne 0 ]; then
  #  echo "Docker command failed during iteration $i."
  #  exit 1
  #fi
done

echo "Completed $iterations iterations."
