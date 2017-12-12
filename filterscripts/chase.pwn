// This is a comment
// Yes I do understand that

// uncomment the line below if you want to write a filterscript
// which one?

/*CREDITS: Wups - For help fixing bugs in middle stage
		   Stommpy - A friend with who we started this game and script
		   Thanks for people who helped me to test it:
		   Damien
		   Lakiuz*/
		   
#include <a_samp>
#define FOREACH_NO_BOTS
#include <foreach>
#define COLOR_GREEN 0x33AA33AA
#define COLOR_RED 0xAA3333AA
#define COLOR_WHITE 0xFFFFFFAA
#define DEFAULT_TIME 15
#define DIALOGID 15000

new
	bool:ChaseGame=false,
	bool:AbilityToJoin=false,
	bool:AutoFix=false,
	bool:CanDoIt=false,
	g_Players,
	Joined[MAX_PLAYERS],
	Noobie[MAX_PLAYERS],
	g_Chaser[MAX_PLAYERS],
	CoolDown[MAX_PLAYERS],
	g_ChaseStartedBy = -1,
	ChaseMode = 1,
	TillChase = 60,
	ChaseTime,
	Participants,
	Text:Info,
	Iterator:Dalyviai<MAX_PLAYERS>
	;

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Chase game FS by Awdrius Loaded");
	print("--------------------------------------\n");
	
	Info=TextDrawCreate(390,5,"Chaser Will be HERE!");
	TextDrawColor(Info,0xFFFFFFFF);
	TextDrawSetShadow(Info,0);
	TextDrawSetOutline(Info,1);
	TextDrawLetterSize(Info,0.5,2);
	TextDrawBackgroundColor(Info,0x00000040);
	TextDrawFont(Info,1);
 	for(new i;i<MAX_PLAYERS;i++)
	{
		if(IsPlayerConnected(i))
		{
			g_Players++;
			Iter_Add(Player,i);
		}
	}
	return 1;
}

public OnFilterScriptExit()
{
	CloseChase();
	TextDrawDestroy(Info);
	return 1;
}


