/*-----------------------------------------------------------------
            Converti i Give PlayerMoney con quelli dell'anticheat
            Aggiungi al DB il campo JOB e Component, e aggiungili anche al salvataggio
            Implementa l'attuale sistema tassista a questo (Invece di fare il Check della fazione fai == TAXIST Owl)
            I Pay'n'Spray sono totalmente dinamici anche se non si salvano, se è necessario farò un comando che li crea IG.
            bb.

-------------------------------------------------------------------*/

#include <a_samp>
#include <foreach>
            #include colors // Se vedi questi due eliminali, a te non servono
            #include zones
#include <zcmd>
#include <sscanf2>
#include <streamer>

enum dialogID
{
    LISTJOBS,
    MECHJOB,
    TAXIJOB,
    TRANSPORTERJOB,
    FARMERJOB
};

enum pInfo
{
    Job,
    Component,
};

new PlayerInfo[MAX_PLAYERS][pInfo];

new WorkProposed[MAX_PLAYERS],
    TimerWork[MAX_PLAYERS],
    ToolBox[MAX_PLAYERS],
    JobDuty[MAX_PLAYERS],
    JobRequest[MAX_PLAYERS],
    WorkAccepted[MAX_PLAYERS];

#define NO_JOB 0
#define MECHANIC 1
#define TAXIST 2
#define TRANSPORTER 3
#define FARMER 4


#define TAXI_TAX 500
#define MECHANIC_TAX 900
#define TRANSPORTER_TAX 2000
#define FARMER_TAX 300

#define COMP_PRICE 10

new FarmerZones[][] = 
    {-595, -1388, -360, -1277, 
    {-329, -1431, -161, -1309}, 
    {-341, -1531, -210, -1460}
};


#define strcpy(%0,%1,%2) \
	strcat((%0[0] = '\0', %0), %1, %2)

main()
{
	print("\n----------------------------------");
	print("  Blank Script\n");
	print("----------------------------------\n");
}

public OnPlayerConnect(playerid)
{
    WorkProposed[playerid] = -1;
    WorkAccepted[playerid] = -1;
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    WorkProposed[playerid] = -1;
    WorkAccepted[playerid] = -1;
   	return 1;
}

public OnGameModeInit()
{
    SetGameModeText("Bare Script");
	AddPlayerClass(265,1958.3783,1343.1572,15.3746,270.1425,0,0,0,0,-1,-1);
    CreateDynamicPickup(1239, 1, 492.7678,194.8144,1025.8496, 0); // Ufficio Licenze -> 492.7678,194.8144,1025.8496
    CreateDynamicPickup(1239, 1, 2076.2246,-2033.5221,13.5469, 0); // /compracomp -> 2076.2246,-2033.5221,13.5469
    CreateDynamic3DTextLabel("Ufficio Licenze\n\n((/prendilavoro))", COLOR_LIGHTYELLOW, 492.7678,194.8144,1025.8496+0.5, 10);
    CreateDynamic3DTextLabel("Discarica\n\n((/compracomp))", COLOR_LIGHTYELLOW, 2076.2246,-2033.5221,13.5469+0.5,10);
	return 1;
}

