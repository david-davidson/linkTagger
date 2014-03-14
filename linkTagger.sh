#!/bin/bash
# If you encounter an error the first time you run the script, you'll need to convert the line breaks from DOS to Unix. Cd into the directory where the script lives, and strip the problem line breaks with this command: sed -i 's/\r//g' linkTagger.sh
MYPATH="/cygdrive/c/users/david.davidson/desktop/linkTagger" # The script's replacement commands are recursive--they tag not only all the files in the current working directory, but all the files in all the *folders* in there, too. For that reason, the recommended behavior is conservative: replace MYPATH with the single directory where you'd like to tag files (not the desktop!), and put files there when you want to tag them. If you'd like to run the script in the current working directory, though, you can set MYPATH to "."
echo "Enter the source:"
read SOURCE
echo "Enter the medium:"
read MEDIUM
echo "Enter the content:"
read CONTENT
echo "Enter the campaign:"
read CAMPAIGN
echo "Append target=\"_blank\"? y/n"
read ADDTARGETBLANK
SOURCE="?utm_source=$SOURCE"
MEDIUM="&utm_medium=$MEDIUM"
CONTENT="&utm_content=$CONTENT"
CAMPAIGN="&utm_campaign=$CAMPAIGN"
GLT="$SOURCE$MEDIUM$CONTENT$CAMPAIGN"
GLT=${GLT,,} # lowercase the string
GLT=${GLT//\&/\\&} # Escape the ampersands
GLT=${GLT//\./\\.} # Escape the periods
ALTGLT=${GLT//\?/\\&} # Create alternative version that starts with &, not ?
find $MYPATH -type f -exec \sed -i "s/href=\"\([^?#\"]*\)\(#[^\"]*\)*\(\?[^\"]*\)\"/href=\"\1\3\2\"/g" {} + # If a previously tagged link puts an ID before the GLT, reverse the two
find $MYPATH -type f -exec \sed -i "s/href=\"\([^?#\"]*\)\(#[^\"]*\)*\"/href=\"\1$GLT\2\"/g" {} + # Tag all the links that don't include "?"; if there's a section ID, put the GLT before it.
find $MYPATH -type f -exec \sed -i "s/href=\"\([^\"]*utm_[^\"]*\)\"/href= \"\1\"/g" {} + # "Comment out" previously tagged links. (Sed doesn't support negative lookaheads, so we can't do something like [ href="([^?#"]*)\?(?!.*?utm_).*?([^#]*?)*?" ]; instead, we add [and later remove] a space after "href=", which addition hides matching links from the next regex. [If the undo somehow fails, browsers still render links with a space after "href=".])
find $MYPATH -type f -exec \sed -i "s/href=\"\([^#\"]*\)\(#[^\"]*\)*\"/href=\"\1$ALTGLT\2\"/g" {} + # Tag links that (1) include "?" and (2) don't have any GLT; introduce the GLT with "&", not "?".
find $MYPATH -type f -exec \sed -i "s/href= \"\([^\"]*utm_[^\"]*\)\"/href=\"\1\"/g" {} + # Remove that space after "href=" in previously tagged links.
if [ "$ADDTARGETBLANK" = "y" ]
	then
		find $MYPATH -type f -exec \sed -i "s/href=\"\([^\"]*\)\">/href=\"\1\" target=\"_blank\">/g" {} +
fi
echo "Done. Click back to your file(s), and reload if prompted!"