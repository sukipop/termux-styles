#!/usr/bin/env bash
set -euo pipefail

# Function to print error message
error() {
    local errmsg="${1:-Unknown error}"
    echo -e "\033[1;31mError\033[0m: ${errmsg}\n" 1>&2
}

create_share() {
    local share_dir="$PREFIX/share/termux-styles"
    mkdir -p "$share_dir"
    rm -rf "$share_dir"/*
    cp share/* "$share_dir"
}

# Ensure 'PREFIX' is defined
if [[ -z "$PREFIX" ]]; then
    error "Unset variable: PREFIX"
    exit 1
fi

echo "Installing termux-textgen..."
create_share || error
