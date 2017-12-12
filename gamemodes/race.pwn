/*------------------------------------------------
	Converti lo Spawn dei veicoli per la tua GM
	Aggiungi il PlayerInfo al TUO playerInfo
	Le gare in OnGameModeInit sono precreate per i test, lasciale finché non finisci il sistema di Salvataggio
	Ripeto il consiglio di usare EasyDialog in quanto rischi un conflitto tra gli ID con tutti questi DIALOG.
	Abbiamo testato PRATICAMENTE tutto e funziona bene.
	--- CHANGELOG ---
	Modificati gli ENUM e tutte le funzioni base
	RIcopia tutti i DIALOG, gli ENUM e le funzioni, Tra cui l'OnPlayertDisconnect è stato modificato.
	PS: Tua mamma è mia.
--------------------------------------------------*/

#include <a_samp>
#include <a_mysql>
#include <sscanf2>
#include <SmartCMD>
#include <easydialog>
#include <foreach>

#define MYSQL_HOST "localhost"
#define MYSQL_PSW ""
#define MYSQL_USER "root"
#define MYSQL_DB "samp"

#define Loop(%0,%1) \
	for(new %0 = 0; %0 != %1; %0++)

#define strcpy(%0,%1,%2) \
	strcat((%0[0] = '\0', %0), %1, %2)

#define MAX_RACES 50
#define MAX_RACE_CHECK 200
#define RACE_WAIT 30
#define MAX_RACING_PLAYERS 20

#define EMB_ORANGE "{f2a53a}"
#define EMB_GREEN "{32ff36}"
#define EMB_YELLOW "{fbff31}"
#define EMB_WHITE "{FFFFFF}"
#define EMB_RED "{ff0000}"

enum P_INFO
{
	pLoaned,
	pTDTimer
};

new PlayerInfo[MAX_PLAYERS][P_INFO];

enum R_INFO
{
	rID,
	rName[32],
	rTimer,
	rCreator[MAX_PLAYER_NAME],
	rTimeout,
	rTime,
	rVeh,
	Float:rCheckX[MAX_RACE_CHECK],
	Float:rCheckY[MAX_RACE_CHECK],
	Float:rCheckZ[MAX_RACE_CHECK],
	rActualCheck,
	Float:rStartingX[MAX_RACING_PLAYERS],
	Float:rStartingY[MAX_RACING_PLAYERS],
	Float:rStartingZ[MAX_RACING_PLAYERS],
	Float:rStartingA[MAX_RACING_PLAYERS],
	bool:rStarted,
	bool:rJoinable,
	rRacers,
	rTotalRacers,
	rCompleted,
	rVehLoans[MAX_RACING_PLAYERS]
};



new RaceInfo[MAX_RACES][R_INFO];

new createdRace = 1,
	InRace[MAX_PLAYERS],
	CurrentCheck[MAX_PLAYERS],
	startingPos[MAX_RACES],
	FreeStart[MAX_RACES],
	PlayerText:pRaceTD[MAX_PLAYERS][3],
	CD[MAX_RACES],
	CDTimer[MAX_RACES],
	creatingRace = -1,
	Iterator:Races<MAX_RACES>;


new VehicleNames[212][] =
{
	"Landstalker",  "Bravura",  "Buffalo", "Linerunner", "Perennial", "Sentinel",
 	"Dumper",  "Firetruck" ,  "Trashmaster" ,  "Stretch",  "Manana",  "Infernus",
  	"Voodoo", "Pony",  "Mule", "Cheetah", "Ambulance",  "Leviathan",  "Moonbeam",
    "Esperanto", "Taxi",  "Washington",  "Bobcat",  "Mr Whoopee", "BF Injection",
    "Hunter", "Premier",  "Enforcer",  "Securicar", "Banshee", "Predator", "Bus",
    "Rhino",  "Barracks",  "Hotknife",  "Trailer",  "Previon", "Coach", "Cabbie",
    "Stallion", "Rumpo", "RC Bandit",  "Romero", "Packer", "Monster",  "Admiral",
    "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer",  "Turismo", "Speeder",
    "Reefer", "Tropic", "Flatbed","Yankee", "Caddy", "Solair","Berkley's RC Van",
    "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron","RC Raider","Glendale",
    "Oceanic", "Sanchez", "Sparrow",  "Patriot", "Quad",  "Coastguard", "Dinghy",
    "Hermes", "Sabre", "Rustler", "ZR-350", "Walton",  "Regina",  "Comet", "BMX",
    "Burrito", "Camper", "Marquis", "Baggage", "Dozer","Maverick","News Chopper",
    "Rancher", "FBI Rancher", "Virgo", "Greenwood","Jetmax","Hotring","Sandking",
    "Blista Compact", "Police Maverick", "Boxville", "Benson","Mesa","RC Goblin",
    "Hotring Racer", "Hotring Racer", "Bloodring Banger", "Rancher",  "Super GT",
    "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropdust", "Stunt",
    "Tanker", "RoadTrain", "Nebula", "Majestic", "Buccaneer", "Shamal",  "Hydra",
    "FCR-900","NRG-500","HPV1000","Cement Truck","Tow Truck","Fortune","Cadrona",
    "FBI Truck", "Willard", "Forklift","Tractor","Combine","Feltzer","Remington",
    "Slamvan", "Blade", "Freight", "Streak","Vortex","Vincent","Bullet","Clover",
    "Sadler",  "Firetruck", "Hustler", "Intruder", "Primo", "Cargobob",  "Tampa",
    "Sunrise", "Merit", "Utility Truck", "Nevada", "Yosemite", "Windsor", "Monster",
    "Monster","Uranus","Jester","Sultan","Stratum","Elegy","Raindance","RCTiger",
    "Flash","Tahoma","Savanna", "Bandito", "Freight", "Trailer", "Kart", "Mower",
    "Dune", "Sweeper", "Broadway", "Tornado", "AT-400",  "DFT-30", "Huntley",
    "Stafford", "BF-400", "Newsvan","Tug","Trailer","Emperor","Wayfarer","Euros",
    "Hotdog", "Club", "Trailer", "Trailer","Andromada","Dodo","RC Cam", "Launch",
    "Police Car LSPD", "Police Car SFPD","Police Car LVPD","Police Ranger",
    "Picador",   "S.W.A.T. Van",  "Alpha",   "Phoenix",   "Glendale",   "Sadler",
    "Luggage Trailer","Luggage Trailer","Stair Trailer", "Boxville", "Farm Plow",
    "Utility Trailer"
};

