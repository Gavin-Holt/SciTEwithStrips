assert(v [, message]) -- error if v nil or false, otherwise returns v
Current:CursorUp()
Current:CursorDown()
Current:CursorPageUp()
Current:CursorPageDown()
Current:CursorLeft()
Current:CursorRight()
Current:CursorStart()
Current:CursorEnd()
Current:SelectToStart()
Current:SelectToEnd()
Current:SelectUp()
Current:SelectDown()
Current:SelectLeft()
Current:SelectRight()
Current:SelectToStartOfText()
Current:SelectToStartOfTextToggle()
Current:WordRight()
Current:WordLeft()
Current:SelectWordRight()
Current:SelectWordLeft()
Current:MoveLinesUp()
Current:MoveLinesDown()
Current:DeleteWordRight()
Current:DeleteWordLeft()
Current:SelectLine()
Current:SelectToStartOfLine()
Current:SelectToEndOfLine()
Current:InsertNewline()
Current:InsertSpace()
Current:Backspace()
Current:Delete()
Current:Center()
Current:InsertTab()
Current:Save()
Current:SaveAll()
Current:SaveAs()
Current:Find()
Current:FindLiteral()
Current:FindNext()
Current:FindPrevious()
Current:Undo()
Current:Redo()
Current:Copy()
Current:CopyLine()
Current:Cut()
Current:CutLine()
Current:DuplicateLine()
Current:DeleteLine()
Current:IndentSelection()
Current:OutdentSelection()
Current:OutdentLine()
Current:IndentLine()
Current:Paste()
Current:SelectAll()
Current:OpenFile()
Current:Start()
Current:End()
Current:PageUp()
Current:PageDown()
Current:SelectPageUp()
Current:SelectPageDown()
Current:HalfPageUp()
Current:HalfPageDown()
Current:StartOfLine()
Current:EndOfLine()
Current:StartOfText()
Current:StartOfTextToggle()
Current:ParagraphPrevious()
Current:ParagraphNext()
Current:ToggleHelp()
Current:ToggleDiffGutter()
Current:ToggleRuler()
Current:JumpLine()
Current:ClearStatus()
Current:ShellMode()
Current:CommandMode()
Current:Quit()
Current:QuitAll()
Current:AddTab()
Current:PreviousTab()
Current:NextTab()
Current:NextSplit()
Current:Unsplit()
Current:VSplit()
Current:HSplit()
Current:PreviousSplit()
Current:ToggleMacro()
Current:PlayMacro()
Current:ScrollUp()
Current:ScrollDown()
Current:SpawnMultiCursor()
Current:SpawnMultiCursorUp()
Current:SpawnMultiCursorDown()
Current:SpawnMultiCursorSelect()
Current:RemoveMultiCursor()
Current:RemoveAllMultiCursors()
Current:SkipMultiCursor()
Current:JumpToMatchingBrace()
Current:Autocomplete()
collectgarbage([limit]) -- set threshold to limit KBytes, default 0, may run GC
coroutine.create(f) -- creates coroutine from function f, returns coroutine
coroutine.resume(co, val1, ...) -- continues execution of co, returns bool status plus any values
coroutine.status(co) -- returns co status: "running", "suspended" or "dead"
coroutine.wrap(f) -- creates coroutine with body f, returns function that resumes co
coroutine.yield(val1, ...) -- suspend execution of calling coroutine
debug.debug() -- enters interactive debug mode, line with only "cont" terminates
debug.gethook() -- returns current hook function, hook mask, hook count
debug.getinfo(function [, what]) -- returns table with information about a function
debug.getlocal(level, local) -- returns name and value of local variable with index local at stack level
debug.getupvalue(func, up) -- returns name and value of upvalue with index up of function func
debug.sethook(hook, mask [, count]) -- sets given function as a hook, mask="[crl]"
debug.setlocal(level, local, value) -- sets local variable with index local at stack level with value
debug.setupvalue(func, up, value) -- sets upvalue with index up of function func with value
debug.traceback([message]) -- returns a string with a traceback of the call stack
dofile(filename) -- executes as Lua chunk, default stdin, returns value
error(message [, level]) -- terminates protected func, never returns, level 1(default), 2=parent
file:close() -- closes file
file:flush() -- saves any written data to file
file:lines() -- returns iterator function to return lines, nil ends
file:read(format1, ...) -- reads file according to given formats, returns read values or nil
file:seek([whence] [, offset]) -- sets file pos, whence="set"|"cur"|"end", defaults "curr",0, returns file pos
file:write(value1, ...) -- writes strings or numbers to file
gcinfo() -- returns dynamic mem in use(KB), and current GC threshold(KB)
getfenv(f) -- gets env, f can be a function or number(stack level, default=1), 0=global env
getmetatable(object) -- returns metatable of given object, otherwise nil
io.close([file]) -- closes file, or the default output file
io.flush() -- flushes the default output file
io.input([file]) -- opens file in text mode, sets as default input file, or returns current default input file
io.lines([filename]) -- open file in read mode, returns iterator function to return lines, nil ends
io.open(filename [, mode]) -- opens file in specified mode "[rawb+]", returns handle or nil
io.output([file]) -- opens file in text mode, sets as default output file, or returns current default output file
io.read(format1, ...) -- reads file according to given formats, returns read values or nil
io.stderr file descriptor for STDERR
io.stdin file descriptor for STDIN
io.stdout file descriptor for STDOUT
io.tmpfile() -- returns a handle for a temporary file, opened in update mode
io.type(obj) -- returns "file" if obj is an open file handle, "close file" if closed, or nil if not a file handle
io.write(value1, ...) -- writes strings or numbers to file
ipairs(t) -- returns an iterator function, table t and 0
loadfile(filename) -- loads chunk without execution, returns chunk as function, else nil plus error
loadlib(libname, funcname) -- links to dynamic library libname, returns funcname as a C function
loadstring(string [, chunkname]) -- loads string as chunk, returns chunk as function, else nil plus error
math.abs(v) -- returns absolute value of v
math.acos(v) -- returns arc cosine value of v in radians
math.asin(v) -- returns arc sine value of v in radians
math.atan(v) -- returns arc tangent value of v in radians
math.atan2(v1, v2) -- returns arc tangent value of v1/v2 in radians
math.ceil(v) -- returns smallest integer >= v
math.cos(rad) -- returns cosine value of angle rad
math.deg(rad) -- returns angle in degrees of radians rad
math.exp(v) -- returns e^v
math.floor(v) -- returns largest integer <= v
math.frexp(v) -- returns mantissa [0.5,1) -- and exponent values of v
math.ldexp(v1, v2) -- returns v1*2^v2
math.log(v) -- returns natural logarithm of v
math.log10(v) -- returns logarithm 10 of v
math.max(v1, ...) -- returns maximum in a list of one or more values
math.min(v1, ...) -- returns minimum in a list of one or more values
math.mod(v1, v2) -- returns remainder of v1/v2 which is v1 - iV2 for some integer i
math.pow(v1, v2) -- returns v1 raised to the power of v2
math.rad(deg) -- returns angle in radians of degrees deg
math.random([n [, u]]) -- returns random real [0,1), integer [1,n] or real [1,u](with n=1)
math.randomseed(seed) -- sets seed for pseudo-random number generator
math.sin(rad) -- returns sine value of angle rad
math.sqrt(v) -- returns square root of v
math.tan(rad) -- returns tangent value of angle rad
next(table [, index]) -- returns next index,value pair, if index=nil(default), returns first index
os.clock() -- returns CPU time used by program in seconds
os.date([format [, time]]) -- returns a string or table containing date and time, "*t" returns a table
os.difftime(t2, t1) -- returns number of seconds from time t1 to time t2
os.execute(command) -- executes command using C function system, returns status code
os.exit([code]) -- terminates host program with optional code, default is success code
os.getenv(varname) -- returns value of environment variable varname. nil if not defined
os.remove(filename) -- deletes file with given name, nil if fails
os.rename(oldname, newname) -- renames file oldname to newname, nil if fails
os.setlocale(locale [, category]) -- set current locale of program, returns name of new locate or nil
os.time([table]) -- returns current time(usually seconds) -- or time as represented by table
os.tmpname() -- returns a string with a filename for a temporary file(dangerous! tmpfile is better)
pairs(t) -- returns the next function and table t plus a nil, iterates over all key-value pairs
pcall(f, arg1, arg2, ...) -- protected mode call, catches errors, returns status code first(true=success)
print(e1, e2, ...) -- prints values to stdout using tostring
rawequal(v1, v2) -- non-metamethod v1==v2, returns boolean
rawget(table, index) -- non-metamethod get value of table[index], index != nil
rawset(table, index, value) -- non-metamethod set value of table[index], index != nil
require(packagename) -- loads package, updates _LOADED, returns boolean
setfenv(f, table) -- sets env, f can be a function or number(stack level, default=1), 0=global env
setmetatable(table, metatable) -- sets metatable, nil to remove metatable
string.byte()
string.byte(s [, i]) -- returns numerical code, nil if index out of range, default i=1
string.char()
string.char(i1, i2, ...) -- returns a string built from 0 or more integers
string.dump()
string.dump(function) -- returns binary representation of function, used with loadstring
string.find()
string.find(s, pattern [, init [, plain]]) -- matches pattern in s, returns start,end indices, else nil
string.format()
string.format(formatstring, e1, e2, ...) -- returns formatted string, printf-style
string.gfind(s, pat) -- returns iterator function that returns next captures from pattern pat on s
string.gmatch()
string.gsub()
string.gsub(s, pat, repl [, n]) -- returns copy of s with pat replaced by repl, and substitutions made
string.len()
string.len(s) -- returns string length
string.lower()
string.lower(s) -- returns string with letters in lower case
string.match()
string.pack()
string.packsize()
string.rep()
string.rep(s, n) -- returns string with n copies of string s
string.reverse()
string.split()
string.sub()
string.sub(s, i [, j]) -- returns substring from index i to j of s, default j=-1(string length)
string.trim()
string.unpack()
string.upper()
string.upper(s) -- returns string with letters in upper case
table.concat()
table.concat(table [, sep [, i [, j]]]) -- returns concatenated table elements i to j separated by sep
table.dedup()
table.diff()
table.foreach(table, f) -- executes f(index,value) -- over all elements of table, returns first non-nil of f
table.foreachi(table, f) -- executes f(index,value) -- in sequential order 1 to n, returns first non-nil of f
table.getn(table) -- returns size of table, or n field, or table.setn value, or 1 less first index with nil value
table.grab(string) -- GMH Unserialize string to table
table.insert()
table.insert(table, [pos,] value) -- insert value at location pos in table, default pos=n+1
table.length()
table.match()
table.move()
table.pack()
table.remove()
table.remove(table [, pos]) -- removes element at pos from table, default pos=n
table.setn(table, n) -- sets size of table, n field of table if it exists
table.sort()
table.sort(table [, comp]) -- sorts in-place elements 1 to n, comp(v1,v2) -- true if v1<v2, default <
table.stash(table) -- GMH Serialize table to string
table.unpack()
tonumber(e [, base]) -- convert to number, returns number, nil if non-convertible, 2<=base<=36
tostring(e) -- convert to string, returns string
type(v) -- returns type of v as a string
unpack(list) -- returns all elements from list
xpcall(f, err) -- pcall function f with new error handler err
for i,v in pairs() do -- key value iteration
for i,v in ipairs() do -- array iteration
for i=1,100,1 do print(i) end -- simple loop http://lua.lickert.net/loop/index_en.html
repeat until(bool) -- execute and possibly repeat
while(bool) do end -- test before each execution
globals(_G)  -- from extensions: list all the top level tables in any table (or _G)
tables(_G)  -- from extensions: list all the top level non-tables/non-functions in _G
functions(_G) -- from extensions: list all the top level functions in any table (or _G)
paths(_G) -- from extensions: list package.path and package.cpath
paths(_G) -- from extensions: list package.path and package.cpath

