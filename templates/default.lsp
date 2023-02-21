-- Load the page generation package:
require("page")  -- extensions{} web{} widget{} page{} page.backup() page.make()

-- Run a local template overlay
-- require("page\\BoardPaperTemplate")
-- require("page\\BoardPaperTemplate")
-- require("page\\BoardPaperDraftTemplate")
require("page\\Minimalist")

-- Set the output page.Name and path
page.Name="page.html"
page.Path=io.scriptpath()

-- Backup current version
page.backup(page) --if exists "ver" directory

-- Customize title
page.Title="Project Management"
page.HTML={ "Hello World",

}
page.make(page)
