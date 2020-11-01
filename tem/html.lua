-- This is a template for my latest 15-09-2020 version
-- Create html{} and w{} - (which are actually the same table)
dofile([[P:\MyPrograms\PROFILE\Tools\lua\lua\html\init.lua]])

html.Title = "My First Web Page"
html.HTMLbody = {
w.h1("Title of my masterpiece")..
w.h2("Subtitle of my masterpiece")..
"This is the first paragraph of the first page of the rest of my life.",
"again we stray into the dark world of html"..
w.footnote("help is there anybody out there")..
"more stuff to learn"..
w.footnote("nobody else here")..
"last line",
}

-- Output for tinyweb
html:serve()
-- Saved copy of generated file
html:save([[P:\MyPrograms\EDITORS\SciTE\tem\test\test.html]])
