#include <a_samp>
#include <sscanf2>
#include <smartcmd>
#include <easydialog>
#define MAX_ITEMS 500

#define EMB_WHITE "{FFFFFF}"
#define EMB_GREEN "{008000}"
#define EMB_RED "{00FFFF}"
#define NO_ITEM 999

new createdItems;

#define MAX_INVENTORY_SLOTS 32

#define ITEM_NOUSE 0

#define ACMD 1

#define strcpy(%0,%1,%2) \
    strcat((%0[0] = '\0', %0), %1, %2)

new PlayerText:InvTD[MAX_PLAYERS][11];

enum I_PLAYER_INV
{
	pItemID,
	pItemName[32],
	pItemQuantity,
	pItemType
};

new PlayerInventory[MAX_PLAYERS][MAX_INVENTORY_SLOTS][I_PLAYER_INV];

enum I_SERVER_ITEMS
{
	sItemID,
	sItemName[32],
	sMaxQuantity
}

new ServerItems[MAX_ITEMS][I_SERVER_ITEMS];

public OnGameModeInit()
{
	print("\n--------------------------------------");
	print(" Fatman Inventory System");
	print("--------------------------------------\n");
	CreateItem("Santino",50);
	CreateItem("Crocifissi",666);
	return 1;
}

public OnGameModeExit()
{
	return 1;
}



main()
{
	print("\n----------------------------------");
	print(" Blank Gamemode by your name here");
	print("----------------------------------\n");
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}

public OnPlayerConnect(playerid)
{
	InvTDCreate(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
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
CMD<ACMD>:giveitem(cmdid, playerid, params[])
{
	new otherid,itemid,quantity;
	if(sscanf(params,"ud",otherid,itemid,quantity)) return SendClientMessage(playerid, -1, "[ERRORE:] USO: /giveitem <playerid> <itemid> <quantity>");
	new slot = GetPlayerFreeInventorySlot(playerid, itemid);
	PlayerInventory[otherid][slot][pItemID] = itemid;
	PlayerInventory[otherid][slot][pItemQuantity] = quantity;
	strcpy(ServerItems[itemid][sItemName],PlayerInventory[otherid][slot][pItemName],32);
	InvTDUpdate(playerid);
	return 1;
}

CMD:inventory(cmdid, playerid, params[])
{
	new action[16],slotid = -1,quantity;
	if(sscanf(params, "s[16]D(-1)D(-1)",action,slotid,quantity)) return SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" USO: /i <action> <slotid> <quantity>");
	if(!strcmp(action, "usa"))
	{
		if(slotid == -1) return 1;
		if(PlayerInventory[playerid][slotid][pItemType] == ITEM_NOUSE)
		{
			SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" Nessuno uso per questo item");
			return 1;
		}
	}
	else if(!strcmp(action, "getta"))
	{
		if(quantity == 0) return SendClientMessage(playerid, -1, ""EMB_RED"[ERRORE:]"EMB_WHITE" USO: /i getta <quantita'>");
		//DropItem(slot,quantity);
		return 1;
	}
	else if(!strcmp(action, "mostra"))
	{
		TextDrawShowForPlayer(playerid, Text:InvTD[playerid][0]);
		TextDrawShowForPlayer(playerid, Text:InvTD[playerid][1]);
		TextDrawShowForPlayer(playerid, Text:InvTD[playerid][2]);
		TextDrawShowForPlayer(playerid, Text:InvTD[playerid][3]);
		TextDrawShowForPlayer(playerid, Text:InvTD[playerid][4]);
		TextDrawShowForPlayer(playerid, Text:InvTD[playerid][5]);
		TextDrawShowForPlayer(playerid, Text:InvTD[playerid][6]);
		TextDrawShowForPlayer(playerid, Text:InvTD[playerid][7]);
		TextDrawShowForPlayer(playerid, Text:InvTD[playerid][8]);
		TextDrawShowForPlayer(playerid, Text:InvTD[playerid][9]);
		TextDrawShowForPlayer(playerid, Text:InvTD[playerid][10]);
		return 1;
	}
	else if(!strcmp(action, "nascondi"))
	{
		return 1;
	}
	else SendClientMessage(playerid, -1, ""EMB_GREEN"[INFO:]"EMB_WHITE" Puoi usare getta, usa, equipaggia, mostra e nascondi");
	return 1;
}

ALT:i = CMD:inventory;

stock GetPlayerFreeInventorySlot(playerid, itemid)
{
	for(new s = 0; s < MAX_INVENTORY_SLOTS; s++)
	{
		if(PlayerInventory[playerid][s][pItemID] == itemid) return s;
		else if(PlayerInventory[playerid][s][pItemID] == NO_ITEM) return s;
		else return 0;
	}
	return 0;
}

