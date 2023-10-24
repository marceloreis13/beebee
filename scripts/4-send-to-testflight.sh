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
    local review_branch="review/$current_version"
    local api_key="VYC6Y3597A"
    local api_issuer="3abd6cbf-0209-4799-b7c5-b5dd729ce158"
    local build_path="/Users/marceloreis/Mobile/Vertical/smarttime/mobile/build/ios/ipa/*.ipa"
    local keys_path_original="/Users/marceloreis/Mobile/Vertical/smarttime/mobile/private_keys"
    local keys_path_link="/Users/marceloreis/.private_keys"

    # Creating link to private keys folder
    ln -s $keys_path_original $keys_path_link
    if [ -L "$keys_path_link" ] && [ -e "$keys_path_link" ]; then
      notify "Link to /private_keys folder created succesfully" success    

      git checkout $review_branch
      local current_branch=$(git rev-parse --abbrev-ref HEAD)
      if [ $current_branch == $review_branch ]; then
          notify "Moved to $review_branch branch" success    
          
          notify "Started building IPA file" warning    
          flutter build ipa
          notify "IPA file builded succesfully!" success    

          notify "Started uploading build to TestFlight" warning    
          xcrun altool --upload-app --type ios -f $build_path --apiKey $api_key --apiIssuer $api_issuer
          notify "Uploaded to TestFlight succesfully!" success    

          if [ $? -ne 0 ]; then
              notify "An error occurred during the process." error
              exit 1
          fi
      else
          notify "Was not possible move to $review_branch branch" error
      fi
    else
        notify "Was not possible to create a link to $keys_path_original folder" error
    fi

}

run