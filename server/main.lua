ESX = nil

TriggerEvent("esx:getSharedObject", function(library) 
    ESX = library 
end)


RegisterServerEvent("flyyrin:log")
AddEventHandler("flyyrin:log", function(text)
    print(text)
end)