#include <a_samp>
#include <streamer>
#include <smartcmd>
#include <easydialog>
#include <sqlitei>
#include <sscanf2>

#define SERVER_NAME "Dildo City Roleplay"
#define DB_NAME "server.db"
#define ANTICHEAT "Dio"

new DB:serverdb;
#define MAX_FAILS 3

#define EMB_WHITE "{FFFFFF}"
#define EMB_GREEN "{008000}"
#define EMB_RED "{FF0000}"
#define EMB_ORANGE "{FFA500}"
#define EMB_YELLOW "{ccff33}"
#define EMB_AINFO "{00ff94}"
#define EMB_DGREEN "{8C9566}"
#define EMB_CYAN "{00cccc}"

#define MAX_ITEMS 500
#define NO_ITEM 999

new createdItems = 1;
new PlayerText:InvTD[MAX_PLAYERS][11];
new giveItemID[MAX_PLAYERS];
new giveItemQ[MAX_PLAYERS];
new giveItemOther[MAX_PLAYERS];

#define MAX_INVENTORY_SLOTS 11

#define ITEM_NOUSE 0
#define ITEM_FOOD 1
#define ITEM_WEAP 2
#define ITEM_AMMO 3
#define ITEM_VEHKEY 4

#define strcpy(%0,%1,%2) \
strcat((%0[0] = '\0', %0), %1, %2)

enum (*=2)
{
    VIP_CMD = 1,
    RCON_CMD,
    PLAYER_CMD,
    ACMD1,
    ACMD2,
    ACMD3,
    ACMD4,
    ACMD5
}

enum I_PLAYER_INV
{
	pItemID,
	pItemName[32],
	pItemQuantity,
	pItemType,
	pKeyID
};

new PlayerInventory[MAX_PLAYERS][MAX_INVENTORY_SLOTS][I_PLAYER_INV];

enum I_SERVER_ITEMS
{
	sItemID,
	sItemName[32],
	sMaxQuantity,
	sItemType,
};
new ServerItems[MAX_ITEMS][I_SERVER_ITEMS];

enum I_PLAYER_ENUM
{
	pID,
	pPsw[65],
	pSalt[11],
	pLogged,
	pAttempts,
	pAdmin,
	pMoney,
	pBuyin,
	Float:pPosX,
	Float:pPosY,
	Float:pPosZ,
	Float:pPosA
};
new PlayerInfo[MAX_PLAYERS][I_PLAYER_ENUM];

enum I_SERVER_VEHICLES
{
	Float:vPosX,
	Float:vPosY,
	Float:vPosZ,
	Float:vPosA,
	vModelID,
	vColor1,
	vColor2,
	vOwnerID,
	vID,
	vEngine,
	vLight,
	Float:vHealth,
	vLocked,
	Float:vFuel,
	vKM,
	vKey,
	vKeyPresent
};
new ServerVehicles[MAX_VEHICLES][I_SERVER_VEHICLES];

#define MAX_DEALERSHIPS 5
#define MAX_DEALERSHIP_VEHICLES 20
new dVeh;
new PlayerText:DealerTD[MAX_PLAYERS];

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

enum I_DEALER_INFO
{
	Float:dPosX,
	Float:dPosY,
	Float:dPosZ,
	Float:dSpawnX,
	Float:dSpawnY,
	Float:dSpawnZ,
	Float:dSpawnA,
	Text3D:dLabel,
	dName[32],
	dPickup,
	dModel[MAX_DEALERSHIP_VEHICLES],
	dPrice[MAX_DEALERSHIP_VEHICLES]
};
new DealerInfo[MAX_DEALERSHIPS][I_DEALER_INFO];

new createdVeh;
new createdD;
new svAddons_WeaponNames[][] =
{
        "Fist", "Brass Knuckles", "Golf Club", "Nightstick", "Knife", "Baseball Bat", "Shovel", "Pool Cue", "Katana",
        "Chainsaw", "Double-ended Dildo", "Dildo", "Vibrator", "Silver Vibrator", "Flowers", "Cane", "Grenade", "Tear Gas",
        "Molotov Cocktail", "", "", "", "9mm", "Silenced 9mm", "Desert Eagle", "Shotgun", "Sawnoff Shotgun", "Combat Shotgun",
        "Uzi", "MP5", "AK-47", "M4", "Tec-9", "Country Rifle", "Sniper Rifle", "RPG", "HS Rocket", "Flamethrower", "Minigun",
        "Satchel Charge", "Detonator", "Spraycan", "Fire Extinguisher", "Camera", "Night Vision Goggles", "Thermal Goggles",
        "Parachute"
};


static const VehicleName[212][64] = {
		"Landstalker","Bravura","Buffalo","Linerunner","Pereniel","Sentinel","Dumper","Firetruck","Trashmaster","Stretch","Manana","Infernus",
		"Voodoo","Pony","Mule","Cheetah","Ambulance","Leviathan","Moonbeam","Esperanto","Taxi","Washington","Bobcat","Mr Whoopee","BF Injection",
		"Hunter","Premier","Enforcer","Securicar","Banshee","Predator","Bus","Rhino","Barracks","Hotknife","Trailer","Previon","Coach","Cabbie",
		"Stallion","Rumpo","RC Bandit","Romero","Packer","Monster","Admiral","Squalo","Seasparrow","Pizzaboy","Tram","Trailer","Turismo","Speeder",
		"Reefer","Tropic","Flatbed","Yankee","Caddy","Solair","Berkley's RC Van","Skimmer","PCJ-600","Faggio","Freeway","RC Baron","RC Raider",
		"Glendale","Oceanic","Sanchez","Sparrow","Patriot","Quad","Coastguard","Dinghy","Hermes","Sabre","Rustler","ZR3 50","Walton","Regina",
		"Comet","BMX","Burrito","Camper","Marquis","Baggage","Dozer","Maverick","News Chopper","Rancher","FBI Rancher","Virgo","Greenwood",
		"Jetmax","Hotring","Sandking","Blista Compact","Police Maverick","Boxville","Benson","Mesa","RC Goblin","Hotring Racer A","Hotring Racer B",
		"Bloodring Banger","Rancher","Super GT","Elegant","Journey","Bike","Mountain Bike","Beagle","Cropdust","Stunt","Tanker","RoadTrain",
		"Nebula","Majestic","Buccaneer","Shamal","Hydra","FCR-900","NRG-500","HPV1000","Cement Truck","Tow Truck","Fortune","Cadrona","FBI Truck",
		"Willard","Forklift","Tractor","Combine","Feltzer","Remington","Slamvan","Blade","Freight","Streak","Vortex","Vincent","Bullet","Clover",
		"Sadler","Firetruck","Hustler","Intruder","Primo","Cargobob","Tampa","Sunrise","Merit","Utility","Nevada","Yosemite","Windsor","Monstera",
		"Monsterb","Uranus","Jester","Sultan","Stratum","Elegy","Raindance","RC Tiger","Flash","Tahoma","Savanna","Bandito","Freight","Trailer",
		"Kart","Mower","Duneride","Sweeper","Broadway","Tornado","AT-400","DFT-30","Huntley","Stafford","BF-400","Newsvan","Tug","Trailer A","Emperor",
		"Wayfarer","Euros","Hotdog","Club","Trailer B","Trailer C","Andromada","Dodo","RC Cam","Launch","Police Car (LSPD)","Police Car (SFPD)",
		"Police Car (LVPD)","Police Ranger","Picador","S.W.A.T. Van","Alpha","Phoenix","Glendale","Sadler","Luggage Trailer A","Luggage Trailer B",
		"Stair Trailer","Boxville","Farm Plow","Utility Trailer"};



