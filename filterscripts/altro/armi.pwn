//Weapon  Menu-David Sean
#include <a_samp>

new Menu:weaponmenu;
new Menu:weaponmenu2;

#define LIGHT_BLUE 0x33CCFFAA

public OnFilterScriptInit()
{

        print("\n--------------------------------------");
		print(" [FILTERSCRIPT armi]");
        print(" Armi Spawn di David Sean, Editato da Maxel - CARICATO");
        print("--------------------------------------\n");

        weaponmenu = CreateMenu("Lista Armi", 1, 220.0, 100.0, 150.0, 150.0);
        AddMenuItem(weaponmenu, 0, "Pistola 9mm");
        AddMenuItem(weaponmenu, 0, "Pistola 9mm Silenziata");
        AddMenuItem(weaponmenu, 0, "Desert Eagle");
        AddMenuItem(weaponmenu, 0, "Fucile a pompa");
        AddMenuItem(weaponmenu, 0, "Fucile a Canne Mozze");
        AddMenuItem(weaponmenu, 0, "Fucile Spas-12");
        AddMenuItem(weaponmenu, 0, "Mitra Micro SMG");
        AddMenuItem(weaponmenu, 0, "Mitra MP5");
        AddMenuItem(weaponmenu, 0, "Fucile Automatico AK47");
        AddMenuItem(weaponmenu, 0, "Fucile Automatico M4");
        AddMenuItem(weaponmenu, 0, "Mitra Tec9");
        AddMenuItem(weaponmenu, 0, "PAGINA SUCCESSIVA");

        weaponmenu2 = CreateMenu("Lista Armi", 1, 220.0, 100.0, 150.0, 150.0);
        AddMenuItem(weaponmenu2, 0, "Fucile da cecchino"); // Semiautomatico
        AddMenuItem(weaponmenu2, 0, "Minigun (n/d)"); // Cecchino
        AddMenuItem(weaponmenu2, 0, "Fucile Semi-automatico"); // Minigun
        AddMenuItem(weaponmenu2, 0, "Lanciamissili (n/d)");
        AddMenuItem(weaponmenu2, 0, "HS Lanciamissili (n/d)");
        AddMenuItem(weaponmenu2, 0, "Lanciafiamme (n/d)");
        AddMenuItem(weaponmenu2, 0, "Granata a Gas");
        AddMenuItem(weaponmenu2, 0, "Granata (n/d)");
        AddMenuItem(weaponmenu2, 0, "Molotov (n/d)");
        AddMenuItem(weaponmenu2, 0, "Motosega (n/d)");
        AddMenuItem(weaponmenu2, 0, "PAGINA PRECEDENTE");
        return 1;
}

public OnFilterScriptExit()
{

        print("\n--------------------------------------");
        print(" Armi Spawn di David Sean, Editato da Maxel - DISATTIVATO");
        print("--------------------------------------\n");

}

