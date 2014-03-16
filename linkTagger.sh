#!/bin/bash

# Two-step setup:
# 1. Change MYPATH (line 8) to the folder where you'd like to tag files. Note that the script tags not only all the files in the chosen directory, but also all the files in *all the directories* in there, too. (Of course, if you'd like to run the script in the current working directory, you can set MYPATH to "."--just don't run it in, say, the desktop!)
# 2. If you encounter an error the first time you run the script, you probably need to convert the line endings. Cd into the directory where the script lives, and run this command: "sed -i 's/\r//g' linkTagger.sh"
# Oh, and you might as well set up an alias to run this: "alias glt='absolute/path/to/script/linkTagger.sh'" or something

MYPATH="/cygdrive/c/users/david.davidson/desktop/filesToTag"
printf "Enter n to build new GLT, or e to paste in existing GLT:\n" # If you enter nothing, it'll just make sure that all section IDs are at the very end of URLs and, if you want, add target="_blank"
read MODE
if [[ "$MODE" = "e" || "$MODE" = "E" ]]
	then
	TAG="true"
	echo "Right-click and paste in your GLT:" ; read GLT
	GLT=${GLT/\?/} # Get rid of the leading question mark (if there is one), because we might occasionally need to lead with an ampersand
elif [[ "$MODE" = "n" || "$MODE" = "N" ]]
	then
	TAG="true"
	echo "Enter the source:" ; read SOURCE
	echo "Enter the medium:" ; read MEDIUM
	echo "Enter the content:" ; read CONTENT
	echo "Enter the campaign:" ; read CAMPAIGN
	SOURCE="utm_source=$SOURCE"
	MEDIUM="utm_medium=$MEDIUM"
	CONTENT="utm_content=$CONTENT"
	CAMPAIGN="utm_campaign=$CAMPAIGN"
	GLT="$SOURCE&$MEDIUM&$CONTENT&$CAMPAIGN"
	GLT=${GLT,,} # lowercase the string
fi
GLT=${GLT//&/\\&} # Escape the ampersands
GLT=${GLT////\\/} # Escape slashes
GLT=${GLT// /} # Remove spaces, just in case
printf "\nAppend target=\"_blank\"? y/n\n" ; read ADDTARGETBLANK
find "$MYPATH" -type f -exec \sed -i "s/a\(.*\?\)href=\"\([^?#\"]*\)\(#[^\"]*\)*\(?[^\"]*\)\"/a\1href=\"\2\4\3\"/g" {} + # Move all section IDs to the end of their links
if [[ "$TAG" = "true" ]]
	then
	find "$MYPATH" -type f -exec \sed -i "s/a\(.*\?\)href=\"\([^?#\"]*\)\(#[^\"]*\)*\"/a\1href=\"\2?$GLT\3\"/g" {} + # Tag all the links that don't include "?"; introduce the GLT with "?"; if there's a section ID, keep it at the end
	find "$MYPATH" -type f -exec \sed -i "s/href=\"\([^\"]*utm_[^\"]*\)\"/href= \"\1\"/g" {} + # What about links that include "?" but don't include GLT? sed doesn't support negative lookahead, so we'll "comment out" tagged links by adding a space after href=, which we'll later remove...
	find "$MYPATH" -type f -exec \sed -i "s/a\(.*\?\)href=\"\([^#\"]*\)\(#[^\"]*\)*\"/a\1href=\"\2\&$GLT\3\"/g" {} + # ...tag remaining links, which (1) don't have any GLT and (2) include "?" (so we introduce the GLT with "&")...
	find "$MYPATH" -type f -exec \sed -i "s/href= \"\([^\"]*utm_[^\"]*\)\"/href=\"\1\"/g" {} + # ...and remove that space after "href="
fi
if [[ "$ADDTARGETBLANK" = "y" || "$ADDTARGETBLANK" = "Y" ]]
	then
	find "$MYPATH" -type f -exec \sed -i "s/a\(.*\?\)href=\"\([^\"]*\)\">/a\1href=\"\2\" target=\"_blank\">/g" {} + # Append target="_blank"
fi
printf "\nDone! Click back to your file(s), and reload if prompted.\n"