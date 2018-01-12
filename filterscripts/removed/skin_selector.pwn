/////////////////////////////////////////////////////////////////////////////////////////////////////////////    /////    ///         ///
	///	   ///	//           ///
	 ////	  //// ///    ///    //////
	    //    /////	    ///	   ///  ///
      //////	///  ///	   ///     ///   ///
#include <a_samp>
#include "../include/gl_common.inc"
#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
  		print("\n--------------------------------------");
		print(" [FILTERSCRIPT skin_selector]");
        print(" Skin Selector di Krakuski - CARICATO");
        print("--------------------------------------\n");
}

public OnFilterScriptExit()
{
  		print("\n--------------------------------------");
        print(" Skin Selector di Krakuski - DISATTIVATO");
        print("--------------------------------------\n");
}

#else

main()
{
  		print("\n--------------------------------------");
		print(" [FILTERSCRIPT skin_selector]");
        print(" Skin Selector di Krakuski - CARICATO");
        print("--------------------------------------\n");
}

#endif
#define COLOR_RED 0xAA3333AA
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_RED 0xAA3333AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_SPAWN 0xFF8C55FF
#define COLOR_LIGHTBLUE 0x6DC5F3FF
#define COLOR_ADMIN 0xFF0000FF
#define COLOR_SAY 0x2986CEFF
#define COLOR_SYSGREY 0xC6BEBDFF
#define COLOR_BLACK 0x000000FF
#define COLOR_JOIN 0x74E80099
#define COLOR_WARN 0xBE615099
#define COLOR_RACE 0x00BBBB99
#define COLOR_KRED 0xFF0000FF


public OnGameModeInit()
{
    return 1;
}

public OnGameModeExit()
{
    return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    return 1;
}

