#include <a_samp>
#include <sscanf2>
#include <zcmd>
#include <colors>
#include <streamer>
#include <foreach>

// SETTA I GIVEPLAYERMONEY ALLA GAMEMODE!

//Questi devi cancellarli
#define MAX_PLAYERNAME 50
new OnDuty[MAX_PLAYERS];

#define strcpy(%0,%1,%2) \
	strcat((%0[0] = '\0', %0), %1, %2)

#define MAX_TOLL 20
#define TOLL_TAX 50
// Police 1
// Gov: 7


//QUesto devi cancellarlo
enum pInfo
{
	Faction
};

new PlayerInfo[MAX_PLAYERS][pInfo];

enum TOLL_ARRAY
{
	Float:PosX,
	Float:PosY,
	Float:PosZ
};

new TollArray[][TOLL_ARRAY] = {
	{19.6481, -1346.5347, 10.0801}, // Entrata LS - RODEO
	{16.0952,-1342.2184,9.9116}, // Entrata LS - RODEO, DESTRA
	{-9.3920,-1326.0033,11.1127}, // Uscita LS Rodeo
	{-5.9525,-1331.0011,10.8573}, //UScita LS - Rodeo DESTRA
	{48.5712,-1539.7959,5.1693}, //Flint Bridge -> LS
	{52.5748,-1523.6921,5.0424}, // LS-> Flint Bridge
	{-164.1377,368.4522,12.0781}, //Blueberry -> Bone County
	{-172.4314,364.2362,12.0781}, // Bone -> BlueBerry
	{521.1497,466.3320,18.9297}, // Quarry -> Red County
	{522.6004,475.6912,18.9297}, // Red -> Quarry
	{1703.5913,440.9917,31.0103}, // LV -> RED Sinistra
	{1697.7810,443.3117,31.0064}, // LV -> Red Destra
	{1718.4269,427.8354,30.9951}, // Red -> LV Destra
	{1712.2573,428.9568,30.9792} // Red -> LV Sinistra
};

new bool:TollLock = false,
	TollBar[MAX_TOLL],
	bar,
	bool:TollOpened[MAX_TOLL] = false;

main()
{
	print("\n----------------------------------");
	print("  Bare Script\n");
	print("----------------------------------\n");
}

