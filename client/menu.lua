
-----menu img
menu_img = "shopui_title_sm_hangar"
-----

_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Detective menu", "Detective options.", 0, 100, menu_img, menu_img)
_menuPool:Add(mainMenu)
_menuPool:MouseEdgeEnabled(false)

function infoMenu(menu)
    contact = NativeUI.CreateItem(translateName('contact'), translateName('contact_info'))
    infomenu:AddItem(contact)

end



function FirstItem(menu) 
    local click = NativeUI.CreateItem("Inspect", "Inspect a dead body.")
    menu:AddItem(click)
    menu.OnItemSelect = function(sender, item, index)
        if item == click then
            startLocateBone(ped)        
        end
    end
end

function SecondItem(menu) 
    local click = NativeUI.CreateItem("Find damage", "Find the damaged location.")
    menu:AddItem(click)
    menu.OnItemSelect = function(sender, item, index)
        if item == click then
            if distance2 > 7.5 or not IsPedDeadOrDying(ped) then
                notify('No players close.')
            else
                startInspect(player)            

            end
        end
    end
end






FirstItem(mainMenu)
SecondItem(mainMenu)

_menuPool:RefreshIndex()