public OnPlayerConnect(playerid)
{
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

public OnVehicleSpawn(vehicleid)
{
    return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
    return 1;
}

public OnPlayerText(playerid, text[])
{
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(strcmp(cmdtext, "/skin 1", true) == 0)
    {
        SetPlayerSkin(playerid, 1);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 2", true) == 0)
    {
        SetPlayerSkin(playerid, 2);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 3", true) == 0)
    {
        SetPlayerSkin(playerid, 3);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 4", true) == 0)
    {
        SetPlayerSkin(playerid, 4);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 5", true) == 0)
    {
        SetPlayerSkin(playerid, 5);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 6", true) == 0)
    {
        SetPlayerSkin(playerid, 6);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 7", true) == 0)
    {
        SetPlayerSkin(playerid, 7);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 8", true) == 0)
    {
        SetPlayerSkin(playerid, 8);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 9", true) == 0)
    {
        SetPlayerSkin(playerid, 9);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 10", true) == 0)
    {
        SetPlayerSkin(playerid, 10);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 11", true) == 0)
    {
        SetPlayerSkin(playerid, 11);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 12", true) == 0)
    {
        SetPlayerSkin(playerid, 12);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 13", true) == 0)
    {
        SetPlayerSkin(playerid, 13);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 14", true) == 0)
    {
        SetPlayerSkin(playerid, 14);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 15", true) == 0)
    {
        SetPlayerSkin(playerid, 15);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 16", true) == 0)
    {
        SetPlayerSkin(playerid, 16);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 17", true) == 0)
    {
        SetPlayerSkin(playerid, 17);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 18", true) == 0)
    {
        SetPlayerSkin(playerid, 18);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 19", true) == 0)
    {
        SetPlayerSkin(playerid, 19);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 20", true) == 0)
    {
        SetPlayerSkin(playerid, 20);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 21", true) == 0)
    {
        SetPlayerSkin(playerid, 21);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 22", true) == 0)
    {
        SetPlayerSkin(playerid, 22);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 23", true) == 0)
    {
        SetPlayerSkin(playerid, 23);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 24", true) == 0)
    {
        SetPlayerSkin(playerid, 24);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 25", true) == 0)
    {
        SetPlayerSkin(playerid, 25);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 26", true) == 0)
    {
        SetPlayerSkin(playerid, 26);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 27", true) == 0)
    {
        SetPlayerSkin(playerid, 27);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 28", true) == 0)
    {
        SetPlayerSkin(playerid, 28);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 29", true) == 0)
    {
        SetPlayerSkin(playerid, 29);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 30", true) == 0)
    {
        SetPlayerSkin(playerid, 30);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 31", true) == 0)
    {
        SetPlayerSkin(playerid, 31);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 32", true) == 0)
    {
        SetPlayerSkin(playerid, 32);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 33", true) == 0)
    {
        SetPlayerSkin(playerid, 33);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 34", true) == 0)
    {
        SetPlayerSkin(playerid, 34);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 35", true) == 0)
    {
        SetPlayerSkin(playerid, 35);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 36", true) == 0)
    {
        SetPlayerSkin(playerid, 36);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 37", true) == 0)
    {
        SetPlayerSkin(playerid, 37);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 38", true) == 0)
    {
        SetPlayerSkin(playerid, 38);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 39", true) == 0)
    {
        SetPlayerSkin(playerid, 39);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 40", true) == 0)
    {
        SetPlayerSkin(playerid, 40);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 41", true) == 0)
    {
        SetPlayerSkin(playerid, 41);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 42", true) == 0)
    {
        SetPlayerSkin(playerid, 42);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 43", true) == 0)
    {
        SetPlayerSkin(playerid, 43);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 44", true) == 0)
    {
        SetPlayerSkin(playerid, 44);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 45", true) == 0)
    {
        SetPlayerSkin(playerid, 45);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 46", true) == 0)
    {
        SetPlayerSkin(playerid, 46);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 47", true) == 0)
    {
        SetPlayerSkin(playerid, 47);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 48", true) == 0)
    {
        SetPlayerSkin(playerid, 48);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 49", true) == 0)
    {
        SetPlayerSkin(playerid, 49);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 50", true) == 0)
    {
        SetPlayerSkin(playerid, 50);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 51", true) == 0)
    {
        SetPlayerSkin(playerid, 51);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 52", true) == 0)
    {
        SetPlayerSkin(playerid, 52);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 53", true) == 0)
    {
        SetPlayerSkin(playerid, 53);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 54", true) == 0)
    {
        SetPlayerSkin(playerid, 54);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 55", true) == 0)
    {
        SetPlayerSkin(playerid, 55);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 56", true) == 0)
    {
        SetPlayerSkin(playerid, 56);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 57", true) == 0)
    {
        SetPlayerSkin(playerid, 57);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 58", true) == 0)
    {
        SetPlayerSkin(playerid, 58);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 59", true) == 0)
    {
        SetPlayerSkin(playerid, 59);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 60", true) == 0)
    {
        SetPlayerSkin(playerid, 60);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 61", true) == 0)
    {
        SetPlayerSkin(playerid, 61);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 62", true) == 0)
    {
        SetPlayerSkin(playerid, 62);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 63", true) == 0)
    {
        SetPlayerSkin(playerid, 63);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 64", true) == 0)
    {
        SetPlayerSkin(playerid, 64);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 65", true) == 0)
    {
        SetPlayerSkin(playerid, 65);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 66", true) == 0)
    {
        SetPlayerSkin(playerid, 66);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 67", true) == 0)
    {
        SetPlayerSkin(playerid, 67);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 68", true) == 0)
    {
        SetPlayerSkin(playerid, 68);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 69", true) == 0)
    {
        SetPlayerSkin(playerid, 69);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 70", true) == 0)
    {
        SetPlayerSkin(playerid, 70);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 71", true) == 0)
    {
        SetPlayerSkin(playerid, 71);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 72", true) == 0)
    {
        SetPlayerSkin(playerid, 72);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 73", true) == 0)
    {
        SetPlayerSkin(playerid, 73);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 74", true) == 0)
    {
        SetPlayerSkin(playerid, 74);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 75", true) == 0)
    {
        SetPlayerSkin(playerid, 75);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 76", true) == 0)
    {
        SetPlayerSkin(playerid, 76);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 77", true) == 0)
    {
        SetPlayerSkin(playerid, 77);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 78", true) == 0)
    {
        SetPlayerSkin(playerid, 78);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 79", true) == 0)
    {
        SetPlayerSkin(playerid, 79);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 80", true) == 0)
    {
        SetPlayerSkin(playerid, 80);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 81", true) == 0)
    {
        SetPlayerSkin(playerid, 81);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 82", true) == 0)
    {
        SetPlayerSkin(playerid, 82);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 83", true) == 0)
    {
        SetPlayerSkin(playerid, 83);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 84", true) == 0)
    {
        SetPlayerSkin(playerid, 84);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 85", true) == 0)
    {
        SetPlayerSkin(playerid, 85);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 86", true) == 0)
    {
        SetPlayerSkin(playerid, 86);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 87", true) == 0)
    {
        SetPlayerSkin(playerid, 87);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 88", true) == 0)
    {
        SetPlayerSkin(playerid, 88);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 89", true) == 0)
    {
        SetPlayerSkin(playerid, 89);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 90", true) == 0)
    {
        SetPlayerSkin(playerid, 90);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 91", true) == 0)
    {
        SetPlayerSkin(playerid, 91);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 92", true) == 0)
    {
        SetPlayerSkin(playerid, 92);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 93", true) == 0)
    {
        SetPlayerSkin(playerid, 93);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 94", true) == 0)
    {
        SetPlayerSkin(playerid, 94);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 95", true) == 0)
    {
        SetPlayerSkin(playerid, 95);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 96", true) == 0)
    {
        SetPlayerSkin(playerid, 96);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 97", true) == 0)
    {
        SetPlayerSkin(playerid, 97);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 98", true) == 0)
    {
        SetPlayerSkin(playerid, 98);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 99", true) == 0)
    {
        SetPlayerSkin(playerid, 99);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 100", true) == 0)
    {
        SetPlayerSkin(playerid, 100);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 101", true) == 0)
    {
        SetPlayerSkin(playerid, 101);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 102", true) == 0)
    {
        SetPlayerSkin(playerid, 102);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 103", true) == 0)
    {
        SetPlayerSkin(playerid, 103);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 104", true) == 0)
    {
        SetPlayerSkin(playerid, 104);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 105", true) == 0)
    {
        SetPlayerSkin(playerid, 105);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 106", true) == 0)
    {
        SetPlayerSkin(playerid, 106);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 107", true) == 0)
    {
        SetPlayerSkin(playerid, 108);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 107", true) == 0)
    {
        SetPlayerSkin(playerid, 107);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 108", true) == 0)
    {
        SetPlayerSkin(playerid, 108);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 109", true) == 0)
    {
        SetPlayerSkin(playerid, 109);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 110", true) == 0)
    {
        SetPlayerSkin(playerid, 110);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 111", true) == 0)
    {
        SetPlayerSkin(playerid, 111);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 112", true) == 0)
    {
        SetPlayerSkin(playerid, 112);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 113", true) == 0)
    {
        SetPlayerSkin(playerid, 113);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 114", true) == 0)
    {
        SetPlayerSkin(playerid, 114);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 115", true) == 0)
    {
        SetPlayerSkin(playerid, 115);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 116", true) == 0)
    {
        SetPlayerSkin(playerid, 116);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 117", true) == 0)
    {
        SetPlayerSkin(playerid, 117);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 118", true) == 0)
    {
        SetPlayerSkin(playerid, 118);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 119", true) == 0)
    {
        SetPlayerSkin(playerid, 119);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 120", true) == 0)
    {
        SetPlayerSkin(playerid, 120);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 121", true) == 0)
    {
        SetPlayerSkin(playerid, 121);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 122", true) == 0)
    {
        SetPlayerSkin(playerid, 122);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 123", true) == 0)
    {
        SetPlayerSkin(playerid, 123);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 124", true) == 0)
    {
        SetPlayerSkin(playerid, 124);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 125", true) == 0)
    {
        SetPlayerSkin(playerid, 125);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 126", true) == 0)
    {
        SetPlayerSkin(playerid, 126);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 127", true) == 0)
    {
        SetPlayerSkin(playerid, 127);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 128", true) == 0)
    {
        SetPlayerSkin(playerid, 128);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 129", true) == 0)
    {
        SetPlayerSkin(playerid, 129);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 130", true) == 0)
    {
        SetPlayerSkin(playerid, 130);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 131", true) == 0)
    {
        SetPlayerSkin(playerid, 131);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 132", true) == 0)
    {
        SetPlayerSkin(playerid, 132);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 133", true) == 0)
    {
        SetPlayerSkin(playerid, 133);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 134", true) == 0)
    {
        SetPlayerSkin(playerid, 134);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 135", true) == 0)
    {
        SetPlayerSkin(playerid, 135);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 136", true) == 0)
    {
        SetPlayerSkin(playerid, 136);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 137", true) == 0)
    {
        SetPlayerSkin(playerid, 137);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 138", true) == 0)
    {
        SetPlayerSkin(playerid, 138);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 139", true) == 0)
    {
        SetPlayerSkin(playerid, 139);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 140", true) == 0)
    {
        SetPlayerSkin(playerid, 140);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 141", true) == 0)
    {
        SetPlayerSkin(playerid, 141);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 142", true) == 0)
    {
        SetPlayerSkin(playerid, 142);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 143", true) == 0)
    {
        SetPlayerSkin(playerid, 143);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 144", true) == 0)
    {
        SetPlayerSkin(playerid, 144);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 145", true) == 0)
    {
        SetPlayerSkin(playerid, 145);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 146", true) == 0)
    {
        SetPlayerSkin(playerid, 146);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 147", true) == 0)
    {
        SetPlayerSkin(playerid, 147);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 148", true) == 0)
    {
        SetPlayerSkin(playerid, 148);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 149", true) == 0)
    {
        SetPlayerSkin(playerid, 149);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 150", true) == 0)
    {
        SetPlayerSkin(playerid, 150);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 151", true) == 0)
    {
        SetPlayerSkin(playerid, 151);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 152", true) == 0)
    {
        SetPlayerSkin(playerid, 152);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 153", true) == 0)
    {
        SetPlayerSkin(playerid, 153);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 154", true) == 0)
    {
        SetPlayerSkin(playerid, 154);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 155", true) == 0)
    {
        SetPlayerSkin(playerid, 155);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 156", true) == 0)
    {
        SetPlayerSkin(playerid, 156);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 157", true) == 0)
    {
        SetPlayerSkin(playerid, 157);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 158", true) == 0)
    {
        SetPlayerSkin(playerid, 158);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 159", true) == 0)
    {
        SetPlayerSkin(playerid, 159);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 160", true) == 0)
    {
        SetPlayerSkin(playerid, 160);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 161", true) == 0)
    {
        SetPlayerSkin(playerid, 161);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 162", true) == 0)
    {
        SetPlayerSkin(playerid, 162);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 163", true) == 0)
    {
        SetPlayerSkin(playerid, 163);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 164", true) == 0)
    {
        SetPlayerSkin(playerid, 164);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 165", true) == 0)
    {
        SetPlayerSkin(playerid, 165);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 166", true) == 0)
    {
        SetPlayerSkin(playerid, 166);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 167", true) == 0)
    {
        SetPlayerSkin(playerid, 167);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 168", true) == 0)
    {
        SetPlayerSkin(playerid, 168);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 169", true) == 0)
    {
        SetPlayerSkin(playerid, 169);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 170", true) == 0)
    {
        SetPlayerSkin(playerid, 170);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 171", true) == 0)
    {
        SetPlayerSkin(playerid, 171);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 172", true) == 0)
    {
        SetPlayerSkin(playerid, 172);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 173", true) == 0)
    {
        SetPlayerSkin(playerid, 173);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 174", true) == 0)
    {
        SetPlayerSkin(playerid, 174);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 175", true) == 0)
    {
        SetPlayerSkin(playerid, 175);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 176", true) == 0)
    {
        SetPlayerSkin(playerid, 176);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 177", true) == 0)
    {
        SetPlayerSkin(playerid, 177);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 178", true) == 0)
    {
        SetPlayerSkin(playerid, 178);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 179", true) == 0)
    {
        SetPlayerSkin(playerid, 179);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 180", true) == 0)
    {
        SetPlayerSkin(playerid, 180);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 181", true) == 0)
    {
        SetPlayerSkin(playerid, 181);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 182", true) == 0)
    {
        SetPlayerSkin(playerid, 182);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 183", true) == 0)
    {
        SetPlayerSkin(playerid, 183);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 184", true) == 0)
    {
        SetPlayerSkin(playerid, 184);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 185", true) == 0)
    {
        SetPlayerSkin(playerid, 185);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 186", true) == 0)
    {
        SetPlayerSkin(playerid, 186);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 187", true) == 0)
    {
        SetPlayerSkin(playerid, 187);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 188", true) == 0)
    {
        SetPlayerSkin(playerid, 188);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 189", true) == 0)
    {
        SetPlayerSkin(playerid, 189);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 190", true) == 0)
    {
        SetPlayerSkin(playerid, 190);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 191", true) == 0)
    {
        SetPlayerSkin(playerid, 191);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 192", true) == 0)
    {
        SetPlayerSkin(playerid, 192);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 193", true) == 0)
    {
        SetPlayerSkin(playerid, 193);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 194", true) == 0)
    {
        SetPlayerSkin(playerid, 194);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 195", true) == 0)
    {
        SetPlayerSkin(playerid, 195);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 196", true) == 0)
    {
        SetPlayerSkin(playerid, 196);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 197", true) == 0)
    {
        SetPlayerSkin(playerid, 197);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 198", true) == 0)
    {
        SetPlayerSkin(playerid, 198);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 199", true) == 0)
    {
        SetPlayerSkin(playerid, 199);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 200", true) == 0)
    {
        SetPlayerSkin(playerid, 200);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 201", true) == 0)
    {
        SetPlayerSkin(playerid, 201);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 202", true) == 0)
    {
        SetPlayerSkin(playerid, 202);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 203", true) == 0)
    {
        SetPlayerSkin(playerid, 203);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 204", true) == 0)
    {
        SetPlayerSkin(playerid, 204);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 205", true) == 0)
    {
        SetPlayerSkin(playerid, 205);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 206", true) == 0)
    {
        SetPlayerSkin(playerid, 206);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 207", true) == 0)
    {
        SetPlayerSkin(playerid, 207);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 208", true) == 0)
    {
        SetPlayerSkin(playerid, 208);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 209", true) == 0)
    {
        SetPlayerSkin(playerid, 209);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 210", true) == 0)
    {
        SetPlayerSkin(playerid, 210);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 211", true) == 0)
    {
        SetPlayerSkin(playerid, 211);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 212", true) == 0)
    {
        SetPlayerSkin(playerid, 212);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 213", true) == 0)
    {
        SetPlayerSkin(playerid, 213);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 214", true) == 0)
    {
        SetPlayerSkin(playerid, 214);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 215", true) == 0)
    {
        SetPlayerSkin(playerid, 215);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 216", true) == 0)
    {
        SetPlayerSkin(playerid, 216);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 217", true) == 0)
    {
        SetPlayerSkin(playerid, 217);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 218", true) == 0)
    {
        SetPlayerSkin(playerid, 218);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 219", true) == 0)
    {
        SetPlayerSkin(playerid, 219);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 220", true) == 0)
    {
        SetPlayerSkin(playerid, 220);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 221", true) == 0)
    {
        SetPlayerSkin(playerid, 221);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 222", true) == 0)
    {
        SetPlayerSkin(playerid, 222);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 223", true) == 0)
    {
        SetPlayerSkin(playerid, 223);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 224", true) == 0)
    {
        SetPlayerSkin(playerid, 224);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 225", true) == 0)
    {
        SetPlayerSkin(playerid, 225);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 226", true) == 0)
    {
        SetPlayerSkin(playerid, 226);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 227", true) == 0)
    {
        SetPlayerSkin(playerid, 227);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 228", true) == 0)
    {
        SetPlayerSkin(playerid, 228);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 229", true) == 0)
    {
        SetPlayerSkin(playerid, 229);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 230", true) == 0)
    {
        SetPlayerSkin(playerid, 230);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 231", true) == 0)
    {
        SetPlayerSkin(playerid, 231);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 232", true) == 0)
    {
        SetPlayerSkin(playerid, 232);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 233", true) == 0)
    {
        SetPlayerSkin(playerid, 233);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 234", true) == 0)
    {
        SetPlayerSkin(playerid, 234);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 235", true) == 0)
    {
        SetPlayerSkin(playerid, 235);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 236", true) == 0)
    {
        SetPlayerSkin(playerid, 236);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 237", true) == 0)
    {
        SetPlayerSkin(playerid, 237);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 238", true) == 0)
    {
        SetPlayerSkin(playerid, 238);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 239", true) == 0)
    {
        SetPlayerSkin(playerid, 239);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 240", true) == 0)
    {
        SetPlayerSkin(playerid, 240);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 241", true) == 0)
    {
        SetPlayerSkin(playerid, 241);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 242", true) == 0)
    {
        SetPlayerSkin(playerid, 242);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 243", true) == 0)
    {
        SetPlayerSkin(playerid, 243);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 244", true) == 0)
    {
        SetPlayerSkin(playerid, 244);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 245", true) == 0)
    {
        SetPlayerSkin(playerid, 245);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 246", true) == 0)
    {
        SetPlayerSkin(playerid, 246);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 247", true) == 0)
    {
        SetPlayerSkin(playerid, 247);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 248", true) == 0)
    {
        SetPlayerSkin(playerid, 248);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 249", true) == 0)
    {
        SetPlayerSkin(playerid, 249);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 250", true) == 0)
    {
        SetPlayerSkin(playerid, 250);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 251", true) == 0)
    {
        SetPlayerSkin(playerid, 251);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 252", true) == 0)
    {
        SetPlayerSkin(playerid, 252);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 253", true) == 0)
    {
        SetPlayerSkin(playerid, 253);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 254", true) == 0)
    {
        SetPlayerSkin(playerid, 254);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 255", true) == 0)
    {
        SetPlayerSkin(playerid, 255);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 256", true) == 0)
    {
        SetPlayerSkin(playerid, 256);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 257", true) == 0)
    {
        SetPlayerSkin(playerid, 257);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 258", true) == 0)
    {
        SetPlayerSkin(playerid, 258);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 259", true) == 0)
    {
        SetPlayerSkin(playerid, 259);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 260", true) == 0)
    {
        SetPlayerSkin(playerid, 260);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 261", true) == 0)
    {
        SetPlayerSkin(playerid, 261);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 262", true) == 0)
    {
        SetPlayerSkin(playerid, 262);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 263", true) == 0)
    {
        SetPlayerSkin(playerid, 263);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 264", true) == 0)
    {
        SetPlayerSkin(playerid, 264);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 265", true) == 0)
    {
        SetPlayerSkin(playerid, 265);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 266", true) == 0)
    {
        SetPlayerSkin(playerid, 266);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 267", true) == 0)
    {
        SetPlayerSkin(playerid, 267);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 268", true) == 0)
    {
        SetPlayerSkin(playerid, 268);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 269", true) == 0)
    {
        SetPlayerSkin(playerid, 269);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 270", true) == 0)
    {
        SetPlayerSkin(playerid, 270);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 271", true) == 0)
    {
        SetPlayerSkin(playerid, 271);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 272", true) == 0)
    {
        SetPlayerSkin(playerid, 272);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 273", true) == 0)
    {
        SetPlayerSkin(playerid, 273);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 274", true) == 0)
    {
        SetPlayerSkin(playerid, 274);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 275", true) == 0)
    {
        SetPlayerSkin(playerid, 275);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 276", true) == 0)
    {
        SetPlayerSkin(playerid, 276);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 277", true) == 0)
    {
        SetPlayerSkin(playerid, 277);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 278", true) == 0)
    {
        SetPlayerSkin(playerid, 278);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 279", true) == 0)
    {
        SetPlayerSkin(playerid, 279);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 280", true) == 0)
    {
        SetPlayerSkin(playerid, 280);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 281", true) == 0)
    {
        SetPlayerSkin(playerid, 281);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 282", true) == 0)
    {
        SetPlayerSkin(playerid, 282);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 283", true) == 0)
    {
        SetPlayerSkin(playerid, 283);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 284", true) == 0)
    {
        SetPlayerSkin(playerid, 284);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 285", true) == 0)
    {
        SetPlayerSkin(playerid, 285);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 286", true) == 0)
    {
        SetPlayerSkin(playerid, 286);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 287", true) == 0)
    {
        SetPlayerSkin(playerid, 287);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 288", true) == 0)
    {
        SetPlayerSkin(playerid, 288);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 289", true) == 0)
    {
        SetPlayerSkin(playerid, 289);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 290", true) == 0)
    {
        SetPlayerSkin(playerid, 290);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 291", true) == 0)
    {
        SetPlayerSkin(playerid, 291);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 292", true) == 0)
    {
        SetPlayerSkin(playerid, 292);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 293", true) == 0)
    {
        SetPlayerSkin(playerid, 293);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 294", true) == 0)
    {
        SetPlayerSkin(playerid, 294);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 295", true) == 0)
    {
        SetPlayerSkin(playerid, 295);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 296", true) == 0)
    {
        SetPlayerSkin(playerid, 296);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 297", true) == 0)
    {
        SetPlayerSkin(playerid, 297);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 298", true) == 0)
    {
        SetPlayerSkin(playerid, 298);
        return 1;
    }
    if(strcmp(cmdtext, "/skin 299", true) == 0)
    {
        SetPlayerSkin(playerid, 299);
        return 1;
    }
    if (strcmp("/skin", cmdtext, true, 10) == 0)
	{
  		SendClientMessage (playerid, COLOR_GREY, "[USO:] /skin [1-299]");
		return 1;
	}
    return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
    return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
    return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
    return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
    return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
    return 1;
}

public OnRconCommand(cmd[])
{
    return 1;
}

public OnPlayerRequestSpawn(playerid)
{
    return 1;
}

public OnObjectMoved(objectid)
{
    return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
    return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
    return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
    return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
    return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
    return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
    return 1;
}

public OnPlayerExitedMenu(playerid)
{
    return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
    return 1;
}

public OnPlayerUpdate(playerid)
{
    return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
    return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
    return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
    return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
    return 1;
}
