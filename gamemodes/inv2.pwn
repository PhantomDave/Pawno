

#include <a_samp>
#include <a_mysql>
#include <sscanf2>
#include <SmartCMD>

#define DBHOST "87.98.243.201"
#define DBUSER "samp6244"
#define DBNAME "samp6244_zero"
#define DBPASS "JP,nmBJA~m){m7VS"

#define COLOR_RED 0xFFC00000
#define COLOR_GREEN 0xFF92D050

new MySQL:db;

new PlayerText:Inv[MAX_PLAYERS][10];
new PlayerText:FixInv[MAX_PLAYERS][3];

enum // NON RIMUOVERE OGGETTI GIA' INSERITI
{
    ITEM_EMPTY,
    ITEM_BLINDFOLD,
    ITEM_FISHROD,
    ITEM_CIGARETTE,
    ITEM_FUELCAN,
    ITEM_RADIO, 
    
    ITEM_WEAP_NOAMMO = 47,
    ITEM_WEAP_NOAMMO_END = 59,
    
    ITEM_AMMO_RIFLE,
    ITEM_AMMO_PISTOL,
    ITEM_AMMO_SHOTGUN,
    ITEM_AMMO_SNIPER,

    ITEM_BAG_EMPTY = 100
};

#define MAX_ITEMS 2000

enum E_INV_OBJ
{
    Name[32],
    SingleUse,
    MaxStack,
    ModelID,
    Float:iOffZ,
    Float:iRotX,
    Float:iRotY,
    Float:iRotZ
};

new InventoryInfo[MAX_ITEMS][E_INV_OBJ];

#define MAX_ITEM_SLOT 10
#define MAX_BAG_ITEMS 20
#define MAX_BAGS 300

enum E_PLAYER_ITEMS
{
    Item,
    Amount
};


enum E_BAG_ITEMS
{
    bID,
    Item,
    Amount
};

new PlayerInventory[MAX_PLAYERS][MAX_ITEM_SLOT][E_PLAYER_ITEMS],
    BagInventory[MAX_BAGS][MAX_BAG_ITEMS][E_BAG_ITEMS];

new createdBags;

enum pInfo
{
    pID
};

new PlayerInfo[MAX_PLAYERS][pInfo];

main()
{
	print("\n----------------------------------");
	print(" Blank Gamemode by your name here");
	print("----------------------------------\n");
}


public OnGameModeInit()
{
	// Don't use these lines if it's a filterscript
	db = mysql_connect(DBHOST, DBUSER, DBPASS, DBNAME);
	SetGameModeText("Inventory");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	CreateInventoryItems();
    mysql_tquery(db, "SELECT * FROM bagsinv","LoadBags");
	return 1;
}

CreateInventoryItems()
{
    SetupInventoryItem(ITEM_EMPTY, "Vuoto");
    new wep, single, wepname[32];
    for(new i = 1; i < 46; i++)
    {
        wep = GetWeaponModel(i);
        if(wep)
        {
            GetWeaponName(i, wepname, sizeof(wepname));
            if(16 <= i <= 18) single = 0;
                else single = 1;
            SetupInventoryItem(i, wepname, wep, single, _, -1.0, 93.7, 120.0, 60.0);
          
            if(22 <= i <= 34)
            {
                format(wepname, sizeof(wepname), "%s (Scarico)",wepname);
                SetupInventoryItem(i - 22 + ITEM_WEAP_NOAMMO, wepname, wep, 1, _, -1.0, 93.7, 120.0, 60.0);
            }
        }      
    }
    
    SetupInventoryItem(ITEM_AMMO_PISTOL, "Munizioni pistola", 2038, _, 250, -0.9488983, -90, 0.00000, 90.00000);
    SetupInventoryItem(ITEM_AMMO_RIFLE, "Munizioni fucile", 2037, _, 250, -0.9488983, -90, 0.00000, 90.00000);
    SetupInventoryItem(ITEM_AMMO_SHOTGUN, "Munizioni Shotgun", 2038, _, 250, -0.9488983, -90, 0.00000, 90.00000);
    SetupInventoryItem(ITEM_AMMO_SNIPER, "Munizioni pesanti", 2039, _, 250, -0.9488983, -90, 0.00000, 90.00000);  
    for(new i = 64; i < MAX_BAGS; i++)
    {
        SetupInventoryItem(i, "Borsone", 2919, 1, 1, _, _, _, _);  
    }
}

