-- ***Welcome***
-- An experimental setup for SciTE with the following aims:
--  Remove dependency upon binary addins - i.e. DLLs
--  Minimal use of external tools - annotated with **
--  Remove extman dependency
--  Maximise Lua customisation
--      Custom OnKey handler - catches all key presses outside menu and dialog boxes
--      Custom OnDoubleClick handler - action dependent upon indicators
--      Short function names for use in a Command Strip
--      Replace as many floating dialogs as possible - with strips
--  Consistent UI for strips
--      Only one visible strip at a time - is proving difficult!
--      Remember last entry - across buffers
--      Repeat with enter
--      Dismiss with esc
--  Platform for my extensions to the string library for modal/macro editing
--      See scite.Block* functions

--  Expected directory structure
--      SciteDefaultHome
--          confSciTE/mac     Macros
--          confSciTE/mod     Modified properties files
--          ctags
--          dictionary
--          help
--          history
--          hunspell
--          insertions
--          snippets
--          templates

--  View this file with all folds closed and it make more sense

require("extensions")                   -- Simple additions to Lua for Command Strip

-- ***Modifications for Lua version***
if not loadstring then
    -- Make loadstring                  -- Assume Scite >=4.4.4 i.e. Lua 5.3
    loadstring = load
else
    -- Make scite constants             -- Assume Scite 3.7.5 i.e. Lua 5.1
    for i=1,5050 do
        if pcall(scite.ConstantName,i) then
            _G[scite.ConstantName(i)]=tonumber(i)
        end
    end
end

