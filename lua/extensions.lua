
-- Autotable

function autotable()
-- Autotables -Tables that create their own subtables and indicies
-- 	http://lua-users.org/wiki/AutomagicTables
    local auto, assign

    function auto(tab, key)
	return setmetatable({}, {
	    __index = auto,
	    __newindex = assign,
	    parent = tab,
	    key = key
	})
    end

    local meta = {__index = auto}

    function assign(tab, key, val)
	if val ~= nil then
	    local oldmt = getmetatable(tab)
	    oldmt.parent[oldmt.key] = tab
	    setmetatable(tab, meta)
	    tab[key] = val
	else
	    return nil
	end
    end

    return setmetatable({}, meta)
end

-- General functions

function kpairs(t, comp)
-- https://stackoverflow.com/questions/15706270/sort-a-table-in-lua
	if comp == "desc" then
		comp = function(a,b) return a>b end
	end

	local a = {}
	for n in pairs(t) do
		table.insert(a, n)
	end
	table.sort(a, comp)
	local i = 0      					-- iterator variable
	local iter = function ()   				-- iterator function
		i = i + 1
		if a[i] == nil then
			return nil
		else
			return a[i], t[a[i]]
		end
	end
end

function table.dedup(t)
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

function table.diff(t,s)
    print("Testing tables:",table.name(t),table.name(s))
    for i,v in pairs(t) do
        if type(v)=="table" then
            table.diff(v,s[i])
        elseif rawget(t,i)~=rawget(s,i) then
            print(rawget(t,i),"~=",rawget(s,i))
        end
    end
end

function table.stash(t,level,output)
-- My recursive serialization function
--	with great help from http://lua-users.org/lists/lua-l/2009-11/msg00533.html
    if type(t)~="table" then
	return "Error not a table: "..tostring(t)
    end

-- Define output variable
    output = output or {}

-- Define level
    level = level or 1

-- Define tab command
    local function tab(level)
	return string.rep("\t", level)
    end

-- Define functions for all data types
    local function stash_string(i,v)
        table.insert(output,tab(level)..'["'..tostring(i)..'"] = '..string.format("%q", v))
        return
    end

    local function stash_number(i,v)
        table.insert(output,tab(level)..'["'..tostring(i)..'"] = '..tostring(v))
        return
    end

    local function stash_boolean(i,v)
        table.insert(output,tab(level)..'["'..tostring(i)..'"] = '..tostring(v))
        return
    end

    local function stash_nil(i,v)
        table.insert(output,tab(level)..'["'..tostring(i)..'"] = nil')
        return
    end

    local function stash_table(i,v) -- Recurse function
        table.insert(output,tab(level)..'["'..tostring(i)..'"] = {')
        level = level+1
            table.stash(v,level,output)
        level	= level-1
        return
    end

    local function stash_function(i,v) -- This needs an error handler to catch [C] functions ***
-- 	table.insert(output,tab(level)..'["'..tostring(i)..'"] = loadstring('..string.format("%q", string.dump(v,true))..")")
        table.insert(output,tab(level)..'["'..tostring(i)..'"] = loadstring('..string.format("%q", tostring(v))..")")
    end

    local function stash_userdata(i,v)
        table.insert(output,tab(level)..'["'..tostring(i)..'"] = userdata('..i..")")
    end

-- Prime the output tables
    if level==1 then
        table.insert(output," return {")
    end

-- Loop through table using the correct stash function
    for i,v in pairs(t) do
        local item = type(v)
        if item=="string" 	then stash_string(i,v) end
        if item=="number" 	then stash_number(i,v) end
        if item=="boolean" 	then stash_boolean(i,v) end
        if item=="nil" 		then stash_nil(i,v) end
        if item=="table" 	then stash_table(i,v) end
        if item=="function"	then stash_function(i,v) end
        if item=="userdata" 	then stash_userdata(i,v) end
    end

-- Close the current table
    table.insert(output,tab(level).."}")

-- Close and stringify the final table
    if level==1 then
        -- Concatenate
        output =  table.concat(output,",\n")
        -- Correct errors
        output = string.gsub(output,"{,","{")
    end
-- Returns table or string depending upon level
    return output
end