public OnGameModeInit()
{
	print("\n--------------------------------------");
	print(" Fatman Inventory System");
	print("--------------------------------------\n");
	ShowPlayerMarkers(0);
	serverdb = db_open(DB_NAME);
	SendRconCommand("hostname "SERVER_NAME"");

	db_query(serverdb, "CREATE TABLE IF NOT EXISTS `Players` (pID INTEGER PRIMARY KEY AUTOINCREMENT,\
						PlayerName  VARCHAR(24),\
						Password VARCHAR(129),\
						Salt VARCHAR(11),\
						Money INTEGER DEFAULT 0 NOT NULL,\
						AdminLevel INTEGER DEFAULT 0 NOT NULL,\
						PosX FLOAT DEFAULT 20.0 NOT NULL,\
						PosY FLOAT DEFAULT 20.0 NOT NULL,\
						PosZ FLOAT DEFAULT 20.0 NOT NULL,\
						PosA FLOAT DEFAULT 0.0 NOT NULL)");

	db_query(serverdb, "CREATE TABLE IF NOT EXISTS `Inventory` (pName VARCHAR(24),\
					    ItemsID VARCHAR(64),\
					    ItemsQ VARCHAR(128))");

	db_query(serverdb, "CREATE TABLE IF NOT EXISTS Vehicles (vID INTEGER PRIMARY KEY AUTOINCREMENT,\
						Engine INTEGER DEFAULT 0 NOT NULL,\
						OwnerID INTEGER DEFAULT 0 NOT NULL,\
						Lights INTEGER DEFAULT 0 NOT NULL,\
						Health FLOAT DEFAULT 999.9 NOT NULL,\
						Locked INTEGER DEFAULT 0 NOT NULL,\
						Fuel FLOAT DEFAULT 5.0 NOT NULL,\
						KM INTEGER DEFAULT 0 NOT NULL,\
						Key INTEGER DEFAULT 0 NOT NULL,\
						KeyPresent INTEGER DEFAULT 0 NOT NULL,\
						PosX FLOAT DEFAULT 20.0 NOT NULL,\
						PosY FLOAT DEFAULT 20.0 NOT NULL,\
						PosZ FLOAT DEFAULT 20.0 NOT NULL,\
						PosA FLOAT DEFAULT 0.0 NOT NULL,\
						Color1 INTEGER DEFAULT 0 NOT NULL,\
						Color2 INTEGER DEFAULT 0 NOT NULL)");

	new id = CreateDealership("Conc. Sportive","FC",110.3672,1106.6704,13.6094,105.1987,1088.8165,13.3562,352.6316);
	AddVehicleToDealerShip(id, 560, 50000); // Sultan
	AddVehicleToDealerShip(id, 562, 42000); // Elegy
	AddVehicleToDealerShip(id, 565, 35000); // Flash
	AddVehicleToDealerShip(id, 559, 40000); // Jester
	AddVehicleToDealerShip(id, 561, 36000); // Stratum
	AddVehicleToDealerShip(id, 558, 33200); // Uranus
	CreateItem("9mm",50,ITEM_WEAP);
	CreateItem("Colpi 9mm",500,ITEM_AMMO);
	CreateItem("Patatine",10,ITEM_FOOD);
	CreateItem("Baseball Bat",1,ITEM_WEAP);
	CreateItem("Shotgun",50,ITEM_WEAP);
	CreateItem("Desert eagle",50,ITEM_WEAP);
	CreateItem("Colpi .50AE",500,ITEM_AMMO);
	CreateItem("Pallettoni",500,ITEM_AMMO);
	CreateItem("Chiave veicolo ID: X",1,ITEM_VEHKEY);
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

main()
{
	print("\n----------------------------------");
	print(" Random Shits");
	print("----------------------------------\n");
}

public OnPlayerRequestClass(playerid, classid)
{

	new query[128],DBResult:result,string[156];
	TogglePlayerSpectating(playerid, true);
	ClearPlayerInventory(playerid);
	format(query,sizeof(query), "SELECT Password,Salt FROM `Players` WHERE `PlayerName` = '%q'",GetPlayerNameEx(playerid));
	result = db_query(serverdb, query);
	if(db_num_rows(result))
	{
		db_get_field_assoc(result, "Password", PlayerInfo[playerid][pPsw], 65);
		db_get_field_assoc(result, "Salt", PlayerInfo[playerid][pSalt], 11);
		format(string,sizeof(string), ""EMB_WHITE"Bentornato "EMB_ORANGE"%s"EMB_WHITE" usa la tua password per eseguire il login in "EMB_GREEN"%s",GetPlayerNameEx(playerid), SERVER_NAME);
		Dialog_Show(playerid, dialog_Login, DIALOG_STYLE_PASSWORD,"Login", string, "Login", "Esci(Kick)");
	}
	else
	{
		format(string,sizeof(string), ""EMB_WHITE"Benvenuto "EMB_ORANGE"%s"EMB_WHITE" usa la tua password per eseguire la registrazione in "EMB_GREEN"%s",GetPlayerNameEx(playerid), SERVER_NAME);
		Dialog_Show(playerid, dialog_Register, DIALOG_STYLE_PASSWORD,"Registrazione", string, "Registrazione", "Esci(Kick)");		
	}
	db_free_result(result);
	return 1;
}


public OnPlayerConnect(playerid)
{
	SetSpawnInfo(playerid, 0, random(200),  1958.3783, 1343.1572, 15.3746, 0.0, 0, 0, 0, 0, 0, 0);
	new tmp[I_PLAYER_ENUM] = 0;
	PlayerInfo[playerid] = tmp;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	PlayerInfo[playerid][pMoney] = GetPlayerMoney(playerid);
	SavePlayerData(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	for(new i=0;i<11;i++){PlayerTextDrawShow(playerid, InvTD[playerid][i]);}
	if(PlayerInfo[playerid][pLogged] == 0)
	{
		SetPlayerPos(playerid, PlayerInfo[playerid][pPosX],PlayerInfo[playerid][pPosY],PlayerInfo[playerid][pPosZ]);
		SetPlayerFacingAngle(playerid, PlayerInfo[playerid][pPosA]);
		PlayerInfo[playerid][pLogged] = 1;
	}
	else SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	InvTDUpdate(playerid);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(PRESSED(KEY_WALK))
	{
		new did = GetPlayerDealership(playerid);
		if(did != -1)
		{
			new string[256];
			for(new v = 0; v < MAX_DEALERSHIP_VEHICLES; v++)
			{
				if(DealerInfo[did][dPrice][v] == 0) continue;
				if(v == 0)
				{
					format(string,sizeof(string), "Nome Veicolo\tCosto\n"EMB_WHITE"%s\t"EMB_DGREEN"%d$\n",GetVehicleModelName(DealerInfo[did][dModel][v]),DealerInfo[did][dPrice][v]);
				}
				else format(string,sizeof(string), "%s"EMB_WHITE"%s\t"EMB_DGREEN"%d$\n",string,GetVehicleModelName(DealerInfo[did][dModel][v]),DealerInfo[did][dPrice][v]);

			}
			new cap[32];
			format(cap,sizeof(cap), ""EMB_CYAN"%s",DealerInfo[did][dName]);
			Dialog_Show(playerid, dialog_Dealership, DIALOG_STYLE_TABLIST_HEADERS, cap, string, "Ok","");
		}
	}
	return 1;
}

Dialog:dialog_Dealership(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;
	PlayerInfo[playerid][pBuyin] = listitem;
	Dialog_Show(playerid, dialog_Dealership_color, DIALOG_STYLE_INPUT, "Scelta del colore", "Scegli il colore primario e secondario del veicolo\nDeve essere inserivo nel seguente formato: Colore primario , Colore secondario. (Esempio: 0 , 3)\nPuoi trovare una lista completa nel link sottostante\n"EMB_CYAN"http://wiki.sa-mp.com/wiki/Vehicle_Color_IDs", "Conferma", "Annulla");
	return 1;
}

Dialog:dialog_Dealership_color(playerid, response, listitem, inputtext[])
{
	if(!response) return PlayerInfo[playerid][pBuyin] = 0;
	if(strfind(inputtext, ",", true) == -1) return Dialog_Show(playerid, dialog_Dealership_color, DIALOG_STYLE_INPUT, "Scelta del colore", "Scegli il colore primario e secondario del veicolo\nDeve essere inserivo nel seguente formato: Colore primario , Colore secondario. (Esempio: 0 , 3)\nPuoi trovare una lista completa nel link sottostante\n"EMB_CYAN"http://wiki.sa-mp.com/wiki/Vehicle_Color_IDs", "Conferma", "Annulla");
	new did = GetPlayerDealership(playerid), id = PlayerInfo[playerid][pBuyin];
	new color1,color2,string[170];
	sscanf(inputtext,"p<,>ii",color1,color2);
	SetPVarInt(playerid, "Color1", color1); SetPVarInt(playerid, "Color2", color2);
	PlayerTextDrawSetPreviewModel(playerid, DealerTD[playerid], DealerInfo[did][dModel][id]);
	PlayerTextDrawSetPreviewVehCol(playerid, DealerTD[playerid], color1, color2);
	PlayerTextDrawShow(playerid, DealerTD[playerid]);
	format(string,sizeof(string), ""EMB_WHITE"Hai scelto di acquistare una "EMB_YELLOW"%s\n"EMB_WHITE"ID colore principale: %d\nID colore secondario: %d\nPrezzo finale: "EMB_DGREEN"%d$",GetVehicleModelName(DealerInfo[did][dModel][id]),color1,color2,DealerInfo[did][dPrice][id]);
	Dialog_Show(playerid, dialog_Dealership_conf, DIALOG_STYLE_MSGBOX, "Conferma acquisto", string, "Conferma", "Annulla");
	return 1;
}

Dialog:dialog_Dealership_conf(playerid, response, listitem, inputtext[])
{
	if(!response) return Dialog_Show(playerid, dialog_Dealership_color, DIALOG_STYLE_INPUT, "Scelta del colore", "Scegli il colore primario e secondario del veicolo\nDeve essere inserivo nel seguente formato: Colore primario , Colore secondario. (Esempio: 0 , 3)\nPuoi trovare una lista completa nel link sottostante\n"EMB_CYAN"http://wiki.sa-mp.com/wiki/Vehicle_Color_IDs", "Conferma", "Annulla");	PlayerTextDrawHide(playerid, DealerTD[playerid]);
	if(HasPlayerFreeInventorySlot(playerid) == -1) return SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" Non hai spazio libero nell'inventario!");	PlayerTextDrawHide(playerid, DealerTD[playerid]);
	new did = GetPlayerDealership(playerid), id = PlayerInfo[playerid][pBuyin];
	if(GetPlayerMoney(playerid) < DealerInfo[did][dPrice][id]) return SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" Non hai abbastanza fondi!"); PlayerTextDrawHide(playerid, DealerTD[playerid]);
	PlayerTextDrawHide(playerid, DealerTD[playerid]);
	GivePlayerMoney(playerid, -DealerInfo[did][dPrice][id]);
	new string[126];
	format(string,sizeof(string), ""EMB_WHITE"Congratulazioni! Hai acquistato una "EMB_YELLOW"%s"EMB_WHITE" per "EMB_DGREEN" %d$",GetVehicleModelName(DealerInfo[did][dModel][id]),DealerInfo[did][dPrice][id]);
	SendClientMessage(playerid, -1, string);
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

/* ------------------------- COMMANDS -------------------------*/
CMD<ACMD3>:giveitem(cmdid, playerid, params[])
{
	new otherid,itemid,quantity,string[156];
	if(sscanf(params,"uii",otherid,itemid,quantity)) return SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" USO: /giveitem <playerid> <itemid> <quantity>");
	if(otherid == INVALID_PLAYER_ID) return SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" ID Inesistente"); 
	if(HasPlayerFreeInventorySlot(otherid) == -1) return SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" Il player non ha spazi liberi nell'inventario!");
	if(GetPlayerItemQuantity(playerid,itemid) >= ServerItems[itemid][sMaxQuantity]) return SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" Il giocatore ha superato il numero di item massimo!");
	GivePlayerItem(otherid, itemid, quantity);
	format(string,sizeof(string), ""EMB_GREEN"[INFO:]"EMB_WHITE" Hai givato a "EMB_ORANGE"%s"EMB_WHITE" l'item "EMB_YELLOW"%s"EMB_WHITE" ("EMB_YELLOW"%d"EMB_WHITE")", GetPlayerNameEx(otherid), ServerItems[itemid][sItemName],quantity);
	SendClientMessage(playerid, -1, string);
	return 1;
}

