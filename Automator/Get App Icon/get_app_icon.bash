#!/bin/bash
# Written by Tully Jagoe 12/10/24

appName="$(basename "${1}" .app)"
iconStore="${2}"
iconName="$(echo "${appName}" | tr ' ' '_' | tr '[:upper:]' '[:lower:]')" # Convert the app name to lowercase and replace spaces with underscores

echo -e "appName:\n${appName}"
echo -e "iconStore:\n${2}"
echo -e "iconName:\n${iconName}"

# Get the icon file name from Info.plist
icnsFile="$(defaults read "${1}/Contents/Info.plist" CFBundleIconFile)"
[[ ! "${icnsFile}" == *.icns ]] && icnsFile="${icnsFile}.icns" # Add the .icns extension if it's missing
echo -e "ICNS:\n${icnsFile}"

echo -e "\nCopying ${appName} icon to ${iconStore}/${iconName}.icns"
cp "${1}/Contents/Resources/${icnsFile}" "${iconStore}/${iconName}.icns"

# Convert the .icns file to .png
[[ -f "${iconStore}/${iconName}.icns" ]] && {
    sips -s format png "${iconStore}/${iconName}.icns" --out "${iconStore}/${iconName}.png"
    open -R "${iconStore}/${iconName}.png"
    # Remove the original .icns file
    rm "${iconStore}/${iconName}.icns"
} || {
    echo -e "ERROR: Could not convert icon to .png, file not not found at output destination:\n${iconStore}/${iconName}.icns"
    exit 1
}