SetupInventoryItem(id, name[], modelid = 1271, single = 0, max = 999, Float:OffZ = -0.6589966, Float:RotX = 0.0, Float:RotY = 0.0, Float:RotZ = 0.0)
{
    format(InventoryInfo[id][Name], 32 , "%s", name);
    InventoryInfo[id][SingleUse] = single;
    InventoryInfo[id][MaxStack] = max;
    InventoryInfo[id][ModelID] = modelid;
    InventoryInfo[id][iOffZ] = OffZ;
    InventoryInfo[id][iRotX] = RotX;
    InventoryInfo[id][iRotY] = RotY;
    InventoryInfo[id][iRotZ] = RotZ;
    printf("Name: %s, ID: %d",InventoryInfo[id][Name],id);
}

public OnGameModeExit()
{
	return 1;
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
    new tmp[E_PLAYER_ITEMS];
    for(new i = 0; i < MAX_ITEM_SLOT; i++)
    {
        PlayerInventory[playerid][i] = tmp;
    }
    CreatePlayerInventoryTD(playerid);
    
    PlayerInfo[playerid][pID] = 18; // NON TI SERVE
    
    // Questa mettila al login del PG dopo che hai caricato il pID Dal DB
    new query[64];
    mysql_format(db, query, sizeof(query), "SELECT * FROM playerinv WHERE pID = '%d'", PlayerInfo[playerid][pID]);
    mysql_tquery(db, query, "LoadPlayerInventory", "i", playerid);
    //
    UpdateInventoryTD(playerid);
    for(new i = 0; i < 10; i++)
    {
        if(i < 3) PlayerTextDrawShow(playerid, FixInv[playerid][i]);
        PlayerTextDrawShow(playerid, Inv[playerid][i]);
    }
    //CreatePlayerInventory(playerid);
	return 1;
}

CMD:i(cmdid, playerid, params[])
{
    new action[20], slotid, amount;
    if(sscanf(params, "s[16]I(0)I(1)",action, slotid, amount)) return SendClientMessage(playerid, COLOR_RED, "[ERRORE:] Usa /(i)nventario <azione> <slotid> <quantita'>");
    if(amount == 0) return SendClientMessage(playerid, COLOR_RED, "[ERRORE:] Devi specificare una quantita' superiore a 0!");
    
    if(!strcmp(action, "aiuto", true))
    {
        ShowPlayerDialog(playerid, 9096, DIALOG_STYLE_MSGBOX, "Aiuto sul sistema inventario", "Puoi usare i seguenti comandi riguardanti il sistema inventario\n\n \
                                                               (I)nventario <azione> <slotid> <quantita' (Default: 1)>\n\n \
                                                               Azioni disponibili:\n \
                                                               Aiuto: Mostra questo dialog\n \
                                                               Usa: Usa l'oggetto in questione\n \
                                                               Nascondi: Nasconde la Textdraw dell'inventario\n \
                                                               Mostra: Mostra la Textdraw dell'inventario\n \
                                                               (R)iponi: Ripone l'oggetto nell'inventario, se non specifichi uno slot verra' riposto nel primo disponibile.\n \
                                                               (S)carica: Scarica le munizioni dell'arma attualmente in mano e le ripone nell'inventario\n \
                                                               (G)etta: Getta a terra un oggetto.\n\n \
                                                               NOTA: Alcuni oggetti non possono essere utilizzati se non prima equipaggiati.\n \
                                                               NOTA: Per dare un oggetto a un altro giocatore, usa /dai.\n \
                                                               NOTA: I Borsoni devono essere equipaggiati per riporre oggetti al loro interno.\n \
                                                               NOTA: Le lettere tra parentesi indicano che il comando puo' essere accorciato in modo da facilitarne l'uso.", "Ho capito", "");
    }
    else if(!strcmp(action, "nascondi", true))
    {
        for(new i = 0; i < 10; i++)
        {
            if(i < 3) PlayerTextDrawHide(playerid, FixInv[playerid][i]);
            PlayerTextDrawHide(playerid, Inv[playerid][i]);
        }
    }
    else if(!strcmp(action, "mostra", true))
    {
        for(new i = 0; i < 10; i++)
        {
            if(i < 3) PlayerTextDrawShow(playerid, FixInv[playerid][i]);
            PlayerTextDrawShow(playerid, Inv[playerid][i]);       
        }
    }
    else if(!strcmp(action, "usa", true)|| !strcmp(action, "u", true))
    {
        OnPlayerUseItem(playerid, slotid, amount);
    }
    else if(!strcmp(action, "riponi", true) || !strcmp(action, "r", true))
    {
        new 
            wep = GetPlayerWeapon(playerid),
            ammo = GetPlayerAmmo(playerid),
            string[156];
       
        GivePlayerItem(playerid, wep, ammo, slotid);
        format(string,sizeof(string), "Hai riposto la tua %s (Colpi: %d) nel tuo inventario",InventoryInfo[wep][Name],ammo);
        SendClientMessage(playerid, COLOR_GREEN, string);
        RemovePlayerWeapon(playerid, wep);      
    }
    else if(!strcmp(action, "scarica", true) || !strcmp(action, "s", true))
    {
        new wep = GetPlayerWeapon(playerid),
            itemid = wep - 22 + ITEM_WEAP_NOAMMO,
            quantity = GetPlayerAmmo(playerid),
            ammotype = GetAmmoType(itemid),
            string[156];
        
        GivePlayerItem(playerid, itemid);
        GivePlayerItem(playerid, ammotype, quantity);
        
        format(string, sizeof(string), "Hai scaricato la tua %s (Colpi: %d)", InventoryInfo[wep][Name], quantity);
        SendClientMessage(playerid, COLOR_GREEN, string);
        RemovePlayerWeapon(playerid, wep);
    }                
    return 1;
}

