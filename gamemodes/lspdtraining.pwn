// -------------------------------------------------------
//      LSPD - Training | GM Sviluppata interamente da Maxel 
//      Si ringrazia enom e Nikola aka Sh4ark per alcuni Map.
//      Sito Web Sviluppatore: iMaxel.net
//      2015 - Ultima modifica: Gennaio 2015
// -------------------------------------------------------

#pragma tabsize 0

#include <a_samp>
#include <streamer>
#include <core>
#include <float>
#include <zcmd>
#include <sscanf2>



//#include "../include/gl_common.inc"


// -------------------------------------------------------

// PRESSED(keys)
#define PRESSED(%0) \
(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

// RELEASED(keys)
#define RELEASED(%0) \
(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))


// -------------------------------------------------------

#define GM_SVILUPPATORE "Maxel"
#define GM_RIGHE "3800"
#define GM_VERSION "1.0"
#define GM_TEXTVERSION "PD Training 1.0"
#define GM_LASTUPDATE "25 Gennaio 2015"

// -------------------------------------------------------

#define ADMINFS_MESSAGE_COLOR 0xFF444499
#define PM_INCOMING_COLOR     0xFFFF22AA
#define PM_OUTGOING_COLOR     0xFFCC2299
#define COLOR_ORANGE 0xF97804FF // arancione
#define COLOR_ORANGELIGHT 0xFAA26BFF // arancione chiaro
#define COLOR_ORANGECHAT 0xEBC4ABFF // arancione chat
#define COLOR_AZZURRO 0x99FFFFAA // azzurro
#define COLOR_GRAD1 0xCECECEFF // grigio chiaro
#define COLOR_WHITE 0xFFFFFFFF // bianco
#define COLOR_BLUE 0x00C2ECFF // blu chiaro
#define COLOR_RED 0xE60000FF // rosso
#define COLOR_REDLIGHT 0xEBABABFF // rosso chat
#define COLOR_VIOLA 0xB360FDFF // viola
#define COLOR_ACTION 0xADFF2FAA // azioni /me /do
#define COLOR_GIALLO 0xFFFF00AA // giallo megafono
#define COLOR_AME 0xC2A2DAAA // ame
#define COLOR_GREEN 0x21DD00FF // verde
#define COLOR_VEHFIX 0xD1AE4FFF // Veh Fix

// -------------------------------------------------------

#define DIALOG_REJECT 1
#define DIALOG_ACCESS 2

#define DIALOG_LOGIN_ACCADEMICO 3
#define DIALOG_LOGIN_AGENTE 4
#define DIALOG_LOGIN_ISTRUTTORE 5

#define DIALOG_ARMI 6
#define DIALOG_MUNIZIONI 7
#define DIALOG_ONDUTY 8

#define ADMIN_SPEC_TYPE_NONE 0
#define ADMIN_SPEC_TYPE_PLAYER 1
#define ADMIN_SPEC_TYPE_VEHICLE 2

#define BODY_PART_HEAD 9

// -------------------------------------------------------

new pswAccademico[64]; 
new pswAgente[64]; 
new pswIstruttore[64]; 

// -------------------------------------------------------

#define MAX_ROADBLOCKS 300
#define MAX_COORDS 200
#define PICKUP_FILE_NAME "Pickups.txt"
#define LABEL_FILE_NAME "Labels.txt"
#define PSWACCADEMICO_FILE_NAME "PasswordAccademico.txt"
#define PSWAGENTE_FILE_NAME "PasswordAgente.txt"
#define PSWISTRUTTORE_FILE_NAME "PasswordIstruttore.txt"

// -------------------------------------------------------

#pragma tabsize 0

enum rInfo
{
	sCreated,
	Float:sX,
	Float:sY,
	Float:sZ,
	sObject,
	sSpike
};


new Roadblocks[MAX_ROADBLOCKS][rInfo];

// -------------------------------------------------------

new bool:Simulazione;
new bool:CarSpawn;
new bool:zonaAddestramento;
new bool:zonaRiot;
new bool:TeamKill = false;
new bool:ElevatorStatus = false;
new Text:sim, Text:Textdraw0, Text:Textdraw1, Text:txt;
new bool:ScriptObject[MAX_OBJECTS];
new bool:ScriptVehicle[MAX_VEHICLES];
new pRank[MAX_PLAYERS]; // 1 accademico - 2 agente lspd - 3 istruttore
new pSwat[MAX_PLAYERS];
new pRiot[MAX_PLAYERS];
new pSkin[MAX_PLAYERS];
new bool:pLogged[MAX_PLAYERS];
new caselev; // ID Oggetto Ascensore
new pTazed[MAX_PLAYERS];
new pTazer[MAX_PLAYERS];
new wepid[MAX_PLAYERS];

new Text:txtTimeDisp;
new hour, minute;
new timestr[32];
new fine_weather_ids[] = {1,2,3,4,5,6,7,12,13,14,15,17,18,24,25,26,27,28,29,30,40};
new foggy_weather_ids[] = {9,19,20,31,32};
new wet_weather_ids[] = {8};
forward UpdateTimeAndWeather();

new gSpectateID[MAX_PLAYERS];
new gSpectateType[MAX_PLAYERS];

new Text3D:vehicle3Dtext[MAX_VEHICLES];

new VehicleName[][] = {  
	"Landstalker",  "Bravura",  "Buffalo",  "Linerunner",  "Perennial",  "Sentinel",  "Dumper",  "Firetruck",  "Trashmaster",  "Stretch",  "Manana",  "Infernus",  "Voodoo",  "Pony",  "Mule",  "Cheetah",  
	"Ambulance",  "Leviathan",  "Moonbeam",  "Esperanto",  "Taxi",  "Washington",  "Bobcat",  "MrWhoopee",  "BFInjection",  "Hunter",  "Premier",  "Enforcer",  "Securicar",  "Banshee",  "Predator",  "Bus",  
	"Rhino",  "Barracks",  "Hotknife",  "Trailer",  "Previon",  "Coach",  "Cabbie",  "Stallion",  "Rumpo",  "RCBandit",  "Romero",  "Packer",  "Monster",  "Admiral",  "Squalo",  "Seasparrow",  "Pizzaboy",  
	"Tram",  "Trailer",  "Turismo",  "Speeder",  "Reefer",  "Tropic",  "Flatbed",  "Yankee",  "Caddy",  "Solair",  "RCVan",  "Skimmer",  "PCJ600",  "Faggio",  "Freeway",  "RCBaron",  "RCRaider",  "Glendale",  
	"Oceanic",  "Sanchez",  "Sparrow",  "Patriot",  "Quad",  "Coastguard",  "Dinghy",  "Hermes",  "Sabre",  "Rustler",  "ZR350",  "Walton",  "Regina",  "Comet",  "BMX",  "Burrito",  "Camper",  "Marquis",  
	"Baggage",  "Dozer",  "Maverick",  "NewsChopper",  "Rancher",  "FBIRancher",  "Virgo",  "Greenwood",  "Jetmax",  "Hotring",  "Sandking",  "BlistaCompact",  "PoliceMaverick",  "Boxville",  "Benson",  
	"Mesa",  "RCGoblin",  "HotringA",  "HotringB",  "BloodringBanger",  "Rancher",  "SuperGT",  "Elegant",  "Journey",  "Bike",  "MountainBike",  "Beagle",  "Cropdust",  "Stunt",  "Tanker",  "RoadTrain",  
	"Nebula",  "Majestic",  "Buccaneer",  "Shamal",  "Hydra",  "FCR900",  "NRG500",  "HPV1000",  "CementTruck",  "TowTruck",  "Fortune",  "Cadrona",  "FBITruck",  "Willard",  "Forklift",  "Tractor",  
	"Combine",  "Feltzer",  "Remington",  "Slamvan",  "Blade",  "Freight",  "Streak",  "Vortex",  "Vincent",  "Bullet",  "Clover",  "Sadler",  "Firetruck",  "Hustler",  "Intruder",  "Primo",  "Cargobob",  
	"Tampa",  "Sunrise",  "Merit",  "Utility",  "Nevada",  "Yosemite",  "Windsor",  "MonsterA",  "MonsterB",  "Uranus",  "Jester",  "Sultan",  "Stratum",  "Elegy",  "Raindance",  "RCTiger",  "Flash",  "Tahoma", 
	"Savanna",  "Bandito",  "Freight",  "Trailer",  "Kart",  "Mower",  "Duneride",  "Sweeper",  "Broadway",  "Tornado",  "AT400",  "DFT30",  "Huntley",  "Stafford",  "BF400",  "Newsvan",  "Tug",  "Trailer",  
	"Emperor",  "Wayfarer",  "Euros",  "Hotdog",  "Club",  "Trailer",  "Trailer",  "Andromada",  "Dodo",  "RCCam",  "Launch",  "LSPD",  "SFPD",  "LVPD",  "PoliceRanger",  "Picador",  "SWAT",  "Alpha",  
	"Phoenix",  "Glendale",  "Sadler",  "Trailer1",  "Trailer2",  "Trailer3",  "Boxville",  "FarmPlow",  "UtilityTrailer" };

//new rapinacp[256];

// -------------------------------------------------------

	forward PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z);
	forward Tazed(playerid);
	forward DelayedKick(playerid);

#if defined FILTERSCRIPT

// ====================================================================
// Caricamento FilterScript

	public OnFilterScriptInit()
	{
		print("\n--------------------------------------");
		print(" PD Training (2015) - Scriptato da Maxel");
		print(" Powered by www.iMaxel.net");
		print(" -- GAMEMODE CARICATA CON SUCCESSO! --");
		print("--------------------------------------\n");

		return 1;


	}

// ====================================================================
// Chiusura Filterscript

	public OnFilterScriptExit()
	{
		return 1;
	}

#else

	main()
	{
		print("\n--------------------------------------");
		print(" PD Training (2015) - Scriptato da Maxel");
		print(" Powered by www.iMaxel.net");
		print(" -- GAMEMODE CARICATA CON SUCCESSO! --");
		print("--------------------------------------\n");
	}

#endif

// ====================================================================
// ATTIVAZIONE DELLA GAMEMODE...

	public OnGameModeInit()
	{
		SetGameModeText(GM_TEXTVERSION);
		ShowPlayerMarkers(0);
		DisableInteriorEnterExits();
		ShowNameTags(1);
		EnableStuntBonusForAll(0);

	//pswAccademico = "jackson400";
    //pswAgente = "officer99";
    //pswIstruttore = "istruttore555";
		
		pswAccademico = PasswordFromFile(PSWACCADEMICO_FILE_NAME);
		pswAgente = PasswordFromFile(PSWAGENTE_FILE_NAME);
		pswIstruttore = PasswordFromFile(PSWISTRUTTORE_FILE_NAME);

		zonaAddestramento = false;
		zonaRiot = false;
		Simulazione = true;

	// --------- Caricamenti ------------
		
		AggiungiTextDraw();
		AddPickupFromFile(PICKUP_FILE_NAME);
		AddLabelsFromFile(LABEL_FILE_NAME);
		AggiungiVeicoli();
		AggiungiPersonalPickupAndLabel();
		AggiungiClassi();
		AggiungiMapElevatorPD();
		TargheVeicoli();

		return 1;
	}


// ====================================================================
// CHIUSURA DELLA GAMEMODE

	public OnGameModeExit()
	{
		return 1;
	}

// ====================================================================
// PLAYER SI CONNETTE

	public OnPlayerConnect(playerid)
	{

		gettime(hour, minute);
		SetPlayerTime(playerid,hour,minute);	

		TextDrawShowForPlayer(playerid, txt);
		if(Simulazione==true){
			TextDrawShowForPlayer(playerid, sim);
		}else{
			TextDrawHideForPlayer(playerid, sim);
		}

		
		SetPlayerColor(playerid, COLOR_GRAD1);
		pTazed[playerid] = 0;
		pTazer[playerid] = 0;
		pSkin[playerid] = 71;

		NameCheck(playerid);
		RimuoviBuilding(playerid);


		new musicaRandom = random(5);
		
		switch(musicaRandom)
		{
			case 0:
			{
				PlayAudioStreamForPlayer(playerid, "https://dl.dropboxusercontent.com/u/27041844/getlucky.mp3");
			}
			case 1:
			{
				PlayAudioStreamForPlayer(playerid, "https://dl.dropboxusercontent.com/u/27041844/whycall.mp3");
			}
			case 2:
			{
				PlayAudioStreamForPlayer(playerid, "https://dl.dropboxusercontent.com/u/27041844/anotherbrick1.mp3");
			}
			case 3:
			{
				PlayAudioStreamForPlayer(playerid, "https://dl.dropboxusercontent.com/u/27041844/sultans.mp3");
			}
			case 4:
			{
				PlayAudioStreamForPlayer(playerid, "https://dl.dropboxusercontent.com/u/27041844/timetopretend.mp3");
			}
		}

		new str[128];
		format(str, 128, "%s � entrato nel server.", NameRP(playerid));
		SendClientMessageToAll(COLOR_GREEN, str);

		clearChat(playerid, 25);
		SendClientMessage(playerid, 0xB3C725FF, "_________________________________________________________________");
		SendClientMessage(playerid, 0xFF8000FF, "Ca{FCB81B}ric{FFFF00}a{BBE124}me{00FF00}nto..{00FFFF}.");
		SendClientMessage(playerid, 0xB3C725FF, "_________________________________________________________________");
		return 1;
	}

// ====================================================================
// PLAYER RICHIEDE CLASSE

	public OnPlayerRequestClass(playerid, classid)
	{

		TextDrawShowForPlayer(playerid, Textdraw0);
		TextDrawShowForPlayer(playerid, Textdraw1);

		if(pLogged[playerid]==false){

			new infoTraining[128], infoLastUpdate[128];
			format(infoTraining, 128, "Righe della Gamemode: %s | Versione: %s", GM_RIGHE, GM_VERSION);
			format(infoLastUpdate, 128, "Ultimo update: %s", GM_LASTUPDATE);

			clearChat(playerid, 30);
			SendClientMessage(playerid, 0xB3C725FF, "___________________[Informazioni]___________________");
			SendClientMessage(playerid, 0xFF8000FF, "Cre{FCB81B}a{FFFF00}tor{BBE124}e Gam{00FF00}emode:{FFFFFF} Maxel");
			SendClientMessage(playerid, 0xCECECEFF, infoTraining);
			SendClientMessage(playerid, 0xCECECEFF, infoLastUpdate);
			SendClientMessage(playerid, 0xF97804FF, "Per info sul server usa /crediti e per i comandi usa /aiuto ");
			SendClientMessage(playerid, 0xB3C725FF, "____________________________________________________"); 	

			new cameraRandom = random(4);

			switch(cameraRandom)
			{
				case 0:
				{
					InterpolateCameraPos(playerid, 1342.7703,-1379.3030,132.3936, 817.9200,-1028.4723,115.5088, 60000, CAMERA_MOVE);
				}
				case 1:
				{
					InterpolateCameraPos(playerid, 614.0995,-1220.8635,98.2265, 395.8842,-1711.8972,72.4119, 60000, CAMERA_MOVE);
				}
				case 2:
				{
					InterpolateCameraPos(playerid, 1107.7620,-2063.3333,104.6443, 1506.7935,-1706.2725,53.5407, 60000, CAMERA_MOVE);
				}
				case 3:
				{
					InterpolateCameraPos(playerid, 2056.0046,-1818.9824,51.7968, 2459.2952,-1662.2765,46.2366, 60000, CAMERA_MOVE);
				}
			}

			ShowPlayerDialog(playerid, DIALOG_ACCESS, DIALOG_STYLE_LIST, "Seleziona la modalit� di accesso", "Accademico\nAgente\nIstruttore", "Seleziona", "Esci");
			
		}else if(pLogged[playerid]==true){

			ApplyAnimation(playerid, "ON_LOOKERS", "wave_loop", 4.0, 1, 0, 0, 0, 0, 0);
			SetPlayerFacingAngle(playerid, 90);
			SetPlayerPos(playerid, 1553.4167,-1675.6750,16.1953);
			SetPlayerCameraPos(playerid, 1544.2543,-1675.8698,17.3803);
			SetPlayerCameraLookAt(playerid, 1544.2543,-1675.8698,17.3803);
		}

		return 1;
	}


// ====================================================================
// PLAYER SI DISCONETTE

	public OnPlayerDisconnect(playerid, reason)
	{
		pLogged[playerid] = false;
		pSkin[playerid] = false; 

		new DisconnectReason[3][] =
		{
			"[Crash]",
			"",
			"[Kick/Ban]"
		};

		new str[128];


		format(str, 128, "%s � uscito dal server%s.", NameRP(playerid), DisconnectReason[reason]);
		SendClientMessageToAll(COLOR_RED, str);
		return 1;
	}

// ====================================================================
// PLAYER SPAWNA

	public OnPlayerSpawn(playerid)
	{
		TextDrawShowForPlayer(playerid,txtTimeDisp);
		gettime(hour, minute);
		SetPlayerTime(playerid,hour,minute);

		TextDrawHideForPlayer(playerid, Textdraw0);
		TextDrawHideForPlayer(playerid, Textdraw1);
		StopAudioStreamForPlayer(playerid);

 // -------------- PLAYERTEAM --------------

		if(pRank[playerid]==1){
			SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid, 1837.1801,-1866.4897,13.3828);
			SetPlayerSkin(playerid, 71);
			GivePlayerWeapon(playerid, 3, 1);
			GivePlayerWeapon(playerid, 22, 999999);
			GivePlayerWeapon(playerid, 41, 999999);
			SetPlayerArmour(playerid,100);
		}else{


			if(GetPlayerTeam(playerid) == 1){
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, 1837.1801,-1866.4897,13.3828);
				SetPlayerSkin(playerid, pSkin[playerid]);
				GivePlayerWeapon(playerid, 5, 1);
				GivePlayerWeapon(playerid, 24, 999999);
				GivePlayerWeapon(playerid, 28, 999999);
				GivePlayerWeapon(playerid, 30, 999999);
				SetPlayerArmour(playerid,0);

			}else if(GetPlayerTeam(playerid) == 0 && pSwat[playerid] == 1){

				SetPlayerInterior(playerid, 0);
				GivePlayerWeapon(playerid, 4, 1);
				GivePlayerWeapon(playerid, 24, 99999);
				GivePlayerWeapon(playerid, 34, 99999);
				GivePlayerWeapon(playerid, 27, 99999);
				GivePlayerWeapon(playerid, 31, 99999);
				GivePlayerWeapon(playerid, 17, 999999);
				GivePlayerWeapon(playerid, 29, 999999);
				SetPlayerArmour(playerid,100);
				SetPlayerSkin(playerid,285);
				pSkin[playerid] = 285;

			}else if(GetPlayerTeam(playerid) == 0 && pRiot[playerid] == 1){

				SetPlayerInterior(playerid, 0);
				GivePlayerWeapon(playerid, 3, 1);
				GivePlayerWeapon(playerid, 41, 999999);
				GivePlayerWeapon(playerid, 17, 999999);
				GivePlayerWeapon(playerid, 24, 999999);
				GivePlayerWeapon(playerid, 25, 999999);
				SetPlayerArmour(playerid,100);
				SetPlayerSkin(playerid,284);
				pSkin[playerid] = 284;	    

			}else if(GetPlayerTeam(playerid) == 0 && pSwat[playerid] == 0){

				SetPlayerInterior(playerid, 0);
				GivePlayerWeapon(playerid, 3, 1);
				GivePlayerWeapon(playerid, 24, 999999);
				GivePlayerWeapon(playerid, 25, 999999);
				GivePlayerWeapon(playerid, 29, 999999);
				GivePlayerWeapon(playerid, 31, 999999);
				SetPlayerArmour(playerid,100);
				SetPlayerSkin(playerid, pSkin[playerid]);
				
			}else{
				SetPlayerInterior(playerid, 0);
				SetPlayerTeam(playerid, 0);
				SetPlayerSkin(playerid, pSkin[playerid]);
			}

		}	

// -------------- PLAYER RANK --------------

		if(pRank[playerid] == 1)	{
			SetPlayerColor(playerid, COLOR_GIALLO);

		}else if(pRank[playerid] == 2)	{
			SetPlayerColor(playerid, COLOR_GRAD1);

		}else if(pRank[playerid] == 3)	{
			SetPlayerColor(playerid, COLOR_ORANGE);
		}

		if(IsPlayerAdmin(playerid))	{
			SetPlayerColor(playerid, COLOR_VIOLA);
		}
		
		SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 10);
		return 1;
	}

