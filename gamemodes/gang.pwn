/*-----------------------------------------------
	Allora, Hai da aggiungere i Comandi Admin ad /acmds
	di Enum ti serve solo GangZone.
	Deve essere fare in modo che la chat /f per i clan va in base al colore scelto dal CC.
	Per la Table del DB ti ho lasciato tutto in OnGameModeInit, guarda la.
	Se noti qualcosa che non va fammi sapere.
-------------------------------------------------*/


#include <a_samp>
#include <a_mysql>
#include <zcmd>
#include <colors>
#include <sscanf2>
#include <zones>
#include <foreach>
#include <streamer>

#define HOST "localhost"
#define PSW ""
#define USER "root"
#define DB "arp"

#define strcpy(%0,%1,%2) \
	strcat((%0[0] = '\0', %0), %1, %2)

#define DIALOG_LISTGANGZONE 31234
#define DIALOG_GANGZONEOPT 31235

enum GangWarInfo
{
	gwOn,
	gwTime,
	gwZone,
	gwType,
	gwClanStarter
}

new GangWar[GangWarInfo];

enum pInfo
{
	Clan,
	ClanLeader
};

new PlayerInfo[MAX_PLAYERS][pInfo];

enum ClanInfo
{
    Name[32],
    Mafia,
    Gang,
    GangColor,
    TogGW
};

new Clans[50][ClanInfo];

new InCreation[MAX_GANG_ZONES],
	createdgZone,
	Step,
	Iterator:GangZones<MAX_GANG_ZONES>;

enum gZone
{
	gID,
	gAreaID,
	Float:gMinX,
	Float:gMaxX,
	Float:gMinY,
	Float:gMaxY,
	ClanID
};

new GangZone[MAX_GANG_ZONES][gZone];

new MySQL;

main()
{
	print("\n----------------------------------");
	print(" Blank Gamemode by your name here");
	print("----------------------------------\n");
}


public OnGameModeInit()
{
	MySQL = mysql_connect(HOST, USER, DB, PSW);
	if(!mysql_errno()) print("[MySQL] Connection Succesful");
	else print("[MySQL] Connection Failed");
	/*mysql_tquery(MySQL,"CREATE TABLE IF NOT EXISTS `GangZones`(\
					`gID` int(5) NOT NULL AUTO_INCREMENT,\
					`MinX` float NOT NULL,\
					`MinY` float NOT NULL,\
					`MaxX` float NOT NULL,\
					`MaxY` float NOT NULL,\
					`ClanOwner` int(5) NOT NULL,\
					PRIMARY KEY (`gID`)) ENGINE MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1","",""); Riferimento su come creare la Table! */
 	SetGameModeText("Conquest Script");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	InCreation[createdgZone] = -1;
	mysql_tquery(MySQL, "SELECT * FROM GangZones", "LoadGangZones");
}

forward LoadGangZones();
public LoadGangZones()
{
	for(new i, count = cache_get_row_count(); i < count; i++)
	{
		GangZone[createdgZone][gID] = cache_get_row_int(i, 0);
		GangZone[createdgZone][gMinX] = cache_get_row_float(i, 1);
		GangZone[createdgZone][gMinY] = cache_get_row_float(i, 2);
		GangZone[createdgZone][gMaxX] = cache_get_row_float(i, 3);
		GangZone[createdgZone][gMaxY] = cache_get_row_float(i, 4);
		GangZone[createdgZone][ClanID] = cache_get_row_int(i, 5);
		printf("%d PD",createdgZone);
		createdgZone = GangZoneCreate(GangZone[createdgZone][gMinX], GangZone[createdgZone][gMinY], GangZone[createdgZone][gMaxX], GangZone[createdgZone][gMaxY]);
		GangZone[createdgZone][gAreaID] = CreateDynamicRectangle(GangZone[createdgZone][gMinX], GangZone[createdgZone][gMinY], GangZone[createdgZone][gMaxX], GangZone[createdgZone][gMaxY]);
		Iter_Add(GangZones, createdgZone);
		createdgZone++;
	}
}