public OnPlayerConnect(playerid)
{
	g_Players++;
	SetPlayerColor(playerid, 0x80808000);
	if(ChaseGame)
	{
		SendClientMessage(playerid, COLOR_GREEN, "[Chase] If you want to join chasing game type /join.");
		Noobie[playerid]=true;
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    Iter_Remove(Dalyviai,playerid);
	if(g_ChaseStartedBy == playerid && (ChaseGame || AbilityToJoin))
	{
	    SendClientMessageToAll(0x33AA33AA,"[Chase] Chase game is over, because the creator left!");
 		foreach(Player, i)
 		{
 		    Joined[i]=false;
			g_Chaser[i]=0;
			Iter_Remove(Dalyviai,i);
		}
		ChaseGame=false;
		AbilityToJoin=false;
	}
 	g_Players--;
	Joined[playerid]=false;
	Noobie[playerid]=false;
 	if(g_Players<2 && (ChaseGame || AbilityToJoin))
 	{
 		SendClientMessageToAll(0x33AA33AA,"[Chase] Chase game is over.");
 		foreach(Player, i)
 		{
 		    Joined[i]=false;
			g_Chaser[i]=0;
			Iter_Remove(Dalyviai,i);
		}
        AbilityToJoin=false;
        ChaseGame=false;
	}
	else
	{
		if(g_Chaser[playerid]==1)
		{
			new chaser;
			chaser=Iter_Random(Dalyviai);
    		while(Joined[chaser]!=1)
    		{
				chaser=Iter_Random(Dalyviai);
			}
			new name[MAX_PLAYER_NAME], msg[128];
			GetPlayerName(chaser,name,sizeof(name));
			TextDrawSetString(Text:Info, msg);
			TextDrawShowForAll(Text:Info);
			g_Chaser[chaser]=1;
			g_Chaser[playerid]=0;
		}
	}
	return 1;
}


public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/chase", cmdtext, true) == 0)
	{
	    if(!ChaseGame && !AbilityToJoin)
	    {
		    if(g_Players>1)
		    {
			    if(!IsPlayerAdmin(playerid))
			    {
			    	new a;
			    	foreach(Player, i)
			    	{
						if(IsPlayerAdmin(i)) a++;
					}
					CanDoIt = (a<1);
				}
				if(IsPlayerAdmin(playerid) || CanDoIt)
				{
				    new MainMenu[200];
					format(MainMenu,sizeof(MainMenu),"Mode [%s]\nGame Time [%imin]\nAutoFix[%s]\nStart the Chase", ((ChaseMode == 1) ? ("One Chaser") : ("Till Last Runner")), ((ChaseTime == 0) ? DEFAULT_TIME : (ChaseTime/60000)), ((AutoFix == false) ? ("OFF") : ("ON")));
					ShowPlayerDialog(playerid,DIALOGID,DIALOG_STYLE_LIST,"Chase game Menu",MainMenu,"Choose","Exit");
				}
				else SendClientMessage(playerid,COLOR_RED,"[Chase] There is an administrator online. Please ask him to do the chase!");
				return 1;
			}
			else SendClientMessage(playerid, COLOR_RED, "[Chase] There is only you playing at the moment");
		}
		else
		{
			if(IsPlayerAdmin(playerid) || (CanDoIt && g_ChaseStartedBy == playerid))
			{
			    new name[MAX_PLAYER_NAME],msg[64];
				GetPlayerName(playerid,name,sizeof(name));
				format(msg,sizeof(msg),"[Chase] %s stopped the chase game",name);
				SendClientMessageToAll(COLOR_RED,msg);
	   			CloseChase();
				KillTimer(CloseChase());
	  		}
			else SendClientMessage(playerid,COLOR_RED,"[Chase] The chase is already started!");
		}
		return 1;
	}

	if (strcmp("/join", cmdtext, true) == 0)
	{
	    if(!AbilityToJoin && !Noobie[playerid]) return SendClientMessage(playerid,COLOR_RED,"[Chase] Registration is closed!");
 		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid,COLOR_RED,"[Chase] You need to drive car by yourself!");
 		if(!Joined[playerid])
 		{
			if(Noobie[playerid])
			{
				SetPlayerColor(playerid, COLOR_WHITE);
				new name[MAX_PLAYER_NAME], msg[128];
				for(new i;i<MAX_PLAYERS;i++)
				{
				    if(g_Chaser[i]==1) GetPlayerName(i,name,sizeof(name));
	   			}
	   			if(ChaseMode==1)
	   			{
					format(msg,sizeof(msg),"Chaser - %s",name);
					TextDrawSetString(Text:Info, msg);
					TextDrawShowForPlayer(playerid,Text:Info);
				}
			}
			new msg[70];
		    Joined[playerid]=true;
		    Participants++;
		    Iter_Add(Dalyviai, playerid);
			format(msg,sizeof(msg),"[Chase] You have joined the chase game, %d secs left till Registration will be closed!",TillChase);
		    SendClientMessage(playerid,COLOR_GREEN,msg);
   		}
   		else if(Joined[playerid])
 		{
			if(Noobie[playerid])
			{
				SetPlayerColor(playerid,0x80808000);
			}
		    Joined[playerid]=false;
		    Participants--;
		    Iter_Remove(Dalyviai, playerid);
		    SendClientMessage(playerid,COLOR_GREEN,"[Chase] You have left the chase game!");
   		}
	    return 1;
 	}
	return 0;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOGID)
	{
		if(response)
		{
			if(listitem == 0)
			{
				ShowPlayerDialog(playerid,DIALOGID+1,DIALOG_STYLE_LIST,"Chase Mode","One chaser\nTill the last runner","Choose","Return");
				return 1;
			}
			else if(listitem == 1) 
			{
        		ShowPlayerDialog(playerid, DIALOGID+2, DIALOG_STYLE_INPUT , "Chase Time", "Enter time in minutes (min>1)", "OK", "Return");
				return 1;
			}
			else if(listitem == 2)
			{
        		ShowPlayerDialog(playerid, DIALOGID+3, DIALOG_STYLE_LIST , "AutoFix", "OFF\nON","Choose","Return");
				return 1;
			}
			else if(listitem == 3)
			{
				SendClientMessageToAll(COLOR_GREEN,"[Chase] If you want to join chasing game type /join.");
				g_ChaseStartedBy = playerid;
				AbilityToJoin=true;
				SetTimer("CloseReg",TillChase*1000,false);
				SetTimer("CountDown",1000,true);
				return 1;
			}
		}
		return 1;
	}
	if(dialogid == DIALOGID+1)
	{
		if(response)
		{
			if(listitem == 0) ChaseMode=1;
			else if(listitem == 1)
			{
				if(g_Players>2) ChaseMode=2;
				else
				{
					ChaseMode=1;
					SendClientMessage(playerid,COLOR_RED,"[Chase] 3 or more players is needed to run this mode.");
				}
			}
		}
		new MainMenu[200];
		format(MainMenu,sizeof(MainMenu),"Mode [%s]\nGame Time [%imin]\nAutoFix[%s]\nStart the Chase", ((ChaseMode == 1) ? ("One Chaser") : ("Till Last Runner")), ((ChaseTime == 0) ? DEFAULT_TIME : (ChaseTime/60000)), ((AutoFix == false) ? ("OFF") : ("ON")));
		ShowPlayerDialog(playerid,DIALOGID,DIALOG_STYLE_LIST,"Chase game Menu",MainMenu,"Choose","Exit");
		return 1;
	}
 	if(dialogid == DIALOGID+2)
	{
		if(response)
		{
  			if(IsNumeric(inputtext)) ChaseTime=strval(inputtext)*60000;
		}
		new MainMenu[200];
		format(MainMenu,sizeof(MainMenu),"Mode [%s]\nGame Time [%imin]\nAutoFix[%s]\nStart the Chase", ((ChaseMode == 1) ? ("One Chaser") : ("Till Last Runner")), ((ChaseTime == 0) ? DEFAULT_TIME : (ChaseTime/60000)), ((AutoFix == false) ? ("OFF") : ("ON")));
		ShowPlayerDialog(playerid,DIALOGID,DIALOG_STYLE_LIST,"Chase game Menu",MainMenu,"Choose","Exit");
	}
 	if(dialogid == DIALOGID+3)
	{
		if(response)
		{
			if(listitem == 0) AutoFix=false;
			else if(listitem == 1) AutoFix=true;
		}
		new MainMenu[200];
		format(MainMenu,sizeof(MainMenu),"Mode [%s]\nGame Time [%imin]\nAutoFix[%s]\nStart the Chase", ((ChaseMode == 1) ? ("One Chaser") : ("Till Last Runner")), ((ChaseTime == 0) ? DEFAULT_TIME : (ChaseTime/60000)), ((AutoFix == false) ? ("OFF") : ("ON")));
		ShowPlayerDialog(playerid,DIALOGID,DIALOG_STYLE_LIST,"Chase game Menu",MainMenu,"Choose","Exit");
	}
	return 1;
}