// ====================================================================
// PLAYER MUORE

	public OnPlayerDeath(playerid, killerid, reason)
	{

		TextDrawHideForPlayer(playerid,txtTimeDisp);

		if(killerid != INVALID_PLAYER_ID)
		{
			SetPlayerScore(killerid, GetPlayerScore(killerid) + 1);
		}

		if(GetPlayerTeam(playerid) == GetPlayerTeam(killerid)){
			SendDeathMessage(killerid, playerid, reason);
		} else {
			SendDeathMessage(killerid, playerid, reason);
		}
		
  	// ELIMINA OGGETTI INDOSSO
		
		for(new i=0; i<MAX_PLAYER_ATTACHED_OBJECTS; i++)
		{
			if(IsPlayerAttachedObjectSlotUsed(playerid, i)) RemovePlayerAttachedObject(playerid, i);
		}
		
		return 1;
	}

// ====================================================================
// SPAWN DEI VEICOLI

	public OnVehicleSpawn(vehicleid)
	{
		return 1;
	}

// ====================================================================
// MUORE IL VEICOLO

	public OnVehicleDeath(vehicleid, killerid)
	{
		return 1;
	}

// ====================================================================
// IL PLAYER SCRIVE

	public OnPlayerText(playerid, text[])
	{
		if(Simulazione==true){

			new string[600];
			format(string, sizeof(string), "%s dice: %s", NameRP(playerid), text);
			SendLocalMessage(playerid, string, 10.0, COLOR_WHITE, COLOR_GRAD1);
	//SetPlayerChatBubble(playerid, text, COLOR_WHITE, 10.0, 7000);

		}
		else{
			return 1;
		}

		return 0;
	}

// ====================================================================
// PLAYER IMMETTE UN COMANDO

/*
public OnPlayerCommandText(playerid, cmdtext[])
{

	new tmp[256], idx, cmd[256];
	tmp = strtok(cmdtext, idx);
*/



// =========================================================== Comandi Admin ===========================================================



	COMMAND:simulazione(playerid, params[])
	{

		if(IsPlayerAdmin(playerid) || pRank[playerid] >= 3)
		{
			if(Simulazione == true){
				Simulazione = false;
				SendClientMessageToAll(COLOR_GIALLO, "[SERVER] La simulazione roleplay � stata disattivata.");
				TextDrawHideForAll(sim);
			}
			else{
				Simulazione = true;
				SendClientMessageToAll(COLOR_GIALLO, "[SERVER] La simulazione roleplay � stata attivata e con essa i comandi roleplay.");
				TextDrawShowForAll(sim);
			}
		}

		return 1;
	}
	
	

	COMMAND:teamkill(playerid, params[])
	{

		if(IsPlayerAdmin(playerid) || pRank[playerid] >= 3)
		{
			if(TeamKill == true){
				TeamKill = false;
				SendClientMessageToAll(COLOR_GIALLO, "[SERVER] Il team kill � stato disabilitato.");
			}
			else{
				TeamKill = true;
				SendClientMessageToAll(COLOR_GIALLO, "[SERVER] Il team kill � stato abilitato, ora � possibile uccidersi anche se si � dello stesso team.");
			}
		}

		return 1;
	}


	CMD:pm(playerid, params[])
	{
		new str[256], str2[256], id;
		if(sscanf(params, "us", id, str2))
		{
			SendClientMessage(playerid, -1, "[Uso] /pm <id> <testo>");
			return 1;
		}
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "[Errore] Il player non � connesso.");
		if(playerid == id) return SendClientMessage(playerid, -1, "[Errore] Non puoi mandare un PM a te stesso.");
		{
			format(str, sizeof(str), "PM a %s (%d): %s", NameRP(playerid), id, str2);
			SendClientMessage(playerid, PM_OUTGOING_COLOR, str);
			format(str, sizeof(str), "PM da %s (%d): %s", NameRP(id), playerid, str2);
			SendClientMessage(id, PM_INCOMING_COLOR, str);
		}
		return 1;
	}


	CMD:kick(playerid, params[])
	{
		new targetid, string[256], reason[128];
		if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, -1,"[Errore] Non sei un amministratore.");
		if(sscanf(params,"is", targetid, reason)) return SendClientMessage(playerid, -1,"[Uso] /kick <id> <motivo>");
		if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1,"[Errore] ID invalido.");
		if(IsPlayerAdmin(targetid)) return SendClientMessage(playerid, -1,"[Errore] Non puoi kickare un amministratore.");
		format(string, sizeof(string),"[ADMIN] %s ha kickato %s dal server. Motivo: %s", NameRP(playerid), NameRP(targetid), reason);
		SendClientMessageToAll(ADMINFS_MESSAGE_COLOR, string);
		Kick(targetid);
		return 1;
	}


	CMD:ban(playerid, params[])
	{
		new targetid, string[256], reason[128];
		if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, -1,"[Errore] Non sei un amministratore.");
		if(sscanf(params,"is", targetid, reason)) return SendClientMessage(playerid, -1,"[Uso] /ban <id> <motivo>");
		if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1,"[Errore] ID invalido.");
		if(IsPlayerAdmin(targetid)) return SendClientMessage(playerid, -1,"[Errore] Non puoi bannare un amministratore.");
		format(string, sizeof(string),"[ADMIN] %s ha bannato %s dal server. Motivo: %s", NameRP(playerid), NameRP(targetid), reason);
		SendClientMessageToAll(ADMINFS_MESSAGE_COLOR, string);
		Ban(targetid);
		return 1;
	}


	CMD:adminduty(playerid, params[])
	{
		if(IsPlayerAdmin(playerid))
		{
			new str[128];
			format(str, 128, "L'admin %s � ora in servizio. Utilizza /pm per contattarlo.", NameRP(playerid));
			SendClientMessageToAll(0xB360FDFF, str);
		}
		
		return 1;
	}
	
	
	CMD:iduty(playerid, params[])
	{
		if(pRank[playerid]>=3)
		{
			new str[128];
			format(str, 128, "L'istruttore %s � ora in servizio. Utilizza /pm per contattarlo.", NameRP(playerid));
			SendClientMessageToAll(COLOR_ORANGELIGHT, str);
		}

		return 1;
	}
	
	CMD:a(playerid, params[])
	{
		if(pRank[playerid] >= 3){
			new testo[128], string[128];
			if(sscanf(params,"s", testo)) return SendClientMessage(playerid, -1,"[Uso] /a <mex chat istruttori>");
			format(string, sizeof(string), "[CHAT ADMIN] %s: %s", NameRP(playerid), testo);
			SendAdminMessage(COLOR_ORANGECHAT, string);
		}
		return 1;
	}
	
	
	CMD:rimuoviogg(playerid, params[])
	{
		for(new i=0; i<MAX_PLAYER_ATTACHED_OBJECTS; i++)
		{
			if(IsPlayerAttachedObjectSlotUsed(playerid, i)) RemovePlayerAttachedObject(playerid, i);
			GameTextForPlayer(playerid, "~b~Oggetti indosso ~w~rimossi", 1500, 5);
		}
		return 1;
	}


	CMD:minigun(playerid, params[])
	{
		if(IsPlayerAdmin(playerid) || pRank[playerid]>=3)
		{
			GivePlayerWeapon(playerid, 38, 99999999);
			SendClientMessage(playerid, COLOR_ORANGE, "Ti sei givvato un minigun");
		}
		return 1;
	}

	CMD:icmds(playerid, params[])
	{
		if(pRank[playerid]>=3)
		{
			SendClientMessage(playerid, 0xFFFFFFFF, " ");
			SendClientMessage(playerid, COLOR_GRAD1, "_____________________[ Comandi Istruttori ] ____________________");
			SendClientMessage(playerid, COLOR_GIALLO, "[GLOBALE] /simulazione (roleplay) - /carspawn (abilita o meno /car) - /teamkill");
			SendClientMessage(playerid, COLOR_ORANGE, "[ISTRUTTORE] /iduty - /a (adminchat) - /n (global chat) - /god - /minigun - /jetpack");
			SendClientMessage(playerid, COLOR_ORANGE, "[ISTRUTTORE] /kick - /ban - /reconplayer - /reconveicolo - /reconoff - /setskin");
			SendClientMessage(playerid, COLOR_ORANGE, "[ISTRUTTORE] /goto - /gethere - /(un)freeze - /(un)freezeall - /setadd(sparatoria/riot) - /resetadd");             
			SendClientMessage(playerid, COLOR_ORANGELIGHT, "[AUTO] /respawncars (non occupate) - /respawnallcars (tutte)");
			SendClientMessage(playerid, COLOR_ORANGELIGHT, "[AUTO] /removecar (dentro veicolo) /removeid (id veicolo) - /deleteallcars (rimuove tutte le /car)");
			SendClientMessage(playerid, COLOR_ORANGELIGHT, "[AUTO SPECIALI] /cargang - /carsultan - /carnormal - /carsuper - /carpd");   
			if(IsPlayerAdmin(playerid)) SendClientMessage(playerid, COLOR_VIOLA, "[ADMIN] /adminduty - /maphelp - /rconcmds");
			SendClientMessage(playerid, COLOR_GRAD1, "________________________________________________________________");
		}
		return 1;
	}
	
	
	CMD:rconcmds(playerid, params[])
	{
		if(IsPlayerAdmin(playerid))
		{
			SendClientMessage(playerid, 0xFFFFFFFF, " ");
			SendClientMessage(playerid, COLOR_GRAD1, "____________________[ Rcon Comandi  ] ____________________");
			SendClientMessage(playerid, 0x00C2ECFF, " /rcon cmdlist - Mostra la lista di tutti i comandi. ");
			SendClientMessage(playerid, 0x00C2ECFF, " /rcon varlist - Mostra la lista con le variabili correnti.");
			SendClientMessage(playerid, 0x00C2ECFF, " /rcon exit - Chiude il server.");
			SendClientMessage(playerid, 0x00C2ECFF, " /rcon echo [messaggio] - Mostra il messaggio nella console.");
			SendClientMessage(playerid, 0x00C2ECFF, " /rcon hostname [nome] - Cambia il nome del server.");
			SendClientMessage(playerid, 0x00C2ECFF, " /rcon gamemodetext [nome] - Cambia il nome della GM.");
			SendClientMessage(playerid, 0x00C2ECFF, " /rcon mapname [nome] - Cambia il nome della mappa.");
			//	SendClientMessage(playerid, 0x00C2ECFF, " /rcon exec [filename] - Esegue un determinato file .cfg.");
			SendClientMessage(playerid, 0x00C2ECFF, " /rcon kick [ID] - Kicka un player.");
			SendClientMessage(playerid, 0x00C2ECFF, " /rcon ban [ID] - Banna un player.");
			//	SendClientMessage(playerid, 0x00C2ECFF, " /rcon changemode [mode] - Cambia GM.");
			SendClientMessage(playerid, 0x00C2ECFF, " /rcon gmx - Ricarica la Gamemod.");
			SendClientMessage(playerid, 0x00C2ECFF, " /rcon reloadbans - Resetta il file ban.");
			SendClientMessage(playerid, 0x00C2ECFF, " /rcon reloadlog - Resetta i log.");
			SendClientMessage(playerid, 0x00C2ECFF, " /rcon say - Scrive un messaggio con nick 'Admin:' .");
			SendClientMessage(playerid, 0x00C2ECFF, " /rcon players - Mostra nick, IP e ping di tutti i players.");
			SendClientMessage(playerid, 0x00C2ECFF, " /rcon banip [IP] - Banna un determinato IP.");
			SendClientMessage(playerid, 0x00C2ECFF, " /rcon unbanip [IP] - Sbanna un determinato IP.");
			//	SendClientMessage(playerid, 0x00C2ECFF, " /rcon gravity - Cambia la gravit� - normale: 0.008 ");
			SendClientMessage(playerid, 0x00C2ECFF, " /rcon weather [ID] - Cambia il meteo.");
			SendClientMessage(playerid, 0x00C2ECFF, " /rcon loadfs - Carica un Filterscript. ");
			SendClientMessage(playerid, 0x00C2ECFF, " /rcon unloadfs - Annulla tutti i FS.");
			SendClientMessage(playerid, 0x00C2ECFF, " /rcon reloadfs - Ricarica tutti i FS.");
			SendClientMessage(playerid, 0x00C2ECFF, " /rcon password [PASSWORD] - Chiude il server con una password.");
			SendClientMessage(playerid, COLOR_GRAD1, "_________________________________________________________");
		}
		return 1;
	}
	

	CMD:god(playerid, params[])
	{
		if(IsPlayerAdmin(playerid) || pRank[playerid]>=3)
		{
			SetPlayerHealth(playerid, 9999999);
			SetPlayerArmour(playerid, 9999999);
			SetPlayerAttachedObject(playerid,1,19142,1,0.1,0.05,0.0,0.0,0.0,0.0);
			SendClientMessage(playerid, COLOR_ORANGE, "Godmode attivata (vita e armatura infinita).");
		}
		return 1;
	}
	
	CMD:jetpack(playerid, params[])
	{
		if(IsPlayerAdmin(playerid) || pRank[playerid]>=3)
		{
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
			SendClientMessage(playerid, COLOR_ORANGE, "Ti sei givvato un jetpack.");
		}
		return 1;
	}
	
	CMD:setaddsparatoria(playerid, params[])
	{
		if(IsPlayerAdmin(playerid) || pRank[playerid]>=3)
		{

			if(zonaAddestramento == false){

				AddestramentoSparatoria();
				zonaAddestramento = true;				
				SendClientMessageToAll(COLOR_RED, "[MAPPING] L'addestramento scontro a fuoco � ora disponibile. Digita /addsparatoria per gotarvici. ");

			}else{
				SendClientMessage(playerid, COLOR_WHITE, "[Errore] L'addestramento scontro a fuoco a El Corona � gi� stato creato. Per rimuovere gli tutti gli objects digita /resetadd.");
			}

		}

		return 1;
	}

	CMD:setaddriot(playerid, params[])
	{
		if(IsPlayerAdmin(playerid) || pRank[playerid]>=3)
		{

			if(zonaRiot == false){

				AddestramentoRiot();
				zonaRiot = true;				
				SendClientMessageToAll(COLOR_RED, "[MAPPING] L'addestramento riot antisommossa � ora disponibile. Digita /addriot per gotarvici. ");

			}else{
				SendClientMessage(playerid, COLOR_WHITE, "[Errore] L'addestramento riot antisommossa a East Beach � gi� stato creato. Per rimuovere gli tutti gli objects digita /resetadd.");
			}

		}

		return 1;
	}


	CMD:resetadd(playerid, params[])
	{
		if(IsPlayerAdmin(playerid) || pRank[playerid]>=3)
		{
			if(zonaAddestramento == true || zonaRiot == true){
				DestroyScriptObjects();
				zonaAddestramento = false;
				zonaRiot = false;
				SendClientMessageToAll(COLOR_RED, "[MAPPING] Tutti i mapping aggiuntivi degli addestramenti sono stati resettati.");
			}else{ 
				SendClientMessage(playerid, COLOR_WHITE, "[Errore] Non c'� nessun addestramento da rimuovere.");
			}

		}

		return 1;
	}	

	CMD:maphelp(playerid, params[])
	{
		if(IsPlayerAdmin(playerid))
		{
			SendClientMessage(playerid, 0xFFFFFFFF, " ");
			SendClientMessage(playerid, COLOR_WHITE, "_____________________[ Aiuto Server ]__________________");
			SendClientMessage(playerid, COLOR_GRAD1, "Se hai i seguenti problemi: ");
			SendClientMessage(playerid, COLOR_GRAD1, "- Non si vedono le mappe");
			SendClientMessage(playerid, COLOR_GRAD1, "- Non si vedono i veicoli");
			SendClientMessage(playerid, COLOR_WHITE, "________________________________________________________");
			SendClientMessage(playerid, COLOR_GRAD1, "Procedi in questa maniera.. digita /rcon realodfs mappe");
			SendClientMessage(playerid, COLOR_WHITE, "________________________________________________________");
		}

		return 1;
	}

	CMD:respawnallcars(playerid, params[])
	{
		if(IsPlayerAdmin(playerid) || pRank[playerid]>=3)
		{

			for(new i = 0; i < MAX_VEHICLES; i++)
			{
				SetVehicleToRespawn(i);
			}
			SendClientMessageToAll(COLOR_REDLIGHT, "[SERVER] Tutti i veicoli sono stati respawnati.");
		}

		return 1;
	}

	CMD:respawncars(playerid, params[])
	{
		if (IsPlayerAdmin(playerid) || pRank[playerid]>=3)
		{
			for(new i=0;i<MAX_VEHICLES;i++)
			{
				if(IsVehicleOccupied(i) == 0)
				{
					SetVehicleToRespawn(i);
				}
			}
			SendClientMessageToAll(COLOR_REDLIGHT, "[SERVER] Tutti i veicoli non occupati sono stati respawnati.");

		}
		return 1;
	}
	
	CMD:deleteallcars(playerid, params[])
	{
		if(IsPlayerAdmin(playerid) || pRank[playerid]>=3)
		{
			DestroyScriptVehicles();
			SendClientMessageToAll(COLOR_RED, "[SERVER] Tutti i veicoli creati con /car sono stati rimossi.");
		}
		return 1;
	}


	CMD:removecar(playerid, params[]) // Disponibile anche agli utenti
	{
		if(!IsPlayerInAnyVehicle(playerid)) SendClientMessage(playerid, -1, "[Errore] Devi essere in un veicolo per poterlo rimuovere.");
		
		if(Simulazione == false){
			DestroyVehicle(GetPlayerVehicleID(playerid));
			SendClientMessage(playerid, COLOR_ORANGE, "Hai eliminato questo veicolo.");
		}else{
			if(IsPlayerAdmin(playerid)){
				DestroyVehicle(GetPlayerVehicleID(playerid));
				SendClientMessage(playerid, COLOR_ORANGE, "Hai eliminato questo veicolo.");
			}else{
				ErroreSim(playerid);
			}
		}
		return 1;
	}


	CMD:removeid(playerid, params[])
	{
		if(IsPlayerAdmin(playerid) || pRank[playerid] >= 3)
		{
			new carid;
			if(sscanf(params,"i", carid)) return SendClientMessage(playerid, -1,"[Uso] /removeid <car id>");
			DestroyVehicle(carid);
			SendClientMessage(playerid, COLOR_ORANGE, "Hai eliminato il veicolo tramite ID.");
		}

		return 1;
	}

	CMD:cargang(playerid, params[])
	{
		if(IsPlayerAdmin(playerid) || pRank[playerid]>=3)
		{
			new Float:x, Float:y, Float:z, macchina, stringa[32];
			GetPlayerPos(playerid, x, y, z);
			macchina = CreateVehicle(567, x, y, z, 0, 229, 0, 1200);
			format(stringa,sizeof(stringa), "ADMIN %d", macchina);
			SetVehicleNumberPlate(macchina, stringa);
			ScriptVehicle[macchina] = true;
			PutPlayerInVehicle(playerid, macchina, 0);
			AddVehicleComponent(macchina, 1087); // Nitro
			SendClientMessage(playerid, COLOR_ORANGE, "Hai creato un auto da gangster modificata con l'idraulica.");
		}

		return 1;
	}

	CMD:carpd(playerid, params[])
	{
		if(IsPlayerAdmin(playerid) || pRank[playerid]>=3)
		{
			new Float:x, Float:y, Float:z, macchina, stringa[32];
			GetPlayerPos(playerid, x, y, z);
			macchina = CreateVehicle(596, x, y, z, 0, 0, 1, 1200);
			format(stringa,sizeof(stringa),"ADMIN %d", macchina);
			SetVehicleNumberPlate(macchina, stringa);
			ScriptVehicle[macchina] = true;		
			SetVehicleHealth(macchina, 2500);
			PutPlayerInVehicle(playerid, macchina, 0);
			SendClientMessage(playerid, COLOR_ORANGE, "Hai creato un auto della polizia corazzata (2500hp).");
		}

		return 1;
	}
	
	CMD:carnormal(playerid, params[])
	{
		if(IsPlayerAdmin(playerid) || pRank[playerid]>=3)
		{
			new Float:x, Float:y, Float:z, macchina, stringa[32];
			GetPlayerPos(playerid, x, y, z);
			macchina = CreateVehicle(579, x, y, z, 0, 1, 0, 1200);
			format(stringa,sizeof(stringa),"ADMIN %d", macchina);
			SetVehicleNumberPlate(macchina, stringa);
			ScriptVehicle[macchina] = true;		
			SetVehicleHealth(macchina, 2500);
			PutPlayerInVehicle(playerid, macchina, 0);
			SendClientMessage(playerid, COLOR_ORANGE, "Hai creato un fuoristrada corazzato (2500hp).");
		}

		return 1;
	}
	
	
	CMD:carsuper(playerid, params[])
	{
		if(IsPlayerAdmin(playerid) || pRank[playerid]>=3)
		{
			new Float:x, Float:y, Float:z, macchina, stringa[32];
			GetPlayerPos(playerid, x, y, z);
			macchina = CreateVehicle(541, x, y, z, 1, 0, 0, 1200);
			format(stringa,sizeof(stringa),"ADMIN %d", macchina);
			SetVehicleNumberPlate(macchina, stringa);
			ScriptVehicle[macchina] = true;		
			PutPlayerInVehicle(playerid, macchina, 0);
			AddVehicleComponent(macchina, 1010); 
			SendClientMessage(playerid, COLOR_ORANGE, "Hai creato una supercar modificata con il nitro. ");
		}

		return 1;
	}

	CMD:carsultan(playerid, params[])
	{
		if(IsPlayerAdmin(playerid) || pRank[playerid]>=3)
		{
			new Float:x, Float:y, Float:z, macchina, stringa[32];
			GetPlayerPos(playerid, x, y, z);
			macchina = CreateVehicle(560, x, y, z, 0, 0, 1, 1200);
			format(stringa,sizeof(stringa),"ADMIN %d", macchina);
			SetVehicleNumberPlate(macchina, stringa);
			ScriptVehicle[macchina] = true;		
			PutPlayerInVehicle(playerid, macchina, 0);
			AddVehicleComponent(macchina, 1010); 		
			SendClientMessage(playerid, COLOR_ORANGE, "Hai creato una sultan modificata con il nitro. ");
		}

		return 1;
	}
	

	CMD:n(playerid, params[])
	{
		if(IsPlayerAdmin(playerid) || pRank[playerid]>=3)
		{
			new str[128], testo[128];
			if(sscanf(params,"s", testo)) return SendClientMessage(playerid, -1, "[Uso] /n <testo chat globale>");
			if(IsPlayerAdmin(playerid)) {
				format(str, sizeof(str), "Admin %s: %s", NameRP(playerid), testo);
				SendClientMessageToAll(COLOR_VIOLA, str);
			}else{
				format(str, sizeof(str), "Istruttore %s: %s", NameRP(playerid), testo);
				SendClientMessageToAll(COLOR_ORANGELIGHT, str);
			}
		}

		return 1;
	}
	
	CMD:v(playerid, params[])
	{
		if(IsPlayerAdmin(playerid) || pRank[playerid] >= 3)
		{
			new Float:x, Float:y, Float:z, macchina, stringa[32], id;
			if(sscanf(params, "d", id)) return 1;
			GetPlayerPos(playerid, x, y, z);
			macchina = CreateVehicle(id, x, y, z, 0, 0, 1, 1200);
			format(stringa,sizeof(stringa),"ADMIN %d", macchina);
			SetVehicleNumberPlate(macchina, stringa);
			ScriptVehicle[macchina] = true;		
			PutPlayerInVehicle(playerid, macchina, 0);
			AddVehicleComponent(macchina, 1010); 		
			SendClientMessage(playerid, COLOR_ORANGE, "Hai creato un auto.");			
		}
		return 1;
	}
	
	CMD:goto(playerid, params[])
	{
		if(IsPlayerAdmin(playerid) || pRank[playerid]>=3)
		{
			new targetid, Float:x, Float:y, Float:z;
			if(sscanf(params, "i", targetid)) SendClientMessage(playerid, -1, "[Uso] /goto <id>");
			else if(!IsPlayerConnected(targetid) || targetid == playerid) return SendClientMessage(playerid, -1, "[Errore] Il player selezionato � offline o stai cercando di gotare te stesso.");
			else
			{
				if (GetPlayerVehicleID(playerid))
				{
					GetPlayerPos(playerid, x, y, z);
					SetVehiclePos(GetPlayerVehicleID(playerid), x+2, y+2, z);
				}else{
					GetPlayerPos(targetid, x, y, z);
					SetPlayerPos(playerid, x+2, y+2, z);
				}
			}
		}
		return 1;
	}


	CMD:gethere(playerid, params[])
	{
		if(IsPlayerAdmin(playerid) || pRank[playerid]>=3)
		{
			new targetid, Float:x, Float:y, Float:z;
			if(sscanf(params, "i", targetid)) return SendClientMessage(playerid, -1, "[Uso] /gethere <id>");
			if(!IsPlayerConnected(targetid) || targetid == playerid) return SendClientMessage(playerid, -1, "[Errore] Il player selezionato � offline o stai cercando di gotare te stesso.");
			GetPlayerPos(playerid, x, y, z);
			SetPlayerPos(targetid, x+2, y+2, z);
		}
		return 1;
	}

	
	CMD:freeze(playerid, params[])
	{
		if(IsPlayerAdmin(playerid) == 1  || pRank[playerid]>=3) {
			
			new targetid, string[128];
			if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, -1, "[Uso] /freeze <id>");
			if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, "[Errore] Il player non � connesso.");
			TogglePlayerControllable(targetid, 0);
			format(string,sizeof(string),"%s � stato freezato da %s",NameRP(targetid),NameRP(playerid));
			SendClientMessageToAll(COLOR_REDLIGHT,string);
		} 
		return 1;
	}

	CMD:unfreeze(playerid, params[])
	{
		if(IsPlayerAdmin(playerid) == 1  || pRank[playerid]>=3) {

			new targetid, string[128];
			if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, -1, "[Uso] /unfreeze <id>");
			if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, "[Errore] Il player non � connesso.");
			TogglePlayerControllable(targetid, 1);
			format(string,sizeof(string),"%s � stato unfreezato da %s",NameRP(targetid),NameRP(playerid));
			SendClientMessageToAll(COLOR_REDLIGHT,string);
		}
		return 1;
	}
	

	CMD:freezeall(playerid, params[])
	{
		if(IsPlayerAdmin(playerid) == 1  || pRank[playerid]>=3) {
			
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerAdmin(i) == 0  || pRank[i]<3) {
					TogglePlayerControllable(i, false);
				}
			}
			SendClientMessageToAll(COLOR_REDLIGHT,".:: Tutti i player sono stati freezati ::.");
			return 1;
		}
		return 1;
	}
	

	CMD:unfreezeall(playerid, params[])
	{
		if(IsPlayerAdmin(playerid) == 1  || pRank[playerid]>=3) {

			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerAdmin(i) == 0  || pRank[i]<3) {
					TogglePlayerControllable(i, false);
				}
			}
			SendClientMessageToAll(COLOR_REDLIGHT,".:: Tutti i player sono stati unfreezati ::.");
			return 1;
		}
		return 1;
	}


	CMD:reconplayer(playerid, params[])
	{
		if(IsPlayerAdmin(playerid) || pRank[playerid]>=3) {

			new specplayerid;
			if(sscanf(params, "i", specplayerid)) return SendClientMessage(playerid, -1, "[Uso] /reconplayer <id>");
			TogglePlayerSpectating(playerid, 1);
			PlayerSpectatePlayer(playerid, specplayerid);
			SetPlayerInterior(playerid,GetPlayerInterior(specplayerid));
			gSpectateID[playerid] = specplayerid;
			gSpectateType[playerid] = ADMIN_SPEC_TYPE_PLAYER;
			return 1;
		}
		return 1;
	}

	CMD:reconveh(playerid, params[])
	{
		if(IsPlayerAdmin(playerid) || pRank[playerid]>=3) {
			
			new specvehicleid;
			if(sscanf(params, "i", specvehicleid)) return SendClientMessage(playerid, -1, "[Uso] /reconveh <id veicolo>");
			if(specvehicleid < MAX_VEHICLES) {
				TogglePlayerSpectating(playerid, 1);
				PlayerSpectateVehicle(playerid, specvehicleid);
				gSpectateID[playerid] = specvehicleid;
				gSpectateType[playerid] = ADMIN_SPEC_TYPE_VEHICLE;
				return 1;
			}
		}
		return 1;
	}

	CMD:reconoff(playerid, params[])
	{
		if(IsPlayerAdmin(playerid) == 1  || pRank[playerid]>=3) {

			TogglePlayerSpectating(playerid, 0);
			gSpectateID[playerid] = INVALID_PLAYER_ID;
			gSpectateType[playerid] = ADMIN_SPEC_TYPE_NONE;
			SendClientMessage(playerid, COLOR_WHITE, "Hai finito di spectare il player/veicolo.");
			return 1;
		}
		return 1;
	}


	CMD:setskin(playerid, params[])
	{
		if(IsPlayerAdmin(playerid) == 1  || pRank[playerid]>=3) {
			new targetid, skin;
			if(sscanf(params, "ii", targetid, skin)) return SendClientMessage(playerid, -1, "[Uso] /setskin <player id> <skin id>");
			if(skin > 299 || skin < 0) return SendClientMessage(playerid, COLOR_RED,"[Errore] Skin Invalida!");
			SetPlayerSkin(targetid, skin);
			pSkin[targetid] = skin;
			SendClientMessage(playerid, -1, "Skin settata perfettamente al player.");
		}
		return 1;
	}


