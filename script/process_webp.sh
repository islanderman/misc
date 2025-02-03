#!/bin/bash

# Usage: ./convert_webp_to_gif.sh -d <directory> -p <parallel_jobs>
# Example: ./convert_webp_to_gif.sh -d /path/to/webp/files -p 4

# Default values
DIRECTORY=""
PARALLEL_JOBS=5

# Parse command-line arguments
while getopts "d:p:" opt; do
  case $opt in
    d) DIRECTORY="$OPTARG" ;;
    p) PARALLEL_JOBS="$OPTARG" ;;
    *) echo "Usage: $0 -d <directory> -p <parallel_jobs>"; exit 1 ;;
  esac
done

# Check if directory is provided and exists
if [[ -z "$DIRECTORY" || ! -d "$DIRECTORY" ]]; then
  echo "Error: Valid directory must be provided with -d option."
  exit 1
fi

# Check if GNU parallel is installed
if ! command -v parallel &> /dev/null; then
  echo "Error: GNU parallel is not installed. Install it with 'brew install parallel' or your package manager."
  exit 1
fi

# Check if ImageMagick is installed
if ! command -v magick &> /dev/null; then
  echo "Error: ImageMagick is not installed. Install it with 'brew install imagemagick' or your package manager."
  exit 1
fi

# Find all .webp files in the directory and convert them to .gif in parallel
find "$DIRECTORY" -type f -iname '*.webp' | parallel -j "$PARALLEL_JOBS" magick {} -loop 0 {.}.gif

echo "Conversion completed!"
