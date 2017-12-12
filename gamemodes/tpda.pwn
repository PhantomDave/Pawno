#include <a_samp>
#include <zcmd>
		#include <colors>
		#include <zones>
		#include <foreach>
		#include <sscanf2>
		#include <progress>



#define EMB_GREEN "{32ff36}"
#define EMB_WHITE "{FFFFFF}"
#define GetPlayerCash(%0) GetPlayerMoney(%0)
#define GivePlayerCash(%0,%1) GivePlayerMoney(%0,%1)

new TpdaState[MAX_PLAYERS],
	TpdaVeh[MAX_PLAYERS],
	TPDARadio[MAX_PLAYERS],
	InConvoy[MAX_PLAYERS],
	ConvoyLeader[MAX_PLAYERS];


enum Tpda
{
	Float:PosX,
	Float:PosY,
	Float:PosZ
};

#define WORK_FOR_KM 35

new PetrolArray[][Tpda] = {
	{270.1480,1451.7457,11.5797},
	{-1047.0576,-652.9470,32.0078}
};

new CoolerArray[][Tpda] = {
	{1682.1061,755.8707,10.8203},
	{1733.1445,1068.3632,10.8203},
	{-54.9754,-224.7262,5.4297},
	{-575.6037,-494.8311,25.5234},
	{320.2767,1131.4310,9.1040},
	{-1736.5480,174.1025,3.5547}
};

new CoolerDrop[][Tpda] =  {
	{2184.7625,-2320.4216,13.5469},
	{2178.3730,-1922.9409,13.5146},
	{2793.9561,-2530.3455,13.6296},
	{-1575.5461,92.7164,3.5547}
};

new GasStations[][Tpda] = {
	{-95.0454,-1178.3851,3.1879},
	{1007.3806,-904.2232,43.2099},
	{1925.4382,-1793.2501,14.4109},
	{658.6213,-565.9858,17.3468},
	{1364.1198,479.5634,21.1893},
	{28.8511,-2636.1609,41.4341},
	{-2238.8928,-2570.0198,32.9345},
	{-2027.0134,171.4133,29.8557},
	{-1675.5333,426.2327,8.1958},
	{-2440.6675,952.4665,46.3145},
	{-1331.9309,2694.3105,51.0834},
	{-742.2529,2754.0962,48.2465},
	{636.9873,1687.4127,8.0107},	
	{68.4417,1210.5498,19.8318},
	{2108.2004,936.2983,10.8203},
	{1596.3096,2200.0610,10.8203},
	{2178.8140,2490.6082,10.8203},
	{2648.1479,1089.3859,10.8203}
};

new GravelArray[][Tpda] = {
	{612.5507,879.9114,-42.9609}
};

new GravelDropOff[][Tpda] = {
	{-2122.3049,-249.9937,35.320},
	{-1519.8563,-627.1719,14.1484},
	{-602.2237,-493.3111,25.5234},
	{-349.7073,-1060.7992,59.2557},
	{4.2079,-243.9757,5.4297},
	{156.4346,-322.5598,1.5781},
	{1094.5145,-1206.6895,17.8047},
	{2658.9248,-2130.3608,13.5469},
	{2617.9785,-2219.2429,13.5469},
	{2787.4785,-2361.8342,13.6328}
};

new SmallVanPick[][Tpda] = {
	{2060.9082,-2329.1384,13.5469},
	{2178.8320,-2296.7644,13.5469},
	{2790.1624,-2350.9063,13.6328}
};

new SmallVanDropOff[][Tpda] = {
	{1338.9150,-1764.3046,13.5340},
	{1802.7246,-1697.1555,13.5371},
	{2505.5583,-2426.7847,13.6198},
	{2314.5706,-1997.0861,13.5524},
	{2139.6733,-1868.6781,13.5469},
	{1910.0864,-1860.3322,13.5624}
};

new LogsPickup[][Tpda] = {
	{1201.5532,-2335.3926,15.0247}
};

new LogsDropOff[][Tpda] = {
	{-533.2451,-177.0102,79.0291},
	{-1967.3844,-2437.6492,30.6250},
	{-2502.2104,2513.8855,18.8335},
	{909.8450,11.8243,91.9137},
	{1493.0873,260.0698,19.1511}
};

new PlanePickups[][Tpda] = {
	{1601.6080,1623.2021,10.8203},
	{-1323.2731,-219.1115,14.1484},
	{2108.2297,-2433.4304,13.5469}
};

new PlaneDropOff[][Tpda] = {
	{1598.6963,1323.3887,10.8335},
	{-1409.3224,-605.7786,14.1484},
	{1727.1179,-2435.8843,13.5547}
};

Float:GetPointDistanceToPoint(Float:x1,Float:y1,Float:x2,Float:y2) // Se ti da un Warning mettilo in alto
{
	new Float:x, Float:y;
	x = x1-x2;
	y = y1-y2;
	return floatsqroot(x*x+y*y);
}

main()
{
	print("\n----------------------------------");
	print("  TPDA Script\n");
	print("----------------------------------\n");
}

public OnPlayerConnect(playerid)
{
	CreateTachometerTD(playerid);
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerInterior(playerid,0);
	TogglePlayerClock(playerid,0);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
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
	return 1;
}

public OnGameModeInit()
{
	SetGameModeText("Train Script");
	AddPlayerClass(265,1958.3783,1343.1572,15.3746,270.1425,0,0,0,0,-1,-1);
	return 1;
}

