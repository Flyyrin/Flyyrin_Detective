RegisterServerEvent('flyyrin:requestAcces')
AddEventHandler('flyyrin:requestAcces', function()
    local identifiers = {
        steam = "",
        license = "",
    }

    for i = 0, GetNumPlayerIdentifiers(source) - 1 do
        local id = GetPlayerIdentifier(source, i)

        --Convert it to a nice table.
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "license") then
            identifiers.license = id
        end
    end
    local check_steam = Config.Identifiers[identifiers.steam]
    local check_license = Config.Identifiers[identifiers.license]
    if check_steam ~= nil then
        steam_aproved = true
        TriggerClientEvent('flyyrin:police_true', source)
    else
        steam_aproved = false
    end
    if not steam_aproved then
        if check_license ~= nil then
            TriggerClientEvent('flyyrin:police_true', source)
        end
    end
end)