main()
{
	print("\n----------------------------------");
	print("  Race System\n");
	print("----------------------------------\n");
}

public OnPlayerConnect(playerid)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerInterior(playerid,0);
	TogglePlayerClock(playerid,0);
	SetPlayerPos(playerid, 2030.8905,1346.6224,10.8203);
	InRace[playerid] = -1;
	CurrentCheck[playerid] = -1;
	CreateRaceTD(playerid);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(InRace[playerid] != -1) LeaveRace(playerid, InRace[playerid]);
   	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(InRace[playerid] != -1) LeaveRace(playerid, InRace[playerid]);
	if(playerid == creatingRace)
	{	
		Loop(r, MAX_RACES)
		{
			if(RaceInfo[r][rCompleted] == 0) startingPos[r] = 0, RaceInfo[r][rActualCheck] = 0; 
		}
	}
	return 1;
}

SetupPlayerForClassSelection(playerid)
{
 	SetPlayerInterior(playerid,14);
	SetPlayerPos(playerid,258.4893,-41.4008,1002.0234);
	SetPlayerFacingAngle(playerid, 270.0);
	SetPlayerCameraPos(playerid,256.0815,-43.0475,1004.0234);
	SetPlayerCameraLookAt(playerid,258.4893,-41.4008,1002.0234);
}

public OnPlayerRequestClass(playerid, classid)
{
	SetupPlayerForClassSelection(playerid);
	GivePlayerMoney(playerid, 500000);
	return 1;
}

SaveRace(raceid)
{
	new query[156];
	format(query,sizeof(query), "INSERT INTO Races (Name, Creator, Timeout, Veh) VALUES('%s', '%s', '%d', '%d')",
								RaceInfo[raceid][rName],
								RaceInfo[raceid][rCreator],
								RaceInfo[raceid][rTimeout],
								RaceInfo[raceid][rVeh]);
	mysql_query(query);
	new id = mysql_insert_id();
	Loop(i, startingPos[raceid])
	{
		format(query,sizeof(query), "INSERT INTO RacesStart (StartPosX,StartPosY,StartPosZ,StartPosA,rID) VALUES('%f','%f','%f','%f','%d')",
									RaceInfo[raceid][rStartingX][i],
									RaceInfo[raceid][rStartingY][i],
									RaceInfo[raceid][rStartingZ][i],
									RaceInfo[raceid][rStartingA][i],
									id);
		mysql_query(query);
	}
	Loop(i, RaceInfo[raceid][rActualCheck])
	{
		format(query,sizeof(query), "INSERT INTO RaceCheck (CheckX, CheckY, CheckZ, rID) VALUES('%f','%f','%f','%d')",
									RaceInfo[raceid][rCheckX][i],
									RaceInfo[raceid][rCheckY][i],
									RaceInfo[raceid][rCheckZ][i],
									id);
		mysql_query(query);
	}
	return 1;
}

public OnGameModeInit()
{
	mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_DB, MYSQL_PSW);
	if(!mysql_ping()) printf("[MYSQL] Connection failed");	
	mysql_query("CREATE TABLE IF NOT EXISTS `Races`(\
				`rID` int(5) NOT NULL AUTO_INCREMENT, \
				`Name` varchar(32) NOT NULL, \
				`Timeout` int(5) NOT NULL, \
				`Creator` varchar(24) NOT NULL, \
				`Veh` int(5) NOT NULL, PRIMARY KEY(`rID`)) ENGINE MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1");
	mysql_query("CREATE TABLE IF NOT EXISTS `RacesStart`(\
				`rID` INT(5) NOT NULL, \
				`StartPosX` float NOT NULL, \
				`StartPosY` float NOT NULL, \
				`StartPosZ` float NOT NULL, \
				`StartPosA` float NOT NULL) ENGINE MyISAM DEFAULT CHARSET=latin1");
	mysql_query("CREATE TABLE IF NOT EXISTS `RaceCheck` (\
				`rID` INT(5) NOT NULL, \
				`CheckX` float NOT NULL, \
				`CheckY` float NOT NULL, \
				`CheckZ` float NOT NULL) ENGINE MyISAM DEFAULT CHARSET=latin1");
	SetGameModeText("Race System");
	AddPlayerClass(265,1958.3783,1343.1572,15.3746,270.1425,0,0,0,0,-1,-1);
	AddStaticVehicle(560,2039.8206,1365.7656,10.4190,314.5409,random(125),random(125)); 
	AddStaticVehicle(560,2040.3571,1361.2877,10.4192,315.6203,random(125),random(125)); // car1
	AddStaticVehicle(411,2040.1533,1355.8367,10.4180,315.9099,random(125),random(125)); // car2
	AddStaticVehicle(411,2039.8099,1350.4756,10.4188,312.7543,random(125),random(125)); // car3
	AddStaticVehicle(402,2039.7996,1345.5996,10.4187,315.3969,random(125),random(125)); // car4
	AddStaticVehicle(402,2040.0474,1341.0137,10.4183,314.7311,random(125),random(125)); // car5
	AddStaticVehicle(562,2039.9669,1335.7738,10.4182,314.3734,random(125),random(125)); // car6
	AddStaticVehicle(562,2039.8062,1330.7701,10.2538,316.1808,random(125),random(125)); // car7
	LoadRaces();
	return 1;
}

