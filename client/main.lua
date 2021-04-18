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
create_blip = true
police = false
--------
typed_name = GetPlayerName(PlayerId())
--------


Citizen.CreateThread(function()  
    Citizen.Wait(0)
    while true do
        Citizen.Wait(0)
        local plyData = ESX.GetPlayerData()
        if plyData and plyData.job and plyData.job.name == "police" then
            police = true
        else
            police = false
        end
    end
end)


Citizen.CreateThread(function()  
    Citizen.Wait(1000)
    while true do
            local sleep = 3000

            if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                local player, distance = ESX.Game.GetClosestPlayer()

                --if distance ~= -1 and distance < 10.0 then

                    if distance ~= -1 and distance <= 20.0 then	
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
        if police then
            if distance < 10.0 then 
                ESX.Game.Utils.DrawText3D({x = x, y = y, z = z}, translateName('3d_text'), 0.7)
                if distance > 1.0 then
                    if IsControlPressed(0, Config.KeybindKeys['E']) then
                        subtext(translateName('get_closer'), 1500)
                    end
                    if IsControlPressed(0, Config.KeybindKeys['H']) then
                        subtext(translateName('get_closer'), 1500)
                    end
                end

            end


            if distance < 1.0 then
                    local ped1 = GetPlayerPed(-1)
                    --looking_at_player = IsPedFacingPed(ped1, ped, 360)
                    if show_message then
                        helpMessage(translateName('keys_message'))
                    end
                    
                    if IsControlPressed(0, Config.KeybindKeys['E']) then
                        --if looking_at_player then
                            SetEntityHeading(ped1, 40.0) --TEMP
                            message = false
                            ClearHelp(true)
                            startInspect(ped)
                        --else
                            --subtext(translateName(translateName('face_ped')), 1500)
                        --end
                    end
                    if IsControlPressed(0, Config.KeybindKeys['H']) then
                        --if looking_at_player then
                            SetEntityHeading(ped1, 40.0) --TEMP
                            message = false
                            ClearHelp(true)
                            startLocateBone(ped)
                        --else
                            subtext(translateName(translateName('face_ped')), 1500)
                        --end

                    end
            end

            if distance > 7.5 or not IsPedDeadOrDying(ped) then
                checking = false
            end
        end
    end
end

function startInspect(ped)
	local playerPed = GetPlayerPed(-1)
  
	--starts animation
    local duration = math.random(Config.inspectDurationMin, Config.inspectDurationMax)
	loopAnimation(duration)
  
	--exits animation			
  
    --get cause 
    local hash = GetPedCauseOfDeath(ped)		
	local name = getNameFromHash(hash)

    TriggerServerEvent('flyyrin:log', typed_name.. ' : ' ..hash)
    print('Inspected body hash: ' .. hash)


    --translate model

    local message = translateName(name)
    subtext(message, 2500)

    Wait(1000)

    show_message = true

end

function startLocateBone(ped)
    local duration = math.random(Config.searchDurationMin, Config.searchDurationMax)
    loopAnimation(duration)

    local bone_found, bone_ID = GetPedLastDamageBone(ped)

    if bone_found then
        local bone_index = GetPedBoneIndex(ped, bone_ID)
        local bone_location = GetPedBoneCoords(ped, bone_ID)
        local x,y,z = table.unpack(bone_location)




        show_bone = true


        
        local playerPed = GetPlayerPed(-1)
  
        --starts animation
      



        CreateThread(function()
            while show_bone do
                Wait(0)
        
                local pedCoords = GetEntityCoords(PlayerPedId())
                DrawMarker(22, x, y, z+0.3, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.2, 0.2, 0.2, 255, 128, 0, 100, true, true, 2, nil, nil, true)
            end
        end)

        Wait(Config.showBoneDuration)
        show_bone = false

    else
        subtext(translateName('no_bone_broke'), 2500)
    end
    show_message = true
end

function loopAnimation(miliseconds)
    loop_animation = true
    local playerPed = GetPlayerPed(-1)

    ClearPedTasksImmediately(playerPed)

    xDisable = true
    loop_animation = true


    CreateThread(function()
        Wait(0)
        while loop_animation do
            TaskPlayAnim(GetPlayerPed(-1), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
            TaskPlayAnim(GetPlayerPed(-1), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
            Citizen.Wait(5000)
        end
    end)
    --EXIT KNEEL!!!
    ----
    ---
    Citizen.Wait(miliseconds)
    loop_animation = false
    xDisable = false
    ClearPedTasksImmediately(playerPed)
end

CreateThread(function()
while true do
    Wait(0)

    while xDisable do
        Wait(0)
        DisableControlAction(0, 73, true) 
        DisableControlAction(0, 120, true) 
        DisableControlAction(0, 154, true) 
        DisableControlAction(0, 186, true)
        DisableControlAction(0, 252, true) 
        DisableControlAction(0, 323, true) 
        DisableControlAction(0, 337, true) 
        DisableControlAction(0, 345, true) 
        DisableControlAction(0, 354, true) 
        DisableControlAction(0, 357, true) 
    end
end
end)

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
        return "[ERROR] No ".. Config.MenuLanguage .. " translation found for: ~g~" .. name
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

function showDeadBlip(x,y,z)
    CreateThread(function()
        while show_blip do
            Wait(0)
            local blip = AddBlipForCoord(x, y, z)

            SetBlipSprite (blip, 84)--sprite
            SetBlipDisplay(blip, 6)--v.Blip.Display
            SetBlipScale  (blip, 0.7)--scale
            SetBlipColour (blip, 1)--color
            SetBlipAsShortRange(blip, true)
                
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Dead Body")
            EndTextCommandSetBlipName(blip)
            Wait(5000)
            RemoveBlip(blip)
        end
    end)
end

function playerHeading(pedloc)
    local player = GetEntityCoords(GetPlayerPed(-1))
    --local pedloc = GetEntityCoords(ped, true)

    local dx = pedloc.x - player.x
    local dy = pedloc.y - player.y

    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading(GetPlayerPed(-1), heading)
end

----funcion up

--TEST
---------
RegisterCommand("become", function(source, args , rawCommand)
    if args[1] == 'police' then
        notify('Now police')
        police = true
    else
        notify('No longer police')
        police = false
    end
end, false)


RegisterCommand("lonetest_inspect", function(source, args , rawCommand)
    local ped = GetPlayerPed(-1)
    startInspect(ped)
end, false)

RegisterCommand("lonetest_bone", function(source, args , rawCommand)
    local ped = GetPlayerPed(-1)
    startLocateBone(ped)
end, false)

RegisterCommand("lonetest_angle", function(source, args , rawCommand)
    playerHeading(vector3(tonumber(args[1]), tonumber(args[2]), 0.0))
end, false)

--------------