CMD:tpda(playerid, params[])
{
		//CHECK LAVORO TRASPORTATORE
	if(!IsPlayerInTPDAVehicle(playerid)) return SendClientMessage(playerid, COLOR_RED, "Non sei in veicolo valido per fare il trasportatore!");
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_RED, "Devi essere il guidatore del veicolo");
	if(TPDARadio[playerid] == 1) SendClientMessage(playerid, COLOR_LIGHTBLUE, "Hai la radio del veicolo accesa, parlerai automaticamente in essa");
	TPDAWork(playerid);
	return 1;
}

CMD:togtpdar(playerid, params[])
{
	//CHECK LAVORO TRASPORTATORE
	switch(TPDARadio[playerid])
	{
		case 0: TPDARadio[playerid] = 1, SendClientMessage(playerid, COLOR_LIGHTBLUE, "Hai acceso la radio del veicolo, parlerai automaticamente in essa");
		case 1: TPDARadio[playerid] = 0, SendClientMessage(playerid, COLOR_LIGHTBLUE, "Hai spento la radio del veicolo");
	}
	return 1;
}


CMD:annullatpda(playerid, params[])
{
	if(TpdaState[playerid] == 1 || TpdaState[playerid] == 2)
	{
		TpdaVeh[playerid] = 0;
		GivePlayerCash(playerid, -500); 
		TpdaState[playerid] = 0;
		DisablePlayerCheckpoint(playerid);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "Hai annullato la missione assegnata e di conseguenza hai pagato una penale pari a 500$");
		return 1;
	}
	return 1;
}

TPDAWork(playerid)
{
	if(TpdaState[playerid] != 0) return SendClientMessage(playerid, COLOR_RED, "Finisici il tuo attuale lavoro o usa /annullatpda (Dovrai pagare una penale salata)");
	TpdaVeh[playerid] = GetPlayerVehicleID(playerid);
	new str[145];
	switch(IsPlayerInTPDAVehicle(playerid))
	{
		case 1:
		{
			new trailerid = GetVehicleTrailer(GetPlayerVehicleID((playerid)));
			switch(IsAValidTPDATrailer(trailerid))
			{
				case 1:
				{
					new rand = random(sizeof(CoolerArray)),zone[MAX_ZONE_NAME];
					Get2DZoneName(CoolerArray[rand][PosX], CoolerArray[rand][PosY],zone,MAX_ZONE_NAME);
					format(str,sizeof(str), "SMS ricevuto dalla ditta trasporti: Il tuo prossimo carico ti attende a %s",zone);
					SendClientMessage(playerid, COLOR_LIGHTGREEN, str);
					SetPlayerCheckpoint(playerid, CoolerArray[rand][PosX], CoolerArray[rand][PosY], CoolerArray[rand][PosZ], 6.0);
					TpdaState[playerid] = 1;
					return 1;
				}
				case 2:
				{
					new rand = random(sizeof(GravelArray)),zone[MAX_ZONE_NAME];
					Get2DZoneName(GravelArray[rand][PosX], GravelArray[rand][PosY],zone,MAX_ZONE_NAME);
					format(str,sizeof(str), "SMS ricevuto dalla ditta trasporti: Il tuo prossimo carico ti attende a %s",zone);
					SendClientMessage(playerid, COLOR_LIGHTGREEN, str);
					SetPlayerCheckpoint(playerid, GravelArray[rand][PosX], GravelArray[rand][PosY], GravelArray[rand][PosZ], 6.0);
					TpdaState[playerid] = 1;
					return 1;
				}
				case 3:
				{
					new rand = random(sizeof(PetrolArray)),zone[MAX_ZONE_NAME];
					Get2DZoneName(CoolerArray[rand][PosX], CoolerArray[rand][PosY],zone,MAX_ZONE_NAME);
					format(str,sizeof(str), "SMS ricevuto dalla ditta trasporti: Il tuo prossimo carico ti attende a %s",zone);
					SendClientMessage(playerid, COLOR_LIGHTGREEN, str);
					SetPlayerCheckpoint(playerid, PetrolArray[rand][PosX], PetrolArray[rand][PosY], PetrolArray[rand][PosZ], 6.0);
					TpdaState[playerid] = 1;
					return 1;
				}	
			}
			return 1;

		}
		case 2:
		{
			new rand = random(sizeof(SmallVanPick)),zone[MAX_ZONE_NAME];
			Get2DZoneName(SmallVanPick[rand][PosX], SmallVanPick[rand][PosY],zone,MAX_ZONE_NAME);
			format(str,sizeof(str), "SMS ricevuto dalla ditta trasporti: Il tuo prossimo carico ti attende a %s",zone);
			SendClientMessage(playerid, COLOR_LIGHTGREEN, str);
			SetPlayerCheckpoint(playerid, SmallVanPick[rand][PosX], SmallVanPick[rand][PosY], SmallVanPick[rand][PosZ], 6.0);
			TpdaState[playerid] = 1;
			return 1;
		}
		case 3:
		{
			new rand = random(sizeof(LogsPickup)),zone[MAX_ZONE_NAME];
			Get2DZoneName(LogsPickup[rand][PosX], LogsPickup[rand][PosY],zone,MAX_ZONE_NAME);
			format(str,sizeof(str), "SMS ricevuto dalla ditta trasporti: Il tuo prossimo carico ti attende a %s",zone);
			SendClientMessage(playerid, COLOR_LIGHTGREEN, str);
			SetPlayerCheckpoint(playerid, LogsPickup[rand][PosX], LogsPickup[rand][PosY], LogsPickup[rand][PosZ], 6.0);
			TpdaState[playerid] = 1;
			return 1;			
		}
		case 4:
		{
			new zone[MAX_ZONE_NAME];
			Get2DZoneName(2223.9001,-1335.7738,zone,MAX_ZONE_NAME);
			format(str,sizeof(str), "SMS ricevuto dalla ditta trasporti: Il tuo prossimo carico ti attende a %s",zone);
			SendClientMessage(playerid, COLOR_LIGHTGREEN, str);
			SetPlayerCheckpoint(playerid, 2223.9001,-1335.7738,23.9844, 6.0);
			TpdaState[playerid] = 1;
			return 1;				
		}
		case 5:
		{
			new rand = random(sizeof(PlanePickups)),zone[MAX_ZONE_NAME];
			Get2DZoneName(PlanePickups[rand][PosX], PlanePickups[rand][PosY],zone,MAX_ZONE_NAME);
			format(str,sizeof(str), "SMS ricevuto dalla ditta trasporti: Il tuo prossimo carico ti attende a %s",zone);
			SendClientMessage(playerid, COLOR_LIGHTGREEN, str);
			SetPlayerCheckpoint(playerid, PlanePickups[rand][PosX], PlanePickups[rand][PosY], PlanePickups[rand][PosZ], 6.0);
			TpdaState[playerid] = 1;
			return 1;			
		}
	}
	return 1;
}