LoadRaces()
{
	new query[150],string[64];
	Loop(i, MAX_RACES)
	{
		format(query,sizeof(query), "SELECT * FROM `Races` WHERE `rID` = '%d'",i);
		mysql_query(query);
		mysql_store_result();
		while(mysql_fetch_row_format(query, "|"))
		{
			mysql_fetch_field_row(string, "rID"); RaceInfo[createdRace][rID] = strval(string);
			mysql_fetch_field_row(string, "Name"); strcpy(RaceInfo[createdRace][rName], string, 32);
			mysql_fetch_field_row(string, "Timeout"); RaceInfo[createdRace][rTimeout] = strval(string);
			mysql_fetch_field_row(string, "Creator"); strcpy(RaceInfo[createdRace][rCreator], string, MAX_PLAYER_NAME);
			mysql_fetch_field_row(string, "Veh"); RaceInfo[createdRace][rVeh] = strval(string);
		}
		if(RaceInfo[createdRace][rID] == 0) continue;
		mysql_free_result();
		format(query,sizeof(query), "SELECT * FROM `RacesStart` WHERE `rID` = '%d'",i);
		mysql_query(query);
		mysql_store_result();
		while(mysql_fetch_row_format(query, "|"))
		{
			new Float:X,Float:Y,Float:Z,Float:A;
			mysql_fetch_field_row(string, "StartPosX"); X = floatstr(string);
			mysql_fetch_field_row(string, "StartPosY"); Y = floatstr(string);
			mysql_fetch_field_row(string, "StartPosZ"); Z = floatstr(string);
			mysql_fetch_field_row(string, "StartPosA"); A = floatstr(string);
			AddRaceStarting(createdRace, X,Y,Z,A);
		}
		mysql_free_result();
		format(query,sizeof(query), "SELECT * FROM `RaceCheck` WHERE `rID` = '%d'",i);
		mysql_query(query);
		mysql_store_result();
		while(mysql_fetch_row_format(query, "|"))
		{
			new Float:X,Float:Y,Float:Z;
			mysql_fetch_field_row(string, "CheckX"); X = floatstr(string);
			mysql_fetch_field_row(string, "CheckY"); Y = floatstr(string);
			mysql_fetch_field_row(string, "CheckZ"); Z = floatstr(string);	
			AddCheckpointToRace(createdRace, X,Y,Z);
		}
		mysql_free_result();
		Iter_Add(Races, i);
		createdRace++;
	}
	return 1;
}

stock CreateRace(Name[], Timeout, Veh = -1)
{
	strcpy(RaceInfo[createdRace][rName], Name, 32);
	strcpy(RaceInfo[createdRace][rCreator], "Server", MAX_PLAYER_NAME);
	RaceInfo[createdRace][rTimeout] = Timeout;
	RaceInfo[createdRace][rVeh] = Veh;
	RaceInfo[createdRace][rStarted] = false;
	RaceInfo[createdRace][rJoinable] = false;
	RaceInfo[createdRace][rCompleted] = 1;
	return createdRace, createdRace++;
}

AddRaceStarting(raceid, Float:sx, Float:sy, Float:sz, Float:sa)
{
	RaceInfo[raceid][rStartingX][startingPos[raceid]] = sx;
	RaceInfo[raceid][rStartingY][startingPos[raceid]] = sy;
	RaceInfo[raceid][rStartingZ][startingPos[raceid]] = sz;
	RaceInfo[raceid][rStartingA][startingPos[raceid]] = sa;
	return startingPos[raceid], startingPos[raceid]++;
}

AddCheckpointToRace(raceid, Float:ChX, Float:ChY, Float:ChZ)
{
	new freeslot = RaceInfo[raceid][rActualCheck];
	RaceInfo[raceid][rCheckX][freeslot] = ChX;
	RaceInfo[raceid][rCheckY][freeslot] = ChY;
	RaceInfo[raceid][rCheckZ][freeslot] = ChZ;
	return RaceInfo[raceid][rActualCheck], RaceInfo[raceid][rActualCheck]++;
}

OpenRaceLobby(raceid)
{
	new rstr[144];
	switch(RaceInfo[raceid][rVeh])
	{
		case -1:
		{
			format(rstr, sizeof(rstr), ""EMB_GREEN"[INFO:]"EMB_WHITE" The race "EMB_ORANGE"%s"EMB_WHITE" will start in "EMB_YELLOW"%d"EMB_WHITE" seconds!",RaceInfo[raceid][rName],RACE_WAIT);
			SendClientMessageToAll(-1, rstr);
			format(rstr, sizeof(rstr),  ""EMB_GREEN"[INFO:]"EMB_WHITE" Type "EMB_RED"/joinrace %d"EMB_WHITE" to join. (All Vehicles Allowed)",raceid);
			SendClientMessageToAll(-1, rstr);
		}
		case 0:
		{
			format(rstr, sizeof(rstr), ""EMB_GREEN"[INFO:]"EMB_WHITE" The race "EMB_ORANGE"%s"EMB_WHITE" will start in "EMB_YELLOW"%d"EMB_WHITE" seconds!",RaceInfo[raceid][rName],RACE_WAIT);
			SendClientMessageToAll(-1, rstr);
			format(rstr, sizeof(rstr),  ""EMB_GREEN"[INFO:]"EMB_WHITE" Type "EMB_RED"/joinrace %d"EMB_WHITE" to join. (Onfoot race)",raceid);
			SendClientMessageToAll(-1, rstr);
		}
		default:
		{
			format(rstr, sizeof(rstr), ""EMB_GREEN"[INFO:]"EMB_WHITE" The race "EMB_ORANGE"%s"EMB_WHITE" will start in "EMB_YELLOW"%d"EMB_WHITE" seconds!",RaceInfo[raceid][rName],RACE_WAIT);
			SendClientMessageToAll(-1, rstr);
			format(rstr, sizeof(rstr),  ""EMB_GREEN"[INFO:]"EMB_WHITE" Type "EMB_RED"/joinrace %d"EMB_WHITE" to join. ("EMB_ORANGE"%s"EMB_WHITE" only race)",raceid,VehicleNames[RaceInfo[raceid][rVeh]-400]);
			SendClientMessageToAll(-1, rstr);
		}
	}
	CD[raceid] = 20;
	CDTimer[raceid] = SetTimerEx("CountDown",1000,true,"d",raceid);
	RaceInfo[raceid][rJoinable] = true;
	return 1;
}	