CMD<ACMD3>:givemoney(cmdid, playerid, params[])
{
	new otherid, money,string[124];
	if(sscanf(params, "ui",otherid, money)) return SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" USO: /givemoney <playerid> <money>");
	if(otherid == INVALID_PLAYER_ID) return SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" ID Inesistente"); 
	format(string,sizeof(string), ""EMB_YELLOW"[ACMD:]"EMB_ORANGE" %s"EMB_WHITE" Ha givato a "EMB_ORANGE"%s"EMB_DGREEN" %d$",GetPlayerNameEx(playerid),GetPlayerNameEx(otherid),money);
	SendClientMessage(otherid, -1, string);
	SendClientMessage(playerid, -1, string);
	GivePlayerMoney(otherid, money);
	return 1;
}


LoadPlayerData(playerid)
{
	new query[64],DBResult:result, field[20];
	format(query,sizeof(query), "SELECT * FROM Players WHERE PlayerName = '%q'",GetPlayerNameEx(playerid));
	result = db_query(serverdb, query);
	if(db_num_rows(result))
	{
		db_get_field_assoc(result, "pID",field,20); PlayerInfo[playerid][pID] = strval(field);
		db_get_field_assoc(result, "Money", field, 20); PlayerInfo[playerid][pMoney] = strval(field);
		db_get_field_assoc(result, "AdminLevel",field,20); PlayerInfo[playerid][pAdmin] = strval(field);
		db_get_field_assoc(result, "PosX", field, 20); PlayerInfo[playerid][pPosX] = floatstr(field);
		db_get_field_assoc(result, "PosY", field, 20); PlayerInfo[playerid][pPosY] = floatstr(field);
		db_get_field_assoc(result, "PosZ", field, 20); PlayerInfo[playerid][pPosZ] = floatstr(field);
		db_get_field_assoc(result, "PosA", field, 20); PlayerInfo[playerid][pPosA] = floatstr(field);
	}
	GivePlayerMoney(playerid, PlayerInfo[playerid][pMoney]);	
	db_free_result(result);
	TogglePlayerSpectating(playerid, false);
	return 1;
}