CMD:prendilavoro(playerid, params[])
{
    if(IsPlayerInRangeOfPoint(playerid, 1.0, 1961.2810,1346.0297,15.3746))
    {
        ShowPlayerDialog(playerid, LISTJOBS, DIALOG_STYLE_LIST,"Ufficio licenze", "Meccanico\nTassista\nTransportatore\nAgricoltore","Conferma","Annulla");    
        return 1;
    }    
    else return SendClientMessage(playerid, COLOR_RED, "Vai al comune per richiedere o vedere i requisiti per una licenza!");
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case LISTJOBS:
        {
            if(!response) return 1;
            new string[165];
            switch(listitem)
            {
                case 0:
                {
                    format(string,sizeof(string), "Hai scelto come lavoro il meccanico.\nRequisiti: Possedere un TowTruck e avere %d$ per pagare la licenza da libero professionista\n\nConfermi questo lavoro?",MECHANIC_TAX);
                    ShowPlayerDialog(playerid, MECHJOB, DIALOG_STYLE_MSGBOX, "Ufficio Licenze",string,"Accetta","Annulla");
                    return 1;
                }
                case 1:
                {
                    format(string,sizeof(string), "Hai scelto come lavoro il tassista.\nRequisiti: Possedere un Taxi o un Cabbie e avere %d$ per pagare la licenza da tassista\n\nConfermi questo lavoro?",TAXI_TAX);
                    ShowPlayerDialog(playerid, TAXIJOB, DIALOG_STYLE_MSGBOX, "Ufficio Licenze",string,"Accetta","Annulla");
                    return 1;
                }
                case 2:
                {
                    format(string,sizeof(string), "Hai scelto come lavoro il transportatore.\nRequisiti: Possedere un Taxi o un Cabbie e avere %d$ per pagare la licenza da tassista\n\nConfermi questo lavoro?",TAXI_TAX);
                    ShowPlayerDialog(playerid, TRANSPORTERJOB, DIALOG_STYLE_MSGBOX, "Ufficio Licenze",string,"Accetta","Annulla");                  
                }
                case 3:
                {
                    format(string,sizeof(string), "Hai scelto come lavoro l'agricoltore.\nRequisiti: Possedere un trattore e avere %d$ per pagare la licenza\n\nConfermi questo lavoro?",FARMER_TAX);
                    ShowPlayerDialog(playerid, FARMERJOB, DIALOG_STYLE_MSGBOX, "Ufficio Licenze", string, "Accetta", "Annulla");
                }
            }
            return 1;
        }
        case MECHJOB:
        {
            if(!response) return 1;
            if(GetPlayerMoney(playerid) < MECHANIC_TAX) return SendClientMessage(playerid, COLOR_RED, "Non hai abbastanza soldi per pagare la tassa!");
            SendClientMessage(playerid, COLOR_LIGHTGREEN, "Hai confermato l'acquisizione della licenza e pagato la tassa, Ora sei un Meccanico.");
            PlayerInfo[playerid][Job] = MECHANIC;
            GivePlayerMoney(playerid, -MECHANIC_TAX);
            return 1;
        }
        case TAXIJOB:
        {
            if(!response) return 1;
            if(GetPlayerMoney(playerid) < TAXI_TAX) return SendClientMessage(playerid, COLOR_RED, "Non hai abbastanza soldi per pagare la tassa!");
            SendClientMessage(playerid, COLOR_LIGHTGREEN, "Hai confermato l'acquisizione della licenza e pagato la tassa, Ora sei un Tassista.");
            PlayerInfo[playerid][Job] = TAXIST;
            GivePlayerMoney(playerid, -TAXI_TAX);
            return 1;      
        }
        case TRANSPORTERJOB:
        {
            if(!response) return 1;
            if(GetPlayerMoney(playerid) < TRANSPORTER_TAX) return SendClientMessage(playerid, COLOR_RED, "Non hai abbastanza soldi per pagare la tassa!");
            SendClientMessage(playerid, COLOR_LIGHTGREEN, "Hai confermato l'acquisizione della licenza e pagato la tassa, Ora sei un Transportatore.");
            PlayerInfo[playerid][Job] = TRANSPORTER;
            GivePlayerMoney(playerid, -TRANSPORTER_TAX);    
            return 1;        
        }
        case FARMERJOB:
        {
            if(!response) return 1;
            if(GetPlayerMoney(playerid) < FARMER_TAX) return SendClientMessage(playerid, COLOR_RED, "Non hai abbastanza soldi per pagare la tassa!");
            SendClientMessage(playerid, COLOR_LIGHTGREEN, "Hai confermato l'acquisizione della licenza e pagato la tassa, Ora sei un Agricoltore.");
            PlayerInfo[playerid][Job] = FARMER;
            GivePlayerMoney(playerid, -FARMER_TAX);    
            return 1;               
        }

    }
    return 1;
}

