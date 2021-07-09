-- original code from https://v3rmillion.net/showthread.php?tid=974599

local players = game:GetService('Players');
local client = players.LocalPlayer;

local network = require(game:GetService("ReplicatedFirst").ClientModules.Old.framework.network)
local send = network.send;
local fetch = network.fetch;

getgenv().filter = {"ping", "repupdate", "suppressionassist"}

function contains(table, element)
    for _, value in pairs(table) do
      if value == element then
        return true
      end
    end
    return false
  end

function network.send(self, action, ...)
    local arguments = {...}
    if contains(getgenv().filter, action) then return send(self, action, unpack(arguments)) end

    print(("="):rep(10))
    print('network.send called with action:', action)
    
    for i, v in next, arguments do
        warn(i, v)
    end
    
    print(("="):rep(10))
    return send(self, action, unpack(arguments))
end

function network.fetch(self, action, ...)
    local arguments = {...}
    if contains(getgenv().filter, action) then return send(self, action, unpack(arguments)) end
    print(("="):rep(10))
    print('network.fetch called with action:', action)
        
    for i, v in next, arguments do
            warn(i, v)
        end
    
        print(("="):rep(10))
    return fetch(self, action, unpack(arguments))
end