SavePlayerData(playerid)
{
	new query[256],Float:X,Float:Y,Float:Z,Float:A;
	GetPlayerPos(playerid, X,Y,Z);
	GetPlayerFacingAngle(playerid, A);
	format(query,sizeof(query), "UPDATE Players SET \
								Money = '%d',\
								AdminLevel = '%d',\
								PosX = '%.2f',\
								PosY = '%.2f',\
								PosZ = '%.2f',\
								PosA = '%.2f'\
								WHERE pID = '%d'",
								PlayerInfo[playerid][pMoney],
								PlayerInfo[playerid][pAdmin],
								X,Y,Z,A,
								PlayerInfo[playerid][pID]);
	db_query(serverdb,query);
	print(query);
	printf("Salvati i dati di %s",GetPlayerNameEx(playerid));
	SavePlayerInventory(playerid);
	return 1;
}

LoadPlayerInventory(playerid)
{
	new query[126],DBResult:result,itemid[64],itemq[128],itemgive[MAX_INVENTORY_SLOTS],itemgiveq[MAX_INVENTORY_SLOTS];
	format(query,sizeof(query), "SELECT * FROM Inventory WHERE pName = '%q'",GetPlayerNameEx(playerid));
	result = db_query(serverdb,query);
	if(!db_num_rows(result)) return 1;
	db_get_field_assoc(result, "ItemsID", itemid, 64);
	db_get_field_assoc(result, "ItemsQ",itemq,128);
	sscanf(itemid,"p<,>iiiiiiiiiii",itemgive[0],itemgive[1],itemgive[2],itemgive[3],itemgive[4],itemgive[5],itemgive[6],itemgive[7],itemgive[8],itemgive[9],itemgive[10]);
	sscanf(itemq,"p<,>iiiiiiiiiii",itemgiveq[0],itemgiveq[1],itemgiveq[2],itemgiveq[3],itemgiveq[4],itemgiveq[5],itemgiveq[6],itemgiveq[7],itemgiveq[8],itemgiveq[9],itemgiveq[10]);
	for(new s = 1; s < MAX_INVENTORY_SLOTS; s++)
	{
		if(itemgive[s] == 0) continue;
		GivePlayerItem(playerid, itemgive[s],itemgiveq[s]);
	}
	db_free_result(result);
	InvTDUpdate(playerid);
	return 1;
}

SavePlayerInventory(playerid)
{
	new query[156],string[126],string2[126];
	for(new s = 1; s < MAX_INVENTORY_SLOTS; s++)
	{
		if(PlayerInventory[playerid][s][pItemID] == NO_ITEM) continue;
		if(s == 1)
		{
			format(string2,sizeof(string2), ",%d",PlayerInventory[playerid][s][pItemID]);
			format(string,sizeof(string), ",%d",PlayerInventory[playerid][s][pItemQuantity]);
		}
		else if(s != 1)
		{
			format(string2,sizeof(string2), "%s,%d",string2,PlayerInventory[playerid][s][pItemID]);
			format(string,sizeof(string), "%s,%d",string,PlayerInventory[playerid][s][pItemQuantity]);		
		}
	}
	format(query,sizeof(query), "UPDATE Inventory SET ItemsID = '%q', ItemsQ = '%q' WHERE pName = '%q'",string2,string,GetPlayerNameEx(playerid));
	db_query(serverdb,query);
	return 1;
}

KickPlayer(playerid, kicker[],reason[])
{
	new string[156];
	format(string,sizeof(string), ""EMB_AINFO"[AINFO:]"EMB_WHITE" Sei stato kickato da "EMB_ORANGE"%s"EMB_WHITE". Motivo:"EMB_AINFO" %s",kicker,reason);
	SendClientMessage(playerid,-1, string);
	SetTimerEx("KickP",1000, 0, "i", playerid);
	return 1;
}

forward KickP(playerid);
public KickP(playerid)
{
	Kick(playerid);
	return 1;
}

GetVehicleModelName(modelid) 
{ 
    new tmp_vname[sizeof VehicleName[]]; 
    if (400 <= modelid <= 611) strcat(tmp_vname, VehicleName[modelid - 400], sizeof tmp_vname); 
    return tmp_vname; 
}  

GetPlayerItemQuantity(playerid, itemid)
{
	for(new i = 1; i < MAX_INVENTORY_SLOTS; i++)
	{
		if(PlayerInventory[playerid][i][pItemID] == itemid) return PlayerInventory[playerid][i][pItemQuantity];
	}
	return 0;
}

GivePlayerItem(playerid, itemid, quantity)
{
	for(new s = 1; s < MAX_INVENTORY_SLOTS; s++)
	{
		if(PlayerInventory[playerid][s][pItemID] == itemid && ServerItems[itemid][sItemType] != ITEM_WEAP && ServerItems[itemid][sItemType] != ITEM_VEHKEY)
		{
			PlayerInventory[playerid][s][pItemQuantity] += quantity;
			InvTDUpdate(playerid);
			return 1;
		}
		else if(PlayerInventory[playerid][s][pItemID] == NO_ITEM)
		{
			strcpy(PlayerInventory[playerid][s][pItemName],ServerItems[itemid][sItemName],32);
			PlayerInventory[playerid][s][pItemID] = itemid;
			PlayerInventory[playerid][s][pItemQuantity] += quantity;
			PlayerInventory[playerid][s][pItemType] = ServerItems[itemid][sItemType];
			InvTDUpdate(playerid);
			return 1;
		}
	}
	return 1;
}

RemovePlayerItem(playerid, itemid, quantity,slotid = 0)
{
	if(slotid == 0)
	{
		for(new s = 1; s < MAX_INVENTORY_SLOTS; s++)
		{
			if(PlayerInventory[playerid][s][pItemID] == itemid)
			{
				PlayerInventory[playerid][s][pItemQuantity] += quantity;
				if(PlayerInventory[playerid][s][pItemQuantity] == 0) PlayerInventory[playerid][s][pItemID] = NO_ITEM;
				InvTDUpdate(playerid);
			}
		}
		return 1;
	}
	else if(slotid != 0)
	{
		PlayerInventory[playerid][slotid][pItemQuantity] += quantity;
		if(PlayerInventory[playerid][slotid][pItemQuantity] == 0) PlayerInventory[playerid][slotid][pItemID] = NO_ITEM;
		InvTDUpdate(playerid);
	}
	return 1;
}

Dialog:dialog_Register(playerid, response, listitem, inputtext[])
{
	if(!response) return KickPlayer(playerid, ANTICHEAT, "Rifiuto alla registrazione");
	if(strlen(inputtext) < 1 && strlen(inputtext) > 20) return Dialog_Show(playerid, dialog_Register, DIALOG_STYLE_PASSWORD, "Registrazione","La tua password deve essere di una lunghezza inferiore a 20 caratteri","Ok","Esci(Kick)");
	new query[156],string[156];
	new salt[11];
	for(new i = 0; i < 10; i++)
	{
		salt[i] = random(79) + 47;
	}
	salt[10] = 0;
	SHA256_PassHash(inputtext, salt, PlayerInfo[playerid][pPsw], 65);
	format(query,sizeof(query), "INSERT INTO Players (PlayerName, Password, Salt) VALUES('%q','%q','%q')",GetPlayerNameEx(playerid),PlayerInfo[playerid][pPsw],salt);
	db_query(serverdb,query);
	format(query,sizeof(query), "INSERT INTO Inventory (pName) VALUES ('%q')",GetPlayerNameEx(playerid));
	db_query(serverdb,query);
	strcpy(PlayerInfo[playerid][pSalt], salt,11);
	SendClientMessage(playerid, -1, ""EMB_GREEN"[INFO:]"EMB_WHITE" Ti sei registrato con successo!");
	format(string,sizeof(string), ""EMB_WHITE"Bentornato "EMB_ORANGE"%s"EMB_WHITE" usa la tua password per eseguire il login in "EMB_GREEN"%s",GetPlayerNameEx(playerid), SERVER_NAME);
	Dialog_Show(playerid, dialog_Login, DIALOG_STYLE_PASSWORD,"Login", string, "Login", "Esci(Kick)");
	return 1;
}