CMD:lservizio(playerid, params[])
{
    if(PlayerInfo[playerid][Job] == NO_JOB) return SendClientMessage(playerid, COLOR_RED,"Non hai nessun lavoro! vai al comune a richiedere una licenza o per vedere i requisiti!");
    new job[16],str[90];
    switch(PlayerInfo[playerid][Job])
    {
        case MECHANIC: strcpy(job, "meccanico",12);
        case TAXIST: strcpy(job, "tassista",12);
        case TRANSPORTER: return 1;
    }
    if(JobDuty[playerid] == 0)
    {
        format(str,sizeof(str), "Sei andato in servizio come %s, ora riceverai le chiamate dal centralino",job);
        SendClientMessage(playerid, COLOR_LIGHTGREEN, str);
        JobDuty[playerid] = 1;
        return 1;
    }
    else if(JobDuty[playerid] == 1)
    {
        format(str,sizeof(str), "Sei andato fuori servizio come %s, ora non riceverai le chiamate dal centralino",job);
        SendClientMessage(playerid, COLOR_LIGHTGREEN, str);
        JobDuty[playerid] = 0;
        return 1;      
    }
    return 1;
}

CMD:lascialavoro(playerid, params[])
{
    if(PlayerInfo[playerid][Job] == NO_JOB) return SendClientMessage(playerid, COLOR_RED, "Non hai nessun lavoro! vai al comune a richiedere una licenza o per vedere i requisiti!");
    new job[16], str[64];
    switch(PlayerInfo[playerid][Job])
    {
        case MECHANIC: strcpy(job, "meccanico",12);
        case TAXIST: strcpy(job, "tassista",12);
        case TRANSPORTER: strcpy(job, "transportatore", 16);
    }
    PlayerInfo[playerid][Job] = NO_JOB;
    format(str,sizeof(str), "Hai lasciato il tuo lavoro, non sei piu' un %s",job);
    SendClientMessage(playerid, COLOR_GREEN, str);
    return 1;
}

CMD:toolbox(playerid,params[])
{
    new str[74];
    //Check se il Towtruck è vicino al player e se il player in questione è il propietario
    if(ToolBox[playerid] == 0)
    {
        SetPlayerAttachedObject(playerid, 9, 19921,6,0.062999,-0.001000,0.000000,-67.900024,-6.000000,-93.999969,0.595000,0.284999,0.561999);
        ToolBox[playerid] = 1;
        format(str,sizeof(str), "* Afferra una cassetta degli attrezzi dal retro del towtruck *");
        // Ame
        return 1;
    }
    if(ToolBox[playerid] == 1)
    {
        RemovePlayerAttachedObject(playerid, 9);
        ToolBox[playerid] = 0;
        format(str,sizeof(str), "* Ripone una cassetta degli attrezzi dal retro del towtruck *");
        // Ame
        return 1;
    }
    return 1;
}

CMD:aiutolavoro(playerid, params[])
{
    switch(PlayerInfo[playerid][Job])
    {
        case MECHANIC: return SendClientMessage(playerid, COLOR_AQUA, "Lavoro: /servizi - /lservizio - /vernicia - /toolbox - /compracomp - /rimorchia");
        case TAXIST: return SendClientMessage(playerid, COLOR_AQUA, "DEVI SETTARE I COMANDI");
        case TRANSPORTER: return SendClientMessage(playerid, COLOR_AQUA, "Lavoro: /tpda");
    }
    return 1;
}
command(rimorchia, playerid, params[])
{
    if(IsPlayerConnected(playerid))
    {
        if(IsPlayerInAnyVehicle(playerid))
        {
            if (GetVehicleModel(GetPlayerVehicleID(playerid)) == 525 && PlayerInfo[playerid][Job] == MECHANIC && JobDuty[playerid] == 1)
            {
                if(GetPlayerState(playerid)==2)
                {
                    new otherid;
                    if(sscanf(params,"u",otherid)) return SendClientMessage(playerid, COLOR_WHITE, "USO: /rimorchia <playerid/part of name>");
                    new Float:X,Float:Y,Float:Z;
                    GetPlayerPos(otherid, X,Y,Z);
                    if(!IsPlayerInRangeOfPoint(playerid, 10.0, X, Y, Z)) return SendClientMessage(playerid, COLOR_RED, "Non sei vicino al player!");
                    if(!IsPlayerInAnyVehicle(otherid)) return SendClientMessage(playerid, COLOR_RED, "Il player non è in nessun veicolo!");
                    if(GetPlayerState(otherid) != PLAYER_STATE_PASSENGER) return SendClientMessage(playerid, COLOR_RED, "Il player deve essere un passeggero del veicolo!");
                    if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid))) return DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
                    new vid = GetPlayerVehicleID(otherid);
                    AttachTrailerToVehicle(vid, GetPlayerVehicleID(playerid));
                    return 1;
                }
                else
                {
                    SendClientMessage(playerid, COLOR_RED, "Devi essere l'autista!");
                    return 1;
                }
            }
            else
            {
                SendClientMessage(playerid, COLOR_RED, "Devi essere in un Tow Truck ed essere un meccanico in servizio!");
                return 1;
            }
        }
        else
        {
            SendClientMessage(playerid, COLOR_RED, "Devi essere in un veicolo!");
            return 1;
        }
    }
    return 1;
}

