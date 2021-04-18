RegisterServerEvent('flyyrin:requestAcces')
AddEventHandler('flyyrin:requestAcces', function()
    TriggerClientEvent('flyyrin:police_true', source)
end)