// Commands

CMD:joinrace(cmdid, playerid, params[])
{
	new rid;
	if(sscanf(params, "d",rid)) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE" USE: /joinrace <raceid>"), SendClientMessage(playerid, -1, ""EMB_GREEN"[INFO:]"EMB_WHITE" If you don't know the Race ID you can use /races!");
	if(rid > createdRace-1) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE" Invalid race ID!");
	if(RaceInfo[rid][rJoinable] == false && RaceInfo[rid][rStarted] == false && InRace[playerid] == -1) OpenRaceLobby(rid);
	JoinRace(playerid, rid);
	return 1;
}


CMD:quitrace(cmdid, playerid, params[])
{
	if(InRace[playerid] == -1) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE" You are not in a race!");
	new rstr[156];
	format(rstr,sizeof(rstr), ""EMB_GREEN"[INFO:]"EMB_ORANGE" %s"EMB_WHITE" left the race, %d racers remaning!",GetPlayerNameEx(playerid), RaceInfo[InRace[playerid]][rRacers]-1);
	SendRaceMessage(InRace[playerid],rstr);
	LeaveRace(playerid, InRace[playerid]);
	return 1;
}

CMD:races(cmdid, playerid, params[])
{
	new rstr[1024],requiredveh[24];
	strcpy(rstr, "Status\tName (ID)\tCreator\tVehicle\tPlayers\n", sizeof(rstr));
	foreach(new i : Races)
	{
		switch (RaceInfo[i][rVeh])
		{
			case 0: strcpy(requiredveh, "Onfoot",24);
			case -1: strcpy(requiredveh, "Personal Vehicle",24);
			default: format(requiredveh,sizeof(requiredveh), "%s",VehicleNames[RaceInfo[i][rVeh]-400]);
		}
		if(RaceInfo[i][rJoinable] == true) format(rstr,sizeof(rstr), "%s"EMB_YELLOW"[JOINABLE]\t"EMB_WHITE" %s (ID: %d)\t%s\t %d/%d\n",rstr,RaceInfo[i][rName],i,requiredveh,RaceInfo[i][rRacers],startingPos[i]);
		else if(RaceInfo[i][rStarted] == true) format(rstr,sizeof(rstr), "%s"EMB_RED"[RUNNING]\t"EMB_WHITE" %s (ID: %d)\t%s\t %d/%d\n",rstr,RaceInfo[i][rName],i,requiredveh,RaceInfo[i][rRacers],startingPos[i]);
		else format(rstr,sizeof(rstr), "%s"EMB_GREEN"[OPEN]\t"EMB_WHITE" %s (ID: %d)\t%s\t%s\n",rstr,RaceInfo[i][rName],i,requiredveh);
	}
	Dialog_Show(playerid, dialog_Races, DIALOG_STYLE_TABLIST_HEADERS, "Races", rstr, "Join Race", "Exit");
	return 1;
}

Dialog:dialog_CreateRace2(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;
	switch(listitem)
	{
		case 0:
		{
			if(startingPos[createdRace] >= MAX_RACING_PLAYERS) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE" Limit Reached!");
			if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE" You must be in a vehicle!");
			new Float:X, Float:Y, Float:Z, Float:A, vid = GetPlayerVehicleID(playerid);
			GetVehiclePos(vid, X,Y,Z);
			GetVehicleZAngle(vid, A);
			AddRaceStarting(createdRace, X,Y,Z,A);
			new rstr[144];
			format(rstr,sizeof(rstr), ""EMB_GREEN"[INFO:]"EMB_WHITE" You added a starting position in the race "EMB_ORANGE"%s"EMB_WHITE". Total: "EMB_YELLOW"%d",RaceInfo[createdRace][rName],startingPos[createdRace]);
			SendClientMessage(playerid, -1, rstr);
			return 1;
		}
		case 1:
		{
			if(RaceInfo[createdRace][rActualCheck] >= MAX_RACE_CHECK) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE" Limit Reached!");
			if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE" You must be in a vehicle!");
			new Float:X, Float:Y, Float:Z, vid = GetPlayerVehicleID(playerid);
			GetVehiclePos(vid, X,Y,Z);
			AddCheckpointToRace(createdRace, X,Y,Z);
			new rstr[144];
			format(rstr,sizeof(rstr), ""EMB_GREEN"[INFO:]"EMB_WHITE" You added a checkpoint in the race "EMB_ORANGE"%s"EMB_WHITE". Total: "EMB_YELLOW"%d",RaceInfo[createdRace][rName],RaceInfo[createdRace][rActualCheck]);
			SendClientMessage(playerid, -1, rstr);	
			return 1;		
		}
		case 2:
		{
			new rstr[144];
			format(rstr,sizeof(rstr), ""EMB_GREEN"[INFO:]"EMB_ORANGE" %s"EMB_WHITE" created the race"EMB_ORANGE" %s"EMB_WHITE". Time to try it!",GetPlayerNameEx(playerid), RaceInfo[createdRace][rName]);
			SendClientMessageToAll(-1, rstr);
			creatingRace = -1;
			RaceInfo[createdRace][rStarted] = false;
			RaceInfo[createdRace][rCompleted] = 1;
			strcpy(RaceInfo[createdRace][rCreator], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
			SaveRace(createdRace);
			Iter_Add(Races, createdRace);
			createdRace++;
			return 1;
		}
		case 3:
		{
			RaceInfo[createdRace][rActualCheck] = 0;
			startingPos[createdRace] = 0;
			creatingRace = -1;
			SendClientMessage(playerid, -1, ""EMB_RED"[INFO:] You aborted the race creation, next time you have to do everything from scratch!");
			return 1;
		}
	}
	return 1;
}

