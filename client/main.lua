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
not_checking = true


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        --[[
        --IF near dead ped
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
            police = true
            if IsControlJustReleased(0, Config.KeybindKeys['G']) then
                local player_ped = GetPlayerPed(PlayerId())
                if isDead(player_ped) then
                    local hash = GetPedCauseOfDeath(player_ped)
                    print(hash)
                    local item = getModelFromHash(hash)
                    local message = translateItem(item)
                    if message == nil then
                        helpMessage(translateItem('unknown'))
                        notify(translateItem('unknown')) --REMOVE
                    else
                        helpMessage(message)
                        notify(message)  --REMOVE
                    end
                else
                    helpMessage(translateItem('not_dead'))
                end
            end
        else
            if IsControlJustReleased(0, Config.KeybindKeys['G']) then
                helpMessage(translateItem('not_police'))
                notify(translateItem('not_police')) --REMOVE
                police = false
            end
        end
        
    end
    ]]
    
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        local ped = GetPlayerPed(closestPlayer)
        if isDead(ped) and not_checking then
            helpMessage(translateItem('inspect'))  
            if IsControlJustReleased(0, Config.KeybindKeys['G']) then
                --startCheck(ped)
                helpMessage('Start Check....')
            end
        end
    end
end


end)

function isDead(ped)
    return IsPedDeadOrDying(ped, true)
end

function getModelFromHash(hash)
    if police then
        return causes[hash]
    else
        return 'Im not a docter.'
    end
end

function translateItem(item)
    local translation = Config.Languages[Config.MenuLanguage][item]
    if translation == nil then
        return "[ERROR] No translation found for: ~g~" .. item
    else
        return translation
    end
end

function helpMessage(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0,0,0,-1)
end

function notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, false)
end





-----------

function startCheck(ped)
    checking = true
  
	  while checking do
		  Citizen.Wait(5)
  
		  local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), GetEntityCoords(ped))
  
		  local x,y,z = table.unpack(GetEntityCoords(ped))
  
		  if distance < 2.0 then
            helpMessage(translateItem('inspectting....'))  
			if IsControlPressed(0, Config.KeybindKeys['G']) then
			    local hash = GetPedCauseOfDeath(ped)
                local item = getModelFromHash(hash)
                helpMessage(translateItem(item))
			end
		end
        if distance > 7.5 or not IsPedDeadOrDying(ped) then
			checking = false
            helpMessage(translateItem('Canceled inspecting'))  
		end
        if IsControlPressed(0, Config.KeybindKeys['X']) then
            checking = false
            helpMessage(translateItem('Canceled inspecting'))  
        end
	end
end