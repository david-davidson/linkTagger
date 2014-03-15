#!/bin/bash
# If you encounter an error the first time you run the script, you may need to convert the line breaks. Cd into the directory where the script lives, and run this command: sed -i 's/\r//g' linkTagger.sh
MYPATH="/cygdrive/c/users/david.davidson/desktop/linkTagger" # The script's replacement commands are recursive--they tag not only all the files in the current working directory, but all the files in all the *folders* in there, too. For that reason, the recommended behavior is conservative: replace MYPATH with the single directory where you'd like to tag files (not the desktop!), and put files there when you want to tag them. If you'd like to run the script in the current working directory, though, you can set MYPATH to "."
echo "Paste in existing GLT, write new GLT, or just check link formatting?
Enter e for existing, n for new, or f for formatting:"
read MODE
if [[ "$MODE" = "e" || "$MODE" = "E" ]]
	then
		echo "Paste in your GLT:"
		read GLT
		GLT=${GLT/\?/} # Get rid of the leading question mark, because we might occasionally need to lead with an ampersand
elif [[ "$MODE" = "n" || "$MODE" = "N" ]]
	then
		echo "Enter the source:"
		read SOURCE
		echo "Enter the medium:"
		read MEDIUM
		echo "Enter the content:"
		read CONTENT
		echo "Enter the campaign:"
		read CAMPAIGN
		SOURCE="utm_source=$SOURCE"
		MEDIUM="utm_medium=$MEDIUM"
		CONTENT="utm_content=$CONTENT"
		CAMPAIGN="utm_campaign=$CAMPAIGN"
		GLT="$SOURCE&$MEDIUM&$CONTENT&$CAMPAIGN"
		GLT=${GLT,,} # lowercase the string
fi
GLT=${GLT//\&/\\&} # Escape the ampersands
GLT=${GLT//\//\\/} # Escape slashes
GLT=${GLT// /} # Remove spaces, just in case
echo "Append target=\"_blank\"? y/n"
read ADDTARGETBLANK
find "$MYPATH" -type f -exec \sed -i "s/href=\"\([^?#\"]*\)\(#[^\"]*\)*\(?[^\"]*\)\"/href=\"\1\3\2\"/g" {} + # Move all section IDs to the end of their links
if [[ "$MODE" != "f" && "$MODE" != "F" ]]
	then
		find "$MYPATH" -type f -exec \sed -i "s/href=\"\([^?#\"]*\)\(#[^\"]*\)*\"/href=\"\1?$GLT\2\"/g" {} + # Tag all the links that don't include "?"; introduce the GLT with "?"; if there's a section ID, keep it at the end
		find "$MYPATH" -type f -exec \sed -i "s/href=\"\([^\"]*utm_[^\"]*\)\"/href= \"\1\"/g" {} + # What about links that include "?" but don't include GLT? Sed doesn't support negative lookahead, so we'll "comment out" tagged links by adding a space after href=, which we'll later remove...
		find "$MYPATH" -type f -exec \sed -i "s/href=\"\([^#\"]*\)\(#[^\"]*\)*\"/href=\"\1\&$GLT\2\"/g" {} + # ...tag remaining links, which (1) don't have any GLT and (2) include "?" (so we introduce the GLT with "&")...
		find "$MYPATH" -type f -exec \sed -i "s/href= \"\([^\"]*utm_[^\"]*\)\"/href=\"\1\"/g" {} + # ...and remove that space after "href="
fi
if [[ "$ADDTARGETBLANK" = "y" || "$ADDTARGETBLANK" = "Y" ]]
	then
		find "$MYPATH" -type f -exec \sed -i "s/href=\"\([^\"]*\)\">/href=\"\1\" target=\"_blank\">/g" {} + # Append target="_blank"
fi
echo "Done! Click back to your file(s), and reload if prompted."