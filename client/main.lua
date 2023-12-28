player = {}
local oldPeds = {}
local turfData = nil

RegisterNetEvent("exp_turfwars:SetPlayerGang")
AddEventHandler("exp_turfwars:SetPlayerGang", function(gang)
    player.Gang = gang
end)

-- TURF THREAD
Citizen.CreateThread(function()
    while true do Wait(1000)
        player.Ped = PlayerPedId()
        for turf, v in pairs(TURFS) do
            if IsPlayerInPolygon(v.Polygon, player.Ped) then
                TriggerServerCallback("exp_turfwars:GetTurfData", function(data)
                    turfData = data
                end, turf)

                while IsPlayerInPolygon(v.Polygon, player.Ped) do Wait(500)
                    if IsRadarHidden() then
                        DisplayTurfOnScreen(false)
                    else
                        DisplayTurfOnScreen(true, turfData.gang)
                    end
                end -- WAIT FOR PLAYER TO EXIT TURF
                DisplayTurfOnScreen(false)
                turfData = nil
            end
        end
    end
end)

-- SELL THREAD
RegisterNetEvent("exp_turfwars:SellDrug")
AddEventHandler("exp_turfwars:SellDrug", function(entity)
    player.Ped = PlayerPedId()

    if not oldPeds[entity] and not IsPedDeadOrDying(entity, 1) and not IsPedFleeing(entity) and not IsPedInMeleeCombat(entity) and not IsPedInAnyVehicle(entity, true) then
        ClearPedTasks(entity)
        oldPeds[entity] = true
        if turfData then
            if turfData.gang == player.Gang then
                Execute(GenAction("SELL_IN", PERCENTAGES_OWN), turfData, entity)
            else
                Execute(GenAction("SELL_IN", PERCENTAGES_ADV), turfData, entity)
            end
        else
            Execute(GenAction("SELL_OUT", PERCENTAGES_OUT), turfData, entity)
        end
    end
end)

function GenAction(default, percentages)
    local rand = math.random(1,100)
    local sum = 0
    local action = default
    for act, chance in pairs(percentages) do
        sum = sum + chance
        if rand < sum then
                action = act
            break
        end
    end
    return action
end

function Execute(action, turfData, target)
    TriggerServerCallback("exp_turfwars:EnoughCops", function(ready)
        if ready then
            if action == "SELL_IN" then
                TriggerServerEvent("exp_turfwars:SellIn", turfData.name)
                SellAnim(player.Ped, target)
            elseif action == "SELL_OUT" then
                TriggerServerEvent("exp_turfwars:SellOut")
                SellAnim(player.Ped, target)
            elseif action == "COPS" then
                TriggerServerEvent("exp_turfwars:SendPoliceAlert", GetEntityCoords(player.Ped))
                CallAnim(target)
            elseif action == "DENY" then
                SetPedAnim(target, "gestures@m@standing@casual","gesture_no_way", 1000)
            elseif action == "GANG" then
                TriggerServerEvent("exp_turfwars:GangAlert", turfData.gang, turfData.name)
                CallAnim(target)
            end
        else
            ShowNotification({
                title = _("notif_title"),
                message = _("not_enough_cops"),
                type = "error"
            })
        end
    end)
end

function DisplayTurfOnScreen(show, gang)
    if show then
        SendNUIMessage({
            action = "SHOW",
            color = GANG_COLORS[gang]
        })
    else
        SendNUIMessage({
            action = "HIDE"
        })
    end
end

RegisterNetEvent("exp_turfwars:Captured")
AddEventHandler("exp_turfwars:Captured", function(turf, gang)
    if player.Gang == gang then
        ShowNotification({
            title = _("notif_title"),
            message = _("capture", _(turf)),
            type = "default"
        })
    end

    if turf == turfData.name then
        TriggerServerCallback("exp_turfwars:GetTurfData", function(data)
            turfData = data
        end, turf)
    end
end)

RegisterNetEvent("exp_turfwars:ShowNotification")
AddEventHandler("exp_turfwars:ShowNotification", function(data)
    ShowNotification(data)
end)

RegisterNetEvent("exp_turfwars:ShowPoliceAlert")
AddEventHandler("exp_turfwars:ShowPoliceAlert", function(position)
    local blip_icon = SetBlip(_("notif_title"), position, POL_ALERT_SPRITE, POL_ALERT_COLOR, 1.0)
    SetBlipAsShortRange(blip_icon, false)
    if POL_ALERT_WAVE then
        local blip_wave = SetBlip("", position, 161, POL_ALERT_COLOR, 1.0)
        SetBlipDisplay(blip_wave, 8)
        SetBlipAsShortRange(blip_wave, false)
    end

    Wait(POL_ALERT_TIME)
    
    RemoveBlip(blip_icon)
    RemoveBlip(blip_wave)
    ShowNotification({
        title = _("notif_title"),
        message = _("cop_notif"),
        type = "default"
    })
end)