Dialog:dialog_Login(playerid, response, listitem, inputtext[])
{
	if(!response) return KickPlayer(playerid, ANTICHEAT, "Rifiuto al login");	
	if(strlen(inputtext) < 1 && strlen(inputtext) > 20) return Dialog_Show(playerid, dialog_Register, DIALOG_STYLE_PASSWORD, "Login","La tua password deve essere di una lunghezza inferiore a 20 caratteri","Ok","Esci(Kick)");
	new string[256],hashpass[65];
	SHA256_PassHash(inputtext, PlayerInfo[playerid][pSalt], hashpass, 65);
	if(strcmp(PlayerInfo[playerid][pPsw], hashpass))
	{
		if(PlayerInfo[playerid][pAttempts] >= MAX_FAILS) return KickPlayer(playerid, ANTICHEAT, "Fallito il Login");
		else if(PlayerInfo[playerid][pAttempts] != MAX_FAILS)
		{
			PlayerInfo[playerid][pAttempts]++;
			format(string, sizeof(string), ""EMB_WHITE"La password inserita e' incorretta.\nHai usato "EMB_AINFO"%d"EMB_WHITE" tentativi su "EMB_RED"%d"EMB_WHITE".\nInserisci la tua password qui sotto",PlayerInfo[playerid][pAttempts],MAX_FAILS);
			Dialog_Show(playerid, dialog_Login, DIALOG_STYLE_PASSWORD, "Login", string, "Login","Esci(Kick)");
		}
		return 1;
	}
	else SendClientMessage(playerid, -1, ""EMB_GREEN"[INFO:]"EMB_WHITE" Ti sei loggato con successo!"); LoadPlayerData(playerid); TDCreate(playerid); LoadPlayerInventory(playerid);
	return 1;
}

CMD:asd(cmdid, playerid, params[])
{
	PlayerInfo[playerid][pAdmin] = 10;
	return 1;
}

CMD:dai(cmdid, playerid, params[])
{
	new otherid, slotid, quantity,string[124];
	if(sscanf(params,"uiI(1)",otherid,slotid,quantity)) return SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" USO: /dai <playerid> <slotid> <quantita'>");
	if(PlayerInventory[playerid][slotid][pItemID] == NO_ITEM) return SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" Non hai nulla da dare in questo slot!");
	if(PlayerInventory[playerid][slotid][pItemType] == ITEM_WEAP && quantity != PlayerInventory[playerid][slotid][pItemQuantity]) return SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" Puoi solo dare l'arma intera!");
	format(string,sizeof(string), ""EMB_ORANGE"%s"EMB_WHITE" vuole darti "EMB_YELLOW"%s"EMB_WHITE" ("EMB_YELLOW"%d"EMB_WHITE")",GetPlayerNameEx(playerid),PlayerInventory[playerid][slotid][pItemName],quantity);
	Dialog_Show(otherid, dialog_GiveItem, DIALOG_STYLE_MSGBOX, "Inventario", string, "Accetta", "Rifiuta");
	SendClientMessage(playerid, -1, ""EMB_GREEN"[INFO:]"EMB_WHITE" Hai proposto al player di dargli un oggetto");
	giveItemID[otherid] = PlayerInventory[playerid][slotid][pItemID];
	giveItemQ[otherid] = PlayerInventory[playerid][slotid][pItemQuantity];
	giveItemOther[otherid] = playerid;
	return 1;
}

Dialog:dialog_GiveItem(playerid, dialogid, response, listitem, inputtext[])
{
	if(response)
	{
		GivePlayerItem(playerid, giveItemID[playerid],giveItemQ[playerid]);
		RemovePlayerItem(giveItemOther[playerid],giveItemID[playerid],-giveItemQ[playerid]);
		SendClientMessage(playerid,-1, ""EMB_GREEN"[INFO:]"EMB_WHITE" Hai ricevuto l'oggetto");
		return 1;
	}
	else return SendClientMessage(giveItemOther[playerid], -1, ""EMB_GREEN"[INFO:]"EMB_WHITE" Il player non ha accettato lo scambio!");

}