Dialog:dialog_Races(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;
	if(RaceInfo[listitem+1][rJoinable] == false && RaceInfo[listitem+1][rStarted] == false && InRace[playerid] == -1) OpenRaceLobby(listitem+1);
	JoinRace(playerid, listitem+1);
	return 1;
}

CMD:createrace(cmdid, playerid, params[])
{
	if(creatingRace == playerid) Dialog_Show(playerid, dialog_CreateRace2, DIALOG_STYLE_LIST, "Creating Race", "Add Starting position here (Must be in a vehicle)\nAdd Checkpoint here\nComplete the race\n"EMB_RED"Abort!", "Confirm", "Exit");
	else if(creatingRace == -1) Dialog_Show(playerid, dialog_CreateRace, DIALOG_STYLE_INPUT, "Create Race", "The race must have a name\nPlease insert a name not longer than 16 character here!", "Confirm", "Exit");
	else if(creatingRace != -1) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE" Someone is creating a race, wait for him/her to finish!");
	return 1;
}

Dialog:dialog_CreateRace(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;
	if(strlen(inputtext) > 16) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE" Max lenght of racename is 16 characters!");
	new rstr[96];
	strcpy(RaceInfo[createdRace][rName], inputtext, 16);
	format(rstr,sizeof(rstr), ""EMB_GREEN"[INFO:]"EMB_WHITE" The name of the race is: "EMB_ORANGE"%s",RaceInfo[createdRace][rName]);
	SendClientMessage(playerid, -1, rstr);
	Dialog_Show(playerid, dialog_CreateRaceTime, DIALOG_STYLE_INPUT, "Race Timeout", "To avoid AFK people blocking a race, you must insert a timeout value\nPlease insert a timeout value in seconds bigger than 299 seconds.", "Confirm", "Exit");
	RaceInfo[createdRace][rCompleted] = 0;
	creatingRace = playerid;
	return 1;
}

Dialog:dialog_CreateRaceTime(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;
	if(!IsNumeric(inputtext)) return Dialog_Show(playerid, dialog_CreateRaceVeh, DIALOG_STYLE_INPUT, "Race Vehicle", "Only Numbers!","Confirm","Exit");
	if(strval(inputtext) <= 299) return Dialog_Show(playerid, dialog_CreateRaceTime, DIALOG_STYLE_INPUT, "Race Timeout", "To avoid AFK people blocking a race, you must insert a timeout value\nPlease insert a timeout value in seconds bigger than 299 seconds.", "Confirm", "Exit");
	RaceInfo[createdRace][rTimeout] = strval(inputtext);
	new rstr[96];
	format(rstr,sizeof(rstr), ""EMB_GREEN"[INFO:]"EMB_WHITE" The Timeout timer is: "EMB_ORANGE"%d"EMB_WHITE" seconds!",RaceInfo[createdRace][rTimeout]);
	SendClientMessage(playerid, -1, rstr);
	Dialog_Show(playerid, dialog_CreateRaceVeh, DIALOG_STYLE_INPUT, "Race Vehicle", "Do you intend to have a specific vehicle to be used in the race?\nIf so please insert the vehicle id in the box below\nIf you don't want any vehicle in particular to be used, please type 0", "Confirm", "Exit");
	return 1;	
}

Dialog:dialog_CreateRaceVeh(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;
	if(!IsNumeric(inputtext)) return Dialog_Show(playerid, dialog_CreateRaceVeh, DIALOG_STYLE_INPUT, "Race Vehicle", "Only Numbers!","Confirm","Exit");
	if(strval(inputtext) <= 0) RaceInfo[createdRace][rVeh] = -1;
	else if(strval(inputtext) < 400 || strval(inputtext) > 611) return Dialog_Show(playerid, dialog_CreateRaceVeh, DIALOG_STYLE_INPUT, "Race Vehicle", "Do you intend to have a specific vehicle to be used in the race?\nIf so please insert the vehicle id in the box below\nIf you don't want any vehicle in particular to be used, please leave it empty or type -1\n"EMB_RED"You inserted an invalid ID!", "Confirm", "Exit");
	else RaceInfo[createdRace][rVeh] = strval(inputtext); 
	new rstr[96];
	if(RaceInfo[createdRace][rVeh] == -1) format(rstr,sizeof(rstr), ""EMB_GREEN"[INFO:]"EMB_WHITE" Any vehicle can be used for this race");
	else format(rstr,sizeof(rstr), ""EMB_GREEN"[INFO:]"EMB_WHITE" A "EMB_ORANGE"%s"EMB_WHITE" is required for this race.",VehicleNames[strval(inputtext) -400]);
	SendClientMessage(playerid, -1, rstr);
	SendClientMessage(playerid, -1, ""EMB_GREEN"[INFO:]"EMB_WHITE" You can now use "EMB_ORANGE"/createrace"EMB_WHITE" To add starting position and checkpoints!");
	SendClientMessage(playerid, -1, ""EMB_RED"[ALERT:] Please be extra careful when adding checkpoints or starting position since you will have to redo EVERYTHING from scratch if you fail!");
	RaceInfo[createdRace][rStarted] = true;
	return 1;
}