public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
	new Float:vehx, Float:vehy, Float:vehz;
	GetVehiclePos(vehicleid, vehx, vehy, vehz);
	if(AutoFix && ChaseGame) RepairVehicle(vehicleid);
	foreach(Player, i)
	{
		if (GetPlayerState(i) == PLAYER_STATE_DRIVER && playerid != i)
		{
			if(Joined[playerid] && Joined[i] && ChaseGame)
	  		{
				if(IsPlayerInRangeOfPoint(i, 10.0, vehx, vehy, vehz))
				{
					new vehicleid2 = GetPlayerVehicleID(i);
				    if(ChaseMode==1)
				    {
   						new params[14];
						new msg[128],runner[MAX_PLAYER_NAME];
						if(g_Chaser[playerid] == 1 && CoolDown[playerid]==0)
						{
							g_Chaser[i]=1;
							g_Chaser[playerid]=0;
							GetPlayerName(i,runner,sizeof(runner));
							SetPlayerColor(i, COLOR_RED);
							SetPlayerColor(playerid, COLOR_WHITE);
							GetVehicleParamsEx(vehicleid,params[0],params[1],params[2],params[3],params[4],params[5],params[6]);
							SetVehicleParamsEx(vehicleid,params[0],params[1],params[2],params[3],params[4],params[5],false);
							GetVehicleParamsEx(vehicleid2,params[0],params[1],params[2],params[3],params[4],params[5],params[6]);
							SetVehicleParamsEx(vehicleid2,params[0],params[1],params[2],params[3],params[4],params[5],true);
							TogglePlayerControllable(i,false);
							CoolDown[i]=5;
							SetTimerEx("Ready",5000,0,"i",i);
							SendClientMessage(i,COLOR_RED,"You will be freezed for 5secs!");
						}
						else if(g_Chaser[i] == 1 && CoolDown[i]==0)
						{
							g_Chaser[playerid]=1;
							g_Chaser[i]=0;
							GetPlayerName(playerid,runner,sizeof(runner));
							SetPlayerColor(playerid, COLOR_RED);
							SetPlayerColor(i, COLOR_WHITE);
							GetVehicleParamsEx(vehicleid,params[0],params[1],params[2],params[3],params[4],params[5],params[6]);
							SetVehicleParamsEx(vehicleid,params[0],params[1],params[2],params[3],params[4],params[5],true);
							GetVehicleParamsEx(vehicleid2,params[0],params[1],params[2],params[3],params[4],params[5],params[6]);
							SetVehicleParamsEx(vehicleid2,params[0],params[1],params[2],params[3],params[4],params[5],false);
							TogglePlayerControllable(playerid,false);
							CoolDown[playerid]=5;
							SetTimerEx("Ready",5000,0,"i",playerid);
							SendClientMessage(playerid,COLOR_RED,"You will be freezed for 5secs!");
						}
						format(msg,sizeof(msg),"Chaser - %s",runner);
						TextDrawSetString(Text:Info, msg);
						foreach(Player,y)
						{
							if(Joined[y]) TextDrawShowForPlayer(y,Text:Info);
						}
						break;
					}
	    			if(ChaseMode==2)
				    {
				        if(g_Chaser[i]==1 && g_Chaser[playerid]==1) break;
				    	new params[7];
						GetVehicleParamsEx(vehicleid,params[0],params[1],params[2],params[3],params[4],params[5],params[6]);
						SetVehicleParamsEx(vehicleid,params[0],params[1],params[2],params[3],params[4],params[5],true);
						GetVehicleParamsEx(vehicleid2,params[0],params[1],params[2],params[3],params[4],params[5],params[6]);
						SetVehicleParamsEx(vehicleid2,params[0],params[1],params[2],params[3],params[4],params[5],true);
						new msg[128],runner[MAX_PLAYER_NAME],chaser[MAX_PLAYER_NAME];
						Participants--;
						if(Participants<2)
						{
	 						foreach(Player,f)
							{
								if(g_Chaser[f]==0) GetPlayerName(f,runner,sizeof(runner));
	      					}
	      					format(msg,sizeof(msg),"The winner is %s",runner);
				    		SendClientMessageToAll(COLOR_GREEN, msg);
							CloseChase();
						}
						if(g_Chaser[playerid] == 1)
						{
							g_Chaser[i]=1;
							GetPlayerName(i,runner,sizeof(runner));
							GetPlayerName(playerid,chaser,sizeof(chaser));
							SetPlayerColor(i, COLOR_RED);
						}
						else if(g_Chaser[i] == 1)
						{
							g_Chaser[playerid]=1;
							GetPlayerName(playerid,runner,sizeof(runner));
							GetPlayerName(i,chaser,sizeof(chaser));
							SetPlayerColor(playerid, COLOR_RED);
						}
						format(msg,sizeof(msg),"[Chase] %s just caught %s.",chaser,runner);
						foreach(Player,y)
						{
						    if(Joined[y]) SendClientMessage(y, COLOR_GREEN, msg);
      					}
      					break;
					}
				}
			}
		}
	}
	return 1;
}