CMD:inventory(cmdid, playerid, params[])
{
	new action[16],slotid,quantity;
	if(sscanf(params, "s[16]I(0)I(0)",action,slotid,quantity)) return SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" USO: /i <action> <slotid> <quantity>");
	if(slotid != 0) if(PlayerInventory[playerid][slotid][pItemQuantity] < quantity) return SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" Quantita' non sufficente");
	if(!strcmp(action, "usa"))
	{
		if(slotid == 0) return SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" USO: /i usa <slotid> <quantity>");
		if(PlayerInventory[playerid][slotid][pItemID] == NO_ITEM) return SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" Non hai nessun item in quello slot!");
		if(PlayerInventory[playerid][slotid][pItemType] == ITEM_NOUSE)
		{
			SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" Nessuno uso per questo item");
			return 1;
		}
		else if(PlayerInventory[playerid][slotid][pItemType] == ITEM_FOOD)
		{
			new string[124];
			format(string,sizeof(string), ""EMB_WHITE"Hai mangiato %s",PlayerInventory[playerid][slotid][pItemName]);
			SendClientMessage(playerid, -1, string);
			if(quantity == 0) RemovePlayerItem(playerid, PlayerInventory[playerid][slotid][pItemID], -1,slotid);
			else RemovePlayerItem(playerid, PlayerInventory[playerid][slotid][pItemID], -quantity,slotid);
			return 1;
		}
		else if(PlayerInventory[playerid][slotid][pItemType] == ITEM_AMMO)
		{
			if(GetPlayerWeapon(playerid) == 0) return SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" Non hai nessuna arma da caricare");
			if(slotid == 0 || quantity == 0) return SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" USO: /i carica <slotid> <quantita'>");
			new string[124],weapid,ammo,weapname[32],itemid;
			weapid = GetPlayerWeapon(playerid); ammo = GetPlayerAmmo(playerid); GetWeaponName(weapid, weapname, sizeof(weapname));
			itemid = GetItemIDFromName(weapname);
			if(GetAmmoType(itemid) != PlayerInventory[playerid][slotid][pItemID]) return SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" Munizioni incompatibili");
			format(string,sizeof(string),""EMB_GREEN"[INFO:]"EMB_WHITE" Hai caricato %d %s nella tua arma",quantity, PlayerInventory[playerid][slotid][pItemName]);
			SendClientMessage(playerid, -1, string);
			RemovePlayerWeapon(playerid, weapid);
			GivePlayerWeapon(playerid, weapid, ammo+quantity);
			RemovePlayerItem(playerid, PlayerInventory[playerid][slotid][pItemID], -quantity,slotid);
			return 1;	
		}
		else if(PlayerInventory[playerid][slotid][pItemType] == ITEM_WEAP) return SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" Usa /i equip(aggia) per le armi!");
	}
	else if(!strcmp(action, "getta"))
	{
		if(PlayerInventory[playerid][slotid][pItemID] == NO_ITEM) return SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" Non hai nessun item in quello slot!");
		if(quantity == 0) return SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" USO: /i getta <slotid> <slotid>");
		//DropItem(slot,quantity);
		return 1;
	}
	else if(!strcmp(action, "mostra"))
	{
		for(new i=0; i<11; i++){ PlayerTextDrawShow(playerid, InvTD[playerid][i]); }
		return 1;
	}
	else if(!strcmp(action, "nascondi"))
	{
		for(new i=0; i<11; i++){ PlayerTextDrawHide(playerid, InvTD[playerid][i]); }
		return 1;
	}
	else if(!strcmp(action, "equip") || !strcmp(action, "equipaggia") || !strcmp(action, "e"))
	{
		new string[124];
		if(PlayerInventory[playerid][slotid][pItemID] == NO_ITEM) return SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" Non hai nessun item in quello slot!");
		new weapid = GetWeaponID(PlayerInventory[playerid][slotid][pItemName]);
		GivePlayerWeapon(playerid, weapid, PlayerInventory[playerid][slotid][pItemQuantity]);
		format(string,sizeof(string), ""EMB_GREEN"[INFO:]"EMB_WHITE" Hai equipaggiato %s (%d)",PlayerInventory[playerid][slotid][pItemName],PlayerInventory[playerid][slotid][pItemQuantity]);
		SendClientMessage(playerid, -1, string);
		RemovePlayerItem(playerid, PlayerInventory[playerid][slotid][pItemID], -PlayerInventory[playerid][slotid][pItemQuantity],slotid);
		return 1;
	}
	else if(!strcmp(action, "r") || !strcmp(action, "riponi"))
	{
		if(GetPlayerWeapon(playerid) == 0) return SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" Non hai nessuna arma da riporre");
		if(HasPlayerFreeInventorySlot(playerid) == -1) return SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" Non hai alcuno slot libero nell'inventario!");
		slotid = HasPlayerFreeInventorySlot(playerid);
		new string[124];
		new itemid,weapname[32],weapid,ammo;
		weapid = GetPlayerWeapon(playerid); ammo = GetPlayerAmmo(playerid);
		GetWeaponName(weapid, weapname, sizeof(weapname));
		itemid = GetItemIDFromName(weapname);
		GivePlayerItem(playerid, itemid, ammo);
		format(string,sizeof(string), ""EMB_GREEN"[INFO:]"EMB_WHITE" Hai riposto nel tuo inventario %s (%d)",PlayerInventory[playerid][slotid][pItemName],PlayerInventory[playerid][slotid][pItemQuantity]);
		SendClientMessage(playerid, -1, string);
		RemovePlayerWeapon(playerid, weapid);
		return 1;	
	}
	else if(!strcmp(action, "scarica"))
	{
		if(GetPlayerWeapon(playerid) == 0) return SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" Non hai nessuna arma da riporre");
		if(HasPlayerFreeInventorySlot(playerid) == -1) return SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" Non hai alcuno slot libero nell'inventario!");	
		slotid = HasPlayerFreeInventorySlot(playerid);
		new string[124],itemid,weapname[32],weapid,ammo,ammoid;
		weapid = GetPlayerWeapon(playerid); ammo = GetPlayerAmmo(playerid); GetWeaponName(weapid, weapname, sizeof(weapname));
		itemid = GetItemIDFromName(weapname);
		ammoid = GetAmmoType(itemid);	
		GivePlayerItem(playerid, itemid, 0);
		GivePlayerItem(playerid, ammoid, ammo);
		format(string,sizeof(string), ""EMB_GREEN"[INFO:]"EMB_WHITE" Hai riposto nel tuo inventario %s (%d)",PlayerInventory[playerid][slotid][pItemName],PlayerInventory[playerid][slotid][pItemQuantity]);
		SendClientMessage(playerid, -1, string);
		RemovePlayerWeapon(playerid,weapid);		
		return 1;
	}
	SendClientMessage(playerid, -1, ""EMB_GREEN"[INFO:]"EMB_WHITE" Puoi usare getta, usa, equipaggia, riponi, mostra e nascondi, scarica");
	return 1;
}

ALT:i = CMD:inventory;

GetWeaponID(weapname[])
{
	for(new i; i < sizeof(svAddons_WeaponNames); i++)
	{
		if(strfind(weapname, svAddons_WeaponNames[i][32], true, 0)) return i;
	}
	return -1;
}

CreateDealership(name[],tag[],Float:x,Float:y,Float:z,Float:sx,Float:sy,Float:sz,Float:sa)
{
	DealerInfo[createdD][dPickup] = CreateDynamicPickup(1318, 1, x, y, z);
	new label[64];
	format(label,sizeof(label), ""EMB_CYAN"%s - [%s]", name,tag);
	strcpy(DealerInfo[createdD][dName], label,32);
	DealerInfo[createdD][dLabel] = CreateDynamic3DTextLabel(label, 0xFFFFFFAA, x, y, z+1, 10.0);
	DealerInfo[createdD][dPosX] = x;
	DealerInfo[createdD][dPosY] = y;
	DealerInfo[createdD][dPosZ] = z;
	DealerInfo[createdD][dSpawnX] = sx;
	DealerInfo[createdD][dSpawnY] = sy;
	DealerInfo[createdD][dSpawnZ] = sz;
	DealerInfo[createdD][dSpawnA] = sa;
	++createdD;
	return createdD-1;
}


GetPlayerDealership(playerid)
{
	for(new s = 0; s < MAX_DEALERSHIPS; s++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 1.0, DealerInfo[s][dPosX],DealerInfo[s][dPosY],DealerInfo[s][dPosZ])) return s;
	}
	return -1;
}

AddVehicleToDealerShip(id, modelid, price)
{
	DealerInfo[id][dModel][dVeh] = modelid;
	DealerInfo[id][dPrice][dVeh] = price;
	printf("Aggiunto il veicolo %s (%d) alla concessionaria %d. Costo: %d$\n",GetVehicleModelName(modelid), DealerInfo[id][dModel][dVeh], id, DealerInfo[id][dPrice][dVeh]);
	++dVeh;
	return dVeh-1;
}

GetAmmoType(itemid)
{
	switch(itemid)
	{
		case 1: return 2;
		case 5: return 8;
		case 6: return 7;
		default: return 0;
	}
	return 0;
}

RemovePlayerWeapon(playerid, weaponid)
{
	new
		plyWeapons[ 12 ], plyAmmo[ 12 ];

	for( new slot = 0; slot != 12; slot ++ )
	{
		new
			weap, ammo;
			
    	GetPlayerWeaponData( playerid, slot, weap, ammo );
		if( weap != weaponid )
		{
			GetPlayerWeaponData( playerid, slot, plyWeapons[ slot ], plyAmmo[ slot ] );
		}
	}
	ResetPlayerWeapons( playerid );
	for( new slot = 0; slot != 12; slot ++ )
	{
		GivePlayerWeapon( playerid, plyWeapons[ slot ], plyAmmo[ slot ] );
	}
}

