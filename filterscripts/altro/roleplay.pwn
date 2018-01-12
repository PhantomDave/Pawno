//  Comandi Roleplay
//  By Maxel
//

#include <a_samp>


// -------------------------------------------------------

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


new bool:Simulazione;

#pragma tabsize 0

// -------------------------------------------------------

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Comandi Roleplay - CARICATO");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

#else

main()
{
	print("\n----------------------------------");
	print(" Comandi Roleplay - SCARICATO");
	print("----------------------------------\n");
}

#endif

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

public OnPlayerCommandText(playerid, cmdtext[])
{


    if(strcmp(cmdtext, "/me", true, 3) == 0)
  {
  	if(Simulazione == true){
	    new string[128];
		if(!cmdtext[3])return SendClientMessage(playerid, 0xFF0000FF, "[Uso:] /me [azione]");
		format(string, sizeof(string), "* %s %s *", NameRP(playerid), cmdtext[4]);
		SendLocalMessage(playerid, string, 20.0, COLOR_ACTION, COLOR_ACTION);
     }else{ ErroreSim2(playerid); }
		return 1;
  }

    if(strcmp(cmdtext, "/ame", true, 3) == 0)
  {
  	if(Simulazione == true){
	    new string[128];
		if(!cmdtext[3])return SendClientMessage(playerid, 0xFF0000FF, "[Uso:] /ame [azione]");
		format(string, sizeof(string), "* %s *", cmdtext[4]);
		SetPlayerChatBubble(playerid, string, COLOR_AME, 10.0, 7000);
		SendClientMessage(playerid, COLOR_AME, string);
	}else{ ErroreSim2(playerid); }
		return 1;
  }

    if(strcmp(cmdtext, "/do", true, 3) == 0)
  {
  	if(Simulazione == true){
	    new string[128];
		if(!cmdtext[3])return SendClientMessage(playerid, 0xFF0000FF, "[Uso:] /do [azione]");
		format(string, sizeof(string), "* %s (( %s )) *", cmdtext[4], NameRP(playerid));
		SendLocalMessage(playerid, string, 20.0, COLOR_ACTION, COLOR_ACTION);
	}else{ ErroreSim2(playerid); }
		return 1;
  }

    if(strcmp(cmdtext, "/s", true, 2) == 0)
  {
	  if(Simulazione == true){
	    new string[128];
		if(!cmdtext[2])return SendClientMessage(playerid, 0xFF0000FF, "[Uso:] /s [testo urlato]");
		format(string, sizeof(string), "%s grida: %s!", NameRP(playerid), cmdtext[3]);
		SendLocalMessage(playerid, string, 40.0, COLOR_WHITE, COLOR_WHITE);
	}else{ ErroreSim2(playerid); }
		return 1;
  }

    if(strcmp(cmdtext, "/low", true, 4) == 0)
  {
  	if(Simulazione == true){
	    new string[128];
		if(!cmdtext[4])return SendClientMessage(playerid, 0xFF0000FF, "[Uso:] /low [testo sottovoce]");
		format(string, sizeof(string), "%s dice a bassa voce: %s", NameRP(playerid), cmdtext[5]);
		SendLocalMessage(playerid, string, 3.0, COLOR_GRAD1, COLOR_GRAD1);
	}else{ ErroreSim2(playerid); }
		return 1;
  }

    if(strcmp(cmdtext, "/m", true, 2) == 0)
  {
  	if(Simulazione == true){
	    new string[128];
		if(!cmdtext[2])return SendClientMessage(playerid, 0xFF0000FF, "[Uso:] /m [megafono]");
		format(string, sizeof(string), "[MEGAFONO] %s: %s!", NameRP(playerid), cmdtext[3]);
		SendLocalMessage(playerid, string, 60.0, COLOR_GIALLO, COLOR_GIALLO);
	}else{ ErroreSim2(playerid); }
		return 1;
  }

    if(strcmp(cmdtext, "/b", true, 2) == 0)
  {
  	if(Simulazione == true){
	    new string[128];
		if(!cmdtext[2])return SendClientMessage(playerid, 0xFF0000FF, "[Uso:] /b [testo OOC]");
		format(string, sizeof(string), "((%s [OOC]: %s))", NameRP(playerid), cmdtext[3]);
		SendLocalMessage(playerid, string, 20.0, COLOR_GRAD1, COLOR_GRAD1);
	}else{ ErroreSim2(playerid); }
		return 1;
  }

    if(strcmp(cmdtext, "/rd", true, 3) == 0)
  {
  	if(Simulazione == true){
	    new string[128];
		if(!cmdtext[3])return SendClientMessage(playerid, 0xFF0000FF, "[Uso:] /rd [mex radio]");
		for(new i=0; i<MAX_PLAYERS; i++){

		 if(GetPlayerTeam(i) == 0){
		 	format(string, sizeof(string), "[RADIO] Agente %s: %s", NameRP(playerid), cmdtext[4]);
		 	SendClientMessage(i, COLOR_BLUE, string);
		 }else if(GetPlayerTeam(i) == 1){
			format(string, sizeof(string), "[RADIO] Criminale %s: %s", NameRP(playerid), cmdtext[4]);
            SendClientMessage(i, COLOR_REDLIGHT, string);
		 }

		}
	}else{ ErroreSim2(playerid); }
		return 1;
  }

	return 0;
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
}

stock ErroreSim2(playerid)
{
	SendClientMessage(playerid, COLOR_RED, "[Errore] La simulazione risulta disattivata e pertanto non puoi usare questo comando!");
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