public OnPlayerText(playerid, text[])
{
	if(TPDARadio[playerid] == 1 && IsPlayerInTPDAVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new str[145];
		format(str, sizeof(str), "[TPDA] %s: %s",GetPlayerNameEx(playerid), text);
		SendTPDARadioMessage(IsPlayerInTPDAVehicle(playerid), COLOR_YELLOW, str);
		return 0;
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	if(TpdaState[playerid] == 1 && TpdaVeh[playerid] == GetPlayerVehicleID(playerid))
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_RED, "Devi essere il guidatore del veicolo");
		if(IsPlayerInTPDAVehicle(playerid) == 1)
		{
			if(IsAValidTPDATrailer(GetVehicleTrailer(GetPlayerVehicleID(playerid))) == 1)
			{
				TogglePlayerControllable(playerid, false);
				TpdaState[playerid] = 2;
				new rand = random(sizeof(CoolerDrop)),zone[MAX_ZONE_NAME],str[136];
				SetPlayerCheckpoint(playerid, CoolerDrop[rand][PosX], CoolerDrop[rand][PosY], CoolerDrop[rand][PosZ], 6.0);
				Get2DZoneName(CoolerDrop[rand][PosX], CoolerDrop[rand][PosY],zone,MAX_ZONE_NAME);
				format(str,sizeof(str), "Stanno caricando il tuo rimorchio con dei beni d'acquisto, devi portarli a %s",zone);
				SendClientMessage(playerid, COLOR_LIGHTBLUE, str);
				SetTimerEx("Unfreeze",4000,false,"d",playerid);
				new Float:X,Float:Y,Float:Z;
				GetPlayerPos(playerid, X, Y, Z);
				SetPVarFloat(playerid,"Distance",GetPointDistanceToPoint(CoolerDrop[rand][PosX], CoolerDrop[rand][PosY],X,Y)/100);
				return 1;
			}	
			else if(IsAValidTPDATrailer(GetVehicleTrailer(GetPlayerVehicleID(playerid))) == 2)
			{
				TogglePlayerControllable(playerid, false);
				TpdaState[playerid] = 2;
				new rand = random(sizeof(GravelDropOff)),zone[MAX_ZONE_NAME],str[136];
				SetPlayerCheckpoint(playerid, GravelDropOff[rand][PosX], GravelDropOff[rand][PosY], GravelDropOff[rand][PosZ], 6.0);
				Get2DZoneName(GravelDropOff[rand][PosX], GravelDropOff[rand][PosY],zone,MAX_ZONE_NAME);
				format(str,sizeof(str), "Stanno caricando il tuo rimorchio con del pietrisco, devi portarlo a %s",zone);
				SendClientMessage(playerid, COLOR_LIGHTBLUE, str);
				SetTimerEx("Unfreeze",4000,false,"d",playerid);
				new Float:X,Float:Y,Float:Z;
				GetPlayerPos(playerid, X, Y, Z);
				SetPVarFloat(playerid,"Distance",GetPointDistanceToPoint(GravelDropOff[rand][PosX], GravelDropOff[rand][PosY],X,Y)/100);
				return 1;
			}
			else if(IsAValidTPDATrailer(GetVehicleTrailer(GetPlayerVehicleID(playerid))) == 3)
			{
				TogglePlayerControllable(playerid, false);
				TpdaState[playerid] = 2;
				new rand = random(sizeof(GasStations)),zone[MAX_ZONE_NAME],str[136];
				SetPlayerCheckpoint(playerid, GasStations[rand][PosX], GasStations[rand][PosY], GasStations[rand][PosZ], 6.0);
				Get2DZoneName(GasStations[rand][PosX], GasStations[rand][PosY],zone,MAX_ZONE_NAME);
				format(str,sizeof(str), "Stanno caricando il tuo rimorchio con della benzina, devi portarla alla stazione di servizio di %s",zone);
				SendClientMessage(playerid, COLOR_LIGHTBLUE, str);
				SetTimerEx("Unfreeze",4000,false,"d",playerid);
				new Float:X,Float:Y,Float:Z;
				GetPlayerPos(playerid, X, Y, Z);
				SetPVarFloat(playerid,"Distance",GetPointDistanceToPoint(GasStations[rand][PosX], GasStations[rand][PosY],X,Y)/100);
				return 1;
			}
		}
		else if(IsPlayerInTPDAVehicle(playerid) == 2)
		{
			TogglePlayerControllable(playerid, false);
			TpdaState[playerid] = 2;
			new rand = random(sizeof(SmallVanDropOff)),zone[MAX_ZONE_NAME],str[136];
			SetPlayerCheckpoint(playerid, SmallVanDropOff[rand][PosX], SmallVanDropOff[rand][PosY], SmallVanDropOff[rand][PosZ], 6.0);
			Get2DZoneName(SmallVanDropOff[rand][PosX], SmallVanDropOff[rand][PosY],zone,MAX_ZONE_NAME);
			format(str,sizeof(str), "Stanno caricando il tuo con dei beni alimentari e componentistica, devi portarli a %s",zone);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, str);
			SetTimerEx("Unfreeze",4000,false,"d",playerid);
			new Float:X,Float:Y,Float:Z;
			GetPlayerPos(playerid, X, Y, Z);
			SetPVarFloat(playerid,"Distance",GetPointDistanceToPoint(SmallVanDropOff[rand][PosX], SmallVanDropOff[rand][PosY],X,Y)/100);	
			return 1;			
		}
		else if(IsPlayerInTPDAVehicle(playerid) == 3)
		{
			TogglePlayerControllable(playerid, false);
			TpdaState[playerid] = 2;
			new rand = random(sizeof(LogsDropOff)),zone[MAX_ZONE_NAME],str[136];
			SetPlayerCheckpoint(playerid, LogsDropOff[rand][PosX], LogsDropOff[rand][PosY], LogsDropOff[rand][PosZ], 6.0);
			Get2DZoneName(LogsDropOff[rand][PosX], LogsDropOff[rand][PosY],zone,MAX_ZONE_NAME);
			format(str,sizeof(str), "Stanno caricando il tuo veicolo con dei tronchi di legno, devi portarli a %s",zone);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, str);
			SetTimerEx("Unfreeze",4000,false,"d",playerid);
			new Float:X,Float:Y,Float:Z;
			GetPlayerPos(playerid, X, Y, Z);
			SetPVarFloat(playerid,"Distance",GetPointDistanceToPoint(LogsDropOff[rand][PosX], LogsDropOff[rand][PosY],X,Y)/100);
			return 1;					
		}
		else if(IsPlayerInTPDAVehicle(playerid) == 4)
		{
			TogglePlayerControllable(playerid, false);
			TpdaState[playerid] = 2;
			new zone[MAX_ZONE_NAME],str[136];
			SetPlayerCheckpoint(playerid, 939.5202,-1086.8651,24.2962, 6.0);
			Get2DZoneName(939.5202,-1086.8651,zone,MAX_ZONE_NAME);
			format(str,sizeof(str), "Il tuo veicolo sta venendo caricato con un cadavere, devi portarlo a %s",zone);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, str);
			SetTimerEx("Unfreeze",4000,false,"d",playerid);
			new Float:X,Float:Y,Float:Z;
			GetPlayerPos(playerid, X, Y, Z);
			SetPVarFloat(playerid,"Distance",GetPointDistanceToPoint(939.5202,-1086.8651,X,Y)/100);
			return 1;					
		}
		else if(IsPlayerInTPDAVehicle(playerid) == 5)
		{
			TogglePlayerControllable(playerid, false);
			TpdaState[playerid] = 2;
			new rand = random(sizeof(PlaneDropOff)),zone[MAX_ZONE_NAME],str[136];
			new Float:X,Float:Y,Float:Z;
			GetPlayerPos(playerid, X, Y, Z);
			Get2DZoneName(PlaneDropOff[rand][PosX], PlaneDropOff[rand][PosY],zone,MAX_ZONE_NAME);
			new Float:distance =  GetPointDistanceToPoint(PlaneDropOff[rand][PosX], PlaneDropOff[rand][PosY],X,Y)/100;
			if(distance < 15.0)
			{
				rand = random(sizeof(PlaneDropOff));
				Get2DZoneName(PlaneDropOff[rand][PosX], PlaneDropOff[rand][PosY],zone,MAX_ZONE_NAME);
			}
			SetPlayerCheckpoint(playerid, PlaneDropOff[rand][PosX], PlaneDropOff[rand][PosY], PlaneDropOff[rand][PosZ], 6.0);
			format(str,sizeof(str), "Stanno caricando la stiva del tuo aereo, devi portare il carico a %s",zone);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, str);
			SetTimerEx("Unfreeze",4000,false,"d",playerid);
			SetPVarFloat(playerid,"Distance",GetPointDistanceToPoint(PlaneDropOff[rand][PosX], PlaneDropOff[rand][PosY],X,Y)/100);
			return 1;				
		}
	}
	if(TpdaState[playerid] == 2 && TpdaVeh[playerid] == GetPlayerVehicleID(playerid))
	{
		if(IsPlayerInTPDAVehicle(playerid) == 1)
		{
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_RED, "Devi essere il guidatore del veicolo");
			if(IsAValidTPDATrailer(GetVehicleTrailer(GetPlayerVehicleID(playerid))) == 1)
			{
				TogglePlayerControllable(playerid, false);
				TpdaState[playerid] = 0;
				DisablePlayerCheckpoint(playerid);
				SetTimerEx("Unfreeze",4000,false,"d",playerid);	
				new Float:distance = GetPVarFloat(playerid, "Distance"),str[145];
				DeletePVar(playerid, "Distance");
				format(str,sizeof(str), ""EMB_GREEN"Tipo: "EMB_WHITE"Merce Depepribile\n"EMB_GREEN"Distanza: "EMB_WHITE"%.2f KM\n"EMB_GREEN"Guadagno: "EMB_WHITE"%d$",distance,300+ReturnPay(distance));
				ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Info trasporto", str, "Conferma", "");
				GivePlayerCash(playerid, 300+ReturnPay(distance));
				return 1;
			}
			else if(IsAValidTPDATrailer(GetVehicleTrailer(GetPlayerVehicleID(playerid))) == 2)
			{
				TogglePlayerControllable(playerid, false);
				TpdaState[playerid] = 0;
				DisablePlayerCheckpoint(playerid);
				SetTimerEx("Unfreeze",4000,false,"d",playerid);	
				new Float:distance = GetPVarFloat(playerid, "Distance"),str[145];
				DeletePVar(playerid, "Distance");
				format(str,sizeof(str), ""EMB_GREEN"Tipo: "EMB_WHITE"Pietrisco\n"EMB_GREEN"Distanza: "EMB_WHITE"%.2f KM\n"EMB_GREEN"Guadagno: "EMB_WHITE"%d$",distance,350+ReturnPay(distance));
				ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Info trasporto", str, "Conferma", "");
				GivePlayerCash(playerid, 350+ReturnPay(distance));
				return 1;
			}
			else if(IsAValidTPDATrailer(GetVehicleTrailer(GetPlayerVehicleID(playerid))) == 3)
			{
				TogglePlayerControllable(playerid, false);
				TpdaState[playerid] = 0;
				DisablePlayerCheckpoint(playerid);
				SetTimerEx("Unfreeze",4000,false,"d",playerid);	
				new Float:distance = GetPVarFloat(playerid, "Distance"),str[145];
				DeletePVar(playerid, "Distance");
				format(str,sizeof(str), ""EMB_GREEN"Tipo: "EMB_WHITE"Benzina\n"EMB_GREEN"Distanza: "EMB_WHITE"%.2f KM\n"EMB_GREEN"Guadagno: "EMB_WHITE"%d$",distance,450+ReturnPay(distance));
				ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Info trasporto", str, "Conferma", "");
				GivePlayerCash(playerid, 450+ReturnPay(distance));
				return 1;
			}
		}
		else if(IsPlayerInTPDAVehicle(playerid) == 2)
		{		
			TogglePlayerControllable(playerid, false);
			TpdaState[playerid] = 0;
			DisablePlayerCheckpoint(playerid);
			SetTimerEx("Unfreeze",4000,false,"d",playerid);	
			new Float:distance = GetPVarFloat(playerid, "Distance"),str[145];
			DeletePVar(playerid, "Distance");
			format(str,sizeof(str), ""EMB_GREEN"Tipo: "EMB_WHITE"Alimentari e componentistica\n"EMB_GREEN"Distanza: "EMB_WHITE"%.2f KM\n"EMB_GREEN"Guadagno: "EMB_WHITE"%d$",distance,50+ReturnPay(distance));
			ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Info trasporto", str, "Conferma", "");
			GivePlayerCash(playerid, 125+ReturnPay(distance));
			return 1;						
		}
		else if(IsPlayerInTPDAVehicle(playerid) == 3)
		{
			TogglePlayerControllable(playerid, false);
			TpdaState[playerid] = 0;
			DisablePlayerCheckpoint(playerid);
			SetTimerEx("Unfreeze",4000,false,"d",playerid);	
			new Float:distance = GetPVarFloat(playerid, "Distance"),str[145];
			DeletePVar(playerid, "Distance");
			format(str,sizeof(str), ""EMB_GREEN"Tipo: "EMB_WHITE"Tronchi di legno\n"EMB_GREEN"Distanza: "EMB_WHITE"%.2f KM\n"EMB_GREEN"Guadagno: "EMB_WHITE"%d$",distance,225+ReturnPay(distance));
			ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Info trasporto", str, "Conferma", "");
			GivePlayerCash(playerid, 225+ReturnPay(distance));
			return 1;	
		}
		else if(IsPlayerInTPDAVehicle(playerid) == 4)
		{
			TogglePlayerControllable(playerid, false);
			TpdaState[playerid] = 0;
			DisablePlayerCheckpoint(playerid);
			SetTimerEx("Unfreeze",4000,false,"d",playerid);	
			new Float:distance = GetPVarFloat(playerid, "Distance"),str[145];
			DeletePVar(playerid, "Distance");
			format(str,sizeof(str), ""EMB_GREEN"Tipo: "EMB_WHITE"Cadavere\n"EMB_GREEN"Distanza: "EMB_WHITE"%.2f KM\n"EMB_GREEN"Guadagno: "EMB_WHITE"%d$",distance,33);
			ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Info trasporto", str, "Conferma", "");
			GivePlayerCash(playerid, 33);
			return 1;	
		}
		else if(IsPlayerInTPDAVehicle(playerid) == 5)
		{
			TogglePlayerControllable(playerid, false);
			TpdaState[playerid] = 0;
			DisablePlayerCheckpoint(playerid);
			SetTimerEx("Unfreeze",4000,false,"d",playerid);	
			new Float:distance = GetPVarFloat(playerid, "Distance"),str[145];
			DeletePVar(playerid, "Distance");
			format(str,sizeof(str), ""EMB_GREEN"Tipo: "EMB_WHITE"Cargo\n"EMB_GREEN"Distanza: "EMB_WHITE"%.2f KM\n"EMB_GREEN"Guadagno: "EMB_WHITE"%d$",distance,500+ReturnPay(distance));
			ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Info trasporto", str, "Conferma", "");
			GivePlayerCash(playerid, 500+ReturnPay(distance));
			return 1;	
		}
	}
	return 1;
}