// Comandi Nascosti

	CMD:addpickuptext(playerid, params[])
	{
		if(!IsPlayerAdmin(playerid)) return 0;
		new PModel, Description[128], Float:X, Float:Y, Float:Z;
		if(unformat(params, "is[128]", PModel, Description)) return SendClientMessage(playerid, -1, "[Uso] /addpickuptext <Pickup ID> <Descrizione>");
		GetPlayerPos(playerid, X, Y, Z);

		AddLabelToFile(LABEL_FILE_NAME, Description, X, Y, Z);
		CreateDynamic3DTextLabel(Description, COLOR_ORANGELIGHT, X, Y, Z, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 5.0);
		AddPickupToFile(PICKUP_FILE_NAME, X, Y, Z, PModel, 1);
		CreateDynamicPickup(PModel, 1, X, Y, Z, -1, -1, -1, 100.0);
		return 1; 
	}


	CMD:changeaccesspassword(playerid, params[])
	{
		if(!IsPlayerAdmin(playerid)) return 0;
		new Password[128], Type;
		if(sscanf(params, "ds[128]", Type, Password)) return SendClientMessage(playerid, -1, "[Uso] /ChangeAccessPassword <(0) accademico, (1) agente, (2) istruttore> <nuova password>");
		if(Type==0) PasswordChangeFromFile(PSWACCADEMICO_FILE_NAME, Password);
		else if(Type==1) PasswordChangeFromFile(PSWAGENTE_FILE_NAME, Password);
		else if(Type==2) PasswordChangeFromFile(PSWISTRUTTORE_FILE_NAME, Password);
		else return SendClientMessage(playerid, COLOR_RED, "[Errore] Il tipo deve essere tra 0 e 2. ");
		SendClientMessage(playerid, COLOR_GIALLO, "[SERVER] Password di accesso cambiata con successo!");
		return 1; 
	}

	
// =========================================================== Comandi Utenti ===========================================================


	CMD:aiuto(playerid, params[])
	{
		SendClientMessage(playerid, 0xFFFFFFFF, " ");
		SendClientMessage(playerid, COLOR_WHITE, "___________________[ Comandi Principali ]_________________");
		SendClientMessage(playerid, COLOR_RED, " [ROLEPLAY] /me - /ame - /do - /s - /m - /low - /b - /r - /tazer");
		SendClientMessage(playerid, COLOR_REDLIGHT, " [MISSIONI] /rapinaliquorstore - /trasportovalori");
		SendClientMessage(playerid, COLOR_GIALLO, " [ACCADEMICO] /info - /vita - /armatura - /soldi - /kill - /arma");
		SendClientMessage(playerid, COLOR_GIALLO, " [ACCADEMICO] /luoghi - /pm - /animlist - /rimuoviogg - /vsign");
		SendClientMessage(playerid, COLOR_GIALLO, " [ACCADEMICO] /rb - /rrb - /car - /color - /fix - /flip - /removecar - /skin");
		if(pRank[playerid] >= 2) SendClientMessage(playerid, COLOR_GRAD1, " [AGENTE] /criminal - /police - /swat - /riot - /divisapesante - /rrball");
		if(pRank[playerid] >= 3) SendClientMessage(playerid, COLOR_ORANGE, " [ISTRUTTORE] /icmds");
		if(IsPlayerAdmin(playerid)) SendClientMessage(playerid, COLOR_VIOLA, " [ADMIN] /rconcmds");
		SendClientMessage(playerid, COLOR_WHITE, "__________________________________________________________");
		return 1;
	}
	
	CMD:luoghi(playerid, params[])
	{
		SendClientMessage(playerid, 0xFFFFFFFF, " ");
		SendClientMessage(playerid, COLOR_GRAD1, "___________________[ Luoghi ]_______________________");
		SendClientMessage(playerid, COLOR_AZZURRO, " [SPAWN] /pd - /pdest - /us - /ap - /ganton - /vinewood - /drift");
		SendClientMessage(playerid, COLOR_AZZURRO, " [SPAWN] /carcere - /edificioswat - /tuning");
		SendClientMessage(playerid, COLOR_GIALLO, " [MISSIONI] /eastbeach - /liquorstore - /addsparatoria - /addriot");
		SendClientMessage(playerid, COLOR_GIALLO, " [INTERIORS] /interiors - /enterpd - /enterprison - /enterelettronica");
		SendClientMessage(playerid, COLOR_GRAD1, "____________________________________________________");
		return 1;
	}
	
	
	CMD:crediti(playerid, params[])
	{

		new infoTraining[128], infoLastUpdate[128];
		format(infoTraining, 128, "Righe della Gamemode: %s | Versione: %s", GM_RIGHE, GM_VERSION);
		format(infoLastUpdate, 128, "Ultimo update: %s", GM_LASTUPDATE);

		SendClientMessage(playerid, 0xFFFFFFFF, " ");
		SendClientMessage(playerid, COLOR_WHITE, "__________________[ Info Gamemode ]__________________");
		SendClientMessage(playerid, COLOR_ORANGE, "Sviluppatore: {FFFFFF}Maxel");
		SendClientMessage(playerid, COLOR_ORANGE, "Sviluppatori di terze parti: {FFFFFF}enom, Sh4ark");
		SendClientMessage(playerid, COLOR_ORANGE, infoTraining);
		SendClientMessage(playerid, COLOR_ORANGE, infoLastUpdate);
		SendClientMessage(playerid, COLOR_GRAD1, "LSPD Training Ufficiale di Atlantis City Roleplay");
		SendClientMessage(playerid, COLOR_GRAD1, "Siti Web: www.ac-rp.org | pd.lscity.org");
		SendClientMessage(playerid, COLOR_WHITE, "____________________________________________________");
		return 1;
	}


	CMD:info(playerid, params[])
	{
		new str[128], string[128], stringer[128], stingerlol[128], stingerlol2[128];
		new NomeTeam[32];
		new NomeRank[32];
		new NomeSwat[32];
		
		if(GetPlayerTeam(playerid) == 1) NomeTeam = "Criminali";
		if(GetPlayerTeam(playerid) == 0) NomeTeam = "Polizia";
		
		if(pRank[playerid] == 1) NomeRank = "Accademico";
		if(pRank[playerid] == 2) NomeRank = "Agente";
		if(pRank[playerid] == 3 && !IsPlayerAdmin(playerid)) NomeRank = "Istruttore";
		if(pRank[playerid] == 3 && IsPlayerAdmin(playerid)) NomeRank = "Amministratore";
		
		if(pSwat[playerid] == 1) NomeSwat = "Swat";
		if(pRiot[playerid] == 1) NomeSwat = "Antisommossa";
		if(pSwat[playerid] == 0 && pRiot[playerid] == 0) NomeSwat = "Nessuna";
		
		format(str, 128, "NOME UTENTE: %s ", Name(playerid));
		format(string, 128, "PUNTI: %d ", GetPlayerScore(playerid));
		format(stringer, 128, "TEAM: %s ", NomeTeam);
		format(stingerlol, 128, "SQUADRA SPECIALE: %s ", NomeSwat);
		format(stingerlol2, 128, "RANGO PERMESSI: %s ", NomeRank);

		SendClientMessage(playerid, 0xFFFFFFFF, " ");
		SendClientMessage(playerid, COLOR_WHITE, "________________[ Informazioni Player ]________________");
		SendClientMessage(playerid, COLOR_BLUE, str);
		SendClientMessage(playerid, COLOR_BLUE, string);
		SendClientMessage(playerid, COLOR_ORANGELIGHT, stringer);
		SendClientMessage(playerid, COLOR_ORANGELIGHT, stingerlol);
		SendClientMessage(playerid, COLOR_BLUE, stingerlol2);
		SendClientMessage(playerid, COLOR_WHITE, "_______________________________________________________");
		return 1;
	}

	CMD:vita(playerid, params[])
	{
		if(Simulazione == false){
			SetPlayerHealth(playerid, 100);
			SendClientMessage(playerid, COLOR_ORANGE, "Hai settato la tua vita al massimo");
		}else{ ErroreSim(playerid); }
		return 1;
	}
	
	CMD:kill(playerid, params[])
	{
		if(Simulazione == false){
			SetPlayerHealth(playerid, 0);
			SendClientMessage(playerid, COLOR_ORANGE, "Ti sei ucciso, ma non mancherai a nessuno, tranquillo :P");
		}else{ ErroreSim(playerid); }
		return 1;
	}

	CMD:armatura(playerid, params[])
	{
		if(Simulazione == false){
			SetPlayerArmour(playerid, 100);
			SetPlayerAttachedObject(playerid,1,19142,1,0.1,0.05,0.0,0.0,0.0,0.0);
			SendClientMessage(playerid, COLOR_ORANGE, "Hai settato la tua armatura al massimo");
		}else{ ErroreSim(playerid); }
		return 1;
	}
	
	CMD:divisapesante(playerid, params[])
	{
		if(Simulazione == false){
			if(pRiot[playerid] == 1){
				SetPlayerArmour(playerid, 100);
				SetPlayerAttachedObject(playerid,1,19142,1,0.1,0.05,0.0,0.0,0.0,0.0);
				SetPlayerAttachedObject(playerid, 2, 18637, 4, 0.3, 0, 0, 0, 170, 270, 1, 1, 1);
				SendClientMessage(playerid, COLOR_ORANGE, "Ti sei settato la divisa pesante da Antisommossa.");
			}else{ SendClientMessage(playerid, COLOR_RED, "[Errore] Devi essere settato in /riot per poter usare questo equipaggiamento."); }
		}else{ ErroreSim(playerid); }
		return 1;
	}

	CMD:soldi(playerid, params[])
	{
		if(Simulazione == false){
			GivePlayerMoney(playerid, 50000);
			SendClientMessage(playerid, COLOR_ORANGE, "Hai ricevuto 50000$");
		}else{ ErroreSim(playerid); }
		return 1;
	}

// --------- Comandi Armi ----------


CMD:armeria(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 3.0, 254.45, 87.07, 1002.44)){

		ShowPlayerDialog(playerid, DIALOG_ARMI, DIALOG_STYLE_LIST, "Armeria Dipartimentale", "Manganello\nSpray\nColtello\n{FFF6DA}Colt45\n{FFF6DA}Colt45 Silenziata\n{FFF6DA}Desert Eagle\n{FFB189}Fucile a Pompa\n{FFB189}Spass 12\n{FF9789}MP5\n{FF9789}M4A1\n{FF4646}Fucile Semi-Automatico\n{FF4646}Fucile da Cecchino\n{DFDFDF}Fotocamera\n{DFDFDF}Lacrimogeno", "Seleziona", "Esci");	

	}
	else return SendClientMessage(playerid, COLOR_RED, "[Errore] Devi essere vicino al pickup per poter usare l'armeria."); 
}



// --------- Set e Classi ----------


CMD:servizio(playerid, params[]){

	if(IsPlayerInRangeOfPoint(playerid, 3.0, 255.43, 74.30, 1003.64)){

		ShowPlayerDialog(playerid, DIALOG_ONDUTY, DIALOG_STYLE_LIST, "Servizio", "Agente normale\nAgente Swat\nAgente Riot\n{FF0000}Criminale", "Seleziona", "Esci");

	}else return SendClientMessage(playerid, COLOR_RED, "[Errore] Devi essere vicino al pickup per poter andare in servizio.");

}


stock do_police(playerid){

	if(pRank[playerid]>=2){
		ResetPlayerWeapons(playerid);
		SetPlayerArmour(playerid, 100);
		SetPlayerTeam(playerid, 0);
		SetPlayerSkin(playerid, 281);
		GivePlayerWeapon(playerid, 3, 1);
		GivePlayerWeapon(playerid, 24, 999999);
		GivePlayerWeapon(playerid, 25, 999999);
		GivePlayerWeapon(playerid, 29, 999999);
		GivePlayerWeapon(playerid, 31, 999999);
		pSwat[playerid] = 0;
		pRiot[playerid] = 0;
		pSkin[playerid] = 281;
		new str[128];
		format(str, 128, "%s si � messo il set da Poliziotto. ", NameRP(playerid));
		SendClientMessageToAll(COLOR_GREEN, str);
	}

	return 1;
}

