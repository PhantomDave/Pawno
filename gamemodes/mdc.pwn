#include <a_samp>
#include <a_mysql>

#define dcmd(%1,%2,%3) if ((strcmp(%3, "/%1", true, %2+1) == 0)&&(((%3[%2+1]==0)&&(dcmd_%1(playerid,"")))||((%3[%2+1]==32)&&(dcmd_%1(playerid,%3[%2+2]))))) return 1

main()
{
	print("\n----------------------------------");
	print("  MDC Script\n");
	print("----------------------------------\n");
}

public OnPlayerConnect(playerid)
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    dcmd(mdc, 3, cmdtext);
	return 0;
}

dcmd_mdc(playerid, params[])
{
	// POLICECHECK
	SendClientMessage(playerid, -1, "PORCODDIO");
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

public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

public OnGameModeInit()
{
	SetGameModeText("Bare Script");
	ShowPlayerMarkers(1);
	ShowNameTags(1);
	AllowAdminTeleport(1);

	AddPlayerClass(265,0.0,0.0,0.0,270.1425,0,0,0,0,-1,-1);

	return 1;
}