ReturnPay(Float:distance)
{
	new pay = 0;
	while(distance > 0.9)
	{
		pay += WORK_FOR_KM;
		distance -= 1.0;
	}
	return pay;
}

SendTPDARadioMessage(type, color, const string[])
{
	foreach(new i : Player)
	{
		if(IsPlayerInTPDAVehicle(i) == type)
		{
			if(TPDARadio[i] == 0) continue;
			SendClientMessage(i, color, string);
		}
	}
	return 1;
}

forward Unfreeze(playerid);
public Unfreeze(playerid)
{
	TogglePlayerControllable(playerid, true);
	return 1;
}

new PlayerText:TachTD[MAX_PLAYERS][12],
	PlayerBar:FuelBar[MAX_PLAYERS],
	TachTimer[MAX_PLAYERS];

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER)
	{
		ShowTachometerTD(playerid);
		TachTimer[playerid] = SetTimerEx("UpdateTach", 500, true, "d", playerid);
	}
	if(oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT)
	{
		HideTachometerTD(playerid);
		KillTimer(TachTimer[playerid]);
	}
	return 1;
}

stock GetPlayerSpeed(playerid)
{
    new Float:ST[4];
    if(IsPlayerInAnyVehicle(playerid))
    GetVehicleVelocity(GetPlayerVehicleID(playerid),ST[0],ST[1],ST[2]);
    else GetPlayerVelocity(playerid,ST[0],ST[1],ST[2]);
    ST[3] = floatsqroot(floatpower(floatabs(ST[0]), 2.0) + floatpower(floatabs(ST[1]), 2.0) + floatpower(floatabs(ST[2]), 2.0)) * 179.28625;
    return floatround(ST[3]);
}


