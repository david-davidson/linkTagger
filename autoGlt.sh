#!/bin/bash
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
GLT=${GLT//\&/\\&} # Add escape characters to ampersands
GLT=${GLT//\./\\.} # Add escape characters to periods
ALTGLT=${GLT//\?/\\&} # For alternative version, trim leading ? and replace with &
#Bug: finds "_blank", like this: <a href="http://www.asor.org/" target=&utm_source=blog.logos.com&utm_medium=blog&utm_content=get30off9years&utm_campaign=noet2014q1"_blank">
find /cygdrive/c/users/david.davidson/desktop/autoGlt -type f -exec \sed -i "s/href=\"\([^?#\"]*\)\(#.*\)*\"/href=\"\1$GLT\2\"/g" {} + # If the link includes an ID, add the GLT before that
find /cygdrive/c/users/david.davidson/desktop/autoGlt -type f -exec \sed -i "s/href=\"\([^_#\"]*\)\(#.*\)*\"/href=\"\1$ALTGLT\2\"/g" {} + # If the link already introduces parameters with a question mark, introduce the GLT with an ampersand instead
if [ "$ADDTARGETBLANK" = "y" ]
	then
	find /cygdrive/c/users/david.davidson/desktop/autoGlt -type f -exec \sed -i "s/href=\"\([^\"]*\)\">/href=\"\1\" target=\"_blank\">/g" {} +
fi
echo "Done. Refresh your file!"