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

# Define the tools repo remote URL
tools_repo="git@github.com:Maia-Tech/tools-git-hooks.git"

# Check if the current repo is already the tools-git-hooks repo
current_remote=$(git remote -v | grep -m 1 "origin.*fetch" | awk '{print $2}')
if [ "$current_remote" = "$tools_repo" ]; then
    # We're already in the tools-git-hooks repo, use current directory
    source_dir="${git_top_level}"
else
    # Create a temporary directory and clone the repo
    source_dir="$(mktemp -d)"
    git clone "$tools_repo" "${source_dir}" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Error: Failed to clone the tools-git-hooks repo"
        exit 1
    fi

    trap "rm -rf ${source_dir}" EXIT
fi

# Copy the hook files to the .git/hooks directory
for hook in prepare-commit-msg commit-msg; do
    cp -f "${source_dir}/hooks/${hook}" ".git/hooks/"
    chmod +x ".git/hooks/${hook}"
    echo "${hook} hook installed successfully."
done