SendRaceMessage(raceid, const string[])
{
	Loop(i, MAX_PLAYERS)
	{
		if(!IsPlayerConnected(i)) continue;
		if(InRace[i] != raceid) continue;
		SendClientMessage(i, -1, string);
	}
	return 1;
}

IsNumeric(const string[])
{
	for (new i = 0, j = strlen(string); i < j; i++)
	{
		if (string[i] > '9' || string[i] < '0') return 0;
	}
    return 1;
}

StartRace(raceid)
{
	RaceInfo[raceid][rJoinable] = false;
	if(RaceInfo[raceid][rRacers] == 0) return 1;
	Loop(i, MAX_PLAYERS)
	{
		if(!IsPlayerConnected(i)) continue;
		if(InRace[i] == -1) continue;
		if(GetPlayerState(i) == PLAYER_STATE_DRIVER && InRace[i] == raceid)
		{
			CurrentCheck[i] = 1;
			TogglePlayerControllable(i, true);
		}
		else if(GetPlayerState(i) != PLAYER_STATE_DRIVER)
		{
			InRace[i] = -1;
			CurrentCheck[i] = -1;
			DisablePlayerRaceCheckpoint(i);
			LeaveRace(i, raceid);
			if(IsPlayerInAnyVehicle(i))
			{
				new vid = GetPlayerVehicleID(i);
				SetVehicleVirtualWorld(vid, 0);
				SetPlayerVirtualWorld(i, 0);
				PutPlayerInVehicle(i, vid, 0);
				TogglePlayerControllable(i, true);
			}
			else SetPlayerVirtualWorld(i, 0);
		}
	}
	RaceInfo[raceid][rTimer] = SetTimerEx("RaceTime",100, true, "d", raceid);
	RaceInfo[raceid][rStarted] = true;
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	if(InRace[playerid] != -1)
	{
		if(CurrentCheck[playerid] > 0)
		{
			new raceid = InRace[playerid], checkid = CurrentCheck[playerid];
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return LeaveRace(playerid, raceid), SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE"Nope, you are not driving mate, It won't work");
			if(checkid == RaceInfo[raceid][rActualCheck])
			{
				new str[200];
				format(str,sizeof(str), ""EMB_GREEN"[INFO:]"EMB_ORANGE" %s"EMB_WHITE" finished the race in "EMB_YELLOW"%d"EMB_WHITE" place out of the "EMB_YELLOW"%d"EMB_WHITE" racers in: %s!",GetPlayerNameEx(playerid), RaceInfo[raceid][rTotalRacers] - RaceInfo[raceid][rRacers] +1, RaceInfo[raceid][rTotalRacers],FormatTime(RaceInfo[raceid][rTime]));
				SendRaceMessage(raceid, str);
				LeaveRace(playerid, raceid);
				return 1;
			}
			CurrentCheck[playerid] ++;
			new Float:X, Float:Y, Float:Z;
			if(checkid != RaceInfo[raceid][rActualCheck])
			{
				SetPlayerRaceCheckpoint(playerid, 0, RaceInfo[raceid][rCheckX][checkid],  RaceInfo[raceid][rCheckY][checkid],  RaceInfo[raceid][rCheckZ][checkid], RaceInfo[raceid][rCheckX][checkid+1],  RaceInfo[raceid][rCheckY][checkid+1],  RaceInfo[raceid][rCheckZ][checkid+1], 6);
				GetPlayerPos(playerid, X, Y, Z);
				PlayerPlaySound(playerid, 5201, 0,0,0);
			}	
			if(checkid+1 == RaceInfo[raceid][rActualCheck])
			{
				SetPlayerRaceCheckpoint(playerid, 1, RaceInfo[raceid][rCheckX][checkid],  RaceInfo[raceid][rCheckY][checkid],  RaceInfo[raceid][rCheckZ][checkid], 0.0,0.0,0.0, 6);
				PlayerPlaySound(playerid, 5201, 0,0,0);
			}
		}
		return 1;
	}
	return 1;
}

forward CountDown(raceid);
public CountDown(raceid)
{
	new td[32];
	if(CD[raceid] == 0 && RaceInfo[raceid][rStarted] == false) StartRace(raceid), KillTimer(CDTimer[raceid]);
	Loop(i, MAX_PLAYERS)
	{
		if(!IsPlayerConnected(i)) continue;
		if(InRace[i] != raceid) continue;
		if(CD[raceid] > 0 && RaceInfo[raceid][rStarted] == false)
		{
			format(td,sizeof(td), "~r~Countdown: ~g~%d",CD[raceid]);
			PlayerTextDrawSetString(i, pRaceTD[i][1], td);	
		}
	}
	CD[raceid]--;
	return 1;
}