stock do_criminal(playerid){

	if(pRank[playerid]>=2){
		ResetPlayerWeapons(playerid);
		SetPlayerArmour(playerid,0);
		SetPlayerTeam(playerid, 1);
		SetPlayerSkin(playerid, 109);
		GivePlayerWeapon(playerid, 5, 1);
		GivePlayerWeapon(playerid, 24, 999999);
		GivePlayerWeapon(playerid, 28, 999999);
		GivePlayerWeapon(playerid, 30, 999999);
		pSwat[playerid] = 0;
		pRiot[playerid] = 0;
		pSkin[playerid] = 109;
		new str[128];
		format(str, 128, "%s si � messo il set da Criminale. ", NameRP(playerid));
		SendClientMessageToAll(COLOR_GREEN, str);
	}
	

	return 1;
}


stock do_swat(playerid){

	if(pRank[playerid]>=2){
		ResetPlayerWeapons(playerid);
		SetPlayerTeam(playerid, 0);
		SetPlayerArmour(playerid,100);
		SetPlayerSkin(playerid,285);
		GivePlayerWeapon(playerid, 4, 1);
		GivePlayerWeapon(playerid, 24, 99999);
		GivePlayerWeapon(playerid, 34, 99999);
		GivePlayerWeapon(playerid, 27, 99999);
		GivePlayerWeapon(playerid, 31, 99999);
		GivePlayerWeapon(playerid, 17, 999999);
		GivePlayerWeapon(playerid, 29, 999999);
		pSwat[playerid] = 1;
		pRiot[playerid] = 0;
		pSkin[playerid] = 285;
		new str[128];
		format(str, 128, "%s si � messo il set da SWAT. ", NameRP(playerid));
		SendClientMessageToAll(COLOR_GREEN, str);
	}

	return 1;
}

stock do_riot(playerid){

	if(pRank[playerid]>=2){
		ResetPlayerWeapons(playerid);
		SetPlayerTeam(playerid, 0);
		SetPlayerArmour(playerid,100);
		SetPlayerSkin(playerid,284);
		GivePlayerWeapon(playerid, 3, 1);
		GivePlayerWeapon(playerid, 41, 999999);
		GivePlayerWeapon(playerid, 17, 999999);
		GivePlayerWeapon(playerid, 24, 999999);
		GivePlayerWeapon(playerid, 25, 999999);
		pRiot[playerid] = 1;
		pSwat[playerid] = 0;
		pSkin[playerid] = 284;
		new str[128];
		format(str, 128, "%s si � messo il set da Antisommossa. ", NameRP(playerid));
		SendClientMessageToAll(COLOR_GREEN, str);
	}

	return 1;
}

CMD:police(playerid, params[]) if(Simulazione == false) return do_police(playerid); else return ErroreSim(playerid); 
CMD:criminal(playerid, params[]) if(Simulazione == false) return do_criminal(playerid); else return ErroreSim(playerid); 
CMD:swat(playerid, params[]) if(Simulazione == false) return do_swat(playerid); else return ErroreSim(playerid); 
CMD:riot(playerid, params[]) if(Simulazione == false) return do_riot(playerid); else return ErroreSim(playerid); 


CMD:color(playerid, params[])
{
	if(Simulazione == false){
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,COLOR_RED,"[Errore] Non sei in un veicolo!");
		new color1, color2;
		if(sscanf(params, "ii", color1, color2)) return SendClientMessage(playerid, -1, "[Uso] /color <id colore1> <id colore2>");
		ChangeVehicleColor(GetPlayerVehicleID(playerid), color1, color2);
	}else{ ErroreSim(playerid); }
	return 1;
}

// --------- Spawn ----------


CMD:vinewood(playerid, params[])
{
	if(Simulazione == false){
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid, 1387.9187,-817.5727,74.0799);
		new str[128];
		format(str, 128, "%s si � teletrasportato a Vinewood (/vinewood).", NameRP(playerid));
		SendClientMessageToAll(COLOR_AZZURRO, str);
	}else{ ErroreSim(playerid); }
	return 1;
}

CMD:carcere(playerid, params[])
{
	if(Simulazione == false){
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid, 1420.7347,-2861.1929,13.9535);
		new str[128];
		format(str, 128, "%s si � teletrasportato al carcere mappato (/carcere).", NameRP(playerid));
		SendClientMessageToAll(COLOR_AZZURRO, str);
	}else{ ErroreSim(playerid); }
	return 1;
}

CMD:ganton(playerid, params[])
{
	if(Simulazione == false){
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid, 2465.8408, -1667.4314, 13.4695);
		new str[128];
		format(str, 128, " %s si � teletrasportato a Ganton (/ganton). ", NameRP(playerid));
		SendClientMessageToAll(COLOR_AZZURRO, str);
	}else{ ErroreSim(playerid); }
	return 1;
}

CMD:tuning(playerid, params[])
{
	if(Simulazione == false){
		new veicolo;
		SetPlayerInterior(playerid, 0);
		if(IsPlayerInAnyVehicle(playerid)){
			veicolo = GetPlayerVehicleID(playerid);
			SetVehiclePos(veicolo, 1037.0376 + 1, -1037.1803 + 1, 31.3539 + 1);
			PutPlayerInVehicle(playerid, veicolo, 0);
		}else{
			SetPlayerPos(playerid, 1037.0376, -1037.1803, 31.3539);
		}
		new str[128];
		format(str, 128, "%s si � teletrasportato al tuning (/tuning).", NameRP(playerid));
		SendClientMessageToAll(COLOR_AZZURRO, str);
	}else{ ErroreSim(playerid); }
	return 1;
}

CMD:ap(playerid, params[])
{
	if(Simulazione == false){
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid, 2130.1775, -2554.3279, 13.5469);
		new str[128];
		format(str, 128, "%s si � teletrasportato all'aeroporto (/ap).", NameRP(playerid));
		SendClientMessageToAll(COLOR_AZZURRO, str);
	}else{ ErroreSim(playerid); }
	return 1;
}

CMD:pd(playerid, params[])
{
	if(Simulazione == false){
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid, 1528.2743,-1674.9425,13.3828);
		new str[128];
		format(str, 128, "%s si � teletrasportato al PD (/pd).", NameRP(playerid));
		SendClientMessageToAll(COLOR_AZZURRO, str);
	}else{ ErroreSim(playerid); }
	return 1;
}


CMD:pdest(playerid, params[])
{
	if(Simulazione == false){
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid, 2497.7219,-1766.8550,20.0000);
		new str[128];
		format(str, 128, "%s si � teletrasportato al tetto del PD Est (/pdest).", NameRP(playerid));
		SendClientMessageToAll(COLOR_AZZURRO, str);
	}else{ ErroreSim(playerid); }
	return 1;
}

CMD:us(playerid, params[])
{
	if(Simulazione == false){
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid, 1837.1801,-1866.4897,13.3828);
		new str[128];
		format(str, 128, "%s si � teletrasportato a Unity Station (/us).", NameRP(playerid));
		SendClientMessageToAll(COLOR_AZZURRO, str);
	}else{ ErroreSim(playerid); }
	return 1;
}

CMD:hsiu(playerid, params[])
{
	if(Simulazione == false){
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid, 2858.2939,-1955.5450,10.9393);
		new str[128];
		format(str, 128, "%s si � teletrasportato all'addestramento HSIU - ASU (/hsiu).", NameRP(playerid));
		SendClientMessageToAll(COLOR_AZZURRO, str);
	}else{ ErroreSim(playerid); }
	return 1;
}


CMD:liquorstore(playerid, params[])
{
	if(Simulazione == false){
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid, 232.5600,-73.3890,1.4197);
		new str[128];
		format(str, 128, "%s si � teletrasportato al Liquor Store (/liquorstore).", NameRP(playerid));
		SendClientMessageToAll(COLOR_AZZURRO, str);
	}else{ ErroreSim(playerid); }
	return 1;
}

CMD:eastbeach(playerid, params[])
{
	if(Simulazione == false){
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid, 2786.5195,-1848.8776,9.9580);
		new str[128];
		format(str, 128, "%s si � teletrasportato allo stadio di East Beach (/eastbeach).", NameRP(playerid));
		SendClientMessageToAll(COLOR_AZZURRO, str);
	}else{ ErroreSim(playerid); }
	return 1;
}


CMD:addsparatoria(playerid, params[])
{
	if(Simulazione == false){
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid, 1883.5400,-2049.1636,13.3828);
		new str[128];
		format(str, 128, "%s si � teletrasportato all'addestramento SWAT - Polizia (/addsparatoria).", NameRP(playerid));
		SendClientMessageToAll(COLOR_AZZURRO, str);
		if(zonaAddestramento==false){
			SendClientMessage(playerid, COLOR_WHITE, "Se non vedi il map di addestramento, chiedi ad un istruttore di crearlo.");
		}
	}else{ ErroreSim(playerid); }
	return 1;
}


CMD:edificioswat(playerid, params[])
{
	if(Simulazione == false){
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid, -2164.3157, -210.8491, 35.3203);
		new str[128];
		format(str, 128, "%s si � teletrasportato all'edificio SWAT (/edificioswat).", NameRP(playerid));
		SendClientMessageToAll(COLOR_AZZURRO, str);
	}else{ ErroreSim(playerid); }
	return 1;
}

CMD:drift(playerid, params[])
{
	if(Simulazione == false){
		new veicolo;
		SetPlayerInterior(playerid, 0);
		if(IsPlayerInAnyVehicle(playerid)){
			veicolo = GetPlayerVehicleID(playerid);
			SetVehiclePos(veicolo, -283.1335, 1533.8645, 75.0158);
			PutPlayerInVehicle(playerid, veicolo, 0);
		}else{
			SetPlayerPos(playerid, -297.5922, 1523.1532, 75.3594);
		}
		new str[128];
		format(str, 128, "%s si � teletrasportato al drift (/drift).", NameRP(playerid));
		SendClientMessageToAll(COLOR_AZZURRO, str);
	}else{ ErroreSim(playerid); }
	return 1;
}

CMD:addriot(playerid, params[])
{
	if(Simulazione == false){
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid, 2457.5339,-1322.1095,24.0000);
		new str[128];
		format(str, 128, "%s si � teletrasportato all'addestramento Riot (/addriot).", NameRP(playerid));
		SendClientMessageToAll(COLOR_AZZURRO, str);
		if(zonaRiot==false){
			SendClientMessage(playerid, COLOR_WHITE, "Se non vedi il map di addestramento, chiedi ad un istruttore di crearlo.");
		}		
	}else{ ErroreSim(playerid); }
	return 1;
}

// ----------------- INTERIOR LSPD COMANDI -----------------------------

CMD:enterpd(playerid, params[])
{
	if(Simulazione == false){
		SetPlayerPos(playerid, 246.6695, 65.8039, 1003.6406);
		SetPlayerInterior(playerid,6);
		new str[128];
		format(str, 128, "%s � entrato nel Dipartimento di Polizia (/enterpd).", NameRP(playerid));
		SendClientMessageToAll(COLOR_AZZURRO, str);
	}else{ 
		if(IsPlayerInRangeOfPoint(playerid, 2.5, 1553.95, -1675.76, 16.19)){
			SetPlayerPos(playerid, 246.6695, 65.8039, 1003.6406);
			SetPlayerInterior(playerid,6);
		}else{ return SendClientMessage(playerid, COLOR_RED, "[Errore] Devi essere alla porta del dipartimento per poter entrare!"); }
	}
	return 1;
}	

CMD:exitpd(playerid, params[])
{
	if(Simulazione == false){			
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid, 1553.95, -1675.76, 16.19);
		new str[128];
		format(str, 128, "%s � uscito dal Dipartimento di Polizia (/exitpd).", NameRP(playerid));
		SendClientMessageToAll(COLOR_AZZURRO, str);
	}else{ 
		if(IsPlayerInRangeOfPoint(playerid, 2.5, 246.6695, 65.8039, 1003.6406)){
			SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid, 1553.95, -1675.76, 16.19);
		}else{ return SendClientMessage(playerid, COLOR_RED, "[Errore] Devi essere dentro il dipartimento per poter uscire!"); }
	}
	return 1;
}		


// ----------------- INTERIOR CARCERE COMANDI -----------------------------


CMD:enterprison(playerid, params[])
{
	if(Simulazione == false){
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid, 1779.3185,-1576.1315,1734.9430);
		new str[128];
		format(str, 128, "%s si � entrato nella prigione (/enterprison).", NameRP(playerid));
		SendClientMessageToAll(COLOR_AZZURRO, str);
	}else{
		if(IsPlayerInRangeOfPoint(playerid, 5.0, 1798.6970, -1578.2467, 14.0823)){
			SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid, 1779.3185,-1576.1315,1734.9430);
		}else{ return SendClientMessage(playerid, COLOR_RED, "[Errore] Devi essere fuori la prigione per poterci entrare!"); }    	
	}
	return 1;
}

CMD:exitprison(playerid, params[])
{
	if(Simulazione == false){
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid,1798.6970, -1578.2467, 14.0823);
		new str[128];
		format(str, 128, "%s � uscito dalla prigione (/exitprison).", NameRP(playerid));
		SendClientMessageToAll(COLOR_AZZURRO, str);
	}else{ 
		if(IsPlayerInRangeOfPoint(playerid, 5.0, 1779.3185,-1576.1315,1734.9430)){
			SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid, 1798.6970, -1578.2467, 14.0823);
		}else{ return SendClientMessage(playerid, COLOR_RED, "[Errore] Devi essere dentro la prigione per poterci uscire!"); }
	}
	return 1;
}
// ------------------ INTERIOR ELETTRONICA COMANDI -----------------------------

CMD:enterelettronica(playerid, params[])
{
	if(Simulazione == false){
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid, 1004.19, 52.3467, 55.4);
		new str[128];
		format(str, 128, "%s si � entrato nell'elettronica (/enterelettronica).", NameRP(playerid));
		SendClientMessageToAll(COLOR_AZZURRO, str);
	}else{ 
		if(IsPlayerInRangeOfPoint(playerid, 5.0, 1081.6394,-1699.3267,13.5469)){
			SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid, 1004.19, 52.3467, 55.4);
		}else{ return SendClientMessage(playerid, COLOR_RED, "[Errore] Devi essere davanti all'elettronica per poter entrare!"); }
	}
	return 1;
}

CMD:exitelettronica(playerid, params[])
{
	if(Simulazione == false){
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid, 1081.6394,-1699.3267,13.5469);
		new str[128];
		format(str, 128, "%s si � uscito dall'elettronica (/exitelettronica).", NameRP(playerid));
		SendClientMessageToAll(COLOR_AZZURRO, str);
	}else{ 
		if(IsPlayerInRangeOfPoint(playerid, 5.0, 1004.19, 52.3467, 55.4)){
			SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid, 1081.6394,-1699.3267,13.5469);
		}else{ return SendClientMessage(playerid, COLOR_RED, "[Errore] Devi essere dentro l'elettronica per poter uscire!"); }
	}
	return 1;
}

// ----------------- Utility -----------------------------


CMD:fix(playerid, params[])
{
	if(Simulazione == false){
		if(IsPlayerInAnyVehicle(playerid))
		{
			SetVehicleHealth(GetPlayerVehicleID(playerid),999.9);
			RepairVehicle(GetPlayerVehicleID(playerid));
			new str[128];
			format(str, 128, "%s ha fixato il suo veicolo.", NameRP(playerid));
			SendClientMessageToAll(COLOR_VEHFIX, str);
		}
	}else{ ErroreSim(playerid); }
	return 1;
}

CMD:flip(playerid, params[])
{
	if(Simulazione == false){
		new currentveh;
		new Float:angle;
		currentveh = GetPlayerVehicleID(playerid);
		GetVehicleZAngle(currentveh, angle);
		SetVehicleZAngle(currentveh, angle);
		new str[128];
		format(str, 128, "%s ha flippato il suo veicolo.", NameRP(playerid));
		SendClientMessageToAll(COLOR_ORANGE, str);
	}else{ ErroreSim(playerid); }
	return 1;
}



    // ----------------- ROAD BLOCKS -----------------------------


CMD:rb(playerid, params[])
{
	new rb;

	if(sscanf(params,"i", rb))
	{
		SendClientMessage(playerid, -1, "[Uso] /rb <id>");
		SendClientMessage(playerid, COLOR_AZZURRO, "Blocchi Disponibili (max 300):");
		SendClientMessage(playerid, COLOR_GRAD1, "| 1: Piccolo Roadblock");
		SendClientMessage(playerid, COLOR_GRAD1, "| 2: Medio Roadblock");
		SendClientMessage(playerid, COLOR_GRAD1, "| 3: Grande Roadblock");
		SendClientMessage(playerid, COLOR_GRAD1, "| 4: Cono");
		SendClientMessage(playerid, COLOR_GRAD1, "| 5: Striscia Chiodata");
		return 1;
	}

	if (rb == 1)
	{
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		new Float:plocx,Float:plocy,Float:plocz,Float:ploca;
		GetPlayerPos(playerid, plocx, plocy, plocz);
		GetPlayerFacingAngle(playerid,ploca);
		CreateRoadblock(1459,plocx,plocy,plocz+0.3,ploca);
		GameTextForPlayer(playerid,"~w~Blocco piccolo ~b~piazzato!",2000,1);
		return 1;
	}
	else if (rb == 2)
	{
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		new Float:plocx,Float:plocy,Float:plocz,Float:ploca;
		GetPlayerPos(playerid, plocx, plocy, plocz);
		GetPlayerFacingAngle(playerid,ploca);
		CreateRoadblock(978,plocx,plocy,plocz+0.6,ploca);
		GameTextForPlayer(playerid,"~w~Blocco medio ~b~piazzato!",2000,1);
		return 1;
	}
	else if (rb == 3)
	{
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		new Float:plocx,Float:plocy,Float:plocz,Float:ploca;
		GetPlayerPos(playerid, plocx, plocy, plocz);
		GetPlayerFacingAngle(playerid,ploca);
		CreateRoadblock(981,plocx,plocy,plocz+0.9,ploca+180);
		SetPlayerPos(playerid, plocx, plocy+1.3, plocz);
		GameTextForPlayer(playerid,"~w~Roadblock grande ~b~piazzato!",2000,1);
		return 1;
	}
	else if (rb == 4)
	{
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		new Float:plocx,Float:plocy,Float:plocz,Float:ploca;
		GetPlayerPos(playerid, plocx, plocy, plocz);
		GetPlayerFacingAngle(playerid,ploca);
		CreateRoadblock(1238,plocx,plocy,plocz+0.3,ploca);
		GameTextForPlayer(playerid,"~w~Cono ~b~piazzato!",2000,1);
		return 1;
	}
	else if (rb == 5)
	{
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		new Float:plocx,Float:plocy,Float:plocz,Float:ploca;
		GetPlayerPos(playerid, plocx, plocy, plocz);
		GetPlayerFacingAngle(playerid,ploca);
		CreateRoadblock(2899,plocx,plocy,plocz,ploca+90.0);
		GameTextForPlayer(playerid,"~w~Striscia chiodata ~b~piazzata!",2000,1);
		return 1;
	}
	
	return 1;
}


CMD:rrb(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
		DeleteClosestRoadblock(playerid);
		new pName[24];
		new str[128];
		GetPlayerName(playerid, pName, 24);
		format(str, 128, "%s ha eliminato un blocco stradale vicino a te", NameRP(playerid));
		SendClientMessageToAll(COLOR_AME, str);

	}
	return 1;
}


CMD:rrball(playerid, params[])
{
	if(IsPlayerConnected(playerid) || pRank[playerid]>=2)
	{
		DeleteAllRoadblocks(playerid);
		new pName[24];
		new str[128];
		GetPlayerName(playerid, pName, 24);
		format(str, 128, "%s ha eliminato tutti i blocchi stradali", NameRP(playerid));
		SendClientMessageToAll(COLOR_AME, str);
	}
	return 1;
}


/* ============== Comandi IC ============== */


CMD:me(playerid, params[])
{
	if(Simulazione == true){
		new string[128], testo[128];
		if(sscanf(params,"s", testo)) return SendClientMessage(playerid, -1,"[Uso] /me <azione>");
		format(string, sizeof(string), "* %s %s *", NameRP(playerid), testo);
		SendLocalMessage(playerid, string, 20.0, COLOR_ACTION, COLOR_ACTION);
	}else{ ErroreSim2(playerid); }
	return 1;
}

CMD:ame(playerid, params[])
{
	if(Simulazione == true){
		new string[128], testo[128];
		if(sscanf(params,"s", testo)) return SendClientMessage(playerid, -1,"[Uso] /ame <azione>");
		format(string, sizeof(string), "* %s *", testo);
		SetPlayerChatBubble(playerid, string, COLOR_AME, 10.0, 7000);
		SendClientMessage(playerid, COLOR_AME, string);
	}else{ ErroreSim2(playerid); }
	return 1;
}

