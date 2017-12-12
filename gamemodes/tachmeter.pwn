

#include <a_samp>
#include <zcmd>
#include progress
#include colors
#include sscanf2

new PlayerText:TachTD[MAX_PLAYERS][12],
	PlayerBar:FuelBar[MAX_PLAYERS],
	TachTimer[MAX_PLAYERS];


public OnFilterScriptInit()
{
	// Don't use these lines if it's a filterscript
	SetGameModeText("CONTAKM Script");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
}


public OnFilterScriptExit()
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
	CreateTachometerTD(playerid);
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