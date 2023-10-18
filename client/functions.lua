function SetPedAnim(ped, dict, anim, time)
    if (DoesEntityExist(ped) and not IsEntityDead(ped)) then
        while not HasAnimDictLoaded(dict) do
            RequestAnimDict(dict)
            Wait(10)
        end
        TaskPlayAnim(ped, dict, anim, 8.0, -8.0, time, 49, 1, false, false, false)
    end
end

function IsPlayerInPolygon(pPolygon, pEntity)
	local point = GetEntityCoords(pEntity or PlayerPedId())
    local oddNodes = false
    local j = #pPolygon
    for i = 1, #pPolygon do
        if (pPolygon[i].y < point.y and pPolygon[j].y >= point.y or pPolygon[j].y < point.y and pPolygon[i].y >= point.y) then
            if (pPolygon[i].x + ( point.y - pPolygon[i].y ) / (pPolygon[j].y - pPolygon[i].y) * (pPolygon[j].x - pPolygon[i].x) < point.x) then
                oddNodes = not oddNodes;
            end
        end
        j = i;
    end
    return oddNodes 
end