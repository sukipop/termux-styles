#!/usr/bin/env bash
set -euo pipefail

# Function to print error message
error() {
    local errmsg="${1:-Unknown error}"
    echo -e "\033[1;31mError\033[0m: ${errmsg}\n" 1>&2
}

install_scripts() {
    # Check on project bin
    if [[ ! -d "bin" ]]; then
        error "Missing bin"
        return 1
    elif [[ -z "$(ls -A bin)" ]]; then
        error "Empty bin"
        return 1
    fi

    # Copy scripts to termux bin
    for file in bin/*; do
        file_name=$(basename "$file")
        destination="$PREFIX/bin/$file_name"
        rm -rf "$destination"
        if ! cp "$file" "$destination"; then
            error "Failed to copy to bin: $file_name"
            return 1
        fi
    done
}

create_share() {
    local share_dir="$PREFIX/share/termux-styles"

    # Ensure 'share_dir' is empty
    mkdir -p "$share_dir" || return 1
    rm -rf "$share_dir"/* || return 1

    # Copy share content
    cp -r share/* "$share_dir" || return 1
}

# Ensure 'PREFIX' is defined
if [[ -z "$PREFIX" ]]; then
    error "Unset variable: PREFIX"
    exit 1
fi

echo "Installing termux-textgen..."
install_scripts || exit 1
create_share || { error "Failed to create share"; exit 1; }