function table.grab(input,func)
-- Loads stashed lua table with option for bespoke unpacking - sandboxing
    if type(input)~="string" then
        return "Error not a string: "..tostring(t)
    end

    if type(func)=="function" then
        local t=func(input)
    else
        local t=dostring(input)
    end

    if type(t)~="table" then
    	return "Error table could not be reformed: "..tostring(input)
    else
        return t
    end
end

function table.length(t)
  local count = 0
  for _ in pairs(t) do count = count + 1 end
  return count
end

function table.match(t,s)
    if not type(t)=="table" then return end
    if not type(tostring(s))=="string" then return end
    for i,v in pairs(t) do
        if v==s then
            return true
        end
    end
    return false
end

function string.trim(s)
    return s:match('^%s*(.-)%s*$')
end

function string.split(inputstr, sep)
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

function os.datevalid(value)
	-- 	Check for a UK date pattern dd/mm/yyyy , dd-mm-yyyy, dd.mm.yyyy
	if (string.match(value, "^%d+%p%d+%p%d%d%d%d$")) then
		local d, m, y = string.match(value, "(%d+)%p(%d+)%p(%d+)")
		d, m, y = tonumber(d), tonumber(m), tonumber(y)

		local dm2 = d*m*m
		if  d>31 or m>12 or dm2==116 or dm2==120 or dm2==124 or dm2==496 or dm2==1116 or dm2==2511 or dm2==3751 then
			-- invalid unless leap year
			if dm2==116 and (y%400 == 0 or (y%100 ~= 0 and y%4 == 0)) then
				return true, d, m, y
			else
				return false
			end
		else
			return true, d, m, y
		end
	else
		return false
	end
end

function os.datestamp(date1)
-- Returns date stamp for file names e.g. 201507_28_70089
	--	e.g. print(os.datestamp())
    if date1 and date1~="" then
        if os.datevalid(date1) then
            v, d, m, y = os.datevalid(date1)
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

function os.stampdate(stamp)
-- Returns date and time from stamp
    local t = string.split(stamp,"_")
    t[5] = math.floor(t[4]/3600) 	-- Hours
    t[4] = t[4]%3600
    t[6] = math.floor(t[4]/60)	-- Mins
    t[4] = t[4]%60			-- Secs
    return {tonumber(t[1]), tonumber(t[2]), tonumber(t[3]), t[5], t[6], t[4]}
end

function io.exists(filename)
-- io.exists(filename or directory)
    if type(filename)~="string" then
	    return false
    end
    if shell then
        return shell.fileexists(filename)
    else
        return os.rename(filename,filename) and true or false
        -- Source: http://stackoverflow.com/questions/4990990/lua-check-if-a-file-exists
    end
end

function io.chdir(path)
-- io.chdir(path) - an extension to set current directory absolute or relative
    if gui then
		gui.chdir(path)
		return
    end
    if lfs then
		lfs.chdir(path)
		return
    end
    os.execute("chdir /d " .. path)
end

function io.mkdir(path)
-- io.mkdir(path) - an extension to create a directory absolute or relative
    if lfs then
        lfs.mkdir(path)
        return
    end
    if shell then
        shell.exec("CMD /c mkdir " .. path, nil, true, true)
        return
    end
    os.execute("mkdir " .. path)
end

function io.filepath(filename)
-- http://stackoverflow.com/questions/5243179/what-is-the-neatest-way-to-split-out-a-path-name-into-its-components-in-lua
    if filename then
        local mypath, myfile, myext = string.match(filename, "(.-)([^\\]-([^%.]+))$")
        return mypath
    else
        return nil
    end
end

function io.filename(filename)
-- http://stackoverflow.com/questions/5243179/what-is-the-neatest-way-to-split-out-a-path-name-into-its-components-in-lua
    if filename then
        local mypath, myfile, myext = string.match(filename, "(.-)([^\\]-([^%.]+))$")
        return myfile
    else
        return nil
    end
end

function io.SplitFileName(filename,request)
    local p,n,e = string.match(filename,"(.-)([^\\/]-%.?([^%.\\/]*))$")

    if request=="p" then
        return p
    end
    if request=="n" then
        return n -- Including the extension
    end
    if request=="e" then
        return e
    end
end

