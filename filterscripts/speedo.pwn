

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
	//AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
}


public OnFilterScriptExit()
{
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

