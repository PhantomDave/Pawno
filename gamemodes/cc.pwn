#include <a_samp>
#include <a_mysql>
#include <colors>
#include <easyDialog>

#define MYSQL_HOST "localhost"
#define MYSQL_USER "root"
#define MYSQL_DB "copchase"
#define MYSQL_PSW ""


#define MAX_LOGIN_ATTEMPTS 3
#define ANTICHEAT_NAME "Antocs"
new MySQL:mysql;

enum pInfo
{
	pPsw[64],
	pSalt[16],
	pAdmin,
	pAttempts
}

new PlayerInfo[MAX_PLAYERS][pInfo];

main()
{
	print("\n----------------------------------");
	print(" Blank Gamemode by your name here");
	print("----------------------------------\n");
}


public OnGameModeInit()
{
	mysql = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PSW,MYSQL_DB);
	if(mysql) print("[MySQL] Connection Successful"); else print("[MySQL] Connection Failed");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
}


public OnGameModeExit()
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
	new query[64];
	mysql_format(mysql,query, sizeof(query),  "SELECT Password, Salt FROM Players WHERE Name = '%e'", GetPlayerNameEx(playerid));
	mysql_tquery(mysql, query,"OnPlayerLoad", "d", playerid);
	return 1;
}

Dialog:Login(playerid, response, listitem, inputtext[])
{
	if(!response) KickPlayer(playerid, ANTICHEAT_NAME, "Login aborted");
	if(strlen(inputtext) < 1 && strlen(inputtext) > 20) return Dialog_Show(playerid, Login, DIALOG_STYLE_PASSWORD, "Login","Your Password must be longer than 1 character and longer than 20","Accept","Quit");
	new string[145],hashpass[65];
	SHA256_PassHash(inputtext, PlayerInfo[playerid][pSalt], hashpass, sizeof(hashpass));
	if(strcmp(PlayerInfo[playerid][pPsw],hashpass))
	{
		if(PlayerInfo[playerid][pAttempts] >= MAX_LOGIN_ATTEMPTS) return KickPlayer(playerid, ANTICHEAT_NAME, "Login failed");
		else
		{
			PlayerInfo[playerid][pAttempts]++;
			format(string,sizeof(string), "Wrong password.\nPlease insert the correct password below.\nAttempt %d/%d",PlayerInfo[playerid][pAttempts],MAX_LOGIN_ATTEMPTS);
			Dialog_Show(playerid, Login, DIALOG_STYLE_PASSWORD, "Login", string, "Login", "Quit");
			return 1;
		}
	}
	else
	{	
		new query[80];
		mysql_format(mysql, query, sizeof(query), "SELECT * FROM Players WHERE Name = '%e'", GetPlayerNameEx(playerid));
		mysql_tquery(mysql, query, "LoadPlayerData", "d", playerid);
		SendClientMessage(playerid, COLOR_GREEN, "Login Successful, loading your data.");
		return 1;
	}
}

Dialog:Register(playerid, response, listitem, inputtext[])
{
	if(!response) KickPlayer(playerid, ANTICHEAT_NAME, "Registration aborted");
	if(strlen(inputtext) < 1 && strlen(inputtext) > 20) return Dialog_Show(playerid, Register, DIALOG_STYLE_PASSWORD, "Register","Your Password must be longer than 1 character and longer than 20","Accept","Quit");
	new salt[11],hashpass[65],query[156];
	for(new i = 0; i < 10; i++)
	{
		salt[i] = random(79) + 47;
	}
	salt[10] = 0;
	SHA256_PassHash(inputtext, salt, hashpass, 65);
	mysql_format(mysql, query, sizeof(query), "INSERT INTO Players (Name, Password, Salt) VALUES(%e,%e,%e)",GetPlayerNameEx(playerid), hashpass, salt);
	mysql_tquery(mysql, query);
	Dialog_Show(playerid, Login, DIALOG_STYLE_PASSWORD, "Login", "Your registration was Successful\nInsert your password down below to login", "Login","Quit");
	return 1;
}

forward LoadPlayerData(playerid);
public LoadPlayerData(playerid)
{
	return 1;
}


KickPlayer(playerid, kicker[], reason[])
{
	new kickmsg[145];
	format(kickmsg,sizeof(kickmsg), "You were kicked by %s. Reason: %s.",kicker, reason);
	SendClientMessage(playerid, COLOR_LIGHTRED, kickmsg);
	SetTimerEx("KickP", 1000, 0, "d", playerid);
	return 1;
}

forward KickP(playerid);
public KickP(playerid) { return Kick(playerid); }

forward OnPlayerLoad(playerid);
public OnPlayerLoad(playerid)
{
	new str[90];
	if(cache_num_rows())
	{
		format(str,sizeof(str), "Welcome back %s, please insert your password to log in",GetPlayerNameEx(playerid));
		Dialog_Show(playerid, Login, DIALOG_STYLE_PASSWORD, "Login", str, "Accept", "Exit(Kick)");
		cache_get_value_index(0, 0, PlayerInfo[playerid][pPsw]);
		cache_get_value_index(0, 1, PlayerInfo[playerid][pSalt]);
	}
	else
	{
		format(str,sizeof(str), "Welcome %s, please insert your password to register",GetPlayerNameEx(playerid));
		Dialog_Show(playerid, Register, DIALOG_STYLE_PASSWORD, "Register", str, "Accept", "Exit(Kick)");		
	}
	return 1;
}

GetPlayerNameEx(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}