SaveGangZone(gangID)
{
	new query[145];
	mysql_format(MySQL, query, sizeof(query), "UPDATE GangZones SET \
						MinX = '%f',\
						MinY = '%f',\
						MaxX = '%f',\
						MinX = '%f',\
						ClanOwner = '%d' \
						WHERE gID = '%d'", GangZone[gangID][gMinX],
						GangZone[gangID][gMinY],
						GangZone[gangID][gMaxX],
						GangZone[gangID][gMaxY],
						GangZone[gangID][ClanID],
						GangZone[gangID][gID]);
	mysql_tquery(MySQL, query);
	return 1;
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
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	RefreshGangZone(playerid);
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_LISTGANGZONE:
		{
			if(!response) return 1;
			SetPVarInt(playerid, "GangZoneID",listitem);
			ShowPlayerDialog(playerid, DIALOG_GANGZONEOPT, DIALOG_STYLE_LIST, "Opzioni per la gangzone", "Cancella Gangzone", "Conferma", "Annulla");
			return 1;
		}
		case DIALOG_GANGZONEOPT:
		{
			if(!response) return 1;
			switch(listitem)
			{
				case 0:
				{
					new id = GetPVarInt(playerid, "GangZoneID"), zone[MAX_ZONE_NAME],str[100];
					Get2DZoneName(GangZone[id][gMinX],GangZone[id][gMinY],zone,MAX_ZONE_NAME);
					format(str,sizeof(str), "Hai cancellato la GangZone a %s (ID: %d)",zone,id);
					SendClientMessage(playerid, COLOR_LIGHTYELLOW, str);
					DeleteGangZone(id);
					foreach(new i : Player) { RefreshGangZone(i); }
					return 1;
				}
			}
		}
	}
	return 1;
}

DeleteGangZone(gangid)
{
	new query[145];
	mysql_format(MySQL, query, sizeof(query), "DELETE FROM GangZones WHERE gID = '%d'",GangZone[gangid][gID]);
	mysql_tquery(MySQL, query);
	GangZone[gangid][gMinX] = 0.0;
	GangZone[gangid][gMinY] = 0.0;
	GangZone[gangid][gMaxX] = 0.0;
	GangZone[gangid][gMaxY] = 0.0;
	Iter_Remove(GangZones, gangid);
	DestroyDynamicArea(gangid);
	GangZoneHideForAll(gangid);
	return 1;
}

CMD:creategangzone(playerid, params[])
{
	if(!IsPlayerAdmin(playerid)) return 1;
	if(InCreation[createdgZone] != -1 && InCreation[createdgZone] != playerid) return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "Un altro amministratore sta creando una GangZone, attendi che finisca.");
	new Float:X,Float:Y,Float:Z,str[145];
	switch(Step)
	{
		case 0:
		{
			Step = 1;
			GetPlayerPos(playerid, X, Y, Z);
			GangZone[createdgZone][gMinX] = X, GangZone[createdgZone][gMinY] = Y;
			format(str,sizeof(str), "Hai iniziato la creazione della GangZone, MinX: %.2f, MinY: %.2f.",GangZone[createdgZone][gMinX],GangZone[createdgZone][gMinY]);
			SendClientMessage(playerid, COLOR_LIGHTYELLOW, str);
			SendClientMessage(playerid, COLOR_LIGHTYELLOW, "Rifai il comando spostandoti all'altra estremita' diagonale per completare la creazione.");
			InCreation[createdgZone] = playerid;
			return 1;
		}
		case 1:
		{
			Step = 0;
			GetPlayerPos(playerid, X, Y, Z);
			GangZone[createdgZone][gMaxX] = X, GangZone[createdgZone][gMaxY] = Y;
			format(str,sizeof(str), "Hai completato la creazione della GangZone, MaxX: %.2f, MaxY: %.2f, Zone ID: %d.",GangZone[createdgZone][gMaxX],GangZone[createdgZone][gMaxY],createdgZone);
			SendClientMessage(playerid, COLOR_LIGHTYELLOW, str);
			SendClientMessage(playerid, COLOR_LIGHTYELLOW, "Ora usa il comando /setclanzone per settarla al clan.");
			new query[145];
			mysql_format(MySQL, query, sizeof(query), "INSERT INTO `gangzones` (MinX, MinY, MaxX, MaxY, ClanOwner) VALUES(%f,%f,%f,%f,-1)",GangZone[createdgZone][gMinX],GangZone[createdgZone][gMinY],GangZone[createdgZone][gMaxX],GangZone[createdgZone][gMaxY]);
			mysql_tquery(MySQL, query, "OnGangZoneInsert","d",createdgZone);
			InCreation[createdgZone] = -1;
			GangZone[createdgZone][ClanID] = -1;
			createdgZone = GangZoneCreate(GangZone[createdgZone][gMinX], GangZone[createdgZone][gMinY], GangZone[createdgZone][gMaxX], GangZone[createdgZone][gMaxY]);
			GangZone[createdgZone][gAreaID] = CreateDynamicRectangle(GangZone[createdgZone][gMinX], GangZone[createdgZone][gMinY], GangZone[createdgZone][gMaxX], GangZone[createdgZone][gMaxY]);
			Iter_Add(GangZones, createdgZone);
			foreach(new i : Player) { RefreshGangZone(i); }
			createdgZone++;
			return 1;			
		}
	}
	return 1;
}