CMD:compracomp(playerid, params[])
{
    new comp;
    if(PlayerInfo[playerid][Job] != MECHANIC) return SendClientMessage(playerid, COLOR_RED, "Non sei un meccanico!");
    if(sscanf(params, "d",comp)) return SendClientMessage(playerid, COLOR_WHITE, "USO: /compracomp <quantita'>");
    if(IsPlayerInRangeOfPoint(playerid, 1.5,  1961.3921,1339.7588,15.3746))
    {
        if(PlayerInfo[playerid][Component]+comp > 500) return SendClientMessage(playerid, COLOR_RED, "Il limite di componenti che puoi tenere nel towtruck e' di 500!");
        if(GetPlayerMoney(playerid) < COMP_PRICE*comp) return SendClientMessage(playerid, COLOR_RED, "Non hai abbastanza soldi per tutti quei componenti! (10$ caduno)");
        GivePlayerMoney(playerid, -COMP_PRICE*comp);
        new str[64];
        PlayerInfo[playerid][Component] += comp;
        format(str,sizeof(str), "Hai comprato %d componenti per al costo di %d$",comp,COMP_PRICE*comp);
        SendClientMessage(playerid, COLOR_GREEN, str);
        return 1;
    }
    else return SendClientMessage(playerid, COLOR_RED, "Non sei vicino al punto d'acquisto componenti! (Ocean Docks)");
}

CMD:componenti(playerid, params[])
{
    if(PlayerInfo[playerid][Job] != MECHANIC) return SendClientMessage(playerid, COLOR_RED, "Non sei un meccanico!");
    new str[64];
    format(str,sizeof(str), "Ti rimangono %d componenti nel towtruck, puoi comprarne altri a Ocean Docks!",PlayerInfo[playerid][Component]);
    SendClientMessage(playerid, COLOR_LIGHTBLUE, str);
    return 1;
}

