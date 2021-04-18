RegisterServerEvent("flyyrin:RequestAcces")
AddEventHandler("flyyrin:RequestAcces", function()
    local src = source
    if K9Config.OpenMenuIdentifierRestriction then
        local foundIdentifier = false
        for a = 1, #K9Config.LicenseIdentifiers do
            if not foundIdentifier then
                if GetPlayerId('license', src) == K9Config.LicenseIdentifiers[a] then
                    foundIdentifier = true
                end
            end
        end
        for b = 1, #K9Config.SteamIdentifiers do
            if not foundIdentifier then
                if GetPlayerId('steam', src) == K9Config.SteamIdentifiers[b] then
                    foundIdentifier = true
                end
            end
        end
        if foundIdentifier then
            TriggerClientEvent("K9:OpenMenu", src, K9Config.OpenMenuPedRestriction, K9Config.PedsList)
            return
        else
            TriggerClientEvent("K9:IdentifierRestricted", src)
        end
    else
        TriggerClientEvent("K9:OpenMenu", src, K9Config.OpenMenuPedRestriction, K9Config.PedsList)
    end
end)
