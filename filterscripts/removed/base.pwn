//
// Base FS
// Contains /pm /kick /ban commands.
// Edited from English to Italian by Maxel, iMaxel.net
//

#include <a_samp>
#include "../include/gl_common.inc"

#define ADMINFS_MESSAGE_COLOR 0xFF444499
#define PM_INCOMING_COLOR     0xFFFF22AA
#define PM_OUTGOING_COLOR     0xFFCC2299

new pRank[256]; // 1 accademico - 2 agente lsd - 3 istruttore

//------------------------------------------------

public OnFilterScriptInit()
{
  		print("\n--------------------------------------");
		print(" [FILTERSCRIPT base]");
        print(" Base - CARICATO");
        print("--------------------------------------\n");
}


public OnFilterScriptExit()
{
  		print("\n--------------------------------------");
        print(" Base - DISATTIVATO");
        print("--------------------------------------\n");
}

//------------------------------------------------

public OnPlayerCommandText(playerid, cmdtext[])
{
	new cmd[256];
	new	tmp[256];
	new Message[256];
	new gMessage[256];
	new pName[MAX_PLAYER_NAME+1];
	new iName[MAX_PLAYER_NAME+1];
	new	idx;
	
	cmd = strtok(cmdtext, idx);

	// PM Command
	if(strcmp("/pm", cmd, true) == 0)
	{
		tmp = strtok(cmdtext,idx);
		
		if(!strlen(tmp) || strlen(tmp) > 5) {
			SendClientMessage(playerid,ADMINFS_MESSAGE_COLOR,"[Uso:] /pm (id) (messaggio)");
			return 1;
		}
		
		new id = strval(tmp);
        gMessage = strrest(cmdtext,idx);
        
		if(!strlen(gMessage)) {
			SendClientMessage(playerid,ADMINFS_MESSAGE_COLOR,"[Uso:] /pm (id) (messaggio)");
			return 1;
		}
		
		if(!IsPlayerConnected(id)) {
			SendClientMessage(playerid,ADMINFS_MESSAGE_COLOR,"[Errore] /pm : ID invalido");
			return 1;
		}
		
		if(playerid != id) {
			GetPlayerName(id,iName,sizeof(iName));
			GetPlayerName(playerid,pName,sizeof(pName));
			format(Message,sizeof(Message),">> %s(%d): %s",iName,id,gMessage);
			SendClientMessage(playerid,PM_OUTGOING_COLOR,Message);
			format(Message,sizeof(Message),"** %s(%d): %s",pName,playerid,gMessage);
			SendClientMessage(id,PM_INCOMING_COLOR,Message);
			PlayerPlaySound(id,1085,0.0,0.0,0.0);
			
			printf("PM: %s",Message);
			
		}
		else {
			SendClientMessage(playerid,ADMINFS_MESSAGE_COLOR,"[Errore] Non puoi mandare un PM a te stesso!");
		}
		return 1;
	}

	//Kick Command
	if(strcmp("/kick", cmd, true) == 0)
	{
	    if(IsPlayerAdmin(playerid) || pRank[playerid] >=3 ) {
			tmp = strtok(cmdtext,idx);
			if(!strlen(tmp) || strlen(tmp) > 5) {
				return SendClientMessage(playerid,ADMINFS_MESSAGE_COLOR,"[Uso:] /kick (id) [Motivo]");
			}
			
			new id = strval(tmp);

			if(!IsPlayerConnected(id)) {
				SendClientMessage(playerid,ADMINFS_MESSAGE_COLOR,"[Uso:] /kick : ID invalido");
				return 1;
			}
			
			gMessage = strrest(cmdtext,idx);
			
			GetPlayerName(id,iName,sizeof(iName));
			SendClientMessage(id,ADMINFS_MESSAGE_COLOR,"-- Sei Stato kicckato dal server --");

			if(strlen(gMessage) > 0) {
				format(Message,sizeof(Message),"Motivo: %s",gMessage);
				SendClientMessage(id,ADMINFS_MESSAGE_COLOR,Message);
			}
			
			format(Message,sizeof(Message),">> %s(%d) e' stato kicckato dal server.",iName,id);
			SendClientMessage(playerid,ADMINFS_MESSAGE_COLOR,Message);
			
			Kick(id);
			return 1;
		} else {
            SendClientMessage(playerid,ADMINFS_MESSAGE_COLOR,"[Errore] Non sei un admin.");
			return 1;
		}
	}

	//Ban Command
	if(strcmp("/ban", cmd, true) == 0)
	{
	    if(IsPlayerAdmin(playerid) || pRank[playerid] >=3 ) {
			tmp = strtok(cmdtext,idx);
			if(!strlen(tmp) || strlen(tmp) > 5) {
				return SendClientMessage(playerid,ADMINFS_MESSAGE_COLOR,"[Uso:] /ban (id) [Motivo]");
			}

			new id = strval(tmp);

			if(!IsPlayerConnected(id)) {
				SendClientMessage(playerid,ADMINFS_MESSAGE_COLOR,"[Uso:] /ban : ID invalido");
				return 1;
			}

			gMessage = strrest(cmdtext,idx);

			GetPlayerName(id,iName,sizeof(iName));
			SendClientMessage(id,ADMINFS_MESSAGE_COLOR,"-- Sei stato bannato dal server --");

			if(strlen(gMessage) > 0) {
				format(Message,sizeof(Message),"Motivo: %s",gMessage);
				SendClientMessage(id,ADMINFS_MESSAGE_COLOR,Message);
			}

			format(Message,sizeof(Message),">> %s(%d) e' stato bannato dal server.",iName,id);
			SendClientMessage(playerid,ADMINFS_MESSAGE_COLOR,Message);

			Ban(id);
			return 1;
		} else {
            SendClientMessage(playerid,ADMINFS_MESSAGE_COLOR,"[Errore] Non sei un admin.");
			return 1;
		}
	}
	
	return 0;
}
