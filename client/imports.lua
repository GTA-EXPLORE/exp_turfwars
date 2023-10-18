local ServerCallbacks, CurrentRequestId = {}, 0

function TriggerServerCallback(name, cb, ...)
	ServerCallbacks[CurrentRequestId] = cb

	TriggerServerEvent('exp_turfwars:triggerServerCallback', name, CurrentRequestId, ...)

	if CurrentRequestId < 65535 then
		CurrentRequestId = CurrentRequestId + 1
	else
		CurrentRequestId = 0
	end
end

RegisterNetEvent('exp_turfwars:serverCallback')
AddEventHandler('exp_turfwars:serverCallback', function(requestId, ...)
	ServerCallbacks[requestId](...)
	ServerCallbacks[requestId] = nil
end)