IsAValidTPDATrailer(trailerid)
{
	switch(GetVehicleModel(trailerid))
	{
		case 435,591: return 1;
		case 450: return 2;
		case 584: return 3;
	}
	return 0;
}

IsPlayerInTPDAVehicle(playerid)
{
	if(!IsPlayerInAnyVehicle(playerid)) return 0;
	new vid = GetPlayerVehicleID(playerid), model = GetVehicleModel(vid);
	switch(model)
	{
		case 403,514,515: return 1;
		case 413,440,482,609,498,414,456,499: return 2;
		case 455,578: return 3;
		case 442: return 4;
		case 553,577,592: return 5;
		default: return 0;
	}
	return 0;
}



/// NOPE .OGG

GetPlayerNameEx(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

new	Float:Fuel[MAX_VEHICLES]; // NON TI SERVE PD

forward UpdateTach(playerid);
public UpdateTach(playerid)
{
	new vid = GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vid, engine, lights, alarm, doors, bonnet, boot, objective); // 
	if(doors == VEHICLE_PARAMS_OFF) // CAMBIALO CON LA VARIABILE DELLA GM
	{
		PlayerTextDrawColor(playerid, TachTD[playerid][0], 0x1EFF00FF);
		PlayerTextDrawShow(playerid, TachTD[playerid][0]);

	}
	else if(doors == VEHICLE_PARAMS_ON)
	{
		PlayerTextDrawColor(playerid, TachTD[playerid][0], COLOR_RED);
		PlayerTextDrawShow(playerid, TachTD[playerid][0]);
	}
	//SETTA IL CRUISE NON HO LE VARIABILI IO
	if(Fuel[vid] < 10.0) // CAMBIALO CON LA VARIABILE DELLA GM
	{
		PlayerTextDrawColor(playerid, TachTD[playerid][10], COLOR_YELLOW);
		PlayerTextDrawShow(playerid, TachTD[playerid][10]);
	}
	else
	{
		PlayerTextDrawColor(playerid, TachTD[playerid][10], COLOR_BLACK);
		PlayerTextDrawShow(playerid, TachTD[playerid][10]);		
	}
	new Float:vHP;
	GetVehicleHealth(vid, vHP);
	if(vHP <= 500.0)
	{	
		PlayerTextDrawColor(playerid, TachTD[playerid][11], COLOR_WHITE);
		PlayerTextDrawShow(playerid, TachTD[playerid][11]);
	}
	else
	{
		PlayerTextDrawColor(playerid, TachTD[playerid][11], COLOR_BLACK);
		PlayerTextDrawShow(playerid, TachTD[playerid][11]);		
	}
	new str[25];
	format(str,sizeof(str), "Velocita':_%d_Km/h",GetPlayerSpeed(playerid));
	PlayerTextDrawSetString(playerid, TachTD[playerid][2], str);
	SetPlayerProgressBarValue(playerid, FuelBar[playerid], floatround(Fuel[vid]));
	return 1;
}

