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

forward tvcheck(playerid);
forward tvsuccess(playerid);
forward tvdenied(playerid);
forward waittimer();

new tvpossible; // è possibile / no fare la scorta
new tvcp[256]; // checkpoints
new guard[256]; // è a capo della scorta
new tvfurgone; // id furgone

public OnFilterScriptInit()
{
	print("--------------------------------------");
	print("-  Sistema Scorta, Trasporto Valori  -");
	print("-           by Maxel                 -");
	print("--------------------------------------");
	tvpossible = 1;
	return 1;
}


// ======================= COMANDI ===========================

public OnPlayerCommandText(playerid, cmdtext[])
{

	if(strcmp(cmdtext, "/trasportovalori", true) == 0) {

		if(GetPlayerTeam(playerid) == 0) //se il player è in polizia
		{

			if(tvpossible == 1) //Se la rapina è possibile
			{
				if(IsPlayerInRangeOfPoint(playerid, 5.0, 2786.5195, -1848.8776, 9.9580))
				{
					// ---- Settaggi generali
			    	tvpossible = 0;
					guard[playerid] = 1;
			    	//SetTimer("tvcheck", 5000, false); // Setta il Checkpoint per la meta

					// ---- Crea il furgone portavalori
					new macchina;
					macchina = AddStaticVehicle(427,2786.5195,-1848.8776,9.9580,266.3516,0,1); // Enforcer Nero
					PutPlayerInVehicle(playerid, macchina, 0);
					tvfurgone = GetPlayerVehicleID(playerid);

					// ---- Avvisi in chat
					new str[128], pName[24];
					GetPlayerName(playerid, pName, 24);
					format(str, sizeof(str), "è iniziato. Si prega di seguire le direttive dell'agente %s, capo al comando della scorta!", pName);
			    	
                    SendClientMessageToAll(COLOR_BLUE, "============ AVVISO DIPARTIMENTALE ==============");
                    SendClientMessageToAll(COLOR_WHITE, "Il trasporto valori con partenza dallo stadio di Los Santos e con arrivo alla Banca Nord di Rodeo");
					SendClientMessageToAll(COLOR_WHITE, str);
                    SendClientMessageToAll(COLOR_GRAD1, "Tutti gli agenti disponibili del LSPD si tengano pronti per la partenza.");
                    SendClientMessageToAll(COLOR_BLUE, "============ ====================== =============");
                  //  SendClientMessage(playerid, COLOR_GRAD1, "[SCORTA] Computer inizializzato, preparazione GPS in corso...");

					tvcheck(playerid);
                    
                    for(new i = 0; i < MAX_PLAYERS; i++)
                    {
                        if(GetPlayerTeam(i) == 1){
                            SendClientMessage(playerid, COLOR_GRAD1, "[SCORTA] Criminali, intercettate il furgone portavalori prima che giunga a destinazione!");
                        }
                    }
                    
	            	return 1;
			 	}else{
			 	    SendClientMessage(playerid, COLOR_RED, "[Errore] Devi essere vicino al Pickup dello stadio di Los Santos per iniziare la scorta.");
			 	}
			} else {
		    	SendClientMessage(playerid, COLOR_RED, "[Errore] Devi aspettare che finisca il trasporto valori in corso per poter iniziarne un altro.");
			}
		}else{
			SendClientMessage(playerid, COLOR_RED, "[Errore] Devi settarti il team da /polizia per fare questa scorta.");
		}
		return 1;
	}
	
// ----------------- /arrenditi -----------------

	if(strcmp(cmdtext, "/annullatrasportovalori", true) == 0) {

    	if(guard[playerid]==1 && tvcp[playerid]==1){
        	SendClientMessageToAll(COLOR_BLUE, "[SCORTA] La scorta è fallita poiché è stata annullata dal capo della scorta in carica!");
            tvdenied(playerid);
		}else{
		    SendClientMessage(playerid, COLOR_RED, "[Errore] Non sei il capo che dirige la scorta / non puoi annullare una scorta che non è ancora iniziata.");
		}
		return 1;
	}

	return 0;
}


// ============= FUNZIONI PRINCIPALI ===============


