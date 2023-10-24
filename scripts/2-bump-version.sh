#!/bin/bash

## ===================== ##
## NOTIFY
## ===================== ##

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
function notify() {
  local message="$1"
  local status=$2

  case $status in
    success)
      color="$GREEN"
      symbol="✔"
      ;;
    warning)
      color="$YELLOW"
      symbol="⚠"
      ;;
    error)
      color="$RED"
      symbol="✖"
      ;;
    *)
      color="$NC"
      symbol=""
      ;;
  esac

  block="▌"
  padding=$(( ($(tput cols) - ${#message} - 4) / 2 ))

  printf "${color}${block}%*s ${symbol} ${message} %*s${NC}"
  printf "${color}${block}%*s %s %*s${NC}\n"
}


get_version() {
    local pubspec_file="/Users/marceloreis/Mobile/Vertical/smarttime/mobile/pubspec.yaml"
    local version_line=$(grep "version:" $pubspec_file)
    local current_version=$(echo "$version_line" | awk '{print $2}')

    echo $current_version
}

# Function to update the version in pubspec.yaml
run() {
    local pubspec_file="/Users/marceloreis/Mobile/Vertical/smarttime/mobile/pubspec.yaml"
    local version_part=$1
    local dev_branch="dev"
    local current_version=$(get_version)
    current_major=$(echo $current_version | cut -d'.' -f1)
    current_minor=$(echo $current_version | cut -d'.' -f2)
    current_patch=$(echo $current_version | cut -d'.' -f3 | cut -d'+' -f1)
    current_build=$(echo $current_version | cut -d'+' -f2)
    new_build=$((current_build + 1))
    new_version=""
    
    case $version_part in
        "major")
            new_major=$((current_major + 1))
            new_version="$new_major.$current_minor.$current_patch+$new_build"
            ;;
        "minor")
            new_minor=$((current_minor + 1))
            new_version="$current_major.$new_minor.$current_patch+$new_build"
            ;;
        "patch")
            new_patch=$((current_patch + 1))
            new_version="$current_major.$current_minor.$new_patch+$new_build"
            ;;
        "build")
            new_version="$current_major.$current_minor.$current_patch+$new_build"
            ;;
        *)
            notify "Invalid version part: $version_part" error
            exit 1
            ;;
    esac
    
    # Adding and Commiting pubspec.yaml
    git checkout $dev_branch
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    if [ $current_branch == $dev_branch ]; then
        sed -i '' "s/version: $current_version/version: $new_version/" $pubspec_file
        notify "Version bumped from $current_version to $new_version" success

        git add $pubspec_file
        git commit -m "Bump $version_part | $current_version => $new_version"
        git push origin $current_branch
        notify "pubspec.yaml commited and pushed to origin/$dev_branch successfully!" success

        if [ $? -ne 0 ]; then
            notify "An error occurred during the process." error
            exit 1
        fi
    else 
        notify "You must be on $dev_branch branch to proceed" error
    fi
}

# Main script
if [ $# -ne 1 ]; then
    notify "Version bump failed." error
    notify "Usage: $0 <major|minor|patch|build>" warning
    exit 1
fi

version_part=$1
run $version_part