GetPlayerNameEx(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

HasPlayerFreeInventorySlot(playerid)
{
	for(new s = 1; s < MAX_INVENTORY_SLOTS; s++)
	{
		if(PlayerInventory[playerid][s][pItemID] == NO_ITEM) return s;
	}
	return -1;
}

/*GetPlayerFreeInventorySlot(playerid, itemid)
{
	for(new s = 1; s < MAX_INVENTORY_SLOTS; s++)
	{
		if(PlayerInventory[playerid][s][pItemID] == itemid && PlayerInventory[playerid][s][pItemType] != ITEM_WEAP && PlayerInventory[playerid][s][pItemType] != ITEM_VEHKEY) return s;
		else if(PlayerInventory[playerid][s][pItemID] == NO_ITEM) return s;
		else return 0;
	}
	return 0;
}*/

public OnPlayerCommandReceived(cmdid, playerid, cmdtext[])
{
	if(GetCommandFlags(cmdid) == ACMD1)
	{
		if(PlayerInfo[playerid][pAdmin] < 1){ SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" Non sei autorizzato ad usare questo comando"); return 0; }
    }
    else if(GetCommandFlags(cmdid) == ACMD2)
	{
		if(PlayerInfo[playerid][pAdmin] < 2){ SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" Non sei autorizzato ad usare questo comando"); return 0; }
    }
    else if(GetCommandFlags(cmdid) == ACMD3)
	{
		if(PlayerInfo[playerid][pAdmin] < 3){ SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" Non sei autorizzato ad usare questo comando"); return 0; }
    }
    else if(GetCommandFlags(cmdid) == ACMD4)
	{
		if(PlayerInfo[playerid][pAdmin] < 4){ SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" Non sei autorizzato ad usare questo comando"); return 0; }
    }
	return 1;
}

GetItemIDFromName(itemname[])
{
	for(new i = 1; i < createdItems; i++)
	{
		if(!strcmp(itemname,ServerItems[i][sItemName],true)) return i;
	}
	return -1;
}



/*GetWeaponSlot(weaponid)
{
	new slot;
	switch(weaponid)
	{
		case 0,1: slot = 0;
		case 2 .. 9: slot = 1;
		case 10 .. 15: slot = 10;
		case 16 .. 18, 39: slot = 8;
		case 22 .. 24: slot =2;
		case 25 .. 27: slot = 3;
		case 28, 29, 32: slot = 4;	
		case 30, 31: slot = 5;
		case 33, 34: slot = 6;
		case 35 .. 38: slot = 7;
		case 40: slot = 12;	
		case 41 .. 43: slot = 9;
		case 44 .. 46: slot = 11;
	}
	return slot;
}*/