CMD:setclanzone(playerid,params[])
{
	if(!IsPlayerAdmin(playerid)) return 1;
	new gangzoneid, clanid;
	if(sscanf(params, "dd",gangzoneid, clanid)) return SendClientMessage(playerid, COLOR_WHITE, "USO: /setclanzone <gang zone id> <clan id>");
	if(gangzoneid < 1|| gangzoneid > createdgZone) return SendClientMessage(playerid, COLOR_RED, "ID Invalido");
	GangZone[gangzoneid][ClanID] = clanid;
	new str[90],zone[MAX_ZONE_NAME];
	Get2DZoneName(GangZone[createdgZone][gMinX], GangZone[createdgZone][gMinY],zone,MAX_ZONE_NAME);
	format(str,sizeof(str), "Hai settato la Gang zone a %s (ID: %d) al clan %s (ID %d)",zone,gangzoneid,Clans[clanid][Name],clanid);
	SendClientMessage(playerid, COLOR_LIGHTYELLOW, str);
	RefreshGangZone(gangzoneid);
	SaveGangZone(gangzoneid);
	return 1;		
}

CMD:setclancolor(playerid, params[])
{
 	if(PlayerInfo[playerid][ClanLeader] == 0) return SendClientMessage(playerid, COLOR_RED, "Non sei il leader di un clan!");
 	new red,green,blue,alpha,str[145];
 	if(sscanf(params,"dddd",red,green,blue,alpha)) return SendClientMessage(playerid, COLOR_WHITE, "USO: /setclancolor <red> <green> <blue> <alpha>");
 	if(red < 0 || red > 255 || green < 0 || green > 255 || blue < 0 || blue > 255 || alpha < 0 || alpha > 100) return SendClientMessage(playerid, COLOR_RED, "I valori RGBA vanno massimo da 0 a 255 (0-100 per l'alpha)");
 	Clans[PlayerInfo[playerid][Clan]][GangColor] = RGBAToHex(red,green,blue,alpha);
 	format(str,sizeof(str), "Hai settato il colore del tuo clan. (Rosso: %d, Verde: %d, Blu: %d, Opacita': %d, Hex: %x)",red,green,blue,alpha, RGBAToHex(red,green,blue,alpha));
 	SendClientMessage(playerid, COLOR_LIGHTBLUE, str);
 	foreach(new i : Player) { RefreshGangZone(i); }
 	return 1;
}

CMD:ashowgangzones(playerid,params[])
{
	if(!IsPlayerAdmin(playerid)) return 1;
	new str[300],zone[MAX_ZONE_NAME];
	foreach(new i : GangZones)
	{
		Get2DZoneName(GangZone[i][gMinX],GangZone[i][gMinY],zone,MAX_ZONE_NAME);
		format(str,sizeof(str), "%s%s\t%d\n",str, zone, i);
	}
	ShowPlayerDialog(playerid, DIALOG_LISTGANGZONE, DIALOG_STYLE_TABLIST, "Lista GangZone", str, "Opzioni", "Annulla");
	return 1;
}

