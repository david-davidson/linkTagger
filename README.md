linkTagger.sh
=============

###Tag all your links at once!

This shell script makes tagging links faster&mdash;way faster. It uses sed, the regular expression&ndash;powered stream editor, to tag all the links in all the files in the directory of your choice. Just copy the files (or whole directories) you want to tag into your tagging directory, and then run linkTagger.sh from your Linux or Cygwin terminal. The script will prompt you for GLT parameters (or preexisting GLT) and take it from there!

<strong>linkTagger knows:</strong>
* To add GLT before section IDs, not after
* To fix previously tagged links that put a section ID anywhere but the very end of the&nbsp;URL
* To introduce GLT with &ldquo;&&rdquo;, not &ldquo;?&rdquo;, when it follows other link parameters that are already set off by a question&nbsp;mark
* Not to tag links that are already tagged
* Not to tag nonanchor links, like those to a stylesheet or a typeface&nbsp;provider

That is, it&rsquo;ll tag, say, this: 
`<a href="http://www.test.com#contact?siteid=a">`

Like this: 
`<a href="http://www.test.com?siteid=a&utm_source=var1&utm_medium=var2`
`&utm_content=var3&utm_campaign=var4#contact">`