stock InvTDCreate(playerid)
{
	InvTD[playerid][0] = CreatePlayerTextDraw(playerid, 581.000305, 135.659225, "Inventario");
	PlayerTextDrawLetterSize(playerid, InvTD[playerid][0], 0.368665, 1.039999);
	PlayerTextDrawTextSize(playerid, InvTD[playerid][0], 640.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, InvTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, InvTD[playerid][0], -1);
	PlayerTextDrawUseBox(playerid, InvTD[playerid][0], 1);
	PlayerTextDrawBoxColor(playerid, InvTD[playerid][0], 130);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, InvTD[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, InvTD[playerid][0], 5898495);
	PlayerTextDrawFont(playerid, InvTD[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, InvTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][0], 0);

	InvTD[playerid][1] = CreatePlayerTextDraw(playerid, 580.871032, 148.403656, "99:_Itemname_(99)");
	PlayerTextDrawLetterSize(playerid, InvTD[playerid][1], 0.180665, 0.762072);
	PlayerTextDrawTextSize(playerid, InvTD[playerid][1], 640.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, InvTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, InvTD[playerid][1], -1);
	PlayerTextDrawUseBox(playerid, InvTD[playerid][1], 1);
	PlayerTextDrawBoxColor(playerid, InvTD[playerid][1], 130);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, InvTD[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, InvTD[playerid][1], 5898495);
	PlayerTextDrawFont(playerid, InvTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, InvTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][1], 0);

	InvTD[playerid][2] = CreatePlayerTextDraw(playerid, 580.871032, 158.504272, "99:_Itemname_(99)");
	PlayerTextDrawLetterSize(playerid, InvTD[playerid][2], 0.180665, 0.762072);
	PlayerTextDrawTextSize(playerid, InvTD[playerid][2], 640.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, InvTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, InvTD[playerid][2], -1);
	PlayerTextDrawUseBox(playerid, InvTD[playerid][2], 1);
	PlayerTextDrawBoxColor(playerid, InvTD[playerid][2], 130);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, InvTD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, InvTD[playerid][2], 5898495);
	PlayerTextDrawFont(playerid, InvTD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, InvTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][2], 0);

	InvTD[playerid][3] = CreatePlayerTextDraw(playerid, 580.871032, 168.504882, "99:_Itemname_(99)");
	PlayerTextDrawLetterSize(playerid, InvTD[playerid][3], 0.180665, 0.762072);
	PlayerTextDrawTextSize(playerid, InvTD[playerid][3], 640.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, InvTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, InvTD[playerid][3], -1);
	PlayerTextDrawUseBox(playerid, InvTD[playerid][3], 1);
	PlayerTextDrawBoxColor(playerid, InvTD[playerid][3], 130);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, InvTD[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, InvTD[playerid][3], 5898495);
	PlayerTextDrawFont(playerid, InvTD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, InvTD[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][3], 0);

	InvTD[playerid][4] = CreatePlayerTextDraw(playerid, 580.871032, 178.405487, "99:_Itemname_(99)");
	PlayerTextDrawLetterSize(playerid, InvTD[playerid][4], 0.180665, 0.762072);
	PlayerTextDrawTextSize(playerid, InvTD[playerid][4], 640.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, InvTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, InvTD[playerid][4], -1);
	PlayerTextDrawUseBox(playerid, InvTD[playerid][4], 1);
	PlayerTextDrawBoxColor(playerid, InvTD[playerid][4], 130);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, InvTD[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, InvTD[playerid][4], 5898495);
	PlayerTextDrawFont(playerid, InvTD[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, InvTD[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][4], 0);

	InvTD[playerid][5] = CreatePlayerTextDraw(playerid, 580.871032, 188.406097, "99:_Itemname_(99)");
	PlayerTextDrawLetterSize(playerid, InvTD[playerid][5], 0.180665, 0.762072);
	PlayerTextDrawTextSize(playerid, InvTD[playerid][5], 640.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, InvTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, InvTD[playerid][5], -1);
	PlayerTextDrawUseBox(playerid, InvTD[playerid][5], 1);
	PlayerTextDrawBoxColor(playerid, InvTD[playerid][5], 130);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, InvTD[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, InvTD[playerid][5], 5898495);
	PlayerTextDrawFont(playerid, InvTD[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, InvTD[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][5], 0);

	InvTD[playerid][6] = CreatePlayerTextDraw(playerid, 580.704467, 198.621505, "99:_Itemname_(99)");
	PlayerTextDrawLetterSize(playerid, InvTD[playerid][6], 0.180665, 0.762072);
	PlayerTextDrawTextSize(playerid, InvTD[playerid][6], 639.400146, 0.000000);
	PlayerTextDrawAlignment(playerid, InvTD[playerid][6], 1);
	PlayerTextDrawColor(playerid, InvTD[playerid][6], -1);
	PlayerTextDrawUseBox(playerid, InvTD[playerid][6], 1);
	PlayerTextDrawBoxColor(playerid, InvTD[playerid][6], 130);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, InvTD[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, InvTD[playerid][6], 5898495);
	PlayerTextDrawFont(playerid, InvTD[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, InvTD[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][6], 0);

	InvTD[playerid][7] = CreatePlayerTextDraw(playerid, 580.704467, 208.722122, "99:_Itemname_(99)");
	PlayerTextDrawLetterSize(playerid, InvTD[playerid][7], 0.180665, 0.762072);
	PlayerTextDrawTextSize(playerid, InvTD[playerid][7], 639.400146, 0.000000);
	PlayerTextDrawAlignment(playerid, InvTD[playerid][7], 1);
	PlayerTextDrawColor(playerid, InvTD[playerid][7], -1);
	PlayerTextDrawUseBox(playerid, InvTD[playerid][7], 1);
	PlayerTextDrawBoxColor(playerid, InvTD[playerid][7], 130);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, InvTD[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, InvTD[playerid][7], 5898495);
	PlayerTextDrawFont(playerid, InvTD[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, InvTD[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][7], 0);

	InvTD[playerid][8] = CreatePlayerTextDraw(playerid, 580.704467, 218.622726, "99:_Itemname_(99)");
	PlayerTextDrawLetterSize(playerid, InvTD[playerid][8], 0.180665, 0.762072);
	PlayerTextDrawTextSize(playerid, InvTD[playerid][8], 639.400146, 0.000000);
	PlayerTextDrawAlignment(playerid, InvTD[playerid][8], 1);
	PlayerTextDrawColor(playerid, InvTD[playerid][8], -1);
	PlayerTextDrawUseBox(playerid, InvTD[playerid][8], 1);
	PlayerTextDrawBoxColor(playerid, InvTD[playerid][8], 130);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, InvTD[playerid][8], 0);
	PlayerTextDrawBackgroundColor(playerid, InvTD[playerid][8], 5898495);
	PlayerTextDrawFont(playerid, InvTD[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, InvTD[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][8], 0);

	InvTD[playerid][9] = CreatePlayerTextDraw(playerid, 580.704467, 228.623336, "99:_Itemname_(99)");
	PlayerTextDrawLetterSize(playerid, InvTD[playerid][9], 0.180665, 0.762072);
	PlayerTextDrawTextSize(playerid, InvTD[playerid][9], 639.400146, 0.000000);
	PlayerTextDrawAlignment(playerid, InvTD[playerid][9], 1);
	PlayerTextDrawColor(playerid, InvTD[playerid][9], -1);
	PlayerTextDrawUseBox(playerid, InvTD[playerid][9], 1);
	PlayerTextDrawBoxColor(playerid, InvTD[playerid][9], 130);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, InvTD[playerid][9], 0);
	PlayerTextDrawBackgroundColor(playerid, InvTD[playerid][9], 5898495);
	PlayerTextDrawFont(playerid, InvTD[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid, InvTD[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][9], 0);

	InvTD[playerid][10] = CreatePlayerTextDraw(playerid, 580.704467, 238.723953, "99:_Itemname_(99)");
	PlayerTextDrawLetterSize(playerid, InvTD[playerid][10], 0.180665, 0.762072);
	PlayerTextDrawTextSize(playerid, InvTD[playerid][10], 639.400146, 0.000000);
	PlayerTextDrawAlignment(playerid, InvTD[playerid][10], 1);
	PlayerTextDrawColor(playerid, InvTD[playerid][10], -1);
	PlayerTextDrawUseBox(playerid, InvTD[playerid][10], 1);
	PlayerTextDrawBoxColor(playerid, InvTD[playerid][10], 130);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, InvTD[playerid][10], 0);
	PlayerTextDrawBackgroundColor(playerid, InvTD[playerid][10], 5898495);
	PlayerTextDrawFont(playerid, InvTD[playerid][10], 1);
	PlayerTextDrawSetProportional(playerid, InvTD[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid, InvTD[playerid][10], 0);
	print("Create le TD");
	return 1;
}


public OnPlayerCommandReceived(cmdid, playerid, cmdtext[])
{
	if(GetCommandFlags(cmdid) == ACMD)
	{
		if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, -1, "[ERRORE:] Non sei autorizzato ad usare questo comando");
		return 0;
	}
	return 1;
}

stock InvTDUpdate(playerid)
{
	new string[64], slot = 0;
	for(new td = 0; td < 10; td++)
	{
		if(PlayerInventory[playerid][slot][pItemID] == NO_ITEM) strcpy(PlayerInventory[playerid][slot][pItemName], "Vuoto",32);
		format(string,sizeof(string), "%d: %s (%d)",td,PlayerInventory[playerid][slot][pItemName],PlayerInventory[playerid][slot][pItemQuantity]);
		PlayerTextDrawSetString(playerid, InvTD[playerid][td], string);
		print(string);
		++slot;
	}
	return 1;
}

stock CreateItem(name[],maxquantity)
{
	if(createdItems >= MAX_ITEMS) return print("Non posso creare altri Items! Limite raggiunto.");
	strcpy(ServerItems[createdItems][sItemName],name,32);
	ServerItems[createdItems][sMaxQuantity] = maxquantity;
	printf("Creato l'Item: %s (%d) quantita' massima: %d",ServerItems[createdItems][sItemName],createdItems, ServerItems[createdItems][sMaxQuantity]);
	++createdItems;
	return 1;
}