CMD:itemids(cmdid, playerid, params[]) // Fallo diventare un comando admin
{
    new string[2048];
    for(new i = 0; i < MAX_ITEMS; i++)
    {
        if(InventoryInfo[i][Name] == EOS) continue;
        format(string,sizeof(string), "%s\n[%d] %s",string, i, InventoryInfo[i][Name]);
    }
    ShowPlayerDialog(playerid, 9003, DIALOG_STYLE_LIST, "Item IDS", string, "Conferma", "Annulla");
    return 1;
} 

CMD:giveitem(cmdid, playerid, params[]) // Admin
{
    new otherid, item, amount;
    if(sscanf(params, "udd",otherid, item, amount)) return SendClientMessage(playerid, COLOR_RED, "[ERRORE:] USO: /giveitem <id> <itemid> <quantita'>");
    if(GetPlayerFreeInventorySlot(otherid, item) == -1) return SendClientMessage(playerid, COLOR_RED, "Il player non ha slot liberi!");
    GivePlayerItem(otherid, item, amount);
    //AdminChat %s ha dato a %s l'Item %s
    return 1;
}

UpdateInventoryTD(playerid)
{
    new string[64];
    for(new i = 0; i < 10; i++)
    {
        if(64 <= PlayerInventory[playerid][i][Item] <= 299)
        {
            format(string,sizeof(string), "%d)_%s_ID %d_(%d)",i, InventoryInfo[ PlayerInventory[playerid][i][Item] ][Name], PlayerInventory[playerid][i][Item], PlayerInventory[playerid][i][Amount]);
        }
        else format(string,sizeof(string), "%d)_%s_(%d)", i, InventoryInfo[ PlayerInventory[playerid][i][Item] ][Name], PlayerInventory[playerid][i][Amount]);
        PlayerTextDrawSetString(playerid, Inv[playerid][i], string);
    }
    return 1;
}

CreatePlayerInventory(playerid) // Inserisi la funzione alla creazione del personaggio
{
    new query[255];
    mysql_format(db, query, sizeof(query), "INSERT INTO playerinv (pID, Object, Amount) VALUES('%d', '0,0', '0,0')",PlayerInfo[playerid][pID]);
    mysql_tquery(db, query);
}

forward LoadPlayerInventory(playerid);
public LoadPlayerInventory(playerid)
{
    new inv[MAX_ITEM_SLOT * 3], inv2[MAX_ITEM_SLOT * 3], invstring[150], invamount[200], tmp[16], tmp2[16];
    cache_get_value_index(0, 1, invstring, sizeof(invstring));
    cache_get_value_index(0, 2, invamount, sizeof(invamount));
    format(tmp,sizeof(tmp), "p<,>a<i>[%d]",  invstring);
    format(tmp2,sizeof(tmp2), "p<,>a<i>[%d]", invamount);
    sscanf(invstring, tmp, inv);
    sscanf(invamount, tmp2, inv2);
    for(new i = 0; i < MAX_ITEM_SLOT; i++)
    {
        PlayerInventory[playerid][i][Item] = inv[i];
        PlayerInventory[playerid][i][Amount] = inv2[i];
    }
    UpdateInventoryTD(playerid);
    return 1;
}