CMD:conquista(playerid, params[])
{
	if(IsPlayerInGangZone(playerid) == -1) return SendClientMessage(playerid, COLOR_RED, "Non sei in un territorio da conquistare");
	new clan = 0,
		cmembers,
		string[145],
		zone[MAX_ZONE_NAME],
		gangzone = IsPlayerInGangZone(playerid);
	//if(!IsGangster(playerid)) return SendClientMessage(playerid, COLOR_RED, "Devi far parte di una gang ufficiale per conquistare un territorio!");
	printf("%d GANG ZONE ID",gangzone);
	if(PlayerInfo[playerid][ClanLeader])
	{
		clan = PlayerInfo[playerid][ClanLeader];
	}
	else if(PlayerInfo[playerid][Clan])
	{
		clan = PlayerInfo[playerid][Clan];
	}
	print("PD");
	if(GangWar[gwOn]) return SendClientMessage(playerid, COLOR_RED, "C'e' gia' la conquista di un territorio in corso.");
	cmembers = GetClanMembersCount(clan);
	if(cmembers < 4) return SendClientMessage(playerid, COLOR_RED, "Devono esserci almeno 4 membri della tua gang online!");
	Get2DZoneName(GangZone[gangzone][gMinX],GangZone[gangzone][gMinY],zone,MAX_ZONE_NAME);
	print("PD23");
	if(GangZone[gangzone][ClanID] != -1)
	{
		if(GetClanMembersCount(GangZone[gangzone][ClanID]) < 4) return SendClientMessage(playerid, COLOR_RED, "Ci devono essere minimo 4 membri del clan che possiede il territorio.");
		if(GangZone[gangzone][ClanID] == clan) return SendClientMessage(playerid, COLOR_RED, "Il territorio e' già della tua gang!");
		format(string, sizeof(string), "Il territorio a %s e' sotto attacco da parte dalla gang %s!",zone, Clans[clan-1][Name]);
		print("PD55");
		foreach(new i : Player)
		{
			if(!IsGangster(i)) continue;
			SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
			if(PlayerInfo[i][ClanLeader] != clan && PlayerInfo[i][Clan] != clan)
			{
				SendClientMessage(i, COLOR_LIGHTBLUE, "Stanno attaccanto il vostro territorio, correte a fermarli entro 10 minuti!");
			}
		}
	}
	else 
	{
		print("PD FREE");
		format(string,sizeof(string), "Il territorio neutrale a %s e' sotto attacco dalla gang %s",zone, Clans[clan-1][Name]);
		foreach(new i : Player)
		{
			//if(!IsGangster(i)) continue;
			SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
		}
	}	
	GangWar[gwClanStarter] = clan-1;
	GangWar[gwOn] = 1;
	GangWar[gwTime] = 20;
	GangWar[gwZone] = gangzone;
	foreach(new i : Player) { RefreshGangZone(i); }
	return 1;
}

IsPlayerInGangZone(playerid)
{
	foreach(new i : GangZones)
	{
		if(IsPlayerInDynamicArea(playerid, GangZone[i][gAreaID]))
		{
			printf("%d I GANG",GangZone[i][gAreaID]);
			return i;
		}
	}
	print("-1");
	return -1;
}

RefreshGangZone(playerid) // Devi sostituire tutti gli ShowTurfsForPlayer
{
 	foreach(new i : GangZones)
 	{
 		//if(!IsGangster(i)) GangZoneHideForPlayer(i, gzoneid); Togli il commento
 		if(GangZone[i][ClanID] != -1)
 		{
 			if(GangWar[gwOn] && GangWar[gwZone] == i)
 			{

 				GangZoneShowForPlayer(playerid, i, Clans[GangZone[i][ClanID]][GangColor]);
 				GangZoneFlashForPlayer(playerid, i, COLOR_RED);
 			}
 			else 
 			{
 				GangZoneShowForPlayer(playerid, i, Clans[GangZone[i][ClanID]][GangColor]);
 				GangZoneStopFlashForPlayer(playerid, i);
 			}
 		}
 		else
 		{
 			if(GangWar[gwOn] && GangWar[gwZone] == i)
 			{
 				GangZoneShowForPlayer(playerid, i, 0xFFFFFF66);
 				GangZoneFlashForPlayer(playerid, i, COLOR_RED);
 			}
 			else 
 			{
 				GangZoneShowForPlayer(playerid, i, 0xFFFFFF60);
 				GangZoneStopFlashForPlayer(playerid, i);
 			}	
 		}
 	}
}