public OnPlayerEnterCheckpoint(playerid)
{

    if(tvcp[playerid] == 1){
         tvcp[playerid] = 2;
         SetPlayerCheckpoint(playerid,2822.7563,-1889.5355,11.0657,5);
         return 1;
      }

    if(tvcp[playerid] == 2){
         tvcp[playerid] = 3;
         SetPlayerCheckpoint(playerid,2690.4929,-1881.0870,11.0154,5);
         return 1;
      }

    if(tvcp[playerid] == 3){
         tvcp[playerid] = 4;
         SetPlayerCheckpoint(playerid,2643.4719,-1738.9625,10.8666,5);
         return 1;
      }

    if(tvcp[playerid] == 4){
         tvcp[playerid] = 5;
         SetPlayerCheckpoint(playerid,2419.7686,-1731.7473,13.6265,5);
         return 1;
      }

    if(tvcp[playerid] == 5){
         tvcp[playerid] = 6;
         SetPlayerCheckpoint(playerid,2224.7588,-1731.5477,13.5216,5);
         return 1;
      }

    if(tvcp[playerid] == 6){
         tvcp[playerid] = 7;
         SetPlayerCheckpoint(playerid,2180.6340,-1750.2327,13.5067,5);
         return 1;
      }

    if(tvcp[playerid] == 7){
         tvcp[playerid] = 8;
         SetPlayerCheckpoint(playerid,2091.4111,-1750.8214,13.5366,5);
         return 1;
      }

    if(tvcp[playerid] == 8){
         tvcp[playerid] = 9;
         SetPlayerCheckpoint(playerid,1964.9841,-1750.5120,13.5151,5);
         return 1;
      }

    if(tvcp[playerid] == 9){
         tvcp[playerid] = 10;
         SetPlayerCheckpoint(playerid,1941.2614,-1616.1084,13.5150,5);
         return 1;
      }

    if(tvcp[playerid] == 10){
         tvcp[playerid] = 11;
         SetPlayerCheckpoint(playerid,1819.2671,-1610.8816,13.5129,5);
         return 1;
      }

    if(tvcp[playerid] == 11){
         tvcp[playerid] = 12;
         SetPlayerCheckpoint(playerid,1621.8440,-1591.3638,13.6786,5);
         return 1;
      }

    if(tvcp[playerid] == 12){
         tvcp[playerid] = 13;
         SetPlayerCheckpoint(playerid,1434.8787,-1591.1725,13.5225,5);
         return 1;
      }

    if(tvcp[playerid] == 13){
         tvcp[playerid] = 14;
         SetPlayerCheckpoint(playerid,1322.7120,-1570.7758,13.5028,5);
         return 1;
      }

    if(tvcp[playerid] == 14){
         tvcp[playerid] = 15;
         SetPlayerCheckpoint(playerid,1357.8367,-1403.4036,13.4344,5);
         return 1;
      }

    if(tvcp[playerid] == 15){
         tvcp[playerid] = 16;
         SetPlayerCheckpoint(playerid,1253.2059,-1395.8138,13.1460,5);
         return 1;
      }

    if(tvcp[playerid] == 16){
         tvcp[playerid] = 17;
         SetPlayerCheckpoint(playerid,1061.8761,-1395.4841,13.6183,5);
         return 1;
      }

    if(tvcp[playerid] == 17){
         tvcp[playerid] = 18;
         SetPlayerCheckpoint(playerid,917.3436,-1395.2349,13.3824,5);
         return 1;
      }

    if(tvcp[playerid] == 18){
         tvcp[playerid] = 19;
         SetPlayerCheckpoint(playerid,798.5355,-1395.2850,13.5697,5);
         return 1;
      }

    if(tvcp[playerid] == 19){
         tvcp[playerid] = 20;
         SetPlayerCheckpoint(playerid,646.0681,-1394.7781,13.5746,5);
         return 1;
      }

    if(tvcp[playerid] == 20){
         tvcp[playerid] = 21;
         SetPlayerCheckpoint(playerid,637.0007,-1319.1283,13.5030,5);
         return 1;
      }

    if(tvcp[playerid] == 21){
         tvcp[playerid] = 22;
         SetPlayerCheckpoint(playerid,596.8715,-1288.8990,15.6879,5);
         return 1;
      }
      
    if(tvcp[playerid] == 22){
		 tvsuccess(playerid);
         return 1;
      }

    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(guard[playerid]==1){
        SendClientMessageToAll(COLOR_BLUE, "[SCORTA] La scorta è fallita poiché il conducente del furgone portavalori è morto!");
        tvdenied(playerid);
	}
	
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(guard[playerid]==1){
        SendClientMessageToAll(COLOR_BLUE, "[SCORTA] La scorta è fallita poiché il conducente del furgone portavalori si è disconnesso!");
        tvdenied(playerid);
	}

	return 1;
}

// ======================= FUNZIONI ===========================

public tvcheck(playerid)
{
	SetPlayerCheckpoint(playerid,2786.5195,-1848.8776,9.9580,5);
	tvcp[playerid] = 1;
	SendClientMessage(playerid, COLOR_GRAD1, "[SCORTA] La scorta è ufficialmente iniziata! Segui i checkpoints fino a destinazione.");
	SendClientMessage(playerid, COLOR_GRAD1, "[SCORTA] Puoi sempre annullare la scorta digitando /annullatrasportovalori.");
}

public tvsuccess(playerid)
{
	SetTimer("waittimer", 10000, false); // 10 sec per rifare una scorta
    guard[playerid] = 0;
    tvcp[playerid] = 0;
    DestroyVehicle(tvfurgone);
    DisablePlayerCheckpoint(playerid);
	SendClientMessageToAll(COLOR_BLUE, "[SCORTA] Il furgone portavalori è arrivato a destinazione con successo! Ottimo lavoro poliziotti!");
}

public tvdenied(playerid)
{
    SetTimer("waittimer", 10000, false); // 10 sec per rifare una scorta
    guard[playerid] = 0;
	tvcp[playerid] = 0;
	DestroyVehicle(tvfurgone);
    DisablePlayerCheckpoint(playerid);
}

public waittimer()
{
	tvpossible = 1;
	SendClientMessageToAll(COLOR_GIALLO, "[SERVER] Il trasporto valori (Stadio LS - Banca Nord Rodeo) è nuovamente disponibile!");
}