forward UpdateRaceTD(playerid);
public UpdateRaceTD(playerid)
{
	new td[32];
	new raceid = InRace[playerid];
	format(td, sizeof(td), "~b~%s_~w~(~r~%d~w~)",RaceInfo[raceid][rName],raceid);
	PlayerTextDrawSetString(playerid, pRaceTD[playerid][0], td);
	format(td, sizeof(td), "Checkpoint:_~g~%d~w~/~r~%d",CurrentCheck[playerid]-1,RaceInfo[raceid][rActualCheck]);
	PlayerTextDrawSetString(playerid, pRaceTD[playerid][2], td);
	if(RaceInfo[raceid][rStarted] == true)
	{
		format(td, sizeof(td), "~g~Race_Time:_~y~%s",FormatTime(RaceInfo[raceid][rTime]));
		PlayerTextDrawSetString(playerid, pRaceTD[playerid][1], td);
	}
	return 1;
}

CreateRaceTD(playerid)
{

	pRaceTD[playerid][0] = CreatePlayerTextDraw(playerid, 591.666198, 202.444412, "RACENAME_(100)");
	PlayerTextDrawLetterSize(playerid, pRaceTD[playerid][0], 0.212001, 1.190000);
	PlayerTextDrawTextSize(playerid, pRaceTD[playerid][0], 0.000000, 95.000000);
	PlayerTextDrawAlignment(playerid, pRaceTD[playerid][0], 2);
	PlayerTextDrawColor(playerid, pRaceTD[playerid][0], -1);
	PlayerTextDrawUseBox(playerid, pRaceTD[playerid][0], 1);
	PlayerTextDrawBoxColor(playerid, pRaceTD[playerid][0], 41079);
	PlayerTextDrawSetShadow(playerid, pRaceTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, pRaceTD[playerid][0], 1);
	PlayerTextDrawBackgroundColor(playerid, pRaceTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, pRaceTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, pRaceTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, pRaceTD[playerid][0], 0);

	pRaceTD[playerid][1] = CreatePlayerTextDraw(playerid, 591.666198, 216.445266, "Race_Time:_00.000:000");
	PlayerTextDrawLetterSize(playerid, pRaceTD[playerid][1], 0.212001, 1.190000);
	PlayerTextDrawTextSize(playerid, pRaceTD[playerid][1], 0.000000, 95.000000);
	PlayerTextDrawAlignment(playerid, pRaceTD[playerid][1], 2);
	PlayerTextDrawColor(playerid, pRaceTD[playerid][1], -1);
	PlayerTextDrawUseBox(playerid, pRaceTD[playerid][1], 1);
	PlayerTextDrawBoxColor(playerid, pRaceTD[playerid][1], 119);
	PlayerTextDrawSetShadow(playerid, pRaceTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, pRaceTD[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, pRaceTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, pRaceTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, pRaceTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, pRaceTD[playerid][1], 0);

	pRaceTD[playerid][2] = CreatePlayerTextDraw(playerid, 591.666198, 230.246109, "Checkpoint:_X/X");
	PlayerTextDrawLetterSize(playerid, pRaceTD[playerid][2], 0.212001, 1.190000);
	PlayerTextDrawTextSize(playerid, pRaceTD[playerid][2], 0.000000, 95.000000);
	PlayerTextDrawAlignment(playerid, pRaceTD[playerid][2], 2);
	PlayerTextDrawColor(playerid, pRaceTD[playerid][2], -1);
	PlayerTextDrawUseBox(playerid, pRaceTD[playerid][2], 1);
	PlayerTextDrawBoxColor(playerid, pRaceTD[playerid][2], 119);
	PlayerTextDrawSetShadow(playerid, pRaceTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, pRaceTD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, pRaceTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, pRaceTD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, pRaceTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, pRaceTD[playerid][2], 0);
	return 1;
}

FormatTime(timevariable)
{
	new milliseconds = timevariable, seconds, minutes, string[20];
	while(milliseconds > 9)
	{
	    seconds ++;
	    milliseconds = milliseconds - 10;
	}
	while(seconds > 59)
	{
		minutes ++;
		seconds = seconds - 60;
	}
    format(string, sizeof(string), "%d:%02d.%03d", minutes, seconds, milliseconds);
	return string;
}

forward RaceTime(raceid);
public RaceTime(raceid)
{
	RaceInfo[raceid][rTime]++;
	if(floatround((RaceInfo[raceid][rTime] / 10), floatround_floor) >= RaceInfo[raceid][rTimeout]) StopRace(raceid);
	return 1;
}

GetPlayerNameEx(playerid)
{
	new usr[MAX_PLAYER_NAME];
	GetPlayerName(playerid, usr, sizeof(usr));
	return usr;
}

StopRace(raceid)
{
	RaceInfo[raceid][rStarted] = false;
	KillTimer(RaceInfo[raceid][rTimer]);
	KillTimer(CDTimer[raceid]);
	RaceInfo[raceid][rTime] = 0;
	if(RaceInfo[raceid][rRacers] != 0)
	{
		Loop(i, MAX_PLAYERS)
		{
			if(!IsPlayerConnected(i)) continue;
			if(InRace[i] != -1) continue;
			SendClientMessage(i, -1, ""EMB_RED"[ERRORE:] "EMB_WHITE"The race ended.");
			LeaveRace(i,raceid);
		}
	}
	Loop(i, startingPos[raceid]) { FreeStart[i] = 0; }
	RaceInfo[raceid][rRacers] = 0;
	RaceInfo[raceid][rTotalRacers] = 0;
	return 1;
}

LeaveRace(playerid, raceid)
{
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), 0), SetVehicleToRespawn(GetPlayerVehicleID(playerid));
	CurrentCheck[playerid] = -1;
	InRace[playerid] = -1;
	DisablePlayerRaceCheckpoint(playerid);
	SetPlayerVirtualWorld(playerid, 0);
	if(PlayerInfo[playerid][pLoaned] != 0) DestroyVehicle(PlayerInfo[playerid][pLoaned]), PlayerInfo[playerid][pLoaned] = 0;
	RaceInfo[raceid][rRacers]--;
	KillTimer(PlayerInfo[playerid][pTDTimer]);
	Loop(td, 3) { PlayerTextDrawHide(playerid, pRaceTD[playerid][td]); }
	if(RaceInfo[raceid][rRacers] == 0) StopRace(raceid);
	TogglePlayerControllable(playerid, true);
	SetPlayerPos(playerid,2030.8905,1346.6224,10.8203);
	return 1;
}