-- ***Extensions to Lua***
-- Overloading of the Lua Standard Libraries may be considered tasteless https://stackoverflow.com/a/2032066
function string.split(text, sep)        -- Everybody need this!
-- Splits for a single character e.g. , or /
-- https://stackoverflow.com/questions/1426954/split-string-in-lua
    if sep == nil then
        sep = "%s"
    end

    local t={}
    local i=1

    for str in string.gmatch(text, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end

    if i>1 then
        return t
    else
        return text
    end
end
function table.dedup(t)                 -- Remove table duplicates
-- Remove duplicate v
	local hash = {}
	local res = {}

	for _,v in ipairs(t) do
        v = string.lower(v)
        if (not hash[v]) then
	       res[#res+1] = v -- you could print here instead of saving to result table if you wanted
	       hash[v] = true
	   end
	end

	return res
end
function table.length(t)                -- Length of array/table
  local count = 0
  for _ in pairs(t) do count = count + 1 end
  return count
end
function os.datestamp(date1)            -- Returns my date stamp  e.g. 201507_28_70089

	--	e.g. print(os.datestamp())
    if date1 and date1~="" then
        if os.datevalid(date1) then
            local v, d, m, y = os.datevalid(date1)
            return os.date("%Y%m_%d_",os.time({year=y,month=m,day=d}))
        else
            return nil
        end
    else
        local t = os.date("*t",var)
        local sec = ((t.hour*60*60)+(t.min*60)+(t.sec))
        return os.date("%Y%m_%d_"..sec)
    end
end
function io.exists(filename)            -- Tests for file or directory
-- io.exists(filename or directory)
    if type(filename)~="string" then
	    return false
    end
    return os.rename(filename,filename) and true or false
    -- Source: http://stackoverflow.com/questions/4990990/lua-check-if-a-file-exists
end
function io.mkdir(path)                 -- Create directory - parent must exist!
-- io.mkdir(path) - an extension to create a directory absolute or relative
    os.execute("mkdir " .. path)
end
function io.dir(dir)                    -- Returns the first 1000 files
    -- Validate parameters
    if type(dir)~="string" then return end
    -- Check path ending
    if string.find(dir,"*") or string.find(dir,"?") then
                                -- Do nothing assume full glob
    else
        if string.sub(dir,-1)==[[\]] then
            dir = dir..[[*.*]]  -- Ensure files are found
        else
            dir = dir..[[\*.*]] -- Assume this is a directory
        end
    end

    local h = io.popen('dir "'..dir..'" /a-d/b/s ')
    local ret = {}
    for file in h:lines() do
        table.insert(ret,file)
        if #ret > 1000 then break end
    end
    h:flush()
    h:close()
    return ret
end
function debug.which(funcname)          -- Returns the source file + line of the function
--  identifies the source for the current definition of funcname
--  designed for the console, has been modified to return a string
--
    if type(funcname)~="function" then
	    return  tostring(funcname).. ": is a "..type(funcname)
    end

    local info = _G.debug.getinfo(funcname)
    if info.short_src=="[C]" then
        return "Compiled "..info.short_src.." code:"
    else
        return info.short_src..":"..info.linedefined..":"
    end
end
function math.toBIN(num)                -- Return binary string
    local t={}
    while num>0 do
        rest=math.fmod(num,2)
        t[#t+1]=rest
        num=math.floor((num-rest)/2)    -- For Lua 5.1 compatible
    end

    return string.reverse(table.concat(t,""))
end

-- ***A pipeline of string functions to allow macros and modal editing***
-- These functions work on \n separated lines of text - THEY ARE NOT NORMAL LUA STRING FUNCTIONS
function string.pre(text,prefix)        -- Prefix each line
    -- Prefix each line, assume line or block selection
    -- Check for conditional execution
    if text=="\b" or text=="\a" then
        return text
    end
    return prefix..text:gsub("\n","\n"..prefix)
end
function string.post(text,postfix)      -- Postfix each line
    -- Postfix each line, assume line or block selection
    -- Check for conditional execution
    if text=="\b" or text=="\a" then
        return text
    end
    return text:gsub("\n",postfix.."\n")..postfix
end
function string.unpre(text,n)           -- Remove n char prefix
    -- UnPrefix each line, to n characters
    -- Check for conditional execution
    if text=="\b" or text=="\a" then
        return text
    end
    return text:gsub("\n"..string.rep(".",n),"\n"):gsub("^"..string.rep(".",n),"")
end
function string.unpost(text,n)          -- Remove n char postfix
    -- UnPostfix each line, assume line or block selection
    -- Check for conditional execution
    if text=="\b" or text=="\a" then
        return text
    end
    string.rep(".",n)
    return text:gsub(string.rep(".",n).."\n","\n")
end
function string.ltrim(text)             -- Trim left each line
    -- Left trim lines in multiline text
    -- Check for conditional execution
    if text=="\b" or text=="\a" then
        return text
    end
    return text:gsub("\n%s*", "\n"):gsub("^%s*", "")
end
function string.rtrim(text)             -- Trim right each line
    -- Left trim lines in multiline text
    -- Check for conditional execution
    if text=="\b" or text=="\a" then
        return text
    end
    return text:gsub("%s+\n", "\n"):gsub("%s+$", "")
end
function string.trim(s)                 -- Trim both each line
    -- Check for conditional execution
    if text=="\b" or text=="\a" then
        return text
    end
    return s:match('^%s*(.-)%s*$')
end
function string.pcase(text)             -- Proper case
    -- Convert to proper case http://lua-users.org/wiki/StringRecipes
    -- Check for conditional execution
    if text=="\b" or text=="\a" then
        return text
    end
    local function tchelper(first, rest)
        return first:upper()..rest:lower()
    end
    text = string.gsub(text, "(%a)([%w_']*)", tchelper)
    return text
end
function string.wrap(text,left,right)   -- Enclose text
    -- Check for conditional execution
    if text=="\b" or text=="\a" then
        return text
    end

    -- This works for sel(), word(), line()
    return text:gsub("^.",left.."%1"):gsub(".$","%1"..right)

end
function string.dedup(text)             -- Remove duplicate lines
    -- Removes duplicated lines delimited by \n
    -- Check for conditional execution
    if text=="\b" or text=="\a" then
        return text
    end
    local function split(inputstr, sep)
    -- Splits for a single character e.g. , or /
    -- https://stackoverflow.com/questions/1426954/split-string-in-lua
        if sep == nil then
            sep = "%s"
        end

        local t={}
        local i=1

        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            t[i] = str
            i = i + 1
        end

        if i>1 then
            return t
        else
            return inputstr
        end
    end
    local t = split(text,"\n")
    local hash = {}
	local res = {}

	for _,v in ipairs(t) do
        v = string.lower(v)
        if (not hash[v]) then
            res[#res+1] = v
            hash[v] = true
        end
	end
	return table.concat(res,"\n")
end
function string.del(text)               -- Delete current selection
	-- Send the "\b" delete signal unless test is the "\a" signal
    if text=="\a" then
        return "\a"
    else
        return "\b"
    end
end
function string.sort(text,functionORtag)-- Sort lines with \n
    -- This is sorting lines within a string containing \n EOL
    -- Check for conditional execution
    if text=="\b" or text=="\a" then
        return text
    end
    -- Check for text
    if not text or text=="" then return end
    -- Make a table to sort
    local t = string.split(text,"\n")
    -- Check for function
    if functionORtag and type(functionORtag)=="function" then
        table.sort(t,functionORtag)
        return table.concat(t,"\n")
    end
    if not functionORtag then
        table.sort(t,function(a,b) return string.lower(a) < string.lower(b) end)
        return table.concat(t,"\n")
    end
    if functionORtag and functionORtag=="chara" then
        table.sort(t,function(a,b) return string.lower(a) < string.lower(b) end)
        return table.concat(t,"\n")
    end
    if functionORtag and functionORtag=="chard" then
        table.sort(t,function(a,b) return string.lower(a) > string.lower(b) end)
        return table.concat(t,"\n")
    end
    if functionORtag and functionORtag=="inta" then
        table.sort(t,function(a,b) return tonumber(string.match(a,"%d+")) < tonumber(string.match(b,"%d+")) end)
        return table.concat(t,"\n")
    end
    if functionORtag and functionORtag=="intd" then
        table.sort(t,function(a,b) return tonumber(string.match(a,"%d+")) > tonumber(string.match(b,"%d+")) end )
        return table.concat(t,"\n")
    end
end
function string.min(text)               -- Removes empty lines
    -- Check for conditional execution
    if text=="\b" or text=="\a" then
        return text
    end
    return text:gsub("\n\n","\n")
end
function string.sum(text)               -- Find digits and add them up
    -- Summate all digits in string
    -- Check for conditional execution
    if text=="\b" or text=="\a" then
        return text
    end
    local sum = 0
    -- This only finds decimals
    -- for match in text:gmatch("%d+.%d+") do
    -- https://stackoverflow.com/questions/6192137/how-to-write-this-regular-expression-in-lua
    for match in text:gmatch("%f[%.%d]%d*%.?%d*%f[^%.%d%]]") do
        sum = sum + tonumber(match)
    end
    return tostring(sum)
end
function string.eval(text,s)            -- Run as Lua with text as variable
    -- Evaluate parameter as lua
    -- Check for conditional execution
    if text=="\b" or text=="\a" then
        return text
    end
    -- Pass text as no access to local variables within load
    local f, err = loadstring("do local text= [["..text.."]] "..s.." end")
    if type(f)=="function" then
        return f()
    end
end
function string.call(text,f)            -- Call function with text as parameter
    -- Check for conditional execution
    if text=="\b" or text=="\a" then
        return text
    end
    if type(f)=="function" then
        return f(text)
    end
end
function string.iff(text,...)           -- Conditional execution
    -- Conditional execution using the "\a" abandon signal
    if text=="\b" or text=="\a" then
        return text
    end
    -- Variadic form send text if any match of arg in text
    local arg={...}
    if #arg<1 then
        return nil
    end

    for _,v in pairs(arg) do
        if text:match(v) then
            return text
        end
    end

    -- Fall through
    return "\a"
end
function string.iffnot(text,...)        -- Conditional execution
    -- Variadic form send "\a" if all values of arg match text
    -- Check for conditional execution
    if text=="\b" or text=="\a" then
        return text
    end
    local arg={...}
    if #arg<1 then
        return nil
    end

    local ret = 0
    for i,v in pairs(arg) do
        if text:match(v) then
            ret = ret + 1
        end
    end

    if ret==#arg then
        return "\a"
    end

    -- Fall through
    return text
end
-- Start a string processing pipe in SciTE:
function sel()                          -- Return current selection
    -- Return the current selection with \n for EOL
    local text, len = editor:GetSelText()

    -- Do not default to line as we will use sel() as a test for a selection
    if not text or len<1 then
        return nil
    end

    -- Convert EOL to \n
    text = text:gsub("\r?\n\r?", "\n")
    -- We will convert back in string.ins()

--     editor:BeginUndoAction()   -- This is paired with the string.ins()

    return text
end
function word()                         -- Select and return current word forwards
    local function isWordChar(char)
        local strChar = string.char(char)
        local beginIndex = string.find(strChar, '%w')
        if beginIndex ~= nil then
            return true
        end
        if strChar == '_' or strChar == '$' then
            return true
        end

        return false
    end

    local beginPos = editor.CurrentPos
    local endPos = beginPos
    if editor.SelectionStart ~= editor.SelectionEnd then
        return editor:GetSelText()
    end
    while isWordChar(editor.CharAt[beginPos-1]) do
        beginPos = beginPos - 1
    end
    while isWordChar(editor.CharAt[endPos]) do
        endPos = endPos + 1
    end

    editor:SetSel(beginPos,endPos)

    local text = sel()
    return text
end
function drow()                         -- Select and return current word backwards
    local function isWordChar(char)
        local strChar = string.char(char)
        local beginIndex = string.find(strChar, '%w')
        if beginIndex ~= nil then
            return true
        end
        if strChar == '_' or strChar == '$' then
            return true
        end

        return false
    end

    local beginPos = editor.CurrentPos
    local endPos = beginPos
    if editor.SelectionStart ~= editor.SelectionEnd then
        return editor:GetSelText()
    end
    while isWordChar(editor.CharAt[beginPos-1]) do
        beginPos = beginPos - 1
    end
    while isWordChar(editor.CharAt[endPos]) do
        endPos = endPos + 1
    end

    editor:SetSel(endPos,beginPos)

    local text = sel()
    return text
end
function block()                        -- Select and return current block
    scite.BlockSelect()

    local text = sel()
    return text
end
function line()                         -- Select and return current/next line
    -- Use the current line
    scite.SendEditor(SCI_HOME)
    scite.SendEditor(SCI_LINEENDEXTEND)

    local text = sel()
    return text
end
function para()                         -- Select and return current paragraph
    -- Use the current paragraph
    scite.SendEditor(SCI_PARAUP)
    scite.SendEditor(SCI_PARADOWNEXTEND)
    scite.SendEditor(SCI_CHARLEFTEXTEND)
    scite.SendEditor(SCI_CHARLEFTEXTEND)

    -- Note this selects upto the next para

    local text = sel()
    return text
end
function rest()                         -- Select and return to EOF
    -- Select down to EOF
    scite.SendEditor(SCI_DOCUMENTENDEXTEND)

    local text = sel()
    return text
end
function above()                        -- Select and return to BOF
    -- Select upto BOF
    scite.SendEditor(SCI_DOCUMENTSTARTEXTEND)

    local text = sel()
    return text
end
function all()                          -- Select and return all
    -- Select the whole buffer
    scite.SendEditor(SCI_SELECTALL)

    local text = sel()
    return text
end
-- Midstream function to send text to output window in SciTE:
function string.trace(text)             -- Print to output text from pipe or alternate
    -- Intercept \a abandon command
    if text=="\a" then
        return
    end

     -- Intercept \b - delete command - ignore
     if text=="\b" then
        return
     end

    -- Insert the text
    output:AddText(text)
    return text
end
-- End a string processing pipe in SciTE:
function string.ins(text,text2)         -- Insert text from pipe or alternate
    -- Intercept \a abandon command
    if text=="\a" then
        if text2 then
            -- We will insert text2
            text = text2
        else
            return
        end
    end

     -- Intercept \b - delete command
     if text=="\b" then
         if not editor:GetSelText() then
             return
         else
             scite.MenuCommand(IDM_CLEAR)
             return
         end
     end

    -- Remember selection
     local start, finish  = editor.SelectionStart, editor.SelectionEnd

     -- Delete selection
     if not editor:GetSelText() then
         return
     else
         scite.MenuCommand(IDM_CLEAR)
     end

    -- Insert the text at the cursor
    editor:AddText(text)

    -- Reselect text
    editor:SetSelection(start+string.len(text), start)

    -- Convert back the EOLs
    scite.MenuCommand(IDM_EOL_CONVERT)
end
function string.clip(text)              -- Load clipboard

    -- EOL ??
    -- Copy result to clipboard
    if text then
        editor:CopyText(text)
    end
    --     editor:EndUndoAction()
end

-- ***Additional lua functions in SciTE***
function ins(text)                      -- Insert text at current position
    editor:AddText(text)
end
function del()                          -- Delete selection
    scite.MenuCommand(IDM_CLEAR)
end
function paste()                        -- Inserts clipboard contents
    editor:paste()
end
function copy(text)                     -- Copy text/variable text to clipboard
    -- EOL ??
    -- Copy result to clipboard
    if text then
        editor:CopyText(text)
    end
end
function SetClipboard(text)             -- Renamed function for consistency
    copy(text)
end
function GetClipboard()                 -- Return the contents of the clipboard
    local file = io.popen("paste.exe", "r")
    local contents = file:read'*a'
    file:flush()
    file:close()
    return contents
end
function find(text,flags)               -- Also highlight text if found
    if not text then return end
    if not flags then
        flags  = 0                      -- Alter if you want regex as default
--         SCFIND_NONE
--         SCFIND_MATCHCASE
--         SCFIND_WHOLEWORD
--         SCFIND_WORDSTART
--         SCFIND_REGEXP
--         SCFIND_POSIX
    end

    -- Set anchor
    editor:SearchAnchor()

    -- Do find
    local start,finish = editor:findtext(text, flags, editor.CurrentPos)
    if start then
        -- Reverse selection to allow repeats
        editor:SetSelection(finish,start)

        -- Unfold into view
        editor:EnsureVisible(editor:LineFromPosition(start))

        -- Scroll into view
        editor:ScrollCaret()

        -- Store
        local text = sel()
        return text
    else
        return nil
    end
end

-- ***Global tables***
scite.CommandExclusions = {}            -- List of hidden functions in scite table
scite.KeyActions        = {}            -- Indexed store for Keyboard shortcuts
scite.ClickActions      = {}            -- Indexed store for DoubleClick events - not used yet
scite.UserListFunctions = {}            -- Indexed store for OnUserList events
scite.DefaultDOSCache   = {             -- Preload your favourites here!
    "dir /s/b",
    "which CMD",
    'shelexec.exe props["SciteDefaultHome"]',
    'props["FileDir"]\\makeit.bat',
    'props["FileDir"]\\ToDo.txt',

}
scite.DefaultLuaCache   = {             -- Preload your favourites here!
    "for i,v in pairs(scite) do print(i,v) end",
}

-- ***"Super global variables"***
-- Are held in props for access from all buffers

-- ***New scite functions***
function scite.New(filename)            -- Make a new file on disk
    if io.exists(filename) then
        scite.Open(filename)
        return
    end
    -- Test for path TODO:
    -- Make new empty file
    -- Close and flush
    -- Open this in scite

end
function scite.Colours(pal)             -- Ignore this if you have your own colour settings
-- Load a colour palette from a table

    -- Create a table for each palette using rgb hex values
    -- scite.Colours()
    local default = {
        ["colour.background"]           ="#000000",
        ["colour.foreground"]           ="#FFFFFF",
        ["fold.margin.colour"]          ="#000000",
        ["fold.margin.highlight.colour"]="#000000",
        ["colour.red"]                  ="#FFFFFF",
        ["colour.green"]                ="#FFFFFF",
        ["colour.blue"]                 ="#FFFFFF",
        ["colour.cyan"]                 ="#FFFFFF",
        ["colour.magenta"]              ="#FFFFFF",
        ["colour.yellow"]               ="#FFFFFF",
        ["caret.line.back.alpha"]       =""
    }

    if type(pal)=="string" then
    -- scite.Colours("Light")
        if pal=="Light" then
            pal = {
            ["colour.background"]           ="#FFFFFF",
            ["colour.foreground"]           ="#000000",
            ["fold.margin.colour"]          ="#FFFFFF",
            ["fold.margin.highlight.colour"]="#FFFFFF",
            ["colour.red"]                  ="#7F0000",
            ["colour.green"]                ="#007F00",
            ["colour.blue"]                 ="#00007F",
            ["colour.cyan"]                 ="#007F7F",
            ["colour.magenta"]              ="#7F007F",
            ["colour.yellow"]               ="#7F7F00",
            ["caret.line.back.alpha"]       =""
            }
        end
        if pal=="Dark" then
        -- scite.Colours("Dark")
            pal = {
            ["colour.background"]           ="#000000",
            ["colour.foreground"]           ="#FFFFFF",
            ["fold.margin.colour"]          ="#000000",
            ["fold.margin.highlight.colour"]="#000000",
            ["colour.red"]                  ="#7F0000",
            ["colour.green"]                ="#007F00",
            ["colour.blue"]                 ="#00007F",
            ["colour.blue"]                 ="#0000FF",
            ["colour.cyan"]                 ="#007F7F",
            ["colour.magenta"]              ="#7F007F",
            ["colour.yellow"]               ="#7F7F00",
            ["caret.line.back.alpha"]       ="50"
        }
        end
        if pal=="FTE" then
        -- scite.Colours("FTE")
            pal = {
            ["colour.background"]           ="#004480",
            ["colour.foreground"]           ="#c0c0c0",
            ["fold.margin.colour"]          ="#004480",
            ["fold.margin.highlight.colour"]="#004480",
            ["colour.red"]                  ="#7F0000",
            ["colour.green"]                ="#007F00",
            ["colour.blue"]                 ="#008080",
            ["colour.cyan"]                 ="#007F7F",
            ["colour.magenta"]              ="#FF00FF",
            ["colour.yellow"]               ="#7F7F00",
            ["caret.line.back.alpha"]       ="50"
            }
        end
        if pal=="Sol" then
        -- scite.Colours("Sol")
            pal = {
            ["colour.background"]           ="#004480",
            ["colour.foreground"]           ="#AFAEA3",
            ["fold.margin.colour"]          ="#004480",
            ["fold.margin.highlight.colour"]="#004480",
            ["colour.red"]                  ="#DE3330",
            ["colour.green"]                ="#869A01",
            ["colour.blue"]                 ="#278CD3",
            ["colour.cyan"]                 ="#2BA299",
            ["colour.magenta"]              ="#D43883",
            ["colour.yellow"]               ="#B68A01",
            ["caret.line.back.alpha"]       ="50"
            }
        end
    end

    -- Load the selected palette
    if type(pal)=="table" then
        for i,v in pairs(pal) do
            props[i]=v
        end
    else
        for i,v in pairs(default) do
            props[i]=v
        end
        print("Colour palette not found, using defaults!")
    end

    -- Map the colours to specific elements
    props["colour.brace.highlight"]          ="fore:"..props["colour.green"]
    props["colour.brace.incomplete"]         ="fore:"..props["colour.yellow"]
    props["colour.code.comment.box"]         ="fore:"..props["colour.green"]
    props["colour.code.comment.line"]        ="fore:"..props["colour.green"]
    props["colour.code.comment.doc"]         ="fore:"..props["colour.foreground"]
    props["colour.code.comment.nested"]      ="fore:"..props["colour.foreground"]
    props["colour.text.comment"]             ="fore:"..props["colour.blue"]
    props["colour.other.comment"]            ="fore:"..props["colour.green"]
    props["colour.embedded.comment"]         ="fore:"..props["colour.foreground"]
    props["colour.embedded.js"]              ="fore:"..props["colour.foreground"]
    props["colour.notused"]                  ="back:"..props["colour.red"]
    props["colour.number"]                   ="fore:"..props["colour.cyan"]
    props["colour.keyword"]                  ="fore:"..props["colour.blue"]
    props["colour.string"]                   ="fore:"..props["colour.magenta"]
    props["colour.char"]                     ="fore:"..props["colour.magenta"]
    props["colour.operator"]                 ="fore:"..props["colour.foreground"]
    props["colour.preproc"]                  ="fore:"..props["colour.yellow"]
    props["colour.error"]                    ="fore:"..props["colour.yellow"]
    props["fold.back"]                       =props["colour.background"]

    -- Refresh the current window - but not at startup when there is no editor window!
    if props["FilePath"]~="" then
        -- Set focus
        scite.SendEditor(SCI_GRABFOCUS)
        editor.Focus = true
        -- Colourize
        scite.SendEditor(SCI_COLOURISE,0, -1)
    end
end
scite.Colours("Light")                  -- Remove this to leave your colours alone
function scite.Message(text)            -- Single line message
    if text then
        scite.StripShow("  Message: "..text:gsub("\n"," "))
        scite.SendEditor(SCI_GRABFOCUS)
    end
end
function scite.CurrentWord(pos)         -- Return Word Under Cursor without changing selection
    if not pos then pos = editor.CurrentPos end
    local p2 = editor:WordEndPosition(pos,true)
    local p1 = editor:WordStartPosition(pos,true)
    if p2 > p1 then
        return editor:textrange(p1,p2)
    end
end
function scite.CurrentLineNumber(pos)   -- Return current editor line number
    if not pos then pos = editor.CurrentPos end
    return editor:LineFromPosition(pos)+1
end
function scite.BlockSelect()            -- Smart block selection
-- Extends the selection to the whole contents of all lines partly selected.
-- This is needed because the line selection mode includes char 1 on the next line
-- Note it will work even for reverse selection.

    -- If no selection select line
    if editor.SelectionStart == editor.SelectionEnd then
	    return editor.SelectionStart, editor.SelectionStart
    end
    -- If reverse selection then reselect
    if editor.SelectionStart > editor.SelectionEnd then
	    editor:SetSelection(editor.SelectionEnd,editor.SelectionStart)
    end
    -- If end col =1 then back to previous line
    if props["SelectionEndColumn"]==1 then
	    editor:SetSelection(editor.SelectionStart,editor.SelectionEnd-1)
    end
    -- If start col ~= 1 then extend to start of line
    if props["SelectionStartColumn"]~=1 then
	    editor:SetSelection(editor:PositionFromLine(editor:LineFromPosition(editor.SelectionStart)),editor.SelectionEnd)
    end
    -- If end col is not line end then extend
    if editor:LineFromPosition(editor.SelectionEnd)==editor:LineFromPosition(editor.SelectionEnd+1) then
	    editor:SetSelection(editor.SelectionStart,editor:PositionFromLine(editor:LineFromPosition(editor.SelectionEnd)+1)-1)
    end

    return editor.SelectionStart, editor.SelectionEnd
end
function scite.GetCache(Name)           -- Returns a table
    local RS = string.char(30)
    local t = string.split(props[Name],RS)
    if type(t)~="table" then
        return nil
    else
        return t
    end
end
function scite.SetCache(Name,t)         -- Stores an array
    local RS = string.char(30)
    props[Name]= table.concat(t,RS)
end
function scite.CloseStrips()            -- TODO: close builtin strips
    -- Close any single user strip
    scite.StripShow("")
--     -- Close builtin strips
--     if props["ActiveUserStrip"]=="FindInc" then
--         scite.MenuCommand(IDM_INCSEARCH)
--     elseif props["ActiveUserStrip"]=="Find" then
--         scite.MenuCommand(IDM_FIND)
--     elseif props["ActiveUserStrip"]=="Replace" then
--         scite.MenuCommand(IDM_REPLACE)
--     else
        -- print(props["ActiveUserStrip"])
--     end
    props["ActiveUserStrip"] = ""
end
function scite.DefineTool(name,cmd,files,subsystem)     -- Add a function to the tools menu
    -- Validate parameters
--     if not name or type(name)~="string" then return end
--     if not cmd then return end
--     if not (type(cmd)=="function" or cmd:match("^dostring ")) then return end
    if not files then files = "*" end
    if not subsystem then subsystem = 3 end

    -- Global to keep track of IDM number
    IDMCount = IDMCount or 0
    IDMCount = IDMCount + 1
    if IDMCount > 49 then
        print("Sorry there is a hard coded limit of 50 user defined tools.")
        return
    end

    -- Create handle
	local cmdHandle = "."..tostring(IDMCount).."."..files

    -- Add to props
	props["command.name"..cmdHandle]        = name      -- Overwrite previous commands
	props["command"..cmdHandle]             = cmd       -- A single function name or dostring statement
	props["command.subsystem"..cmdHandle]   = subsystem -- Lua subsystem
	props["command.mode"..cmdHandle] = "savebefore:no"  -- Do it explicitly if necessary
end
function scite.LoadDic(fname)           -- Load a list of words into an indexed table
    if not io.exists(fname) then return end
    local file = io.open(fname)
    local words = {}
    for line in io.lines(fname) do      -- Expected input is one word per line!
        if line and line~="" then       -- Filter blank lines
            words[line] = 1             -- Indexed for searching
        end
    end
    return words
end
function scite.SetIndicator(tag)        -- Define reusable indicators
    if tag=="spelling" then             -- For my spelling inidcators
        local indic = 20
        editor.IndicStyle[indic] = INDIC_SQUIGGLE
        editor.IndicFore[indic] = 0x0000ff
        editor.IndicAlpha[indic] = 100
        editor.IndicOutlineAlpha[indic] = 100
--         editor.IndicFlags[indic] = SC_INDICFLAG_VALUEFORE
        editor.IndicatorCurrent = indic
        return indic
    end
    if tag=="word" then                 -- For my M+Ctrl+Editor marks
        local indic = 21
        editor.IndicStyle[indic] = INDIC_ROUNDBOX
        editor.IndicFore[indic] = 0x1DCCAFF
        editor.IndicAlpha[indic] = 100
        editor.IndicOutlineAlpha[indic] = 100
--         editor.IndicFlags[indic] = SC_INDICFLAG_VALUEFORE
        editor.IndicatorCurrent = indic
        return indic
    end
    if tag=="found" then               -- TODO: check this is the correct indic
        local indic = 9
        editor.IndicStyle[indic] = INDIC_ROUNDBOX
        editor.IndicFore[indic] = 0x1DCCAFF
        editor.IndicAlpha[indic] = 100
        editor.IndicOutlineAlpha[indic] = 100
        editor.IndicFlags[indic] = SC_INDICFLAG_VALUEFORE
        editor.IndicatorCurrent = indic
        return indic
    end
end
function scite.Mark(target,mark)        -- Marks all occurrences with indicator
    -- Validate parameters
    if not target then
        return
    end
    if type(target)=="string" then
        target = {target}
    end
    if type(target)~="table" then
        return
    end

    -- Load predefined indicator properties
    local indic = scite.SetIndicator(mark)
    if not indic then
        print("Unknown indicator mark : "..mark)
        return
    end

    -- Clear previous marks of this type
    scite.SendEditor(SCI_INDICATORCLEARRANGE, 0, editor.Length)

    -- Find and mark
    for i,text in pairs(target) do
        local findflag = SCFIND_WHOLEWORD + SCFIND_MATCHCASE
        local s,e = editor:findtext(text,findflag,0)
        while s do
            scite.SendEditor(SCI_INDICATORFILLRANGE, s, e - s)
            s,e = editor:findtext(text,findflag,e+1)
        end
    end
end
function scite.Unmark(mark)             -- Clear marks in editor
    -- Load predefined indicator properties
    local indic = scite.SetIndicator(mark)
    if not indic then return end
    -- Clear previous marks of this type
    scite.SendEditor(SCI_INDICATORCLEARRANGE, 0, editor.Length)
end
do                                      -- Hide all above from the user command list (F9)
    for i,v in pairs(scite) do
        if type(v)=="function" then
            table.insert(scite.CommandExclusions,i)
            scite.CommandExclusions[i]=1
        end
    end
    props["check.if.already.open"]=1    -- See Open New Window below
end

-- ***Events and actions***
function OnClear()                      -- Fires every time Lua is reloaded
-- This happens OnSwitch
    scite.CloseStrips()
end
function OnOpen(fname)                  -- Capture filenames at open
    -- Close all strips
    scite.CloseStrips()
    -- Store list of files
    local BufferList = scite.GetCache("BufferList",BufferList) or {}
    table.insert(BufferList,1,fname)
    table.dedup(BufferList)
    scite.SetCache("BufferList",BufferList)
end
function OnSave()
    props["WordCount"] = scite.WordCount()
    scite.UpdateStatusBar()
end
function OnSwitchFile()                 -- Close strips on switch
    -- Close all strips
    scite.CloseStrips()                 -- Close all strips
end
function OnKey(KeyCode,Shift,Control,Alt)   -- Hand rolled shortcut handler

    local KeyIndex = ""

    -- Translate non-character codes (use status bar to see codes)
	local KeyTranslate = {
        [8]  = "Bspk",
        [9]  = "Tab",
        [13] = "Enter",
        [20] = "CapsLock",
        [27] = "Esc",
        [32] = "Space",
        [33] = "PgUp",
        [34] = "PgDn",
        [35] = "End",
        [36] = "Home",
        [37] = "Left",
        [38] = "Up",
        [39] = "Right",
        [40] = "Down",
        [45] = "Ins",
        [46] = "Del",
        [48] = ")",
        [56] = "*",
        [57] = "(",
        [112] = "F1",
        [118] = "F7",
        [119] = "F8",
        [120] = "F9",
        [186] = ":",
        [187] = "=",
        [188] = ",",
        [189] = "-",
        [190] = ".",
        [191] = "?",
        [192] = "'",
        [190] = ".",
        [219] = "[",
        [221] = "]",
        [222] = "#",
        [223] = "`",
        }

    -- Append keycode
	if KeyTranslate[KeyCode] then
        KeyIndex = KeyIndex..KeyTranslate[KeyCode]
	else
        KeyIndex = KeyIndex..string.char(KeyCode)
	end

    -- Add modifiers
	if Control then KeyIndex = KeyIndex.."+Ctrl" end
	if Alt then KeyIndex     = KeyIndex.."+Alt" end
	if Shift then KeyIndex   = KeyIndex.."+Shift" end

    -- Add modes
    if editor.Focus then
        KeyIndex = KeyIndex.."+Editor"
        if editor:AutoCActive() then
              KeyIndex = KeyIndex.."+AutoC"
        end
        if editor:CallTipActive() then
              KeyIndex = KeyIndex.."+CallTip"
        end
        -- Close any user strips
        scite.CloseStrips()

    elseif output.Focus then
        KeyIndex = KeyIndex.."+Output"
    else
        if props["ActiveUserStrip"] then
            KeyIndex = KeyIndex.."+"..props["ActiveUserStrip"]
        else
            KeyIndex = KeyIndex.."+Other"
        end
    end

    -- Display in status bar
    props["KeyCode"] = KeyCode
    props["KeyIndex"] = KeyIndex
    scite.UpdateStatusBar()

    -- Keep a log of lines edited - Only named files!
    if props.FilePath and props.FileNameExt then
        -- Get current location
        local Location = props.FilePath .. " @ " .. (editor:LineFromPosition(editor.CurrentPos))
        -- Get Location Cache
        local LocationCache = scite.GetCache("LocationCache") or {}
        -- Store if new
        if LocationCache[1]~=Location then
            table.insert(LocationCache,1,Location)
            scite.SetCache("LocationCache",LocationCache)
        end
    end

    -- Check for actions
    if scite.KeyActions[KeyIndex] then
        scite.KeyActions[KeyIndex]()
        return 1    -- Block native actions
    else
        return nil  -- Run native actions
    end
end
function SaveLocation()
    if props.FilePath and props.FileNameExt then
        -- Get current location
        local Location = props.FilePath .. " @ " .. (editor:LineFromPosition(editor.CurrentPos))
        -- Get Location Cache
        local LocationCache = scite.GetCache("LocationCache") or {}
        -- Store if new
        if LocationCache[1]~=Location then
            table.insert(LocationCache,1,Location)
            scite.SetCache("LocationCache",LocationCache)
        end
    end
end
function OnDoubleClick()                -- Find callback dependent upon styling indicators
    if output.Focus then return end     -- Default output double click behaviour

    local text = scite.CurrentWord()
    if not text then return end

    -- Detect text with indicators - spell checking
    local indicator = editor:IndicatorAllOnFor(editor.CurrentPos-1)
    if indicator>0 then
        if editor:IndicatorValueAt(scite.SetIndicator("word"),editor.CurrentPos-1) ~= 0 then
            -- Nothing at present
            print(text)
        end

        if editor:IndicatorValueAt(scite.SetIndicator("spelling"),editor.CurrentPos-1) ~= 0 then
            -- Offer suggestions
            scite.SuggestSpelling(scite.CurrentWord())
        end
    end

    -- Detect Proper case words - text wiki
    if text:sub(1,1):upper()..text:sub(2)==text and io.exists(props["FileDir"]..[[\]]..text..".txt") then
        scite.Open(props["FileDir"]..[[\]]..text..".txt")
        return 1
    end

    -- Detect Proper case words - markdown wiki
    if text:sub(1,1):upper()..text:sub(2)==text and io.exists(props["FileDir"]..[[\]]..text..".md") then
        scite.Open(props["FileDir"]..[[\]]..text..".md")
        return 1
    end


end
function OnUserListSelection(n,text)    -- Find callback dependent upon UserList "number"
    if scite.UserListFunctions[n] and type(scite.UserListFunctions[n])=="function" and text then
        scite.UserListFunctions[n](text)
        return
    elseif n and text then
        print("No scite.UserListFunctions["..n.."] to process "..text)
        return
    else
        print("Usage: ")
    end
end
function OnClose()                      -- CD SciteDefaultHome on close
--     os.execute("setx CD "..props["SciteDefaultHome"])
end

scite.KeyActions = {                    -- Keyboard Shortcuts  - Many Alt+Shift+Z
    -- Non alpha keys
    ["[+Ctrl+Editor"] = function()              -- Prefix
        scite.Prefix()
    end,
    ["]+Ctrl+Editor"] = function()              -- Postfix
        scite.Postfix()
    end,
    ["2+Ctrl+Editor"] = function()              -- Insert ""
        if sel() then
            sel():wrap([["]],[["]]):ins()
        else
            ins([[""]])
            scite.SendEditor(SCI_CHARLEFT)
        end
    end,
    ["(+Ctrl+Editor"] = function()              -- Insert ()
        if sel() then
            sel():wrap([[(]],[[)]]):ins()
        else
            ins([[()]])
            scite.SendEditor(SCI_CHARLEFT)
        end
    end,
    [")+Ctrl+Editor"] = function()              -- Insert ()
        if sel() then
            sel():wrap([[(]],[[)]]):ins()
        else
            ins([[()]])
            scite.SendEditor(SCI_CHARLEFT)
        end
    end,
    ["*+Ctrl+Shift+Editor"] = function()        -- Insert ****
        if sel() then
            sel():wrap([[*]],[[*]]):ins()
        else
            ins([[*]])
            scite.SendEditor(SCI_CHARLEFT)
        end
    end,
    ["*+Ctrl+Editor"] = function()              -- Find Current Word
        local text = sel() or scite.CurrentWord() or ""
        if not text or text == "" then return end
        find(text)
    end,
    ["=+Ctrl+Editor"] = function()              -- Eval using Lua =
        local text = editor:GetSelText()
        if string.len(text)<1 then
            scite.MenuCommand(IDM_SELECTTOBRACE) -- Select brace2brace
            local text = editor:GetSelText()
            if string.len(text)<1 then
                -- No function to select
                print("\nNo lua function to run")
                return
            end
            scite.SendEditor(SCI_WORDLEFTEXTEND) -- Select function word left
            -- Check for hyphen or dot in function name
            while editor.CurrentPos and (editor:textrange(editor.CurrentPos-1,editor.CurrentPos)=="."
            or editor:textrange(editor.CurrentPos-1,editor.CurrentPos)=="_") do
                scite.SendEditor(SCI_WORDLEFTEXTEND) -- Extend selection left
                scite.SendEditor(SCI_WORDLEFTEXTEND) -- Extend selection left
            end
        end
        -- Reselect
        local text = editor:GetSelText()
        scite.MenuCommand(IDM_CLEAROUTPUT)
        -- Try to direct output to the output window
        assert(loadstring("do io.write = print "..text.." end"))()
    end,
    ["=+Ctrl+Shift+Editor"] = function()        -- Lua strip @
        local LuaCache = scite.GetCache("LuaCache") or scite.DefaultLuaCache
        scite.CloseStrips()             -- Close other Strips
        props["ActiveUserStrip"] = "LuaStrip"
        scite.StripShow("'   Lua:'{}((OK))")
        scite.StripSetList(1,table.concat(LuaCache,"\n") or "")
        scite.StripSet(1,LuaCache[1] or "")

        function OnStrip(control,change)
            if control == 1 then        -- Action in the combo box

            elseif control == 2 then	-- Enter or OK
                if scite.StripValue(1)~="" and pcall(loadstring("do "..scite.StripValue(1).." end")) then
                    -- Save new commands and save cache
                    if scite.StripValue(1)~=LuaCache[1] then
                        table.insert(LuaCache,1,scite.StripValue(1))
                        scite.SetCache("LuaCache",LuaCache)
                    end
                    scite.StripSetList(1,table.concat(LuaCache,"\n") or "")
                    scite.StripSet(1,LuaCache[1] or "")
                else
                    -- Display error
                    assert(loadstring("do "..scite.StripValue(1).." end"))()
                end
                return 1
            elseif control == 3 then 				-- Escape or cancel
                scite.SetCache("LuaCache",LuaCache) -- Save cache before closing
                scite.StripShow("") 				-- Hide the dialog
                scite.SendEditor(SCI_GRABFOCUS)		-- Focus on editor
            end
        end
    end,
    [".+Ctrl+Editor"] = function()              -- Repeat last Lua Strip Command .
        local LuaCache = scite.GetCache("LuaCache")
        if LuaCache then
            assert(loadstring("do "..(LuaCache[1] or "").." end"))()
        end
    end,
    [".+Ctrl+Shift+Editor"] = function()        -- Indent >
        scite.SendEditor(SCI_TAB)
    end,
    [",+Ctrl+Shift+Editor"] = function()        -- Outdent <
        scite.SendEditor(SCI_BACKTAB)
    end,
    ["?+Ctrl+Alt+Editor"] = function()          -- Run Lua Macro Strip
        local MacroCache = scite.GetCache("MacroCache") or {}
        scite.CloseStrips()             -- Close other Strips
        props["ActiveUserStrip"] = "RunMacro"
        scite.StripShow("' Run Macro '{}((OK))")
        scite.StripSetList(1,string.sort(table.concat(io.dir(props["SciteDefaultHome"]..[[\confSciTE\mac\*.*]]),"\n")) or "")
        scite.StripSet(1,MacroCache[1] or "")

        function OnStrip(control,change)
            if control == 1 then 	    -- Action in the combo box

            elseif control == 2 then	-- Enter or OK
                if scite.StripValue(1)~="" and io.exists(scite.StripValue(1)) then
                    local file = assert(io.open(scite.StripValue(1)))
                    local contents = file:read'*a'
                    file:flush()
                    file:close()
                    assert(loadstring("do "..contents.." end"))()

                    -- Save new commands
                    if scite.StripValue(1)~=MacroCache[1] then
                        table.insert(MacroCache,1,scite.StripValue(1))
                        scite.SetCache("MacroCache",MacroCache)
                    end
--                     scite.StripShow("") 				-- Hide the dialog
--                     scite.SendEditor(SCI_GRABFOCUS)	-- Focus on editor
                end
                return 1
            elseif control == 3 then 				-- Escape or cancel
                scite.SetCache("MacroCache",MacroCache)
                scite.StripShow("") 				-- Hide the dialog
                scite.SendEditor(SCI_GRABFOCUS)		-- Focus on editor
            end
        end
    end,
    ["?+Alt+Editor"] = function()               -- Create Lua Macro
        scite.MenuCommand(IDM_NEW)      -- New document
        -- Insert template
        local file = assert(io.open(props["SciteDefaultHome"]..[[\confSciTE\lua\SciteMacro.lua]]))
        local contents = file:read'*a'
        file:flush()
        file:close()
        editor:AddText(contents)
        -- TODO: Change working directory to props["SciteDefaultHome"]..[[\confSciTE\mac]]
        scite.MenuCommand(IDM_SAVE)
    end,
    ["?+Alt+Shift+Editor"] = function()         -- Edit Lua Macro
        local MacroCache = scite.GetCache("MacroCache") or {}
        scite.CloseStrips()             -- Close other Strips
        props["ActiveUserStrip"] = "EditMacro"
        scite.StripShow("' Edit Macro '{}((OK))")
        scite.StripSetList(1,string.sort(table.concat(io.dir(props["SciteDefaultHome"]..[[\confSciTE\mac\*.*]]),"\n")) or "")
        scite.StripSet(1,MacroCache[1] or "")

        function OnStrip(control,change)
            if control == 1 then 			-- Action in the combo box

            elseif control == 2 then		-- Enter or OK
                if scite.StripValue(1)~="" and io.exists(scite.StripValue(1)) then
                    -- Open the file
                    scite.Open(scite.StripValue(1))

                    -- Save new commands
                    if scite.StripValue(1)~=MacroCache[1] then
                        table.insert(MacroCache,1,scite.StripValue(1))
                        scite.SetCache("MacroCache",MacroCache)
                    end
--                     scite.StripShow("") 				-- Hide the dialog
--                     scite.SendEditor(SCI_GRABFOCUS)		-- Focus on editor
                end
                return 1
            elseif control == 3 then 				-- Escape or cancel
                scite.SetCache("MacroCache",MacroCache)
                scite.StripShow("") 				-- Hide the dialog
                scite.SendEditor(SCI_GRABFOCUS)		-- Focus on editor
            end
        end
    end,
    ["#+Ctrl+Editor"] = function()              -- DOS strip
        local DOSCache = scite.GetCache("DOSCache") or scite.DefaultDOSCache
        scite.CloseStrips()             -- Close other Strips
        props["ActiveUserStrip"] = "DOSStrip"
        local prompt = props["FileDir"]
        if not prompt or prompt=="" then
            prompt = io.popen("pwd"):read("*a")
        end
        scite.StripShow("'"..prompt..">'{}((OK))")
        scite.StripSetList(1,table.concat(DOSCache,"\n") or "")
        scite.StripSet(1,DOSCache[1] or "")

        function OnStrip(control,change)
            if control == 1 then 	    -- Action in the combo box

            elseif control == 2 then	-- Enter or OK
                if scite.StripValue(1)~="" then
                    local cmd = scite.StripValue(1)
                    -- Substitute for properties
                    cmd = cmd:gsub('props%["FilePath"%]',props["FilePath"] or "")
                    cmd = cmd:gsub('props%["FileDir"%]',props["FileDir"] or "")
                    cmd = cmd:gsub('props%["FileName"%]',props["FileName"] or "")
                    cmd = cmd:gsub('props%["FileExt"%]',props["FileExt"] or "")
                    cmd = cmd:gsub('props%["FileNameExt"%]',props["FileNameExt"] or "")
                    cmd = cmd:gsub('props%["CurrentSelection"%]',props["CurrentSelection"]:gsub("\r?\n\r?", "\\n") or "")
                    cmd = cmd:gsub('props%["CurrentWord"%]',props["CurrentWord"] or "")
                    cmd = cmd:gsub('props%["SciteDefaultHome"%]',props["SciteDefaultHome"] or "")

                    -- Execute and read results
                    local fp = io.popen(cmd, "r")   -- Run
                    local res = fp:read("*l")       -- Loop through results
                    while res do
                        print(res)
                        res = fp:read("*l")
                    end
                    fp:flush()
                    fp:close()

                    -- Save new commands
                    if scite.StripValue(1)~=DOSCache[1] then
                        table.insert(DOSCache,1,scite.StripValue(1))
                        scite.SetCache("DOSCache",DOSCache)
                    end
--                     scite.StripShow("") 				-- Hide the dialog
--                     scite.SendEditor(SCI_GRABFOCUS)		-- Focus on editor
                end
                return 1
            elseif control == 3 then 				-- Escape or cancel
                scite.SetCache("DOSCache",DOSCache)
                scite.StripShow("") 				-- Hide the dialog
                scite.SendEditor(SCI_GRABFOCUS)		-- Focus on editor
            end
        end
    end,
    ["#+Ctrl+Shift+Editor"] = function()        -- TODO: Pipe text through shell command
    end,
    ["#+Ctrl+Alt+Editor"] = function()          -- Open your shell
        os.execute([[shelexec.exe /Params:-Command cmd.exe /EXE powershell.exe]])
    end,
    ["Space+Ctrl+Editor"] = function()          -- Select current word forwards
        word()
    end,
    ["Space+Ctrl+Shift+Editor"] = function()    -- Select current word backwards
        drow()
    end,
    ["F1+Editor"] = function()                  -- Open help database ** external tool
        os.execute([[shelexec.exe /Dir:"%XTG_Home%editor/help" /EXE "%XTG_Home%editor/help/SynNotes.exe"]])
    end,
    ["F1+Ctrl+Alt+Editor"] = function()         -- Google help ** default browser
        local text = sel() or scite.CurrentWord() or ""
        os.execute("start http://www.google.co.uk/search?q="..text:gsub("%s","+"))
    end,
    ["F7+Alt+Editor"] = function()              -- Toggle spelling ** external tool
        scite.CheckSpelling()
    end,
    ["F8+Editor"] = function()                  -- Show output AND focus
        scite.MenuCommand(IDM_TOGGLEOUTPUT)         -- (Twice will synch)
        scite.MenuCommand(IDM_SWITCHPANE)
    end,
    ["F9+Editor"] = function()                  -- Command strip :
        local CmdCache = scite.GetCache("CmdCache") or {}
        local CmdList = {}      -- Load command list - dynamic
        for i,v in pairs(scite) do
            if type(v)=="function" then
                if scite.CommandExclusions[i]~=1 then
                    table.insert(CmdList,i)
                end
            end
        end
        table.sort(CmdList)
        scite.CloseStrips()             -- Close other Strips
        props["ActiveUserStrip"] = "Command"
        scite.StripShow("'   : '{}((OK))")
        scite.StripSetList(1,table.concat(CmdList,"\n") or "")
        scite.StripSet(1,CmdCache[1] or "")

        function OnStrip(control,change)
            if control == 1 then 			-- Action in the combo box

            elseif control == 2 then		-- Enter or OK
                if scite.StripValue(1)~="" and pcall(loadstring("do scite."..scite.StripValue(1).."() end")) then
                    -- Save new commands and save cache
                    if "scite."..scite.StripValue(1)~=CmdCache[1] then
                        table.insert(CmdCache,1,scite.StripValue(1))
                        scite.SetCache("CmdCache",CmdCache)
                    end
                    scite.StripShow("") 				-- Hide the dialog
                    scite.SendEditor(SCI_GRABFOCUS)		-- Focus on editor
                else
                    pcall(loadstring("do scite."..scite.StripValue(1).."() end")) -- Display error
                end
                return 1
            elseif control == 3 then 				-- Escape or cancel
                scite.SetCache("CmdCache",CmdCache) -- Save the cache before closing
                scite.StripShow("") 				-- Hide the dialog
                scite.SendEditor(SCI_GRABFOCUS)		-- Focus on editor
            end
        end
    end,
    ["Up+Ctrl+Editor"] = function()             -- Find previous
        --Close strip - for calls from find strip
        scite.CloseStrips()
        scite.MenuCommand(IDM_FINDNEXTBACK)
    end,
    ["Down+Ctrl+Editor"] = function()           -- Find next
        --Close strip - for calls from find strip
        scite.CloseStrips()
        scite.MenuCommand(IDM_FINDNEXT)
    end,
    ["Up+Ctrl+Shift+Editor"] = function()       -- Block Up
        scite.SendEditor(SCI_MOVESELECTEDLINESUP)
    end,
    ["Down+Ctrl+Shift+Editor"] = function()     -- Block Down
        scite.SendEditor(SCI_MOVESELECTEDLINESDOWN)
    end,
    ["Up+Alt+Editor"] = function()              -- Pop location
        local LocationCache = scite.GetCache("LocationCache") or {}
        if table.length(LocationCache) < 1 then return end
        local Fpath = LocationCache[2]:gsub(" @ .*","")
        local Line  = LocationCache[2]:gsub(".* @ ","")
        scite.Open(Fpath)
        scite.SendEditor(SCI_GRABFOCUS)
        editor:GotoLine(Line)
    end,
    ["Down+Alt+Editor"] = function()            -- Push location (also in OnKey)
        SaveLocation()
    end,
    -- Alpha keys
    ["B+Ctrl+Editor"] = function()              -- Goto bol - for my mini keyboard
        scite.SendEditor(SCI_VCHOME)
    end,
    ["B+Ctrl+Shift+Editor"] = function()        -- Select to bol - for my mini keyboard
        scite.SendEditor(SCI_VCHOMEEXTEND)
    end,
    ["B+Ctrl+Alt+Editor"] = function()          -- Make a backup
        scite.Backup()
    end,
    ["V+Ctrl+Alt+Editor"] = function()          -- Review versions
        if not props["FileName"] or props["FileName"]=="" then return end
        if not io.exists(props["FileDir"].."\\zBackup") then return end
        local BackupList = io.dir(props["FileDir"].."\\zBackup\\*"..props["FileNameExt"])
        table.sort(BackupList,function(a,b) return a>b end)

        scite.CloseStrips()             -- Close other Strips
        props["ActiveUserStrip"] = "LoadBackup"
        scite.StripShow("'Load Backup '{}((OK))")
        scite.StripSetList(1,table.concat(BackupList,"\n") or "")
        scite.StripSet(1,BackupList[1] or "")

        function OnStrip(control,change)
            if control == 1 then 			-- Action in the combo box

            elseif control == 2 then		-- Enter or OK
                if scite.StripValue(1)~="" and io.exists(scite.StripValue(1)) then
                    -- Open the file
                    scite.Open(scite.StripValue(1))
--                     scite.StripShow("") 				-- Hide the dialog
--                     scite.SendEditor(SCI_GRABFOCUS)		-- Focus on editor
                end
                return 1
            elseif control == 3 then 				-- Escape or cancel
                scite.SetCache("MacroCache",MacroCache)
                scite.StripShow("") 				-- Hide the dialog
                scite.SendEditor(SCI_GRABFOCUS)		-- Focus on editor
            end
        end
    end,
    ["C+Ctrl+Shift+Editor"] = function()        -- CopyAppend
        editor:CopyText(GetClipboard()..sel())
    end,
    ["D+Ctrl+Editor"] = function()              -- Duplicate line or block
        scite.BlockSelect()
        scite.SendEditor(SCI_SELECTIONDUPLICATE)
        scite.MenuCommand(IDM_EOL_CONVERT)
        -- editor:SetSelection(editor.SelectionStart,editor.SelectionEnd)
    end,
    ["E+Ctrl+Editor"] = function()              -- Goto eol - for my mini keyboard
        scite.SendEditor(SCI_LINEEND)
    end,
    ["E+Ctrl+Shift+Editor"] = function()        -- Select to eol - for my mini keyboard
        scite.SendEditor(SCI_LINEENDEXTEND)
    end,
    ["F+Ctrl+Editor"] = function()              -- Find strip
--         -- Using my strip, findnext doesn't work!
--         scite.CloseStrips()             -- Close other Strips
--         props["ActiveUserStrip"] = "Find"
--         local FindCache = scite.GetCache("FindCache") or {}
--         scite.StripShow("'      Find '{}((OK))")
--         scite.StripSetList(1,table.concat(FindCache,"\n") or "")
--         scite.StripSet(1,sel() or "")

--         function OnStrip(control,change)
--             if control == 1 then 	    -- Action in the combo box

--             elseif control == 2 then	-- Enter or OK
--                 if scite.StripValue(1)~="" then
--                     flags = 0
--                     if scite.StripValue(1) and find(scite.StripValue(1),flags) then -- Do the find
--                         -- Save new commands and cache
--                         if scite.StripValue(1)~=FindCache[1] then
--                             table.insert(FindCache,1,scite.StripValue(1))
--                             scite.SetCache("FindCache",FindCache)
--                         end

--                         scite.StripShow("") 				-- Hide the dialog
--                         scite.SendEditor(SCI_GRABFOCUS)		-- Focus on editor
--                     end
--                 end

--             elseif control == 3 then 				-- Escape or cancel
--                 scite.SetCache("FindCache",FindCache)
--                 scite.StripShow("") 				-- Hide the dialog
--                 scite.SendEditor(SCI_GRABFOCUS)		-- Focus on editor
--             end
--         end
        -- Using an inbuilt strip, remember to close it!
        scite.CloseStrips()             -- Close other Strips
        props["ActiveUserStrip"] = "Find"
        props["find.use.strip"]=1
        scite.MenuCommand(IDM_FIND)
        props["find.use.strip"]=0
    end,
    ["F+Ctrl+Shift+Editor"] = function()        -- FindRegext
        scite.CloseStrips()             -- Close other Strips
        props["find.use.strip"]=1
        props["find.replace.regexp"]=1
        scite.MenuCommand(IDM_FIND)
        props["find.replace.regexp"]=0
        props["find.use.strip"]=0

    end,
    ["F+Ctrl+Alt+Editor"] = function()          -- Find in files DLG
        scite.CloseStrips()             -- Close other Strips
        scite.MenuCommand(IDM_FINDINFILES)
    end,
    ["G+Ctrl+Editor"] = function()              -- Goto strip
        scite.CloseStrips()             -- Close other Strips
        props["ActiveUserStrip"] = "Goto"
        local GotoCache = scite.GetCache("GotoCache") or {}
        scite.StripShow("'      Goto '{}((OK))")
        scite.StripSetList(1,table.concat(GotoCache,"\n") or "")
        scite.StripSet(1,GotoCache[1] or "")

        function OnStrip(control,change)
            if control == 1 then 	    -- Action in the combo box

            elseif control == 2 then	-- Enter or OK
                if scite.StripValue(1)~="" then
                    if tonumber(scite.StripValue(1)) then -- Goto line number
                        scite.SendEditor(SCI_GOTOLINE,math.floor(scite.StripValue(1))-1)

                    else
                        return 0
                    end
                    -- Save new commands and cache
                    if scite.StripValue(1)~=GotoCache[1] then
                        table.insert(GotoCache,1,scite.StripValue(1))
                        scite.SetCache("GotoCache",GotoCache)
                    end

                    scite.StripShow("") 				-- Hide the dialog
                    scite.SendEditor(SCI_GRABFOCUS)		-- Focus on editor
                end
                return 1
            elseif control == 3 then 				-- Escape or cancel
                scite.SetCache("GotoCache",GotoCache)
                scite.StripShow("") 				-- Hide the dialog
                scite.SendEditor(SCI_GRABFOCUS)		-- Focus on editor
            end
        end
    end,
    ["G+Ctrl+Shift+Editor"] = function()        -- Filter then goto
        scite.CloseStrips()             -- Close other Strips
        props["ActiveUserStrip"] = "Filter"
        scite.MenuCommand(IDM_FILTER)
    end,
    ["G+Ctrl+Alt+Editor"] = function()          -- Go back strip
        local LocationCache = scite.GetCache("LocationCache") or {}
        scite.CloseStrips()             -- Close other Strips
        props["ActiveUserStrip"] = "Location"
        scite.StripShow("'   Go back '{}((OK))")
        -- Display list of locations
        scite.StripSetList(1,table.concat(LocationCache,"\n") or "")
        scite.StripSet(1,LocationCache[1] or "")

        function OnStrip(control,change)
            if control == 1 then 			-- Action in the combo box

            elseif control == 2 then		-- Enter or OK
                if scite.StripValue(1)~="" then
                    local Fpath = scite.StripValue(1):gsub(" @ .*","")
                    local Line  = scite.StripValue(1):gsub(".* @ ","")
                    scite.Open(Fpath)
                    scite.SendEditor(SCI_GRABFOCUS)		-- Focus on editor
                    editor:GotoLine(Line)
--                     scite.StripShow("") 				    -- Hide the dialog
                end
                return 1
            elseif control == 3 then 				-- Escape or cancel
                scite.StripShow("") 				-- Hide the dialog
                scite.SendEditor(SCI_GRABFOCUS)		-- Focus on editor
            end
        end
    end,
    ["H+Ctrl+Editor"] = function()              -- Use replace strip
        scite.CloseStrips()
        props["ActiveUserStrip"] = "Replace"
        props["replace.use.strip"]=1
        scite.MenuCommand(IDM_REPLACE)  -- Note the real time regex marking - cool!
        props["replace.use.strip"]=0
    end,
    ["H+Ctrl+Alt+Editor"] = function()          -- Replace in files **external tool
        -- https://tools.stefankueng.com/grepWin.html - 'cause it take command line parameters
        -- I'm using Version 1.6.1.519
        scite.MenuCommand(IDM_SAVE)
        os.execute("GrepWin.exe /portable /searchpath:"..props["FileDir"].." /filemask:".."*.*".."  /searchfor:"..editor:GetSelText().." /size:-1 /s:yes /h:yes,", nil, false, false)
    end,
    ["I+Alt+Editor"] = function()              -- Insertor Strip
        scite.CloseStrips()           -- Close other Strips
        if not io.exists(props["SciteDefaultHome"].."\\insertions\\api."..props["FileExt"]) then return end
        props["ActiveUserStrip"] = "Insertor"
        scite.StripShow("'  Insertor '{}((OK))")
        local file = assert(io.open(props["SciteDefaultHome"].."\\insertions\\api."..props["FileExt"]))
        local contents = file:read'*a'
        file:flush()
        file:close()
        scite.StripSetList(1,contents or "")
        scite.StripSet(1,sel() or "")
        function OnStrip(control,change)
            if control == 1 then 			-- Action in the combo box
                -- FEATURE: filter OnCombobox
            elseif control == 2 then		-- Enter or OK
                if scite.StripValue(1)~="" then
                    local sel = scite.StripValue(1)

                    -- Check for selection
                    if not sel or sel == ""  then return end

                    -- Get comment type
                    local commenttype = props["comment.block."..props["FileExt"]]:trim()

                    -- Trim off comments
                    if commenttype=="--" then
                        -- Lua comments are magic characters and must be escaped
                        -- https://stackoverflow.com/questions/6705872/how-to-escape-a-variable-in-lua
                        -- Other magic characters include ( ) % . + - * [ ? ^ $
                        sel = sel:match("(.*)%-%-") or sel
                    elseif commenttype then
                        sel = sel:match("(.*)"..commenttype) or sel
                    end

                    -- Trim whitespaces
                    sel = sel:trim()
                    editor:AddText(sel)
                end

                scite.StripShow("") 				-- Hide the dialog
                scite.SendEditor(SCI_GRABFOCUS)		-- Focus on editor
                return 1
            elseif control == 3 then 				-- Escape or cancel
                scite.StripShow("") 				-- Hide the dialog
                scite.SendEditor(SCI_GRABFOCUS)		-- Focus on editor
            end
        end
    end,
    ["I+Ctrl+Alt+Editor"] = function()          -- Insert Project File strip
        local InsertCache = scite.GetCache("InsertCache") or {}
        scite.CloseStrips()             -- Close other Strips
        props["ActiveUserStrip"] = "Insert"
        scite.StripShow("'    Insert '{}((OK))")
        scite.StripSetList(1,table.concat(io.dir(props["FileDir"] or [[%CD%]]),"\n") or "")
        scite.StripSet(1,InsertCache[1] or "")

        function OnStrip(control,change)
            if control == 1 then 			-- Action in the combo box

            elseif control == 2 then		-- Enter or OK
                if scite.StripValue(1)~="" and io.exists(scite.StripValue(1)) then
                    local file = assert(io.open(scite.StripValue(1)))
                    local contents = file:read'*a'
                    file:flush()
                    file:close()
                    editor:AddText(contents)

                    -- Save new commands
                    if scite.StripValue(1)~=InsertCache[1] then
                        table.insert(InsertCache,1,scite.StripValue(1))
                        scite.SetCache("InsertCache",InsertCache)
                    end
--                     scite.StripShow("") 				-- Hide the dialog
--                     scite.SendEditor(SCI_GRABFOCUS)		-- Focus on editor
                end
                return 1
            elseif control == 3 then 				-- Escape or cancel
                scite.SetCache("InsertCache",InsertCache)
                scite.StripShow("") 				-- Hide the dialog
                scite.SendEditor(SCI_GRABFOCUS)		-- Focus on editor
            end
        end
    end,
    ["J+Ctrl+Editor"] = function()              -- Jump to "end" or delimiter
        if  scite.CurrentWord()=="function" or
            scite.CurrentWord()=="if" or
            scite.CurrentWord()=="for" or
            scite.CurrentWord()=="else" or
            scite.CurrentWord()=="elseif" or
            scite.CurrentWord()=="while" then
            -- Jump to end
            local leader = scite.SendEditor(SCI_GETCURLINE):find("%S")-1
            local target = string.rep(" ",leader).."end"
            editor:GotoPos(editor:findtext("^"..target,SCFIND_REGEXP,scite.SendEditor(SCI_GETCURRENTPOS))+leader+3)
        elseif scite.CurrentWord()=="repeat" then
            -- Jump to repeat
            local leader = scite.SendEditor(SCI_GETCURLINE):find("%S")-1
            local target = string.rep(" ",leader).."until"
            editor:GotoPos(editor:findtext("^"..target,SCFIND_REGEXP,scite.SendEditor(SCI_GETCURRENTPOS))+leader+5)
        else
            -- Jump delimiters
            scite.MenuCommand(IDM_MATCHBRACE)
        end
    end,
    ["J+Ctrl+Shift+Editor"] = function()        -- Select delimiter
        if  scite.CurrentWord()=="function" or
            scite.CurrentWord()=="if" or
            scite.CurrentWord()=="for" or
            scite.CurrentWord()=="else" or
            scite.CurrentWord()=="elseif" or
            scite.CurrentWord()=="while" then
            -- Jump to end
            local leader = scite.SendEditor(SCI_GETCURLINE):find("%S")-1
            local target = string.rep(" ",leader).."end"
            editor:SetSelection(scite.SendEditor(SCI_GETCURRENTPOS)-leader,editor:findtext("^"..target,SCFIND_REGEXP,scite.SendEditor(SCI_GETCURRENTPOS))+leader+3)
        elseif scite.CurrentWord()=="repeat" then
            -- Jump to repeat
            local leader = scite.SendEditor(SCI_GETCURLINE):find("%S")-1
            local target = string.rep(" ",leader).."until"
            editor:SetSelection(scite.SendEditor(SCI_GETCURRENTPOS)-leader,editor:findtext("^"..target,SCFIND_REGEXP,scite.SendEditor(SCI_GETCURRENTPOS))+leader+5)
        else
            scite.MenuCommand(IDM_SELECTTOBRACE)
        end
    end,
    ["J+Ctrl+Alt+Editor"] = function()          -- TODO: CTAGs Strip
    end,
    ["K+Ctrl+Editor"] = function()              -- Delete to EOL
        scite.SendEditor(SCI_DELLINERIGHT)
    end,
    ["K+Ctrl+Shift+Editor"] = function()        -- Delete to BOL
        scite.SendEditor(SCI_DELLINELEFT)
    end,
    ["L+Ctrl+Editor"] = function()              -- Select line forwards
        line()
    end,
    ["L+Ctrl+Shift+Editor"] = function()        -- Select line backwards
        line()
        scite.SendEditor(SCI_SWAPMAINANCHORCARET)
    end,
    ["M+Ctrl+Editor"] = function()              -- Mark and list occurrences
        --Close strip - for calls from find strip
        scite.CloseStrips()

        -- http://lua-users.org/wiki/SciteMarkWord
        -- Fail if no selected text
        if editor.SelectionStart == editor.SelectionEnd then
            return
        end

        -- Use the current selection
        local txt = editor:GetSelText()

        -- Select the indicator properties
        local indic = scite.SetIndicator("word")

        -- Clear previous marks of this type - disable if you want to add marks together
        scite.SendEditor(SCI_INDICATORCLEARRANGE, 0, editor.Length)

        -- Setup the search parameters
        local flags = 0 --SCFIND_WHOLEWORD
        -- Perform an initial search
        local s,e = editor:findtext(txt,flags,0)
        -- Loop through the file
        while s do
            scite.SendEditor(SCI_INDICATORFILLRANGE, s, e - s)
            trace(props.FileNameExt .. ":" .. (editor:LineFromPosition(s)+1) .. ":" .. editor:GetLine(editor:LineFromPosition(s)))
            s,e = editor:findtext(txt,flags,e+1)
        end
    end,
    ["M+Ctrl+Alt+Editor"] = function()          -- Multicursor Editing
    -- https://groups.google.com/g/scite-interest/c/6zQ2Q646GS0/m/MPy5Ebwko0wJ
        local FindCache = scite.GetCache("FindCache",FindCache) or {}
        scite.CloseStrips()             -- Close other Strips
        props["ActiveUserStrip"] = "MultiEdit"
        scite.StripShow("' MultiEdit '{}{}((OK))")
        scite.StripSetList(1,table.concat(FindCache,"\n") or "")
        scite.StripSet(1,FindCache[1] or "")
        scite.StripSetList(2, "Match\nBefore\nAfter")
        scite.StripSet(2, "Match")

        function OnStrip(control, change)
            if control == 3 and change == 1 then
                local pattern = scite.StripValue(1)
                local selectionPart = scite.StripValue(2)
                local first = true
                for m in editor:match(pattern, SCFIND_REGEXP) do
                    local startPos = m.pos
                    local endPos = m.pos+m.len
                    if selectionPart == "Before" then
                        endPos = startPos
                    elseif selectionPart == "After" then
                        startPos = endPos
                    end
                    if first then
                        editor:SetSelection(endPos, startPos)
                    else
                        editor:AddSelection(endPos, startPos)
                    end
                    first = false
                end
                -- Save new search terms
                if scite.StripValue(1)~=FindCache[1] then
                    table.insert(FindCache,1,scite.StripValue(1))
                    scite.SetCache("FindCache",FindCache)
                end

--                 scite.StripShow("")
                editor:GrabFocus()
            end
        end
    end,
    ["N+Ctrl+Shift+Editor"] = function()        -- Open New TextWiki with word
        local text = scite.CurrentWord()
        if not text then return end

        -- Detect Proper case words only
        if text:sub(1,1):upper()..text:sub(2)==text then
            if io.exists(props["FileDir"]..[[\]]..text..".txt") then
                scite.Open(props["FileDir"]..[[\]]..text..".txt")
            else
                -- This is the only way I have found to create and open an empty file
                os.execute("start "..props["SciteDefaultHome"]..[[\scite.exe ]]..props["FileDir"]..[[\]]..text..".txt")
            end
        end
        return 1
    end,
    ["N+Ctrl+Alt+Editor"] = function()          -- Open New Editor
        os.execute("start "..props["SciteDefaultHome"]..[[\scite.exe "-check.if.already.open=0"]])
    end,
    ["O+Ctrl+Alt+Editor"] = function()          -- Open Project File Strip
        local ProjectCache = scite.GetCache("ProjectCache",ProjectCache) or {}
        scite.CloseStrips()             -- Close other Strips
        props["ActiveUserStrip"] = "Open"
        scite.StripShow("'      Open '{}((OK))")
        -- Gather list of files
        scite.ProjectList = io.dir(props["FileDir"] or [[%CD%]])
        scite.StripSetList(1,string.sort(table.concat(scite.ProjectList,"\n")) or "")
        scite.StripSet(1,ProjectCache[1] or "")

        function OnStrip(control,change)
            if control == 1 then 			-- Action in the combo box

            elseif control == 2 then		-- Enter or OK
                if scite.StripValue(1)~="" then
                    if io.exists(scite.StripValue(1)) then -- Open files
                        scite.Open(scite.StripValue(1))
                    else
                        return 0
                    end
                    -- Save new commands
                    if scite.StripValue(1)~=ProjectCache[1] then
                        table.insert(ProjectCache,1,scite.StripValue(1))
                        scite.SetCache("ProjectCache",ProjectCache)
                    end
--                     scite.StripShow("") 				-- Hide the dialog
--                     scite.SendEditor(SCI_GRABFOCUS)		-- Focus on editor
                end
                return 1
            elseif control == 3 then 				-- Escape or cancel
                scite.SetCache("ProjectCache",ProjectCache)
                scite.StripShow("") 				-- Hide the dialog
                scite.SendEditor(SCI_GRABFOCUS)		-- Focus on editor
            end
        end
    end,
    ["R+Ctrl+Alt+Editor"] = function()          -- Save and Run current file
        scite.MenuCommand(IDM_SAVE)
        if props["FileExt"]=="url" then
            os.execute("C:\\Windows\\System32\\Rundll32.exe url.dll, FileProtocolHandler "..'"'..props["FilePath"]..'"')
        else
            os.execute("start "..props["FilePath"])
        end
    end,
    ["S+Ctrl+Alt+Editor"] = function()          -- Insert Snippets Strip
        local SnippetCache = scite.GetCache("SnippetCache") or {}
        scite.CloseStrips()             -- Close other Strips
        props["ActiveUserStrip"] = "Snippet"
        scite.StripShow("'  Snippet '{}((OK))")
        scite.StripSetList(1,string.sort(table.concat(io.dir(props["SciteDefaultHome"]..[[\snippets\*.*]]),"\n")) or "")
        scite.StripSet(1,SnippetCache[1] or "")

        function OnStrip(control,change)
            if control == 1 then 			-- Action in the combo box

            elseif control == 2 then		-- Enter or OK
                if scite.StripValue(1)~="" and io.exists(scite.StripValue(1)) then
                    local file = assert(io.open(scite.StripValue(1)))
                    local contents = file:read'*a'
                    file:flush()
                    file:close()
                    editor:AddText(contents)

                    -- Save new commands
                    if scite.StripValue(1)~=SnippetCache[1] then
                        table.insert(SnippetCache,1,scite.StripValue(1))
                        scite.SetCache("SnippetCache",SnippetCache)
                    end
                    scite.StripShow("") 				-- Hide the dialog
                    scite.SendEditor(SCI_GRABFOCUS)		-- Focus on editor
                end
                return 1
            elseif control == 3 then 				-- Escape or cancel
                scite.SetCache("SnippetCache",SnippetCache)
                scite.StripShow("") 				-- Hide the dialog
                scite.SendEditor(SCI_GRABFOCUS)		-- Focus on editor
            end
        end
    end,
    ["T+Ctrl+Editor"] = function()              -- TODO: Find TAGS
        -- SciTE default is to swap lines
        -- Micro and nano - run filter on selection
        -- I have chosen find tags
    end,
    ["T+Ctrl+Shift+Editor"] = function()        -- TODO: Make TAGS
    end,
    ["T+Ctrl+Alt+Editor"] = function()          -- Insert Template Strip
--         scite.MenuCommand(IDM_NEW)
        local TemplateCache = scite.GetCache("TemplateCache") or {}
        scite.CloseStrips()             -- Close other Strips
        props["ActiveUserStrip"] = "Template"
        scite.StripShow("'  Template '{}((OK))")
        scite.StripSetList(1,string.sort(table.concat(io.dir(props["SciteDefaultHome"]..[[\templates\*.*]]),"\n")) or "")
--         scite.StripSetList(1,string.sort(table.concat(io.dir([[F:\MyProfile\editor\conf\templates\*.*]]),"\n")) or "")
        scite.StripSet(1,TemplateCache[1] or "")

        function OnStrip(control,change)
            if control == 1 then 			-- Action in the combo box

            elseif control == 2 then		-- Enter or OK
                if scite.StripValue(1)~="" and io.exists(scite.StripValue(1)) then
                    local file = assert(io.open(scite.StripValue(1)))
                    local contents = file:read'*a'
                    file:flush()
                    file:close()
                    editor:AddText(contents)

                    -- Save new commands
                    if scite.StripValue(1)~=TemplateCache[1] then
                        table.insert(TemplateCache,1,scite.StripValue(1))
                        scite.SetCache("TemplateCache",TemplateCache)
                    end
                    scite.StripShow("") 				-- Hide the dialog
                    scite.SendEditor(SCI_GRABFOCUS)		-- Focus on editor
                end
                return 1
            elseif control == 3 then 				-- Escape or cancel
                scite.SetCache("TemplateCache",TemplateCache)
                scite.StripShow("") 				-- Hide the dialog
                scite.SendEditor(SCI_GRABFOCUS)		-- Focus on editor
            end
        end
    end,
    ["U+Ctrl+Editor"] = function()              -- Unmark words
        scite.Unmark("word")
        scite.Unmark("found")
        scite.MenuCommand(IDM_TOGGLEOUTPUT)
    end,
    ["V+Ctrl+Shift+Editor"] = function()        -- PastePlainTxt
        scite.PastePlainTxt()
    end,
    ["W+Ctrl+Shift+Editor"] = function()        -- Wrap
        scite.MenuCommand(IDM_WRAP)
        scite.MenuCommand(IDM_LINENUMBERMARGIN)
    end,
    ["W+Alt+Editor"]  = function()              -- Switch Buffers
        scite.CloseStrips()             -- Close other Strips
        props["ActiveUserStrip"] = "Windows"
        scite.StripShow("'   Windows '{}((OK))")
        -- Use stored recent files - see OnOpen
        local BufferList = scite.GetCache("BufferList",BufferList) or {}
        scite.StripSetList(1,string.sort(table.concat(BufferList,"\n")) or "")
        scite.StripSet(1,BufferList[1] or "")

        function OnStrip(control,change)
            if control == 1 then 	    -- Action in the combo box

            elseif control == 2 then	-- Enter or OK
                if scite.StripValue(1)~="" then
                    if io.exists(scite.StripValue(1)) then -- Open files
                        scite.Open(scite.StripValue(1))
                    else
                        return 0
                    end
                    -- Save new commands
                    if scite.StripValue(1)~=BufferList[1] then
                        table.insert(BufferList,1,scite.StripValue(1))
                        scite.SetCache("BufferList",BufferList)
                    end
--                     scite.StripShow("") 				-- Hide the dialog
--                     scite.SendEditor(SCI_GRABFOCUS)		-- Focus on editor
                end
                return 1
            elseif control == 3 then 				-- Escape or cancel
                scite.SetCache("BufferList",BufferList)
                scite.StripShow("") 				-- Hide the dialog
                scite.SendEditor(SCI_GRABFOCUS)		-- Focus on editor
            end
        end
    end,
    ["X+Ctrl+Shift+Editor"] = function()        -- CutAppend
        editor:CopyText(GetClipboard()..sel())
        scite.SendEditor(IDM_CLEAR)
    end,
    ["Y+Ctrl+Editor"] = function()              -- Yank line or block
        if editor.SelectionStart == editor.SelectionEnd then
            scite.SendEditor(SCI_LINEDELETE)
            return
        else
            scite.BlockSelect()
            scite.SendEditor(SCI_CLEAR)
            scite.SendEditor(SCI_LINEDELETE)
        end
    end,
    ["Z+Ctrl+Shift+Editor"] = function()        -- Redo
        scite.MenuCommand(IDM_REDO)
    end,
    ["Z+Alt+Editor"] = function()               -- Toggle branch TODO: go up to visible line
        scite.MenuCommand(IDM_TOGGLE_FOLDRECURSIVE)
    end,
    ["Z+Alt+Shift+Editor"] = function()         -- Toggle children TODO: go up to visible line
        scite.MenuCommand(IDM_TOGGLE_FOLDRECURSIVE)
        scite.MenuCommand(IDM_EXPAND)
    end,
    ["Z+Ctrl+Alt+Editor"] = function()          -- Toggle all headers TODO: go up to visible line
        scite.MenuCommand(IDM_TOGGLE_FOLDALL)
    end,
    -- Output window commands
    ["Tab+Ctrl+Output"] = function()            -- Switch to editor
        scite.SendEditor(SCI_GRABFOCUS)
        scite.SendEditor(SCI_SCROLLCARET)
    end,
    ["2+Ctrl+Output"] = function()              -- Insert ""
        output:AddText([[""]]) scite.SendOuput(SCI_CHARLEFT)
    end,
    ["F+Ctrl+Output"] = function()              -- Search Output
        local function isWordChar(char)
            local strChar = string.char(char)
            local beginIndex = string.find(strChar, '%w')
            if beginIndex ~= nil then
                return true
            end
            if strChar == '_' or strChar == '$' then
                return true
            end

            return false
        end
        local function word_output()
            local beginPos = output.CurrentPos
            local endPos = beginPos
            if output.SelectionStart ~= output.SelectionEnd then
                return output:GetSelText()
            end
            while isWordChar(output.CharAt[beginPos-1]) do
                beginPos = beginPos - 1
            end
            while isWordChar(output.CharAt[endPos]) do
                endPos = endPos + 1
            end
            return output:textrange(beginPos,endPos)
        end

        local FindCache = scite.GetCache("FindCache",FindCache) or {}
        scite.CloseStrips()             -- Close other Strips
        props["ActiveUserStrip"] = "FindOutput"
        scite.StripShow("' Find in Output '{}((OK))")
        scite.StripSetList(1,table.concat(FindCache,"\n") or "")
        scite.StripSet(1,word_output() or FindCache[1] or "")

        function OnStrip(control,change)
            if control == 1 then 			-- Action in the combo box

            elseif control == 2 then		-- Enter or OK
                if scite.StripValue(1)~="" then
                    -- Do the search
                    local flags = 0         -- Change if you want Regx searches
                    -- Set anchor
                    output:SearchAnchor()
                    local start,finish = output:findtext(scite.StripValue(1), flags, output.CurrentPos)
                    if start then
                        output:SetSelection(finish,start)
                        output:ScrollCaret()
                    end

                    -- Save new commands
                    if scite.StripValue(1)~=FindCache[1] then
                        table.insert(FindCache,1,scite.StripValue(1))
                        scite.SetCache("FindCache",FindCache)
                    end
--                     scite.StripShow("") 			-- Hide the dialog
--                     scite.SendOutput(SCI_GRABFOCUS)	-- Focus on editor
                end
                return 1
            elseif control == 3 then 				-- Escape or cancel
                scite.SetCache("FindCache",FindCache)
                scite.StripShow("") 				-- Hide the dialog
                scite.SendOutput(SCI_GRABFOCUS)		-- Focus on output
            end
        end
    end,
    ["Up+Ctrl+Output"] = function()             -- Find prev
        local FindCache = scite.GetCache("FindCache",FindCache) or {}
        local text = FindCache[1] or ""
        local flags = 0
        if text~="" then
            output:SearchAnchor()                    -- Always set an anchor
            if output:SearchNext(flags,text)>0 then
                output:GotoPos(output:SearchPrev(flags,text))
                scite.SendOutput(SCI_SCROLLCARET)    -- Move into view
                scite.SendOutput(SCI_WORDRIGHTEXTEND)-- Select found text
            else
                scite.SendOutput(SCI_WORDRIGHT)      -- Skip back
            end
        end
    end,
    ["Down+Ctrl+Output"] = function()           -- Find next
        local FindCache = scite.GetCache("FindCache",FindCache) or {}
        local text = FindCache[1] or ""
        local flags = 0
        if text~="" then
            scite.SendOutput(SCI_WORDRIGHT)          -- Skip the next word
            output:SearchAnchor()                    -- Always set an anchor
            if output:SearchNext(flags,text)>0 then
                output:GotoPos(output:SearchNext(flags,text))
                scite.SendOutput(SCI_SCROLLCARET)    -- Move into view
                scite.SendOutput(SCI_WORDRIGHTEXTEND)-- Select found text
            else
                scite.SendOutput(SCI_WORDLEFT)       -- Skip back
            end
        end
    end,
    ["H+Ctrl+Output"] = function()              -- Toggle Horizontal
        scite.MenuCommand(IDM_SPLITVERTICAL)
    end,
    ["N+Ctrl+Output"] = function()              -- New (Clear)
        scite.MenuCommand(IDM_CLEAROUTPUT)
    end,
    ["W+Ctrl+Output"] = function()              -- Close
        scite.MenuCommand(IDM_TOGGLEOUTPUT)
        scite.SendEditor(SCI_GRABFOCUS)
    end,
}

-- Copies with different key combinations (some vi inspired)
scite.KeyActions["?+Ctrl+Editor"]       = scite.KeyActions["F+Ctrl+Editor"]
scite.KeyActions["?+Ctrl+Shift+Editor"] = scite.KeyActions["F+Ctrl+Editor"]
scite.KeyActions[":+Ctrl+Shift+Editor"] = scite.KeyActions["F9+Editor"]

scite.KeyActions["Down+Ctrl+Find"]      = scite.KeyActions["Down+Ctrl+Editor"]
scite.KeyActions["Up+Ctrl+Find"]        = scite.KeyActions["Up+Ctrl+Editor"]
scite.KeyActions["M+Ctrl+Find"]         = scite.KeyActions["M+Ctrl+Editor"]
scite.KeyActions["U+Ctrl+Find"]         = scite.KeyActions["U+Ctrl+Editor"]

-- ***User commands from here down***
function scite.BlockTrimLeft()          -- Trim each line at left edge
    block():ltrim():ins()
end
function scite.BlockTrimRight()         -- Trim each line at right edge
    block():rtrim():ins()
end
function scite.BlockTrim()              -- Trim each line at both edges
    block():trim():ins()
end
function scite.BlockDedup()             -- Remove duplicated lines
-- Use string functions
    block():dedup():ins()
end
function scite.BlockMinimise()          -- Remove empty lines
-- Use string functions
    block():min():ins()
end
function scite.BlockSortCharA()         -- Sort lines by character ascending
    -- Save position
    local start, finish  = scite.BlockSelect()

    local ret = string.sort(editor:GetSelText(),"chara")

    -- Paste the results
    editor:ReplaceSel(ret)

    -- Reselect block
    editor:SetSelection(start,start+string.len(ret))

    -- Correct EOL
    scite.MenuCommand(IDM_EOL_CONVERT)
end
function scite.BlockSortCharD()         -- Sort lines by character descending
    -- Save position
    local start, finish  = scite.BlockSelect()

    -- Do the sort
    local ret = string.sort(editor:GetSelText(),"chard")

    -- Paste the results
    editor:ReplaceSel(ret)

    -- Reselect block
    editor:SetSelection(start,start+string.len(ret))

    -- Correct EOL
    scite.MenuCommand(IDM_EOL_CONVERT)
end
function scite.BlockSortIntA()          -- Sort lines by number ascending
    -- Save position
    local start, finish  = scite.BlockSelect()

    -- Do the sort
    local ret = string.sort(editor:GetSelText(),"inta")

    -- Paste the results
    editor:ReplaceSel(ret)

    -- Reselect block
    editor:SetSelection(start,start+string.len(ret))

    -- Correct EOL
    scite.MenuCommand(IDM_EOL_CONVERT)
end
function scite.BlockSortIntD()          -- Sort lines by number descending
    -- Save position
    local start, finish  = scite.BlockSelect()

    -- Do the sort
    local ret = string.sort(editor:GetSelText(),"intd")

    -- Paste the results
    editor:ReplaceSel(ret)

    -- Reselect block
    editor:SetSelection(start,start+string.len(ret))

    -- Correct EOL
    scite.MenuCommand(IDM_EOL_CONVERT)
end
function scite.Backup()                 -- Make a backup file from the disc copy then saves
    if not io.exists(props["FilePath"]) then
        scite.Message("Backup NOT saved")
        return
    end
	if not io.exists(props["FileDir"].."\\zBackup") then
	    -- Make the backup directory
	    io.mkdir(props["FileDir"].."\\zBackup")
	end
    if not io.exists(props["FileDir"].."\\zBackup") then
        -- Can't make the backup directory
        scite.Message("Can't make the backup directory","error\n")
        return
    else
        -- Make the backup file
        os.execute('xcopy "'..props["FilePath"]..'" "'..props["FileDir"].."\\zBackup\\"..os.datestamp().."_"..props["FileName"].."."..props["FileExt"]..'*"', nil, true, true)
        scite.Message("Backup @ "..props["FileDir"].."\\zBackup\\"..os.datestamp().."_"..props["FileName"].."."..props["FileExt"])
        return
    end
end
function scite.Restore()                -- Open backups of this file
    scite.KeyActions["V+Ctrl+Alt+Editor"]()
end
function scite.FoldSelection()          -- TODO: Toggle Folds in Selection
    scite.Message("Can't fold selection ... yet")
end
function scite.FoldAll()                -- Toggle Folds at Header and TODO: goto top visible line
    scite.MenuCommand(IDM_TOGGLE_FOLDALL)
    scite.SendEditor(SCI_LINEUP)
--     scite.SendEditor(SCI_SCROLLCARET)
end
function scite.FoldCurrent()
   -- Toggle Fold this level and TODO: goto top visible line
    scite.MenuCommand(IDM_EXPAND)
    scite.SendEditor(SCI_LINEUP)
--     scite.SendEditor(SCI_SCROLLCARET)
end
function scite.FoldBranch()             -- Toggle fold branch and TODO: goto top visible line
    scite.MenuCommand(IDM_TOGGLE_FOLDRECURSIVE)
    scite.SendEditor(SCI_LINEUP)
--     scite.SendEditor(SCI_SCROLLCARET)
end
function scite.FoldChildren()             -- Toggle fold children and TODO: goto top visible line
    scite.MenuCommand(IDM_TOGGLE_FOLDRECURSIVE)
    scite.MenuCommand(IDM_EXPAND)
--     scite.SendEditor(SCI_SCROLLCARET)
end
function scite.Prefix()                 -- Multicursor Prefix Block
    local function findEOL(text,start,finish)
        -- return table of positions of hex 0A for selected string
        -- this will work for EOL coded as 0D0A (win) or 0A (unix OSX) but not for others
        if start and finish then else finish=start end
        local t = {}
        for i=1,(finish - start) do
            if string.byte(text,i)==10 then
                table.insert(t,start+i)
            end
        end
        return t
    end
    local start, finish  = scite.BlockSelect()
    local text = editor:GetSelText()
    editor:SetSelection(start, start)
    local t = findEOL(text,start,finish)
    for i,v in ipairs(t) do
        editor:AddSelection(v, v)
    end
    scite.SendEditor(SCI_GRABFOCUS)
end
function scite.Postfix()                -- Multicursor Postfix Block
    local function findEOL(text,start,finish)
        -- return table of positions of hex 0A for selected string
        -- this will work for EOL coded as 0D0A (win) or 0A (unix OSX) but not for others
        if start and finish then else finish=start end
        local t = {}
        for i=1,(finish - start) do
            if string.byte(text,i)==10 then
                table.insert(t,start+i)
            end
        end
        return t
    end
    local start, finish  = scite.BlockSelect()
    local text = editor:GetSelText()
    local t = findEOL(text,start,finish)
    for i,v in ipairs(t) do
        editor:AddSelection(v-2, v-2)
    end
    editor:AddSelection(finish-1, finish-1)
    scite.SendEditor(SCI_GRABFOCUS)
end
function scite.CheckSpelling()          -- Mark misspellings **external tool
    -- I can't remember were I got hunspell.exe from - sorry
    -- Don't loose the space at the end
    local hunspell_path = props["SciteDefaultHome"].."\\hunspell\\hunspell.exe "
    local hunspell_dic  = props["SciteDefaultHome"].."\\hunspell\\en_GB "
    local hunspell_user = props["SciteDefaultHome"].."\\hunspell\\USER_DICT.dic "
    local hunspell_input= props["SciteDefaultHome"].."\\hunspell\\temp.txt "

    -- Additionally I manually check for lists of allowed words
    -- at User / Directory / FileType levels
    local UserDic = scite.LoadDic(props["SciteDefaultHome"].."\\dictionary\\user.dic") or {}
    local TypeDic = scite.LoadDic(props["SciteDefaultHome"].."\\dictionary\\"..props["FileExt"]..".dic") or {}
    local DirDic  = scite.LoadDic(props["FileDir"].."\\dir.dic") or {}

    -- Make a temp file of current buffer
    local t = io.open(hunspell_input,"w")
    t:write(editor:GetText():gsub("\n"," "))
    t:close()
    -- Set Hunspell command
    local cmd = ""
    if props["FileExt"]=="html" or props["FileExt"]=="htm" or props["FileExt"]=="hti" then
        cmd =      hunspell_path..[[ -H -l ]]
        cmd = cmd..[[-d ]]..hunspell_dic
        cmd = cmd..[[-p ]]..hunspell_user
        cmd = cmd..hunspell_input
    else
        cmd =      hunspell_path..[[ -l ]]
        cmd = cmd..[[-d ]]..hunspell_dic
        cmd = cmd..[[-p ]]..hunspell_user
        cmd = cmd..hunspell_input

    end
    local misspellings = {}             -- Create table for misspellings
    local fp = io.popen(cmd, "r")       -- Run Hunspell.EXE - generates a list of misspellings
    local res = fp:read("*l")           -- Loop through results one word at a time
    while res do
        if (not UserDic[res]) and (not TypeDic[res]) and (not DirDic[res]) then
            misspellings[res]=res       -- Indexing to avoid duplicates
        end
        res = fp:read("*l")
    end
    fp:flush()
    fp:close()
--     print("Misspellings:"..table.length(misspellings))
    scite.Mark(misspellings,"spelling")
    scite.StripShow("")                 -- Something doesn't work on repeat if lua is not restarted
end
function scite.ClearSpelling()          -- Clear all spelling indicators
    scite.Unmark("spelling")
end
function scite.SuggestSpelling(text)    -- Send marked misspellings for suggestions **external tool
    if not text then text = scite.CurrentWord() end
    if not text then return end
    -- I know these could be global or props
    local hunspell_path = props["SciteDefaultHome"].."\\hunspell\\hunspell.exe "
    local hunspell_dic  = props["SciteDefaultHome"].."\\hunspell\\en_GB "
    local hunspell_user = props["SciteDefaultHome"].."\\hunspell\\USER_DICT.dic "
    local hunspell_input= props["SciteDefaultHome"].."\\hunspell\\temp.txt "
    -- Make temp file (I can't find a way to send a string to hunspell.exe)
    local t = io.open(hunspell_input,"w")
    t:write(text)
    t:close()
    -- Set Hunspell command
    local cmd =    hunspell_path..[[ -a ]]
        cmd = cmd..[[-d ]]..hunspell_dic
        cmd = cmd..[[-p ]]..hunspell_user
        cmd = cmd..hunspell_input

    -- Run the command to get suggestions
    local fp = io.popen(cmd, "r")
    local Suggestions = fp:read("*l")   -- The first line (Hunspell version)
    Suggestions = fp:read("*l")         -- The second line (Suggestions)
    Suggestions = Suggestions:match(":.*$"):gsub(": ",""):gsub(",","")
    Suggestions = Suggestions.."  AddToUserDict".." AddToTypeDict".." AddToDirDict"
    Suggestions = Suggestions:gsub(" ",string.char(editor.AutoCSeparator))
    fp:close()
    -- Include AddTo functions
    -- Offer suggestions
    if not editor:AutoCActive() then
        -- User List
        scite.UserListFunctions[13] = function(text)
            if text=="AddToUserDict" then
                scite.AddToUserDict()
                return
            elseif text=="AddToTypeDict" then
                scite.AddToTypeDict()
                return
            elseif text=="AddToDirDict" then
                scite.AddToDirDict()
                return
            else
                editor:ReplaceSel(text)
            end
        end
        editor:UserListShow(13, Suggestions)
    end
end
function scite.AddToUserDict()          -- Store acceptable words for user
    -- This will only work for misspellings
    if editor:IndicatorValueAt(scite.SetIndicator("spelling"),editor.CurrentPos-1) ~= 0 then
        local fp = io.open(props["SciteDefaultHome"].."\\dictionary\\user.dic","a+")
        fp:write(scite.CurrentWord().."\n")
        fp:flush()
        fp:close()
    end
end
function scite.AddToTypeDict()          -- Store acceptable words for file type
    -- This will only work for misspellings
    if editor:IndicatorValueAt(scite.SetIndicator("spelling"),editor.CurrentPos-1) ~= 0 then
        local fp = io.open(props["SciteDefaultHome"].."\\dictionary\\"..props["FileExt"]..".dic","a+")
        fp:write(scite.CurrentWord().."\n")
        fp:flush()
        fp:close()
    end
end
function scite.AddToDirDict()           -- Store acceptable words for directory
    -- This will only work for misspellings
    if editor:IndicatorValueAt(scite.SetIndicator("spelling"),editor.CurrentPos-1) ~= 0 then
        local fp = io.open(props["FileDir"].."\\dir.dic","a+")
        fp:write(scite.CurrentWord().."\n")
        fp:flush()
        fp:close()
    end
end
function scite.WordCount()              -- Word Count
    -- https://groups.google.com/g/scite-interest/c/rTn_-aCXBKA
    local itt = 0
    local word = 0
    local wordCount = 0
    while itt < editor.LineCount do
        line = editor:GetLine(itt)
        if line then
            for word in string.gmatch(line, "%w+") do
                wordCount = wordCount + 1
            end
        end
        itt = itt + 1
    end
    return wordCount
end
function scite.Shortcuts()              -- List all keyboard shortcuts
    for i,v in pairs(scite.KeyActions) do
        print(debug.which(scite.KeyActions[i]),i)
    end
end
function scite.InsCurrFilename()        -- Current file name
    ins(props["FilePath"])
end
function scite.InsDate()                -- Insert today - set your own format
    --http://lua-users.org/wiki/SciteMiscScripts
    ins(os.date("%d-%m-%Y"))
end
function scite.PastePlainTxt()          -- Paste plain text ** external tool
    os.execute("GetPlainText.exe","",false,true)
    scite.MenuCommand(IDM_PASTE)
end
function scite.HelpIndex()              --  ** external tool
    os.execute([[shelexec.exe /DIR:%XTG_Home%editor/help /EXE %XTG_Home%editor/help/SynNotes.exe]])
--     local text = sel() or scite.CurrentWord() or ""
--     os.execute("%XTG_Home%editor/help/SynNotes.exe, %XTG_Home%editor/help")
--     os.execute("start http://localhost:8020/search.jsp?query="..text:gsub("%s","+").."&order=relevance_desc")
end
function scite.HelpInternet()           -- Internet search current selection ** default browser
    local text = sel() or scite.CurrentWord() or ""
    os.execute("start http://www.google.co.uk/search?q="..text:gsub("%s","+"))
end

-- ***Add functions to Tools Menu (Max 50) ***
scite.DefineTool("Spelling","dostring scite.CheckSpelling()")
scite.DefineTool("Prefix","dostring scite.Prefix()")
scite.DefineTool("Postfix","dostring scite.Postfix()")

-- ***Create Context Menu***
scite.EditorContextMenu = {             -- Main context menu
-- Assign command numbers if you want to add userdefined Lua functions
    "||",
    "&Clear Output |IDM_CLEAROUTPUT|"
}
props["user.context.menu"]=table.concat(scite.EditorContextMenu,"")

scite.OuputContextMenu = {              -- Output context menu - only in SciTE-ru
-- Assign command numbers if you want to add userdefined Lua functions
    "||",
    "Split	|IDM_SPLITVERTICAL|",
}
props["user.outputcontext.menu"]=table.concat(scite.OuputContextMenu,"")

