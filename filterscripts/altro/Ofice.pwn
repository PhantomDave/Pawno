// This is a comment
// uncomment the line below if you want to write a filterscript
#define FILTERSCRIPT

#include <a_samp>

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

#else

main()
{
}

#endif

public OnGameModeInit()
{
	// Don't use these lines if it's a filterscript
	SetGameModeText("LSPD Training V1");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	return 1;
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
    RemoveBuildingForPlayer(playerid, 4990, 1646.1953, -2414.0703, 17.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 5010, 1646.1953, -2414.0703, 17.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 5011, 1874.2109, -2286.5313, 17.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 3672, 1921.6406, -2206.3906, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3672, 2030.0547, -2249.0234, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3672, 2030.0547, -2315.4297, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3672, 2030.0547, -2382.1406, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3672, 2112.9375, -2384.6172, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3672, 1889.6563, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3672, 1822.7344, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3672, 1682.7266, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3672, 1617.2813, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 5044, 1818.9141, -2543.6719, 13.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 3672, 1754.1719, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3769, 1961.4453, -2216.1719, 14.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 3744, 2061.5313, -2209.8125, 14.9766, 0.25);
	RemoveBuildingForPlayer(playerid, 3744, 2082.4063, -2269.6563, 14.9609, 0.25);
	RemoveBuildingForPlayer(playerid, 3744, 2082.4375, -2298.2266, 14.9609, 0.25);
	RemoveBuildingForPlayer(playerid, 3744, 2082.4063, -2370.0156, 14.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 3769, 2060.6875, -2305.9609, 14.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 3769, 2060.6875, -2371.8828, 14.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 1268, 1577.2344, -2668.4297, 16.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 3780, 1884.1719, -2541.3750, 14.2500, 0.25);
	RemoveBuildingForPlayer(playerid, 3780, 1652.3438, -2541.3750, 14.2500, 0.25);
	RemoveBuildingForPlayer(playerid, 3780, 1381.1172, -2541.3750, 14.2500, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1607.0156, -2439.9766, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 1617.2813, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1620.3594, -2476.8516, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1620.3594, -2511.0781, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1620.3594, -2576.2109, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1620.3594, -2610.4375, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1649.0625, -2641.4063, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 3665, 1652.3438, -2541.3750, 14.2500, 0.25);
	RemoveBuildingForPlayer(playerid, 3663, 1664.4531, -2439.8047, 14.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 1682.7266, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1686.4453, -2439.9766, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1705.0391, -2576.2109, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1705.0391, -2610.4375, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1705.0391, -2476.8516, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1705.0391, -2511.0781, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 1754.1719, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1766.7969, -2439.9766, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1789.7188, -2576.2109, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1789.7188, -2610.4375, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1789.7188, -2511.0781, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1789.7188, -2476.8516, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 1822.7344, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3663, 1832.4531, -2388.4375, 14.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1855.7969, -2641.4063, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1874.3984, -2576.2109, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1874.3984, -2610.4375, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 1889.6563, -2666.0078, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1922.2031, -2641.4063, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1874.3984, -2511.0781, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3665, 1884.1719, -2541.3750, 14.2500, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1874.3984, -2476.8516, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3663, 1882.2656, -2395.7813, 14.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1959.0781, -2610.4375, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1959.0781, -2576.2109, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1959.0781, -2476.8516, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1959.0781, -2511.0781, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 2003.4531, -2422.1719, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1980.9219, -2413.8750, 13.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1980.9219, -2355.2109, 13.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 2003.4531, -2350.7344, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 2030.0547, -2382.1406, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 2043.7578, -2576.2109, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 2043.7578, -2610.4375, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3664, 2042.7734, -2442.1875, 19.2813, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 2043.7578, -2476.8516, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 2043.7578, -2511.0781, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 2057.7344, -2402.9922, 12.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 3625, 2060.6875, -2371.8828, 14.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 2088.6094, -2422.1719, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2082.4063, -2370.0156, 14.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 2089.3047, -2359.7578, 12.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 2088.6094, -2350.7344, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 2128.4375, -2511.0781, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 2128.4375, -2576.2109, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 2131.0156, -2608.5234, 13.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 2128.4375, -2476.8516, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 2146.0156, -2409.3516, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 2112.9375, -2384.6172, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 5006, 1874.2109, -2286.5313, 17.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1899.4219, -2328.1406, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1899.4219, -2244.5078, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1983.8594, -2281.7109, 13.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 3664, 1960.6953, -2236.4297, 19.2813, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 2003.4531, -2281.3984, 18.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 5031, 2037.0469, -2313.5469, 18.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 2030.0547, -2315.4297, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 2030.0547, -2249.0234, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 2057.0547, -2315.4688, 12.7422, 0.25);
	RemoveBuildingForPlayer(playerid, 3625, 2060.6875, -2305.9609, 14.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 2057.5391, -2270.0703, 12.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2082.4063, -2269.6563, 14.9609, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2082.4375, -2298.2266, 14.9609, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 2089.3047, -2289.8906, 12.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 2089.3047, -2332.5547, 12.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 2089.7813, -2244.4922, 12.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 2088.6094, -2281.3984, 18.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 3629, 1921.6406, -2206.3906, 18.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1949.3438, -2227.5156, 13.6563, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1944.0625, -2227.5156, 13.6563, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1951.0313, -2207.7031, 18.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1954.6172, -2227.4844, 13.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1965.1719, -2227.4141, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1959.8984, -2227.4453, 13.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 3625, 1961.4453, -2216.1719, 14.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1975.7266, -2227.4141, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1970.4453, -2227.4141, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1979.6797, -2207.8438, 18.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1981.0000, -2227.4141, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1996.8281, -2227.3828, 13.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1991.5547, -2227.4141, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1986.2813, -2227.4141, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 1983.8047, -2224.1641, 12.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 2002.1094, -2227.3438, 13.8281, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 2018.0313, -2224.1641, 12.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 2010.3984, -2207.6172, 18.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 2042.4766, -2207.7031, 18.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 2055.0547, -2224.3828, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 2055.0547, -2219.1094, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 2056.8281, -2224.1641, 12.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 2054.9844, -2213.7891, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 2054.9219, -2208.4609, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 2054.9219, -2203.1875, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2061.5313, -2209.8125, 14.9766, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 2054.9297, -2181.3594, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 2054.9297, -2186.6328, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 3665, 1381.1172, -2541.3750, 14.2500, 0.25);
	RemoveBuildingForPlayer(playerid, 3664, 1388.0078, -2593.0000, 19.2813, 0.25);
	RemoveBuildingForPlayer(playerid, 3664, 1388.0078, -2494.2656, 19.2813, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1471.4844, -2576.2109, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1471.4844, -2610.4375, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1471.4844, -2511.0781, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1471.4844, -2476.8516, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1525.0078, -2439.9766, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1535.6797, -2476.8516, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1535.6797, -2511.0781, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1535.6797, -2576.2109, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3666, 1535.6797, -2610.4375, 12.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 5032, 1567.7109, -2543.6328, 13.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 1259, 1577.2344, -2668.4297, 16.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 3663, 1580.0938, -2433.8281, 14.5703, 0.25);

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
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		// Do something here
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
