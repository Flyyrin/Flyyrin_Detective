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
show_message = true

--------
typed_name = GetPlayerName(PlayerId())
--------

Citizen.CreateThread(function()
    Citizen.Wait(1000)
      while true do
        local sleep = 3000

        if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
            local player, distance = ESX.Game.GetClosestPlayer()

            --if distance ~= -1 and distance < 10.0 then
                if distance ~= -1 and distance <= 5.0 then	
                    if IsPedDeadOrDying(GetPlayerPed(player)) then
                        Locate(GetPlayerPed(player))
                    end
                end

            --else
                sleep = sleep / 100 * distance 
            --end

        end

        Citizen.Wait(sleep)

    end
end)

function Locate(ped)
    checking = true

    while checking do
        Citizen.Wait(5)

        local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), GetEntityCoords(ped))

        local x,y,z = table.unpack(GetEntityCoords(ped))
        
        --DrawMarker(type: number, posX: number, posY: number, posZ: number, dirX: number, dirY: number, dirZ: number, rotX: number, rotY: number, rotZ: number, scaleX: number, scaleY: number, scaleZ: number, red: number, green: number, blue: number, alpha: number, bobUpAndDown: boolean, faceCamera: boolean, p19: number, rotate: boolean, textureDict: string, textureName: string, drawOnEnts: boolean)

        if distance < 2.0 then
            if show_message then
                helpMessage('Press ~INPUT_SELECT_CHARACTER_MICHAEL~ to the open body interaction menu.')
            end
            
            --[[
            if IsControlPressed(0, Config.KeybindKeys['E']) then
                show_message = false
                ClearHelp(true)
                startInspect(ped)
            end
            ]]
        end

        if distance > 7.5 or not IsPedDeadOrDying(ped) then
            checking = false
        end
    end
end

function startInspect(ped)
	local playerPed = GetPlayerPed(-1)
  
	--starts animation
  
	TaskPlayAnim(GetPlayerPed(-1), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
	TaskPlayAnim(GetPlayerPed(-1), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
  
	Citizen.Wait(5000)
  
	--exits animation			
  
	ClearPedTasksImmediately(playerPed)

    --get cause 
    local hash = GetPedCauseOfDeath(ped)		
	local name = getNameFromHash(hash)

    TriggerServerEvent('flyyrin:log', typed_name.. ' : ' ..hash)
    print(hash)


    --translate model
    print(name)

    local message = translateName(name)
    print(message)
    subtext(message, 2500)
    print(message)

    Wait(1000)

    show_message = true

end

function startLocateBone(ped)
    local bone_found, bone_ID = GetPedLastDamageBone(ped)
    print(bone_found)
    print(bone_ID)

    if bone_found then
        local bone_index = GetPedBoneIndex(ped, bone_ID)
        local bone_location = GetPedBoneCoords(ped, bone_ID)
        local x,y,z = table.unpack(bone_location)

        print(bone_index)

        show_bone = true
        
        CreateThread(function()
            while show_bone do
                Wait(0)
        
                local pedCoords = GetEntityCoords(PlayerPedId())
                DrawMarker(22, x, y, z+0.5, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.2, 0.2, 0.2, 255, 128, 0, 50, false, true, 2, nil, nil, true)
            end
        end)

        Wait(3000)
        show_bone = false

    else
        subtext(translateName('no_bone_broke'), 2500)
    end
    show_message = true
end

--ClearHelp(true)

--function down
function getNameFromHash(hash)
    local name = causes[hash]
    if name == nil then
        return 'unknown'
    else
        return name
    end
end

function translateName(name)
    local translation = Config.Languages[Config.MenuLanguage][name]
    if translation == nil then
        return "[ERROR] No translation found for: ~g~" .. name
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

function subtext(text, duration)
    BeginTextCommandPrint("CELL_EMAIL_BCON") 
	AddTextComponentSubstringPlayerName(text) 
	EndTextCommandPrint(duration, true)
end

----funcion up

--TEST
RegisterCommand("helprafael", function(source, args , rawCommand)
    TriggerServerEvent('flyyrin:log', typed_name ..' : ^^^^^ Means: ' .. args[1])
    print('^^^^^ Means: ' .. args[1])
end, false)


RegisterCommand("lonetest_inspect", function(source, args , rawCommand)
    local ped = GetPlayerPed(-1)
    startInspect(ped)
end, false)

RegisterCommand("lonetest_bone", function(source, args , rawCommand)
    local ped = GetPlayerPed(-1)
    startLocateBone(ped)
end, false)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
        if IsControlJustPressed(1, Config.KeybindKeys['F5']) then
            mainMenu:Visible(not mainMenu:Visible())
        end
    end
end)