public OnPlayerConnect(playerid)
{
	GameTextForPlayer(playerid,"~w~SA-MP: ~r~Bare Script",5000,5);
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
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

SetupPlayerForClassSelection(playerid)
{
 	SetPlayerInterior(playerid,14);
	SetPlayerPos(playerid,258.4893,-41.4008,1002.0234);
	SetPlayerFacingAngle(playerid, 270.0);
	SetPlayerCameraPos(playerid,256.0815,-43.0475,1004.0234);
	SetPlayerCameraLookAt(playerid,258.4893,-41.4008,1002.0234);
}

public OnPlayerRequestClass(playerid, classid)
{
	SetupPlayerForClassSelection(playerid);
	return 1;
}

public OnGameModeInit()
{
	SetGameModeText("Bare Script");

	AddPlayerClass(265,1958.3783,1343.1572,15.3746,270.1425,0,0,0,0,-1,-1);

	new doga, barriera, lossantos, flintc, frontierap;
	
	//dogane ls flint

	doga= CreateDynamicObject(16003, -13.81930, -1324.62842, 11.65790,   0.00000, 0.00000, -140.00000);
	SetDynamicObjectMaterial(doga, 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(doga, 1, 14581, "ab_mafiasuitea", "barbersmir1", 0xFF606060);
	SetDynamicObjectMaterial(doga, 2, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(doga, 3, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	doga= CreateDynamicObject(16003, -5.17290, -1335.42834, 11.61880,   0.00000, 0.00000, -140.00000);
	SetDynamicObjectMaterial(doga, 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(doga, 1, 14581, "ab_mafiasuitea", "barbersmir1", 0xFF606060);
	SetDynamicObjectMaterial(doga, 2, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(doga, 3, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	doga= CreateDynamicObject(16003, 17.78310, -1335.87927, 10.53690,   0.00000, 0.00000, 38.00000);
	SetDynamicObjectMaterial(doga, 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(doga, 1, 14581, "ab_mafiasuitea", "barbersmir1", 0xFF606060);
	SetDynamicObjectMaterial(doga, 2, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(doga, 3, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);

	SetDynamicObjectMaterial(CreateDynamicObject(3578, 58.53290, -1532.54309, 4.96160,   0.00000, 0.40000, -9.00000), 0, 8518, "vgsehighways", "concreteblock_256", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateDynamicObject(3578, 43.41770, -1530.14307, 5.12830,   0.00000, 0.50000, -9.00000), 0, 8518, "vgsehighways", "concreteblock_256", 0xFFFFFFFF);
	CreateDynamicObject(19983, 77.46430, -1521.58826, 2.95394,   0.00000, 0.00000, 62.00000);
	CreateDynamicObject(19983, 28.69470, -1540.19519, 3.70970,   0.00000, 0.00000, -126.00000);
	CreateDynamicObject(19985, -15.77479, -1525.09705, 0.87390,   0.00000, 0.00000, -120.00000);
	CreateDynamicObject(19985, 130.56377, -1538.13367, 7.42566,   0.00000, 0.00000, 25.00000);
	SetDynamicObjectMaterial(CreateDynamicObject(1237, 36.25230, -1529.08105, 4.44616,   0.00000, 0.00000, 0.00000), 0, 8518, "vgsehighways", "concreteblock_256", 0xFFFFFFFF);
	CreateDynamicObject(707, 95.38196, -1482.72729, 9.91406,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(CreateDynamicObject(1237, 65.73390, -1533.78113, 4.13640,   0.00000, 0.00000, 0.00000), 0, 8518, "vgsehighways", "concreteblock_256", 0xFFFFFFFF);
	CreateDynamicObject(19970, 77.44939, -1521.59167, 3.81760,   0.00000, 0.00000, 62.00000);

	doga= CreateDynamicObject(16003, 51.05024, -1529.45557, 5.66480,   0.00000, 0.00000, 170.00000);
	SetDynamicObjectMaterial(doga, 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(doga, 1, 14581, "ab_mafiasuitea", "barbersmir1", 0xFF606060);
	SetDynamicObjectMaterial(doga, 2, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(doga, 3, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	doga= CreateDynamicObject(16003, 50.87143, -1533.14966, 5.68460,   0.00000, 0.00000, -9.00000);
	SetDynamicObjectMaterial(doga, 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(doga, 1, 14581, "ab_mafiasuitea", "barbersmir1", 0xFF606060);
	SetDynamicObjectMaterial(doga, 2, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(doga, 3, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	doga= CreateDynamicObject(16003, 26.32200, -1346.77930, 10.53690,   0.00000, 0.00000, 39.00000);
	SetDynamicObjectMaterial(doga, 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(doga, 1, 14581, "ab_mafiasuitea", "barbersmir1", 0xFF606060);
	SetDynamicObjectMaterial(doga, 2, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(doga, 3, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);

	CreateDynamicObject(8843, 12.88825, -1351.98535, 9.26390,   -1.00000, 0.00000, -52.00000);
	CreateDynamicObject(8843, 9.40810, -1347.68542, 9.26390,   -1.00000, 0.00000, -52.00000);
	CreateDynamicObject(8843, 3.27920, -1359.48535, 9.53070,   -1.00000, 0.00000, -52.00000);
	CreateDynamicObject(8843, 0.03920, -1355.38538, 9.53070,   -1.00000, 0.00000, -52.00000);
	CreateDynamicObject(19718, 23.05440, -1336.70227, 13.61640,   0.00000, 0.00000, 38.00000);
	CreateDynamicObject(19718, 26.75444, -1341.48523, 13.61640,   0.00000, 0.00000, 38.00000);
	SetDynamicObjectMaterial(CreateDynamicObject(18762, 24.89710, -1339.10730, 11.50670,   0.00000, 0.00000, 38.00000), 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateDynamicObject(18762, -11.89580, -1331.95679, 12.47730,   0.00000, 0.00000, 38.00000), 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateDynamicObject(18762, 28.59710, -1343.81067, 11.50670,   0.00000, 0.00000, 38.00000), 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	CreateDynamicObject(19786, 26.79700, -1341.54871, 14.58210,   0.00000, 0.00000, -53.00000);
	CreateDynamicObject(19786, 23.10220, -1336.74866, 14.58210,   0.00000, 0.00000, -53.00000);

	barriera= CreateDynamicObject(966, -15.48025, -1325.95398, 10.05961,   0.00000, 0.00000, 128.00000);
	SetDynamicObjectMaterial(barriera, 0, 3267, "milbase", "a51_metal1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(barriera, 1, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	barriera= CreateDynamicObject(966, 28.44392, -1345.16882, 9.00490,   0.00000, 0.00000, -52.00000);
	SetDynamicObjectMaterial(barriera, 0, 3267, "milbase", "a51_metal1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(barriera, 1, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);

	lossantos= CreateDynamicObject(19327, 26.68500, -1341.62366, 14.58270,   0.00000, 0.00000, -53.00000);
	SetDynamicObjectMaterialText(lossantos, 0, "Los Santos \n West \n{00FF00}V", 90,"Arial", 28, 0, 0xFFFFFFFF, 0xFF000000, 1);
	lossantos= CreateDynamicObject(19327, 22.99849, -1336.83948, 14.58270,   0.00000, 0.00000, -53.00000);
	SetDynamicObjectMaterialText(lossantos, 0, "Los Santos \n West \n{FF0000}X {00FF00}->", 90,"Arial", 28, 0, 0xFFFFFFFF, 0xFF000000, 1);

	TollBar[bar] = CreateObject(968, 28.51080, -1345.25024, 9.80000,   0.00000, 90.00000, 128.00000); //chiusa, porta a ls (corsia destra)
	bar++;
	TollBar[bar] = CreateObject(968, 19.79270, -1334.12000, 9.75510,   0.00000, 90.00000, -52.00000); //lasciala chiusa (corsia sinistra)
	bar++;
	SetDynamicObjectMaterial(CreateDynamicObject(18762, 21.19710, -1334.34595, 11.50670,   0.00000, 0.00000, 38.00000), 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);

	barriera= CreateDynamicObject(966, 19.87191, -1334.20093, 9.00490,   0.00000, 0.00000, 128.00000);
	SetDynamicObjectMaterial(barriera, 0, 3267, "milbase", "a51_metal1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(barriera, 1, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	barriera= CreateDynamicObject(966, -6.97276, -1336.85022, 10.05960,   0.00000, 0.00000, -52.00000);
	SetDynamicObjectMaterial(barriera, 0, 3267, "milbase", "a51_metal1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(barriera, 1, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);

	SetDynamicObjectMaterial(CreateDynamicObject(18762, -15.69581, -1327.35681, 12.47732,   0.00000, 0.00000, 38.00000), 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateDynamicObject(18762, -8.12110, -1336.65686, 12.47730,   0.00000, 0.00000, 38.00000), 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	CreateDynamicObject(19718, -13.74710, -1329.65125, 14.61640,   0.00000, 0.00000, 38.00000);
	CreateDynamicObject(19718, -10.04710, -1334.35120, 14.61640,   0.00000, 0.00000, 38.00000);
	CreateDynamicObject(19786, -10.09102, -1334.31726, 15.56104,   0.00000, 0.00000, 128.00000);
	CreateDynamicObject(19786, -13.80100, -1329.61731, 15.56100,   0.00000, 0.00000, 128.00000);

	flintc= CreateDynamicObject(19327, -9.97700, -1334.23535, 15.55942,   0.00000, 0.00000, 128.00000);
	SetDynamicObjectMaterialText(flintc, 0, "Flint County \n East \n{FF0000}X {00FF00}->", 90,"Arial", 28, 0, 0xFFFFFFFF, 0xFF000000, 1);
	flintc= CreateDynamicObject(19327, -13.69350, -1329.53540, 15.55940,   0.00000, 0.00000, 128.00000);
	SetDynamicObjectMaterialText(flintc, 0, "Flint County \n East \n{00FF00}V", 90,"Arial", 28, 0, 0xFFFFFFFF, 0xFF000000, 1);

	CreateDynamicObject(19966, -11.79580, -1331.86694, 10.04330,   9.00000, 0.00000, 128.00000);
	CreateDynamicObject(19966, 24.79710, -1339.19556, 9.08140,   9.00000, 0.00000, -52.00000);
	CreateDynamicObject(19967, 25.00710, -1339.02490, 9.08140,   9.00000, 0.00000, 128.00000);
	CreateDynamicObject(19967, -11.98580, -1332.05737, 10.04330,   9.00000, 0.00000, -52.00000);
	TollBar[bar] = CreateObject(968, -15.56310, -1325.85974, 10.80330,   0.00000, 90.00000, -52.00000);//� chiusa porta a flint (corsia destra)
	bar++;
	TollBar[bar] = CreateObject(968, -6.92710, -1336.92859, 10.80330,   0.00000, 90.00000, 128.00000);//lasciala chiusa, ne basta 1 (corsia sinistra)
	bar++;
	CreateDynamicObject(8843, 0.15070, -1318.62598, 10.32850,   -1.00000, 0.00000, 128.00000);
	CreateDynamicObject(8843, 12.45070, -1316.23596, 10.83100,   -3.00000, 0.00000, 128.00000);
	CreateDynamicObject(8843, 3.65070, -1323.09595, 10.32850,   -1.00000, 0.00000, 128.00000);
	CreateDynamicObject(8843, 8.75070, -1311.82605, 10.82300,   -3.00000, 0.00000, 128.00000);

    barriera= CreateDynamicObject(966, 53.14140, -1535.91992, 4.07250,   0.00000, 0.00000, 81.00000);
    SetDynamicObjectMaterial(barriera, 0, 3267, "milbase", "a51_metal1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(barriera, 1, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	barriera= CreateDynamicObject(966, 48.46860, -1526.94202, 4.07250,   0.00000, 0.00000, -99.00000);
	SetDynamicObjectMaterial(barriera, 0, 3267, "milbase", "a51_metal1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(barriera, 1, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);

	TollBar[bar] = CreateObject(968, 53.15260, -1535.78345, 4.84000,   0.00000, 90.00000, -99.00000); //� chiusa, porta a flint
	bar++;
	TollBar[bar] = CreateObject(968, 48.44450, -1527.08252, 4.84000,   0.00000, 90.00000, 81.00000); //� chiusa porta a LS
	bar++;
	CreateDynamicObject(19786, 68.22950, -1526.35254, 10.80000,   0.00000, 0.00000, 81.00000);
	CreateDynamicObject(19786, 37.59410, -1537.30652, 10.80000,   0.00000, 0.00000, -99.00000);

	lossantos= CreateDynamicObject(19327, 37.45979, -1537.28674, 10.80000,   0.00000, 0.00000, -99.00000);
	SetDynamicObjectMaterialText(lossantos, 0, "Los Santos \n West \n{00FF00}V", 90,"Arial", 28, 0, 0xFFFFFFFF, 0xFF000000, 1);

	flintc= CreateDynamicObject(19327, 68.36400, -1526.36853, 10.80000,   0.00000, 0.00000, 81.00000);
	SetDynamicObjectMaterialText(flintc, 0, "Flint County \n East \n{00FF00}V", 90,"Arial", 28, 0, 0xFFFFFFFF, 0xFF000000, 1);
	
	CreateDynamicObject(1238, 76.06603, -1531.49377, 4.38780,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, 58.04587, -1538.95239, 4.38328,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, 62.38286, -1540.37891, 4.35112,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, 66.98495, -1540.71021, 4.33188,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, 67.06932, -1526.98132, 4.18112,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, 71.72880, -1527.67236, 4.30150,   0.00000, -1.00000, 0.00000);
	CreateDynamicObject(1425, 56.96864, -1537.39136, 4.36650,   0.00000, 0.00000, -81.00000);
	CreateDynamicObject(1425, 75.33162, -1528.76843, 4.66355,   0.00000, 0.00000, 105.00000);
	CreateDynamicObject(8843, 53.03820, -1524.70679, 4.02130,   0.20000, -3.00000, 84.00000);
	CreateDynamicObject(8843, 51.30130, -1539.34375, 4.13240,   -0.60000, 0.00000, -99.00000);
	CreateDynamicObject(19967, 52.23345, -1532.61475, 3.44326,   0.00000, 0.00000, 81.00000);
	CreateDynamicObject(19966, 54.75640, -1519.45325, 4.10790,   9.00000, 0.00000, 60.00000);
	CreateDynamicObject(19967, 49.66085, -1530.05347, 3.44330,   0.00000, 0.00000, -99.00000);
	CreateDynamicObject(19966, 51.01804, -1544.64771, 4.11590,   9.00000, 0.00000, -130.00000);
	
	//piccole frontiere per LV/red County

	doga= CreateDynamicObject(16003, -166.32803, 373.58310, 12.71250,   0.00000, 0.00000, -105.00000);
	SetDynamicObjectMaterial(doga, 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(doga, 1, 14581, "ab_mafiasuitea", "barbersmir1", 0xFF606060);
	SetDynamicObjectMaterial(doga, 2, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(doga, 3, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);

	barriera= CreateDynamicObject(966, -159.28731, 373.69699, 11.07527,   0.00000, 0.00000, -15.00000);
	SetDynamicObjectMaterial(barriera, 0, 3267, "milbase", "a51_metal1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(barriera, 1, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	barriera= CreateDynamicObject(966, -177.14435, 359.29938, 11.07530,   0.00000, 0.00000, 165.00000);
	SetDynamicObjectMaterial(barriera, 0, 3267, "milbase", "a51_metal1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(barriera, 1, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);

	TollBar[bar] = CreateObject(968, -159.17834, 373.67816, 11.89890,   0.00000, 90.00000, 165.00000); //� chiusa, uscita da red County BONE< RED // 9.5400, 10.3200, 165.0000
	bar++;
	TollBar[bar] = CreateObject(968, -177.22777, 359.31647, 11.89890,   0.00000, 90.00000, -15.00000); //� chiusa, entrata per red County RED->Bone //  -1.9800, 6.4200, -15.0000
	bar++;
	SetDynamicObjectMaterial(CreateDynamicObject(3578, -168.19412, 366.46271, 11.83015,   0.00000, 0.00000, 75.00000), 0, 8518, "vgsehighways", "concreteblock_256", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateDynamicObject(18762, -164.82056, 352.74359, 13.73773,   0.00000, 0.00000, -15.00000), 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateDynamicObject(18762, -166.75310, 353.26160, 16.72140,   -90.00000, 0.00000, 75.00000), 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateDynamicObject(18762, -171.07593, 382.27255, 13.73773,   0.00000, 0.00000, -15.00000), 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateDynamicObject(18762, -169.14650, 381.74051, 16.72140,   -90.00000, 0.00000, 75.00000), 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	CreateDynamicObject(19786, -167.79131, 381.86450, 16.75000,   0.00000, 0.00000, 165.00000);
	CreateDynamicObject(19786, -168.09120, 353.13049, 16.75000,   0.00000, 0.00000, -15.00000);

	frontierap= CreateDynamicObject(19327, -168.12331, 353.00000, 16.74560,   0.00000, 0.00000, -15.00000);
	SetDynamicObjectMaterialText(frontierap, 0, "Bone County \n - \n{00FF00}V", 90,"Arial", 28, 0, 0xFFFFFFFF, 0xFF000000, 1);
	frontierap= CreateDynamicObject(19327, -167.76550, 382.00000, 16.74560,   0.00000, 0.00000, 165.00000);
	SetDynamicObjectMaterialText(frontierap, 0, "Red County \n - \n{00FF00}V", 90,"Arial", 28, 0, 0xFFFFFFFF, 0xFF000000, 1);

	CreateDynamicObject(8843, -165.10907, 365.24170, 11.08970,   0.00000, 0.00000, -15.00000);
	CreateDynamicObject(8843, -171.71791, 367.59543, 11.08970,   0.00000, 0.00000, 165.00000);

	doga= CreateDynamicObject(16003, 516.75653, 477.99817, 19.38200,   0.00000, 0.00000, -55.00000);
	SetDynamicObjectMaterial(doga, 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(doga, 1, 14581, "ab_mafiasuitea", "barbersmir1", 0xFF606060);
	SetDynamicObjectMaterial(doga, 2, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(doga, 3, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	doga= CreateDynamicObject(16003, 525.36426, 465.59772, 19.38200,   0.00000, 0.00000, 125.00000);
	SetDynamicObjectMaterial(doga, 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(doga, 1, 14581, "ab_mafiasuitea", "barbersmir1", 0xFF606060);
	SetDynamicObjectMaterial(doga, 2, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(doga, 3, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);

	barriera= CreateDynamicObject(966, 521.14484, 459.76328, 17.92710,   0.00000, 0.00000, -145.00000);
	SetDynamicObjectMaterial(barriera, 0, 3267, "milbase", "a51_metal1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(barriera, 1, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	barriera= CreateDynamicObject(966, 520.94507, 483.98822, 17.92710,   0.00000, 0.00000, 35.00000);
	SetDynamicObjectMaterial(barriera, 0, 3267, "milbase", "a51_metal1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(barriera, 1, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);

	TollBar[bar] = CreateObject(968, 521.03162, 459.67740, 18.63200,   0.00000, -90.00000, -145.00000); //� chiusa, entrata red County
	bar++;
	TollBar[bar] = CreateObject(968, 521.02039, 484.06299, 18.63200,   0.00000, -90.00000, 35.00000); //� chiusa, uscita red County
	bar++;
	CreateDynamicObject(8843, 527.09534, 468.85284, 17.94290,   0.00000, 0.00000, 35.00000);
	CreateDynamicObject(8843, 514.85309, 474.95093, 17.94290,   0.00000, 0.00000, -145.00000);
	CreateDynamicObject(19786, 511.70261, 478.97369, 26.08760,   35.00000, 0.00000, -145.00000);
	CreateDynamicObject(19786, 529.98413, 464.65982, 26.08760,   35.00000, 0.00000, 35.00000);
	SetDynamicObjectMaterial(CreateDynamicObject(3578, 520.97815, 471.91302, 18.67685,   0.00000, 0.00000, -55.00000), 0, 8518, "vgsehighways", "concreteblock_256", 0xFFFFFFFF);

	frontierap= CreateDynamicObject(19327, 511.63391, 479.06210, 26.01400,   35.00000, 0.00000, -145.00000);
	SetDynamicObjectMaterialText(frontierap, 0, "Red County \n - \n{00FF00}V", 90,"Arial", 28, 0, 0xFFFFFFFF, 0xFF000000, 1);
	frontierap= CreateDynamicObject(19327, 530.05701, 464.56909, 26.00600,   35.00000, 0.00000, 35.00000);
	SetDynamicObjectMaterialText(frontierap, 0, "Bone County \n - \n{00FF00}V", 90,"Arial", 28, 0, 0xFFFFFFFF, 0xFF000000, 1);

	doga= CreateDynamicObject(16003, -170.07758, 359.43259, 12.71250,   0.00000, 0.00000, 75.00000);
	SetDynamicObjectMaterial(doga, 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(doga, 1, 14581, "ab_mafiasuitea", "barbersmir1", 0xFF606060);
	SetDynamicObjectMaterial(doga, 2, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(doga, 3, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	
	//frontiera LV
	doga= CreateDynamicObject(16003, 1723.84644, 428.50851, 31.49290,   0.00000, 0.00000, -20.00000); //
	SetDynamicObjectMaterial(doga, 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(doga, 1, 14581, "ab_mafiasuitea", "barbersmir1", 0xFF606060);
	SetDynamicObjectMaterial(doga, 2, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(doga, 3, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	doga= CreateDynamicObject(16003, 1709.58374, 433.90540, 31.43290,   0.00000, 0.00000, 71.00000);
	SetDynamicObjectMaterial(doga, 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(doga, 1, 14581, "ab_mafiasuitea", "barbersmir1", 0xFF606060);
	SetDynamicObjectMaterial(doga, 2, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(doga, 3, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	doga= CreateDynamicObject(16003, 1705.47498, 434.92450, 31.43290,   0.00000, 0.00000, -109.00000);
	SetDynamicObjectMaterial(doga, 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(doga, 1, 14581, "ab_mafiasuitea", "barbersmir1", 0xFF606060);
	SetDynamicObjectMaterial(doga, 2, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(doga, 3, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	doga= CreateDynamicObject(16003, 1691.74573, 439.85379, 31.49290,   0.00000, 0.00000, -20.00000);
	SetDynamicObjectMaterial(doga, 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(doga, 1, 14581, "ab_mafiasuitea", "barbersmir1", 0xFF606060);
	SetDynamicObjectMaterial(doga, 2, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(doga, 3, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	
	barriera= CreateDynamicObject(966, 1704.88464, 432.77927, 29.92380,   0.00000, 0.00000, -20.00000);
	SetDynamicObjectMaterial(barriera, 0, 3267, "milbase", "a51_metal1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(barriera, 1, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	barriera= CreateDynamicObject(966, 1723.52014, 431.07568, 29.92380,   0.00000, 0.00000, -20.00000); // Ingresso LV -> 0.0000, -16.0000, -20.0000
	SetDynamicObjectMaterial(barriera, 0, 3267, "milbase", "a51_metal1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(barriera, 1, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	barriera= CreateDynamicObject(966, 1691.81567, 437.54095, 29.92380,   0.00000, 0.00000, 160.00000); // 0.0000, 11.0000, -20.0000
	SetDynamicObjectMaterial(barriera, 0, 3267, "milbase", "a51_metal1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(barriera, 1, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	barriera= CreateDynamicObject(966, 1710.43518, 435.83453, 29.92380,   0.00000, 0.00000, 160.00000); // INGRESSO 2 LV //
	SetDynamicObjectMaterial(barriera, 0, 3267, "milbase", "a51_metal1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(barriera, 1, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	
	TollBar[bar] = CreateObject(968, 1704.97803, 432.75711, 30.52100,   0.00000, -90.00000, -20.00000); //barriera chiusa sf SINISTRA
	bar++;
	TollBar[bar] = CreateObject(968, 1691.64075, 437.58301, 30.68780,   0.00000, 90.00000, -20.00000); //barriera chiusa, va per sf, apri solo questa
	bar++;
	TollBar[bar] = CreateObject(968, 1723.64917, 431.01938, 30.70380,   0.00000, -90.00000, -20.00000); //bariera chiusa, va per lv, apri solo questa
	bar++;
	TollBar[bar] = CreateObject(968, 1710.32422, 435.85895, 30.74380,   0.00000, 90.00000, -20.00000); //barriera chiusa LV Sinistra
	bar++;
	SetDynamicObjectMaterial(CreateDynamicObject(18762, 1688.69702, 440.58969, 32.52200,   0.00000, 0.00000, -19.00000), 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateDynamicObject(18762, 1725.95325, 427.75900, 32.52200,   0.00000, 0.00000, -19.00000), 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateDynamicObject(18980, 1714.60754, 431.67804, 34.53193,   90.00000, 0.00000, 71.00000), 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateDynamicObject(18762, 1707.42627, 434.13541, 32.52200,   0.00000, 0.00000, -19.00000), 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateDynamicObject(18762, 1701.87329, 436.07864, 35.47930,   0.00000, 90.00000, -19.00000), 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateDynamicObject(18762, 1719.05322, 430.13779, 35.47930,   0.00000, 90.00000, -19.00000), 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateDynamicObject(18762, 1713.41187, 432.04926, 35.47928,   0.00000, 90.00000, -19.00000), 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateDynamicObject(18762, 1696.21265, 438.02060, 35.47930,   0.00000, 90.00000, -19.00000), 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateDynamicObject(18762, 1699.01794, 437.04141, 32.52200,   0.00000, 0.00000, -19.00000), 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateDynamicObject(18762, 1716.18835, 431.10861, 32.52200,   0.00000, 0.00000, -19.00000), 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	CreateDynamicObject(19786, 1718.94995, 429.68549, 35.16370,   0.00000, 0.00000, -19.00000);
	CreateDynamicObject(19786, 1713.15002, 431.68701, 35.16370,   0.00000, 0.00000, -19.00000);
	CreateDynamicObject(19786, 1702.05005, 436.49570, 35.16370,   0.00000, 0.00000, 161.00000);
	CreateDynamicObject(19786, 1696.25000, 438.48630, 35.16370,   0.00000, 0.00000, 161.00000);
	CreateDynamicObject(19966, 1716.06494, 430.72510, 30.00290,   2.00000, 0.00000, -19.00000);
	CreateDynamicObject(19966, 1699.16394, 437.41669, 30.00290,   2.00000, 0.00000, 161.00000);
	CreateDynamicObject(19967, 1716.33862, 431.48749, 30.00290,   2.00000, 0.00000, 161.00000);
	CreateDynamicObject(19967, 1698.90356, 436.65311, 30.00290,   2.00000, 0.00000, -19.00000);

	frontierap= CreateDynamicObject(19327, 1718.90564, 429.54999, 35.16490,   0.00000, 0.00000, -19.00000);
	SetDynamicObjectMaterialText(frontierap, 0, "Las Venturas \n North \n{00FF00}V", 90,"Arial", 28, 0, 0xFFFFFFFF, 0xFF000000, 1);
	frontierap= CreateDynamicObject(19327, 1713.10876, 431.54999, 35.16490,   0.00000, 0.00000, -19.00000);
	SetDynamicObjectMaterialText(frontierap, 0, "Las Venturas \n North \n{FF0000}X {00FF00}->", 90,"Arial", 28, 0, 0xFFFFFFFF, 0xFF000000, 1);
	lossantos= CreateDynamicObject(19327, 1702.10156, 436.62534, 35.16490,   0.00000, 0.00000, 161.00000);
	SetDynamicObjectMaterialText(lossantos, 0, "Los Santos \n South \n{FF0000}X {00FF00}->", 90,"Arial", 28, 0, 0xFFFFFFFF, 0xFF000000, 1);
	lossantos= CreateDynamicObject(19327, 1696.29883, 438.61801, 35.16490,   0.00000, 0.00000, 161.00000);
	SetDynamicObjectMaterialText(lossantos, 0, "Los Santos \n South \n{00FF00}V", 90,"Arial", 28, 0, 0xFFFFFFFF, 0xFF000000, 1);

	SetDynamicObjectMaterial(CreateDynamicObject(18980, 1700.07336, 436.70261, 34.53180,   90.00000, 0.00000, 71.00000), 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF);
	CreateDynamicObject(8843, 1714.96887, 418.86877, 29.86454,   1.00000, 0.00000, -20.00000);
	CreateDynamicObject(8843, 1709.89319, 420.71457, 29.86454,   1.00000, 0.00000, -20.00000);
	CreateDynamicObject(8843, 1702.20239, 454.84238, 29.88650,   1.00000, 0.00000, 161.00000);
	CreateDynamicObject(8843, 1707.38013, 452.87042, 29.88650,   1.00000, 0.00000, 161.00000);
	CreateTollLabels();
	return 1;
}

CMD:casello(playerid, params[])
{
	if(IsPlayerNearTollBoot(playerid) == -1) return 1;
	if(TollLock == true) return SendClientMessage(playerid, COLOR_RED, "I caselli sono stati chiusi dalle forze dell'ordine!");
	new Toll = IsPlayerNearTollBoot(playerid);
	if(TollOpened[Toll] == true) return SendClientMessage(playerid, COLOR_RED, "Il casello e' gia' aperto.");
	OpenToll(playerid,Toll);
	return 1;
}

CMD:chiudicaselli(playerid, params[])
{
	if(PlayerInfo[playerid][Faction] == 1 || PlayerInfo[playerid][Faction] == 7)
	{
		new string[145];
		if(TollLock == false)
		{
			TollLock = true;
			format(string,sizeof(string), "[TollInfo:] %s ha chiuso tutti i caselli dello stato di San Andreas",GetPlayerNameEx(playerid));
			SendFactionDutyMessage(1,COLOR_LIGHTBLUE,string);
			SendFactionDutyMessage(7,COLOR_LIGHTBLUE,string);			
		}
		else if(TollLock == true)
		{
			TollLock = false;
			format(string,sizeof(string), "[TollInfo:] %s ha aperto tutti i caselli dello stato di San Andreas",GetPlayerNameEx(playerid));
			SendFactionDutyMessage(1,COLOR_LIGHTBLUE,string);
			SendFactionDutyMessage(7,COLOR_LIGHTBLUE,string);		
		}
	}
	return 1;
}

stock GetPlayerNameEx(playerid)
{
    new str[24];
    GetPlayerName(playerid, str, 24);
    return str;
}

stock SendFactionDutyMessage(faction, color, const message[])
{
    new 
        string[144];

    strcpy(string, message, 144);

    foreach (new i : Player)
    {
        if(PlayerInfo[i][Faction] == faction && OnDuty[i])
        {
            new
                len = strlen(string);

            if(len > 84)
            {
                new
                    tmp1[85],
                    tmp2[85];

                strmid(tmp2, string, 80, (len > 149 ? 149 : len));
                strins(tmp2, ".. ", 0, 84);
                strmid(tmp1, string, 0, 80);
                strins(tmp1, " ..", 80, 83);
                SendClientMessage(i, color, tmp1);
                SendClientMessage(i, color, tmp2);
            }
            else
                SendClientMessage(i, color, string);
        }
    }
}

IsPlayerNearTollBoot(playerid)
{
	for(new i = 0; i < sizeof(TollArray); i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.0, TollArray[i][PosX],TollArray[i][PosY],TollArray[i][PosZ])) { printf("%d",i); return i; }
	}
	return -1;
}

CreateTollLabels()
{
	for(new i = 0; i < sizeof(TollArray); i++)
	{
		CreateDynamic3DTextLabel("Pedaggio stradale\n\n((/casello))", COLOR_LIGHTBLUE, TollArray[i][PosX], TollArray[i][PosY], TollArray[i][PosZ], 10.0);
	}
	return 1;
}

CMD:gototoll(playerid, params[])
{
	new id;
	if(sscanf(params, "d",id)) return 1;
	SetPlayerPos(playerid, TollArray[id][PosX],TollArray[id][PosY], TollArray[id][PosZ]);
	return 1;
}

OpenToll(playerid, tollid)
{
	TollOpened[tollid] = true;
	new Float:rX,Float:rY,Float:rZ,Float:X,Float:Y,Float:Z,string[124];
	GetObjectRot(TollBar[tollid], rX,rY,rZ);
	GetObjectPos(TollBar[tollid], X,Y,Z);
	MoveObject(TollBar[tollid], X,Y,Z+0.05, 0.01, rX, 0.0,rZ);
	GivePlayerMoney(playerid, -TOLL_TAX);
	format(string,sizeof(string), "[INFO:] Hai pagato %d$ al guardiano che a sua volta apre la sbarra",TOLL_TAX);
	SendClientMessage(playerid, COLOR_LIGHTYELLOW, string);
	SetTimerEx("ResetToll",7000, false, "dffffff",tollid,X,Y,Z+0.05,rX,rY,rZ);
	return 1;
}

forward ResetToll(tid, Float:X,Float:Y,Float:Z, Float:rX,Float:rY,Float:rZ);
public ResetToll(tid, Float:X,Float:Y,Float:Z,Float:rX,Float:rY,Float:rZ)
{
	MoveObject(TollBar[tid], X,Y,Z-0.05, 0.01 ,rX,rY,rZ);
	TollOpened[tid] = false;
	return 1;
}