GetRaceFreeStartingSlot(raceid)
{
	Loop(i, startingPos[raceid])
	{
		if(FreeStart[i] == 1) continue;
		else if(FreeStart[i] == 0) return i;
	}
	return -1;
}

JoinRace(playerid, raceid)
{
	if(RaceInfo[raceid][rJoinable] == false) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE" The race is not open yet!");
	if(InRace[playerid] != -1) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]" EMB_WHITE"You are already in a race, use /quitrace first");
	new start = GetRaceFreeStartingSlot(raceid);
	if(start == -1) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE" The race is full!");
	if(GetVehicleModel(GetPlayerVehicleID(playerid)) != RaceInfo[raceid][rVeh] && RaceInfo[raceid][rVeh] != -1 && GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
		if(RaceInfo[raceid][rVeh] == 0) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]" EMB_WHITE"The race is only onfoot!");
		new rstr[126];
		format(rstr,sizeof(rstr), ""EMB_GREEN"[INFO:]"EMB_WHITE" You need a(n) "EMB_ORANGE"%s"EMB_WHITE" to join in this race",VehicleNames[RaceInfo[raceid][rVeh]-400]);
		SendClientMessage(playerid, -1, rstr);
		SendClientMessage(playerid, -1, ""EMB_GREEN"[INFO:]"EMB_WHITE" We are lending you one vehicle for this race, if you buy the right car you can race with it and have it tuned!");
		new Float:X, Float:Y, Float:Z, id;
		GetPlayerPos(playerid, X,Y,Z);
		id = CreateVehicle(RaceInfo[raceid][rVeh], X, Y, Z, 0, random(125), random(125), -1);
		PlayerInfo[playerid][pLoaned] = id;
		PutPlayerInVehicle(playerid, id, 0);
	}
	if(RaceInfo[raceid][rVeh] == 0 && IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]" EMB_WHITE"The race is only onfoot!");
	if(RaceInfo[raceid][rVeh] == -1 && GetPlayerState(playerid) != PLAYER_STATE_ONFOOT && GetPlayerState(playerid) != PLAYER_STATE_PASSENGER)
	{
		new vehid = GetPlayerVehicleID(playerid);
		SetPlayerVirtualWorld(playerid, raceid+1);
		SetVehicleVirtualWorld(vehid, raceid+1);
		SetVehiclePos(vehid, RaceInfo[raceid][rStartingX][start],RaceInfo[raceid][rStartingY][start],RaceInfo[raceid][rStartingZ][start]);
		SetVehicleZAngle(vehid, RaceInfo[raceid][rStartingA][start]);
		PutPlayerInVehicle(playerid, vehid, 0);
	}
	else if(RaceInfo[raceid][rVeh] != 0 && RaceInfo[raceid][rVeh] == GetVehicleModel(GetPlayerVehicleID(playerid)))
	{
		new vehid = GetPlayerVehicleID(playerid);
		SetPlayerVirtualWorld(playerid, raceid+1);
		SetVehicleVirtualWorld(vehid, raceid+1);
		SetVehiclePos(vehid, RaceInfo[raceid][rStartingX][start],RaceInfo[raceid][rStartingY][start],RaceInfo[raceid][rStartingZ][start]);
		SetVehicleZAngle(vehid, RaceInfo[raceid][rStartingA][start]);
		PutPlayerInVehicle(playerid, vehid, 0);
	}
	else if(RaceInfo[raceid][rVeh] == 0)
	{
		SetPlayerPos(playerid, RaceInfo[raceid][rStartingX][start],RaceInfo[raceid][rStartingY][start],RaceInfo[raceid][rStartingZ][start]);
		SetPlayerVirtualWorld(playerid, raceid+1);
		SetPlayerFacingAngle(playerid, RaceInfo[raceid][rStartingA][start]);
	}
	else if(RaceInfo[raceid][rVeh] != 0 && RaceInfo[raceid][rVeh] == -1) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE" You need a personal vehicle to join this race!");
	else return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE"It was impossible to let you join the race");
	CurrentCheck[playerid] = 0;
	InRace[playerid] = raceid;
	FreeStart[start] = 1;
	new rstr[126];
	RaceInfo[raceid][rRacers] += 1;
	RaceInfo[raceid][rTotalRacers] +=1;
	format(rstr, sizeof(rstr), ""EMB_GREEN"[INFO:]"EMB_ORANGE" %s"EMB_WHITE" joined the race, wait for the race to start!", GetPlayerNameEx(playerid));
	SendRaceMessage(raceid, rstr);	
	UpdateRaceTD(playerid);
	Loop(td, 3) { PlayerTextDrawShow(playerid, pRaceTD[playerid][td]); }
	PlayerInfo[playerid][pTDTimer] = SetTimerEx("UpdateRaceTD", 1000, true, "d", playerid);
	TogglePlayerControllable(playerid, false);
	SetPlayerRaceCheckpoint(playerid, 0, RaceInfo[raceid][rCheckX][0], RaceInfo[raceid][rCheckY][0], RaceInfo[raceid][rCheckZ][0], RaceInfo[raceid][rCheckX][1], RaceInfo[raceid][rCheckY][1],RaceInfo[raceid][rCheckZ][1], 10);
	return 1;
}