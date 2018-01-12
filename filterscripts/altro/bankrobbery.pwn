/*
This script/application is created by UnlimitedDeveloper from SAMP forums
and it's supposed to be shared only at SAMP forums, nowhere else!
If any copy of this script is found on another forum, it will be taken down.
*/
#include <a_samp>

#define COLOR_WHITE 0xFFFFFFAA

//Function forwarding
/*
Firstly we have to forward the functions that we are going
to use later in our sript.
*/
forward robtimer(playerid);
forward waittimer();

//Variables
/*
We are adding a NEW Variable so we can determine wether the bank
can or cannot be robber at a certain time.
*/
new robpossible;

public OnFilterScriptInit()
{
	/*
	When the filterscript executes itself it's setting the 'robpossible'
	variable to 1 which means that we can rob the bank right after we login.
	*/
	robpossible = 1;
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{

	if(strcmp(cmdtext, "/rapinabluebarry", true) == 0) {

		if(robpossible == 1) //If the bank can be robbed we continue below
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, 254.2738, -57.5924, 1.5703))
			{//Next thing we do is, we check if we are at the bank interior ^^
			    robpossible = 0; //Then we set the bank so it cannot be robbed
			    SetTimer("waittimer", 300000, false); //Normal Mode 5 minutes
			    /*We run the timer(5 minutes) for the function that is going to make the
			    bank available for robbing again
			    */
			    //SetTimer("waittimer", 65000, false); //Test Mode 65 seconds
			    SetTimer("robtimer", 60000, false);
			    /* We also run another timer(1 minute) for the function that is
			    actually going to give us the money and a user friendly message.
			    */
			    /*
			    Add a function that would notify the police.
			    */
			    SendClientMessage(playerid, COLOR_WHITE, "You are robbing the bank, the police has been notified!");
	            SendClientMessage(playerid, COLOR_WHITE, "You gotta stay 30 seconds in the bank in order to rob it!");
			 }
		} else {
		    SendClientMessage(playerid, COLOR_WHITE, "You can't rob the bank right now!");
		}
		
		return 1;
	}
		
	return 1;
}

//Functions
public robtimer(playerid)
{
	new string[128];//We are defining a new string for the formatted message that we are displaying later on.
    new cash = random(200000);
	GivePlayerMoney(playerid, cash);
	/*
    With the fuction above 'new cash = random(200000);
	GivePlayerMoney(playerid, cash);' we give the player
    a random amount of money from $0 - $200,000
    */
    //Here below we use the string we defined above to format the message itself and display it to the player.
	format(string, sizeof(string), "You have successfully robbed $%d from the bank!", cash);
	SendClientMessage(playerid, COLOR_WHITE, string);
}

public waittimer()
{
	robpossible = 1; //With this we make the bank available for robbery again, and we display a friendly message to all players.
	SendClientMessageToAll(COLOR_WHITE, "The bank is now available for robbery!");
}