function io.scriptname()
-- Returns the top level script name
    local ret
    local level = 1
    while debug.getinfo(level, "S") and debug.getinfo(level, "S").source:sub(2)~="[C]" do
        ret  = debug.getinfo(level, "S").source:sub(2)
        level = level+1
    end

    if ret and os.rename(ret,ret) and true or false then
        return ret
    else
        return nil
    end
end

function io.scriptpath()
-- Return the path to the current script
    local mypath, myfile, myext = string.match(io.scriptname(), "(.-)([^\\]-([^%.]+))$")
    return mypath
end

function io.cdscript()
    -- CD top level script path
    local mypath, myfile, myext = string.match(io.scriptname(), "(.-)([^\\]-([^%.]+))$")
    io.chdir(mypath)
end

function io.files(glob)
-- Return table of files
    require("afx")
    local output  = {}
    local opt = {}
        opt.param       = "n$cf";
        opt.recurse     = true;
        opt.skipdirs    = true;
        opt.rettable    = true;
        opt.callback    = function(fpath) table.insert(output,fpath) end
    afx.findfile(glob, opt)
    return output
end

function io.findfiles(path,glob)
-- Recurse path and find all matches for glob, return a table of tables: {name created FilePathNameExt}
    require("afx")
    local output = {}
    local opt = {}
        opt.param       = "n$cf";
        opt.recurse     = true;
        opt.skipdirs    = true;
        opt.rettable    = true;
        opt.callback    = function(name, time, fpath) table.insert(output,{name, time, fpath}) end
        afx.findfile(path.."\\"..glob, opt)
    return output
end

function io.stash(t,filename)
-- Serialize to file
--	Dependent upon table.stash()
--	Should process both path separators and relative paths ***
    if type(t)~="table" then
        return "Error not a table: "..tostring(t)
    end

    -- Check for valid filename ***

    -- Serialize
    t = table.stash(t)

    -- Write to disc
    local f = io.open(filename,"w")
    f:write(t)
    io.close(f)
    -- Return?
end

function io.grab(filename)
-- Load a stashed string.. or an lua code!
    dofile(filename)
end

function debug.which(funcname)
--  identifies the source for the current definition of funcname
--  designed for the console, has been modified to return a string
--
    if type(funcname)~="function" then
	    return  tostring(funcname).. ": is a "..type(funcname)
    end

    local info = _G.debug.getinfo(funcname)
    if info.short_src=="[C]" then
--         print("Compiled "..info.short_src.." code:")
        return "Compiled "..info.short_src.." code:"
    else
--         print(info.short_src..":"..info.linedefined)
        return info.short_src -- ,info.linedefined
    end
end

-- Validation functions

function decodeURIComponent(str)
	local str = str:gsub('+', ' ')
	return (str:gsub("%%(%x%x)", function(c)
			return string.char(tonumber(c, 16))
	end))
end

function vstring(value)
	if tonumber(value) ~= nil then
		return false
	end
	if type(value)=="string" then
		return true
	else
		return false
	end
end

function vnumber(value)
	if tonumber(value) ~= nil then
		return true
	else
		return false
	end
end

function vdob(value)
	local v, d, m, y = os.datevalid(value)
	if v == true then
	-- Check against today
		local today = os.date('*t')
		if today.year<y then
			return false
		end
		if today.year==y and today.month<m then
			return false
		end
		if today.year==y and today.month==m and today.d<d then
			return false
		end
		return true, d, m, y
	end

end

function vemail(value)
-- Validate an email pattern
	if (value:match("[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?")) then
		return true
	else
		return false
	end
end

function age(dob,today)
-- Check for valid dob
	local v,d,m,y = vdob(dob)
	if v~=true then
		return nil
	end

	-- Check for second parameter
	local vv,d2,m2,y2
	if today==nil then
		d2=tonumber(os.date("%d"))
		m2=tonumber(os.date("%m"))
		y2=tonumber(os.date("%Y"))
	else
		vv,d2,m2,y2 = os.datevalid(today)
		if vv==false or vv==nil then
			d2=tonumber(os.date("%d"))
			m2=tonumber(os.date("%m"))
			y2=tonumber(os.date("%Y"))
		end
	end

	-- Do the calculations
	if y>y2 then
		return nil
	end

	local age = y2-y

	if m>m2 then
		age = age-1
	end
	if m==m2 and d>d2 then
		age = age-1
	end

	return age
end

