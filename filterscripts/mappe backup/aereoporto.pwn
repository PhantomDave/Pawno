#include <a_samp>
#include <core>
#include <float>


public OnFilterScriptInit()
{
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnGameModeInit()
{
	SetGameModeText("LSPD Training V1");
	AddPlayerClass(0, 1958.3781, 1343.1572, 15.3746, 269.1423, 0, 0, 0, 0, 0, 0);
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3781, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3781, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3781, 1343.1572, 15.3746, 2);
	return 1;
}

public OnPlayerConnect(playerid)
{
	RemoveBuildingForPlayer(playerid, 3699, 1159363264, 3300033600, 1106673664, 1048576000);
	RemoveBuildingForPlayer(playerid, 3699, 1159441184, 3299916992, 1106673664, 1048576000);
	RemoveBuildingForPlayer(playerid, 3699, 1159363264, 3299916992, 1106673664, 1048576000);
	RemoveBuildingForPlayer(playerid, 3699, 1159441184, 3299764352, 1106673664, 1048576000);
	RemoveBuildingForPlayer(playerid, 3699, 1159363264, 3299764352, 1106673664, 1048576000);
	RemoveBuildingForPlayer(playerid, 3699, 1159441184, 3299637888, 1106673664, 1048576000);
	RemoveBuildingForPlayer(playerid, 3699, 1159363264, 3299637888, 1106673664, 1048576000);
	RemoveBuildingForPlayer(playerid, 3699, 1159441184, 3299497216, 1106673664, 1048576000);
	RemoveBuildingForPlayer(playerid, 3699, 1159363264, 3299497216, 1106673664, 1048576000);
	RemoveBuildingForPlayer(playerid, 3698, 1159363264, 3300033600, 1106673664, 1048576000);
	RemoveBuildingForPlayer(playerid, 3698, 1159363264, 3299916992, 1106673664, 1048576000);
	RemoveBuildingForPlayer(playerid, 3698, 1159363264, 3299764352, 1106673664, 1048576000);
	RemoveBuildingForPlayer(playerid, 3698, 1159363264, 3299637888, 1106673664, 1048576000);
	RemoveBuildingForPlayer(playerid, 3698, 1159441184, 3299916992, 1106673664, 1048576000);
	RemoveBuildingForPlayer(playerid, 3698, 1159441184, 3299764352, 1106673664, 1048576000);
	RemoveBuildingForPlayer(playerid, 3698, 1159441184, 3299637888, 1106673664, 1048576000);
	RemoveBuildingForPlayer(playerid, 3698, 1159363264, 3299497216, 1106673664, 1048576000);
	RemoveBuildingForPlayer(playerid, 3698, 1159441184, 3299497216, 1106673664, 1048576000);
	RemoveBuildingForPlayer(playerid, 4990, 1317641100.5, 3463160955.5, 1317215968.0547, 1316618240);
	RemoveBuildingForPlayer(playerid, 5010, 1317641100.5, 3463160955.5, 1317215968.0547, 1316618240);
	RemoveBuildingForPlayer(playerid, 5011, 1317655693.5, 3463169118, 1317215968.0547, 1316618240);
	RemoveBuildingForPlayer(playerid, 3672, 1317658729, 3463174247, 1317219871.9453, 1316618240);
	RemoveBuildingForPlayer(playerid, 3672, 1317665667.5, 3463171518.5, 1317219871.9453, 1316618240);
	RemoveBuildingForPlayer(playerid, 3672, 1317665667.5, 3463167268.5, 1317219871.9453, 1316618240);
	RemoveBuildingForPlayer(playerid, 3672, 1317665667.5, 3463162999, 1317219871.9453, 1316618240);
	RemoveBuildingForPlayer(playerid, 3672, 1317668894, 3463162840.5, 1317219871.9453, 1316618240);
	RemoveBuildingForPlayer(playerid, 3672, 1317656682, 3463144831.5, 1317219871.9453, 1316618240);
	RemoveBuildingForPlayer(playerid, 3672, 1317652399, 3463144831.5, 1317219871.9453, 1316618240);
	RemoveBuildingForPlayer(playerid, 3672, 1317643438.5, 3463144831.5, 1317219871.9453, 1316618240);
	RemoveBuildingForPlayer(playerid, 3672, 1317639250, 3463144831.5, 1317219871.9453, 1316618240);
	RemoveBuildingForPlayer(playerid, 5044, 1317652154.5, 3463152661, 1317187328.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3672, 1317648011, 3463144831.5, 1317219871.9453, 1316618240);
	RemoveBuildingForPlayer(playerid, 3769, 1317661276.5, 3463173621, 1317199744.2031, 1316618240);
	RemoveBuildingForPlayer(playerid, 3744, 1317667249, 3463174028, 1317199680.3047, 1316618240);
	RemoveBuildingForPlayer(playerid, 3744, 1317667917, 3463170198, 1317199551.6953, 1316618240);
	RemoveBuildingForPlayer(playerid, 3744, 1317667918, 3463168369.5, 1317199551.6953, 1316618240);
	RemoveBuildingForPlayer(playerid, 3744, 1317667917, 3463163775, 1317197439.7969, 1316618240);
	RemoveBuildingForPlayer(playerid, 3769, 1317667222, 3463167874.5, 1317199744.2031, 1316618240);
	RemoveBuildingForPlayer(playerid, 3769, 1317667222, 3463163655.5, 1317199744.2031, 1316618240);
	RemoveBuildingForPlayer(playerid, 1268, 1317636687, 3463144676.5, 1317209183.8438, 1316618240);
	RemoveBuildingForPlayer(playerid, 3780, 1317656331, 3463152808, 1317193728, 1316618240);
	RemoveBuildingForPlayer(playerid, 3780, 1317641494, 3463152808, 1317193728, 1316618240);
	RemoveBuildingForPlayer(playerid, 3780, 1317624135.5, 3463152808, 1317193728, 1316618240);
	RemoveBuildingForPlayer(playerid, 1290, 1317638593, 3463159297.5, 1317218208.1563, 1316618240);
	RemoveBuildingForPlayer(playerid, 3629, 1317639250, 3463144831.5, 1317219871.9453, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317639447, 3463156937.5, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317639447, 3463154747, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317639447, 3463150578.5, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317639447, 3463148388, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 1290, 1317641284, 3463146406, 1317218208.1563, 1316618240);
	RemoveBuildingForPlayer(playerid, 3665, 1317641494, 3463152808, 1317193728, 1316618240);
	RemoveBuildingForPlayer(playerid, 3663, 1317642269, 3463159308.5, 1317195520.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3629, 1317643438.5, 3463144831.5, 1317219871.9453, 1316618240);
	RemoveBuildingForPlayer(playerid, 1290, 1317643676.5, 3463159297.5, 1317218208.1563, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317644866.5, 3463150578.5, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317644866.5, 3463148388, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317644866.5, 3463156937.5, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317644866.5, 3463154747, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3629, 1317648011, 3463144831.5, 1317219871.9453, 1316618240);
	RemoveBuildingForPlayer(playerid, 1290, 1317648819, 3463159297.5, 1317218208.1563, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317650286, 3463150578.5, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317650286, 3463148388, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317650286, 3463154747, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317650286, 3463156937.5, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3629, 1317652399, 3463144831.5, 1317219871.9453, 1316618240);
	RemoveBuildingForPlayer(playerid, 3663, 1317653021, 3463162596, 1317195520.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 1290, 1317654515, 3463146406, 1317218208.1563, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317655705.5, 3463150578.5, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317655705.5, 3463148388, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3629, 1317656682, 3463144831.5, 1317219871.9453, 1316618240);
	RemoveBuildingForPlayer(playerid, 1290, 1317658765, 3463146406, 1317218208.1563, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317655705.5, 3463154747, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3665, 1317656331, 3463152808, 1317193728, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317655705.5, 3463156937.5, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3663, 1317656209, 3463162126, 1317195520.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317661125, 3463148388, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317661125, 3463150578.5, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317661125, 3463156937.5, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317661125, 3463154747, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 1290, 1317663965, 3463160437, 1317218208.1563, 1316618240);
	RemoveBuildingForPlayer(playerid, 1215, 1317662523, 3463160968, 1317184000, 1316618240);
	RemoveBuildingForPlayer(playerid, 1215, 1317662523, 3463164722.5, 1317184000, 1316618240);
	RemoveBuildingForPlayer(playerid, 1290, 1317663965, 3463165009, 1317218208.1563, 1316618240);
	RemoveBuildingForPlayer(playerid, 3629, 1317665667.5, 3463162999, 1317219871.9453, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317666544.5, 3463150578.5, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317666544.5, 3463148388, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3664, 1317666481.5, 3463159156, 1317221504.2031, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317666544.5, 3463156937.5, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317666544.5, 3463154747, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 1308, 1317667127.5, 3463161664.5, 1317181440, 1316618240);
	RemoveBuildingForPlayer(playerid, 3625, 1317667222, 3463163655.5, 1317199744.2031, 1316618240);
	RemoveBuildingForPlayer(playerid, 1290, 1317668115.5, 3463160437, 1317218208.1563, 1316618240);
	RemoveBuildingForPlayer(playerid, 3574, 1317667917, 3463163775, 1317197439.7969, 1316618240);
	RemoveBuildingForPlayer(playerid, 1308, 1317668137.75, 3463164431.5, 1317181440, 1316618240);
	RemoveBuildingForPlayer(playerid, 1290, 1317668115.5, 3463165009, 1317218208.1563, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317669390, 3463154747, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317669390, 3463150578.5, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 1215, 1317669472.5, 3463148510.5, 1317184000, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317669390, 3463156937.5, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 1290, 1317669952.5, 3463161257.5, 1317218208.1563, 1316618240);
	RemoveBuildingForPlayer(playerid, 3629, 1317668894, 3463162840.5, 1317219871.9453, 1316618240);
	RemoveBuildingForPlayer(playerid, 5006, 1317655693.5, 3463169118, 1317215968.0547, 1316618240);
	RemoveBuildingForPlayer(playerid, 1290, 1317657307, 3463166455, 1317218208.1563, 1316618240);
	RemoveBuildingForPlayer(playerid, 1290, 1317657307, 3463171807.5, 1317218208.1563, 1316618240);
	RemoveBuildingForPlayer(playerid, 1215, 1317662711, 3463169426.5, 1317184000, 1316618240);
	RemoveBuildingForPlayer(playerid, 3664, 1317661228.5, 3463172324.5, 1317221504.2031, 1316618240);
	RemoveBuildingForPlayer(playerid, 1290, 1317663965, 3463169446.5, 1317217823.9453, 1316618240);
	RemoveBuildingForPlayer(playerid, 5031, 1317666115, 3463167389, 1317219167.8438, 1316618240);
	RemoveBuildingForPlayer(playerid, 3629, 1317665667.5, 3463167268.5, 1317219871.9453, 1316618240);
	RemoveBuildingForPlayer(playerid, 3629, 1317665667.5, 3463171518.5, 1317219871.9453, 1316618240);
	RemoveBuildingForPlayer(playerid, 1308, 1317667105.75, 3463167266, 1317181376.1016, 1316618240);
	RemoveBuildingForPlayer(playerid, 3625, 1317667222, 3463167874.5, 1317199744.2031, 1316618240);
	RemoveBuildingForPlayer(playerid, 1308, 1317667121.25, 3463170171.5, 1317181440, 1316618240);
	RemoveBuildingForPlayer(playerid, 3574, 1317667917, 3463170198, 1317199551.6953, 1316618240);
	RemoveBuildingForPlayer(playerid, 3574, 1317667918, 3463168369.5, 1317199551.6953, 1316618240);
	RemoveBuildingForPlayer(playerid, 1308, 1317668137.75, 3463168903, 1317181440, 1316618240);
	RemoveBuildingForPlayer(playerid, 1308, 1317668137.75, 3463166172.5, 1317181440, 1316618240);
	RemoveBuildingForPlayer(playerid, 1308, 1317668153, 3463171808.5, 1317181440, 1316618240);
	RemoveBuildingForPlayer(playerid, 1290, 1317668115.5, 3463169446.5, 1317217823.9453, 1316618240);
	RemoveBuildingForPlayer(playerid, 3629, 1317658729, 3463174247, 1317219871.9453, 1316618240);
	RemoveBuildingForPlayer(playerid, 1412, 1317660502, 3463172895, 1317188864.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 1412, 1317660164, 3463172895, 1317188864.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 1290, 1317660610, 3463174163, 1317217984.1016, 1316618240);
	RemoveBuildingForPlayer(playerid, 1412, 1317660839.5, 3463172897, 1317189120, 1316618240);
	RemoveBuildingForPlayer(playerid, 1412, 1317661515, 3463172901.5, 1317189695.8984, 1316618240);
	RemoveBuildingForPlayer(playerid, 1412, 1317661177.5, 3463172899.5, 1317189440.3047, 1316618240);
	RemoveBuildingForPlayer(playerid, 3625, 1317661276.5, 3463173621, 1317199744.2031, 1316618240);
	RemoveBuildingForPlayer(playerid, 1412, 1317662190.5, 3463172901.5, 1317189695.8984, 1316618240);
	RemoveBuildingForPlayer(playerid, 1412, 1317661852.5, 3463172901.5, 1317189695.8984, 1316618240);
	RemoveBuildingForPlayer(playerid, 1290, 1317662443.5, 3463174154, 1317217984.1016, 1316618240);
	RemoveBuildingForPlayer(playerid, 1412, 1317662528, 3463172901.5, 1317189695.8984, 1316618240);
	RemoveBuildingForPlayer(playerid, 1412, 1317663541, 3463172903.5, 1317189952.3047, 1316618240);
	RemoveBuildingForPlayer(playerid, 1412, 1317663203.5, 3463172901.5, 1317189695.8984, 1316618240);
	RemoveBuildingForPlayer(playerid, 1412, 1317662866, 3463172901.5, 1317189695.8984, 1316618240);
	RemoveBuildingForPlayer(playerid, 1308, 1317662707.5, 3463173109.5, 1317181440, 1316618240);
	RemoveBuildingForPlayer(playerid, 1412, 1317663879, 3463172906, 1317190271.7969, 1316618240);
	RemoveBuildingForPlayer(playerid, 1308, 1317664898, 3463173109.5, 1317181440, 1316618240);
	RemoveBuildingForPlayer(playerid, 1290, 1317664409.5, 3463174168.5, 1317217984.1016, 1316618240);
	RemoveBuildingForPlayer(playerid, 1290, 1317666462.5, 3463174163, 1317217984.1016, 1316618240);
	RemoveBuildingForPlayer(playerid, 1412, 1317667041.75, 3463173095.5, 1317189695.8984, 1316618240);
	RemoveBuildingForPlayer(playerid, 1412, 1317667041.75, 3463173433, 1317189695.8984, 1316618240);
	RemoveBuildingForPlayer(playerid, 1308, 1317667098.5, 3463173109.5, 1317181440, 1316618240);
	RemoveBuildingForPlayer(playerid, 1412, 1317667039.5, 3463173773.5, 1317189695.8984, 1316618240);
	RemoveBuildingForPlayer(playerid, 1412, 1317667037.5, 3463174114.5, 1317189695.8984, 1316618240);
	RemoveBuildingForPlayer(playerid, 1412, 1317667037.5, 3463174452, 1317189695.8984, 1316618240);
	RemoveBuildingForPlayer(playerid, 3574, 1317667249, 3463174028, 1317199680.3047, 1316618240);
	RemoveBuildingForPlayer(playerid, 1412, 1317667037.75, 3463175849, 1317189695.8984, 1316618240);
	RemoveBuildingForPlayer(playerid, 1412, 1317667037.75, 3463175511.5, 1317189695.8984, 1316618240);
	RemoveBuildingForPlayer(playerid, 3665, 1317624135.5, 3463152808, 1317193728, 1316618240);
	RemoveBuildingForPlayer(playerid, 3664, 1317624576.5, 3463149504, 1317221504.2031, 1316618240);
	RemoveBuildingForPlayer(playerid, 3664, 1317624576.5, 3463155823, 1317221504.2031, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317629919, 3463150578.5, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317629919, 3463148388, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317629919, 3463154747, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317629919, 3463156937.5, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 1290, 1317633344.5, 3463159297.5, 1317218208.1563, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317634027.5, 3463156937.5, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317634027.5, 3463154747, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317634027.5, 3463150578.5, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 3666, 1317634027.5, 3463148388, 1317183232.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 5032, 1317636077.5, 3463152663.5, 1317187328.4063, 1316618240);
	RemoveBuildingForPlayer(playerid, 1259, 1317636687, 3463144676.5, 1317209183.8438, 1316618240);
	RemoveBuildingForPlayer(playerid, 3663, 1317636870, 3463159691, 1317196351.8984, 1316618240);
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

public OnVehicleMod()
{
	return 1;
}

public OnVehiclePaintjob()
{
	return 1;
}

public OnVehicleRespray()
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

public OnPlayerInteriorChange()
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt()
{
	return 1;
}

public OnPlayerUpdate()
{
	return 1;
}

public OnPlayerStreamIn()
{
	return 1;
}

public OnPlayerStreamOut()
{
	return 1;
}

public OnVehicleStreamIn()
{
	return 1;
}

public OnVehicleStreamOut()
{
	return 1;
}

public OnDialogResponse()
{
	return 1;
}

public OnPlayerClickPlayer()
{
	return 1;
}

