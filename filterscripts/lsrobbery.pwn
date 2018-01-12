// ==========================================
//
//    SA-MP LIQUOR STORE ROBBERY SCRIPT | CREATED BY MAXEL
//
// ==========================================

#include <a_samp>

#define COLOR_ORANGE 0xF97804FF // arancione
#define COLOR_AZZURRO 0x99FFFFAA // azzurro
#define COLOR_GRAD1 0xCECECEFF // grigio chiaro
#define COLOR_WHITE 0xFFFFFFFF // bianco
#define COLOR_BLUE 0x00C2ECFF // blu chiaro
#define COLOR_RED 0xE60000FF // rosso
#define COLOR_VIOLA 0xB360FDFF // viola
#define COLOR_ACTION 0xADFF2FAA // azioni /me /do
#define COLOR_GIALLO 0xFFFF00AA // giallo megafono
#define COLOR_AME 0xC2A2DAAA // ame
#define COLOR_GREEN 0x21DD00FF // verde

forward robcheck(playerid);
forward robsuccess(playerid);
forward robdenied(playerid);
forward waittimer();

new robpossible;
new robcp[256]; // checkpoints
new robber[256];

public OnFilterScriptInit()
{
	print("---------------------------------");
	print("-  Sistema Rapina Liquor Store  -");
	print("-           by Maxel            -");
	print("---------------------------------");
	robpossible = 1;
	return 1;
}

// ======================= COMANDI ===========================

public OnPlayerCommandText(playerid, cmdtext[])
{

	if(strcmp(cmdtext, "/rapinaliquorstore", true) == 0) {

		if(GetPlayerTeam(playerid) == 1) //se il player è un criminale
		{

			if(robpossible == 1) //Se la rapina è possibile
			{
				if(IsPlayerInRangeOfPoint(playerid, 3.0, 254.2738, -57.5924, 1.5703))
				{
			    	robpossible = 0;
					robber[playerid] = 1;
			    //	SetTimer("robcheck", 45000, false); // Setta il Checkpoint per la meta

					new str[128], pName[24];
					GetPlayerName(playerid, pName, 24);
					format(str, sizeof(str), "Qualcuno ((%s)) ha iniziato la rapina al Liquor Store di Blueberry!", pName);
			    	
                    SendClientMessageToAll(COLOR_BLUE, "============ ALLARME AL LIQUOR STORE =============");
					SendClientMessageToAll(COLOR_GRAD1, str);
                    SendClientMessageToAll(COLOR_GRAD1, "Poliziotti, accorrete a fermare il rapinatore prima che sia troppo tardi!");
                    SendClientMessageToAll(COLOR_BLUE, "============ ====================== =============");

			    	SendClientMessage(playerid, COLOR_GRAD1, "[RAPINA] Hai cominciato una rapina e la polizia è stata notificata.");
	            //	SendClientMessage(playerid, COLOR_GRAD1, "[RAPINA] Rimani per almeno 45 secondi nell'edificio per rubare i soldi!");
					robcheck(playerid);
	            	return 1;
			 	}else{
			 	    SendClientMessage(playerid, COLOR_RED, "[Errore] Devi essere all'interno dell'edificio per iniziare la rapina.");
			 	}
			} else {
		    	SendClientMessage(playerid, COLOR_RED, "[Errore] Devi aspettare che finisca la rapina in corso per poter farne un'altra.");
			}
		}else{
			SendClientMessage(playerid, COLOR_RED, "[Errore] Devi settarti il team da /criminale per fare questa rapina.");
		}
		return 1;
	}

// ----------------- /arrenditi -----------------
	
	if(strcmp(cmdtext, "/arrenditi", true) == 0) {

    	if(robber[playerid]==1){
        	SendClientMessageToAll(COLOR_BLUE, "[RAPINA] La rapina è fallita poiché il rapinatore si è arreso. Ottimo lavoro poliziotti!");
            robdenied(playerid);
		}else{
		    SendClientMessage(playerid, COLOR_RED, "[Errore] Non sei il rapinatore principale della rapina.");
		}
		return 1;
	}
		
	return 0;
}


// ============= FUNZIONI PRINCIPALI ===============


public OnPlayerEnterCheckpoint(playerid)
{
      
    if(robcp[playerid] == 1){
		 robsuccess(playerid);
         return 1;
      }

    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(robber[playerid]==1){
        SendClientMessageToAll(COLOR_BLUE, "[RAPINA] La rapina è fallita poichè il rapinatore è morto! Ottimo lavoro poliziotti!");
        robdenied(playerid);
	}
	
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(robber[playerid]==1){
        SendClientMessageToAll(COLOR_BLUE, "[RAPINA] La rapina è fallita poichè il rapinatore si è disconnesso!");
        robdenied(playerid);
	}

	return 1;
}

// ======================= FUNZIONI ===========================

public robcheck(playerid)
{
		SetPlayerCheckpoint(playerid,-68.0099,-1175.0652,1.5499,5);
		SetPlayerAttachedObject(playerid, 3, 1550, 1, 0.1, -0.3, 0, 0, 40, 0, 1, 1, 1);
		robcp[playerid] = 1;
	//	SendClientMessage(playerid, COLOR_GRAD1, "[RAPINA] Hai raccolto tutti i soldi disponibili, ora è venuto il momento di scappare!");
		SendClientMessage(playerid, COLOR_GRAD1, "[RAPINA] Prendi tutto ciò che puoi e raggiungi la meta prima che la polizia riesca a prenderti!");
}

public robsuccess(playerid)
{
    robcp[playerid] = 0;
    robber[playerid] = 0;
    DisablePlayerCheckpoint(playerid);
	new string[128];
    new cash = random(200000);
	GivePlayerMoney(playerid, cash); // Da soldi Random
	SetTimer("waittimer", 10000, false); // 10 sec per rifare una rapina
	format(string, sizeof(string), "[RAPINA] Il rapinatore è fuggito e ha rubato $%d dall'edificio con successo!", cash);
	SendClientMessageToAll(COLOR_BLUE, string);
}

public robdenied(playerid)
{
    SetTimer("waittimer", 10000, false); // 10 sec per rifare una rapina
    robcp[playerid] = 0;
    robber[playerid] = 0;
    DisablePlayerCheckpoint(playerid);
}

public waittimer()
{
	robpossible = 1;
	SendClientMessageToAll(COLOR_GIALLO, "[SERVER] La rapina al Liquor Store è nuovamente disponibile!");
}