forward LoadBags();
public LoadBags()
{
    new row, i, bstring[200], bquantity[200], tmp1[16],tmp2[16], inv[MAX_BAG_ITEMS * 2], amount[MAX_BAG_ITEMS * 3];
    cache_get_row_count(row);
    while(i < row)
    {
       // cache_get_value_index_int(row, 0, BagInventory[createdBags][bID]);
        cache_get_value_index(row, 1, bstring, sizeof(bstring));
        cache_get_value_index(row, 1, bquantity, sizeof(bquantity)); 

        format(tmp1,sizeof(tmp1), "p<,>a<i>[%d]",  bstring);
        format(tmp2,sizeof(tmp2), "p<,>a<i>[%d]", bquantity);

        sscanf(bstring, tmp1, inv);
        sscanf(bquantity, tmp2, amount);

        for(new d = 0; d < MAX_BAG_ITEMS; d++)
        {
            BagInventory[createdBags][d][Item] = inv[d];
            BagInventory[createdBags][d][Amount] = amount[d];
        }
        createdBags++;
        printf("Loaded Bag ID: %d",i);
    }
    return 1;
}

CreateBag(playerid)
{
    GivePlayerItem(playerid, 64+createdBags, 1);
    
    return 1;
}

SavePlayerInventory(playerid)
{
    new query[300],  invstring[100], invamount[120];
    
    for(new i = 0; i < MAX_ITEM_SLOT; i++)
    {
        if(i == 0) 
        {
            format(invstring,sizeof(invstring), "%d",PlayerInventory[playerid][i][Item]);
            format(invamount, sizeof(invamount), "%d",PlayerInventory[playerid][i][Amount]); 
        }
        else    
        {    
            format(invstring,sizeof(invstring), "%s,%d",invstring, PlayerInventory[playerid][i][Item]);
            format(invamount, sizeof(invamount), "%s,%d",invamount, PlayerInventory[playerid][i][Amount]);
        }
    }
    
    mysql_format(db, query, sizeof(query), "UPDATE playerinv SET Object = '%s', Amount = '%s' WHERE pID = '%d'", invstring, invamount, PlayerInfo[playerid][pID]);
    mysql_tquery(db, query);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    SavePlayerInventory(playerid);
	return 1;
}