public OnPlayerConnect(playerid)
{
       // SendClientMessage(playerid, LIGHT_BLUE, "Type: /gunshop to spawn weapons.");
        return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
        if(strcmp(cmdtext, "/armi", true) == 0)
        {
        SendClientMessage(playerid, LIGHT_BLUE, "Usa: INVIO per uscire, SPAZIO per selezionare, Freccie SU/GIU per muovere.");
        ShowMenuForPlayer(weaponmenu, playerid);
        return 1;
        }
        return 0;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
        new Menu:CurrentMenu = GetPlayerMenu(playerid);
        if(CurrentMenu == weaponmenu)
        {
        switch(row)
        {
                case 0: //9mm
                {
                    GivePlayerWeapon(playerid, 22 , 500);
                    SendClientMessage(playerid, LIGHT_BLUE, "Ti sei equipaggiato la seguente arma:  9mm!");
                }
                case 1: //Silenced 9mm
                {
                    GivePlayerWeapon(playerid, 23 , 500);
                    SendClientMessage(playerid, LIGHT_BLUE, "Ti sei equipaggiato la seguente arma:  9mm Silenziata!");
                }
                case 2: //Desert Eagle
                {
                    GivePlayerWeapon(playerid, 24 , 500);
                    SendClientMessage(playerid, LIGHT_BLUE, "Ti sei equipaggiato la seguente arma:  Desert Eagle!");
                }
                case 3: //Shotgun
                {
                    GivePlayerWeapon(playerid, 25 , 500);
                    SendClientMessage(playerid, LIGHT_BLUE, "Ti sei equipaggiato la seguente arma:  Fucile a pompa!");
                }
                case 4: //Sawnoff Shotgun
                {
                    GivePlayerWeapon(playerid, 26 , 500);
                    SendClientMessage(playerid, LIGHT_BLUE, "Ti sei equipaggiato la seguente arma:  Fucile a canne mozze!");
                }
                case 5: //Combat Shotgun
                {
                    GivePlayerWeapon(playerid, 27 , 500);
                    SendClientMessage(playerid, LIGHT_BLUE, "Ti sei equipaggiato la seguente arma:  Spas-12!");
                        }
                case 6: //Micro SMG (Uzi)
                {
                    GivePlayerWeapon(playerid, 28 , 500);
                    SendClientMessage(playerid, LIGHT_BLUE, "Ti sei equipaggiato la seguente arma:  Micro SMG (Uzi)!");
                        }
                case 7: //SMG (MP5)
                {
                    GivePlayerWeapon(playerid, 29 , 500);
                    SendClientMessage(playerid, LIGHT_BLUE, "Ti sei equipaggiato la seguente arma:  MP5!");
                        }
                        case 8: //AK47 (Kalashnikov)
                {
                    GivePlayerWeapon(playerid, 30 , 500);
                    SendClientMessage(playerid, LIGHT_BLUE, "Ti sei equipaggiato la seguente arma:  AK47 !");
                        }
                case 9: //M4
                {
                    GivePlayerWeapon(playerid, 31 , 500);
                    SendClientMessage(playerid, LIGHT_BLUE, "Ti sei equipaggiato la seguente arma:  M4!");
                }
                case 10: //Tec9
                {
                    GivePlayerWeapon(playerid, 32 , 500);
                    SendClientMessage(playerid, LIGHT_BLUE, "Ti sei equipaggiato la seguente arma:  Tec9!");
                }
                case 11: //Next Page
                {
                                HideMenuForPlayer(weaponmenu,playerid);
                                ShowMenuForPlayer(weaponmenu2,playerid);
                }
        }
        }
        else if(CurrentMenu == weaponmenu2)
        {
        switch(row)
        {
                case 0: //Sniper Rifle
                {
                    GivePlayerWeapon(playerid, 34 , 500);
                    SendClientMessage(playerid, LIGHT_BLUE, "Ti sei equipaggiato la seguente arma:  Fucile da cecchino!");
                }
                case 1: //Minigun
                {
                   // GivePlayerWeapon(playerid, 38 , 500);
                   // SendClientMessage(playerid, LIGHT_BLUE, "Ti sei equipaggiato la seguente arma:  Minigun!");
                                return 1;
                        }
                        case 2: //Country Rifle
                {
                    GivePlayerWeapon(playerid, 33 , 500);
                    SendClientMessage(playerid, LIGHT_BLUE, "Ti sei equipaggiato la seguente arma:  Fucile semi-automatico!");
                }
                        case 3: //Rocket Launcher
                {
                  //  GivePlayerWeapon(playerid, 35 , 500);
                  //  SendClientMessage(playerid, LIGHT_BLUE, "Ti sei equipaggiato la seguente arma:  Rocket Launcher!");
                }
                        case 4: //HS Rocket Launcher
                {
                 //   GivePlayerWeapon(playerid, 36 , 500);
                 //   SendClientMessage(playerid, LIGHT_BLUE, "Ti sei equipaggiato la seguente arma:  HS Rocket Launcher!");
                }
                        case 5: //Flame Thrower
                {
                  //  GivePlayerWeapon(playerid, 37 , 500);
                  //  SendClientMessage(playerid, LIGHT_BLUE, "Ti sei equipaggiato la seguente arma:  Flamethrower!");
                }
                        case 6: //Tear Gas
                {
                    GivePlayerWeapon(playerid, 17 , 500);
                    SendClientMessage(playerid, LIGHT_BLUE, "Ti sei equipaggiato la seguente arma:  Granata a Gas!");
                }
                        case 7: //Gernade
                {
                   // GivePlayerWeapon(playerid, 16 , 500);
                   // SendClientMessage(playerid, LIGHT_BLUE, "Ti sei equipaggiato la seguente arma:  Granata a frammentazione!");
                }
                        case 8: //Molotov Cocktail
                {
                   // GivePlayerWeapon(playerid, 18 , 500);
                   // SendClientMessage(playerid, LIGHT_BLUE, "Ti sei equipaggiato la seguente arma:  Molotov Cocktails!");
                }
                        case 9: //Chainsaw
                {
                  //  GivePlayerWeapon(playerid, 9 , 500);
                  //  SendClientMessage(playerid, LIGHT_BLUE, "Ti sei equipaggiato la seguente arma:  Chainsaw!");
                }
                        case 10: //Previous Page
                {
                                HideMenuForPlayer(weaponmenu2,playerid);
                                ShowMenuForPlayer(weaponmenu,playerid);
                }
        }
        }
        return 1;
}