CMD:do(playerid, params[])
{
	if(Simulazione == true){
		new string[128], testo[128];
		if(sscanf(params,"s", testo)) return SendClientMessage(playerid, -1,"[Uso] /do <descrizione>");
		format(string, sizeof(string), "* %s (( %s )) *", testo, NameRP(playerid));
		SendLocalMessage(playerid, string, 20.0, COLOR_ACTION, COLOR_ACTION);
	}else{ ErroreSim2(playerid); }
	return 1;
}

CMD:s(playerid, params[])
{
	if(Simulazione == true){
		new string[128], testo[128];
		if(sscanf(params,"s", testo)) return SendClientMessage(playerid, -1,"[Uso] /s <testo urlato>");
		format(string, sizeof(string), "%s grida: %s!", NameRP(playerid), testo);
		SendLocalMessage(playerid, string, 40.0, COLOR_WHITE, COLOR_WHITE);
	}else{ ErroreSim2(playerid); }
	return 1;
}

CMD:low(playerid, params[])
{
	if(Simulazione == true){
		new string[128], testo[128];
		if(sscanf(params,"s", testo)) return SendClientMessage(playerid, -1,"[Uso] /low <testo sottovoce>");
		format(string, sizeof(string), "%s dice a bassa voce: %s", NameRP(playerid), testo);
		SendLocalMessage(playerid, string, 3.0, COLOR_GRAD1, COLOR_GRAD1);
	}else{ ErroreSim2(playerid); }
	return 1;
}

CMD:m(playerid, params[])
{
	if(Simulazione == true){
		new string[128], testo[128];
		if(sscanf(params,"s", testo)) return SendClientMessage(playerid, -1,"[Uso] /m <testo megafono>");
		format(string, sizeof(string), "[MEGAFONO] %s: %s", NameRP(playerid), testo);
		SendLocalMessage(playerid, string, 60.0, COLOR_GIALLO, COLOR_GIALLO);
	}else{ ErroreSim2(playerid); }
	return 1;
}

CMD:b(playerid, params[])
{
	if(Simulazione == true){
		new string[128], testo[128];
		if(sscanf(params,"s", testo)) return SendClientMessage(playerid, -1,"[Uso] /b <testo ooc>");
		format(string, sizeof(string), "(( %s [%i]: %s ))", NameRP(playerid), playerid, testo);
		SendLocalMessage(playerid, string, 20.0, COLOR_GRAD1, COLOR_GRAD1);
	}else{ ErroreSim2(playerid); }
	return 1;
}


CMD:r(playerid, params[])
{
	if(Simulazione == true){
		new string[128], testo[128], Title[24];
		if(sscanf(params,"s", testo)) return SendClientMessage(playerid, -1,"[Uso] /me <azione>");
		if(GetPlayerTeam(playerid) == 1){ Title = "Criminale"; } else { Title = "Agente"; }
		format(string, sizeof(string), "[RADIO] %s %s: %s", Title, NameRP(playerid), testo);
		SendTeamMessage(GetPlayerTeam(playerid), COLOR_BLUE, string);
	}else{ ErroreSim2(playerid); }
	return 1;
}



// ============= Spawn Auto =================


CMD:carspawn(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || pRank[playerid] >= 3 )
	{
		if(CarSpawn == true){
			CarSpawn = false;
			SendClientMessageToAll(COLOR_GIALLO, "[SERVER] Lo spawn delle auto con /car � stato disattivato per gli utenti.");
		}
		else{
			CarSpawn = true;
			SendClientMessageToAll(COLOR_GIALLO, "[SERVER] Lo spawn delle auto con /car � stato attivato per gli utenti.");
		}
	}

	return 1;
}



CMD:car(playerid, params[])
{

		if(CarSpawn == true || IsPlayerAdmin(playerid) || pRank[playerid] >= 3){ // IF

			new Float:vx, Float:vy, Float:vz, vid, car[25];
			new stringa[256];

			if(sscanf(params,"s", car)) return SendClientMessage(playerid, -1,"[Uso] /car <nome/id veicolo>");

			if (IsNumeric(car)) vid = strval(car);
			else vid = GetVehicleIDFromName(car);

			if ((vid < 400) || (vid > 611) || (vid == 590) || (vid == 569) || (vid == 570) || (vid == 537) || (vid == 538) || (vid == 449))
			{
				return SendClientMessage(playerid, COLOR_RED, "[Errore] Veicolo non riconosciuto.");

			}else{

				GetPlayerPos(playerid, vx, vy, vz);
				new veicolo = CreateVehicle(vid, vx + random(9) - 4, vy + random(9) - 4, vz, 0, -1, -1, 1200);
				ScriptVehicle[veicolo] = true;

				format(stringa,sizeof(stringa),"USER %d",veicolo);
				SetVehicleNumberPlate(veicolo, stringa);

				PutPlayerInVehicle(playerid, veicolo, 0);
				SendClientMessage(playerid, COLOR_ORANGE, "Hai spawnato l'auto con successo.");
				return 1;

			}

		}else{ 

			ErroreSpa(playerid);
			return 1;

		}
	}

	CMD:tazer(playerid, params[])
	{
		
		if(Simulazione == true){
			
	    if(GetPlayerTeam(playerid) == 0) // For cops
	    {
	        if(IsPlayerInAnyVehicle(playerid)) // Checks if the player is in a vehicle.
	        {
	        	SendClientMessage(playerid, COLOR_RED, "[Errore] Non puoi usare questo comando in auto!");
	        	return 1;
	        }
	        if(pTazer[playerid] == 0) // se non ha il tazer
	        {
	            GivePlayerWeapon(playerid, 23, 999999); // Givva una pistola silenziata
	            pTazer[playerid] = 1; // Setta la variabile a vero
	            SetPlayerChatBubble(playerid, "* estrae un Tazer dal cinturone *", COLOR_AME, 10.0, 7000);
	            SendClientMessage(playerid, COLOR_AME, "* estrae un Tazer dal cinturone *");
	            return 1;
	        }
	        else if(pTazer[playerid] == 1) // Se ha il tazer
	        {
	            GivePlayerWeapon(playerid, 24, 999999); // Givva una Deagle
	            pTazer[playerid] = 0; // Setta la variabile a Falso
	            SetPlayerChatBubble(playerid, "* ripone il Tazer nel cinturone *", COLOR_AME, 10.0, 7000);
	            SendClientMessage(playerid, COLOR_AME, "* ripone il Tazer nel cinturone *");
	            return 1;
	        }
	        
	    }
	    
	}else{	ErroreSim2(playerid); }
	
	return 1;
}


CMD:skin(playerid, params[])
{
	if(pRank[playerid]>=2){
		new skin;
		if(sscanf(params, "i", skin)) return SendClientMessage(playerid, -1, "[Uso] /skin <id>");
		if(skin > 299 || skin < 0) return SendClientMessage(playerid, COLOR_RED,"[Errore] Skin Invalida!");
		SetPlayerSkin(playerid, skin);
		pSkin[playerid] = skin;
	}else{ return SendClientMessage(playerid, COLOR_RED, "[Errore] Devi loggare come agente per usare questo comando."); }
	return 1;
}



CMD:vsign(playerid, params[])
{
	new getcar = GetPlayerVehicleID(playerid), testo[128], Float:yt;
	if(!(IsPlayerInAnyVehicle(playerid))) return SendClientMessage(playerid, COLOR_RED, "[Errore] Devi essere in un veicolo!");
	if(sscanf(params, "fs", yt, testo)) return SendClientMessage(playerid, -1, "[Uso] /vsign <distanza dal centro (es: -1.5)> <testo 64 caratteri>");
	Delete3DTextLabel(vehicle3Dtext[getcar]);
	vehicle3Dtext[getcar] = Create3DTextLabel(testo, -1, 0.0, 0.0, 0.0, 50.0, 0, 1);
	Attach3DTextLabelToVehicle(vehicle3Dtext[getcar], getcar, 0.0, yt, 0.0);
	SendClientMessage(playerid, -1, "Vehicle Sign attivato correttamente. Usa /vsignoff per rimuoverlo.");
	return 1;
}

CMD:vsignoff(playerid, params[])
{
	new getcar = GetPlayerVehicleID(playerid);
	if(!(IsPlayerInAnyVehicle(playerid))) return SendClientMessage(playerid, COLOR_RED, "[Errore] Devi essere in un veicolo!");
	Delete3DTextLabel(vehicle3Dtext[getcar]);
	SendClientMessage(playerid, -1, "Vehicle Sign disabilitato.");
	return 1;
}


//	else return SendClientMessage(playerid, 0xE60000FF, "[Errore] Comando invalido. Digita /aiuto per la lista dei comandi.");


public OnPlayerCommandPerformed(playerid, cmdtext[], success) {
	if (!success) {
		return SendClientMessage(playerid, 0xE60000FF, "[Errore] Comando invalido. Digita /aiuto per la lista dei comandi.");
	}
	return 1;
}


// ====================================================================
// AGGIORNA TEMPO E WEATHER

public UpdateTimeAndWeather()
{
	// Update time
	gettime(hour, minute);
	format(timestr,32,"%02d:%02d",hour,minute);
	TextDrawSetString(txtTimeDisp,timestr);
	SetWorldTime(hour);
	
	new x=0;
	while(x!=MAX_PLAYERS) {
		if(IsPlayerConnected(x) && GetPlayerState(x) != PLAYER_STATE_NONE) {
			SetPlayerTime(x,hour,minute);
		}
		x++;
	}

	/* Update weather every hour
	if(last_weather_update == 0) {
	    UpdateWorldWeather();
	}
	last_weather_update++;
	if(last_weather_update == 60) {
	    last_weather_update = 0;
	}*/
	}


// ====================================================================
// PLAYER ENTRA NEL VEICOLO

	public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
	{
		return 1;
	}

// ====================================================================
// PLAYER ESCE DAL VEICOLO

	public OnPlayerExitVehicle(playerid, vehicleid)
	{
		return 1;
	}

// ====================================================================
// PLAYER CAMBIA STATO

	public OnPlayerStateChange(playerid, newstate, oldstate)
	{
		return 1;
	}

// ====================================================================
// CHECKPOINT

	public OnPlayerEnterCheckpoint(playerid)
	{
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		GameTextForPlayer(playerid,"~w~CheckPoint ~b~raggiunto",1000,5);

   // SendClientMessage(playerid, 0x00C2ECFF, ".:: Sei arrivato al CheckPoint! ::.");
   // DisablePlayerCheckpoint(playerid);
		return 1;
	}

// ====================================================================
// PLAYER ESCE DAL CHECKPOINT

	public OnPlayerLeaveCheckpoint(playerid)
	{
		return 1;
	}

// ====================================================================
// PLAYER ENTRA NELLA GARA CON IL CHECKPOINT

	public OnPlayerEnterRaceCheckpoint(playerid)
	{
		return 1;
	}

// ====================================================================
// PLAYER " LASCIA*

	public OnPlayerLeaveRaceCheckpoint(playerid)
	{
		return 1;
	}

// ====================================================================
// AL COMANDO RCON..

	public OnRconCommand(cmd[])
	{
		return 1;
	}

// ====================================================================
// PLAYER RICHIEDE SPAWN

	public OnPlayerRequestSpawn(playerid)
	{
		if(pRank[playerid] > 0){
			return 1;
		}else{
			return 0;
		}
	}

// ====================================================================
// QUANDO L'OGGETTO VIENE MOSSO

	public OnObjectMoved(objectid)
	{
		return 1;
	}

// ====================================================================
// .........

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

// ====================================================================
//  CAMBIO DI INTERIORS

	public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
	{
	// SE QUALCUNO STA SPECTANDO, CAMBIA INTERIOR ID
		new x = 0;
		while(x!=MAX_PLAYERS) {
			if( IsPlayerConnected(x) &&	GetPlayerState(x) == PLAYER_STATE_SPECTATING &&
				gSpectateID[x] == playerid && gSpectateType[x] == ADMIN_SPEC_TYPE_PLAYER )
			{
				SetPlayerInterior(x,newinteriorid);
			}
			x++;
		}
	}

// ====================================================================
// PREME UN BOTTONE


	public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
	{
    if(newkeys == KEY_SUBMISSION) // 2
    {
    	if(Simulazione == false){
    		
    		if(IsPlayerInAnyVehicle(playerid))
    		{
    			RepairVehicle(GetPlayerVehicleID(playerid));
    			new str[128];
    			format(str, 128, "%s ha fixato il suo veicolo.", NameRP(playerid));
    			SendClientMessageToAll(COLOR_VEHFIX, str);
    		}
    	}else{ ErroreSim(playerid); }
    	
    }

    if(newkeys == KEY_SECONDARY_ATTACK) // F o Invio
    {
    	if(IsPlayerInRangeOfPoint(playerid, 3.0, 1567.4233398438, -1634.6782226563, 13.89)
    		|| IsPlayerInRangeOfPoint(playerid, 3.0, 1567.4233398438, -1634.6782226563, 17.50)
    		|| IsPlayerInRangeOfPoint(playerid, 3.0, 1567.4233398438, -1634.6782226563, 21.50)
    		|| IsPlayerInRangeOfPoint(playerid, 3.0, 1567.4233398438, -1634.6782226563, 25.50)
    		|| IsPlayerInRangeOfPoint(playerid, 3.0, 1567.4233398438, -1634.6782226563, 28.62))
    	{
    		if(ElevatorStatus == false)
    		{
				MoveObject(caselev, 1567.4233398438, -1634.6782226563, 28.62163734436,4); // dal basso verso l'alto
				ElevatorStatus = true;
			}else if(ElevatorStatus == true){
      			MoveObject(caselev, 1567.4233398438, -1634.6782226563, 13.896639823914,4); // dall'alto verso il basso
      			ElevatorStatus = false;
      		}
      	}else{ return 0; }
      	
      }    
      return 1;
  }


// ====================================================================
// SE IL PLAYER SHOOTA UN ALTRO PLAYER


  public OnPlayerGiveDamage(playerid, damagedid, Float: amount, weaponid, bodypart)
  {

	if (GetPlayerTeam(playerid) == GetPlayerTeam(damagedid)) // controlla se la vittima � dello stesso team dell'attaccante
	{
		
		if(TeamKill == true){
			new Float:hp, Float:ar;
			GetPlayerHealth(damagedid, hp);
			GetPlayerArmour(damagedid, ar);
			SetPlayerArmour(damagedid, ar - amount*2);
			SetPlayerHealth(damagedid, hp - amount);
			return 1;
		}

	}
	
	if(bodypart == BODY_PART_HEAD)
	{
		if(TeamKill == false && GetPlayerTeam(playerid) == GetPlayerTeam(damagedid)) return 1;
		if(Simulazione == true){
			SetPlayerHealth(damagedid, 0);
			GameTextForPlayer(playerid, "~r~ HEADSHOT", 2000, 5);
			GameTextForPlayer(damagedid, "~r~ SEI STATO HEADSHOTTATO", 2000, 5);
		}
	}
	

	if(Simulazione == true){
		
		if(GetPlayerTeam(playerid) == 0)
		{
			if(GetPlayerWeapon(playerid) == 23 && pTazer[playerid] == 1)
			{
				TogglePlayerControllable(damagedid, false);
				ApplyAnimation(damagedid,"CRACK","crckdeth2",4.1,1,1,1,1,1);
				pTazed[damagedid] = 1;
				SetTimerEx("Tazed", 10000, 0, "d", damagedid);
				GameTextForPlayer(damagedid, "~b~SEI STATO TAZERATO", 2000, 5);
				SetPlayerChatBubble(damagedid, "* � stato colpito da un Tazer *", COLOR_AME, 10.0, 7000);
				SendClientMessage(damagedid, COLOR_AME, "* � stato colpito da un Tazer *");
			}
		}
	}
	
	return 1;

}

// ====================================================================
// TENTATO LOGIN

public OnRconLoginAttempt(ip[], password[], success)
{

	printf("LOGIN COME RCON FALLITO DALL'IP %s USANDO LA PASSWORD %s",ip, password);
	new pip[16];

 		for(new i=0; i<MAX_PLAYERS; i++) //Loop through all players
 		{
 			GetPlayerIp(i, pip, sizeof(pip));

			    if(!strcmp(ip, pip, true)) //If a player's IP is the IP that failed the login
			    {
			    	if(pRank[i]==3){
			    		return 1;
			    	}else{
			    		SendClientMessage(i, COLOR_WHITE, "[ERRORE] Non possiedi i permessi necessari per poter entrare come admin!");
			    		Kick(i);
			    	}
			    }
			}
			
			return 1;
		}

