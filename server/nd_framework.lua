if GetResourceState("ND_Core") == "started" then
    print("^5Starting with ND_Core^0")
    
    NDCore = exports["ND_Core"]:GetCoreObject()
    local items = exports.ox_inventory:Items()
    
    RegisterNetEvent("ND:setCharacterOnline", function(id)
        local _source = source
        local gang = GetPlayerGang(_source)
        player_to_gang[_source] = gang
        TriggerClientEvent("exp_turfwars:SetPlayerGang", _source, gang) -- MUST BE TRIGGERED WHEN CONNECTION
    end)
    
    function GetPlayerGang(player_src)
        local player = NDCore.Functions.GetPlayer(player_src)
        return player.data.groupName
    end
    
    function GetPlayerItemCount(player_src, item)
        local player = NDCore.Functions.GetPlayer(player_src)
        return exports.ox_inventory:GetItemCount(player.inventory, item)
    end
    
    function RemovePlayerItem(player_src, item, amount)
        local player = NDCore.Functions.GetPlayer(player_src)
        exports.ox_inventory:RemoveItem(player.inventory, item, amount)
        return true
    end
    
    function GivePlayerMoney(player_src, amount)
        NDCore.Functions.AddMoney(amount, player_src, "cash", "Drug Sell")
        return true
    end
    
    function GetItemLabel(item)
        return items[item].label
    end
    
    function GetPoliceCount()
        local count = 0
    
        for _, value in pairs(NDCore.Functions.GetPlayers("job", "lspd")) do
            count = count + 1
        end
    
        return count
    end
    
    function DiscordLog(player_src, event)
        -- Connect to your log system
    end
    
    RegisterNetEvent("exp_turfwars:SendPoliceAlert")
    AddEventHandler("exp_turfwars:SendPoliceAlert", function(position)
        for _, value in pairs(NDCore.Functions.GetPlayers("job", "lspd")) do
            TriggerClientEvent("exp_turfwars:ShowPoliceAlert", value.source, position)
        end
    end)
end
