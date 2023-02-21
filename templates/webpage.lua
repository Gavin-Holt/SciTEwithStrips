-- Lets keep it clean

require("extensions")               -- Add to Lua standard libraries
require("html")                     -- Functions to generate web pages
-- require("conf")                     -- Project level modifications

html.HTMLbody = {
"Hello World"
}

html.serve(html)