// ====================================================================
// AGGIORNA IL PLAYER

		public OnPlayerUpdate(playerid)
		{
			if(!IsPlayerConnected(playerid)) return 0;

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			{
				for(new i = 0; i < sizeof(Roadblocks); i++)
				{
					if(IsPlayerInRangeOfPoint(playerid, 3.0, Roadblocks[i][sX], Roadblocks[i][sY], Roadblocks[i][sZ]))
					{
						if(Roadblocks[i][sCreated] == 1)
						{
							if(Roadblocks[i][sSpike] == 1){
								
								new panels, doors, lights, tires;
								new carid = GetPlayerVehicleID(playerid);
								GetVehicleDamageStatus(carid, panels, doors, lights, tires);
								tires = encode_tires(1, 1, 1, 1);
								UpdateVehicleDamageStatus(carid, panels, doors, lights, tires);
								return 0;
							}
						}
					}
				}
			}

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

// ===================== ACCESSO A SCELTA MULTIPLA =====================

			if(dialogid == DIALOG_ACCESS)
			{
        if(response) // seleziona
        {
        	switch(listitem)
        	{
        		case 0: ShowPlayerDialog(playerid, DIALOG_LOGIN_ACCADEMICO, DIALOG_STYLE_INPUT, "Accesso al Training", "ACCADEMICO - Inserisci la password per l'accesso:", "Accedi", "Indietro");
        		case 1: ShowPlayerDialog(playerid, DIALOG_LOGIN_AGENTE, DIALOG_STYLE_INPUT, "Accesso al Training", "AGENTE - Inserisci la password per l'accesso:", "Accedi", "Cancella");
        		case 2: ShowPlayerDialog(playerid, DIALOG_LOGIN_ISTRUTTORE, DIALOG_STYLE_INPUT, "Accesso al Training", "ISTRUTTORE - Inserisci la password per l'accesso:", "Accedi", "Cancella");
        	}
        }
        else // esci
        {
        	Kick(playerid);
        }
        return 1;
    }
    
// ===================== ACCESSO COME ACCADEMICO pRank 1 =====================
    

    if(dialogid == DIALOG_LOGIN_ACCADEMICO)
    {
        if(response) // seleziona
        {
        	if(strcmp(inputtext, pswAccademico, false) == 0 && strlen(inputtext) > 0){
        		pRank[playerid] = 1;
        		pLogged[playerid] = true;
        		SendClientMessage(playerid, COLOR_GIALLO, "[ACCESSO] Hai effettuato l'accesso al grado di ACCADEMICO.");
        		SpawnPlayer(playerid);
        	}else{
        		SendClientMessage(playerid, COLOR_RED, "[ACCESSO] La password inserita � errata. Riprova.");
        		ShowPlayerDialog(playerid, DIALOG_LOGIN_ACCADEMICO, DIALOG_STYLE_INPUT, "Accesso al Training", "ACCADEMICO - Inserisci la password per l'accesso:", "Accedi", "Indietro");
        	}
        }
        else // esci
        {
        	ShowPlayerDialog(playerid, DIALOG_ACCESS, DIALOG_STYLE_LIST, "Seleziona la modalit� di accesso", "Accademico\nAgente\nIstruttore", "Seleziona", "Esci");
        }
        return 1;
    }

// ===================== ACCESSO COME AGENTE pRank 2 =====================


    if(dialogid == DIALOG_LOGIN_AGENTE)
    {
        if(response) // seleziona
        {
        	if(strcmp(inputtext, pswAgente, false) == 0 && strlen(inputtext) > 0){
        		pRank[playerid] = 2;
        		pLogged[playerid] = true;
        		SendClientMessage(playerid, COLOR_GRAD1, "[ACCESSO] Hai effettuato l'accesso al grado di AGENTE.");
        		SpawnPlayer(playerid);
        	}else{
        		SendClientMessage(playerid, COLOR_RED, "[ACCESSO] La password inserita � errata. Riprova.");
        		ShowPlayerDialog(playerid, DIALOG_LOGIN_AGENTE, DIALOG_STYLE_INPUT, "Accesso al Training", "AGENTE - Inserisci la password per l'accesso:", "Accedi", "Indietro");
        	}
        }
        else // esci
        {
        	ShowPlayerDialog(playerid, DIALOG_ACCESS, DIALOG_STYLE_LIST, "Seleziona la modalit� di accesso", "Accademico\nAgente\nIstruttore", "Seleziona", "Esci");
        }
        return 1;
    }
    
// ===================== ACCESSO COME ACCADEMICO pRank 1 =====================


    if(dialogid == DIALOG_LOGIN_ISTRUTTORE)
    {
        if(response) // seleziona
        {
        	if(strcmp(inputtext, pswIstruttore, false) == 0 && strlen(inputtext) > 0){
        		pRank[playerid] = 3;
        		pLogged[playerid] = true;
        		SendClientMessage(playerid, COLOR_ORANGE, "[ACCESSO] Hai effettuato l'accesso al grado di ISTRUTTORE.");
        		SpawnPlayer(playerid);
        	}else{
        		SendClientMessage(playerid, COLOR_RED, "[ACCESSO] La password inserita � errata. Riprova.");
        		ShowPlayerDialog(playerid, DIALOG_LOGIN_ISTRUTTORE, DIALOG_STYLE_INPUT, "Accesso al Training", "ISTRUTTORE - Inserisci la password per l'accesso:", "Accedi", "Indietro");
        	}
        }
        else // esci
        {
        	ShowPlayerDialog(playerid, DIALOG_ACCESS, DIALOG_STYLE_LIST, "Seleziona la modalit� di accesso", "Accademico\nAgente\nIstruttore", "Seleziona", "Esci");
        }
        return 1;
    }



// ===================== DIALOG SCELTA ARMI =====================


    if(dialogid == DIALOG_ARMI)
    {
    	new string[128];

        if(response) // seleziona
        {
        	switch(listitem)
        	{
        		case 0: { wepid[playerid] = 3; return GivePlayerWeapon(playerid, wepid[playerid], 1); }
        		case 1: { wepid[playerid] = 41; return GivePlayerWeapon(playerid, wepid[playerid], 1500); }
        		case 2: { wepid[playerid] = 4;  return GivePlayerWeapon(playerid, wepid[playerid], 1); }
        		case 3: { wepid[playerid] = 22; }
        		case 4: { wepid[playerid] = 23; }
        		case 5: { wepid[playerid] = 24; }
        		case 6: { wepid[playerid] = 25; }
        		case 7: { wepid[playerid] = 27; }
        		case 8: { wepid[playerid] = 29; }
        		case 9: { wepid[playerid] = 31; }
        		case 10: { wepid[playerid] = 33; }
        		case 11: { wepid[playerid] = 34; }
        		case 12: { wepid[playerid] = 43; return GivePlayerWeapon(playerid, wepid[playerid], 100); }
        		case 13: { wepid[playerid] = 17; return GivePlayerWeapon(playerid, wepid[playerid], 2); }
        	}

        	format(string, sizeof(string), "Inserisci la quantita' di munizioni da inserire nell'arma %s:", TrovaNomeArma(wepid[playerid]));
        	return ShowPlayerDialog(playerid, DIALOG_MUNIZIONI, DIALOG_STYLE_INPUT, "Armeria Dipartimentale", string, "Equipaggia", "Indietro");
        }
        else // esci
        {
        	return 0;
        }
       // return 1;
    }    


// ===================== DIALOG MUNIZIONI =====================    

    if(dialogid == DIALOG_MUNIZIONI)
    {

        if(response) // seleziona
        {
        	if(wepid[playerid]>0){
        		
        		if(IsNumeric(inputtext)){

        			new ammo = strval(inputtext);

        			// ** Zona Permessi Costruttibile con ammo e wepid[playerid] **

        			if(ammo>120){ 
        				return SendClientMessage(playerid, COLOR_RED, "[Errore] Puoi inserire un massimo di 120 munizioni per arma.");
        			}else{
        				
        				return GivePlayerWeapon(playerid, wepid[playerid], ammo);	
        			}

        		}else{
        			
        			new string[128];
        			SendClientMessage(playerid, COLOR_RED, "[Errore] Devi inserire solo un valore numerico minore di 120.");
        			format(string, sizeof(string), "Inserisci la quantita' di munizioni da inserire nell'arma %s:", TrovaNomeArma(wepid[playerid]));
        			ShowPlayerDialog(playerid, DIALOG_MUNIZIONI, DIALOG_STYLE_INPUT, "Armeria Dipartimentale", string, "Equipaggia", "Indietro");
        			return 0;
        		}
        		
        	}else{ 
        		
        		return 0; 
        	}
        }
	    else // esci
	    {
	    	ShowPlayerDialog(playerid, DIALOG_ARMI, DIALOG_STYLE_LIST, "Armeria Dipartimentale", "Manganello\nSpray\nColtello\n{FFF6DA}Colt45\n{FFF6DA}Colt45 Silenziata\n{FFF6DA}Desert Eagle\n{FFB189}Fucile a Pompa\n{FFB189}Spass 12\n{FF9789}MP5\n{FF9789}M4A1\n{FF4646}Fucile Semi-Automatico\n{FF4646}Fucile da Cecchino\n{DFDFDF}Fotocamera\n{DFDFDF}Lacrimogeno", "Seleziona", "Esci");	
	    }
	    
       // return 1;
	}    

// ===================== DIALOG SERVIZIO DA SISTEMARE =====================

	if(dialogid == DIALOG_ONDUTY)
	{
        if(response) // seleziona
        {
        	switch(listitem)
        	{
        		case 0: { SendClientMessage(playerid, -1, "[Servizio] Usa /skin per selezionare la tua skin."); return do_police(playerid); }
        		case 1: { SendClientMessage(playerid, -1, "[Servizio] La /skin non verr� salvata con questo equipaggiamento quando morirai."); return do_swat(playerid); }
        		case 2: { SendClientMessage(playerid, -1, "[Servizio] La /skin non verr� salvata con questo equipaggiamento quando morirai."); return do_riot(playerid); }
        		case 3: { SendClientMessage(playerid, -1, "[Servizio] Usa /skin per selezionare la tua skin."); return do_criminal(playerid); }
        	}
        	
        	return 1;
        }
        else // esci
        {
        	return 1;
        }

    }
    



// Fine

    return 0;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}


// ====================================================================
// PLAYER AL PUNTO


public PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z)
{
	if(IsPlayerConnected(playerid))
	{
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		tempposx = (oldposx -x);
		tempposy = (oldposy -y);
		tempposz = (oldposz -z);
        //printf("DEBUG: X:%f Y:%f Z:%f",posx,posy,posz);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
		{
			return 1;
		}
	}
	return 0;
}

// ====================================================================
// PUBLIC


public DelayedKick(playerid)
{
	Kick(playerid);
}


public Tazed(playerid)
{
	pTazed[playerid] = 0;
	TogglePlayerControllable(playerid, true);
	ClearAnimations(playerid);
	return 1;
}


// ====================================================================
// STOCK


encode_tires(tires1, tires2, tires3, tires4) {

	return tires1 | (tires2 << 1) | (tires3 << 2) | (tires4 << 3);

}


stock SendAdminMessage(color, message[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerAdmin(i) == 1 || pRank[i] >= 3) return SendClientMessage(i, color, message);
		else return 1;
	}
	return 1;
}


stock SendTeamMessage(team, color, message[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(GetPlayerTeam(i) == team)
		{
			SendClientMessage(i, color, message);
		}
	}
}


stock NameCheck(playerid)
{
//	new string[128];
	new namecheck = strfind(Name(playerid), "_", true);
	if(namecheck == -1)
	{
		ShowPlayerDialog(playerid, DIALOG_REJECT, DIALOG_STYLE_MSGBOX, "Avviso", "Per loggare nel server devi utilizzare il tuo nome roleplay di AC-RP.\nFORMATO: Nome_Cognome", "Chiudi", "");
		new pName[24];
		new str[128];
		GetPlayerName(playerid, pName, 24);
		format(str, 128, "%s � uscito dal server [Auto-Kick].", pName);
		SendClientMessageToAll(COLOR_RED, str);
		SetTimerEx("DelayedKick", 1000, false, "d", playerid);
	}
	return 1;
}


stock SendLocalMessage(playerid, msg[], Float:MessageRange, Range1color, Range2color)
{
	new Float: PlayerX, Float: PlayerY, Float: PlayerZ;
	GetPlayerPos(playerid, PlayerX, PlayerY, PlayerZ);
	for(new i = 0; i < MAX_PLAYERS; i++ )
	{
		if(IsPlayerInRangeOfPoint(i, MessageRange, PlayerX, PlayerY,PlayerZ))
		{
			SendClientMessage(i, Range1color, msg);
		}
		else if(IsPlayerInRangeOfPoint(i, MessageRange/2.0, PlayerX, PlayerY,PlayerZ))
		{
			SendClientMessage(i, Range2color, msg);
		}
	}
	return 1;
}


stock ErroreSim(playerid)
{
	SendClientMessage(playerid, COLOR_RED, "[Errore] La simulazione risulta attivata e pertanto non puoi usare questo comando!");
	return 1;
}


stock ErroreSim2(playerid)
{
	SendClientMessage(playerid, COLOR_RED, "[Errore] La simulazione risulta disattivata e pertanto non puoi usare questo comando!");
	return 1;
}

stock ErroreSpa(playerid)
{
	SendClientMessage(playerid, COLOR_RED, "[Errore] Lo spawn delle auto con /car � attualmente disattivato per gli utenti.");
	return 1;
}


stock TextFormat(textBefore, textMiddle, textAfter){
	new string[128];
	format(string, 128, "%s %s %s", textBefore, textMiddle, textAfter);
	return string;
}


stock Name(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	return name;
}



stock NameRP(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	name[strfind(name,"_")] = ' ';
	return name;
}


