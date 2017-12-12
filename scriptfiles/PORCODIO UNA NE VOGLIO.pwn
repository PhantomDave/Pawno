/*
 * Project Name: PORCODIO UNA NE VOGLIO
 * Date: 03/05/2017 @ 19:57:02

 * The code below is to be used with the Progress Bar V2 include.
 *
*/

#include <a_samp>
#include <progress2>

new PlayerBar:Bar0[MAX_PLAYERS];

public OnPlayerConnect(playerid)
{
    Bar0[playerid] = CreatePlayerProgressBar(playerid, 591.000000, 359.000000, 25.500000, 4.699999, -640349697, 100.0000, 0);

    return 1;
}

public OnPlayerSpawn(playerid)
{
    ShowPlayerProgressBar(playerid, Bar0[playerid]);

    return 1;
}