CMD:servizi(playerid, params[])
{
    if(PlayerInfo[playerid][Job] != MECHANIC) return SendClientMessage(playerid, COLOR_RED, "Non sei un meccanico!");
    if(ToolBox[playerid] == 0) return SendClientMessage(playerid, COLOR_RED, "Non hai la cassetta degli attrezzi con te! usa /toolbox vicino al tuo towtruck!");
    new otherid,type,price;
    if(sscanf(params, "udd",otherid,type,price))
    {
        SendClientMessage(playerid, COLOR_WHITE, "USO: /servizi <playerid/part of name> <tipo> <costo>");
        SendClientMessage(playerid, COLOR_AQUA, "Tipi di servizio: 1 = Riparazione, 2 = Rifornimento");
        return 1;
    }
    if(!IsPlayerInAnyVehicle(otherid)) return SendClientMessage(playerid, COLOR_RED, "Il player non e' in nessun veicolo!");
    if(GetPlayerMoney(otherid) < price) return SendClientMessage(playerid, COLOR_RED, "Il player non ha abbastanza soldi!");
    if(otherid == playerid) return 1;
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return SendClientMessage(playerid, COLOR_RED, "Devi essere a piedi per fare questo comando!");
    new Float:X,Float:Y,Float:Z;
    GetPlayerPos(otherid, X,Y,Z);
    if(!IsPlayerInRangeOfPoint(playerid, 2.0, X,Y,Z)) return SendClientMessage(playerid, COLOR_RED, "Sei troppo lontano dal giocatore!");
    new str[124];
    switch(type)
    {
        case 1:
        {
            if(PlayerInfo[playerid][Component] < 10) return SendClientMessage(playerid, COLOR_RED, "Non i componenti necessari per riparare il veicolo, comprane altri ad Ocean Docks!");
            SetPVarInt(otherid,"MechPrice",price);
            WorkProposed[otherid] = playerid;
            format(str,sizeof(str), "Il meccanico %s ti ha offerto di riparare la tua auto per %d$!",GetPlayerNameEx(playerid),price);
            SendClientMessage(otherid, COLOR_LIGHTBLUE, str);
            SendClientMessage(otherid, COLOR_LIGHTBLUE, "Usa /accetta riparazione per confermare");
            format(str,sizeof(str), "Hai offerto a %s una riparazione per %d$!",GetPlayerNameEx(otherid),price);
            SendClientMessage(playerid, COLOR_LIGHTBLUE, str);   
            TimerWork[playerid] = SetTimerEx("ResetWorkP",20000,false,"dd",playerid,otherid);
            JobRequest[otherid] = 5;
            return 1;
        }
        case 2:
        {
            if(PlayerInfo[playerid][Component] < 2) return SendClientMessage(playerid, COLOR_RED, "Non i componenti necessari per rifornire il veicolo, comprane altri ad Ocean Docks!");
            SetPVarInt(otherid,"MechPrice",price);
            WorkProposed[otherid] = playerid;
            format(str,sizeof(str), "Il meccanico %s ti ha offerto di rifornire la tua auto per %d$!",GetPlayerNameEx(playerid),price);
            SendClientMessage(otherid, COLOR_LIGHTBLUE, str);
            SendClientMessage(otherid, COLOR_LIGHTBLUE, "Usa /accetta rifornimento per confermare");
            format(str,sizeof(str), "Hai offerto a %s un rifornimento per %d$!",GetPlayerNameEx(otherid),price);
            SendClientMessage(playerid, COLOR_LIGHTBLUE, str);    
            TimerWork[playerid] = SetTimerEx("ResetWorkP",20000,false,"dd",playerid,otherid);
            JobRequest[otherid] = 6;
            return 1;
        }
    }
    return 1;
}

CMD:vernicia(playerid, params[])
{
    new otherid, col1,col2,price;
    if(sscanf(params, "uddd",otherid, col1,col2,price)) return SendClientMessage(playerid, COLOR_WHITE, "USO: /vernicia <id/partofname> <color1> <color2> <prezzo>");
    if(col1 < 0 || col1 > 255 || col2 < 0 || col2 > 255) return SendClientMessage(playerid, COLOR_RED, "Range di colori consentito da 0 a 255!");
    if(PlayerInfo[playerid][Component] < 5) return SendClientMessage(playerid, COLOR_RED, "Non i componenti necessari per riverniciare il veicolo, comprane altri ad Ocean Docks!");
    if(ToolBox[playerid] == 0) return SendClientMessage(playerid, COLOR_RED, "Non hai la cassetta degli attrezzi con te! usa /toolbox vicino al tuo towtruck!");
    if(otherid == playerid) return 1;
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return SendClientMessage(playerid, COLOR_RED, "Devi essere a piedi per fare questo comando!");
    new Float:X,Float:Y,Float:Z;
    GetPlayerPos(otherid, X,Y,Z);
    if(!IsPlayerInRangeOfPoint(playerid, 2.0, X,Y,Z)) return SendClientMessage(playerid, COLOR_RED, "Sei troppo lontano dal giocatore!");
    if(GetPlayerMoney(otherid) < price) return SendClientMessage(playerid, COLOR_RED, "Il player non ha abbastanza soldi!");
    if(!IsPlayerInAnyVehicle(otherid)) return SendClientMessage(playerid, COLOR_RED, "Il player non e' in nessun veicolo!");
    new str[90];
    format(str,sizeof(str), "Il meccanico %s ti ha offerto di riverniciare la tua auto per %d$!",GetPlayerNameEx(playerid),price);
    SendClientMessage(otherid, COLOR_LIGHTBLUE, str);
    SendClientMessage(otherid, COLOR_LIGHTBLUE, "Usa /accetta verniciatura per confermare");
    format(str,sizeof(str), "Hai offerto a %s di verniciare la sua auto per %d$!",GetPlayerNameEx(otherid),price);
    SendClientMessage(playerid, COLOR_LIGHTBLUE, str);    
    SetPVarInt(otherid,"MechPrice",price);
    SetPVarInt(otherid, "Color1",col1);
    SetPVarInt(otherid, "Color2",col2);
    WorkProposed[otherid] = playerid;
    TimerWork[playerid] = SetTimerEx("ResetWorkP",20000,false,"dd",playerid,otherid);
    JobRequest[otherid] = 7;
    return 1;
}

