if GetResourceState("qb-core") == "started" then
    print("^5Starting with QB-Core^0")

    QBCore = exports['qb-core']:GetCoreObject()
    
    RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
        local _source = source
        local gang = GetPlayerGang(_source)
        player_to_gang[_source] = gang
        TriggerClientEvent("exp_turfwars:SetPlayerGang", _source, gang) -- MUST BE TRIGGERED ON CONNECTION
    end)
    
    function GetPlayerGang(player_src)
        return QBCore.Functions.GetPlayer(source).PlayerData.gang.name
    end
    
    ---@param source any Server id
    ---@param item string Item name
    ---@return number count Item count
    function GetPlayerItemCount(source, item)
        local player_item = QBCore.Functions.GetPlayer(source).Functions.GetItemByName(item)
        return player_item and player_item.amount or 0
    end
    ---@param source any Server id
    ---@param item string Item name
    ---@param amount number Amount to remove
    function RemovePlayerItem(source, item, amount)
        QBCore.Functions.GetPlayer(source).Functions.RemoveItem(item, amount)
        return true
    end
    
    ---@param source any Server id
    ---@param amount any Money amount
    function GivePlayerMoney(source, amount)
        QBCore.Functions.GetPlayer(source).Functions.AddMoney("cash", amount)
        return true
    end
    
    function GetItemLabel(item)
        return QBCore.Shared.Items[item].label
    end
    
    function GetPoliceCount()
        local count = 0
        for ServerId, Player in ipairs(QBCore.Functions.GetQBPlayers()) do
            if Player.PlayerData.job.name == "police" then
                count = count + 1
            end
        end
        return count
    end
    
    function DiscordLog(player_src, event)
        -- Connect to your log system
    end
    
    RegisterNetEvent("exp_trainheist:SendPoliceAlert", function(coords)
        for ServerId, Player in ipairs(QBCore.Functions.GetQBPlayers()) do
            if Player.PlayerData.job.name == "police" then
                TriggerClientEvent("exp_bank_robbery:ShowPoliceAlert", ServerId, coords)
            end
        end
    end)
end