forward CloseReg();
public CloseReg()
{
	new Check;
	foreach(Player,i)
	{
		if(Joined[i]) Check++;
	}
	if(Check>1)
	{
	    if(ChaseMode==1) PrepareChase();
	    else
	    {
	        if(Check>2) PrepareChase();
	        else
			{
				CloseChase();
				SendClientMessageToAll(COLOR_RED,"[Chase] The Chase couldn't start, because there were too less participants");
			}
     	}
 	}
	else
	{
		CloseChase();
	    SendClientMessageToAll(COLOR_RED,"[Chase] The Chase couldn't start, because there were too less participants");
	}
	AbilityToJoin=false;
	return 1;
}

forward PrepareChase();
public PrepareChase()
{
	new chaser;
    chaser=Iter_Random(Dalyviai);
    while(Joined[chaser]!=1)
	{
		chaser=Iter_Random(Dalyviai);
	}
	foreach(Dalyviai, i)
	{
		new name[MAX_PLAYER_NAME], msg[60],chasem[100];
	    if(Joined[i])
	    {
	    	if(i != chaser) SetPlayerColor(i, COLOR_WHITE);
	    	else SetPlayerColor(i, COLOR_RED);
            GetPlayerName(chaser,name,sizeof(name));
	    	format(chasem,sizeof(chasem),"[Chase] Chase game started, and a chaser is %s",name);
			SendClientMessage(i, COLOR_GREEN, chasem);
			if(ChaseMode==1)
			{
				format(msg,sizeof(msg),"Chaser - %s",name);
				TextDrawSetString(Text:Info, msg);
				TextDrawShowForPlayer(i,Text:Info);
			}

		}
	}
	g_Chaser[chaser]=1;
	new params[7];
	new vehicleid = GetPlayerVehicleID(chaser);
	GetVehicleParamsEx(vehicleid,params[0],params[1],params[2],params[3],params[4],params[5],params[6]);
	SetVehicleParamsEx(vehicleid,params[0],params[1],params[2],params[3],params[4],params[5],true);
	ChaseGame=true;
	if(ChaseTime<1) SetTimer("CloseChase",DEFAULT_TIME*60000,false);
	else SetTimer("CloseChase",ChaseTime,false);
	return 1;
}

