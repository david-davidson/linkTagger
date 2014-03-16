linkTagger.sh
=============

####Automation tool for Google link tagging

This shell script makes tagging links faster&mdash;way faster. It uses sed, the regular expression&ndash;powered stream editor, to <strong>tag all your links in all your files at once</strong>. Just drop the files or directories you want to tag into the directory of your choice, and then run linkTagger.sh from your Linux or Cygwin terminal. The script will prompt you for GLT parameters (or preexisting GLT) and take it from there!

linkTagger knows:
* To add GLT before section IDs, not after
* To fix previously tagged links that put a section ID in the middle of the URL, not at the end
* To introduce GLT with &ldquo;&&rdquo;, not &ldquo;?&rdquo;, when it follows non-GLT parameters that are already set off by a question&nbsp;mark
* Not to tag links that are already tagged
* Not to tag nonanchor links (like those to a stylesheet or a typeface&nbsp;provider)
* To add target="_blank"&mdash;but only after asking!

That is, it&rsquo;ll tag, say, this: 
`<a href="http://www.test.com#contact?p=home">`

Like this: 
`<a href="http://www.test.com?p=home&utm_source=var1&utm_medium=var2`
`&utm_content=var3&utm_campaign=var4#contact" target="_blank">`