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

run() {
  local current_branch=$(git rev-parse --abbrev-ref HEAD)
  local dev_branch="dev"

  if [[ $(git diff --staged --name-only) ]]; then
    if [ $# -gt 0 ]; then
      ARGS="$@"
      git merge $dev_branch
      notify "Rebased to $dev_branch successfully!" success

      git commit -m "$current_branch  | $ARGS"
      notify "Files commited successfully!" success

      git push origin $current_branch
      notify "$current_branch pushed to origin successfully!" success

      git checkout $dev_branch
      git merge $current_branch 
      notify "$current_branch merged to $dev_branch successfully!" success

      git push origin $dev_branch
      notify "Pushed to origin/$dev_branch successfully!" success

      if [ $? -ne 0 ]; then
        notify "An error occurred during the process." error
        exit 1
      fi
    else
      notify "The commit message is missing." error
    fi
  else
      notify "No files added to the Git yet." error
  fi
}

commit_message=$1
run $commit_message