CMD:accetta(playerid, params[])
{
    new offer[24];
    if(sscanf(params,"s[24]",offer))
    {
        SendClientMessage(playerid, COLOR_WHITE, "USO: /accetta <tipo>");
        SendClientMessage(playerid, COLOR_AQUA, "TIPI: Riparazione, verniciatura, rifornimento");
        return 1;
    }
    if(!strcmp(offer, "riparazione"))
    {
        if(WorkProposed[playerid] != -1 && JobRequest[playerid] == 5)
        {
            new price = GetPVarInt(playerid, "MechPrice"), otherid = WorkProposed[playerid];
            WorkProposed[playerid] = -1;
            DeletePVar(playerid, "MechPrice");
            KillTimer(TimerWork[otherid]);
            GivePlayerMoney(playerid, -price);
            PlayerInfo[otherid][Component] -= 10;
            GivePlayerMoney(otherid, price);
            new vid = GetPlayerVehicleID(playerid), string[96];
            RepairVehicle(vid);
            SetVehicleHealth(vid, 999.9);
            format(string,sizeof(string), "Hai riparato il veicolo di %s per 10 componenti, nel farlo hai guadagnato: %d$",GetPlayerNameEx(playerid ),price);
            SendClientMessage(otherid, COLOR_LIGHTBLUE, string);
            format(string,sizeof(string), "%s ha riparato il tuo veicolo per %d$",GetPlayerNameEx(otherid), price);
            SendClientMessage(playerid,COLOR_LIGHTBLUE, string);   
            JobRequest[playerid] = NO_JOB; 
            return 1;      
        }
    }
    if(!strcmp(offer, "verniciatura"))
    {
        if(WorkProposed[playerid] != -1 && JobRequest[playerid] == 7)
        {
            new price = GetPVarInt(playerid, "MechPrice"), otherid = WorkProposed[playerid],col1 = GetPVarInt(playerid, "Color1"), col2 = GetPVarInt(playerid, "Color2");
            WorkProposed[playerid] = -1;
            DeletePVar(playerid, "MechPrice");  
            DeletePVar(playerid, "Color1");
            DeletePVar(playerid, "Color2"); 
            KillTimer(TimerWork[otherid]);  
            GivePlayerMoney(otherid, price);
            GivePlayerMoney(playerid, -price);
            PlayerInfo[otherid][Component] -= 5;
            new vid = GetPlayerVehicleID(playerid), string[96];
            format(string,sizeof(string), "Hai riverniciato il veicolo di %s per 5 componenti, nel farlo hai guadagnato: %d$",GetPlayerNameEx(playerid),price);
            SendClientMessage(otherid, COLOR_LIGHTBLUE, string);
            format(string,sizeof(string), "%s ha riverniciato il tuo veicolo per %d$",GetPlayerNameEx(otherid), price);
            SendClientMessage(playerid,COLOR_LIGHTBLUE, string);   
            ChangeVehicleColor(vid, col1,col2);
            JobRequest[playerid] = NO_JOB;
            return 1;
        }
    }
    if(!strcmp(offer, "rifornimento"))
    {
        if(WorkProposed[playerid] != -1 && JobRequest[playerid] == 6)
        {
            new price = GetPVarInt(playerid, "MechPrice"), otherid = WorkProposed[playerid];
            WorkProposed[playerid] = -1;
            DeletePVar(playerid, "MechPrice");
            KillTimer(TimerWork[otherid]);
            GivePlayerMoney(otherid, price);
            GivePlayerMoney(playerid, -price);
            PlayerInfo[otherid][Component] -= 2;
            new string[96];
            format(string,sizeof(string), "Hai rifornito di benzina il veicolo di %s per 2 componenti, nel farlo hai guadagnato: %d$",GetPlayerNameEx(playerid),price);
            SendClientMessage(otherid, COLOR_LIGHTBLUE, string);
            format(string,sizeof(string), "%s ha rifornito il tuo veicolo per %d$",GetPlayerNameEx(otherid), price);
            SendClientMessage(playerid,COLOR_LIGHTBLUE, string);  
            JobRequest[playerid] = NO_JOB;
            return 1;
            //Aggiungi che il veicolo si rifornisce
        }
    }
    return 1;
}

