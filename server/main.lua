ESX = nil

TriggerEvent("esx:getSharedObject", function(library) 
    ESX = library 
end)

lang = Config.MenuLanguage

print(Config.Languages[lang]['server_start'])

