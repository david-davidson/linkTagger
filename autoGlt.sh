#!/bin/bash
MYPATH="/cygdrive/c/users/david.davidson/desktop/autoGlt" # Replace this with wherever you want to run the script
echo "Enter the source:"
read SOURCE
SOURCE="?utm_source=$SOURCE"
echo "Enter the medium:"
read MEDIUM
MEDIUM="&utm_medium=$MEDIUM"
echo "Enter the content:"
read CONTENT
CONTENT="&utm_content=$CONTENT"
echo "Enter the campaign:"
read CAMPAIGN
CAMPAIGN="&utm_campaign=$CAMPAIGN"
echo "Append target=\"_blank\"? y/n"
read ADDTARGETBLANK
GLT="$SOURCE$MEDIUM$CONTENT$CAMPAIGN"
GLT=${GLT,,} # lowercase the string
GLT=${GLT//\&/\\&} # Escape the ampersands (for sed)
GLT=${GLT//\./\\.} # Escape the periods
ALTGLT=${GLT//\?/\\&}
find $MYPATH -type f -exec \sed -i "s/href=\"\([^?#\"]*\)\(#.*\)*\"/href=\"\1$GLT\2\"/g" {} + # Note: if the link includes an ID, add the GLT before that
find $MYPATH -type f -exec \sed -i "s/href=\"\([^_#\"]*\)\(#.*\)*\"/href=\"\1$ALTGLT\2\"/g" {} + # What if the link already introduces parameters with a question mark? Introduce the GLT with an ampersand instead
if [ "$ADDTARGETBLANK" = "y" ]
	then
		find $MYPATH -type f -exec \sed -i "s/href=\"\([^\"]*\)\">/href=\"\1\" target=\"_blank\">/g" {} +
fi
echo "Done. Click back to your file(s), and reload if prompted!"