CMD:accettachiamata(playerid, params[])
{
    new otherid;
    if(sscanf(params, "u",otherid)) return SendClientMessage(playerid, COLOR_WHITE, "USO: /accettameccanico <playerid>");
    if(WorkAccepted[otherid] != -1) return SendClientMessage(playerid, COLOR_RED, "Hanno già preso la chiamata!");
    if(PlayerInfo[playerid][Job] == MECHANIC)
    {
        if(JobRequest[otherid] != PlayerInfo[playerid][Job]) return SendClientMessage(playerid, COLOR_RED, "L'utente non ha richiesto un meccanico!");
        new str[124],zone[MAX_ZONE_NAME];
        GetPlayer2DZone(playerid, zone, MAX_ZONE_NAME);
        format(str,sizeof(str), "Hai accettato la chiamata di %s. Posizione attuale: %s, Numero: %d",GetPlayerNameEx(otherid), zone); // Aggiungi il numero di telefono.
        SendClientMessage(playerid, COLOR_YELLOW, str);
        format(str,sizeof(str), "Il meccanico %s ha accettato la tua chiamata, sara' presto da te!",GetPlayerNameEx(playerid));
        SendClientMessage(otherid, COLOR_YELLOW, str);
        WorkAccepted[otherid] = otherid;
        JobRequest[otherid] = NO_JOB;
        return 1;
    }
    else if(PlayerInfo[playerid][Job] == TAXIST)
    {
        if(JobRequest[otherid] != PlayerInfo[playerid][Job]) return SendClientMessage(playerid, COLOR_RED, "L'utente non ha richiesto un taxi!");
        new str[124],zone[MAX_ZONE_NAME];
        GetPlayer2DZone(playerid, zone, MAX_ZONE_NAME);
        format(str,sizeof(str), "Hai accettato la chiamata di %s. Posizione attuale: %s, Numero: %d",GetPlayerNameEx(otherid), zone); // Aggiungi il numero di telefono.
        SendClientMessage(playerid, COLOR_YELLOW, str);
        format(str,sizeof(str), "Il tassista %s ha accettato la tua chiamata, sara' presto da te!",GetPlayerNameEx(playerid));
        SendClientMessage(otherid, COLOR_YELLOW, str);   
        WorkAccepted[otherid] = playerid;   
        JobRequest[otherid] = NO_JOB;
        return 1;       
    }
    return 1;
}

CMD:ach(playerid, params[]) { return cmd_accettachiamata(playerid, params); }

forward ResetWorkP(playerid,otherid);
public ResetWorkP(playerid, otherid)
{
    WorkProposed[otherid] = -1;
    DeletePVar(playerid, "MechPrice"); 
    DeletePVar(playerid, "Color1");
    DeletePVar(playerid, "Color2");
    new str[100];
    format(str,sizeof(str), "Non hai accettato in tempo l'offerta di %s, di conseguenza e' stata annullata",GetPlayerNameEx(playerid));
    SendClientMessage(otherid, COLOR_LIGHTBLUE, str);  
    format(str,sizeof(str), "%s non ha accettato in tempo l'offerta, di conseguenza e' stata annullata",GetPlayerNameEx(otherid));
    SendClientMessage(playerid, COLOR_LIGHTBLUE, str);   
    JobRequest[otherid] = NO_JOB;
    return 1;
}

