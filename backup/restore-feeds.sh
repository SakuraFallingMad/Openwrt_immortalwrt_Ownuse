#!/bin/bash

# List of directories to reset
directories=(
    "packages"
    "luci"
    "routing"
    "telephony"
    "video"
    "pw"
    "lucky"
)

# Save the initial directory
initialDir="$(pwd)"

# Reset changes in the initial directory
cd "$initialDir" || { echo "Failed to enter initial directory"; exit 1; }
git checkout . && echo "Reset changes in initial directory"

# Reset changes in each directory
for dir in "${directories[@]}"; do
    cd "$initialDir/feeds/$dir" || { echo "Failed to enter directory $dir"; exit 1; }
    git checkout . && echo "Reset changes in $dir"
    cd "$initialDir" || { echo "Failed to return to initial directory"; exit 1; }
done
