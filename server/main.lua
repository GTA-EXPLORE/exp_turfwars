player_to_gang, turfs = {}, {}

MySQL.ready(function()
    local results = MySQL.query.await('SELECT * FROM turfs')
    for _, row in ipairs(results) do
        turfs[row.name] = {
            name = row.name,
            gang = row.gang,
            reputations = json.decode(row.reputations)
        }
    end
end)

RegisterServerCallback("exp_turfwars:GetTurfData", function(source, callback, turf)
    callback(turfs[turf])
end)

RegisterServerEvent("exp_turfwars:GangAlert")
AddEventHandler("exp_turfwars:GangAlert", function(gang, turf)
    for player_sid, player_gang in pairs(player_to_gang) do
        if player_gang == gang then
            TriggerClientEvent("exp_turfwars:ShowNotification", player_sid, {
                title = _("notif_title"),
                message = _("gang_notif", _(turf)),
                type = "default"
            })
        end
    end
end)

RegisterServerEvent("exp_turfwars:SellIn")
AddEventHandler("exp_turfwars:SellIn", function(turf)
    local _source = source
    local rep = SellDrug(_source, TURF_MULTIPLIER, turf)
    if player_to_gang[_source] then
        IncreaseReputation(turf, player_to_gang[_source], rep, _source)
    end
end)

RegisterServerEvent("exp_turfwars:SellOut")
AddEventHandler("exp_turfwars:SellOut", function()
    SellDrug(source, 1, turf)
end)

function SellDrug(source, multiplier, turf)
    local product = {}
    local empty = true
    for item, price in pairs(DRUGS) do
        local count = GetPlayerItemCount(source, item)
        if count > 0 then
            product = {
                Item = item,
                Count = math.random(1, math.min(MAX_SELL, count)),
                Price = price
            }
            empty = false
            break
        end
    end
    
    if empty then
        TriggerClientEvent("exp_turfwars:ShowNotification", source, {
            title = _("notif_title"),
            message = _("empty"),
            type = "error"
        })
        return 0
    else
        RemovePlayerItem(source, product.Item, product.Count)

        local earnings = math.ceil(product.Count*product.Price*multiplier)
        GivePlayerMoney(source, earnings)
        TriggerClientEvent("exp_turfwars:ShowNotification", source, {
            title = _("notif_title"),
            message = _("sold", product.Count, GetItemLabel(product.Item)),
            type = "default"
        })
        DiscordLog(source, {
            name = "sell",
            item = product.Item,
            count = product.Count,
            turf = turf,
            earnings = earnings
        })
        return product.Count
    end
end

function IncreaseReputation(turf, gang, rep, source)
    turfs[turf].reputations[gang] = (turfs[turf].reputations[gang] or 0) + rep
    if turfs[turf].reputations[gang] > turfs[turf].reputations[turfs[turf].gang] then
        turfs[turf].gang = gang
        TriggerClientEvent("exp_turfwars:Captured", -1, turf, gang)
        DiscordLog(source, {
            name = "capture",
            gang = gang,
            turf = turf
        })
    end
end

-- REPUTATION LOSS & SAVE THREAD
Citizen.CreateThread(function()
    while true do Wait(REPUTATION_LOSS_TIMER)
        
        for turf, data in pairs(turfs) do
            local sum = 0
            for k, val in pairs(data.reputations) do
                data.reputations[k] = math.max(val - REPUTATION_LOSS, 0)
                sum = sum + data.reputations[k]
            end

            local newGang = data.gang
            if sum == 0 then
                newGang = "neutral"
            end

            MySQL.update.await('UPDATE turfs SET reputations = @reputations, gang = @gang WHERE name = @name', {
                ["@reputations"] = json.encode(data.reputations),
                ["@name"] = turf,
                ["@gang"] = newGang
            })
        end
    end
end)

RegisterServerCallback("exp_turfwars:EnoughCops", function(source, callback)
    callback(GetPoliceCount()>=REQUIRED_POLICE)
end)

AddEventHandler('playerDropped', function(reason)
    player_to_gang[source] = nil    
end)