SendJobDutyMessage(job, color, const string[])
{
    foreach(new i : Player)
    {
        if(PlayerInfo[i][Job] != job) continue;
        if(JobDuty[i] == 0) continue;
        SendClientMessage(i, color, string);
    }
    return 1;
}
//QUESTO QUI NON COPIARLO

stock GetPlayerNameEx(playerid)
{
    new str[24];
    GetPlayerName(playerid, str, 24);
    return str;
}

CMD:cash(playerid,params[])
{
    GivePlayerMoney(playerid, 50000);
    return 1;
}

CMD:chiamameccanico(playerid, params[])//Devi integrarlo nel /chiama 555
{
    new text[145];
    if(sscanf(params,"s[145]",text)) return 1;
    new string[156],zone[MAX_ZONE_NAME];
    GetPlayer2DZone(playerid, zone, MAX_ZONE_NAME);
    SendJobDutyMessage(MECHANIC, COLOR_LIGHTYELLOW, "|_____________[Centralino meccanico]_____________|");
    format(string,sizeof(string), "{E0E377}Richiedente:{FFFFFF} %s (ID: %d) {E0E377}Luogo: {FFFFFF}%s {E0E377}Numero: {FFFFFF}%d.",GetPlayerNameEx(playerid),playerid, zone); //Il numero di telefono
    SendJobDutyMessage(MECHANIC,-1, string);
    format(string,sizeof(string), "{E0E377}Testo:{FFFFFF} %s",text);
    SendJobDutyMessage(MECHANIC, -1, string);
    SendJobDutyMessage(MECHANIC, COLOR_LIGHTYELLOW, "|_______________________________________________|");
    format(string,sizeof(string), "Usa /(a)ccetta(ch)iamata %d per prendere questa chiamata dal centralino",playerid);
    SendJobDutyMessage(MECHANIC, COLOR_LIGHTYELLOW, string);
    SendClientMessage(playerid, COLOR_LIGHTYELLOW, "Hai chiamato un meccanico, attendi il suo arrivo");
    JobRequest[playerid] = MECHANIC;
    return 1;
}

CMD:chiamataxi(playerid, params[]) //Devi integrarlo nel /chiama 555
{
    new text[145];
    if(sscanf(params,"s[145]",text)) return 1;
    new string[156],zone[MAX_ZONE_NAME];
    GetPlayer2DZone(playerid, zone, MAX_ZONE_NAME);
    SendJobDutyMessage(TAXIST, COLOR_LIGHTYELLOW, "|_____________[Centralino taxi]_____________|");
    format(string,sizeof(string), "{E0E377}Richiedente:{FFFFFF} %s (ID: %d)  {E0E377}Luogo: {FFFFFF}%s {E0E377}Numero: {FFFFFF}%d.",GetPlayerNameEx(playerid),playerid, zone); //Il numero di telefono
    SendJobDutyMessage(TAXIST,-1, string);
    format(string,sizeof(string), "{E0E377}Testo:{FFFFFF} %s",text);
    SendJobDutyMessage(TAXIST, -1, string);
    SendJobDutyMessage(TAXIST, COLOR_LIGHTYELLOW, "|_______________________________________________|");
    format(string,sizeof(string), "Usa /(a)ccetta(ch)iamata %d per prendere questa chiamata dal centralino",playerid);
    SendJobDutyMessage(TAXIST, COLOR_LIGHTYELLOW, string);
    SendClientMessage(playerid, COLOR_LIGHTYELLOW, "Hai chiamato un taxi, attendi il suo arrivo");
    JobRequest[playerid] = TAXIST;
    return 1;
}

forward FixVeh(playerid, vid);
public FixVeh(playerid, vid)
{
    TogglePlayerControllable(playerid, 1);
    SetVehicleHealth(vid, 999.0);
    return 1; 
}