stock IsVehicleOccupied(vehicleid) // Returns 1 if there is anyone in the vehicle
{
	for(new i2 = 0; i2 < MAX_PLAYERS; i2++)
	{
		if(IsPlayerInAnyVehicle(i2))
		{
			if(GetPlayerVehicleID(i2)==vehicleid)
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
	}
	return 0;
}

stock CreateRoadblock(Object,Float:x,Float:y,Float:z,Float:Angle)
{
	for(new i = 0; i < sizeof(Roadblocks); i++)
	{
		if(Roadblocks[i][sCreated] == 0)
		{
			Roadblocks[i][sCreated] = 1;
			Roadblocks[i][sX] = x;
			Roadblocks[i][sY] = y;
			Roadblocks[i][sZ] = z-0.7;
			if(Object == 2899){ Roadblocks[i][sSpike] = 1; }
			else{ Roadblocks[i][sSpike] = 0; }
			Roadblocks[i][sObject] = CreateDynamicObject(Object, x, y, z-0.9, 0, 0, Angle);
			return 1;
		}
	}
	return 0;
}

stock DeleteAllRoadblocks(playerid)
{
	for(new i = 0; i < sizeof(Roadblocks); i++)
  	{ // default: 100
  		if(IsPlayerInRangeOfPoint(playerid, 1000, Roadblocks[i][sX], Roadblocks[i][sY], Roadblocks[i][sZ]))
  		{
  			if(Roadblocks[i][sCreated] == 1)
  			{
  				Roadblocks[i][sCreated] = 0;
  				Roadblocks[i][sX] = 0.0;
  				Roadblocks[i][sY] = 0.0;
  				Roadblocks[i][sZ] = 0.0;
  				Roadblocks[i][sSpike] = 0;
  				DestroyDynamicObject(Roadblocks[i][sObject]);
  			}
  		}
  	}
  	return 0;
  }

  stock DeleteClosestRoadblock(playerid)
  {
  	for(new i = 0; i < sizeof(Roadblocks); i++)
  	{
  		if(IsPlayerInRangeOfPoint(playerid, 5.0, Roadblocks[i][sX], Roadblocks[i][sY], Roadblocks[i][sZ]))
  		{
  			if(Roadblocks[i][sCreated] == 1)
  			{
  				Roadblocks[i][sCreated] = 0;
  				Roadblocks[i][sX] = 0.0;
  				Roadblocks[i][sY] = 0.0;
  				Roadblocks[i][sZ] = 0.0;
  				Roadblocks[i][sSpike] = 0;
  				DestroyDynamicObject(Roadblocks[i][sObject]);
  				return 1;
  			}
  		}
  	}
  	return 0;
  }


  stock GetVehicleIDFromName(modelname[]) {
  	for (new i = 400; i <= 611; i++) {
  		if (strcmp(modelname, VehicleName[i-400], true) == 0) {
  			return i;
  		}
  	}
  	return 0;
  }

  stock clearChat(playerid, times)
  {
  	for(new j=0; j<times; j++)
  	{
  		SendClientMessage(playerid, -1, "");
  	}
  	return 1;
  }


  stock CreateScriptObject(modelid, Float:X, Float:Y, Float:Z, Float:rX, Float:rY, Float:rZ)
  {
  	new objectid = CreateObject(modelid, X, Y, Z, rX, rY, rZ);
  	ScriptObject[objectid] = true;
  }

/*
stock CreateScriptVehicle(vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2)
{
    new vehid = CreateVehicle(vehicletype, x, y, z, rotation, color1, color2, 1200);
    ScriptVehicle[vehid] = true;
    return 1; 
}
*/

stock DestroyScriptObjects()
{
	for(new o=0; o<sizeof(ScriptObject); o++)
	{
		if(ScriptObject[o])
		{
			DestroyObject(o);
			ScriptObject[o]=false;
		}
	}
}


stock DestroyScriptVehicles()
{
	for(new o=0; o<sizeof(ScriptVehicle); o++)
	{
		if(ScriptVehicle[o])
		{
			DestroyVehicle(o);
			ScriptVehicle[o]=false;
		}
	}
}


stock AddestramentoSparatoria(){

					// Zona Training Swat / Polizia a LS
	CreateScriptObject(853, 1883, -2001.59998, 12.9, 0, 0, 0);
	CreateScriptObject(987, 1813, -2077.69995, 12.4, 0, 0, 0);
	CreateScriptObject(987, 1824.69995, -2077.8999, 12.4, 0, 0, 48.551);
	CreateScriptObject(987, 1830, -2074.30005, 12.4, 0, 0, 71.165);
	CreateScriptObject(987, 1809.69995, -2007.90002, 12.6, 0, 0, 271.121);
	CreateScriptObject(987, 1809.69995, -1996, 12.6, 0, 0, 270.291);
	CreateScriptObject(987, 1809.69995, -1984.09998, 12.6, 0, 0, 269.461);
	CreateScriptObject(987, 1809.69922, -1972.19922, 12.6, 0, 0, 268.627);
	CreateScriptObject(987, 1809.80005, -1971.19995, 12.6, 0, 0, 267.797);
	CreateScriptObject(987, 1821.5, -1970.90002, 12.6, 0, 0, 181.547);
	CreateScriptObject(987, 1833.19995, -1970.59998, 12.6, 0, 0, 181.544);
	CreateScriptObject(987, 1844.8999, -1970.29993, 12.6, 0, 0, 181.54);
	CreateScriptObject(987, 1856.59985, -1969.99988, 12.6, 0, 0, 181.537);
	CreateScriptObject(987, 1868.2998, -1969.69983, 12.6, 0, 0, 181.533);
	CreateScriptObject(987, 1879.99976, -1969.39978, 12.6, 0, 0, 181.53);
	CreateScriptObject(987, 1891.69971, -1969.09973, 12.6, 0, 0, 181.526);
	CreateScriptObject(987, 1903.39966, -1968.79968, 12.6, 0, 0, 181.523);
	CreateScriptObject(987, 1915.09961, -1968.49963, 12.6, 0, 0, 181.52);
	CreateScriptObject(987, 1926.79883, -1968.19922, 12.6, 0, 0, 181.516);
	CreateScriptObject(987, 1928.69995, -1968.19995, 12.6, 0, 0, 181.516);
	CreateScriptObject(987, 1928.59998, -1980, 12.6, 0, 0, 90.221);
	CreateScriptObject(987, 1844.69995, -2061.5, 12.4, 0, 0, 193.298);
	CreateScriptObject(987, 1856.40002, -2061.3999, 12.4, 0, 0, 180.85);
	CreateScriptObject(987, 1868.30005, -2061.19995, 12.4, 0, 0, 180.846);
	CreateScriptObject(987, 1880.20007, -2061, 12.4, 0, 0, 180.842);
	CreateScriptObject(987, 1892.1001, -2060.80005, 12.4, 0, 0, 180.839);
	CreateScriptObject(987, 1904, -2060.59961, 12.4, 0, 0, 180.835);
	CreateScriptObject(987, 1913.19995, -2062.5, 12.4, 0, 0, 170.874);
	CreateScriptObject(987, 1928.69995, -1991.80005, 12.4, 0, 0, 90.442);
	CreateScriptObject(987, 1928.79993, -2003.6001, 12.2, 0, 0, 90.663);
	CreateScriptObject(987, 1928.8999, -2015.40015, 12, 0, 0, 90.884);
	CreateScriptObject(987, 1928.99988, -2027.2002, 11.8, 0, 0, 91.105);
	CreateScriptObject(987, 1929.09961, -2039, 11.6, 0, 0, 91.324);
	CreateScriptObject(987, 1929, -2047.5, 11.6, 0, 0, 91.324);
	CreateScriptObject(3749, 1927.30005, -2053.6001, 18, 0, 0, 269.462);
	CreateScriptObject(987, 1925.5, -2063, 12.4, 0, 0, 177.507);
	CreateScriptObject(987, 1925.09998, -2063.1001, 12.4, 0, 0, 177.506);
	CreateScriptObject(923, 1878, -1985, 13.4, 0, 0, 0);
	CreateScriptObject(923, 1872.19922, -2011.09961, 13.4, 0, 0, 0);
	CreateScriptObject(2912, 1894.59998, -2016.09998, 12.5, 0, 0, 0);
	CreateScriptObject(1431, 1893.19995, -2016.09998, 13.1, 0, 0, 0);
	CreateScriptObject(2567, 1873.59998, -1986.80005, 14.5, 0, 0, 0);
	CreateScriptObject(3577, 1872.30005, -2038.09998, 13.3, 0, 0, 120.62);
	CreateScriptObject(18451, 1857.09998, -2010.30005, 13.1, 0, 0, 201.685);
	CreateScriptObject(3374, 1912.09998, -1995.19995, 14, 0, 0, 0);
	CreateScriptObject(3374, 1903.39941, -2023.39941, 14, 0, 0, 0);
	CreateScriptObject(1225, 1844.69995, -1972.80005, 13, 0, 0, 0);
	CreateScriptObject(1225, 1888.89941, -2001.7998, 13, 0, 0, 0);
	CreateScriptObject(1225, 1839.7998, -2003.7998, 13, 0, 0, 0);
	CreateScriptObject(2780, 1868.30005, -2019.59998, 12.5, 0, 0, 0);
	CreateScriptObject(1558, 1854, -2022.90002, 13.1, 0, 0, 0);
	CreateScriptObject(3091, 1882.40002, -2021.40002, 13, 0, 0, 0);
	CreateScriptObject(2890, 1872.90002, -2020.90002, 12.5, 0, 0, 0);
	CreateScriptObject(1358, 1887.69995, -1984.19995, 13.8, 0, 0, 0);
	CreateScriptObject(1237, 1806.30005, -2062.5, 12.6, 0, 0, 0);
	CreateScriptObject(1237, 1812.19995, -2062.6001, 12.6, 0, 0, 0);
	CreateScriptObject(979, 1806.19995, -2048.69995, 13.4, 0, 0, 270.364);
	CreateScriptObject(1237, 1806.30005, -2053.69995, 12.6, 0, 0, 0);
	CreateScriptObject(1237, 1806.09998, -2043.90002, 12.6, 0, 0, 0);
	CreateScriptObject(979, 1803.59998, -2039.69995, 13.4, 0, 0, 301.347);
	CreateScriptObject(1237, 1801.09998, -2035.5, 12.6, 0, 0, 0);
	CreateScriptObject(1237, 1812, -2034, 12.6, 0, 0, 0);
	CreateScriptObject(979, 1807.69995, -2032.59998, 13.4, 0, 0, 339.038);
	CreateScriptObject(1237, 1803.30005, -2030.80005, 12.6, 0, 0, 0);
	CreateScriptObject(979, 1796.90002, -2033.80005, 13.4, 0, 0, 339.038);
	CreateScriptObject(979, 1799, -2029.19995, 13.4, 0, 0, 339.033);
	CreateScriptObject(1237, 1794.5, -2027.40002, 12.6, 0, 0, 0);
	CreateScriptObject(1237, 1792.40002, -2032.09998, 12.6, 0, 0, 0);
	CreateScriptObject(979, 1787.59998, -2033.59998, 13.4, 0, 0, 16.727);
	CreateScriptObject(979, 1789.80005, -2028.09998, 13.4, 0, 0, 9.188);
	CreateScriptObject(1237, 1785, -2028.80005, 12.6, 0, 0, 0);
	CreateScriptObject(1237, 1782.90002, -2034.90002, 12.6, 0, 0, 0);
	CreateScriptObject(979, 1780.40002, -2029.59998, 13.4, 0, 0, 9.185);
	CreateScriptObject(1237, 1775.69995, -2030.40002, 12.6, 0, 0, 0);
	CreateScriptObject(979, 1783.09998, -2039.69995, 13.4, 0, 0, 92.109);
	CreateScriptObject(979, 1776, -2035.19995, 13.4, 0, 0, 92.111);
	CreateScriptObject(1237, 1776, -2040.09998, 12.6, 0, 0, 0);
	CreateScriptObject(1237, 1783.30005, -2044.59998, 12.6, 0, 0, 0);
	CreateScriptObject(979, 1776.19995, -2044.40002, 13.4, 0, 0, 93.769);
	CreateScriptObject(979, 1783.40002, -2049.19995, 13.4, 0, 0, 92.104);
	CreateScriptObject(979, 1780.19995, -2057.8999, 13.4, 0, 0, 48.536);
	CreateScriptObject(1237, 1783.40002, -2054.19995, 12.6, 0, 0, 0);
	CreateScriptObject(1225, 1777.40002, -2052.80005, 13, 0, 0, 0);
	CreateScriptObject(1237, 1776.40002, -2049.30005, 12.6, 0, 0, 0.83);
	CreateScriptObject(979, 1773.19995, -2052.8999, 13.4, 0, 0, 48.536);
	CreateScriptObject(1225, 1776.5, -2057.69995, 13, 0, 0, 0);
	CreateScriptObject(1225, 1771.90002, -2058, 13, 0, 0, 0);
	return 1;
}


stock AddestramentoRiot(){

	// ZONA CROWD AND RIOT CONTROL (LAS COLLINAS - PIG PEN) - VECCHIO MAP
    /*CreateScriptObject(3569, 2450.75122, -1325.67065, 24.46370,   0.00000, -90.00000, 45.00000);
	CreateScriptObject(18260, 2445.68359, -1341.57410, 22.39580,   0.00000, 0.00000, 35.00000);
	CreateScriptObject(18260, 2456.52124, -1339.70557, 22.39580,   0.00000, 0.00000, -35.00000);
	CreateScriptObject(944, 2443.50024, -1331.19702, 23.83890,   0.00000, 0.00000, 0.00000);
	CreateScriptObject(1297, 2441.91382, -1315.85364, 24.08660,   70.00000, 0.00000, -90.00000);
	CreateScriptObject(1297, 2445.80444, -1282.88147, 24.78660,   -9.36000, -35.00000, -252.72000);
	CreateScriptObject(944, 2456.17578, -1329.40601, 23.99890,   90.00000, 90.00000, 44.88000);
	CreateScriptObject(944, 2454.17480, -1327.38660, 23.99890,   90.00000, 90.00000, 44.88000);
	CreateScriptObject(944, 2454.15649, -1327.40930, 24.89890,   90.00000, 90.00000, 44.88000);
	CreateScriptObject(944, 2456.18164, -1329.44812, 24.89890,   90.00000, 90.00000, 44.88000);
	CreateScriptObject(18260, 2458.40942, -1316.46741, 22.15580,   0.00000, 0.00000, 24.32000);
	CreateScriptObject(3593, 2451.79614, -1307.36169, 23.29610,   0.00000, 0.00000, -67.80002);
	CreateScriptObject(3593, 2453.96558, -1348.95288, 23.29610,   0.00000, 0.00000, -101.58000);
	CreateScriptObject(18260, 2447.98657, -1314.34045, 22.39580,   0.00000, 0.00000, -34.18000);
	CreateScriptObject(3566, 2451.67969, -1360.53748, 25.20370,   0.00000, 0.00000, 46.26001);
	CreateScriptObject(18260, 2446.09399, -1370.35071, 22.39580,   0.00000, 0.00000, -62.68000);
	CreateScriptObject(0, 2446.48364, -1283.82385, 23.29610,   0.00000, 0.00000, -152.58000);
	CreateScriptObject(1297, 2444.66992, -1353.11194, 24.78660,   -9.36000, -35.00000, -402.96014);
	CreateScriptObject(0, 2448.15942, -1343.03015, 22.89740,   0.00000, 180.00000, -1.00000);
	CreateScriptObject(3593, 2453.00000, -1372.32361, 23.29610,   0.00000, 0.00000, -81.35997);*/

	CreateObject(18260, 2459.70215, -1335.26392, 22.39580,   0.00000, 0.00000, 35.00000);
	CreateObject(944, 2443.50024, -1331.19702, 23.83890,   0.00000, 0.00000, 0.00000);
	CreateObject(1297, 2441.91382, -1315.85364, 24.08660,   70.00000, 0.00000, -90.00000);
	CreateObject(3593, 2458.53882, -1290.76624, 23.29610,   0.00000, 0.00000, -25.02002);
	CreateObject(3593, 2458.45093, -1377.19019, 23.29610,   0.00000, 0.00000, -198.05997);
	CreateObject(18260, 2445.70923, -1309.36646, 22.39580,   0.00000, 0.00000, -78.63998);
	CreateObject(0, 2446.48364, -1283.82385, 23.29610,   0.00000, 0.00000, -152.58000);
	CreateObject(1297, 2444.66992, -1353.11194, 24.78660,   -9.36000, -35.00000, -402.96014);
	CreateObject(0, 2448.15942, -1343.03015, 22.89740,   0.00000, 180.00000, -1.00000);
	CreateObject(3593, 2443.12329, -1342.70789, 23.29610,   0.00000, 0.00000, -156.95996);
	CreateObject(944, 2443.19751, -1379.80249, 23.83890,   0.00000, 0.00000, -100.74001);
	CreateObject(944, 2458.67212, -1397.99011, 23.83890,   0.00000, 0.00000, -36.78001);	
	return 1;
}


stock RimuoviBuilding(playerid){

	// Rimozione Edificio a US per mettere Fontana di Unity Station

	RemoveBuildingForPlayer(playerid, 4025, 1777.8359, -1773.9063, 12.5234, 0.25);
	RemoveBuildingForPlayer(playerid, 4215, 1777.5547, -1775.0391, 36.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 4019, 1777.8359, -1773.9063, 12.5234, 0.25);
	
	// Rimozioni Aeroporto
	
	RemoveBuildingForPlayer(playerid, 4990, 1646.1953, -2414.0703, 17.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 5010, 1646.1953, -2414.0703, 17.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 5011, 1874.2109, -2286.5313, 17.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 3672, 1921.6406, -2206.3906, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3672, 2030.0547, -2249.0234, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3672, 2030.0547, -2315.4297, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3672, 2030.0547, -2382.1406, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3672, 2112.9375, -2384.6172, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3672, 1889.6563, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3672, 1822.7344, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3672, 1682.7266, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3672, 1617.2813, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 5044, 1818.9141, -2543.6719, 13.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 3672, 1754.1719, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3769, 1961.4453, -2216.1719, 14.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 3744, 2061.5313, -2209.8125, 14.9766, 0.25);
	RemoveBuildingForPlayer(playerid, 3744, 2082.4063, -2269.6563, 14.9609, 0.25);
	RemoveBuildingForPlayer(playerid, 3744, 2082.4375, -2298.2266, 14.9609, 0.25);
	RemoveBuildingForPlayer(playerid, 3744, 2082.4063, -2370.0156, 14.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 3769, 2060.6875, -2305.9609, 14.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 3769, 2060.6875, -2371.8828, 14.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 1268, 1577.2344, -2668.4297, 16.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 3780, 1884.1719, -2541.3750, 14.2500, 0.25);
	RemoveBuildingForPlayer(playerid, 3780, 1652.3438, -2541.3750, 14.2500, 0.25);
	RemoveBuildingForPlayer(playerid, 3780, 1381.1172, -2541.3750, 14.2500, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1607.0156, -2439.9766, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 1617.2813, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1620.3594, -2476.8516, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1620.3594, -2511.0781, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1620.3594, -2576.2109, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1620.3594, -2610.4375, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1649.0625, -2641.4063, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 3665, 1652.3438, -2541.3750, 14.2500, 0.25);
	RemoveBuildingForPlayer(playerid, 3663, 1664.4531, -2439.8047, 14.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 1682.7266, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1686.4453, -2439.9766, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1705.0391, -2576.2109, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1705.0391, -2610.4375, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1705.0391, -2476.8516, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1705.0391, -2511.0781, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 1754.1719, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1766.7969, -2439.9766, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1789.7188, -2576.2109, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1789.7188, -2610.4375, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1789.7188, -2511.0781, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1789.7188, -2476.8516, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 1822.7344, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3663, 1832.4531, -2388.4375, 14.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1855.7969, -2641.4063, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1874.3984, -2576.2109, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1874.3984, -2610.4375, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 1889.6563, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1922.2031, -2641.4063, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1874.3984, -2511.0781, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3665, 1884.1719, -2541.3750, 14.2500, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1874.3984, -2476.8516, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3663, 1882.2656, -2395.7813, 14.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1959.0781, -2610.4375, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1959.0781, -2576.2109, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1959.0781, -2476.8516, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1959.0781, -2511.0781, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 2003.4531, -2422.1719, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1980.9219, -2413.8750, 13.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1980.9219, -2355.2109, 13.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 2003.4531, -2350.7344, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 2030.0547, -2382.1406, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 2043.7578, -2576.2109, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 2043.7578, -2610.4375, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3664, 2042.7734, -2442.1875, 19.2813, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 2043.7578, -2476.8516, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 2043.7578, -2511.0781, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 2057.7344, -2402.9922, 12.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 3625, 2060.6875, -2371.8828, 14.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 2088.6094, -2422.1719, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2082.4063, -2370.0156, 14.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 2089.3047, -2359.7578, 12.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 2088.6094, -2350.7344, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 2128.4375, -2511.0781, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 2128.4375, -2576.2109, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 2131.0156, -2608.5234, 13.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 2128.4375, -2476.8516, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 2146.0156, -2409.3516, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 2112.9375, -2384.6172, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 5006, 1874.2109, -2286.5313, 17.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1899.4219, -2328.1406, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1899.4219, -2244.5078, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1983.8594, -2281.7109, 13.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 3664, 1960.6953, -2236.4297, 19.2813, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 2003.4531, -2281.3984, 18.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 5031, 2037.0469, -2313.5469, 18.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 2030.0547, -2315.4297, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 2030.0547, -2249.0234, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 2057.0547, -2315.4688, 12.7422, 0.25);
	RemoveBuildingForPlayer(playerid, 3625, 2060.6875, -2305.9609, 14.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 2057.5391, -2270.0703, 12.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2082.4063, -2269.6563, 14.9609, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2082.4375, -2298.2266, 14.9609, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 2089.3047, -2289.8906, 12.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 2089.3047, -2332.5547, 12.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 2089.7813, -2244.4922, 12.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 2088.6094, -2281.3984, 18.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 1921.6406, -2206.3906, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1949.3438, -2227.5156, 13.6563, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1944.0625, -2227.5156, 13.6563, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1951.0313, -2207.7031, 18.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1954.6172, -2227.4844, 13.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1965.1719, -2227.4141, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1959.8984, -2227.4453, 13.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 3625, 1961.4453, -2216.1719, 14.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1975.7266, -2227.4141, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1970.4453, -2227.4141, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1979.6797, -2207.8438, 18.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1981.0000, -2227.4141, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1996.8281, -2227.3828, 13.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1991.5547, -2227.4141, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1986.2813, -2227.4141, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 1983.8047, -2224.1641, 12.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 2002.1094, -2227.3438, 13.8281, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 2018.0313, -2224.1641, 12.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 2010.3984, -2207.6172, 18.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 2042.4766, -2207.7031, 18.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 2055.0547, -2224.3828, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 2055.0547, -2219.1094, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 2056.8281, -2224.1641, 12.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 2054.9844, -2213.7891, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 2054.9219, -2208.4609, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 2054.9219, -2203.1875, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2061.5313, -2209.8125, 14.9766, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 2054.9297, -2181.3594, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 2054.9297, -2186.6328, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 3665, 1381.1172, -2541.3750, 14.2500, 0.25);
	RemoveBuildingForPlayer(playerid, 3664, 1388.0078, -2593.0000, 19.2813, 0.25);
	RemoveBuildingForPlayer(playerid, 3664, 1388.0078, -2494.2656, 19.2813, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1471.4844, -2576.2109, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1471.4844, -2610.4375, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1471.4844, -2511.0781, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1471.4844, -2476.8516, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1525.0078, -2439.9766, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1535.6797, -2476.8516, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1535.6797, -2511.0781, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1535.6797, -2576.2109, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1535.6797, -2610.4375, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 5032, 1567.7109, -2543.6328, 13.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 1259, 1577.2344, -2668.4297, 16.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 3663, 1580.0938, -2433.8281, 14.5703, 0.25);

	// Zona Las Collinas / Pig Pen - VECCHIA MAPPA
	//RemoveBuildingForPlayer(playerid, 1297, 2446.3359, -1355.2813, 26.2266, 0.25);
	//RemoveBuildingForPlayer(playerid, 1297, 2446.3359, -1316.2891, 26.2266, 0.25);
	//RemoveBuildingForPlayer(playerid, 1297, 2446.3359, -1281.1484, 26.2266, 0.25);



	return 1;
}


stock AggiungiVeicoli(){

		/* Veicoli aggiunti ad /hsiu */

		AddStaticVehicleEx(497,2917.6963,-1898.7051,14.0679,357.0320,0,1,3600); // Elicotteri
		AddStaticVehicleEx(497,2987.6531,-1910.2103,17.5679,1.1682,0,1,3600);
		AddStaticVehicleEx(497,2990.2952,-1842.1991,20.8679,89.4037,0,1,3600);
        AddStaticVehicleEx(541,2852.5801,-2037.0088,10.7298,300.0931,0,1,3600); // Auto sportive
        AddStaticVehicleEx(541,2852.8508,-2029.0929,10.7304,309.7910,0,1,3600);
        AddStaticVehicleEx(411,2852.8979,-2017.1864,10.7311,300.6440,0,1,3600);
        AddStaticVehicleEx(411,2852.7402,-2008.4889,10.7297,301.8137,0,1,3600);
        AddStaticVehicleEx(415,2852.7644,-2000.1477,10.7302,302.0125,0,1,3600);
        AddStaticVehicleEx(415,2852.4731,-1992.1482,10.7290,312.0896,0,1,3600);
		AddStaticVehicleEx(497,2864.5042,-1942.8947,10.8148,358.9792,0,1,3600); // Elicotteri
		AddStaticVehicleEx(497,2856.2803,-1894.7020,10.6295,270.7111,0,1,3600);


	    /* Veicoli del mapping generale*/

		//AddStaticVehicleEx(560,2502.3999023,-1674.8000488,13.3000002,0.0000000,-1,-1,3600); //Sultan
		//AddStaticVehicleEx(560,2498.3999023,-1674.6999512,13.3000002,0.0000000,-1,-1,3600); //Sultan
		//AddStaticVehicleEx(560,2494.1999512,-1674.6999512,13.3000002,0.0000000,-1,-1,3600); //Sultan
		//AddStaticVehicleEx(560,2489.3999023,-1674.5000000,13.3000002,0.0000000,-1,-1,3600); //Sultan
		//AddStaticVehicleEx(541,2485.1000977,-1674.3000488,13.3000002,0.0000000,0,1,3600); //Bullet
		//AddStaticVehicleEx(411,2500.6000977,-1668.0999756,13.3000002,0.0000000,-1,-1,3600); //Infernus
		//AddStaticVehicleEx(411,2496.1000977,-1668.0000000,13.3000002,0.0000000,-1,-1,3600); //Infernus
		//AddStaticVehicleEx(411,2491.3000488,-1668.0999756,13.3000002,0.0000000,-1,-1,3600); //Infernus
		//AddStaticVehicleEx(411,2486.1000977,-1667.5999756,13.3000002,0.0000000,-1,-1,3600); //Infernus
		//AddStaticVehicleEx(504,2506.3000488,-1668.5000000,13.3000002,0.0000000,6,1,3600); //Bloodring Banger
		//AddStaticVehicleEx(506,2503.0000000,-1662.5000000,13.3000002,0.0000000,-1,-1,3600); //Super GT
		//AddStaticVehicleEx(506,2498.3999023,-1662.4000244,13.3000002,0.0000000,-1,-1,3600); //Super GT
		//AddStaticVehicleEx(506,2493.8000488,-1662.4000244,13.3000002,0.0000000,-1,-1,3600); //Super GT
		//AddStaticVehicleEx(541,2489.5000000,-1662.4000244,13.3000002,0.0000000,1,0,3600); //Bullet
		//AddStaticVehicleEx(576,2481.5000000,-1662.6999512,13.1000004,0.0000000,3,85,3600); //Tornado
		AddStaticVehicleEx(528,2515.8000488,-1777.0000000,13.6999998,0.0000000,-1,-1,3600); //FBI Truck
		AddStaticVehicleEx(528,2511.8999023,-1777.3000488,13.6999998,0.0000000,-1,-1,3600); //FBI Truck
		AddStaticVehicleEx(596,2506.8999023,-1777.0000000,13.5000000,0.0000000,-1,-1,3600); //Police Car (LSPD)
		AddStaticVehicleEx(597,2503.8999023,-1777.1999512,13.5000000,0.0000000,-1,-1,3600); //Police Car (SFPD)
		AddStaticVehicleEx(596,2500.6000977,-1777.4000244,13.5000000,0.0000000,-1,-1,3600); //Police Car (LSPD)
		AddStaticVehicleEx(599,2496.8000488,-1778.5999756,13.8999996,0.0000000,-1,1,3600); //Police Ranger
		AddStaticVehicleEx(525,2492.6000977,-1778.4000244,13.5000000,0.0000000,-1,-1,3600); //Tow Truck
		AddStaticVehicleEx(497,2509.8000488,-1768.5999756,20.7999992,0.0000000,-1,1,3600); //Police Maverick
		AddStaticVehicleEx(489,1839.3000488,-1854.3000488,13.6999998,0.0000000,3,1,3600); //Rancher
		AddStaticVehicleEx(579,1835.8000488,-1854.0000000,13.5000000,0.0000000,3,1,3600); //Huntley
		AddStaticVehicleEx(431,1748.0999756,-1859.1999512,13.6999998,270.0000000,6,1,3600); //Bus
		AddStaticVehicleEx(494,1840.8000488,-1870.5000000,13.3999996,0.0000000,-1,6,3600); //Hotring
		AddStaticVehicleEx(463,1837.1999512,-1871.1999512,13.0000000,0.0000000,6,1,3600); //Freeway
		AddStaticVehicleEx(451,1834.3000488,-1870.5000000,13.1000004,0.0000000,-1,1,3600); //Turismo
		AddStaticVehicleEx(506,1852.0000000,-1863.0000000,13.3999996,90.0000000,79,1,3600); //Super GT
		AddStaticVehicleEx(596,1548.9000244,-1606.5999756,13.3000002,0.0000000,-1,-1,3600); //Police Car (LSPD)
		AddStaticVehicleEx(596,1554.5000000,-1607.0000000,13.3000002,0.0000000,-1,-1,3600); //Police Car (LSPD)
		AddStaticVehicleEx(596,1560.1999512,-1606.8000488,13.3000002,0.0000000,-1,-1,3600); //Police Car (LSPD)
		AddStaticVehicleEx(596,1566.4000244,-1606.8000488,13.3000002,0.0000000,-1,-1,3600); //Police Car (LSPD)
		AddStaticVehicleEx(596,1574.4000244,-1607.0999756,13.3000002,0.0000000,-1,-1,3600); //Police Car (LSPD)
		AddStaticVehicleEx(596,1580.9000244,-1607.0999756,13.3000002,0.0000000,-1,-1,3600); //Police Car (LSPD)
		AddStaticVehicleEx(528,1587.4000244,-1607.5999756,13.6000004,0.0000000,-1,-1,3600); //FBI Truck
		AddStaticVehicleEx(528,1591.1999512,-1607.8000488,13.6000004,0.0000000,-1,-1,3600); //FBI Truck
		AddStaticVehicleEx(601,1595.5000000,-1608.0000000,13.3000002,0.0000000,-1,-1,3600); //S.W.A.T. Van
		AddStaticVehicleEx(490,1599.5000000,-1608.3000488,13.8000002,0.0000000,-1,-1,3600); //FBI Rancher
		AddStaticVehicleEx(490,1604.1999512,-1607.6999512,13.8000002,0.0000000,-1,-1,3600); //FBI Rancher
		AddStaticVehicleEx(523,1570.5999756,-1606.6999512,13.0000000,0.0000000,-1,-1,3600); //HPV1000
		AddStaticVehicleEx(523,1578.0000000,-1606.8000488,13.0000000,0.0000000,-1,-1,3600); //HPV1000
		AddStaticVehicleEx(523,1563.5000000,-1606.4000244,13.0000000,0.0000000,-1,-1,3600); //HPV1000
		AddStaticVehicleEx(523,1557.5999756,-1607.3000488,13.0000000,0.0000000,-1,-1,3600); //HPV1000
		AddStaticVehicleEx(523,1551.5000000,-1606.8000488,13.0000000,0.0000000,-1,-1,3600); //HPV1000
		AddStaticVehicleEx(426,1544.8000488,-1606.8000488,13.1999998,0.0000000,24,1,3600); //Premier
		AddStaticVehicleEx(426,1535.6999512,-1674.5999756,13.1999998,0.0000000,-1,-1,3600); //Premier
		AddStaticVehicleEx(497,1564.9000244,-1645.0999756,29.2000008,0.0000000,-1,1,3600); //Police Maverick
		AddStaticVehicleEx(497,1564.3000488,-1658.9000244,29.2000008,0.0000000,-1,1,3600); //Police Maverick
		AddStaticVehicleEx(497,1565.1999512,-1692.5000000,29.2000008,0.0000000,-1,1,3600); //Police Maverick
		AddStaticVehicleEx(497,1565.5999756,-1706.6999512,29.2000008,0.0000000,-1,1,3600); //Police Maverick
		AddStaticVehicleEx(523,1536.3000488,-1665.8000488,13.0000000,0.0000000,-1,-1,3600); //HPV1000
		AddStaticVehicleEx(523,1535.1999512,-1668.5999756,13.0000000,0.0000000,-1,-1,3600); //HPV1000
		AddStaticVehicleEx(427,1800.6999512,-1587.1999512,13.8000002,308.0000000,-1,1,3600); //Enforcer
		AddStaticVehicleEx(490,1807.4000244,-1581.8000488,13.8000002,308.0000000,86,-1,3600); //FBI Rancher
		AddStaticVehicleEx(523,1816.5000000,-1556.0999756,13.1999998,0.0000000,-1,-1,3600); //HPV1000
		AddStaticVehicleEx(523,1785.9000244,-1593.8000488,13.1000004,306.0000000,-1,-1,3600); //HPV1000


		/* Veicoli Carcere a SUD di LS */

		AddStaticVehicleEx(497,1361.79980469,-2855.09960938,16.79999924,266.03942871,-1,1,3600); //Police Maverick
		AddStaticVehicleEx(548,1358.69921875,-2869.09960938,18.39999962,266.90185547,-1,-1,3600); //Cargobob
		AddStaticVehicleEx(427,1339.80004883,-2931.19995117,14.00000000,86.55578613,-1,1,3600); //Enforcer
		AddStaticVehicleEx(427,1339.69995117,-2926.89990234,14.00000000,85.39453125,-1,1,3600); //Enforcer
		AddStaticVehicleEx(599,1341.09960938,-2921.89941406,14.37859249,86.55578613,-1,1,3600); //Police Ranger
		AddStaticVehicleEx(599,1340.59997559,-2916.89990234,14.37859249,84.23327637,-1,1,3600); //Police Ranger
		AddStaticVehicleEx(596,1341.80004883,-2911.80004883,13.80000019,86.55578613,-1,1,3600); //Police Car (LSPD)
		AddStaticVehicleEx(596,1342.00000000,-2906.89941406,13.80000019,86.55578613,-1,1,3600); //Police Car (LSPD)
		AddStaticVehicleEx(596,1342.30004883,-2901.69995117,13.80000019,86.55578613,-1,1,3600); //Police Car (LSPD)
		AddStaticVehicleEx(598,1349.30004883,-2895.39990234,13.80000019,356.51623535,-1,1,3600); //Police Car (LVPD)
		AddStaticVehicleEx(598,1354.30004883,-2895.80004883,13.80000019,356.51184082,-1,1,3600); //Police Car (LVPD)
		AddStaticVehicleEx(598,1359.19995117,-2896.19995117,13.80000019,356.51184082,-1,1,3600); //Police Car (LVPD)
		AddStaticVehicleEx(598,1364.30004883,-2896.60009766,13.80000019,356.51184082,-1,1,3600); //Police Car (LVPD)
		AddStaticVehicleEx(598,1369.40002441,-2897.00000000,13.80000019,356.51184082,-1,1,3600); //Police Car (LVPD)
		AddStaticVehicleEx(598,1374.19995117,-2897.39990234,13.80000019,356.51184082,-1,1,3600); //Police Car (LVPD)
		AddStaticVehicleEx(598,1379.40002441,-2897.80004883,13.80000019,356.51184082,-1,1,3600); //Police Car (LVPD)
		AddStaticVehicleEx(598,1384.19995117,-2897.89990234,13.80000019,356.51184082,-1,1,3600); //Police Car (LVPD)
		AddStaticVehicleEx(430,1365.40002441,-2964.80004883,-0.40000001,265.53411865,-1,-1,3600); //Predator
		AddStaticVehicleEx(430,1379.40002441,-2966.00000000,-0.40000001,265.53405762,-1,-1,3600); //Predator
		AddStaticVehicleEx(430,1394.00000000,-2967.10009766,-0.40000001,265.53405762,-1,-1,3600); //Predator
		AddStaticVehicleEx(430,1408.69995117,-2968.30004883,-0.40000001,265.53405762,-1,-1,3600); //Predator

		return 1; 
	}

	stock AggiungiPersonalPickupAndLabel(){


	// ------- Pickup e 3D Text Label

   // AddStaticPickup(1274, 1, 2490.3691, -1685.1134, 13.5093, 0); // Prigione
   // AddStaticPickup(1240, 1, 2487.4285, -1685.2180, 13.5080, 0); // Cuore
   // AddStaticPickup(1239, 1, 1798.6970, -1578.2167, 14.0823, 0); // Info Carcere
      AddStaticPickup(1239, 1, 1540.4380, -1681.5313, 13.5506, 0); // Spawn
   // AddStaticPickup(1239, 1, 1779.0575, -1576.3798, 1734.9430, 0); // Prigione Interna
   // AddStaticPickup(1239, 1, 1547.6556, -1643.2023, 28.4021, 0); // Tetto Sopra
   // AddStaticPickup(1239, 1, 1554.1049, -1634.1178, 13.5474, 0); // Tetto Sotto
   // AddStaticPickup(1239, 1, 1081.6394, -1699.3267, 13.5469, 0); // Elettronica
   // AddStaticPickup(1239, 1, 1004.19, 52.3467, 55.4, 0); // Elettronica
    AddStaticPickup(1239, 1, 254.2738, -57.5924, 1.5703, 0); // Rapina Liquor Store
    AddStaticPickup(1239, 1, 2786.5195,-1848.8776,9.9580,0); // Stadio LS
	AddStaticPickup(1239, 1, 598.2411,-1289.0424,15.4199,0); // Banca Nord Rodeo
	//Create3DTextLabel("Utilizza /enterprison per entrare nel carcere.\n Utilizza /exitprison per uscire di prigione.", 0xFFFF00FF, 1798.6970, -1578.2467, 14.0823, 20.0, 0, 0);
   // Create3DTextLabel("Utilizza /vita per settarti la vita al massimo e /armatura per l'armatura al massimo.\n", 0xE60000FF, 2487.4285, -1685.2180, 13.5080, 20.0, 0, 0);
   // Create3DTextLabel("Utilizza /soldi per darti $50000.\n", 0x21DD00FF, 2490.3691, -1685.1134, 13.5093, 20.0, 0, 0);
	Create3DTextLabel("Benvenuto sull'LSPD Training, utente!\n Usa /aiuto per visualizzare i comandi del server. \n Visita www.lscity.org per altre informazioni.", 0xFFFF00FF, 1540.4380, -1681.5313, 13.5506, 20.0, 0, 0);
   // Create3DTextLabel("Usa /exitprison per uscire.", 0xFFFF00FF, 1779.0575, -1576.3798, 1734.9430, 20.0, 0, 0);
   // Create3DTextLabel("Usa /pd per scendere.", 0xFFFF00FF, 1547.6556, -1643.2023, 28.4021, 20.0, 0, 0);
   // Create3DTextLabel("Usa /tettopd per salire.", 0xFFFF00FF, 1554.1049, -1634.1178, 13.5474, 20.0, 0, 0);
   // Create3DTextLabel("Elettronica. \n Usa /enterelettronica per entrare nell'elettronica.", 0xFFFF00FF, 1081.6394, -1699.3267, 13.5469, 20.0, 0, 0);
   // Create3DTextLabel("Usa /exitelettronica per uscire dall'elettronica.", 0xFFFF00FF, 1004.19, 52.3467, 55.4, 20.0, 0, 0);
	Create3DTextLabel("Usa /rapinaliquorstore con il set da criminale\nper iniziare la rapina.\n Se vuoi arrenderti, usa /arrenditi", 0xFFFF00FF, 254.2738, -57.5924, 1.5703, 10.0, 0, 0);
	Create3DTextLabel("Usa /trasportovalori con il set da poliziotto\nper iniziare la scorta.\n Se vuoi annullare la scorta, usa /annullascorta", 0xFFFF00FF, 2786.5195, -1848.8776, 9.9580, 10.0, 0, 0);
	Create3DTextLabel("Punto di Arrivo della Scorta", 0xFFFF00FF, 598.2411,-1289.0424,15.4199, 10.0, 0, 0);
	return 1;
}


stock AggiungiClassi(){


		// --------- Classi predefinite

	AddPlayerClass(71,1541.5084,-1675.5659,13.5527,90.8504,0,0,0,0,0,0);

	/* Accademico */
	//AddPlayerClass (71,1541.5084,-1675.5659,13.5527,90.8504,3,1,22,999999,41,999999);

  	/* Polizia */
	//AddPlayerClass (266,1541.5084,-1675.5659,13.5527,90.8504,3,1,24,999999,29,999999); // Manganello, Pistola, Mp5
	//AddPlayerClass (280,1541.5084,-1675.5659,13.5527,90.8504,3,1,24,999999,29,999999); // Manganello, Pistola, Mp5
    //AddPlayerClass (284,1541.5084,-1675.5659,13.5527,90.8504,3,1,24,999999,29,999999); // Manganello, Pistola, Mp5
    //AddPlayerClass (265,1541.5084,-1675.5659,13.5527,90.8504,3,1,24,999999,29,999999); // Manganello, Pistola, Mp5


	/* SADoC */
	//AddPlayerClass (192,1541.5084,-1675.5659,13.5527,90.8504,3,1,22,999999,25,999999); // Manganello, Pistola, Fucile a Pompa
	//AddPlayerClass (282,1541.5084,-1675.5659,13.5527,90.8504,3,1,22,999999,25,999999);
	//AddPlayerClass (283,1541.5084,-1675.5659,13.5527,90.8504,3,1,22,999999,25,999999);


	/* Militare */
	//AddPlayerClass (285,1541.5084,-1675.5659,13.5527,90.8504,4,1,17,999999,31,999999); // Swat
    //AddPlayerClass (287,1541.5084,-1675.5659,13.5527,90.8504,4,1,17,999999,31,999999); // Militare


	/* Civili - Criminali */
	//AddPlayerClass (299,1541.5084,-1675.5659,13.5527,90.8504,22,999999,30,999999,25,999999);
	//AddPlayerClass (3,1541.5084,-1675.5659,13.5527,90.8504,22,999999,30,999999,25,999999);
	//AddPlayerClass (127,1541.5084,-1675.5659,13.5527,90.8504,22,999999,30,999999,25,999999);
	//	AddPlayerClass (109,1541.5084,-1675.5659,13.5527,90.8504,22,999999,30,999999,25,999999);

	return 1;
}


stock TargheVeicoli(){
	new stringa[24];
	for(new i=0; i<MAX_VEHICLES; i++)
	{
		format(stringa,sizeof(stringa),"TRAINING %d",i);
		SetVehicleNumberPlate(i, stringa);
	}
	return 1;	
}

stock AggiungiTextDraw(){

	sim = TextDrawCreate(260.0, 420.0, "SIMULAZIONE RP ATTIVA");
	TextDrawLetterSize(sim, 0.3 ,2.0);
	TextDrawColor(sim, COLOR_ORANGE);

	txt = TextDrawCreate(520.0, 420.0, "PD Training - ACRP");
	TextDrawLetterSize(txt, 0.3 ,2.0);
	TextDrawColor(txt, COLOR_WHITE);
	
    Textdraw0 = TextDrawCreate(650.000000, 0.000000, "_"); // Barra verticale
    TextDrawBackgroundColor(Textdraw0, 255);
    TextDrawFont(Textdraw0, 1);
    TextDrawLetterSize(Textdraw0, 0.500000, 13.000000);
    TextDrawColor(Textdraw0, -1);
    TextDrawSetOutline(Textdraw0, 0);
    TextDrawSetProportional(Textdraw0, 1);
    TextDrawSetShadow(Textdraw0, 1);
    TextDrawUseBox(Textdraw0, 1);
    TextDrawBoxColor(Textdraw0, 255);
    TextDrawTextSize(Textdraw0, -10.000000, 0.000000);
    TextDrawSetSelectable(Textdraw0, 0);

	Textdraw1 = TextDrawCreate(650.000000, 330.000000, "_"); // Barra verticale
	TextDrawBackgroundColor(Textdraw1, 255);
	TextDrawFont(Textdraw1, 1);
	TextDrawLetterSize(Textdraw1, 0.500000, 13.000000);
	TextDrawColor(Textdraw1, -1);
	TextDrawSetOutline(Textdraw1, 0);
	TextDrawSetProportional(Textdraw1, 1);
	TextDrawSetShadow(Textdraw1, 1);
	TextDrawUseBox(Textdraw1, 1);
	TextDrawBoxColor(Textdraw1, 255);
	TextDrawTextSize(Textdraw1, -10.000000, 0.000000);
	TextDrawSetSelectable(Textdraw1, 0);


	txtTimeDisp = TextDrawCreate(605.0,25.0,"00:00");
	TextDrawUseBox(txtTimeDisp, 0);
	TextDrawFont(txtTimeDisp, 3);
	TextDrawSetShadow(txtTimeDisp,0); // no shadow
    TextDrawSetOutline(txtTimeDisp,2); // thickness 1
    TextDrawBackgroundColor(txtTimeDisp,0x000000FF);
    TextDrawColor(txtTimeDisp,0xFFFFFFFF);
    TextDrawAlignment(txtTimeDisp,3);
    TextDrawLetterSize(txtTimeDisp,0.5,1.5);
    
    UpdateTimeAndWeather();
    SetTimer("UpdateTimeAndWeather",1000 * 60,1);	

    return 1; 
}

stock UpdateWorldWeather()
{
	new next_weather_prob = random(100);
	if(next_weather_prob < 70) 		SetWeather(fine_weather_ids[random(sizeof(fine_weather_ids))]);
	else if(next_weather_prob < 95) SetWeather(foggy_weather_ids[random(sizeof(foggy_weather_ids))]);
	else							SetWeather(wet_weather_ids[random(sizeof(wet_weather_ids))]);
}

stock AggiungiMapElevatorPD(){

   	caselev = CreateObject(2669, 1567.4233398438, -1634.6782226563, 13.896639823914, 0, 0, 270); // Elevator
   	CreateObject(1383, 1567.904296875, -1637.5500488281, -1.6610670089722, 0, 0, 0);
   	CreateObject(974, 1561.6535644531, -1635.599609375, 27.379848480225, 90, 179.59649658203, 180.40350341797);
   	CreateObject(970, 1562.9537353516, -1632.9342041016, 27.939142227173, 0, 0, 0);
   	CreateObject(970, 1560.4147949219, -1632.9245605469, 27.939142227173, 0, 0, 0);
   	CreateObject(970, 1558.3157958984, -1635.0493164063, 27.939142227173, 0, 0, 269.99996948242);
   	CreateObject(1215, 1564.1802978516, -1633.2125244141, 27.951984405518, 0, 0, 0);
   	CreateObject(1215, 1561.5998535156, -1633.2470703125, 27.951984405518, 0, 0, 0);
   	CreateObject(1215, 1558.7445068359, -1633.1572265625, 27.951984405518, 0, 0, 0);
   	CreateObject(1215, 1558.6159667969, -1635.1682128906, 27.951984405518, 0, 0, 0);
   	CreateObject(1215, 1558.5804443359, -1636.8074951172, 27.951984405518, 0, 0, 0);
   	CreateObject(1215, 1564.2353515625, -1636.0129394531, 13.123223304749, 0, 0, 0);
   	CreateObject(1215, 1564.3372802734, -1633.5808105469, 13.121915817261, 0, 0, 0);

   	return 1;
   }


   stock AddPickupFromFile(DFileName[])
   {
   	if(!fexist(DFileName)) return 0;

   	new File:PickupFile, PType, PModel, Float:PX, Float:PY, Float:PZ, pTotal, Line[128];

   	PickupFile = fopen(DFileName, io_read);
   	while(fread(PickupFile, Line))
   	{
   		if(Line[0] == '/' || isnull(Line)) continue;
   		unformat(Line, "fffii", PX, PY, PZ, PModel, PType);
   		CreateDynamicPickup(PModel, PType, PX, PY, PZ, -1, -1, -1, 100.0);
   		pTotal++;
   	}
   	fclose(PickupFile);
   	return pTotal;
   }


   stock AddPickupToFile(DFileName[], Float:PX, Float:PY, Float:PZ, PModel, PType)
   {
   	new File:PickupFile, Line[128];

   	format(Line, sizeof(Line), "%f %f %f %i %i\r\n", PX, PY, PZ, PModel, PType);
   	PickupFile = fopen(DFileName, io_append);
   	fwrite(PickupFile, Line);
   	fclose(PickupFile);
   	return 1;
   }

   stock AddLabelsFromFile(LFileName[])
   {
   	if(!fexist(LFileName)) return 0;

   	new File:LFile, Line[128], LabelInfo[128], Float:LX, Float:LY, Float:LZ, lTotal = 0;

   	LFile = fopen(LFileName, io_read);
   	while(fread(LFile, Line))
   	{
   		if(Line[0] == '/' || isnull(Line)) continue;
   		unformat(Line, "p<,>s[128]fff", LabelInfo,LX,LY,LZ);
   		CreateDynamic3DTextLabel(LabelInfo, COLOR_ORANGELIGHT, LX, LY, LZ, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 5.0);
   		lTotal++;
   	}
   	fclose(LFile);
   	return lTotal;
   }

   stock AddLabelToFile(LFileName[], LabelInfo[], Float:LX, Float:LY, Float:LZ)
   {
   	new File:LFile, Line[128];

   	format(Line, sizeof(Line), "%s,%.2f,%.2f,%.2f\r\n",LabelInfo, LX, LY, LZ);
   	LFile = fopen(LFileName, io_append);
   	fwrite(LFile, Line);
   	fclose(LFile);
   	return 1;
   }


   stock PasswordFromFile(LFileName[])
   {
   	new File:LFile, Line[128], Password[64];

   	LFile = fopen(LFileName, io_read);
   	while(fread(LFile, Line))
   	{
   		if(Line[0] == '/' || isnull(Line)) continue;
   		unformat(Line, "s[128]", Password);
   	}
   	fclose(LFile);
   	return Password;
   }


   stock PasswordChangeFromFile(LFileName[], Password[])
   {
   	new File:handle = fopen(LFileName, io_write);
   	fwrite(handle, Password);
   	fclose(handle);
   	return 1;
   }


   stock TrovaNomeArma(armaid){

// Si pu� usare anche GetWeaponName(weaponid, weapon[], len);

   	new wepname[32];

   	if(armaid == 3) wepname = "Manganello"; 
   	else if(armaid == 41) wepname = "Spray"; 
   	else if(armaid == 4) wepname = "Coltello";  
   	else if(armaid == 22) wepname = "Colt45"; 
   	else if(armaid == 23) wepname = "Colt45 Silenziata";  
   	else if(armaid == 24) wepname = "Desert Eagle"; 
   	else if(armaid == 25) wepname = "Fucile a Pompa";  
   	else if(armaid == 27) wepname = "Spass12"; 
   	else if(armaid == 29) wepname = "Mp5"; 
   	else if(armaid == 31) wepname = "M4A1"; 
   	else if(armaid == 33) wepname = "Fucile Semi-Automatico"; 
   	else if(armaid == 34) wepname = "Fucile da Cecchino";  
   	else if(armaid == 43) wepname = "Fotocamera"; 
   	else if(armaid == 17) wepname = "Gas Lacrimogeno"; 
   	else wepname = "Sconosciuta";

   	return wepname;

   }

stock IsNumeric(const string[]) {
        new length=strlen(string);
        if (length==0) return false;
        for (new i = 0; i < length; i++) {
                if (
                (string[i] > '9' || string[i] < '0' && string[i]!='-' && string[i]!='+')
                || (string[i]=='-' && i!=0)
                || (string[i]=='+' && i!=0)
                ) return false;
        }
        if (length==1 && (string[0]=='-' || string[0]=='+')) return false;
        return true;
}