ShowTachometerTD(playerid)
{
	for(new i = 0; i < 12; i++) { PlayerTextDrawShow(playerid, TachTD[playerid][i]); }
	ShowPlayerProgressBar(playerid, FuelBar[playerid]);
	return 1;
}

HideTachometerTD(playerid)
{
	for(new i = 0; i < 12; i++) { PlayerTextDrawHide(playerid, TachTD[playerid][i]); }
	HidePlayerProgressBar(playerid, FuelBar[playerid]);
	return 1;
}

CreateTachometerTD(playerid)
{

	TachTD[playerid][0] = CreatePlayerTextDraw(playerid, 557.100585, 367.756347, "hud:radar_fire");
	PlayerTextDrawLetterSize(playerid, TachTD[playerid][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TachTD[playerid][0], 9.000000, 10.000000);
	PlayerTextDrawAlignment(playerid, TachTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, TachTD[playerid][0], COLOR_BLACK);
	PlayerTextDrawSetShadow(playerid, TachTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, TachTD[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, TachTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, TachTD[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, TachTD[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, TachTD[playerid][0], 0);

	TachTD[playerid][1] = CreatePlayerTextDraw(playerid, 585.233154, 368.471679, "_");
	PlayerTextDrawLetterSize(playerid, TachTD[playerid][1], 0.139329, 1.064888);
	PlayerTextDrawTextSize(playerid, TachTD[playerid][1], 0.000000, 61.000000);
	PlayerTextDrawAlignment(playerid, TachTD[playerid][1], 2);
	PlayerTextDrawColor(playerid, TachTD[playerid][1], -1);
	PlayerTextDrawUseBox(playerid, TachTD[playerid][1], 1);
	PlayerTextDrawBoxColor(playerid, TachTD[playerid][1], 100);
	PlayerTextDrawSetShadow(playerid, TachTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, TachTD[playerid][1], 1);
	PlayerTextDrawBackgroundColor(playerid, TachTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, TachTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, TachTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, TachTD[playerid][1], 0);
	
	TachTD[playerid][2] = CreatePlayerTextDraw(playerid, 554.666564, 344.040588, "Velocita':~r~_999~w~_KM/H");
	PlayerTextDrawLetterSize(playerid, TachTD[playerid][2], 0.165998, 0.958962);
	PlayerTextDrawTextSize(playerid, TachTD[playerid][2], 615.700000, 0.000000);
	PlayerTextDrawAlignment(playerid, TachTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, TachTD[playerid][2], -1);
	PlayerTextDrawUseBox(playerid, TachTD[playerid][2], 1);
	PlayerTextDrawBoxColor(playerid, TachTD[playerid][2], 100);
	PlayerTextDrawSetShadow(playerid, TachTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, TachTD[playerid][2], 1);
	PlayerTextDrawBackgroundColor(playerid, TachTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, TachTD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, TachTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, TachTD[playerid][2], 0);

	TachTD[playerid][3] = CreatePlayerTextDraw(playerid, 570.697265, 367.756347, "hud:radar_catalinapink");
	PlayerTextDrawLetterSize(playerid, TachTD[playerid][3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TachTD[playerid][3], 9.000000, 10.000000);
	PlayerTextDrawAlignment(playerid, TachTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, TachTD[playerid][3], COLOR_BLACK);
	PlayerTextDrawSetShadow(playerid, TachTD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, TachTD[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, TachTD[playerid][3], 255);
	PlayerTextDrawFont(playerid, TachTD[playerid][3], 4);
	PlayerTextDrawSetProportional(playerid, TachTD[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, TachTD[playerid][3], 0);

	TachTD[playerid][4] = CreatePlayerTextDraw(playerid, 554.666564, 356.041320, "Carburante:");
	PlayerTextDrawLetterSize(playerid, TachTD[playerid][4], 0.165998, 1.018962);
	PlayerTextDrawTextSize(playerid, TachTD[playerid][4], 615.700000, 0.000000);
	PlayerTextDrawAlignment(playerid, TachTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, TachTD[playerid][4], -1);
	PlayerTextDrawUseBox(playerid, TachTD[playerid][4], 1);
	PlayerTextDrawBoxColor(playerid, TachTD[playerid][4], 100);
	PlayerTextDrawSetShadow(playerid, TachTD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, TachTD[playerid][4], 1);
	PlayerTextDrawBackgroundColor(playerid, TachTD[playerid][4], 255);
	PlayerTextDrawFont(playerid, TachTD[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, TachTD[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, TachTD[playerid][4], 0);

	TachTD[playerid][5] = CreatePlayerTextDraw(playerid, 585.333129, 381.272460, "6666666 Km");
	PlayerTextDrawLetterSize(playerid, TachTD[playerid][5], 0.139329, 1.064888);
	PlayerTextDrawTextSize(playerid, TachTD[playerid][5], 0.000000, 61.000000);
	PlayerTextDrawAlignment(playerid, TachTD[playerid][5], 2);
	PlayerTextDrawColor(playerid, TachTD[playerid][5], -1);
	PlayerTextDrawUseBox(playerid, TachTD[playerid][5], 1);
	PlayerTextDrawBoxColor(playerid, TachTD[playerid][5], 100);
	PlayerTextDrawSetShadow(playerid, TachTD[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, TachTD[playerid][5], 1);
	PlayerTextDrawBackgroundColor(playerid, TachTD[playerid][5], 255);
	PlayerTextDrawFont(playerid, TachTD[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, TachTD[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, TachTD[playerid][5], 0);

	TachTD[playerid][6] = CreatePlayerTextDraw(playerid, 552.698303, 394.125488, "box");
	PlayerTextDrawLetterSize(playerid, TachTD[playerid][6], 0.000000, -0.099999);
	PlayerTextDrawTextSize(playerid, TachTD[playerid][6], 617.500366, 0.000000);
	PlayerTextDrawAlignment(playerid, TachTD[playerid][6], 1);
	PlayerTextDrawColor(playerid, TachTD[playerid][6], -1);
	PlayerTextDrawUseBox(playerid, TachTD[playerid][6], 1);
	PlayerTextDrawBoxColor(playerid, TachTD[playerid][6], 255);
	PlayerTextDrawSetShadow(playerid, TachTD[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, TachTD[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, TachTD[playerid][6], 255);
	PlayerTextDrawFont(playerid, TachTD[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, TachTD[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, TachTD[playerid][6], 0);

	TachTD[playerid][7] = CreatePlayerTextDraw(playerid, 552.698303, 342.422332, "box");
	PlayerTextDrawLetterSize(playerid, TachTD[playerid][7], 0.000000, -0.099999);
	PlayerTextDrawTextSize(playerid, TachTD[playerid][7], 617.500366, 0.000000);
	PlayerTextDrawAlignment(playerid, TachTD[playerid][7], 1);
	PlayerTextDrawColor(playerid, TachTD[playerid][7], -1);
	PlayerTextDrawUseBox(playerid, TachTD[playerid][7], 1);
	PlayerTextDrawBoxColor(playerid, TachTD[playerid][7], 255);
	PlayerTextDrawSetShadow(playerid, TachTD[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, TachTD[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, TachTD[playerid][7], 255);
	PlayerTextDrawFont(playerid, TachTD[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, TachTD[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, TachTD[playerid][7], 0);

	TachTD[playerid][8] = CreatePlayerTextDraw(playerid, 552.798278, 394.125488, "box");
	PlayerTextDrawLetterSize(playerid, TachTD[playerid][8], 0.000000, -5.999998);
	PlayerTextDrawTextSize(playerid, TachTD[playerid][8], 552.099975, 0.000000);
	PlayerTextDrawAlignment(playerid, TachTD[playerid][8], 1);
	PlayerTextDrawColor(playerid, TachTD[playerid][8], -1);
	PlayerTextDrawUseBox(playerid, TachTD[playerid][8], 1);
	PlayerTextDrawBoxColor(playerid, TachTD[playerid][8], 255);
	PlayerTextDrawSetShadow(playerid, TachTD[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, TachTD[playerid][8], 0);
	PlayerTextDrawBackgroundColor(playerid, TachTD[playerid][8], 255);
	PlayerTextDrawFont(playerid, TachTD[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, TachTD[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, TachTD[playerid][8], 0);

	TachTD[playerid][9] = CreatePlayerTextDraw(playerid, 618.182312, 394.125488, "box");
	PlayerTextDrawLetterSize(playerid, TachTD[playerid][9], 0.000000, -5.999998);
	PlayerTextDrawTextSize(playerid, TachTD[playerid][9], 617.484008, 0.000000);
	PlayerTextDrawAlignment(playerid, TachTD[playerid][9], 1);
	PlayerTextDrawColor(playerid, TachTD[playerid][9], -1);
	PlayerTextDrawUseBox(playerid, TachTD[playerid][9], 1);
	PlayerTextDrawBoxColor(playerid, TachTD[playerid][9], 255);
	PlayerTextDrawSetShadow(playerid, TachTD[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, TachTD[playerid][9], 0);
	PlayerTextDrawBackgroundColor(playerid, TachTD[playerid][9], 255);
	PlayerTextDrawFont(playerid, TachTD[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid, TachTD[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid, TachTD[playerid][9], 0);

	TachTD[playerid][10] = CreatePlayerTextDraw(playerid, 586.116638, 367.356323, "hud:radar_centre");
	PlayerTextDrawLetterSize(playerid, TachTD[playerid][10], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TachTD[playerid][10], 9.000000, 10.000000);
	PlayerTextDrawAlignment(playerid, TachTD[playerid][10], 1);
	PlayerTextDrawColor(playerid, TachTD[playerid][10], COLOR_BLACK);
	PlayerTextDrawSetShadow(playerid, TachTD[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, TachTD[playerid][10], 0);
	PlayerTextDrawBackgroundColor(playerid, TachTD[playerid][10], 255);
	PlayerTextDrawFont(playerid, TachTD[playerid][10], 4);
	PlayerTextDrawSetProportional(playerid, TachTD[playerid][10], 0);
	PlayerTextDrawSetShadow(playerid, TachTD[playerid][10], 0);

	TachTD[playerid][11] = CreatePlayerTextDraw(playerid, 599.713317, 367.356323, "hud:radar_modgarage");
	PlayerTextDrawLetterSize(playerid, TachTD[playerid][11], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, TachTD[playerid][11], 9.000000, 10.000000);
	PlayerTextDrawAlignment(playerid, TachTD[playerid][11], 1);
	PlayerTextDrawColor(playerid, TachTD[playerid][11], COLOR_BLACK);
	PlayerTextDrawSetShadow(playerid, TachTD[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, TachTD[playerid][11], 0);
	PlayerTextDrawBackgroundColor(playerid, TachTD[playerid][11], 255);
	PlayerTextDrawFont(playerid, TachTD[playerid][11], 4);
	PlayerTextDrawSetProportional(playerid, TachTD[playerid][11], 0);
	PlayerTextDrawSetShadow(playerid, TachTD[playerid][11], 0);

	FuelBar[playerid] = CreatePlayerProgressBar(playerid, 591.000000, 359.000000, 25.500000, 4.699999, -640349697, 100.0000, 0);

}

CMD:fuel(playerid,params[])
{
	new Float:fuel;
	if(sscanf(params, "f",fuel)) return 1;
	Fuel[GetPlayerVehicleID(playerid)] = fuel;
	return 1;
}

CMD:lock(playerid,params[])
{
	new vid = GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vid, engine, lights, alarm, doors, bonnet, boot, objective);
	switch(doors)
	{
		case 0: SetVehicleParamsEx(vid, engine, lights, alarm, 1, bonnet, boot, objective);
		case 1: SetVehicleParamsEx(vid, engine, lights, alarm, 0, bonnet, boot, objective);
		default: SetVehicleParamsEx(vid, engine, lights, alarm, 1, bonnet, boot, objective);
	}	
	return 1;
}