TDCreate(playerid)
{
	InvTD[playerid][0] = CreatePlayerTextDraw(playerid, 601.227478, 132.111022, "Inventario");
	PlayerTextDrawLetterSize(playerid, InvTD[playerid][0], 0.343000, 1.320000);
	PlayerTextDrawTextSize(playerid, InvTD[playerid][0], 0.000000, 74.000000);
	PlayerTextDrawAlignment(playerid, InvTD[playerid][0], 2);
	PlayerTextDrawColor(playerid, InvTD[playerid][0], 10484479);
	PlayerTextDrawUseBox(playerid, InvTD[playerid][0], 1);
	PlayerTextDrawBoxColor(playerid, InvTD[playerid][0], 110);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, InvTD[playerid][0], 1);
	PlayerTextDrawBackgroundColor(playerid, InvTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, InvTD[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, InvTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][0], 0);

	InvTD[playerid][1] = CreatePlayerTextDraw(playerid, 564.169921, 147.611968, "99:_Chiave_veicolo_ID:_100_(1)");
	PlayerTextDrawLetterSize(playerid, InvTD[playerid][1], 0.136668, 1.140000);
	PlayerTextDrawTextSize(playerid, InvTD[playerid][1], 684.109008, 0.000000);
	PlayerTextDrawAlignment(playerid, InvTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, InvTD[playerid][1], -1);
	PlayerTextDrawUseBox(playerid, InvTD[playerid][1], 1);
	PlayerTextDrawBoxColor(playerid, InvTD[playerid][1], 110);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, InvTD[playerid][1], 1);
	PlayerTextDrawBackgroundColor(playerid, InvTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, InvTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, InvTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][1], 0);

	InvTD[playerid][2] = CreatePlayerTextDraw(playerid, 564.169921, 161.012786, "99:_Chiave_veicolo_ID:_100_(1)");
	PlayerTextDrawLetterSize(playerid, InvTD[playerid][2], 0.136668, 1.140000);
	PlayerTextDrawTextSize(playerid, InvTD[playerid][2], 684.109008, 0.000000);
	PlayerTextDrawAlignment(playerid, InvTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, InvTD[playerid][2], -1);
	PlayerTextDrawUseBox(playerid, InvTD[playerid][2], 1);
	PlayerTextDrawBoxColor(playerid, InvTD[playerid][2], 110);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, InvTD[playerid][2], 1);
	PlayerTextDrawBackgroundColor(playerid, InvTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, InvTD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, InvTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][2], 0);

	InvTD[playerid][3] = CreatePlayerTextDraw(playerid, 564.169921, 174.613616, "99:_Chiave_veicolo_ID:_100_(1)");
	PlayerTextDrawLetterSize(playerid, InvTD[playerid][3], 0.136668, 1.140000);
	PlayerTextDrawTextSize(playerid, InvTD[playerid][3], 684.109008, 0.000000);
	PlayerTextDrawAlignment(playerid, InvTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, InvTD[playerid][3], -1);
	PlayerTextDrawUseBox(playerid, InvTD[playerid][3], 1);
	PlayerTextDrawBoxColor(playerid, InvTD[playerid][3], 110);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, InvTD[playerid][3], 1);
	PlayerTextDrawBackgroundColor(playerid, InvTD[playerid][3], 255);
	PlayerTextDrawFont(playerid, InvTD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, InvTD[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][3], 0);

	InvTD[playerid][4] = CreatePlayerTextDraw(playerid, 564.169921, 187.914428, "99:_Chiave_veicolo_ID:_100_(1)");
	PlayerTextDrawLetterSize(playerid, InvTD[playerid][4], 0.136668, 1.140000);
	PlayerTextDrawTextSize(playerid, InvTD[playerid][4], 684.109008, 0.000000);
	PlayerTextDrawAlignment(playerid, InvTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, InvTD[playerid][4], -1);
	PlayerTextDrawUseBox(playerid, InvTD[playerid][4], 1);
	PlayerTextDrawBoxColor(playerid, InvTD[playerid][4], 110);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, InvTD[playerid][4], 1);
	PlayerTextDrawBackgroundColor(playerid, InvTD[playerid][4], 255);
	PlayerTextDrawFont(playerid, InvTD[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, InvTD[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][4], 0);

	InvTD[playerid][5] = CreatePlayerTextDraw(playerid, 564.169921, 201.215240, "99:_Chiave_veicolo_ID:_100_(1)");
	PlayerTextDrawLetterSize(playerid, InvTD[playerid][5], 0.136668, 1.140000);
	PlayerTextDrawTextSize(playerid, InvTD[playerid][5], 684.109008, 0.000000);
	PlayerTextDrawAlignment(playerid, InvTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, InvTD[playerid][5], -1);
	PlayerTextDrawUseBox(playerid, InvTD[playerid][5], 1);
	PlayerTextDrawBoxColor(playerid, InvTD[playerid][5], 110);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, InvTD[playerid][5], 1);
	PlayerTextDrawBackgroundColor(playerid, InvTD[playerid][5], 255);
	PlayerTextDrawFont(playerid, InvTD[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, InvTD[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][5], 0);

	InvTD[playerid][6] = CreatePlayerTextDraw(playerid, 564.169921, 214.616058, "99:_Chiave_veicolo_ID:_100_(1)");
	PlayerTextDrawLetterSize(playerid, InvTD[playerid][6], 0.136668, 1.140000);
	PlayerTextDrawTextSize(playerid, InvTD[playerid][6], 684.109008, 0.000000);
	PlayerTextDrawAlignment(playerid, InvTD[playerid][6], 1);
	PlayerTextDrawColor(playerid, InvTD[playerid][6], -1);
	PlayerTextDrawUseBox(playerid, InvTD[playerid][6], 1);
	PlayerTextDrawBoxColor(playerid, InvTD[playerid][6], 110);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, InvTD[playerid][6], 1);
	PlayerTextDrawBackgroundColor(playerid, InvTD[playerid][6], 255);
	PlayerTextDrawFont(playerid, InvTD[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, InvTD[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][6], 0);

	InvTD[playerid][7] = CreatePlayerTextDraw(playerid, 564.169921, 228.216888, "99:_Chiave_veicolo_ID:_100_(1)");
	PlayerTextDrawLetterSize(playerid, InvTD[playerid][7], 0.136668, 1.140000);
	PlayerTextDrawTextSize(playerid, InvTD[playerid][7], 684.109008, 0.000000);
	PlayerTextDrawAlignment(playerid, InvTD[playerid][7], 1);
	PlayerTextDrawColor(playerid, InvTD[playerid][7], -1);
	PlayerTextDrawUseBox(playerid, InvTD[playerid][7], 1);
	PlayerTextDrawBoxColor(playerid, InvTD[playerid][7], 110);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, InvTD[playerid][7], 1);
	PlayerTextDrawBackgroundColor(playerid, InvTD[playerid][7], 255);
	PlayerTextDrawFont(playerid, InvTD[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, InvTD[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][7], 0);

	InvTD[playerid][8] = CreatePlayerTextDraw(playerid, 564.169921, 241.817718, "99:_Chiave_veicolo_ID:_100_(1)");
	PlayerTextDrawLetterSize(playerid, InvTD[playerid][8], 0.136668, 1.140000);
	PlayerTextDrawTextSize(playerid, InvTD[playerid][8], 684.109008, 0.000000);
	PlayerTextDrawAlignment(playerid, InvTD[playerid][8], 1);
	PlayerTextDrawColor(playerid, InvTD[playerid][8], -1);
	PlayerTextDrawUseBox(playerid, InvTD[playerid][8], 1);
	PlayerTextDrawBoxColor(playerid, InvTD[playerid][8], 110);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, InvTD[playerid][8], 1);
	PlayerTextDrawBackgroundColor(playerid, InvTD[playerid][8], 255);
	PlayerTextDrawFont(playerid, InvTD[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, InvTD[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][8], 0);

	InvTD[playerid][9] = CreatePlayerTextDraw(playerid, 564.169921, 255.118530, "99:_Chiave_veicolo_ID:_100_(1)");
	PlayerTextDrawLetterSize(playerid, InvTD[playerid][9], 0.136668, 1.140000);
	PlayerTextDrawTextSize(playerid, InvTD[playerid][9], 684.109008, 0.000000);
	PlayerTextDrawAlignment(playerid, InvTD[playerid][9], 1);
	PlayerTextDrawColor(playerid, InvTD[playerid][9], -1);
	PlayerTextDrawUseBox(playerid, InvTD[playerid][9], 1);
	PlayerTextDrawBoxColor(playerid, InvTD[playerid][9], 110);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, InvTD[playerid][9], 1);
	PlayerTextDrawBackgroundColor(playerid, InvTD[playerid][9], 255);
	PlayerTextDrawFont(playerid, InvTD[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid, InvTD[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][9], 0);

	InvTD[playerid][10] = CreatePlayerTextDraw(playerid, 564.169921, 268.519348, "99:_Chiave_veicolo_ID:_100_(1)");
	PlayerTextDrawLetterSize(playerid, InvTD[playerid][10], 0.136668, 1.140000);
	PlayerTextDrawTextSize(playerid, InvTD[playerid][10], 684.109008, 0.000000);
	PlayerTextDrawAlignment(playerid, InvTD[playerid][10], 1);
	PlayerTextDrawColor(playerid, InvTD[playerid][10], -1);
	PlayerTextDrawUseBox(playerid, InvTD[playerid][10], 1);
	PlayerTextDrawBoxColor(playerid, InvTD[playerid][10], 110);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, InvTD[playerid][10], 1);
	PlayerTextDrawBackgroundColor(playerid, InvTD[playerid][10], 255);
	PlayerTextDrawFont(playerid, InvTD[playerid][10], 1);
	PlayerTextDrawSetProportional(playerid, InvTD[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][10], 0);

	DealerTD[playerid] = CreatePlayerTextDraw(playerid, 272.666778, 294.377777, "");
	PlayerTextDrawLetterSize(playerid, DealerTD[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, DealerTD[playerid], 88.000000, 103.000000);
	PlayerTextDrawAlignment(playerid, DealerTD[playerid], 1);	
	PlayerTextDrawColor(playerid, DealerTD[playerid], -30);
	PlayerTextDrawSetShadow(playerid, DealerTD[playerid], 0);
	PlayerTextDrawSetOutline(playerid, DealerTD[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, DealerTD[playerid], 255);
	PlayerTextDrawFont(playerid, DealerTD[playerid], 5);
	PlayerTextDrawSetProportional(playerid, DealerTD[playerid], 0);
	PlayerTextDrawSetShadow(playerid, DealerTD[playerid], 0);
	PlayerTextDrawSetPreviewModel(playerid, DealerTD[playerid], 555);
	PlayerTextDrawSetPreviewRot(playerid, DealerTD[playerid], 0.000000, 0.000000, 42.000000, 0.901981);
	PlayerTextDrawSetPreviewVehCol(playerid, DealerTD[playerid], 1, 1);
	return 1;
}

ClearPlayerInventory(playerid)
{
	for(new s = 1; s < MAX_INVENTORY_SLOTS; s++)
	{
		PlayerInventory[playerid][s][pItemID] = NO_ITEM;
		PlayerInventory[playerid][s][pItemQuantity] = 0;
	}
	return 1;
}

InvTDUpdate(playerid)
{
	new string[64], slot = 1, id;
	for(new td = 1; td < 11; td++)
	{
		if(PlayerInventory[playerid][slot][pItemQuantity] <= 0 && PlayerInventory[playerid][slot][pItemType] != ITEM_WEAP) PlayerInventory[playerid][slot][pItemID] = NO_ITEM;
		id = PlayerInventory[playerid][slot][pItemID];
		if(PlayerInventory[playerid][slot][pItemType] == ITEM_VEHKEY) format(PlayerInventory[playerid][slot][pItemName],32, "Chiave veicolo ID %d",PlayerInventory[playerid][slot][pKeyID]);
		if(id == NO_ITEM) strcpy(PlayerInventory[playerid][slot][pItemName], "Vuoto" ,32);
		format(string,sizeof(string), "%d:_%s_(%d)",slot,PlayerInventory[playerid][slot][pItemName],PlayerInventory[playerid][slot][pItemQuantity]);
		PlayerTextDrawSetString(playerid, InvTD[playerid][td], string);
		++slot;
	}
	return 1;
}

CreateItem(name[],maxquantity,type)
{
	if(createdItems >= MAX_ITEMS) return print("Non posso creare altri Items! Limite raggiunto.");
	strcpy(ServerItems[createdItems][sItemName],name,32);
	ServerItems[createdItems][sMaxQuantity] = maxquantity;
	ServerItems[createdItems][sItemType] = type;
	printf("Creato l'Item: %s (%d) quantita' massima: %d Tipo: %d",ServerItems[createdItems][sItemName],createdItems, ServerItems[createdItems][sMaxQuantity],type);
	++createdItems;
	return 1;
}