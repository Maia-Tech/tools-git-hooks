#!/bin/bash

# Check if the current directory is within a Git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "Error: Not inside a Git repository."
  exit 1
fi

git_top_level=$(git rev-parse --show-toplevel 2>/dev/null)
if [ $? -ne 0 ]; then
    echo "ERROR: Could not extract the top of the workspace"
    exit 1
fi

# Create a temporary directory
temp_dir="$(mktemp -d)"

# Clone the repository into the temporary directory
git clone git@github.com:Maia-Tech/tools-git-hooks.git "$temp_dir" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: Failed to clone the tools-git-hooks repo"
    exit 1
fi

# Copy the hook files to the .git/hooks directory
for hook in prepare-commit-msg commit-msg; do
    cp "$temp_dir/hooks/${hook}" ".git/hooks/"
done

# Make the hook file executable
chmod +x ".git/hooks/prepare-commit-msg"

# Clean up the temporary directory
rm -rf "$temp_dir"

echo "prepare-commit-msg hook installed successfully."
