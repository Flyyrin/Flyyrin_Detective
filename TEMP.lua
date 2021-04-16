using CitizenFX.Core;
using CitizenFX.Core.Native;
using MenuAPI;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Threading.Tasks;
using vMenuShared;

namespace vMenuClient
{
    public class WeaponOptions
    {
        private Menu menu;

        public static Dictionary<string, uint> AddonWeapons;

        private Dictionary<Menu, ValidWeapon> weaponInfo;

        private Dictionary<MenuItem, string> weaponComponents;

        public bool AutoEquipChute { get; private set; } = UserDefaults.AutoEquipChute;

        public bool NoReload { get; private set; } = UserDefaults.WeaponsNoReload;

        public bool UnlimitedAmmo { get; private set; } = UserDefaults.WeaponsUnlimitedAmmo;

        public bool UnlimitedParachutes { get; private set; } = UserDefaults.WeaponsUnlimitedParachutes;

        static WeaponOptions()
        {
            WeaponOptions.AddonWeapons = new Dictionary<string, uint>();
        }

        public WeaponOptions()
        {
        }

        private void CreateMenu()
        {
            this.weaponInfo = new Dictionary<Menu, ValidWeapon>();
            this.weaponComponents = new Dictionary<MenuItem, string>();
            this.menu = new Menu(Game.get_Player().get_Name(), "Weapon Options");
            MenuItem menuItem = new MenuItem("Get All Weapons", "Get all weapons.");
            MenuItem menuItem1 = new MenuItem("Remove All Weapons", "Removes all weapons in your inventory.");
            MenuCheckboxItem menuCheckboxItem = new MenuCheckboxItem("Unlimited Ammo", "Unlimited ammonition supply.", this.UnlimitedAmmo);
            MenuCheckboxItem menuCheckboxItem1 = new MenuCheckboxItem("No Reload", "Never reload.", this.NoReload);
            MenuItem menuItem2 = new MenuItem("Set All Ammo Count", "Set the amount of ammo in all your weapons.");
            MenuItem menuItem3 = new MenuItem("Refill All Ammo", "Give all your weapons max ammo.");
            MenuItem menuItem4 = new MenuItem("Spawn Weapon By Name", "Enter a weapon mode name to spawn.");
            if (PermissionsManager.IsAllowed(PermissionsManager.Permission.WPGetAll, false))
            {
                this.menu.AddMenuItem(menuItem);
            }
            if (PermissionsManager.IsAllowed(PermissionsManager.Permission.WPRemoveAll, false))
            {
                this.menu.AddMenuItem(menuItem1);
            }
            if (PermissionsManager.IsAllowed(PermissionsManager.Permission.WPUnlimitedAmmo, false))
            {
                this.menu.AddMenuItem(menuCheckboxItem);
            }
            if (PermissionsManager.IsAllowed(PermissionsManager.Permission.WPNoReload, false))
            {
                this.menu.AddMenuItem(menuCheckboxItem1);
            }
            if (PermissionsManager.IsAllowed(PermissionsManager.Permission.WPSetAllAmmo, false))
            {
                this.menu.AddMenuItem(menuItem2);
                this.menu.AddMenuItem(menuItem3);
            }
            if (PermissionsManager.IsAllowed(PermissionsManager.Permission.WPSpawnByName, false))
            {
                this.menu.AddMenuItem(menuItem4);
            }
            MenuItem menuItem5 = new MenuItem("Addon Weapons", "Equip / remove addon weapons available on this server.");
            Menu menu = new Menu("Addon Weapons", "Equip/Remove Addon Weapons");
            this.menu.AddMenuItem(menuItem5);
            if (!PermissionsManager.IsAllowed(PermissionsManager.Permission.WPSpawn, false) || WeaponOptions.AddonWeapons == null || WeaponOptions.AddonWeapons.Count <= 0)
            {
                menuItem5.LeftIcon = MenuItem.Icon.LOCK;
                menuItem5.Enabled = false;
                menuItem5.Description = "This option is not available on this server because you don't have permission to use it, or it is not setup correctly.";
            }
            else
            {
                MenuController.BindMenuItem(this.menu, menu, menuItem5);
                foreach (KeyValuePair<string, uint> addonWeapon in WeaponOptions.AddonWeapons)
                {
                    string str = addonWeapon.Key.ToString();
                    uint value = addonWeapon.Value;
                    MenuItem menuItem6 = new MenuItem(str, string.Concat("Click to add/remove this weapon (", str, ") to/from your inventory."));
                    menu.AddMenuItem(menuItem6);
                    if (API.IsWeaponValid(value))
                    {
                        continue;
                    }
                    menuItem6.Enabled = false;
                    menuItem6.LeftIcon = MenuItem.Icon.LOCK;
                    menuItem6.Description = "This model is not available. Please ask the server owner to verify it's being streamed correctly.";
                }
                menu.OnItemSelect += new Menu.ItemSelectEvent((Menu sender, MenuItem item, int index) => {
                    KeyValuePair<string, uint> keyValuePair = WeaponOptions.AddonWeapons.ElementAt<KeyValuePair<string, uint>>(index);
                    if (API.HasPedGotWeapon(Game.get_PlayerPed().get_Handle(), keyValuePair.Value, false))
                    {
                        API.RemoveWeaponFromPed(Game.get_PlayerPed().get_Handle(), keyValuePair.Value);
                        return;
                    }
                    int num = 200;
                    API.GetMaxAmmo(Game.get_PlayerPed().get_Handle(), keyValuePair.Value, ref num);
                    API.GiveWeaponToPed(Game.get_PlayerPed().get_Handle(), keyValuePair.Value, num, false, true);
                });
                menuItem5.Label = "→→→";
            }
            menu.RefreshIndex();
            if (PermissionsManager.IsAllowed(PermissionsManager.Permission.WPParachute, false))
            {
                Menu menu1 = new Menu("Parachute Options", "Parachute Options");
                MenuItem menuItem7 = new MenuItem("Parachute Options", "All parachute related options can be changed here.")
                {
                    Label = "→→→"
                };
                MenuController.AddSubmenu(this.menu, menu1);
                this.menu.AddMenuItem(menuItem7);
                MenuController.BindMenuItem(this.menu, menu1, menuItem7);
                List<string> strs = new List<string>()
                {
                    API.GetLabelText("PM_TINT0"),
                    API.GetLabelText("PM_TINT1"),
                    API.GetLabelText("PM_TINT2"),
                    API.GetLabelText("PM_TINT3"),
                    API.GetLabelText("PM_TINT4"),
                    API.GetLabelText("PM_TINT5"),
                    API.GetLabelText("PM_TINT6"),
                    API.GetLabelText("PM_TINT7"),
                    API.GetLabelText("PS_CAN_0"),
                    API.GetLabelText("PS_CAN_1"),
                    API.GetLabelText("PS_CAN_2"),
                    API.GetLabelText("PS_CAN_3"),
                    API.GetLabelText("PS_CAN_4"),
                    API.GetLabelText("PS_CAN_5")
                };
                List<string> strs1 = new List<string>()
                {
                    API.GetLabelText("PD_TINT0"),
                    API.GetLabelText("PD_TINT1"),
                    API.GetLabelText("PD_TINT2"),
                    API.GetLabelText("PD_TINT3"),
                    API.GetLabelText("PD_TINT4"),
                    API.GetLabelText("PD_TINT5"),
                    API.GetLabelText("PD_TINT6"),
                    API.GetLabelText("PD_TINT7"),
                    string.Concat(API.GetLabelText("PSD_CAN_0"), " ~r~For some reason this one doesn't seem to work in FiveM."),
                    string.Concat(API.GetLabelText("PSD_CAN_1"), " ~r~For some reason this one doesn't seem to work in FiveM."),
                    string.Concat(API.GetLabelText("PSD_CAN_2"), " ~r~For some reason this one doesn't seem to work in FiveM."),
                    string.Concat(API.GetLabelText("PSD_CAN_3"), " ~r~For some reason this one doesn't seem to work in FiveM."),
                    string.Concat(API.GetLabelText("PSD_CAN_4"), " ~r~For some reason this one doesn't seem to work in FiveM."),
                    string.Concat(API.GetLabelText("PSD_CAN_5"), " ~r~For some reason this one doesn't seem to work in FiveM.")
                };
                MenuItem menuItem8 = new MenuItem("Toggle Primary Parachute", "Equip or remove the primary parachute");
                MenuItem menuItem9 = new MenuItem("Enable Reserve Parachute", "Enables the reserve parachute. Only works if you enabled the primary parachute first. Reserve parachute can not be removed from the player once it's activated.");
                MenuListItem menuListItem = new MenuListItem("Primary Chute Style", strs, 0, string.Concat("Primary chute: ", strs1[0]));
                MenuListItem menuListItem1 = new MenuListItem("Reserve Chute Style", strs, 0, string.Concat("Reserve chute: ", strs1[0]));
                MenuCheckboxItem menuCheckboxItem2 = new MenuCheckboxItem("Unlimited Parachutes", "Enable unlimited parachutes and reserve parachutes.", this.UnlimitedParachutes);
                MenuCheckboxItem menuCheckboxItem3 = new MenuCheckboxItem("Auto Equip Parachutes", "Automatically equip a parachute and reserve parachute when entering planes/helicopters.", this.AutoEquipChute);
                List<string> strs2 = new List<string>()
                {
                    API.GetLabelText("PM_TINT8"),
                    API.GetLabelText("PM_TINT9"),
                    API.GetLabelText("PM_TINT10"),
                    API.GetLabelText("PM_TINT11"),
                    API.GetLabelText("PM_TINT12"),
                    API.GetLabelText("PM_TINT13")
                };
                List<int[]> numArrays = new List<int[]>()
                {
                    new int[] { 255, 255, 255 },
                    new int[] { 255, 0, 0 },
                    new int[] { 255, 165, 0 },
                    new int[] { 255, 255, 0 },
                    new int[] { 0, 0, 255 },
                    new int[] { 20, 20, 20 }
                };
                List<int[]> numArrays1 = numArrays;
                MenuListItem menuListItem2 = new MenuListItem("Smoke Trail Color", strs2, 0, "Choose a smoke trail color, then press select to change it. Changing colors takes 4 seconds, you can not use your smoke while the color is being changed.");
                menu1.AddMenuItem(menuItem8);
                menu1.AddMenuItem(menuItem9);
                menu1.AddMenuItem(menuCheckboxItem3);
                menu1.AddMenuItem(menuCheckboxItem2);
                menu1.AddMenuItem(menuListItem2);
                menu1.AddMenuItem(menuListItem);
                menu1.AddMenuItem(menuListItem1);
                menu1.OnItemSelect += new Menu.ItemSelectEvent((Menu sender, MenuItem item, int index) => {
                    if (item != menuItem8)
                    {
                        if (item == menuItem9)
                        {
                            API.SetPlayerHasReserveParachute(Game.get_Player().get_Handle());
                            Subtitle.Custom("Reserve parachute has been added.", 2500, true);
                        }
                        return;
                    }
                    if (API.HasPedGotWeapon(Game.get_PlayerPed().get_Handle(), (uint)API.GetHashKey("gadget_parachute"), false))
                    {
                        Subtitle.Custom("Primary parachute removed.", 2500, true);
                        API.RemoveWeaponFromPed(Game.get_PlayerPed().get_Handle(), (uint)API.GetHashKey("gadget_parachute"));
                        return;
                    }
                    Subtitle.Custom("Primary parachute added.", 2500, true);
                    API.GiveWeaponToPed(Game.get_PlayerPed().get_Handle(), (uint)API.GetHashKey("gadget_parachute"), 0, false, false);
                });
                menu1.OnCheckboxChange += new Menu.CheckboxItemChangeEvent((Menu sender, MenuCheckboxItem item, int index, bool _checked) => {
                    if (item == menuCheckboxItem2)
                    {
                        this.UnlimitedParachutes = _checked;
                        return;
                    }
                    if (item == menuCheckboxItem3)
                    {
                        this.AutoEquipChute = _checked;
                    }
                });
                bool flag = false;
                menu1.OnListItemSelect += new Menu.ListItemSelectedEvent((Menu sender, MenuListItem item, int index, int itemIndex) => this.<CreateMenu>g__IndexChangedEventHandler|22(sender, item, -1, index, itemIndex));
                menu1.OnListIndexChange += new Menu.ListItemIndexChangedEvent(async (Menu sender, MenuListItem item, int oldIndex, int newIndex, int itemIndex) => {
                    if (item == menuListItem2 && oldIndex == -1)
                    {
                        if (!flag)
                        {
                            flag = true;
                            API.SetPlayerCanLeaveParachuteSmokeTrail(Game.get_Player().get_Handle(), false);
                            await CommonFunctions.Delay(4000);
                            int[] numArray = numArrays1[newIndex];
                            API.SetPlayerParachuteSmokeTrailColor(Game.get_Player().get_Handle(), numArray[0], numArray[1], numArray[2]);
                            API.SetPlayerCanLeaveParachuteSmokeTrail(Game.get_Player().get_Handle(), newIndex != 0);
                            flag = false;
                        }
                    }
                    else if (item == menuListItem)
                    {
                        item.Description = string.Concat("Primary chute: ", strs1[newIndex]);
                        API.SetPlayerParachuteTintIndex(Game.get_Player().get_Handle(), newIndex);
                    }
                    else if (item == menuListItem1)
                    {
                        item.Description = string.Concat("Reserve chute: ", strs1[newIndex]);
                        API.SetPlayerReserveParachuteTintIndex(Game.get_Player().get_Handle(), newIndex);
                    }
                });
            }
            MenuItem spacerMenuItem = CommonFunctions.GetSpacerMenuItem("↓ Weapon Categories ↓", null);
            this.menu.AddMenuItem(spacerMenuItem);
            Menu menu2 = new Menu("Weapons", "Handguns");
            MenuItem menuItem10 = new MenuItem("Handguns");
            Menu menu3 = new Menu("Weapons", "Assault Rifles");
            MenuItem menuItem11 = new MenuItem("Assault Rifles");
            Menu menu4 = new Menu("Weapons", "Shotguns");
            MenuItem menuItem12 = new MenuItem("Shotguns");
            Menu menu5 = new Menu("Weapons", "Sub-/Light Machine Guns");
            MenuItem menuItem13 = new MenuItem("Sub-/Light Machine Guns");
            Menu menu6 = new Menu("Weapons", "Throwables");
            MenuItem menuItem14 = new MenuItem("Throwables");
            Menu menu7 = new Menu("Weapons", "Melee");
            MenuItem menuItem15 = new MenuItem("Melee");
            Menu menu8 = new Menu("Weapons", "Heavy Weapons");
            MenuItem menuItem16 = new MenuItem("Heavy Weapons");
            Menu menu9 = new Menu("Weapons", "Sniper Rifles");
            MenuItem menuItem17 = new MenuItem("Sniper Rifles");
            MenuController.AddSubmenu(this.menu, menu2);
            MenuController.AddSubmenu(this.menu, menu3);
            MenuController.AddSubmenu(this.menu, menu4);
            MenuController.AddSubmenu(this.menu, menu5);
            MenuController.AddSubmenu(this.menu, menu6);
            MenuController.AddSubmenu(this.menu, menu7);
            MenuController.AddSubmenu(this.menu, menu8);
            MenuController.AddSubmenu(this.menu, menu9);
            menuItem10.Label = "→→→";
            this.menu.AddMenuItem(menuItem10);
            MenuController.BindMenuItem(this.menu, menu2, menuItem10);
            menuItem11.Label = "→→→";
            this.menu.AddMenuItem(menuItem11);
            MenuController.BindMenuItem(this.menu, menu3, menuItem11);
            menuItem12.Label = "→→→";
            this.menu.AddMenuItem(menuItem12);
            MenuController.BindMenuItem(this.menu, menu4, menuItem12);
            menuItem13.Label = "→→→";
            this.menu.AddMenuItem(menuItem13);
            MenuController.BindMenuItem(this.menu, menu5, menuItem13);
            menuItem14.Label = "→→→";
            this.menu.AddMenuItem(menuItem14);
            MenuController.BindMenuItem(this.menu, menu6, menuItem14);
            menuItem15.Label = "→→→";
            this.menu.AddMenuItem(menuItem15);
            MenuController.BindMenuItem(this.menu, menu7, menuItem15);
            menuItem16.Label = "→→→";
            this.menu.AddMenuItem(menuItem16);
            MenuController.BindMenuItem(this.menu, menu8, menuItem16);
            menuItem17.Label = "→→→";
            this.menu.AddMenuItem(menuItem17);
            MenuController.BindMenuItem(this.menu, menu9, menuItem17);
            foreach (ValidWeapon validWeapon1 in ValidWeapons.WeaponList)
            {
                uint weapontypeGroup = (uint)API.GetWeapontypeGroup(validWeapon1.Hash);
                if (string.IsNullOrEmpty(validWeapon1.Name) || !PermissionsManager.IsAllowed(validWeapon1.Perm, false))
                {
                    continue;
                }
                Menu menu10 = new Menu("Weapon Options", validWeapon1.Name)
                {
                    ShowWeaponStatsPanel = true
                };
                Game.WeaponHudStats weaponHudStat = new Game.WeaponHudStats();
                Game.GetWeaponHudStats(validWeapon1.Hash, ref weaponHudStat);
                menu10.SetWeaponStats((float)weaponHudStat.hudDamage / 100f, (float)weaponHudStat.hudSpeed / 100f, (float)weaponHudStat.hudAccuracy / 100f, (float)weaponHudStat.hudRange / 100f);
                MenuItem menuItem18 = new MenuItem(validWeapon1.Name, string.Concat("Open the options for ~y~", validWeapon1.Name, "~s~."))
                {
                    Label = "→→→",
                    LeftIcon = MenuItem.Icon.GUN,
                    ItemData = weaponHudStat
                };
                this.weaponInfo.Add(menu10, validWeapon1);
                MenuItem menuItem19 = new MenuItem("Equip/Remove Weapon", "Add or remove this weapon to/form your inventory.")
                {
                    LeftIcon = MenuItem.Icon.GUN
                };
                menu10.AddMenuItem(menuItem19);
                if (!PermissionsManager.IsAllowed(PermissionsManager.Permission.WPSpawn, false))
                {
                    menuItem19.Enabled = false;
                    menuItem19.Description = "You do not have permission to use this option.";
                    menuItem19.LeftIcon = MenuItem.Icon.LOCK;
                }
                MenuItem menuItem20 = new MenuItem("Re-fill Ammo", "Get max ammo for this weapon.")
                {
                    LeftIcon = MenuItem.Icon.AMMO
                };
                menu10.AddMenuItem(menuItem20);
                List<string> strs3 = new List<string>();
                if (!validWeapon1.Name.Contains(" Mk II"))
                {
                    foreach (KeyValuePair<string, int> weaponTint in ValidWeapons.WeaponTints)
                    {
                        strs3.Add(weaponTint.Key);
                    }
                }
                else
                {
                    foreach (KeyValuePair<string, int> weaponTintsMkII in ValidWeapons.WeaponTintsMkII)
                    {
                        strs3.Add(weaponTintsMkII.Key);
                    }
                }
                MenuListItem menuListItem3 = new MenuListItem("Tints", strs3, 0, "Select a tint for your weapon.");
                menu10.AddMenuItem(menuListItem3);
                menu10.OnListIndexChange += new Menu.ListItemIndexChangedEvent((Menu sender, MenuListItem item, int oldIndex, int newIndex, int itemIndex) => {
                    if (item == menuListItem3)
                    {
                        if (API.HasPedGotWeapon(Game.get_PlayerPed().get_Handle(), this.weaponInfo[sender].Hash, false))
                        {
                            API.SetPedWeaponTintIndex(Game.get_PlayerPed().get_Handle(), this.weaponInfo[sender].Hash, newIndex);
                            return;
                        }
                        Notify.Error("You need to get the weapon first!", true, true);
                    }
                });
                menu10.OnItemSelect += new Menu.ItemSelectEvent((Menu sender, MenuItem item, int index) => {
                    uint hash = this.weaponInfo[sender].Hash;
                    API.SetCurrentPedWeapon(Game.get_PlayerPed().get_Handle(), hash, true);
                    if (item != menuItem19)
                    {
                        if (item == menuItem20)
                        {
                            if (API.HasPedGotWeapon(Game.get_PlayerPed().get_Handle(), hash, false))
                            {
                                int num = 900;
                                API.GetMaxAmmo(Game.get_PlayerPed().get_Handle(), hash, ref num);
                                API.SetPedAmmo(Game.get_PlayerPed().get_Handle(), hash, num);
                                return;
                            }
                            Notify.Error("You need to get the weapon first before re-filling ammo!", true, true);
                        }
                        return;
                    }
                    if (API.HasPedGotWeapon(Game.get_PlayerPed().get_Handle(), hash, false))
                    {
                        API.RemoveWeaponFromPed(Game.get_PlayerPed().get_Handle(), hash);
                        Subtitle.Custom("Weapon removed.", 2500, true);
                        return;
                    }
                    int num1 = 255;
                    API.GetMaxAmmo(Game.get_PlayerPed().get_Handle(), hash, ref num1);
                    API.GiveWeaponToPed(Game.get_PlayerPed().get_Handle(), hash, num1, false, true);
                    Subtitle.Custom("Weapon added.", 2500, true);
                });
                if (validWeapon1.Components != null && validWeapon1.Components.Count > 0)
                {
                    foreach (KeyValuePair<string, uint> component in validWeapon1.Components)
                    {
                        MenuItem menuItem21 = new MenuItem(component.Key, "Click to equip or remove this component.");
                        this.weaponComponents.Add(menuItem21, component.Key);
                        menu10.AddMenuItem(menuItem21);
                        menu10.OnItemSelect += new Menu.ItemSelectEvent((Menu sender, MenuItem item, int index) => {
                            if (item == menuItem21)
                            {
                                ValidWeapon validWeapon = this.weaponInfo[sender];
                                uint num = validWeapon.Components[this.weaponComponents[item]];
                                if (API.HasPedGotWeapon(Game.get_PlayerPed().get_Handle(), validWeapon.Hash, false))
                                {
                                    API.SetCurrentPedWeapon(Game.get_PlayerPed().get_Handle(), validWeapon.Hash, true);
                                    if (API.HasPedGotWeaponComponent(Game.get_PlayerPed().get_Handle(), validWeapon.Hash, num))
                                    {
                                        API.RemoveWeaponComponentFromPed(Game.get_PlayerPed().get_Handle(), validWeapon.Hash, num);
                                        Subtitle.Custom("Component removed.", 2500, true);
                                        return;
                                    }
                                    int ammoInPedWeapon = API.GetAmmoInPedWeapon(Game.get_PlayerPed().get_Handle(), validWeapon.Hash);
                                    int maxAmmoInClip = API.GetMaxAmmoInClip(Game.get_PlayerPed().get_Handle(), validWeapon.Hash, false);
                                    API.GetAmmoInClip(Game.get_PlayerPed().get_Handle(), validWeapon.Hash, ref maxAmmoInClip);
                                    API.GiveWeaponComponentToPed(Game.get_PlayerPed().get_Handle(), validWeapon.Hash, num);
                                    API.SetAmmoInClip(Game.get_PlayerPed().get_Handle(), validWeapon.Hash, maxAmmoInClip);
                                    API.SetPedAmmo(Game.get_PlayerPed().get_Handle(), validWeapon.Hash, ammoInPedWeapon);
                                    Subtitle.Custom("Component equiped.", 2500, true);
                                    return;
                                }
                                Notify.Error("You need to get the weapon first before you can modify it.", true, true);
                            }
                        });
                    }
                }
                menu10.RefreshIndex();
                if (weapontypeGroup == 970310034)
                {
                    MenuController.AddSubmenu(menu3, menu10);
                    MenuController.BindMenuItem(menu3, menu10, menuItem18);
                    menu3.AddMenuItem(menuItem18);
                }
                else if (weapontypeGroup == 416676503 || weapontypeGroup == 690389602)
                {
                    MenuController.AddSubmenu(menu2, menu10);
                    MenuController.BindMenuItem(menu2, menu10, menuItem18);
                    menu2.AddMenuItem(menuItem18);
                }
                else if (weapontypeGroup == 860033945)
                {
                    MenuController.AddSubmenu(menu4, menu10);
                    MenuController.BindMenuItem(menu4, menu10, menuItem18);
                    menu4.AddMenuItem(menuItem18);
                }
                else if (weapontypeGroup == -957766203 || weapontypeGroup == 1159398588)
                {
                    MenuController.AddSubmenu(menu5, menu10);
                    MenuController.BindMenuItem(menu5, menu10, menuItem18);
                    menu5.AddMenuItem(menuItem18);
                }
                else if (weapontypeGroup == 1548507267 || weapontypeGroup == -37788308 || weapontypeGroup == 1595662460)
                {
                    MenuController.AddSubmenu(menu6, menu10);
                    MenuController.BindMenuItem(menu6, menu10, menuItem18);
                    menu6.AddMenuItem(menuItem18);
                }
                else if (weapontypeGroup == -728555052 || weapontypeGroup == -1609580060)
                {
                    MenuController.AddSubmenu(menu7, menu10);
                    MenuController.BindMenuItem(menu7, menu10, menuItem18);
                    menu7.AddMenuItem(menuItem18);
                }
                else if (weapontypeGroup != -1569042529)
                {
                    if (weapontypeGroup != -1212426201)
                    {
                        continue;
                    }
                    MenuController.AddSubmenu(menu9, menu10);
                    MenuController.BindMenuItem(menu9, menu10, menuItem18);
                    menu9.AddMenuItem(menuItem18);
                }
                else
                {
                    MenuController.AddSubmenu(menu8, menu10);
                    MenuController.BindMenuItem(menu8, menu10, menuItem18);
                    menu8.AddMenuItem(menuItem18);
                }
            }
            if (menu2.Size == 0)
            {
                menuItem10.LeftIcon = MenuItem.Icon.LOCK;
                menuItem10.Description = "The server owner removed the permissions for all weapons in this category.";
                menuItem10.Enabled = false;
            }
            if (menu3.Size == 0)
            {
                menuItem11.LeftIcon = MenuItem.Icon.LOCK;
                menuItem11.Description = "The server owner removed the permissions for all weapons in this category.";
                menuItem11.Enabled = false;
            }
            if (menu4.Size == 0)
            {
                menuItem12.LeftIcon = MenuItem.Icon.LOCK;
                menuItem12.Description = "The server owner removed the permissions for all weapons in this category.";
                menuItem12.Enabled = false;
            }
            if (menu5.Size == 0)
            {
                menuItem13.LeftIcon = MenuItem.Icon.LOCK;
                menuItem13.Description = "The server owner removed the permissions for all weapons in this category.";
                menuItem13.Enabled = false;
            }
            if (menu6.Size == 0)
            {
                menuItem14.LeftIcon = MenuItem.Icon.LOCK;
                menuItem14.Description = "The server owner removed the permissions for all weapons in this category.";
                menuItem14.Enabled = false;
            }
            if (menu7.Size == 0)
            {
                menuItem15.LeftIcon = MenuItem.Icon.LOCK;
                menuItem15.Description = "The server owner removed the permissions for all weapons in this category.";
                menuItem15.Enabled = false;
            }
            if (menu8.Size == 0)
            {
                menuItem16.LeftIcon = MenuItem.Icon.LOCK;
                menuItem16.Description = "The server owner removed the permissions for all weapons in this category.";
                menuItem16.Enabled = false;
            }
            if (menu9.Size == 0)
            {
                menuItem17.LeftIcon = MenuItem.Icon.LOCK;
                menuItem17.Description = "The server owner removed the permissions for all weapons in this category.";
                menuItem17.Enabled = false;
            }
            this.menu.OnItemSelect += new Menu.ItemSelectEvent((Menu sender, MenuItem item, int index) => {
                Ped ped = new Ped(Game.get_PlayerPed().get_Handle());
                if (item == menuItem)
                {
                    foreach (ValidWeapon weaponList in ValidWeapons.WeaponList)
                    {
                        if (!PermissionsManager.IsAllowed(weaponList.Perm, false))
                        {
                            continue;
                        }
                        API.GiveWeaponToPed(Game.get_PlayerPed().get_Handle(), weaponList.Hash, weaponList.GetMaxAmmo, false, true);
                        int maxAmmoInClip = API.GetMaxAmmoInClip(Game.get_PlayerPed().get_Handle(), weaponList.Hash, false);
                        API.SetAmmoInClip(Game.get_PlayerPed().get_Handle(), weaponList.Hash, maxAmmoInClip);
                        int num = 0;
                        API.GetMaxAmmo(Game.get_PlayerPed().get_Handle(), weaponList.Hash, ref num);
                        API.SetPedAmmo(Game.get_PlayerPed().get_Handle(), weaponList.Hash, num);
                    }
                    API.SetCurrentPedWeapon(Game.get_PlayerPed().get_Handle(), (uint)API.GetHashKey("weapon_unarmed"), true);
                    return;
                }
                if (item == menuItem1)
                {
                    ped.get_Weapons().RemoveAll();
                    return;
                }
                if (item == menuItem2)
                {
                    CommonFunctions.SetAllWeaponsAmmo();
                    return;
                }
                if (item == menuItem3)
                {
                    foreach (ValidWeapon validWeapon in ValidWeapons.WeaponList)
                    {
                        if (!API.HasPedGotWeapon(Game.get_PlayerPed().get_Handle(), validWeapon.Hash, false))
                        {
                            continue;
                        }
                        int maxAmmoInClip1 = API.GetMaxAmmoInClip(Game.get_PlayerPed().get_Handle(), validWeapon.Hash, false);
                        API.SetAmmoInClip(Game.get_PlayerPed().get_Handle(), validWeapon.Hash, maxAmmoInClip1);
                        int num1 = 0;
                        API.GetMaxAmmo(Game.get_PlayerPed().get_Handle(), validWeapon.Hash, ref num1);
                        API.SetPedAmmo(Game.get_PlayerPed().get_Handle(), validWeapon.Hash, num1);
                    }
                }
                else if (item == menuItem4)
                {
                    CommonFunctions.SpawnCustomWeapon();
                }
            });
            this.menu.OnCheckboxChange += new Menu.CheckboxItemChangeEvent((Menu sender, MenuCheckboxItem item, int index, bool _checked) => {
                if (item == menuCheckboxItem1)
                {
                    this.NoReload = _checked;
                    Subtitle.Custom(string.Concat("No reload is now ", (_checked ? "enabled" : "disabled"), "."), 2500, true);
                    return;
                }
                if (item == menuCheckboxItem)
                {
                    this.UnlimitedAmmo = _checked;
                    Subtitle.Custom(string.Concat("Unlimited ammo is now ", (_checked ? "enabled" : "disabled"), "."), 2500, true);
                }
            });
            menu2.OnIndexChange += new Menu.IndexChangedEvent((Menu sender, MenuItem oldItem, MenuItem newItem, int oldIndex, int newIndex) => WeaponOptions.<CreateMenu>g__OnIndexChange|20_3(sender, newItem));
            menu3.OnIndexChange += new Menu.IndexChangedEvent((Menu sender, MenuItem oldItem, MenuItem newItem, int oldIndex, int newIndex) => WeaponOptions.<CreateMenu>g__OnIndexChange|20_3(sender, newItem));
            menu4.OnIndexChange += new Menu.IndexChangedEvent((Menu sender, MenuItem oldItem, MenuItem newItem, int oldIndex, int newIndex) => WeaponOptions.<CreateMenu>g__OnIndexChange|20_3(sender, newItem));
            menu5.OnIndexChange += new Menu.IndexChangedEvent((Menu sender, MenuItem oldItem, MenuItem newItem, int oldIndex, int newIndex) => WeaponOptions.<CreateMenu>g__OnIndexChange|20_3(sender, newItem));
            menu6.OnIndexChange += new Menu.IndexChangedEvent((Menu sender, MenuItem oldItem, MenuItem newItem, int oldIndex, int newIndex) => WeaponOptions.<CreateMenu>g__OnIndexChange|20_3(sender, newItem));
            menu7.OnIndexChange += new Menu.IndexChangedEvent((Menu sender, MenuItem oldItem, MenuItem newItem, int oldIndex, int newIndex) => WeaponOptions.<CreateMenu>g__OnIndexChange|20_3(sender, newItem));
            menu8.OnIndexChange += new Menu.IndexChangedEvent((Menu sender, MenuItem oldItem, MenuItem newItem, int oldIndex, int newIndex) => WeaponOptions.<CreateMenu>g__OnIndexChange|20_3(sender, newItem));
            menu9.OnIndexChange += new Menu.IndexChangedEvent((Menu sender, MenuItem oldItem, MenuItem newItem, int oldIndex, int newIndex) => WeaponOptions.<CreateMenu>g__OnIndexChange|20_3(sender, newItem));
            menu2.OnMenuOpen += new Menu.MenuOpenedEvent((Menu sender) => WeaponOptions.<CreateMenu>g__OnIndexChange|20_3(sender, sender.GetCurrentMenuItem()));
            menu3.OnMenuOpen += new Menu.MenuOpenedEvent((Menu sender) => WeaponOptions.<CreateMenu>g__OnIndexChange|20_3(sender, sender.GetCurrentMenuItem()));
            menu4.OnMenuOpen += new Menu.MenuOpenedEvent((Menu sender) => WeaponOptions.<CreateMenu>g__OnIndexChange|20_3(sender, sender.GetCurrentMenuItem()));
            menu5.OnMenuOpen += new Menu.MenuOpenedEvent((Menu sender) => WeaponOptions.<CreateMenu>g__OnIndexChange|20_3(sender, sender.GetCurrentMenuItem()));
            menu6.OnMenuOpen += new Menu.MenuOpenedEvent((Menu sender) => WeaponOptions.<CreateMenu>g__OnIndexChange|20_3(sender, sender.GetCurrentMenuItem()));
            menu7.OnMenuOpen += new Menu.MenuOpenedEvent((Menu sender) => WeaponOptions.<CreateMenu>g__OnIndexChange|20_3(sender, sender.GetCurrentMenuItem()));
            menu8.OnMenuOpen += new Menu.MenuOpenedEvent((Menu sender) => WeaponOptions.<CreateMenu>g__OnIndexChange|20_3(sender, sender.GetCurrentMenuItem()));
            menu9.OnMenuOpen += new Menu.MenuOpenedEvent((Menu sender) => WeaponOptions.<CreateMenu>g__OnIndexChange|20_3(sender, sender.GetCurrentMenuItem()));
        }

        public Menu GetMenu()
        {
            if (this.menu == null)
            {
                this.CreateMenu();
            }
            return this.menu;
        }
    }
}