forward CloseChase();
public CloseChase()
{
	if(ChaseGame)
	{
		if(ChaseMode==1)
		{
			new name[MAX_PLAYER_NAME], msg[64];
			foreach(Player,f)
			{
				if(g_Chaser[f]==1) GetPlayerName(f,name,sizeof(name));
			}
			format(msg,sizeof(msg),"[Chase] The Last Chaser was %s",name);
			SendClientMessageToAll(COLOR_GREEN, msg);
		}
		ChaseMode=1;
		ChaseTime=0;
		Participants=0;
		AutoFix=false;
		for(new i;i<MAX_PLAYERS;i++)
		{
			if(Joined[i])
			{
				Iter_Remove(Dalyviai,i);
				Joined[i]=0;
				SetPlayerColor(i, 0x80808000);
				TextDrawHideForPlayer(i,Text:Info);
				if(g_Chaser[i]==1)
				{
					g_Chaser[i]=0;
					new vehicleid = GetPlayerVehicleID(i);
					new params[7];
					GetVehicleParamsEx(vehicleid,params[0],params[1],params[2],params[3],params[4],params[5],params[6]);
					SetVehicleParamsEx(vehicleid,params[0],params[1],params[2],params[3],params[4],params[5],false);
				}
			}
		}
	}
	ChaseGame=false;
}

forward CountDown();
public CountDown()
{
	new msg[64];
	TillChase--;
	if(TillChase % 30 == 0 && TillChase>1)
	{
		format(msg,sizeof(msg),"[Chase] %d secs left till the chase game will start.",TillChase);
		SendClientMessageToAll(COLOR_WHITE,msg);
	}
	else if(TillChase==10) 
	{
		format(msg,sizeof(msg),"[Chase] Only %d secs left till the chase game will start.",TillChase);
		SendClientMessageToAll(COLOR_WHITE,msg);
	}
	else if(TillChase==1) 
	{
		KillTimer(CountDown());
	}
}
	

forward Ready(playerid);
public Ready(playerid)
{
	TogglePlayerControllable(playerid,true);
	CoolDown[playerid]=0;
}

IsNumeric(const string[])
{
	for (new i = 0, j = strlen(string); i < j; i++)
	{
		if (string[i] > '9' || string[i] < '0') return 0;
	}
	return 1;
}