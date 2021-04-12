ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(library) 
            ESX = library 
        end)

		Citizen.Wait(0)
    end

    if ESX.IsPlayerLoaded() then
        ESX.PlayerData = ESX.GetPlayerData()
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(playerData)
    ESX.PlayerData = playerData   
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    ESX.PlayerData["job"] = job
end)
------------------ESX up here-----------------
causes = {
        [-842959696] = 'fall',
        [-1553120962] = 'Car Accident',
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, Config.KeybindKeys['G']) then
            local player_ped = GetPlayerPed(PlayerId())
            if isDead(player_ped) then
                cause = GetPedCauseOfDeath(player_ped)
                print(cause)
                local reason = causes[cause]
                print(Config.Languages[Config.MenuLanguage][reason])
            else
                print("Not Dead")
            end
        end
    end
end)

function isDead(ped)
    return IsPedDeadOrDying(ped, true)
end