forward OnGangZoneInsert(gangzid);
public OnGangZoneInsert(gangzid)
{
	GangZone[gangzid][gID] = cache_insert_id(MySQL);
	return 1;
}

// NON TI SERVE

GetClanMembersCount(clan)
{
	#pragma unused clan
	return 10;
}

new createdClans = 1;

CMD:creaclan(playerid, params[])
{
	new cname[32];
	if(sscanf(params, "s[32]",cname)) return 1;
	strcpy(Clans[createdClans][Name], cname, 32);
	PlayerInfo[playerid][ClanLeader] = createdClans;
	PlayerInfo[playerid][Clan] = createdClans;
	new str[64];
	format(str,sizeof(str), "Hai creato il Clan %s (ID: %d)",cname, createdClans);
	SendClientMessage(playerid, COLOR_WHITE, str);
	createdClans++;
	return 1;
}

CMD:show(playerid,params[])
{
	RefreshGangZone(playerid);
	return 1;
}

RGBAToHex(r, g, b, a)
{
    return (r<<24 | g<<16 | b<<8 | a);
}

stock IsGangster(playerid)
{
    new
        clan = PlayerInfo[playerid][ClanLeader] ? PlayerInfo[playerid][ClanLeader] : PlayerInfo[playerid][Clan];
    return (clan && Clans[clan-1][Gang]) ? 1 : 0;
}
// NOPE.OGG
/*
stock GetGangstersCount()
{
	new
		count;
	foreach (new i : Player)
	{
		if(IsGangster(i))
		{
			count++;
		}
	}
	return count;
}

stock GetPlayerTurf(playerid)
{
	for(new i; i < sizeof Turf; i++)
	{
		if(IsPlayerInDynamicArea(playerid, Turf[i][AreaID]))
		{
			return i;
		}
	}
	return -1;
}



enum E_TERRITORIES
{
	tName[24],
	Float:tMinX,
	Float:tMinY,
	Float:tMaxX,
	Float:tMaxY
}

new const
	Territories[20][E_TERRITORIES] =
	{
		{"Temple", 1109.582, -1144.969, 1356.766, -1042.328},
		{"Mullhoand", 1577.33, -1160.76, 1820.712, -1006.798},
		{"Little Mexico", 1581.133, -1879.249, 1691.416, -1748.974},
		{"Unity", 1695.218, -1977.943, 1969.022, -1752.921},
		{"Las Collinas Ovest", 1870.149, -1141.021, 2250.432, -994.9549},
		{"Glen Park", 1866.346, -1259.454, 2067.896, -1141.021},
		{"Jefferson", 2071.699, -1294.983, 2254.235, -1148.917},
		{"Skate Park", 1862.543, -1460.788, 1984.234, -1354.199},
		{"Idlewood", 1835.923, -1748.974, 2083.108, -1520.005},
		{"Idlewood Sud", 1969.022, -1930.57, 2185.784, -1772.66},
		{"Ganton Ovest", 2105.925, -1752.921, 2193.39, -1555.534},
		{"Ganton", 2220.01, -1745.026, 2470.997, -1658.175},
		{"Ganton Sud", 2216.207, -1942.413, 2497.617, -1764.764},
		{"Willowfield", 2212.404, -2041.106, 2501.419, -1938.465},
		{"Playa de Seville", 2596.49, -2060.845, 2790.435, -1906.883},
		{"East Beach", 2718.181, -1666.071, 2866.492, -1152.865},
		{"East LS Nord", 2360.715, -1441.05, 2467.194, -1200.237},
		{"Los Flores", 2562.265, -1595.012, 2695.364, -1271.297},
		{"Stadium", 2623.11, -1902.935, 2824.661, -1670.019},
		{"El Corona", 1691.416, -2171.382, 1969.022, -1973.995}
	};

enum TurfInfo
{
	ZoneID,
	ClanOwner,
	AreaID
}

new Turf[sizeof Territories][TurfInfo];*/