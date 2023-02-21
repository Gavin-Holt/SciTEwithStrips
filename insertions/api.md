NB. Use -- As line comment in this file, it will allow stripping out comments on insertion
Transclude Base:.
Title: This is markdown!
*text*  -- Italic
**text** -- Bold
***text*** -- Bold Italic
`text` -- Inline Code
^text^ -- Superscript (also EOL terminated) e.g. E=mc^2
~text~ -- Subscript (also EOL terminated) e.g. C~14
<http://text> -- Clickable url e.g. <http://fletcherpenney.net/mmd>
[%text] -- Variable defined in metadata e.g. Title: [%Title]
[#text] -- In line Citation e.g. [#John Doe. *A Totally Fake Book*.  Vanity Press, 2006.]
[^text] -- In line Footnote e.g. [^John Doe. *A Totally Fake Book*.  Vanity Press, 2006.]
[?(term) text]  -- In line Glossary e.g. [?(Autoindent) Return replicates preceding line indent]
[link] -- Internal link [link] e.g. [InLine]
[text](url) -- External link e.g. [MMD](https://fletcher.github.io/MultiMarkdown-6/)
[text][id] -- External link via id e.g. [id]: https://fletcher.github.io/MultiMarkdown-6/
[id]: http://fletcherpenney.net/mmd
\# text \[id\] -- Header with link id, note the space e.g. # Introduction [Chapter1Intro]
--- -- Horizontal rule
[id]: -- Define variable to use in image, link definitions
[--]: Some text -- Line comment abusing the id definition process
[>]: -- Define abbreviation for roll-over display e.g. HTML 
[>HTML]:Hypertext Markup Language
```{{filename}}``` -- Unprocessed inclusion
{{filename}}    -- Transclusion of filename.md - does not work with piped input
![alt text](\path "title") -- Image e.g. ![Micro Icon](micro.jpg "Some rollover text")
$(html.toc("Title")) -- Table of contents in details tag
$()  -- Insert Lua variable, or the string result of running Lua code in UPP.exe
:()  -- Add Lua code to project, good for require and function definitions