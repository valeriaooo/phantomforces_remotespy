-- original code from https://v3rmillion.net/showthread.php?tid=974599
local players = game:GetService('Players');
local client = players.LocalPlayer;

local network
local old_send
local old_fetch

for i, v in next, getgc(true) do
    if type(v) == "function" and not is_synapse_function(v) then
        for k, x in next, debug.getupvalues(v) do
            if type(x) == "table" then
                if rawget(x, 'send') then
                    network = x
                    old_send = x.send
                    old_fetch = x.fetch
                end
            end
        end
    end
end

getgenv().filter = {"ng", "repup", "ressionassist"}

local function StringContans(str, sub)
    return string.find(str, sub) ~= nil
end

-- check if character is in the alphabet 
local function IsAlphabet(char)
    return char:match("%a") ~= nil
end

-- loop through all characters in a string
local function ForEachChar(str, func)
    for i = 1, #str do
        func(str:sub(i, i))
    end
end


-- loop through each character in the string#
-- check for a whitespace and replace it with a underscore
local function ReplaceWhitespace(str)
    local new_str = ""
    ForEachChar(str, function(char)
        if not IsAlphabet(char) then
            new_str = new_str .. "_"
        else
            new_str = new_str .. char
        end
    end)
    return new_str
end

local function LookThroughAllTables(table)
    if type(table) == "table" then
        warn(("="):rep(2), tostring(table), ("="):rep(2))
        for i, v in next, table do
            warn("-- ", i, v, "type:", tostring(type(v)))
            if type(v) == "table" then
                LookThroughAllTables(v)
            end
        end
    end
    warn(("="):rep(2), tostring(table), ("="):rep(2))
end

function network.send(self, action, ...)
    local arguments = {...}
    if StringContans(action, "repup") or StringContans(action, "ressionassist") or StringContans(action, "ng") then
        return old_send(self, action, unpack(arguments))
    end

    print(("="):rep(10))
    print('network.send called with action:', action)
    warn('action whitespaces:', ReplaceWhitespace(action))

    for i, v in next, arguments do
        warn(i, v, "type:", tostring(type(v)))
        if type(v) == "table" then
            LookThroughAllTables(v)
        end
    end

    print(("="):rep(10))
    return old_send(self, action, unpack(arguments))
end

-- do for loops until type is no longer a table

function network.fetch(self, action, ...)
    local arguments = {...}
    if StringContans(action, "repup") or StringContans(action, "ressionassist") or StringContans(action, "ng") then
        return old_fetch(self, action, unpack(arguments))
    end

    print(("="):rep(10))
    print('network.fetch called with action:', action)
    warn('action whitespaces:', ReplaceWhitespace(action))

    for i, v in next, arguments do
        warn(i, v, "type:", tostring(type(v)))
        if type(v) == "table" then
            LookThroughAllTables(v)
        end
    end

    print(("="):rep(10))
    return old_fetch(self, action, unpack(arguments))
end
