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

run() {
    local current_version=$(get_version)
    local master_branch="master"
    local review_branch="review/$current_version"
    local tag_branch="v$current_version"

    git checkout $master_branch
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    if [ $current_branch == $master_branch ]; then
        notify "Moved to $master_branch branch" success    
        
        git merge $review_branch
        git push origin $master_branch
        notify "$review_branch merged to $master_branch successfully!" success

        git tag $tag_branch
        git push origin $tag_branch
        notify "Created and pushed to origin/$review_branch successfully!" success    

        if [ $? -ne 0 ]; then
            notify "An error occurred during the process." error
            exit 1
        fi
    else
        notify "Was not possible move to $master_branch branch" error
    fi
}

run