CreatePlayerInventoryTD(playerid)
{
    FixInv[playerid][0] = CreatePlayerTextDraw(playerid, 590.298217, 134.436477, "Inventario");
    PlayerTextDrawLetterSize(playerid, Inv[playerid][0], 0.359000, 1.620000);
    PlayerTextDrawTextSize(playerid, Inv[playerid][0], 0.009999, 97.000000);
    PlayerTextDrawAlignment(playerid, Inv[playerid][0], 2);
    PlayerTextDrawColor(playerid, Inv[playerid][0], -1);
    PlayerTextDrawUseBox(playerid, Inv[playerid][0], 1);
    PlayerTextDrawBoxColor(playerid, Inv[playerid][0], 112);
    PlayerTextDrawSetShadow(playerid, Inv[playerid][0], 0);
    PlayerTextDrawSetOutline(playerid, Inv[playerid][0], 1);
    PlayerTextDrawBackgroundColor(playerid, Inv[playerid][0], 255);
    PlayerTextDrawFont(playerid, Inv[playerid][0], 0);
    PlayerTextDrawSetProportional(playerid, Inv[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, Inv[playerid][0], 0);

    Inv[playerid][0] = CreatePlayerTextDraw(playerid, 541.765380, 157.882446, "1) DIO_PORCO_DIO (999)");
    PlayerTextDrawLetterSize(playerid, Inv[playerid][0], 0.179000, 0.997852);
    PlayerTextDrawTextSize(playerid, Inv[playerid][0], 641.000000, 0.009999);
    PlayerTextDrawAlignment(playerid, Inv[playerid][0], 1);
    PlayerTextDrawColor(playerid, Inv[playerid][0], -1);
    PlayerTextDrawUseBox(playerid, Inv[playerid][0], 1);
    PlayerTextDrawBoxColor(playerid, Inv[playerid][0], 112);
    PlayerTextDrawSetShadow(playerid, Inv[playerid][0], 0);
    PlayerTextDrawSetOutline(playerid, Inv[playerid][0], 1);
    PlayerTextDrawBackgroundColor(playerid, Inv[playerid][0], 255);
    PlayerTextDrawFont(playerid, Inv[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, Inv[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, Inv[playerid][0], 0);

    Inv[playerid][1] = CreatePlayerTextDraw(playerid, 541.765380, 170.283203, "2) DIO_PORCO_DIO (999)");
    PlayerTextDrawLetterSize(playerid, Inv[playerid][1], 0.179000, 0.997852);
    PlayerTextDrawTextSize(playerid, Inv[playerid][1], 641.000000, 0.009999);
    PlayerTextDrawAlignment(playerid, Inv[playerid][1], 1);
    PlayerTextDrawColor(playerid, Inv[playerid][1], -1);
    PlayerTextDrawUseBox(playerid, Inv[playerid][1], 1);
    PlayerTextDrawBoxColor(playerid, Inv[playerid][1], 112);
    PlayerTextDrawSetShadow(playerid, Inv[playerid][1], 0);
    PlayerTextDrawSetOutline(playerid, Inv[playerid][1], 1);
    PlayerTextDrawBackgroundColor(playerid, Inv[playerid][1], 255);
    PlayerTextDrawFont(playerid, Inv[playerid][1], 1);
    PlayerTextDrawSetProportional(playerid, Inv[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, Inv[playerid][1], 0);

    Inv[playerid][2] = CreatePlayerTextDraw(playerid, 541.765380, 182.783966, "3) DIO_PORCO_DIO (999)");
    PlayerTextDrawLetterSize(playerid, Inv[playerid][2], 0.179000, 0.997852);
    PlayerTextDrawTextSize(playerid, Inv[playerid][2], 641.000000, 0.009999);
    PlayerTextDrawAlignment(playerid, Inv[playerid][2], 1);
    PlayerTextDrawColor(playerid, Inv[playerid][2], -1);
    PlayerTextDrawUseBox(playerid, Inv[playerid][2], 1);
    PlayerTextDrawBoxColor(playerid, Inv[playerid][2], 112);
    PlayerTextDrawSetShadow(playerid, Inv[playerid][2], 0);
    PlayerTextDrawSetOutline(playerid, Inv[playerid][2], 1);
    PlayerTextDrawBackgroundColor(playerid, Inv[playerid][2], 255);
    PlayerTextDrawFont(playerid, Inv[playerid][2], 1);
    PlayerTextDrawSetProportional(playerid, Inv[playerid][2], 1);
    PlayerTextDrawSetShadow(playerid, Inv[playerid][2], 0);

    Inv[playerid][3] = CreatePlayerTextDraw(playerid, 541.765380, 194.984710, "4) DIO_PORCO_DIO (999)");
    PlayerTextDrawLetterSize(playerid, Inv[playerid][3], 0.179000, 0.997852);
    PlayerTextDrawTextSize(playerid, Inv[playerid][3], 641.000000, 0.009999);
    PlayerTextDrawAlignment(playerid, Inv[playerid][3], 1);
    PlayerTextDrawColor(playerid, Inv[playerid][3], -1);
    PlayerTextDrawUseBox(playerid, Inv[playerid][3], 1);
    PlayerTextDrawBoxColor(playerid, Inv[playerid][3], 112);
    PlayerTextDrawSetShadow(playerid, Inv[playerid][3], 0);
    PlayerTextDrawSetOutline(playerid, Inv[playerid][3], 1);
    PlayerTextDrawBackgroundColor(playerid, Inv[playerid][3], 255);
    PlayerTextDrawFont(playerid, Inv[playerid][3], 1);
    PlayerTextDrawSetProportional(playerid, Inv[playerid][3], 1);
    PlayerTextDrawSetShadow(playerid, Inv[playerid][3], 0);

    Inv[playerid][4] = CreatePlayerTextDraw(playerid, 541.765380, 207.185455, "5) DIO_PORCO_DIO (999)");
    PlayerTextDrawLetterSize(playerid, Inv[playerid][4], 0.179000, 0.997852);
    PlayerTextDrawTextSize(playerid, Inv[playerid][4], 641.000000, 0.009999);
    PlayerTextDrawAlignment(playerid, Inv[playerid][4], 1);
    PlayerTextDrawColor(playerid, Inv[playerid][4], -1);
    PlayerTextDrawUseBox(playerid, Inv[playerid][4], 1);
    PlayerTextDrawBoxColor(playerid, Inv[playerid][4], 112);
    PlayerTextDrawSetShadow(playerid, Inv[playerid][4], 0);
    PlayerTextDrawSetOutline(playerid, Inv[playerid][4], 1);
    PlayerTextDrawBackgroundColor(playerid, Inv[playerid][4], 255);
    PlayerTextDrawFont(playerid, Inv[playerid][4], 1);
    PlayerTextDrawSetProportional(playerid, Inv[playerid][4], 1);
    PlayerTextDrawSetShadow(playerid, Inv[playerid][4], 0);

    Inv[playerid][5] = CreatePlayerTextDraw(playerid, 541.765380, 219.786224, "6) DIO_PORCO_DIO (999)");
    PlayerTextDrawLetterSize(playerid, Inv[playerid][5], 0.179000, 0.997852);
    PlayerTextDrawTextSize(playerid, Inv[playerid][5], 641.000000, 0.009999);
    PlayerTextDrawAlignment(playerid, Inv[playerid][5], 1);
    PlayerTextDrawColor(playerid, Inv[playerid][5], -1);
    PlayerTextDrawUseBox(playerid, Inv[playerid][5], 1);
    PlayerTextDrawBoxColor(playerid, Inv[playerid][5], 112);
    PlayerTextDrawSetShadow(playerid, Inv[playerid][5], 0);
    PlayerTextDrawSetOutline(playerid, Inv[playerid][5], 1);
    PlayerTextDrawBackgroundColor(playerid, Inv[playerid][5], 255);
    PlayerTextDrawFont(playerid, Inv[playerid][5], 1);
    PlayerTextDrawSetProportional(playerid, Inv[playerid][5], 1);
    PlayerTextDrawSetShadow(playerid, Inv[playerid][5], 0);

    Inv[playerid][6] = CreatePlayerTextDraw(playerid, 541.765380, 231.986968, "7) DIO_PORCO_DIO (999)");
    PlayerTextDrawLetterSize(playerid, Inv[playerid][6], 0.179000, 0.997852);
    PlayerTextDrawTextSize(playerid, Inv[playerid][6], 641.000000, 0.009999);
    PlayerTextDrawAlignment(playerid, Inv[playerid][6], 1);
    PlayerTextDrawColor(playerid, Inv[playerid][6], -1);
    PlayerTextDrawUseBox(playerid, Inv[playerid][6], 1);
    PlayerTextDrawBoxColor(playerid, Inv[playerid][6], 112);
    PlayerTextDrawSetShadow(playerid, Inv[playerid][6], 0);
    PlayerTextDrawSetOutline(playerid, Inv[playerid][6], 1);
    PlayerTextDrawBackgroundColor(playerid, Inv[playerid][6], 255);
    PlayerTextDrawFont(playerid, Inv[playerid][6], 1);
    PlayerTextDrawSetProportional(playerid, Inv[playerid][6], 1);
    PlayerTextDrawSetShadow(playerid, Inv[playerid][6], 0);

    Inv[playerid][7] = CreatePlayerTextDraw(playerid, 541.765380, 244.187713, "8) DIO_PORCO_DIO (999)");
    PlayerTextDrawLetterSize(playerid, Inv[playerid][7], 0.179000, 0.997852);
    PlayerTextDrawTextSize(playerid, Inv[playerid][7], 641.000000, 0.009999);
    PlayerTextDrawAlignment(playerid, Inv[playerid][7], 1);
    PlayerTextDrawColor(playerid, Inv[playerid][7], -1);
    PlayerTextDrawUseBox(playerid, Inv[playerid][7], 1);
    PlayerTextDrawBoxColor(playerid, Inv[playerid][7], 112);
    PlayerTextDrawSetShadow(playerid, Inv[playerid][7], 0);
    PlayerTextDrawSetOutline(playerid, Inv[playerid][7], 1);
    PlayerTextDrawBackgroundColor(playerid, Inv[playerid][7], 255);
    PlayerTextDrawFont(playerid, Inv[playerid][7], 1);
    PlayerTextDrawSetProportional(playerid, Inv[playerid][7], 1);
    PlayerTextDrawSetShadow(playerid, Inv[playerid][7], 0);

    Inv[playerid][8] = CreatePlayerTextDraw(playerid, 541.765380, 256.588470, "9) DIO_PORCO_DIO (999)");
    PlayerTextDrawLetterSize(playerid, Inv[playerid][8], 0.179000, 0.997852);
    PlayerTextDrawTextSize(playerid, Inv[playerid][8], 641.000000, 0.009999);
    PlayerTextDrawAlignment(playerid, Inv[playerid][8], 1);
    PlayerTextDrawColor(playerid, Inv[playerid][8], -1);
    PlayerTextDrawUseBox(playerid, Inv[playerid][8], 1);
    PlayerTextDrawBoxColor(playerid, Inv[playerid][8], 112);
    PlayerTextDrawSetShadow(playerid, Inv[playerid][8], 0);
    PlayerTextDrawSetOutline(playerid, Inv[playerid][8], 1);
    PlayerTextDrawBackgroundColor(playerid, Inv[playerid][8], 255);
    PlayerTextDrawFont(playerid, Inv[playerid][8], 1);
    PlayerTextDrawSetProportional(playerid, Inv[playerid][8], 1);
    PlayerTextDrawSetShadow(playerid, Inv[playerid][8], 0);

    Inv[playerid][9] = CreatePlayerTextDraw(playerid, 541.765380, 269.189239, "9) DIO_PORCO_DIO (999)");
    PlayerTextDrawLetterSize(playerid, Inv[playerid][9], 0.179000, 0.867852);
    PlayerTextDrawTextSize(playerid, Inv[playerid][9], 848.000000, 0.009999);
    PlayerTextDrawAlignment(playerid, Inv[playerid][9], 1);
    PlayerTextDrawColor(playerid, Inv[playerid][9], -1);
    PlayerTextDrawUseBox(playerid, Inv[playerid][9], 1);
    PlayerTextDrawBoxColor(playerid, Inv[playerid][9], 112);
    PlayerTextDrawSetShadow(playerid, Inv[playerid][9], 0);
    PlayerTextDrawSetOutline(playerid, Inv[playerid][9], 1);
    PlayerTextDrawBackgroundColor(playerid, Inv[playerid][9], 255);
    PlayerTextDrawFont(playerid, Inv[playerid][9], 1);
    PlayerTextDrawSetProportional(playerid, Inv[playerid][9], 1);
    PlayerTextDrawSetShadow(playerid, Inv[playerid][9], 0);

    FixInv[playerid][1] = CreatePlayerTextDraw(playerid, 590.298156, 152.437667, "_");
    PlayerTextDrawLetterSize(playerid, FixInv[playerid][1], 0.358333, 0.228297);
    PlayerTextDrawTextSize(playerid, FixInv[playerid][1], 0.009999, 97.000000);
    PlayerTextDrawAlignment(playerid, FixInv[playerid][1], 2);
    PlayerTextDrawColor(playerid, FixInv[playerid][1], -1);
    PlayerTextDrawUseBox(playerid, FixInv[playerid][1], 1);
    PlayerTextDrawBoxColor(playerid, FixInv[playerid][1], 112);
    PlayerTextDrawSetShadow(playerid, FixInv[playerid][1], 0);
    PlayerTextDrawSetOutline(playerid, FixInv[playerid][1], 1);
    PlayerTextDrawBackgroundColor(playerid, FixInv[playerid][1], 255);
    PlayerTextDrawFont(playerid, FixInv[playerid][1], 0);
    PlayerTextDrawSetProportional(playerid, FixInv[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, FixInv[playerid][1], 0);

    FixInv[playerid][2] = CreatePlayerTextDraw(playerid, 590.265441, 280.154064, "_");
    PlayerTextDrawLetterSize(playerid, FixInv[playerid][2], 0.358333, 0.228297);
    PlayerTextDrawTextSize(playerid, FixInv[playerid][2], 0.009999, 97.000000);
    PlayerTextDrawAlignment(playerid, FixInv[playerid][2], 2);
    PlayerTextDrawColor(playerid, FixInv[playerid][2], -1);
    PlayerTextDrawUseBox(playerid, FixInv[playerid][2], 1);
    PlayerTextDrawBoxColor(playerid, FixInv[playerid][2], 112);
    PlayerTextDrawSetShadow(playerid, FixInv[playerid][2], 0);
    PlayerTextDrawSetOutline(playerid, FixInv[playerid][2], 1);
    PlayerTextDrawBackgroundColor(playerid, FixInv[playerid][2], 255);
    PlayerTextDrawFont(playerid, FixInv[playerid][2], 0);
    PlayerTextDrawSetProportional(playerid, FixInv[playerid][2], 1);
    PlayerTextDrawSetShadow(playerid, FixInv[playerid][2], 0);
    return 1; 
}

stock GetWeaponModel(weaponid)
{
	switch(weaponid)
	{
	    case 1:
	        return 331;

		case 2..8:
		    return weaponid+331;

        case 9:
		    return 341;

		case 10..15:
			return weaponid+311;

		case 16..18:
		    return weaponid+326;

		case 22..29:
		    return weaponid+324;

		case 30,31:
		    return weaponid+325;

		case 32:
		    return 372;

		case 33..45:
		    return weaponid+324;

		case 46:
		    return 371;
	}
	return 0;
}

GetAmmoType(object)
{
    switch(object)
    {
        case 22..24, 28, 29, 32, 47..49, 53, 54, 57: return ITEM_AMMO_PISTOL;
        case 25..27, 50..52: return ITEM_AMMO_SHOTGUN;
        case 30,31,33,55,56,58: return ITEM_AMMO_RIFLE;
        case 34, 59: return ITEM_AMMO_SNIPER;
    }
    return 0;
}

IsItemInPlayerInventory(playerid, item)
{
    for(new i = 0; i < MAX_ITEM_SLOT; i++)
    {
        if(PlayerInventory[playerid][i][Item] == item) return i;
    }
    return -1;
}
        
GivePlayerItem(playerid, itemid, amount = 1, slot = -1)
{
    if(slot == -1) slot = GetPlayerFreeInventorySlot(playerid, itemid);
    PlayerInventory[playerid][slot][Item] = itemid;
    PlayerInventory[playerid][slot][Amount] += amount;
    UpdateInventoryTD(playerid);
    return 1;
}


GetPlayerFreeInventorySlot(playerid, itemid)
{
    for(new i = 0; i < MAX_ITEM_SLOT; i++)
    {
        if(PlayerInventory[playerid][i][Item] == itemid && InventoryInfo[PlayerInventory[playerid][i][Item]][SingleUse] == 0) return i;
        else if(PlayerInventory[playerid][i][Item] == ITEM_EMPTY) return i;
    }
    return -1;
}


OnPlayerItemUpdate(playerid, object, slot, amount = 1)
{
    switch(object)
    {
        case 1..46:
        {
            new string[100];
            GivePlayerWeapon(playerid, object, PlayerInventory[playerid][slot][Amount]);
            format(string,sizeof(string), "Hai ritirato dal tuo inventario %s con %d colpi",InventoryInfo[object][Name],PlayerInventory[playerid][slot][Amount]);
            SendClientMessage(playerid, COLOR_RED, string);
        }
        case ITEM_WEAP_NOAMMO..ITEM_WEAP_NOAMMO_END:
        {
            new wep = object - ITEM_WEAP_NOAMMO + 22,
            ammotype = GetAmmoType(wep),
            ammoslot = IsItemInPlayerInventory(playerid, ammotype);
            new string[150];
            if(ammoslot == -1)
            {

                format(string,sizeof(string), "Devi avere le %s per poter usare quest'arma", InventoryInfo[ammotype][Name]);
                SendClientMessage(playerid, COLOR_RED, string);
                return 1;
            }
            else
            {
                if(PlayerInventory[playerid][ammoslot][Amount] < amount) SendClientMessage(playerid, COLOR_RED, "Non hai abbastanza munizioni!");
                format(string,sizeof(string), "Hai caricato nella tua %s %d %s",InventoryInfo[wep][Name], amount, InventoryInfo[ammotype][Name]);
                SendClientMessage(playerid, COLOR_GREEN, string);
                GivePlayerItem(playerid, wep, amount);
                GivePlayerItem(playerid, ammotype, -amount);
                return 1;
            }
        }
        default: return 1;
    }
    return 1;
}

RemovePlayerItem(playerid, slotid)
{
    PlayerInventory[playerid][slotid][Item] = ITEM_EMPTY;
    PlayerInventory[playerid][slotid][Amount] = 0;

    UpdateInventoryTD(playerid);
    return 1;    
}

OnPlayerUseItem(playerid, slot, amount = 1)
{
    if(amount == 0) return;
    new object = PlayerInventory[playerid][slot][Item];
    OnPlayerItemUpdate(playerid, object, slot, amount);
    if(InventoryInfo[object][SingleUse])
    {
        PlayerInventory[playerid][slot][Item] = ITEM_EMPTY;
        PlayerInventory[playerid][slot][Amount] = 0;
    }
    else
    {
        PlayerInventory[playerid][slot][Amount] -= amount;
        if(PlayerInventory[playerid][slot][Amount] <= 0)
        {
            PlayerInventory[playerid][slot][Item] = ITEM_EMPTY;
            PlayerInventory[playerid][slot][Amount] = 0;   
        }
    }
    UpdateInventoryTD(playerid);
}       

RemovePlayerWeapon(playerid, weaponid) //Credits to Xalphox
{
    if(!IsPlayerConnected(playerid) || weaponid < 0 || weaponid > 50)
        return;
    new saveweapon[13], saveammo[13];
    for(new slot = 0; slot < 13; slot++)
        GetPlayerWeaponData(playerid, slot, saveweapon[slot], saveammo[slot]);
    ResetPlayerWeapons(playerid);
    for(new slot; slot < 13; slot++)
    {
        if(saveweapon[slot] == weaponid || saveammo[slot] == 0)
            continue;
        GivePlayerWeapon(playerid, saveweapon[slot], saveammo[slot]);
    }

}