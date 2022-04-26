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

local function stringcontains(str, sub)
    return string.find(str, sub) ~= nil
end

local function LookThroughAllTables(table)
    if type(table) == "table" then
        warn(("="):rep(1), tostring(table), ("="):rep(1))
        for i, v in next, table do
            print(i, v)
            if type(v) == "table" then
                LookThroughAllTables(v)
            end
        end
    end
end

function network.send(self, action, ...)
    local arguments = {...}
    if stringcontains(action, "repup") or stringcontains(action, "ressionassist") or stringcontains(action, "ng") then
        return old_send(self, action, unpack(arguments))
    end

    print(("="):rep(10))
    print('network.send called with action:', action)

    for i, v in next, arguments do
        warn(i, v)
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
    if stringcontains(action, "repup") or stringcontains(action, "ressionassist") or stringcontains(action, "ng") then
        return old_fetch(self, action, unpack(arguments))
    end

    print(("="):rep(10))
    print('network.fetch called with action:', action)

    for i, v in next, arguments do
        warn(i, v)
        if type(v) == "table" then
            if type(v) == "table" then
                LookThroughAllTables(v)
            end
        end
    end

    print(("="):rep(10))
    return old_fetch(self, action, unpack(arguments))
end
