#!/bin/bash
MYPATH="/cygdrive/c/users/david.davidson/desktop/linkTagger" # Replace this with wherever you want to put HTML files to tag. Then drop those files into the folder, run the script from your Linux or Cygwin shell, and relax!
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
ALTGLT=${GLT//\?/\\&} # Create alternative version that starts with &, not ?
find $MYPATH -type f -exec \sed -i "s/href=\"\([^?#\"]*\)\(#[^\"]*\)*\(\?[^\"]*\)\"/href=\"\1\3\2\"/g" {} + # If a previously tagged link puts an ID before the GLT, reverse the two
find $MYPATH -type f -exec \sed -i "s/href=\"\([^?#\"]*\)\(#[^\"]*\)*\"/href=\"\1$GLT\2\"/g" {} + # If the link includes an ID, add the GLT first
find $MYPATH -type f -exec \sed -i "s/href=\"\([^_#\"]*\)\(#[^\"]*\)*\"/href=\"\1$ALTGLT\2\"/g" {} + # If the link already introduces other parameters with a question mark, introduce the GLT with an ampersand instead.
if [ "$ADDTARGETBLANK" = "y" ]
	then
		find $MYPATH -type f -exec \sed -i "s/href=\"\([^\"]*\)\">/href=\"\1\" target=\"_blank\">/g" {} +
fi
echo "Done. Click back to your file(s), and reload if prompted!"