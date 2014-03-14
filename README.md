linkTagger
==========

####Automation tool for Google link tagging

This bash script makes tagging links faster&mdash;way faster. Just drop the files you want to tag into the folder of your choice, and then run linkTagger from your Linux or Cygwin terminal. The script will prompt you for GLT parameters and take it from there!

linkTagger knows:
* To add GLT before section IDs, not after
* To fix previously tagged links that put a section ID in the middle of the URL, not at the end
* Not to add new tagging to links that are already tagged
* To introduce GLT with &ldquo;&&rdquo;, not &ldquo;?&rdquo;, when it follows non-GLT parameters that are already set off by a question&nbsp;mark
* To add target="_blank"&mdash;but only after asking!

That is, it&rsquo;ll tag, say, this: 
`<a href="http://www.test.com#contact?p=home">`

Like this: 
`<a href="http://www.test.com?p=home&utm_source=var1&utm_medium=var2`
`&utm_content=var3&utm_campaign=var4#contact" target="_blank">`