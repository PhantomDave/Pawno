/*
Inserire tutorial Civile / Criminale e convertire PG in Accounts
Modificare il sistema armi
Fare il Destroy Vehicle al Logout
Comprare una casa per i veicoli
Modificare visuale class selection
Scirptare sistema "furniture" per le case
Inserire un'economia abbastanza portante
Iniziare sistema Clan
Fixare il Concessionario /vmenu
Fixare il /ruba, permette di rubare più soldi rispetto a quelli posseduti dal player.
Inserire sistema BENZINA (MI DO FUOCO) e renderli acquistabili
Inserire sistema Workshop -> Modifica del veicolo e riparazione
*/

#include <a_samp>
#undef MAX_PLAYERS
#define MAX_PLAYERS 50
#include <foreach>
#include <zcmd>
#include <sscanf2>
#include <streamer>
//#include <mtime>
#include <a_mysql>
#include <zones>
#include <spikestrip>
#include <mapandreas>
#include <progress>

/*	MySql Info	*/

new MySQL:MySQLC;

//ShowPlayerDialog(playerid, DIALOG_BUSINESS_247, DIALOG_STYLE_LIST, "24/7", "Motosega\nColtello\nTirapugni\nMazza da baseball\nPortafoglio", "", "");

#define MySQL_Host "87.98.243.201"
#define MySQL_User "samp6244"
#define MySQL_Password "JP,nmBJA~m){m7VS"
#define MySQL_Database "samp6244_dave"

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define KEY_AIM (128)

native gpci(playerid, serial [], len); //Serial Ban

#define RIGHE_GAMEMODE 8868
#define GAMEMODE_VERSION "v0.8 Beta"

//Iterators
new Iterator:ServerVehicle<MAX_VEHICLES>;

#define MAX_INI_ENTRY_TEXT 80


new PlayerBar:NoiseBar[MAX_PLAYERS];

/*				{Colours}                */
#define 	COLOR_GREY 0xAFAFAFAA
#define 	EMB_GREY "{AFAFAF}"
#define 	COLOR_DARKGREY 0xA9A9A9FF
#define 	COLOR_BYELLOW 0xE8DA13AA
#define 	COLOR_GREEN 0x33AA33AA
#define 	EMB_GREEN "{33AA33}"
#define 	COLOR_YELLOW 0xFFFF00AA
#define     EMB_YELLOW "{FFFF00}"
#define     EMB_DOLLARGREEN "{295921}"
#define 	COLOR_WHITE 0xFFFFFFAA
#define     EMB_WHITE "{FFFFFF}"
#define 	COLOR_BLUE 0x0000BBAA
#define     EMB_BLUE "{0000BB}"
#define 	COLOR_LIGHTBLUE 0x33CCFFAA
#define     EMB_LIGHTBLUE "{33CCFF}"
#define 	COLOR_ORANGE 0xFF9900AA
#define     EMB_ORANGE "{FF9900}"
#define 	COLOR_LIGHTRED 0xFF3300AA
#define 	COLOR_DARKRED 0x8B0000FF
#define     EMB_DARKRED "{8B0000}"
#define 	COLOR_RED 0xFF0000AA
#define 	EMB_RED "{FF0000}"
#define 	COLOR_LIME 0x10F441AA
#define 	COLOR_MAGENTA 0xFF00FFFF
#define 	COLOR_AQUA 0xF0F8FFAA
#define 	COLOR_CRIMSON 0xDC143CAA
#define 	COLOR_FLBLUE 0x6495EDAA
#define 	COLOR_BISQUE 0xFFE4C4AA
#define 	COLOR_BLACK 0x000000AA
#define 	COLOR_CHARTREUSE 0x7FFF00AA
#define 	COLOR_BROWN 0xB54B00D3
#define		COLOR_LIGHTBROWN 0xFF8000FF
#define 	COLOR_CORAL 0xFF7F50AA
#define 	COLOR_GOLD 0xB8860BAA
#define     EMB_GOLD "{B8860B}"
#define 	COLOR_GREENYELLOW 0xADFF2FAA
#define 	COLOR_INDIGO 0x4B00B0AA
#define 	COLOR_IVORY 0xFFFF82AA
#define 	COLOR_LAWNGREEN 0x7CFC00AA
#define 	COLOR_SEAGREEN 0x20B2AAAA
#define 	COLOR_LIMEGREEN 0x32CD32AA //<--- Dark lime
#define 	COLOR_MIDNIGHTBLUE 0X191970AA
#define 	COLOR_MAROON 0x800000AA
#define 	COLOR_OLIVE 0x808000AA
#define 	COLOR_ORANGERED 0xFF4500AA
#define 	COLOR_PURPLE 0x800080AA
#define     COLOR_NAVY  0x308C19FF
#define 	COLOR_PINK 0xFFC0CBAA

/*	Global Config		*/
#define MAX_TAZER_TIME 6000 //Tempo Tazer
#define MAX_HOUSES 500
#define SERVER_BUILDING 35

#define NO_BUILDING     999
#define NO_HOUSE 		999
#define NO_OWNER        0 //Houses

#define MAX_WALLET_CHANCE 3

#define SERVER_NAME "Atlatis Cops'n'Robbers"

/*			{Dialogs Config}			 */

enum
{
	DIALOG_REG, DIALOG_LOGIN, //Reg & Login
	DIALOG_HOUSE, DIALOG_HOUSE_WITHDRAW, DIALOG_HOUSE_DEPOSIT, //House
	DIALOG_SHOWROOM, DIALOG_VMENU, DIALOG_VMENU_RESPONSE, DIALOG_VMENU_SELLTO, DIALOG_VMENU_SELLTO_PRICE, DIALOG_VMENU_SELLTO_FINISH, //Showroom & Vehicle
	DIALOG_AMMU_BUY, DIALOG_AMMU_BUY_PISTOLS, DIALOG_AMMU_BUY_SMGUN, DIALOG_AMMU_BUY_SHOTGUNS, DIALOG_AMMU_BUY_ARMOUR, DIALOG_AMMU_BUY_ASSAULT, DIALOG_AMMU_BUY_UTILITY, //AMMUNATIONS
	DIALOG_BANK, DIALOG_BANK_WITHDRAW, DIALOG_BANK_DEPOSIT,
	DIALOG_BUY_DRUG,
	DIALOG_POLICE_WEAPONS, DIALOG_POLICE_ELEVATOR, //Con Tickets
	DIALOG_WEAPOND_SELL,
	DIALOG_CHOOSE_WORK,
	DIALOG_BUSINESS_247,
	DIALOG_GPS,
	DIALOG_DEALERBUY
};

/*	Checkpoint	*/
new DrugDealerHouseEnter,
DrugDealerHouseExit,
DrugDealerHouseDrug,
BankEnter,
BankExit,
BankAction
;

/*				{Teams}					 */
#define     TEAM_POLICE             0
new Float:PoliceSpawn[2][4] =
{
	/*           X              Y             Z                A                            																					*/
	{1568.4758,		-1693.1176,		5.8906,			177.9518},
	{1570.5966,		-1636.7916,		13.5605,		359.8549}
};

#define COLT_TICKET 1
#define DEAGLE_TICKET 2
#define SHOTGUN_TICKET 1
#define SHAWNOFF_TICKET 2
#define SPAS_TICKET 3
#define UZI_TICKET 2
#define TEC_TICKET 2
#define MP5_TICKET 2
#define AK_TICKET 2
#define M4_TICKET 3
#define ARMOUR_TICKET 0
#define MEDIKIT_TICKET 0

new stock
ticketstring[345],
policeBuyWeaponsCP,
policeEnter,
policeExit,
playerSpikeStrip[MAX_PLAYERS],
playerSpikeStripTimer[MAX_PLAYERS],
policeElevatorPark,
policeElevatorRoof,
policeElevatorStation
;


#define     TEAM_CIVILIAN  1

new Float:CivilianSpawn[7][4] =
{
	/*           X              Y             Z                A                            																					*/
	{1848.8232,		-1863.2910,		13.5781, 		84.8874},
	{2529.2412,		-1667.6443,		15.1689,		89.5865},
	{2230.8386,		-1327.9219,		23.9844,		88.0455},
	{2211.2705,		-1171.3475,		25.7266,		0.4927},
	{997.9591,		-1313.5706,		13.5469,		179.1815},
	{2242.2275,		-1261.0071,		23.9458,		269.0318},
	{1653.8662,		-1666.1783,		21.4375,		179.2700}
};
//	{2055.8289,		-1694.6259,		13.5547,		270.3375}, Big Smoke

/*		{Time System or Clock System}	 */
#define CLOCK_UPDATE_TIME 1500
new
clockMins = 0,
Text: Clock,
clockSec = 0,
clockstry[20]
;

/*			{Player System}				*/
// Premium
enum {PLAYER_NO_PREMIUM, PLAYER_PREMIUM_BRONZE, PLAYER_PREMIUM_SILVER, PLAYER_PREMIUM_GOLD};
#define MAX_VEHICLE_SLOT 21+1
#define NORMAL_PLAYER_SLOT 5+1
#define PREMIUM_PLAYER_SLOT 20+1
new Text3D:playerPremiumLabel[MAX_PLAYERS];

// Player Enum
enum PlayerEnum__
{
	playerID,
	playerName[MAX_PLAYER_NAME],
	playerMoney,
	playerBank,
	playerWanted,
	playerTeam,
	playerHouse,
	playerAdmin,
	playerC4,
	playerKills,
	playerDeaths,
	playerBanTime,
	playerJailTime,
	playerPremiumTime,
	playerPremium,
	playerDrug,
	playerRewards, //Taglie
	playerRewardMoney, //Soldi Taglia
	playerTickets, //Police Ticket
	bool:playerLogged,
	bool:playerWeapons[47],
	bool:playerWeapAllowed,
	playerWarns,
	bool:playerDead,
	playerWork,
	playerWallet,
	playerRegisterDate,
	playerGainRobberies,
	playerGainVehicleStolen,
	playerGainWeaponsD,
	playerGainDrugsD
};

new PlayerInfo[MAX_PLAYERS][PlayerEnum__];

//
new playerInHouse[MAX_PLAYERS] = NO_HOUSE;
new playerInBuilding[MAX_PLAYERS] = NO_BUILDING;
//
new playerLastVehicle[MAX_PLAYERS] = INVALID_VEHICLE_ID;

new bool:ClassSelection[MAX_PLAYERS];

#define PLAYER_ROBBABLE 	true
#define PLAYER_UNROBBABLE 	false
new bool:CanBeRobbed[MAX_PLAYERS] = PLAYER_ROBBABLE, CanBeRobbedTimer[MAX_PLAYERS];
// Works
#define MAX_WORKS 10
new WorkSellerID[MAX_PLAYERS][MAX_WORKS];
new BuyerID[MAX_PLAYERS] = INVALID_PLAYER_ID;

enum
{
	WORK_NOWORK,
	WORK_WEAPONSD,
	WORK_DRUGSD
};

/*	Rapine	*/

//Centro Scommesse
#define CS_ROBBERY_TIME 15000

new
CS_CheckRobbery, //Checkpoint (Check = Checkpoint)
CSDoor, //Object
CS_PickMoneyCP, //Checkpoint for take money
Dynamite[2], //Object
bool:CS_Robbed //Bool var
;
/*			{Skill System}			*/
enum ENUM_SKILLS
{
	skillRobber,
	skillPolice,
	skillVehicleStolen,
	skillWeaponsD,
	skillDrugsD,
	skillMechanic
};
new PlayerSkill[MAX_PLAYERS][ENUM_SKILLS];

enum wType
{
	ID,
	Ammo,
	Price
};

new WeaponDealerArray[][wType] = 
{
	{WEAPON_COLT45, 300, 500},
	{WEAPON_SILENCED,  150, 750},
	{WEAPON_DEAGLE,  150, 5000},
	{WEAPON_UZI, 500, 15000},
	{WEAPON_TEC9, 500, 15000},
	{WEAPON_MP5, 300, 20000},
	{WEAPON_AK47, 300, 45000},
	{WEAPON_M4, 300, 50000},
	{WEAPON_SATCHEL, 1, 300000}
};

/*	GlobalVar	*/
new
//Admin Vars
bool: Spectating[MAX_PLAYERS] = false,
playerSpectated[MAX_PLAYERS] = -1,
bool: playerADuty[MAX_PLAYERS],
adminVehicleSpawned[MAX_PLAYERS] = INVALID_VEHICLE_ID,
//GeneralVars (Teams, Players, Static Building (Like Bank, Crack house, etc), ATM, etc)
bool:Cuffed[MAX_PLAYERS],
bool:Tazed[MAX_PLAYERS],
bool:Drugged[MAX_PLAYERS],
DruggedTimer[MAX_PLAYERS],
gPlayerAnimLibsPreloaded[MAX_PLAYERS] = false,
playerLoggedFails[MAX_PLAYERS] = 0,
bool:RobCommandUsed[MAX_PLAYERS] = false,
bool:TogPM[MAX_PLAYERS] = false,
BuyWeapons
;

/*		PlayerText		*/

new
PlayerText: InfoText[MAX_PLAYERS],
PlayerText: InfoText2[MAX_PLAYERS],
PlayerText: WantedLevelText[MAX_PLAYERS],
PlayerText: TextLogin[MAX_PLAYERS],
PlayerText: TextLogin2[MAX_PLAYERS],
PlayerText: TextLoot[MAX_PLAYERS],
PlayerText: showroomTD[MAX_PLAYERS][8]
;

new InfoTextTimer[MAX_PLAYERS], InfoTextTimer2[MAX_PLAYERS];

/*		Text3D		*/
new
Text3D: playerADutyLabel[MAX_PLAYERS];

/*		Checkpoint Skills		*/

new VehicleRobberyCP,
Float:randomVehiclePos[][] =
{
	{1670.6542, -1896.2764, 13.9219, 0.0164},
	{-95.4442, -1557.4846, 2.3653, 137.4715},
	{-66.7143, -1172.1510, 1.6080, 334.3933},
	{-28.8620, -1125.0385, 0.8329, 159.5604},
	{2127.3076, -352.2046, 66.3855, 263.5896},
	{2351.4863, -652.0748, 127.8088, 180.8376},
	{887.4194, -24.0291, 62.9841, 156.0728}
};

/*			{Building System}				*/


enum
{
	BUILDING_TYPE_PIZZA, BUILDING_TYPE_AMMUNATION, BUILDING_TYPE_PROLAPS, BUILDING_TYPE_SUBURBAN, BUILDING_TYPE_VICTIM,
	BUILDING_TYPE_DS, BUILDING_TYPE_BINCO, BUILDING_TYPE_CLUCKIN, BUILDING_TYPE_STORE, BUILDING_TYPE_STOREV2,
	BUILDING_TYPE_TGB, BUILDING_TYPE_DONUTS, BUILDING_TYPE_BURGER, BUILDING_TYPE_BARBER, BUILDING_TYPE_TATTOO,
	BUILDING_TYPE_GYM, BUILDING_TYPE_SEXY, BUILDING_TYPE_CLUB, BUILDING_TYPE_ZIP, BUILDING_TYPE_CS, BUILDING_TYPE_POLICE
};

enum _Actors
{
	Skin,
	Float:aX,
	Float:aY,
	Float:aZ,
	Float:aA
};

new const BuildingActors[][_Actors] =
{
	{155, 374.6961,-117.2787,1001.4922,180.9673}, //Pizza
	{179, 296.6023,-40.2156,1001.5156,0.5378}, // Ammu
	{211, 207.0575,-127.8066,1003.5078,180.6846}, //ProLaps
	{211, 203.8950,-41.6711,1001.8047,180.7625}, //Sub Urban
	{211, 204.8534,-8.1097,1001.2109,270.3694}, //Victim
	{211, 204.4661,-157.8299,1000.5234,185.2217}, //Ds
	{211, 207.4455,-98.7054,1005.2578,178.8824}, //Binco
	{167, 369.5554,-4.4921,1001.8589,177.6796}, //Cluckin Bell
	{211, -29.1342,-186.8167,1003.5469,359.0367}, //Store
	{211, 1.7390,-30.7007,1003.5494,356.8434}, //StoreV2
	{211, 493.9797,-77.5623,998.7578,359.5254}, //TGB
	{67, 380.6583,-189.1136,1000.6328,87.0530}, //Dount
	{205, 376.5890,-65.8495,1001.5078,180.4057}, //Burger
	{156, 414.1217,-15.5944,1001.8047,159.2165}, //Barber
	{180, -201.3441,-23.3093,1002.2734,149.5030}, //Tattoo
	{80, 756.5120,7.7400,1000.7003,271.2894}, //Gym
	{178, -104.6593,-8.9152,1000.7188,184.5577}, //Sexy Shop (Aka Morello's Mother)
	{12, 476.1028,-15.0201,1003.6953,267.4893}, //Club
	{211, 161.6468,-81.1917,1001.8047,180.7384} //Zip
};

#define TIME_TO_RESET_BUILDING 60000*3

enum BuildingEnum__
{
	bName[36],
	bType,
	Float:	bEnterX,
	Float:	bEnterY,
	Float:	bEnterZ,
	Float:  bEnterA,
	Float:	bExitX,
	Float:	bExitY,
	Float:	bExitZ,
	Float:  bExitA,
	bInterior,
	bVirtualWorld,
	bPickup,
	bPickupE,
	bBuyPickup,//Pickup per comprare oggetti, esempio: 24/7.
	//Robbery System
	bool:bRobbed,
	bMaxMoney, //Soldi massimi che puoi derubare dal Building.
	bRobberyTime,
	bActor
};

new
BuildingInfo[SERVER_BUILDING][BuildingEnum__],
BuildingCount__ = 0,
RobberyTimer__[MAX_PLAYERS],
TimeCounter__[MAX_PLAYERS],
UnJailTimer__[MAX_PLAYERS],
RobbingBusiness[MAX_PLAYERS],
playerLoot[MAX_PLAYERS] = 0
;

//LootSystem
new static Float:MoneyLaundryPosition[][] =
{
	{691.0319,-1567.4363,14.2422},
	{1124.2679,-1332.9232,12.9133},
	{1997.2871,-2073.5669,13.5469},
	{2445.2778,-1759.9586,13.5896}
};
new MoneyLaundryPickup[sizeof(MoneyLaundryPosition)];
//24/7 buy position
#define STOREV1 0
#define STOREV2 1

new static Float:buyPickupPosition[][] =
{
	{-27.9973,-185.1496,1003.5469}, //StoreV1
	{3.2458,-29.0139,1003.5494} //StoreV2
};

//24/7 Object Price
#define CHAINSAW_PRICE 5000 	//Chainsaw
#define KNIFE_PRICE    2000 	//Knife
#define BRASS_PRICE    2000 	//Brass
#define BASEBALL_PRICE 3000 	//Baseball
#define WALLET_PRICE   20000 	//Wallet

/*		House System			*/
enum houseEnum_
{
	hOwnerID,
	OwnerName[24],
	Float:hX,
	Float:hY,
	Float:hZ,
	Float:hXu,
	Float:hYu,
	Float:hZu,
	bool:hOwned,
	hMoney,
	hInterior,
	hInteriorID,
	hPrice,
	hVirtualW,
	hPickup,
	Text3D: hLabel,
	hClosed,
	bool:hCreated,
	hMapIcon,
	hRobberyCP,
	bool:hRobbed
};
new HouseInfo[MAX_HOUSES][houseEnum_], HouseCount__ = 1;

//Interiors & Rob Check
enum INTERIOR_INFO
{
	INTERIOR_ID,
	Float:INTERIOR_X,
	Float:INTERIOR_Y,
	Float:INTERIOR_Z
};
new Float:HouseInteriors[][INTERIOR_INFO] =
{
	{3, 2496.1187, -1693.4113, 1014.7422}, //CJ house
	{5, 2233.7268, -1113.9570, 1050.8828}, //Hotel Room
	{10, 23.6688, 1341.7125, 1084.3750}, //Luxury House
	{5, 140.1375, 1367.2816, 1083.8613}, //Big House
	{6, 234.1799, 1065.4612, 1084.2097},//Big House 2
	{9, 83.2390, 1323.7605, 1083.8594}, //Luxury House
	{3, 235.3933, 1187.9822, 1080.2578}, // Luxury House 2
	{5, 1262.1553, -785.2296, 1091.9063} //MadDog House
};

enum HOUSE_ROBBERY_INFO
{
	ROBBERY_INTERIOR,
	Float:ROBBERY_X,
	Float:ROBBERY_Y,
	Float:ROBBERY_Z
};
new Float:RobberyHouseCP[][HOUSE_ROBBERY_INFO] =
{
	{3, 2495.4138,-1704.4496,1018.3438}, //CJ house
	{5, 2229.9688,-1107.6345,1050.8828}, //Hotel Room
	{10, 25.0652,1347.1564,1088.8750}, //Luxury House
	{5, 152.4956,1383.4063,1088.3672}, //Big House
	{6, 235.5315,1079.4839,1087.8126},//Big House 2
	{9, 78.1953,1341.7683,1088.3672}, //Luxury House
	{3, 234.3947,1206.6655,1084.3644}, // Luxury House 2
	{5, 1230.5186,-807.4849,1084.0078} //MadDog House
};

enum HOUSE_ROBBERY_OBJECT
{
	robberyHouseName[24],
	robberyObjectID,
	robberyHouseMoney
};
new HouseRobberyObjects[][HOUSE_ROBBERY_OBJECT] =
{
	{"Televisore", 1752, 3000},
	{"Televisore", 1518, 2000},
	{"Televisore", 1747, 1400},
	{"Televisore", 1429, 1000},//Ghetto TV
	{"Registratore", 1783, 2000},
	{"Lettore DVD", 1785, 2000},
	{"VHS Player", 1790, 3000},
	{"Casse", 1840, 1000},
	{"Impianto HiFi", 2103, 3200},
	{"Vaso Antico", 14705, 1240},
	{"Stereo", 2226, 952},
	{"StopStation 2", 2028, 1200},
	{"FakeBox 2", 2028, 1200},
	{"Riviste", 2855, 100}

};
new BoxvilleCheckpoint[MAX_PLAYERS] = -1;
new BoxvilleVehicle[3];
new bool:PlayerRobbingHouse[MAX_PLAYERS] = false;
new PlayerNoiseTimer[MAX_PLAYERS];

enum gpsI
{
	gName[36],
	Float:gX,
	Float:gY,
	Float:gZ
}
new Float:GPS_POS[][gpsI] =
{
	{"Banca", 1029.2897,-1580.5015,13.4874},//Banca
	{"Sfascio", 2180.3018,-2311.6394,13.5469},//Sfascio
	{"Concessionaria Velivoli", 2117.5071,-2422.9126,13.5469},//Concessionaria Velivoli
	{"Grotti", 532.2700,-1291.5427,17.2422},//Grotti
	{"Concessionaria 2", 2131.8789,-1149.2317,24.2905},//Concessionaria 2
	{"Concessionaria Premium", 1248.5476,-2014.3073,59.7472},//Concessionaria Premium
	{"Riciclaggio (1)", 691.0319,-1567.4363,14.2422},
	{"Riciclaggio (2)", 1124.2679,-1332.9232,12.9133},
	{"Riciclaggio (3)", 1997.2871,-2073.5669,13.5469},
	{"Riciclaggio (4)", 2445.2778,-1759.9586,13.5896}
};
new gps_Checkpoint[MAX_PLAYERS];
new bool:UsingGPS[MAX_PLAYERS];
/*	Vehicles	*/
enum vehiclesInfo
{
	vOwnerID,
	vOwnerName[MAX_PLAYER_NAME],
	vModel,
	Float:vX,
	Float:vY,
	Float:vZ,
	Float:vA,
	vColor1,
	vColor2,
	vClosed,
	bool:vOwned,
	bool:vShowroom,
	vMod[18]
};
new
VehicleInfo[MAX_VEHICLES][vehiclesInfo],
vmenu_PlayerToSellVeh[MAX_PLAYERS] = -1,
vmenu_PlayerToSellVehPrice[MAX_PLAYERS] = -1,
vmenu_SellerID[MAX_PLAYERS] = -1,
VmenuVehicles[MAX_PLAYERS][MAX_VEHICLE_SLOT],
vehicleMenuChoosed[MAX_PLAYERS],
vehicleCount[MAX_PLAYERS],
VehicleDriverID[MAX_VEHICLES+1] = INVALID_PLAYER_ID
;

/*	{Player Vehicle}	*/
enum playerVehicleInfo
{
	vID,
}
new PlayerVehicle[MAX_PLAYERS][MAX_VEHICLE_SLOT][playerVehicleInfo];

/*		[Public Vehicle System]			*/
new publicVehicles[] =
{
	445, 401, 518, 527, 542, 507, 562, 585,
	419, 526, 466, 492, 405, 436, 560, 550,
	579, 400, 412, 533, 439, 422, 581, 461,
	463, 468, 586
};

/*	{Showroom System}	*/
#define MAX_SHOWROOM 4+1
#define MAX_CARS 16

new
ShowroomPickup[MAX_SHOWROOM],
ShowroomName[MAX_SHOWROOM][32],
Float:ShowroomPickupPos[MAX_SHOWROOM][3],
showroom_Car[MAX_PLAYERS],
bool:playerBuyingVehicle[MAX_PLAYERS],
vehicleColor1[MAX_PLAYERS],
vehicleColor2[MAX_PLAYERS],
createdShowrooms,
showroomvehs[MAX_SHOWROOM]
;

enum sveh
{
	Float:sX,
	Float:sY,
	Float:sZ,
	Float:sA,
	sPrice,
	sModel
};

new ShowroomVehicle[MAX_SHOWROOM][MAX_CARS][sveh],
	creatingShowroom = -1;

new Float:ATMPosition[][] =
{
	{1073.7020,	-1328.0668,	13.5642},
	{559.6204,	-1293.0023,	17.2482},
	{2117.4978,	-1126.9698,	25.2579},
	{2684.7019, -1422.1848, 30.5062},
	{1366.5023,	-1291.5156,	13.5469},
	{2112.0415,	-1789.8011,	13.5547}
};
new
bool:playerInBank[MAX_PLAYERS] = false,
ATMCheckpoint[sizeof(ATMPosition)];

new randomMessage[][] =
{
	"[SERVER] Visita il nostro sito web all'indirizzo http://lscnr.it/",
	"[SERVER] Sei a corto di soldi? Rapina uno dei tanti business in giro per Los Santos o tenta una rapina al Centro scommesse!",
	"[SERVER] Ricordati di depositare i soldi in banca o qualcuno tentera' di rapinarti!",
	"[SERVER] Hai notato un hacker o qualcuno che abusa di bug? Digita /report [playerid][motivo].",
	"[SERVER] Hai bisogno d'aiuto? Digita /dom [messaggio] per inviare una domanda agli admin.",
	"[SERVER] Hai trovato un bug? Digita /reportbug per inviare un messaggio agli amministratori.",
	"[SERVER] Ti sei perso? Digita /gps per una serie di luoghi utili!"
};


//OnBag
enum PLAYER_BAG
{
	pMoneyBagMoney,
	Float:pMoneyBagX,
	Float:pMoneyBagY,
	Float:pMoneyBagZ,
	pMoneyBagPickup,
	bool:pMoneyBagCreated,
	pMoneyBagTimer
};
new BagInfo[100][PLAYER_BAG];





main()
{
	print("\n----------------------------------");
	print(" Los Santos Cops and Robbers by Code, Edit by Dave");
	print("----------------------------------\n");
	/*		Messo qui per un BUG dell'OnGameModeInit		*/
	SetTimer("UpdateClock", CLOCK_UPDATE_TIME, true);
	SetTimer("RespawnUnoccupiedVehicles", 60000*20, true);
	SetTimer("RandomMessage", 60000*5, true);
}

forward RandomMessage();
public RandomMessage()
{
	SendClientMessageToAll(COLOR_LIGHTBLUE, randomMessage[random(sizeof(randomMessage))]);
}


forward RespawnUnoccupiedVehicles();
public RespawnUnoccupiedVehicles()
{
	foreach(new i : ServerVehicle)
	{
		if(IsVehicleOccupied(i))continue;
		if(VehicleInfo[i][vOwned] != false)continue;
		if(i == BoxvilleVehicle[0] || i ==  BoxvilleVehicle[1] || i ==  BoxvilleVehicle[2])
		{
			SetVehicleToRespawn(i);
			continue;
		}
		DestroyVehicle(i);
	}
	LoadServerVehicles(false);
	SendClientMessageToAll(-1, EMB_RED"[SERVER]"EMB_WHITE" I veicoli pubblici sono stati respawnati automaticamente! (Prossimo respawn tra 20 minuti) ");
}

public OnGameModeInit()
{
	MySQLC = mysql_connect(MySQL_Host, MySQL_User, MySQL_Password, MySQL_Database);
	mysql_log(ALL);
	//	ConnectNPC("Debug","at400_ls");
	SetGameModeText("Cops and Robbers");

	//Classi
	AddPlayerClass(280, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0); // Police
	AddPlayerClass(281, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0); // Police
	AddPlayerClass(282, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0); // Police
	AddPlayerClass(283, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0); // Police
	AddPlayerClass(284, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0); // Police
	AddPlayerClass(288, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0); // Police
	AddPlayerClass(266, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0); // Police
	AddPlayerClass(265, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0); // Police
	AddPlayerClass(267, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0); // Police

	for(new i = 1; i < 299; i++)
	{
		if(i >= 280 && i <= 283 || i == 288 || i >= 284 && i <= 287 || i == 266 || i == 265 || i == 267)continue; //Blocca le skin della NAVY, FBI e Polizia.
		AddPlayerClass(i, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	}
	//	ManualVehicleEngineAndLights();
	LoadServerVehicles(true);
	/*			Zones				*/
	/*for(new i=0; i < sizeof(zones); i++)
	{
	ZoneArea[i] = CreateDynamicRectangle(zones[i][zone_minx], zones[i][zone_miny], zones[i][zone_maxx], zones[i][zone_maxy]);
	}*/
	/*						Stores												*/
	/*							ssName[],          ssType = 1          seX,        seY,        seZ      brCheckX  brCheckY   brCheckZ   RobbSbr MaxMoney*/
	#define GENERAL_ROBBERY_TIME 20
	CreateServerBuilding("Well Stacked Pizza", BUILDING_TYPE_PIZZA, 2105.3816,-1806.4060,13.5547,91.8466, GENERAL_ROBBERY_TIME, 5000);// WSP
	CreateServerBuilding("Cluckin' Bell", BUILDING_TYPE_CLUCKIN, 2397.5806, -1899.0764, 13.5469, 1.5920, GENERAL_ROBBERY_TIME, 5000);// Cluckin Willowfield
	CreateServerBuilding("Cluckin' Bell", BUILDING_TYPE_CLUCKIN, 2419.8169, -1509.0332, 24.0000, 274.3721, GENERAL_ROBBERY_TIME, 5000);// Cluckin East Los Santos
	CreateServerBuilding("Burger Shot", BUILDING_TYPE_BURGER, 1199.3479, -918.2413, 43.1219, 183.4484, GENERAL_ROBBERY_TIME, 5000);// Burger Shot Vinewood
	CreateServerBuilding("Ciambellaio", BUILDING_TYPE_DONUTS, 1038.2321, -1340.7296, 13.7419, 357.2938,   GENERAL_ROBBERY_TIME, 5000);
	CreateServerBuilding("Prolaps", 	BUILDING_TYPE_PROLAPS,		499.5358, -1360.5254, 16.3608, 336.0580, GENERAL_ROBBERY_TIME, 10000);// Rodeo
	CreateServerBuilding("Victim", 		BUILDING_TYPE_VICTIM,		461.6284, -1500.9658, 31.0463, 89.8557, GENERAL_ROBBERY_TIME, 15000);// Rodeo
	CreateServerBuilding("DS", 		    BUILDING_TYPE_DS, 			454.0810, -1477.9941, 30.8131, 108.6231, GENERAL_ROBBERY_TIME, 10000);// Rodeo
	CreateServerBuilding("Binco", 		BUILDING_TYPE_BINCO, 		2244.3367, -1665.4049, 15.4766, 349.1295, GENERAL_ROBBERY_TIME, 10000);// Grove
	CreateServerBuilding("Suburban", 	BUILDING_TYPE_SUBURBAN, 	2112.8386, -1211.6252, 23.9631, 179.1888,GENERAL_ROBBERY_TIME, 5000);// Glen Park
	CreateServerBuilding("24/7", 		BUILDING_TYPE_STOREV2,		1352.4587, -1759.1481, 13.5078, 356.3687, GENERAL_ROBBERY_TIME, 10000);// 24/7 Dove sta la polizia
	CreateServerBuilding("24/7", 		BUILDING_TYPE_STORE, 		1928.6868, -1776.2354, 13.5469, 271.5903, GENERAL_ROBBERY_TIME, 10000);// 24/7 Idlewood
	CreateServerBuilding("24/7", 		BUILDING_TYPE_STORE, 		1833.6084, -1842.5012, 13.5781, 91.8477, GENERAL_ROBBERY_TIME, 10000);// 24/7 Unity
	CreateServerBuilding("24/7", 		BUILDING_TYPE_STOREV2, 		1315.5063, -897.8214, 39.5781, 170.6727, GENERAL_ROBBERY_TIME, 10000);// 24/7 Vinewood
	CreateServerBuilding("Ammunation", BUILDING_TYPE_AMMUNATION,    1368.8953, -1279.5083, 13.5469, 91.3657,    30,   30000); //Central
	CreateServerBuilding("Ammunation", BUILDING_TYPE_AMMUNATION,    2400.4858, -1981.8911, 13.5469, 354.4886,   30,   30000); //Willowfield
	CreateServerBuilding("Ten Green Bottles", BUILDING_TYPE_TGB,    2310.0938, -1643.5424, 14.8270, 90, GENERAL_ROBBERY_TIME, 10000); //Ten Green Bottles Grove
	CreateServerBuilding("Centro Scommesse", BUILDING_TYPE_CS,      1631.8344, -1172.8254, 24.0843, 356.9954); //Centro Scommesse MH
	CreateServerBuilding("Barbiere", BUILDING_TYPE_BARBER,      2070.7332,-1793.9462,13.5533,259.5631, GENERAL_ROBBERY_TIME, 5000); //Barbiere
	CreateServerBuilding("Tattoo", BUILDING_TYPE_TATTOO,      2068.6848,-1779.8763,13.5596,258.5434, GENERAL_ROBBERY_TIME, 10000); //Tattoo MH
	CreateServerBuilding("Sexy Shop", BUILDING_TYPE_SEXY,      1087.6447,-922.5891,43.3906,175.3597, GENERAL_ROBBERY_TIME, 15000); //Sexy Shop Vinewood
	CreateServerBuilding("Alhambra", BUILDING_TYPE_CLUB,      1836.9326, -1682.3787, 13.3273, 82.5320, GENERAL_ROBBERY_TIME, 10000); //Alhambra Vinewood
	CreateServerBuilding("Palestra", BUILDING_TYPE_GYM,      2229.9053, -1721.4121, 13.5629, 128.8734, GENERAL_ROBBERY_TIME, 10000); //Palestra Vinewood
	CreateServerBuilding("Burger Shot", BUILDING_TYPE_BURGER, 810.6002,-1616.3519,13.5469,274.4536, GENERAL_ROBBERY_TIME, 5000);//
	CreateServerBuilding("Barbiere", BUILDING_TYPE_BARBER, 823.9066,-1588.3256,13.5545,142.1934, GENERAL_ROBBERY_TIME, 5000);//
	CreateServerBuilding("Cluckin Bell", BUILDING_TYPE_CLUCKIN, 928.8090,-1352.9760,13.3438,88.0989, GENERAL_ROBBERY_TIME, 5000);//
	CreateServerBuilding("24/7", BUILDING_TYPE_STORE,	1000.4776,-919.8459,42.3281,87.2154, GENERAL_ROBBERY_TIME, 10000);// 24/7
	CreateServerBuilding("Liquor Bar", BUILDING_TYPE_TGB,    2348.4417,-1372.7896,24.3984,179.8647, GENERAL_ROBBERY_TIME, 10000);
	CreateServerBuilding("98$ Store", BUILDING_TYPE_STORE,    2424.2007,-1742.8208,13.5454,46.5925, GENERAL_ROBBERY_TIME, 10000);
	CreateServerBuilding("Sexy Shop", BUILDING_TYPE_SEXY,    953.9216,-1336.7296,13.5389,357.2690, GENERAL_ROBBERY_TIME, 10000);
	CreateServerBuilding("Zip", BUILDING_TYPE_ZIP,    1456.5831,-1137.6555,23.9540,216.4568, GENERAL_ROBBERY_TIME, 10000);
	CreateServerBuilding("69$ Store", BUILDING_TYPE_STORE,    2001.7897,-1761.9609,13.5391,356.6504, GENERAL_ROBBERY_TIME, 5000);
	CreateServerBuilding("Bar", BUILDING_TYPE_TGB,    1951.4487,-2041.0963,13.5469,266.8765, GENERAL_ROBBERY_TIME, 10000);
	CreateServerBuilding("Sexy Shop", BUILDING_TYPE_SEXY,    1940.1111,-2116.1250,13.6953,276.6588, GENERAL_ROBBERY_TIME, 22000);

	printf("Building Caricati: %d", BuildingCount__);

	//Clock
	Clock = TextDrawCreate(551.918029, 20.999998, " ");
	TextDrawLetterSize(Clock, 0.492635, 2.451667);
	TextDrawTextSize(Clock, 13.587115, 292.250000);
	TextDrawAlignment(Clock, 1);
	TextDrawColor(Clock, -1);
	TextDrawSetShadow(Clock, 0);
	TextDrawSetOutline(Clock, 1);
	TextDrawBackgroundColor(Clock, 51);
	TextDrawFont(Clock, 3);
	TextDrawSetProportional(Clock, 1);

	//== Timers ==
	/*				{Global Checkpoint}				*/
	// MoneyLaundry

	for(new i = 0; i < sizeof(MoneyLaundryPosition); i++)
	{
		CreateDynamicMapIcon(MoneyLaundryPosition[i][0],MoneyLaundryPosition[i][1],MoneyLaundryPosition[i][2], 52, -1, -1, -1, -1, 50.0); // MapIcon
		MoneyLaundryPickup[i] = CreateDynamicPickup(1274, 1, MoneyLaundryPosition[i][0],MoneyLaundryPosition[i][1],MoneyLaundryPosition[i][2], 0, 0, -1, 100.0);//Parcheggio
	}
	// Skills Checkpoint
	VehicleRobberyCP = CreateDynamicCP(2185.8972, -2318.2458, 13.1101, 3.0, -1, -1, -1, 40.0);
	CreateDynamicMapIcon(2185.8972, -2318.2458, 13.1101, 55, -1, -1, -1, -1, 9999.0); // MapIcon Checkpoint RobVehicleSkill
	//Rapina CS
	CS_CheckRobbery = CreateDynamicCP(825.3669, 10.0317, 1004.1797, 1.2, -1, 3, -1, 100.0);
	CSDoor = CreateDynamicObject(2634,824.2000100,10.1000000,1004.2999900,0.0000000,0.0000000,272.0000000); //object(ab_vaultdoor) (3)
	CS_PickMoneyCP = CreateDynamicCP(820.8804, 9.0661, 1004.1959, 1.2, -1, 3, -1, 50.0);
	//Police Checkpoints/Pickups
	policeEnter = CreateDynamicPickup(1239, 1, 1555.3945, -1675.6084, 16.1953, 0, 0, -1, 100.0);
	CreateDynamic3DTextLabel("Stazione di Polizia", -1, 1555.3945, -1675.6084, 16.1953, 50, -1);
	CreateDynamicMapIcon(1555.3945, -1675.6084, 16.1953, 30, -1, -1, -1, -1, 100.0);
	policeExit = CreateDynamicPickup(1239, 1, 246.8096, 62.4316, 1003.6406, 0, 6, -1, 100.0);
	policeBuyWeaponsCP = CreateDynamicCP(1577.1603,-1636.5814,13.5552, 3.0, -1, -1, -1, 40.0);
	//Ascensore
	policeElevatorPark = CreateDynamicPickup(1559, 1, 1568.5887,-1689.9709,6.2188, 0, 0, -1, 100.0);//Parcheggio
	CreateDynamic3DTextLabel("Ascensore.\nPremi ~k~~VEHICLE_ENTER_EXIT~ per usare.", -1, 1568.5887,-1689.9709,6.2188, 50, -1, INVALID_VEHICLE_ID, 0, 0, 0);
	policeElevatorRoof = CreateDynamicPickup(1559, 1, 1565.0767,-1667.0001,28.3956, 0, 0, -1, 100.0);//Tetto
	CreateDynamic3DTextLabel("Ascensore.\nPremi ~k~~VEHICLE_ENTER_EXIT~ per usare.", -1, 1565.0767,-1667.0001,28.3956, 50, -1, INVALID_VEHICLE_ID, 0, 0, 0);
	policeElevatorStation = CreateDynamicPickup(1559, 1, 242.2487,66.3135,1003.6406, 0, 0, -1, 100.0);//Stazione
	CreateDynamic3DTextLabel("Ascensore.\nPremi ~k~~VEHICLE_ENTER_EXIT~ per usare.", -1, 1568.5887,-1689.9709,6.2188, 50, -1, INVALID_VEHICLE_ID, 0, 0, 6);
	//Ammunation
	BuyWeapons = CreateDynamicCP(296.6755, -38.5138, 1001.5156, 1.0, -1,  1, -1, 22.0);
	//Bank
	//                    		         X           Y         Z        Sz  	VW    INT     IDP     DrawDist.
	BankEnter  =  CreateDynamicCP(   1026.0591,  -1583.6067, 13.5469, 	2.0,   0, 	  0, 		-1, 	20.0);
	BankExit   =  CreateDynamicCP(   2304.6794,  -16.0816, 	 26.7422,  	2.0,   5, 	  0, 		-1, 	20.0);
	BankAction =  CreateDynamicCP(   2316.6204,  -7.4120,	 26.7422,  	1.5,   5, 	  0, 		-1, 	20.0);
	CreateDynamicMapIcon(1028.1586, -1580.7498, 13.5032, 52, -1, -1, -1, -1, 9999.0); // MapIcon Bank
	//Jobs
	//Drug Dealer Conig

	DrugDealerHouseEnter  =  CreateDynamicCP(   2166.1348, -1671.4480, 15.0736, 	1.5,   0, 	  0, 		-1, 	20.0);
	DrugDealerHouseExit  =  CreateDynamicCP(   318.5807,	1114.4806, 1083.0386, 	1.5,   0, 	  5, 		-1, 	20.0);
	DrugDealerHouseDrug  =  CreateDynamicCP(   323.5592,	1120.8582,	1083.8828, 	1.5,   0, 	  5, 		-1, 	20.0);

	ManualVehicleEngineAndLights();
	UsePlayerPedAnims();
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	LoadMaps();
	CheckMySQLTable();
	mysql_tquery(MySQLC, "SELECT * FROM `houses`", "LoadHouses");
	mysql_tquery(MySQLC, "SELECT * FROM `showrooms`","LoadShowrooms");
	return 1;
}

public OnGameModeExit()
{
	mysql_close(MySQLC);
	Iter_Clear(ServerVehicle);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(IsPlayerNPC(playerid))return 1;
	OnPlayerRequestClass__(playerid, classid);
	return 1;
}

public OnPlayerConnect(playerid)
{
	TogglePlayerAllDynamicCPs(playerid, false);
	SetPlayerHealth(playerid, 99.0);
	if(IsPlayerNPC(playerid))
	{
		PlayerInfo[playerid][playerLogged] = true;
		return 1;
	}
	OnPlayerRequestClass__(playerid, 1);
	if(CS_Robbed == true)
	{
		TogglePlayerDynamicCP(playerid, CS_CheckRobbery, 0);//Toglie i CP
		TogglePlayerDynamicCP(playerid, CS_PickMoneyCP, 0);
	}
	else
	{
		TogglePlayerDynamicCP(playerid, CS_CheckRobbery, 1);//Mette i CP
		TogglePlayerDynamicCP(playerid, CS_PickMoneyCP, 1);
	}
	PlayerTextDrawShow(playerid, TextLogin[playerid]);
	PlayerTextDrawShow(playerid, TextLogin2[playerid]);
	PlayerInfo[playerid][playerLogged] = false;
	TogglePlayerDynamicCP(playerid, policeBuyWeaponsCP, 1);
	TogglePlayerDynamicCP(playerid, VehicleRobberyCP, 1);
	TogglePlayerDynamicCP(playerid, CS_CheckRobbery, 1);
	TogglePlayerDynamicCP(playerid, BuyWeapons, 1);
	TogglePlayerDynamicCP(playerid, BankEnter, 1);
	TogglePlayerDynamicCP(playerid, BankExit, 1);
	TogglePlayerDynamicCP(playerid, BankAction, 1);
	TogglePlayerDynamicCP(playerid, DrugDealerHouseEnter, 1);
	TogglePlayerDynamicCP(playerid, DrugDealerHouseExit, 1);
	TogglePlayerDynamicCP(playerid, DrugDealerHouseDrug, 1);
	for(new i = 0; i < sizeof(ATMPosition); i++)//ATMLOAD
	{
		TogglePlayerDynamicCP(playerid, ATMCheckpoint[i], 1);
	}
	/*	RemoveBuildingForPlayer(playerid, 955, 0, 0, 0, 50000);
	RemoveBuildingForPlayer(playerid, 956, 0, 0, 0, 50000);
	RemoveBuildingForPlayer(playerid, 1209, 0, 0, 0, 50000);
	RemoveBuildingForPlayer(playerid, 1302, 0, 0, 0, 50000);
	RemoveBuildingForPlayer(playerid, 1775, 0, 0, 0, 50000);
	RemoveBuildingForPlayer(playerid, 1776, 0, 0, 0, 50000);*/
	SendClientMessage(playerid, COLOR_LIGHTRED, "Caricamento...");
	SetTimerEx("Timer_OnPlayerConnect", 1000, false, "i", playerid);
	return 1;
}

forward SerialCheck(playerid);
public SerialCheck(playerid)
{
	new cout;
	cache_get_row_count(cout);
	if(cout > 1)
	{
		SendClientMessage(playerid, COLOR_RED, "> [SERIAL-BAN]: Risulti bannato dal sistema.");
		KickPlayer(playerid);
		return 0;
	}
	return 1;
}

forward Timer_OnPlayerConnect(playerid);
public Timer_OnPlayerConnect(playerid)
{
	ClearPlayerVariables(playerid);
	LoadTextDrawForPlayer(playerid);
	GetPlayerName(playerid, PlayerInfo[playerid][playerName], MAX_PLAYER_NAME);
	for(new i = 0; i < 25; i++) SendClientMessage(playerid, -1, "");
	TextDrawShowForAll(Clock);
	new player_serial[129], query[200];
	gpci(playerid, player_serial, sizeof(player_serial)); //Serial Ban
	mysql_tquery(MySQLC, query, "SerialCheck","d",playerid);
	new string[128];
	SendClientMessage(playerid, -1, "=== Los Santos Cops'n'Robbers ===");
	format(string, sizeof(string), "Versione: "GAMEMODE_VERSION);
	SendClientMessage(playerid, -1, string);
	format(string, sizeof(string), "Righe Gamemode: %d - Creata da Coda, Edit by Dave", RIGHE_GAMEMODE);
	SendClientMessage(playerid, -1, string);
	mysql_format(MySQLC, query, sizeof query, "SELECT * FROM `Players` WHERE `Name` = '%e'", PlayerInfo[playerid][playerName]);
	mysql_tquery(MySQLC, query, "FirstLoadPlayer","d",playerid);
	PlayerInfo[playerid][playerWeapAllowed] = true;
	return 1;
}
forward FirstLoadPlayer(playerid);
public FirstLoadPlayer(playerid)
{
	new cout, string[200];
	cache_get_row_count(cout);
	if(cout)
	{
		format(string,sizeof(string), ""EMB_WHITE"Benvenuto su "EMB_GREEN"%s"EMB_WHITE"\nInserisci la tua password per loggarti",SERVER_NAME);
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", string, "Login", "Annulla");
	}
	else
	{
		format(string,sizeof(string), ""EMB_WHITE"Benvenuto su "EMB_GREEN"%s"EMB_WHITE"\nInserisci la tua password per registrarti", SERVER_NAME);
		ShowPlayerDialog(playerid, DIALOG_REG, DIALOG_STYLE_PASSWORD, "Registrazione", string, "Registrati", "Annulla");
	}
	return 1;
}

public OnQueryError(errorid, const error[], const callback[], const query[], MySQL:handle)
{
	switch(errorid)
	{
		case CR_SERVER_GONE_ERROR:
		{
			printf("Lost connection to server");
		}
		case ER_SYNTAX_ERROR:
		{
			printf("Something is wrong in your syntax, query: %s",query);
		}
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(IsPlayerNPC(playerid))
	{
		return 1;
	}
	SetPlayerFightingStyle (playerid, FIGHT_STYLE_NORMAL);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SNIPERRIFLE, 999);
	SendClientMessage(playerid, COLOR_GREY, "Usa /aiuto per una lista di tutti i comandi!");
	if(!gPlayerAnimLibsPreloaded[playerid])
	{
		PreloadAnimLib(playerid,"BOMBER"), PreloadAnimLib(playerid,"RAPPING"), PreloadAnimLib(playerid,"SHOP"), PreloadAnimLib(playerid,"BEACH");
		PreloadAnimLib(playerid,"SMOKING"), PreloadAnimLib(playerid,"FOOD"), PreloadAnimLib(playerid,"ON_LOOKERS"), PreloadAnimLib(playerid,"DEALER");
		PreloadAnimLib(playerid,"CRACK"), PreloadAnimLib(playerid,"CARRY"), PreloadAnimLib(playerid,"COP_AMBIENT"), PreloadAnimLib(playerid,"PARK");
		PreloadAnimLib(playerid,"INT_HOUSE"), PreloadAnimLib(playerid,"FOOD");
		gPlayerAnimLibsPreloaded[playerid] = true;
	}
	PlayerTextDrawHide(playerid, TextLoot[playerid]);
	PlayerTextDrawHide(playerid, TextLogin[playerid]);
	PlayerTextDrawHide(playerid, TextLogin2[playerid]);
	TextDrawShowForPlayer(playerid, Clock);
	Cuffed[playerid] = false;
	PlayerInfo[playerid][playerDead] = true;
	playerInBuilding[playerid] = NO_BUILDING;
	playerInHouse[playerid] = NO_HOUSE;
	RobbingBusiness[playerid] = -1;
	TogglePlayerControllable(playerid, 1);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	ClearAnimations(playerid);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	PlayerInfo[playerid][playerWeapAllowed] = false;
	SetPlayerHealth(playerid, 99.0);
	SetTimerEx("SetPlayerSpawn", 300, false, "i", playerid);
	return 1;
}

forward SetPlayerSpawn(playerid);

public SetPlayerSpawn(playerid)
{
	ResetPlayerWantedLevel(playerid);
	DestroyDynamic3DTextLabel(playerADutyLabel[playerid]);
	if(playerADuty[playerid])playerADuty[playerid] = false;
	ClassSelection[playerid] = false;
	KillTimer(TimeCounter__[playerid]);
	KillTimer(RobberyTimer__[playerid]);
	KillTimer(UnJailTimer__[playerid]);
	PlayerTextDrawHide(playerid, InfoText[playerid]);
	PlayerTextDrawHide(playerid, InfoText2[playerid]);
	if(PlayerInfo[playerid][playerTeam] == TEAM_POLICE)
	{
		if(PlayerInfo[playerid][playerHouse] == NO_HOUSE)
		{
			new spawnPosition = random(sizeof(PoliceSpawn));
			Streamer_UpdateEx(playerid,PoliceSpawn[spawnPosition][0], PoliceSpawn[spawnPosition][1], PoliceSpawn[spawnPosition][2], 0, 0);
			SetPlayerPos(playerid, PoliceSpawn[spawnPosition][0], PoliceSpawn[spawnPosition][1], PoliceSpawn[spawnPosition][2]);
			SetPlayerFacingAngle(playerid, PoliceSpawn[spawnPosition][3]);
		}
		else
		{
			Streamer_UpdateEx(playerid,HouseInfo[ PlayerInfo[playerid][playerHouse] ][hX], HouseInfo[ PlayerInfo[playerid][playerHouse] ][hY], HouseInfo[ PlayerInfo[playerid][playerHouse] ][hZ], 0, 0);
			SetPlayerPos(playerid, HouseInfo[ PlayerInfo[playerid][playerHouse] ][hX], HouseInfo[ PlayerInfo[playerid][playerHouse] ][hY], HouseInfo[ PlayerInfo[playerid][playerHouse] ][hZ]);
			SetPlayerFacingAngle(playerid, random(180));
		}
		SetCameraBehindPlayer(playerid);
		SetPlayerColor(playerid, COLOR_BLUE);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		GivePlayerWeaponEx(playerid, 24, 150);
		GivePlayerWeaponEx(playerid, 25, 200);
		GivePlayerWeaponEx(playerid, 29, 460);
		SetPlayerColor(playerid, COLOR_BLUE);
	}
	else if(PlayerInfo[playerid][playerTeam] == TEAM_CIVILIAN)
	{
		if(PlayerInfo[playerid][playerHouse] == NO_HOUSE)
		{
			new spawnPosition = random(sizeof(CivilianSpawn));
			Streamer_UpdateEx(playerid,CivilianSpawn[spawnPosition][0], CivilianSpawn[spawnPosition][1], CivilianSpawn[spawnPosition][2], 0, 0);
			SetPlayerPos(playerid, CivilianSpawn[spawnPosition][0], CivilianSpawn[spawnPosition][1], CivilianSpawn[spawnPosition][2]);
			SetPlayerFacingAngle(playerid, CivilianSpawn[spawnPosition][3]);
		}
		else
		{
			Streamer_UpdateEx(playerid,HouseInfo[ PlayerInfo[playerid][playerHouse] ][hX], HouseInfo[ PlayerInfo[playerid][playerHouse] ][hY], HouseInfo[ PlayerInfo[playerid][playerHouse] ][hZ], 0, 0);
			SetPlayerPos(playerid, HouseInfo[ PlayerInfo[playerid][playerHouse] ][hX], HouseInfo[ PlayerInfo[playerid][playerHouse] ][hY], HouseInfo[ PlayerInfo[playerid][playerHouse] ][hZ]);
			SetPlayerFacingAngle(playerid, random(180));
		}
		SetCameraBehindPlayer(playerid);
		SetPlayerColor(playerid, COLOR_WHITE);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		ShowPlayerDialog(playerid, DIALOG_CHOOSE_WORK, DIALOG_STYLE_LIST, "Lavori", "N/A\nTrafficante d'Armi\nSpacciatore di Droga\n", "Continua", "Annulla");
	}
	if(PlayerInfo[playerid][playerJailTime] > 0)
	{
		KillTimer(TimeCounter__[playerid]);
		KillTimer(RobberyTimer__[playerid]);
		KillTimer(UnJailTimer__[playerid]);
		KillTimer(RobberyTimer__[playerid]);
		SetPlayerInterior(playerid, 6);
		SetPlayerPos(playerid, 264.6123,77.6957,1001.0391);
		SetPlayerVirtualWorld(playerid, playerid);
		UnJailTimer__[playerid] = SetTimerEx("UnJailPlayer", PlayerInfo[playerid][playerJailTime]*1000, false, "i", playerid);
		TimeCounter(playerid, PlayerInfo[playerid][playerJailTime]);
		SendClientMessage(playerid, COLOR_RED, "Sei tornato in jail!");
		PlayerInfo[playerid][playerWeapAllowed] = false;
	}
	if(PlayerInfo[playerid][playerRewardMoney] > 0)
	{
		SetPlayerTeam(playerid, NO_TEAM);
	}
	Cuffed[playerid] = false;
	PlayerInfo[playerid][playerWallet] = 0;
	PlayerInfo[playerid][playerDead] = false;
	SetPlayerRobbableStatus(playerid, PLAYER_UNROBBABLE);
	SendClientMessage(playerid, COLOR_GREEN, "> ANTI ROB SPAWN: Attivo");
	CanBeRobbedTimer[playerid] = SetTimerEx("AntiRobSpawn", 1*60*1000, false, "i", playerid);
	SetPlayerHealth(playerid, 99.0);
	PlayerInfo[playerid][playerDead] = false;
	PlayerTextDrawHide(playerid, WantedLevelText[playerid]);
	return 1;
}


public OnPlayerDisconnect(playerid, reason)
{
	if(IsPlayerNPC(playerid))
	{
		PlayerInfo[playerid][playerLogged] = false;
		return 1;
	}
	if(BuyerID[playerid] != INVALID_PLAYER_ID && WorkSellerID[ BuyerID[playerid] ][ PlayerInfo[playerid][playerWork] ] == playerid)
	{
		WorkSellerID[ BuyerID[playerid] ][ PlayerInfo[playerid][playerWork] ] = INVALID_PLAYER_ID;
		BuyerID[playerid] = INVALID_PLAYER_ID;
	}
	if(playerLoot[playerid] > 0 && PlayerInfo[playerid][playerTeam] != TEAM_POLICE)
	{
		new Float:pX, Float:pY, Float:pZ;
		GetPlayerPos(playerid, pX, pY, pZ);
		CreateServerBag(playerLoot[playerid], pX, pY, pZ, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), 2);
	}
	if(Cuffed[playerid] == true)
	{
		PlayerInfo[playerid][playerJailTime] = 60*3;
	}
	SavePlayer(playerid);
	if(GetPlayerVehicleCount(playerid) > 0)SavePlayerVehicle(playerid);
	new
	string[22+24+4+2+10],
	reasonname[10];
	switch(reason)
	{
		case 0: reasonname = "Crash";
		case 1: reasonname = "Uscito";
		case 2: reasonname = "Kick";
	}
	format(string, sizeof(string), "%s[%d] e' uscito dal server. [%s]", PlayerInfo[playerid][playerName], playerid, reasonname);
	SendClientMessageToAll(COLOR_GREY, string);
	PlayerInfo[playerid][playerLogged] = false;
	ClearPlayerVariables(playerid);
	if(creatingShowroom == playerid) creatingShowroom = -1;
	for(new i = 0; i < MAX_CARS; i++)
	{
		//if(PlayerVehicles[playerid][i][vID] == 0) continue;
		//DestroyPlayerVehicles(playerid, i);
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	SendDeathMessage(killerid, playerid, reason);
	PlayerInfo[playerid][playerDead] = true;
	PlayerInfo[playerid][playerDeaths] ++;
	playerInBank[playerid] = false;
	Cuffed[playerid] = false;
	PlayerTextDrawHide(playerid, TextLoot[playerid]);
	PlayerTextDrawHide(playerid, InfoText[playerid]);
	PlayerTextDrawHide(playerid, InfoText2[playerid]);
	if(playerLoot[playerid] > 0 && PlayerInfo[playerid][playerTeam] == TEAM_CIVILIAN)
	{
		new Float:pX, Float:pY, Float:pZ;
		GetPlayerPos(playerid, pX, pY, pZ);
		CreateServerBag(playerLoot[playerid], pX, pY, pZ, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), 2);
		playerLoot[playerid] = 0;
	}
	if(killerid != INVALID_PLAYER_ID) //Ucciso da ...
	{
		PlayerInfo[killerid][playerKills] ++;
		switch(PlayerInfo[killerid][playerTeam])
		{
			case TEAM_CIVILIAN:
			{
				GivePlayerWantedLevelEx(killerid, 6, "** Crimine Commesso: Omicidio di primo grado **");
			}
			case TEAM_POLICE:
			{
				if(PlayerInfo[playerid][playerTeam] == TEAM_CIVILIAN && GetPlayerWantedLevelEx(playerid) > 2)
				{
					new string[128];
					format(string, 128, "Hai ucciso "EMB_RED"%s"EMB_WHITE" (Livello ricercato %d) ed hai ricevuto "EMB_DOLLARGREEN"%s"EMB_WHITE" (+1 punto poliziotto)", PlayerInfo[playerid][playerName], GetPlayerWantedLevelEx(playerid), ConvertPrice(5000));
					SendMessageToPlayer(killerid, -1, string);
					GivePlayerMoneyEx(killerid, 5000);
					PlayerSkill[killerid][skillPolice] ++;
					PlayerInfo[killerid][playerTickets] ++;
				}
			}
		}
		if(PlayerInfo[playerid][playerRewardMoney] > 0)
		{
			GivePlayerMoneyEx(killerid, PlayerInfo[playerid][playerRewardMoney]);
			new string[128];
			format(string, 128, EMB_RED"%s(%d)"EMB_WHITE" ha ucciso "EMB_RED"%s(%d)"EMB_WHITE" risquotendo la taglia. ("EMB_DOLLARGREEN"%s"EMB_WHITE")", PlayerInfo[killerid][playerName], killerid, PlayerInfo[playerid][playerName], playerid, ConvertPrice(PlayerInfo[playerid][playerRewardMoney]));
			SendClientMessageToAll(-1, string);
			SetPlayerTeam(playerid, 0);
			PlayerInfo[playerid][playerRewardMoney] = 0;
		}
	}
	if(PlayerInfo[playerid][playerTeam] == TEAM_CIVILIAN && RobbingBusiness[playerid] != -1)
	{
		PlayerTextDrawHide(playerid, InfoText[playerid]);
		KillTimer(TimeCounter__[playerid]);
		KillTimer(RobberyTimer__[playerid]);
		SendClientMessage(playerid, COLOR_RED, "Sei morto ed hai fallito la rapina!");
		new id = GetPlayerBuildingID(playerid);
		if(BuildingInfo[id][bType] == BUILDING_TYPE_AMMUNATION)
		{
			new string[100];
			format(string, sizeof string, "** [ATTENZIONE!] %s ha fallito la rapina all'AmmuNation (%s) **", PlayerInfo[playerid][playerName], GetLocationNameFromCoord(BuildingInfo[id][bEnterX], BuildingInfo[id][bEnterY], BuildingInfo[id][bEnterZ]));
			SendMessageToTeam(TEAM_POLICE, COLOR_LIGHTBLUE, string);
		}
		else if(BuildingInfo[id][bType] == BUILDING_TYPE_ZIP)
		{
			new string[100];
			format(string, sizeof string, "** [ATTENZIONE!] %s ha fallito la rapina dallo Zip (%s) **", PlayerInfo[playerid][playerName], GetLocationNameFromCoord(BuildingInfo[id][bEnterX], BuildingInfo[id][bEnterY], BuildingInfo[id][bEnterZ]));
			SendMessageToTeam(TEAM_POLICE, COLOR_LIGHTBLUE, string);
		}
		else
		{
			new string[100];
			format(string, sizeof string, "** [ATTENZIONE!] %s ha fallito la rapina al %s (%s) **", PlayerInfo[playerid][playerName], GetLocationNameFromCoord(BuildingInfo[id][bEnterX], BuildingInfo[id][bEnterY], BuildingInfo[id][bEnterZ]));
			SendMessageToTeam(TEAM_POLICE, COLOR_LIGHTBLUE, string);
		}
		SetTimerEx("ResetBuildingVar", TIME_TO_RESET_BUILDING, false, "i", RobbingBusiness[playerid]);
		RobbingBusiness[playerid] = -1;
	}
	ResetPlayerWantedLevel(playerid);
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	SetVehicleParamsEx(vehicleid, false, false, false, false, false, false, false);
	if(VehicleInfo[vehicleid][vOwned] == true)
	{
		SetVehiclePos(vehicleid, VehicleInfo[vehicleid][vX], VehicleInfo[vehicleid][vY], VehicleInfo[vehicleid][vZ]+2);
		SetVehicleZAngle(vehicleid, VehicleInfo[vehicleid][vA]);
	}
	if(VehicleInfo[vehicleid][vOwned])
	{
		for(new i = 0; i < 17; i++)
		{
			if(VehicleInfo[vehicleid][vMod][i] == 0)continue;
			if(!IsVehicleComponentLegal(GetVehicleModel(vehicleid), VehicleInfo[vehicleid][vMod][i]))continue;
			AddVehicleComponent(vehicleid, VehicleInfo[vehicleid][vMod][i]);
			if(VehicleInfo[vehicleid][vMod][17] != 3)
			{
				ChangeVehiclePaintjob(vehicleid,VehicleInfo[vehicleid][vMod][17]);
			}
		}
	}
	SetVehicleHealth(vehicleid, 999.0);
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}


public OnPlayerText(playerid, text[])
{
	if(!PlayerInfo[playerid][playerLogged])return 0;
	new textstring[200];
	if(PlayerInfo[playerid][playerTeam] == TEAM_CIVILIAN)
	{
		/*				{PlayerColours}									*/
		/*				1 - 2 Livello Ricercato: Giallo					*/
		/*				3 - 6 Livello Ricercato: Arancione				*/
		/*				7 - 12 Livello Ricercato: Rosso 				*/
		/*				13 > Rosso Scuro     							*/
		if(GetPlayerWantedLevelEx(playerid) == 0)
		{
			format(textstring, sizeof(textstring), EMB_WHITE "%s(%d): %s", PlayerInfo[playerid][playerName], playerid, text);
		}
		if(GetPlayerWantedLevelEx(playerid) > 0 && GetPlayerWantedLevelEx(playerid) < 3)
		{
			format(textstring, sizeof(textstring), EMB_YELLOW "%s" EMB_WHITE "(%d): %s", PlayerInfo[playerid][playerName], playerid, text);
		}
		else if(GetPlayerWantedLevelEx(playerid) >= 3 && GetPlayerWantedLevelEx(playerid) < 7)
		{
			format(textstring, sizeof(textstring), EMB_ORANGE "%s" EMB_WHITE "(%d): %s", PlayerInfo[playerid][playerName], playerid, text);
		}
		else if(GetPlayerWantedLevelEx(playerid) > 7 && GetPlayerWantedLevelEx(playerid) < 12)
		{
			format(textstring, sizeof(textstring), EMB_RED "%s" EMB_WHITE "(%d): %s", PlayerInfo[playerid][playerName], playerid, text);
		}
		else if(GetPlayerWantedLevelEx(playerid) >= 12)
		{
			format(textstring, sizeof(textstring), EMB_DARKRED "%s" EMB_WHITE "(%d): %s", PlayerInfo[playerid][playerName], playerid, text);
		}
		printf("[CIVILE] %s[%d]: %s", PlayerInfo[playerid][playerName], playerid, text);
	}
	else
	{
		format(textstring, sizeof(textstring), EMB_BLUE "%s" EMB_WHITE "(%d): %s", PlayerInfo[playerid][playerName], playerid, text);
		printf("[POLIZIOTTO] %s[%d]: %s", PlayerInfo[playerid][playerName], playerid, text);
	}
	if(playerADuty[playerid] == true)
	{
		format(textstring, sizeof(textstring), EMB_GREEN "%s" EMB_WHITE "(%d): %s", PlayerInfo[playerid][playerName], playerid, text);
		printf("[ADMIN DUTY] %s[%d]: %s", PlayerInfo[playerid][playerName], playerid, text);
	}
	SendMessageToAll(-1, textstring);
	//SendClientMessageToAll(-1, textstring);
	return 0;
}

public OnPlayerCommandReceived(playerid, cmdtext[])
{
	if(!PlayerInfo[playerid][playerLogged])return SendClientMessage(playerid, COLOR_RED, "Prima devi loggare!");
	return 1;
}
public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
	if(!success)return SendClientMessage(playerid, COLOR_SEAGREEN, "Comando inesistente. Utilizza /aiuto per una lista dei comandi.");
	return 1;
}


CMD:addvtoshowroom(playerid, params[])
{
	if(PlayerInfo[playerid][playerAdmin] < 8) return 1;
	new mid, price, sid;
	if(sscanf(params, "ddd",mid, price, sid)) return SendClientMessage(playerid, COLOR_RED, "> /addvtoshowroom <modelid> <price> <showroomid>");
	if(GetPlayerShowroomArea(playerid) != sid) return SendClientMessage(playerid, COLOR_RED, "> You are not near the showroom!");
	if(price <= 0) return SendClientMessage(playerid, COLOR_RED, "> Insert a valid price!");
	if(mid < 400 || mid > 611) return SendClientMessage(playerid, COLOR_RED, "> Insert a valid model id (400 - 611)");
	new Float:X, Float:Y, Float:Z, Float:A, query[200];
	GetPlayerPos(playerid, X,Y,Z);
	GetPlayerFacingAngle(playerid, A);
	new id = CreateShowroomVehicle(sid, mid, price, X,Y,Z,A);
	PutPlayerInVehicle(playerid, id, 0);
	mysql_format(MySQLC, query,sizeof(query), "INSERT INTO showroomcars (modelid, showid, price, posx, posy, posz, posa) VALUES('%d', '%d', '%d', '%f', '%f', '%f', '%f')",mid, sid, price, X,Y,Z,A);
	mysql_tquery(MySQLC, query);
	SendClientMessage(playerid, COLOR_GREENYELLOW, "> Remember to park the vehicle using /parksveh!");
	return 1;
}

CMD:parksveh(playerid, params[])
{
	if(PlayerInfo[playerid][playerAdmin] < 5) return 1;
	if(!IsPlayerInAnyVehicle(playerid)) return 1;
	new id = GetPlayerVehicleID(playerid), sid = GetPlayerShowroomArea(playerid), modelid = GetVehicleModel(id);
	new query[200], Float:X, Float:Y, Float:Z, Float:A;
	GetVehiclePos(id, X,Y,Z);
	GetVehicleZAngle(id, A);
	mysql_format(MySQLC, query,sizeof(query), "UPDATE showroomcars SET posx = '%f', posy = '%f', posz = '%f', posa = '%f' WHERE showid = '%d' AND modelid = '%d'",X,Y,Z,A, sid, modelid);
	mysql_tquery(MySQLC, query);
	SendClientMessage(playerid, COLOR_GREEN, "> You succesfully parked this vehicle");
	return 1;
}

CMD:pc(playerid, params[])
{
	new pcstring[460+139];

	strcat(pcstring,
		EMB_WHITE" BIANCO: Civile, non puo' uccidere nessuno ma puo' rapinare.\n\
		"EMB_YELLOW" GIALLO: Ricercato per piccoli crimini. DEVE essere multato dalla polizia, non arrestato/ucciso\n\
		"EMB_ORANGE" ARANCIONE: Ricercato, deve essere arrestato dalla polizia, nel caso aprisse il fuoco contro un agente, quest'ultimo puo' aprire il fuoco.\n");
	strcat(pcstring,
		EMB_RED" ROSSO: Nemico pubblico. Gli agenti sono autorizzati a sparare a vista.\n\
		"EMB_DARKRED" ROSSO SCURO: L'attuale Most Wanted. All'uccisione di quest'ultimo si riceve un bonus in soldi (solo i poliziotti).\n\
		"EMB_WHITE" Per maggiori informazioni visita il sito: lscnr.it");

	ShowPlayerDialog(playerid, 999, DIALOG_STYLE_MSGBOX, "Colori", pcstring, "Chiudi", "");
	return 1;
}

CMD:skin(playerid, params[])
{
	if(!PlayerInfo[playerid][playerAdmin]) return 1;
	new skin, id;
	if(sscanf(params, "ud", id, skin))return SendClientMessage(playerid, COLOR_RED, "/skin <playerid> <skinid>");
	SetPlayerSkin(id, skin);
	return 1;
}

new lastManualSave[MAX_PLAYERS] = 0;
CMD:saveme(playerid, params[])
{
	if(!PlayerInfo[playerid][playerLogged])return 0;
	#define MANUAL_SAVE_TIME 5
	if((gettime() - lastManualSave[playerid]) < 1*60*MANUAL_SAVE_TIME)return SendClientMessage(playerid, COLOR_RED, "Comando utilizzato recentemente!");
	SendClientMessage(playerid, COLOR_GREEN, "> Salvataggio manuale effettuato con successo!");
	lastManualSave[playerid] = gettime();
	SavePlayer(playerid);
	return 1;
}

CMD:admins(playerid, params[])
{
	SendClientMessage(playerid, -1, "=== Admin Online ===");
	new string[100];
	foreach(new i : Player)
	{
		if(PlayerInfo[i][playerAdmin] == 11)continue;
		if(PlayerInfo[i][playerAdmin] > 0)
		{
			format(string, sizeof(string), "%s[%d] - Livello Admin: %d", PlayerInfo[i][playerName], i, PlayerInfo[i][playerAdmin]);
			SendClientMessage(playerid,  COLOR_YELLOW, string);
		}
	}
	return 1;
}

CMD:taglie(playerid, params[])
{
	new string[50], finalstring[300], count = 0;
	foreach(new i : Player)
	{
		if(!PlayerInfo[i][playerLogged])continue;
		if(PlayerInfo[i][playerRewardMoney] < 1)continue;
		format(string, sizeof(string), EMB_RED"%s"EMB_WHITE"[%d]  -  "EMB_DOLLARGREEN"%s\n", PlayerInfo[i][playerName], i, ConvertPrice(PlayerInfo[i][playerRewardMoney]));
		strcat(finalstring, string, sizeof(finalstring));
		count ++;
	}
	if(count == 0)return ShowPlayerDialog(playerid, 999, DIALOG_STYLE_MSGBOX, "Taglie", "Non ci sono taglie al momento!", "Chiudi", "");
	ShowPlayerDialog(playerid, 999, DIALOG_STYLE_MSGBOX, "Taglie", finalstring, "Chiudi", "");
	return 1;
}

CMD:savehouse(playerid, params[])
{
	new id;
	if(sscanf(params, "i", id))return SendClientMessage(playerid, COLOR_GREY, "/savehouse [houseid]");
	if(HouseInfo[id][hCreated] == false)return SendClientMessage(playerid, COLOR_RED, "Non esiste nessuna casa con questo ID!");
	new string[30];
	format(string, sizeof(string), "** Casa ID %d salvata **", id);
	SendClientMessage(playerid, COLOR_GREEN, string);
	SaveHouse(id);
	return 1;
}



CMD:l(playerid, params[])
{
	new message[100];
	if(sscanf(params, "s[100]", message))return SendClientMessage(playerid, COLOR_GREY, "/l [messaggio]");
	new string[160];
	format(string, sizeof(string), "** [CHAT LOCALE] %s[%d] dice: %s **", PlayerInfo[playerid][playerName], playerid, message);
	SendRangedMessage(playerid, COLOR_PINK, string, 10.0);
	return 1;
}

CMD:taglia(playerid, params[])
{
	new id, money;
	if(sscanf(params, "ui", id, money))return SendClientMessage(playerid, COLOR_GREY, "/taglia [playerid] [importo]");
	if(id == playerid)return SendClientMessage(playerid, COLOR_RED, "Non puoi mettere una taglia su te stesso!");
	if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Il giocatore non e' connesso!");
	if(PlayerInfo[id][playerRewardMoney] > 0)return SendClientMessage(playerid, COLOR_RED, "Questo player possiede gia' una taglia!");
	if(GetPlayerMoneyEx(playerid) < money)return SendClientMessage(playerid, COLOR_RED, "Non possiedi questi soldi!");
	if(money < 19999)return SendClientMessage(playerid, -1, "La taglia deve essere di almeno "EMB_DOLLARGREEN"$20,000");
	PlayerInfo[playerid][playerRewards] ++;
	PlayerInfo[id][playerRewardMoney] = money;
	new string[160];
	format(string, sizeof(string), "** [ATTENZIONE] "EMB_RED"%s[%d]"EMB_WHITE" ha piazzato una taglia di "EMB_DOLLARGREEN"%s"EMB_WHITE" su "EMB_RED"%s"EMB_WHITE"[%d]. **", PlayerInfo[playerid][playerName], playerid, ConvertPrice(money), PlayerInfo[id][playerName], id);
	SendClientMessageToAll(-1, string);
	format(string, sizeof(string), "** [ATTENZIONE] "EMB_RED"%s[%d]"EMB_WHITE" ha piazzato una taglia di "EMB_DOLLARGREEN"%s"EMB_WHITE" su di te. **", PlayerInfo[playerid][playerName], playerid, ConvertPrice(money));
	SendClientMessage(id, COLOR_DARKRED, string);
	GivePlayerMoneyEx(playerid, -money);
	SavePlayer(id);
	SavePlayer(playerid);
	return 1;
}

CMD:usadroga(playerid, params[])
{
	if(PlayerInfo[playerid][playerDrug] < 1)return SendClientMessage(playerid, COLOR_RED, "Non hai droga con te!");
	if(Drugged[playerid] == true)return SendClientMessage(playerid, COLOR_RED, "Hai fatto uso di droghe recentemente!");
	Drugged[playerid] = true;
	SendClientMessage(playerid, COLOR_YELLOW, "Sei sotto effetto di droghe per 30 secondi.");
	SendClientMessage(playerid, COLOR_YELLOW, "Riceverai 10 HP ogni 5 secondi.");
	DruggedTimer[playerid] = SetTimerEx("Drugged2Timer", 5000, true, "i", playerid);
	SetTimerEx("FinishDruggedTimer", 30000, false, "i", playerid);
	return 1;
}

forward Drugged2Timer(playerid);
public Drugged2Timer(playerid)
{
	if(Drugged[playerid] == false)return KillTimer(DruggedTimer[playerid]);
	new Float:HP;
	GetPlayerHealth(playerid, HP);
	if(HP > 90.0)SetPlayerHealth(playerid, 99.0);
	else SetPlayerHealth(playerid, HP+10.0);
	return 1;
}

forward FinishDruggedTimer(playerid);
public FinishDruggedTimer(playerid)
{
	SendClientMessage(playerid, COLOR_YELLOW, "> L'effetto della droga e' finito!");
	Drugged[playerid] = false;
	KillTimer(DruggedTimer[playerid]);
	return 1;
}

CMD:setservertime(playerid, params[])
{
	if(PlayerInfo[playerid][playerAdmin] >= 5)
	{
		new time1, time2;
		if(sscanf(params, "ii", time1, time2))return SendClientMessage(playerid, COLOR_GREY, "/setservertime [Minuti] [Secondi]");
		if(time1 > 24 || time2 > 60)return SendClientMessage(playerid, COLOR_RED, "Tempo non valido.");
		if(time1 < 0 || time2 < 0)return SendClientMessage(playerid, COLOR_RED, "Tempo non valido.");
		clockMins = time1;
		clockSec = time2;
	}
	return 1;
}

CMD:giveskill(playerid, params[])
{
	if(PlayerInfo[playerid][playerAdmin] >= 5)
	{
		new id, skillid,skillpoint;
		if(sscanf(params, "udd", id, skillid, skillpoint))return SendClientMessage(playerid, COLOR_GREY, "/giveskill <playerid/partofname> <skillid> <points>");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Il giocatore non e' connesso!");
		PlayerSkill[id][ENUM_SKILLS: skillid] += skillpoint;
	}
	return 1;
}

CMD:setvehiclecolor(playerid, params[])
{
	if(PlayerInfo[playerid][playerAdmin] >= 3)
	{
		new vid, id1, id2;
		if(sscanf(params, "iii", vid, id1, id2))return SendClientMessage(playerid, COLOR_GREY, "/colori [vehicleid] [colore1] [colore2]");
		if(id1 < 0 || id1 > 255)return SendClientMessage(playerid, COLOR_RED, "I colore non deve essere minore di 0 o superiore a 255");
		if(id2 < 0 || id2 > 255)return SendClientMessage(playerid, COLOR_RED, "I colore non deve essere minore di 0 o superiore a 255");
		VehicleInfo[vid][vColor1] = id1;
		VehicleInfo[vid][vColor2] = id2;
		ChangeVehicleColor(vid, id1, id2);
	}
	return 1;
}


CMD:colori(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid))
	{
		if(playerBuyingVehicle[playerid] == false)return SendClientMessage(playerid, -1, "Non stai comprando un veicolo!");
		if(showroom_Car[playerid] == 0)return SendClientMessage(playerid, -1, "Non stai comprando un veicolo!");
		new id1, id2;
		if(sscanf(params, "ii", id1, id2))return SendClientMessage(playerid, COLOR_GREY, "/colori [colore1] [colore2]");
		if(id1 < 0 || id1 > 255)return SendClientMessage(playerid, COLOR_RED, "I colore non deve essere minore di 0 o superiore a 255");
		if(id2 < 0 || id2 > 255)return SendClientMessage(playerid, COLOR_RED, "I colore non deve essere minore di 0 o superiore a 255");
		vehicleColor1[playerid] = id1;
		vehicleColor2[playerid] = id2;
		ChangeVehicleColor(showroom_Car[playerid], vehicleColor1[playerid], vehicleColor2[playerid]);
	}
	return 1;
}

CMD:ritira(playerid, params[])
{
	if(!IsPlayerAtATM(playerid))return SendClientMessage(playerid, COLOR_RED, "Non ti trovi nelle vicinanze di un ATM!");
	new money;
	if(sscanf(params, "i", money))return SendClientMessage(playerid, COLOR_GREY, "/ritira [importo]");
	if(money > PlayerInfo[playerid][playerBank])return SendClientMessage(playerid, COLOR_RED, "Non possiedi questi soldi!");
	if(money < 1)return SendClientMessage(playerid, COLOR_RED, "Non possiedi questi soldi!");
	PlayerInfo[playerid][playerBank] -= money;
	new string[45+15+15+30];
	format(string, sizeof(string), "** Hai ritirato "EMB_DOLLARGREEN"%s"EMB_WHITE". Nuovo bilancio: "EMB_DOLLARGREEN"%s"EMB_WHITE" **", ConvertPrice(money), ConvertPrice(PlayerInfo[playerid][playerBank]));
	SendClientMessage(playerid, -1, string);
	GivePlayerMoneyEx(playerid, money);
	SavePlayer(playerid);
	return 1;
}

CMD:bilancio(playerid, params[])
{
	if(!IsPlayerAtATM(playerid))return SendClientMessage(playerid, COLOR_RED, "Non ti trovi nelle vicinanze di un ATM!");
	new string[75];
	format(string, sizeof(string), "** Bilancio Bancario: "EMB_DOLLARGREEN"%s"EMB_WHITE" **", ConvertPrice(PlayerInfo[playerid][playerBank]));
	SendClientMessage(playerid, -1, string);
	return 1;
}

/*				{Police Commands}				*/

CMD:segnala(playerid, params[])
{
	if(PlayerInfo[playerid][playerTeam] == TEAM_POLICE)
	{
		//if(PlayerSkill[playerid][skillPolice] < 30)return SendClientMessage(playerid, COLOR_RED, "Non puoi ancora utilizzare questo comando. Devi avere l'abilit� '' Poliziotto '' a 30.");
		new id, rsn[32];
		if(sscanf(params, "us[30]", id, rsn))return SendClientMessage(playerid, COLOR_GREY, "/segnala [playerid/partofname] [motivo]");
		if(id == playerid)return SendClientMessage(playerid, COLOR_RED, "Non puoi segnalare te stesso!");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Il giocatore non e' connesso!");
		if(PlayerInfo[id][playerTeam] == TEAM_POLICE)return SendClientMessage(playerid, COLOR_RED, "Non puoi sengnalare un poliziotto!");
		if(GetPlayerWantedLevelEx(id) >= 2)return SendClientMessage(playerid, COLOR_RED, "Il giocatore e' gia' ricercato!");
		new string[160];
		format(string, sizeof(string), "Hai segnalato %s[%d]. Motivo: %s", PlayerInfo[id][playerName], id, rsn);
		SendClientMessage(playerid, COLOR_GREEN, string);
		format(string, sizeof(string), "Sei stato segnalato da %s[%d]. Motivo: %s ", PlayerInfo[playerid][playerName], playerid, rsn);
		GivePlayerWantedLevelEx(id, 2, string);
		format(string, sizeof(string), "** [ATTENZIONE!] %s[%d] ha segnalato %s[%d]. Motivo: %s **", PlayerInfo[playerid][playerName], playerid, PlayerInfo[id][playerName], id, rsn);
		SendMessageToTeam(TEAM_POLICE, COLOR_BLUE, string);
	}
	else
	{
		SendClientMessage(playerid, COLOR_RED, "Non sei un poliziotto!");
	}
	return 1;
}

CMD:strisce(playerid, params[])
{
	if(PlayerInfo[playerid][playerTeam] != TEAM_POLICE)return SendClientMessage(playerid, COLOR_RED, "Non sei un poliziotto!");
	if(PlayerSkill[playerid][skillPolice] < 20)return SendClientMessage(playerid, COLOR_RED, "Non sei del rank adatto per utilizzare questo comando!");
	if(IsPlayerInAnyVehicle(playerid))return SendClientMessage(playerid, COLOR_RED, "Non puoi utilizzare questo comando in un veicolo!");
	if(Stinger_IsValid(playerSpikeStrip[playerid]))
	{
		Stinger_Delete(playerSpikeStrip[playerid]);
		KillTimer(playerSpikeStripTimer[playerid]);
		playerSpikeStrip[playerid] = INVALID_OBJECT_ID;
		SendClientMessage(playerid, COLOR_GREEN, "Striscia chiodata rimossa con successo!");
		return 1;
	}
	new
	Float:X,
	Float:Y,
	Float:Z,
	Float:A;
	GetPlayerPos(playerid, X, Y, Z);
	Z = GetPointZPos(X, Y);
	GetPlayerFacingAngle(playerid, A);
	playerSpikeStrip[playerid] = SpikeStrip_Create(SPIKE_STRIP_SHORT, X, Y, Z, A);
	playerSpikeStripTimer[playerid] = SetTimerEx("RemovePlayerStrip", 180000, false, "i", playerid);
	SendClientMessage(playerid, COLOR_GREEN, "Hai piazzato una striscia chiodata, si rimuovera' automaticamente tra 3 minuti.");
	SendClientMessage(playerid, COLOR_GREEN, "Oppure puoi utilizzare di nuovo /strisce (/ps) per rimuoverla.");
	return 1;
}

CMD:ps(playerid, params[])return cmd_strisce(playerid, params);

forward RemovePlayerStrip(playerid);
public RemovePlayerStrip(playerid)
{
	SendClientMessage(playerid, COLOR_GREEN, "Striscia rimossa automaticamente!");
	Stinger_Delete(playerSpikeStrip[playerid]);
	return 1;
}

CMD:radio(playerid, params[])
{
	if(PlayerInfo[playerid][playerTeam] != TEAM_POLICE)return SendClientMessage(playerid, COLOR_RED, "Non sei un poliziotto!");
	new text[64];
	if(sscanf(params, "s[60]", text))return SendClientMessage(playerid, COLOR_GREY, "[/r]adio <messaggio>");
	new string[160];
	format(string, sizeof(string), "** Radio ** [%s] %s [%d]: %s, passo.", GetPlayerRank(playerid), PlayerInfo[playerid][playerName], playerid, text);
	SendMessageToTeam(TEAM_POLICE, COLOR_LIGHTBLUE, string);
	return 1;
}

CMD:r(playerid, params[])
{
	return cmd_radio(playerid, params);
}

stock GetPlayerRank(playerid)
{
	new txt[18];
	if(PlayerInfo[playerid][playerTeam] == TEAM_POLICE)
	{
		switch(PlayerSkill[playerid][skillPolice])
		{
			case 0 .. 19: txt = "Cadetto";
			case 20 .. 35: txt = "Agente";
			case 36 .. 50: txt = "Ufficiale";
			case 51 .. 60: txt = "Detective";
			case 61 .. 75: txt = "Sergente";
			case 76 .. 85: txt = "Tenente";
			case 86 .. 95: txt = "Capitano";
			case 96 .. 110: txt = "Generale";
			default: txt = "Comandante";
		}
	}
	return txt;
}

CMD:taze(playerid, params[])
{
	if(PlayerInfo[playerid][playerTeam] == TEAM_POLICE)
	{
		new id;
		if(sscanf(params, "u", id))return SendClientMessage(playerid, COLOR_GREY, "/taze [playerid/partofname]");
		if(id == playerid)return SendClientMessage(playerid, COLOR_RED, "Non puoi tazerare te stesso!");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Il giocatore non e' connesso!");
		if(IsPlayerInAnyVehicle(playerid))return SendClientMessage(playerid, COLOR_RED, "Non puoi utilizzare questo comando in un veicolo!");
		if(IsPlayerInAnyVehicle(id))return SendClientMessage(playerid, COLOR_RED, "Questo giocatore e' in un veicolo!");
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		if(!IsPlayerInRangeOfPoint(id, 3.0, x, y, z))return SendClientMessage(playerid, COLOR_RED, "Non sei abbastanza vicino al Player!");
		if(PlayerInfo[id][playerTeam] == TEAM_POLICE)return SendClientMessage(playerid, COLOR_RED, "Non puoi tazeraree un poliziotto!");
		if(PlayerInfo[id][playerWanted] == 0 || Cuffed[id] == true)return SendClientMessage(playerid, COLOR_RED, "Non puoi tazerare questo Player!");
		if(Tazed[id] == true)return SendClientMessage(playerid, COLOR_RED, "Giocatore gia' tazerato!");
		new string[50];
		format(string, sizeof(string), "Hai tazerato %s!", PlayerInfo[id][playerName]);
		SendClientMessage(playerid, COLOR_GREEN, string);
		format(string, sizeof(string), "Sei stato tazerato da %s!", PlayerInfo[playerid][playerName]);
		SendClientMessage(id, COLOR_GREEN, string);
		Tazed[id] = true;
		ClearAnimations(id);
		ApplyAnimation(id, "CRACK", "crckdeth2", 4.0, 1, 0, 0, MAX_TAZER_TIME, 0);
		SetTimerEx("UnTazePlayer", MAX_TAZER_TIME, false, "i", id);
	}
	else
	{
		SendClientMessage(playerid, COLOR_RED, "Non sei un poliziotto!");
	}
	return 1;
}

forward UnTazePlayer(playerid);
public UnTazePlayer(playerid)
{
	if(Tazed[playerid] == true)
	{
		GameTextForPlayer(playerid, "~g~L'effetto del tazer e' finito!", 3000, 3);
		Tazed[playerid] = false;
		ClearAnimations(playerid);
	}
	return 1;
}

new bool:rmUsed[MAX_PLAYERS];
CMD:rompimanette(playerid, params[])
{
	if(Cuffed[playerid] == false)return SendClientMessage(playerid, COLOR_RED, "Non sei ammanettato!");
	if(rmUsed[playerid] == true)return SendClientMessage(playerid, COLOR_RED, "Comando usato recentemente!");
	new rand = random(100)+1;
	#define BRONZE_POSSIBILITY 35
	#define SILVER_POSSIBILITY 40
	#define GOLD_POSSIBILITY 50
	if(PlayerInfo[playerid][playerPremium] == PLAYER_PREMIUM_BRONZE)
	{
		switch(rand)
		{
			case 0 .. BRONZE_POSSIBILITY:
			{
				new string[100];
				UnFreezePlayer(playerid);
				Cuffed[playerid] = false;
				format(string, sizeof(string), "** %s[%d] ha rotto le manette! **", PlayerInfo[playerid][playerName], playerid);
				SendRangedMessage(playerid, COLOR_LIGHTBLUE, string, 10.0);
				GivePlayerWantedLevelEx(playerid, 6, "** Crimine Commesso: Resistenza all'arresto **");
			}
			default:
			{
				new string[100];
				format(string, sizeof(string), "** %s[%d] ha tentato di rompere le manetta, fallendo! **", PlayerInfo[playerid][playerName], playerid);
				SendRangedMessage(playerid, COLOR_LIGHTBLUE, string, 10.0);
				FreezePlayer(playerid);
				Cuffed[playerid] = true;
			}
		}
	}
	else if(PlayerInfo[playerid][playerPremium] == PLAYER_PREMIUM_SILVER)
	{
		switch(rand)
		{
			case 0 .. SILVER_POSSIBILITY:
			{
				new string[100];
				UnFreezePlayer(playerid);
				Cuffed[playerid] = false;
				format(string, sizeof(string), "** %s[%d] ha rotto le manette! **", PlayerInfo[playerid][playerName], playerid);
				SendRangedMessage(playerid, COLOR_LIGHTBLUE, string, 10.0);
				GivePlayerWantedLevelEx(playerid, 6, "** Crimine Commesso: Resistenza all'arresto **");
			}
			default:
			{
				new string[100];
				format(string, sizeof(string), "** %s[%d] ha tentato di rompere le manetta, fallendo! **", PlayerInfo[playerid][playerName], playerid);
				SendRangedMessage(playerid, COLOR_LIGHTBLUE, string, 10.0);
				FreezePlayer(playerid);
				Cuffed[playerid] = true;
			}
		}
	}
	else if(PlayerInfo[playerid][playerPremium] == PLAYER_PREMIUM_GOLD)
	{
		switch(rand)
		{
			case 0 .. GOLD_POSSIBILITY:
			{
				new string[100];
				UnFreezePlayer(playerid);
				Cuffed[playerid] = false;
				format(string, sizeof(string), "** %s[%d] ha rotto le manette! **", PlayerInfo[playerid][playerName], playerid);
				SendRangedMessage(playerid, COLOR_LIGHTBLUE, string, 10.0);
				GivePlayerWantedLevelEx(playerid, 6, "** Crimine Commesso: Resistenza all'arresto **");
			}
			default:
			{
				new string[100];
				format(string, sizeof(string), "** %s[%d] ha tentato di rompere le manetta, fallendo! **", PlayerInfo[playerid][playerName], playerid);
				SendRangedMessage(playerid, COLOR_LIGHTBLUE, string, 10.0);
				FreezePlayer(playerid);
				Cuffed[playerid] = true;
			}
		}
	}
	else
	{
		switch(rand)
		{
			case 0 .. 30:
			{
				new string[100];
				UnFreezePlayer(playerid);
				Cuffed[playerid] = false;
				format(string, sizeof(string), "** %s[%d] ha rotto le manette! **", PlayerInfo[playerid][playerName], playerid);
				SendRangedMessage(playerid, COLOR_LIGHTBLUE, string, 10.0);
				GivePlayerWantedLevelEx(playerid, 6, "** Crimine Commesso: Resistenza all'arresto **");
			}
			default:
			{
				new string[100];
				format(string, sizeof(string), "** %s[%d] ha tentato di rompere le manetta, fallendo! **", PlayerInfo[playerid][playerName], playerid);
				SendRangedMessage(playerid, COLOR_LIGHTBLUE, string, 10.0);
				FreezePlayer(playerid);
				Cuffed[playerid] = true;
			}
		}
	}
	rmUsed[playerid] = true;
	SetTimerEx("ClearRMUsed", 180*1000, false, "i", playerid);
	return 1;
}

forward ClearRMUsed(playerid);
public ClearRMUsed(playerid)
{
	rmUsed[playerid] = false;
	return 1;
}

CMD:rm(playerid, params[])return cmd_rompimanette(playerid, params);
CMD:breakcuff(playerid, params[])return cmd_rompimanette(playerid, params);
CMD:bk(playerid, params[])return cmd_rompimanette(playerid, params);

CMD:arresta(playerid, params[])
{
	if(PlayerInfo[playerid][playerTeam] == TEAM_POLICE)
	{
		new id;
		if(sscanf(params, "u", id))return SendClientMessage(playerid, COLOR_GREY, "- /arresta [playerid/partofname] -");
		if(id == playerid)return SendClientMessage(playerid, COLOR_RED, "Non puoi arrestarti da solo!");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Il giocatore non e' connesso!");
		if(Cuffed[id] == false)return SendClientMessage(playerid, COLOR_RED, "Il giocatore deve essere ammanettato!");
		if(PlayerInfo[id][playerDead] == true)return SendClientMessage(playerid, COLOR_RED, "Non puoi ammanettare questo giocatore!");
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		if(!IsPlayerInRangeOfPoint(id, 5.0, x, y, z))return SendClientMessage(playerid, COLOR_RED, "Non sei abbastanza vicino al Player!");
		if(PlayerInfo[id][playerTeam] == TEAM_POLICE)return SendClientMessage(playerid, COLOR_RED, "Non puoi arrestare un poliziotto!");
		if(GetPlayerWantedLevelEx(id) < 3)return SendClientMessage(playerid, COLOR_RED, "Non puoi arrestare questo Player!");
		PlayerInfo[id][playerJailTime] = JailTimeByWantedLevel(id);
		KillTimer(TimeCounter__[id]), KillTimer(RobberyTimer__[id]), KillTimer(UnJailTimer__[id]), KillTimer(RobberyTimer__[id]);
		SetPlayerInterior(id, 6);
		PlayerInfo[id][playerDrug] = 0;
		PlayerInfo[id][playerC4] = 0;
		SetPlayerPos(id, 264.6123,77.6957,1001.0391);
		SetPlayerVirtualWorld(id, id);
		new string[200];
		format(string, sizeof(string), "Sei stato arrestato da "EMB_RED"%s"EMB_WHITE"[%d] per %d secondi.", PlayerInfo[playerid][playerName], playerid, PlayerInfo[id][playerJailTime]);
		SendClientMessage(id, -1, string);
		format(string, sizeof(string), "Hai arrestato "EMB_RED"%s"EMB_WHITE"[%d] per %d secondi ricevendo "EMB_DOLLARGREEN"%s"EMB_WHITE" ed 1 ticket!", PlayerInfo[id][playerName], id, PlayerInfo[id][playerJailTime], ConvertPrice(ToggleMoneyByWantedLevel(id)));
		SendClientMessage(playerid, -1, string);
		GivePlayerMoneyEx(playerid, ToggleMoneyByWantedLevel(id));
		format(string, sizeof(string), "** [POLIZIA] ** [%s] %s(%d) ha arrestato %s(%d).", GetPlayerRank(playerid), PlayerInfo[playerid][playerName], playerid, PlayerInfo[id][playerName], id);
		SendMessageToTeam(TEAM_POLICE, COLOR_LIGHTBLUE, string);
		TogglePlayerControllable(id, 1);
		UnJailTimer__[id] = SetTimerEx("UnJailPlayer", PlayerInfo[id][playerJailTime]*1000, false, "i", id);
		TimeCounter(id, PlayerInfo[id][playerJailTime]);
		PlayerSkill[playerid][skillPolice] ++;
		PlayerInfo[playerid][playerTickets] ++;
		Cuffed[id] = false;
		PlayerInfo[playerid][playerWeapAllowed] = false;
		playerLoot[id] = 0;
		playerInBank[id] = false;
		PlayerTextDrawHide(id, TextLoot[id]);
		PlayerTextDrawHide(id, InfoText[id]);
		PlayerTextDrawHide(id, InfoText2[id]);
		//GivePlayerMoneyEx(id, -ToggleMoneyByWantedLevel(id));
		ResetPlayerWantedLevel(id);
	}
	else
	{
		SendClientMessage(playerid, COLOR_RED, "Non sei un poliziotto!");
	}
	return 1;
}
CMD:ar(playerid, params[])return cmd_arresta(playerid, params);
stock ToggleMoneyByWantedLevel(playerid)
{
	if(GetPlayerWantedLevelEx(playerid) > 0 && 3 > GetPlayerWantedLevelEx(playerid))
	{
		return 5000;
	}
	else if(GetPlayerWantedLevelEx(playerid) > 2 && 7 > GetPlayerWantedLevelEx(playerid))
	{
		return 10000;
	}
	else if(GetPlayerWantedLevelEx(playerid) > 7 && 12 > GetPlayerWantedLevelEx(playerid))
	{
		return 15000;
	}
	else if(GetPlayerWantedLevelEx(playerid) >= 12 && 20 > GetPlayerWantedLevelEx(playerid))
	{
		return 20000;
	}
	else if(GetPlayerWantedLevelEx(playerid) > 20 && 50 > GetPlayerWantedLevelEx(playerid))
	{
		return 30000;
	}
	else if(GetPlayerWantedLevelEx(playerid) > 50)
	{
		return 50000;
	}
	return 10000;
}

CMD:ammanetta(playerid, params[])
{
	if(PlayerInfo[playerid][playerTeam] == TEAM_POLICE)
	{
		new id;
		if(sscanf(params, "u", id))return SendClientMessage(playerid, COLOR_GREY, " [/am]manetta [playerid/partofname]");
		if(id == playerid)return SendClientMessage(playerid, COLOR_RED, "Non puoi ammanettarti da solo!");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Il giocatore non e' connesso!");
		if(IsPlayerInAnyVehicle(playerid))return SendClientMessage(playerid, COLOR_RED, "Non puoi utilizzare questo comando in un veicolo!");
		if(IsPlayerInAnyVehicle(id))return SendClientMessage(playerid, COLOR_RED, "Questo giocatore e' in un veicolo!");
		if(PlayerInfo[id][playerDead] == true)return SendClientMessage(playerid, COLOR_RED, "Non puoi ammanettare questo giocatore!");
		if(Cuffed[id] == false)//giocatore non Cuffed
		{
			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
			if(!IsPlayerInRangeOfPoint(id, 5.0, x, y, z))return SendClientMessage(playerid, COLOR_RED, "Non sei abbastanza vicino al Player!");
			if(PlayerInfo[id][playerTeam] == TEAM_POLICE)return SendClientMessage(playerid, COLOR_RED, "Non puoi ammanettare un poliziotto!");
			if(PlayerInfo[id][playerWanted] == 0)return SendClientMessage(playerid, COLOR_RED, "Non puoi ammanettare questo Player!");
			FreezePlayer(id);
			Cuffed[id] = true;
			new string[50];
			format(string, sizeof(string), "Hai ammanettato %s!", PlayerInfo[id][playerName]);
			SendClientMessage(playerid, COLOR_GREEN, string);
			format(string, sizeof(string), "Sei stato ammanettato da %s!", PlayerInfo[playerid][playerName]);
			SendClientMessage(id, COLOR_GREEN, string);
			SendClientMessage(id, COLOR_GREEN, "Ricorda che puoi utilizzare /rm (/rompimanette) per tentare di scappare!");
			SendClientMessage(playerid, COLOR_GREEN, "Riutilizza [/am]manetta per rimuovere le manette!");
			return 1;
		}
		else if(Cuffed[id] == true)//Player Cuffed
		{
			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
			if(!IsPlayerInRangeOfPoint(id, 5.0, x, y, z))return SendClientMessage(playerid, COLOR_RED, "Non sei abbastanza vicino al Player!");
			if(Cuffed[id] == false)return SendClientMessage(playerid, COLOR_RED, "Questo giocatore non e' ammanettato!");
			UnFreezePlayer(id);
			Cuffed[id] = false;
			new string[50];
			format(string, sizeof(string), "Hai tolto le manette di %s!", PlayerInfo[id][playerName]);
			SendClientMessage(playerid, COLOR_GREEN, string);
			format(string, sizeof(string), "%s ti ha tolto le manette!", PlayerInfo[playerid][playerName]);
			SendClientMessage(id, COLOR_GREEN, string);
			return 1;
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_RED, "Non sei un poliziotto!");
	}
	return 1;
}

CMD:am(playerid, params[])
{
	return cmd_ammanetta(playerid, params);
}

CMD:sfondaporta(playerid, params[])
{
	if(PlayerInfo[playerid][playerTeam] != TEAM_POLICE)return SendClientMessage(playerid, COLOR_RED, "Non sei un poliziotto!");
	if(PlayerSkill[playerid][skillPolice] < 10)return SendClientMessage(playerid, COLOR_RED, "Non sei del rank adatto per utilizzare questo comando!");
	if(IsPlayerInAnyVehicle(playerid))return SendClientMessage(playerid, COLOR_RED, "Non puoi utilizzare questo comando in un veicolo!");
	new houseid = GetPlayerRangedHouse(playerid);
	if(houseid == NO_HOUSE)return SendClientMessage(playerid, COLOR_RED, "Non ti trovi vicino ad una casa!");
	if(HouseInfo[houseid][hClosed] == 0)return SendClientMessage(playerid, COLOR_RED, "La casa e' aperta!");
	HouseInfo[houseid][hClosed] = 0;
	new string[24+35+4+1];
	foreach(new i : Player)
	{
		if(!PlayerInfo[i][playerLogged])continue;
		if(GetPlayerVirtualWorld(i)-999 != houseid)continue;
		if(GetPlayerInterior(i) != HouseInfo[houseid][hInterior])continue;
		if(GetPlayerVirtualWorld(i) != HouseInfo[houseid][hVirtualW])continue;
		format(string, sizeof(string), "** %s ha sfondato la porta della casa **", PlayerInfo[playerid][playerName]);
		SendClientMessage(i, COLOR_PURPLE, string);
	}
	return 1;
}



		/* ========================================================= */

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(Tazed[playerid] == true)return ClearAnimations(playerid);
	if((VehicleInfo[vehicleid][vClosed] == 1) && (!IsVehicleOwnedFromPlayer(playerid, vehicleid)))
	{
		GameTextForPlayer(playerid, "~r~Veicolo Chiuso", 1000, 1);
		ClearAnimations(playerid);
	}
	if((!ispassenger))
	{
		if(IsVehicleOwnedFromPlayer(playerid, vehicleid))
		{
			for(new rand = 0; rand < sizeof(randomVehiclePos); rand++)
			{
				if(VehicleInfo[vehicleid][vX] == randomVehiclePos[rand][0] && VehicleInfo[vehicleid][vY] == randomVehiclePos[rand][1] && VehicleInfo[vehicleid][vZ] == randomVehiclePos[rand][2] && VehicleInfo[vehicleid][vA] == randomVehiclePos[rand][3])
				{
					SendClientMessage(playerid, COLOR_GREEN, "Hai recuperato il tuo veicolo, ricorda di parcheggiarlo.");
					SendClientMessage(playerid, COLOR_GREEN, "La prossima volta stai piu' attento e chiudi il tuo veicolo!");
					break;
				}
			}
		}
	}
	if(VehicleInfo[vehicleid][vShowroom] == true)
	{
		new string[200];
		new sid = GetPlayerShowroomArea(playerid),cid;
		for(new i = 0; i < showroomvehs[sid]; i++)
		{
			if(GetVehicleModel(vehicleid) == ShowroomVehicle[sid][i][sModel]) cid = i;
		}
		format(string,sizeof(string), "Informazioni Veicolo:\n\nNome: %s \nCosto: %s\nVenditore: %s\n\nVuoi effettuare l'acquisto?", GetVehicleName(GetVehicleModel(vehicleid)), ConvertPrice(ShowroomVehicle[sid][cid][sPrice]), ShowroomName[sid]);
		ShowPlayerDialog(playerid, DIALOG_DEALERBUY, DIALOG_STYLE_MSGBOX, "Acquisto", string, "Conferma", "Annulla");
		return 1;
	}
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	foreach(new i : Player)
	{
		if(PlayerInfo[i][playerAdmin] == 0)continue;
		if(PlayerInfo[i][playerLogged] && Spectating[i] == true && playerSpectated[i] == playerid)
		{
			TogglePlayerSpectating(i, 1);
			PlayerSpectatePlayer(i, playerid);
		}
	}

	VehicleDriverID[vehicleid] = INVALID_PLAYER_ID;
	SetVehicleParamsEx(vehicleid, false, false, false, false, false, false, false);
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_PASSENGER || newstate == PLAYER_STATE_DRIVER)
	{
		foreach(new i : Player)
		{
			if(PlayerInfo[i][playerAdmin] == 0)continue;
			if(PlayerInfo[i][playerLogged] && Spectating[i] == true && playerSpectated[i] == playerid)
			{
				TogglePlayerSpectating(i, 1);
				PlayerSpectateVehicle(i, GetPlayerVehicleID(playerid));
			}
		}
	}
	if(newstate == PLAYER_STATE_PASSENGER)
	{
		if(GetPlayerWeapon(playerid) == 24 || GetPlayerWeapon(playerid) == 38)
		{
			new Weap[2];
			GetPlayerWeaponData(playerid, 4, Weap[0], Weap[1]);
			SetPlayerArmedWeapon(playerid, Weap[0]);
			SetPlayerArmedWeapon(playerid, Weap[0]);
		}
		new vehicleid = GetPlayerVehicleID(playerid);
		if(PlayerInfo[playerid][playerTeam] != TEAM_POLICE)
		{
			if(GetPlayerWantedLevelEx(playerid) > 2 && GetVehicleDriverID(vehicleid) != INVALID_PLAYER_ID && GetPlayerWantedLevelEx(GetVehicleDriverID(vehicleid)) < 3)
			{
				GivePlayerWantedLevelEx(GetVehicleDriverID(vehicleid), 3, "** Crimine Commesso: Trasporto di ricercato **");
			}
			if(GetVehicleDriverID(vehicleid) != INVALID_PLAYER_ID && GetPlayerWantedLevelEx(GetVehicleDriverID(vehicleid)) > 2 && GetPlayerWantedLevelEx(playerid) < 3)
			{
				GivePlayerWantedLevelEx(playerid, 3);
			}
		}
	}
	if(newstate == PLAYER_STATE_ONFOOT && oldstate == PLAYER_STATE_DRIVER)
	{
		if(adminVehicleSpawned[playerid] != INVALID_VEHICLE_ID)
		{
			DestroyVehicle(adminVehicleSpawned[playerid]);
			adminVehicleSpawned[playerid] = INVALID_VEHICLE_ID;
		}
	}
	if(newstate == PLAYER_STATE_DRIVER)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		playerLastVehicle[playerid] = vehicleid;
		SetVehicleParamsEx(vehicleid, true, false, false, false, false, false, false);
		if(vehicleid  > 0)
		{
			VehicleDriverID[vehicleid] = playerid;
		}
		if(VehicleInfo[GetPlayerVehicleID(playerid)][vOwned] == true && playerBuyingVehicle[playerid] == false)
		{
			if(!IsVehicleOwnedFromPlayer(playerid, GetPlayerVehicleID(playerid)))
			{
				new string[63+10+24+5];
				format(string, sizeof(string), "Questo veicolo (%s) appartiene a %s.", GetVehicleName(GetVehicleModel(GetPlayerVehicleID(playerid))), VehicleInfo[GetPlayerVehicleID(playerid)][vOwnerName]);
				SendClientMessage(playerid, COLOR_GREEN, string);
			}
			else if(IsVehicleOwnedFromPlayer(playerid, GetPlayerVehicleID(playerid)))
			{
				if(playerBuyingVehicle[playerid] == false && VehicleInfo[GetPlayerVehicleID(playerid)][vOwned] == true)
				{
					SendClientMessage(playerid, COLOR_GREEN, "Bentornato nel tuo veicolo!");
				}
			}
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 523 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 427 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 490 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 528 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 407 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 544 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 596 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 598 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 597 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 599 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 432 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 601 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 520 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 416 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 438)
		{
			if(PlayerInfo[playerid][playerTeam] != TEAM_POLICE)
			{
				SendClientMessage(playerid, COLOR_GREEN, "Non puoi guidare questo veicolo!");
				RemovePlayerFromVehicle(playerid);
			}
		}
	}
	return 1;
}

public OnPlayerEnterDynamicRaceCP(playerid, checkpointid)
{
	if(checkpointid == gps_Checkpoint[playerid])
	{
		SendClientMessage(playerid, COLOR_GREEN, "Sei arrivato a destinazione!");
		DestroyDynamicRaceCP(gps_Checkpoint[playerid]);
		UsingGPS[playerid] = false;
		return 1;
	}
	return 1;
}


forward CanBeRobbedPublic(playerid);
public CanBeRobbedPublic(playerid)
{
	SendClientMessage(playerid, -1, "> Adesso sei rapinabile da tutti <");
	SetPlayerRobbableStatus(playerid, PLAYER_ROBBABLE);
	return 1;
}

public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	if(checkpointid == policeBuyWeaponsCP)
	{
		if(PlayerInfo[playerid][playerTeam] == TEAM_POLICE)
		{
			format(ticketstring, sizeof ticketstring, "9mm (40 colpi) - %d ticket\nDesert Eagle (50 colpi) - %d ticket\n\
				Shotgun (30 colpi) - %d ticket\nShawnoff Shotgun (15 colpi) - %d ticket\nSpas 12 (10 colpi) - %d ticket\n\
				Uzi (100 colpi) - %d ticket\nTec-9 (100 colpi) - %d ticket\nMP5 (150 colpi) - %d ticket\n\
				AK-47 (120 colpi) - %d ticket\nM4 (160 colpi) - %d ticket\nArmatura - %d ticket\nMedikit - %d ticket",
				COLT_TICKET, DEAGLE_TICKET,
				SHOTGUN_TICKET, SHAWNOFF_TICKET, SPAS_TICKET,
				UZI_TICKET, TEC_TICKET, MP5_TICKET,
				AK_TICKET, M4_TICKET,
				ARMOUR_TICKET, MEDIKIT_TICKET);
			new ticks[20+12];
			format(ticks, sizeof ticks, "Armeria (Ticket: %d)", PlayerInfo[playerid][playerTickets]);
			ShowPlayerDialog(playerid, DIALOG_POLICE_WEAPONS, DIALOG_STYLE_LIST, ticks, ticketstring, "Compra", "Annulla");
			return 1;
		}
	}
	for(new i = 0; i < sizeof(ATMPosition); i++)
	{
		if(checkpointid == ATMCheckpoint[i])
		{
			SendClientMessage(playerid, COLOR_PINK, "** Los Santos ATM **");
			SendClientMessage(playerid, COLOR_PINK, "Usa /ritira per ritirare una somma di denaro!");
			SendClientMessage(playerid, COLOR_PINK, "Usa /bilancio per fare un bilancio bancario!");
			return 1;
		}
	}
	if(checkpointid == VehicleRobberyCP)
	{
		if(!IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
		{
			ShowPlayerDialog(playerid, 999, DIALOG_STYLE_MSGBOX, "Sfascio", "Ricorda:\nPuoi rubare i veicoli dei giocatori per portarli qui guadagnando il 20% del costo del veicolo!", "Okay", "");
			return 1;
		}
		else if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			if(PlayerInfo[playerid][playerTeam] == TEAM_POLICE)return SendClientMessage(playerid, COLOR_RED, "I poliziotti non possono rivendere i veicoli!");
			if(VehicleInfo[GetPlayerVehicleID(playerid)][vOwned] == true && !IsVehicleOwnedFromPlayer(playerid, GetPlayerVehicleID(playerid)))//Rivenduto
			{
				PlayerSkill[playerid][skillVehicleStolen] ++;
				new Float:vhp;
				GetVehicleHealth(GetPlayerVehicleID(playerid), vhp);
				new m = random(100*floatround(vhp)/10);
				GivePlayerMoneyEx(playerid, m);
				PlayerInfo[playerid][playerGainVehicleStolen] += m;
				new string[128];
				format(string, sizeof(string), "Hai venduto questo veicolo ("EMB_RED"%s"EMB_WHITE") per "EMB_DOLLARGREEN"%s"EMB_WHITE"", GetVehicleName(GetVehicleModel(GetPlayerVehicleID(playerid))), ConvertPrice(m));
				SendClientMessage(playerid, COLOR_GREEN, string);
				new id = GetPlayerVehicleID(playerid);
				new Float:Pos[3];
				GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
				SetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
				foreach(new i : Player)
				{
					if(PlayerInfo[i][playerLogged] == false)continue;
					if(!IsPlayerInAnyVehicle(i))continue;
					if(i == playerid)continue;
					if(IsPlayerInVehicle(i, id))
					{
						GetPlayerPos(i, Pos[0], Pos[1], Pos[2]);
						SetPlayerPos(i, Pos[0], Pos[1], Pos[2]);
					}
				}
				SetTimerEx("SellVehicle", 600, false, "i", id);
				return 1;
			}
			else if(VehicleInfo[GetPlayerVehicleID(playerid)][vOwned] == true && IsVehicleOwnedFromPlayer(playerid, GetPlayerVehicleID(playerid)) || VehicleInfo[GetPlayerVehicleID(playerid)][vOwned] == false)//Veicolo proprio o pubblico
			{
				return SendClientMessage(playerid, COLOR_RED, "Non puoi rivendere questo veicolo!");
			}
		}
	}
	if(checkpointid == DrugDealerHouseEnter)
	{
		SetPlayerPos(playerid, 318.6152,1116.9098,1083.0386+1);
		SetPlayerFacingAngle(playerid, 359.1479);
		SetPlayerInterior(playerid, 5);
		return 1;
	}
	if(checkpointid == DrugDealerHouseExit)
	{
		SetPlayerPos(playerid, 2167.9387,-1673.2777,15.0821+1);
		SetPlayerFacingAngle(playerid, 217.0205);
		SetPlayerInterior(playerid, 0);
		return 1;
	}
	if(checkpointid == DrugDealerHouseDrug)
	{
		return ShowPlayerDialog(playerid, DIALOG_BUY_DRUG, DIALOG_STYLE_LIST, "Droga", "1g		"EMB_DOLLARGREEN"$1.000"EMB_WHITE"\n10g		"EMB_DOLLARGREEN"$10.000"EMB_WHITE"\n15g		"EMB_DOLLARGREEN"$15.000"EMB_WHITE"\
			\n20g		"EMB_DOLLARGREEN"$20.000"EMB_WHITE, "Avanti", "Esci");
	}
	if(checkpointid == BankEnter && !IsPlayerInAnyVehicle(playerid))
	{
		if(GetServerMinutes() >= 21 || GetServerMinutes() < 8)
		{
			SendClientMessage(playerid, COLOR_PINK, "** Banca Los Santos **");
			SendClientMessage(playerid, COLOR_PINK, "La banca attualmente e' chiusa.");
			SendClientMessage(playerid, COLOR_PINK, "Banca chiusa dalle ore 21:00 alle 08:00");
			return 1;
		}
		playerInBank[playerid] = true;
		SetPlayerPos(playerid, 2311.0596,-14.9670,26.7422);
		SetPlayerFacingAngle(playerid, 270.0990);
		SetPlayerVirtualWorld(playerid, 5);
		SetCameraBehindPlayer(playerid);
		return 1;
	}
	if(checkpointid == BankExit && !IsPlayerInAnyVehicle(playerid))
	{
		playerInBank[playerid] = false;
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid, 1030.1880,-1579.9127,13.4619);
		SetPlayerFacingAngle(playerid, 319.2039);
		SetCameraBehindPlayer(playerid);
		return 1;
	}
	if(checkpointid == BankAction)
	{
		return ShowPlayerDialog(playerid, DIALOG_BANK, DIALOG_STYLE_LIST, "Banca","Ritira Soldi\nDeposita Soldi\nBilancio Bancario", "Continua","Chiudi");
	}
	if(checkpointid == BuyWeapons)
	{
		return ShowPlayerDialog(playerid, DIALOG_AMMU_BUY, DIALOG_STYLE_LIST, "Ammunation", "Pistole\nSMG\nShotguns\nArmatura\nAssalti\nUtilita'", "Avanti", "Chiudi");
	}
	if(checkpointid == CS_PickMoneyCP)
	{
		if(PlayerInfo[playerid][playerTeam] == TEAM_POLICE)
		{
			foreach(new i : Player)
			{
				if(!PlayerInfo[i][playerLogged])continue;
				TogglePlayerDynamicCP(i, CS_PickMoneyCP, false);
			}
			new string[80+24+3+6];
			format(string, sizeof(string), "** Il poliziotto "EMB_BLUE"%s"EMB_WHITE"[%d] ha sventato la rapina al Centro Scommesse!", PlayerInfo[playerid][playerName], playerid);
			SendClientMessageToAll(-1, string);
			new rand = random(100000)+10000;
			format(string, sizeof(string), "** Congratulazioni, hai sventato la rapina al Centro Scommesse ed hai ricevuto "EMB_DOLLARGREEN"%s + 4 tickets.", ConvertPrice(rand));
			SendClientMessage(playerid, -1, string);
			GivePlayerMoneyEx(playerid, rand);
			PlayerSkill[playerid][skillPolice] ++;
			PlayerInfo[playerid][playerTickets] += 4;
			return 1;
		}
		else
		{
			foreach(new i : Player)
			{
				if(!PlayerInfo[i][playerLogged])continue;
				TogglePlayerDynamicCP(i, CS_PickMoneyCP, false);
			}
			new randommoney = 100000+random(100000);
			GivePlayerLootMoney(playerid, randommoney);
			new string[128];
			format(string, sizeof(string), "Hai rapinato il "EMB_RED"Centro Scommesso ed hai ricevuto "EMB_GREEN"%s.", ConvertPrice(randommoney));
			SendClientMessage(playerid, -1, string);
			return 1;
		}
	}
	if(GetPlayerHouseID(playerid) != NO_HOUSE)
	{
		if(checkpointid == HouseInfo[GetPlayerHouseID(playerid)][hRobberyCP])
		{
			ShowInfoText(playerid, "Premi ~y~~k~~CONVERSATION_YES~~w~ per derubare la casa!");
			return 1;
		}
	}
	if(checkpointid == BoxvilleCheckpoint[playerid])
	{
		RemovePlayerAttachedObject(playerid, 0);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		ClearAnimations(playerid);
		DestroyDynamicCP(BoxvilleCheckpoint[playerid]);
		DestroyPlayerProgressBar(playerid, NoiseBar[playerid]);
		KillTimer(PlayerNoiseTimer[playerid]);
		PlayerRobbingHouse[playerid] = true;
		return 1;
	}
	return 1;
}


public OnPlayerLeaveDynamicCP(playerid, checkpointid)
{
	if(GetPlayerBuildingID(playerid) != NO_BUILDING && checkpointid == CS_CheckRobbery)return PlayerTextDrawHide(playerid, InfoText[playerid]);
	if(GetPlayerHouseID(playerid) != NO_HOUSE && checkpointid == HouseInfo[GetPlayerHouseID(playerid)][hRobberyCP])return LeaveInfoText(playerid);
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

forward SellVehicle(vid);
public SellVehicle(vid)
{
	new rand = random(sizeof(randomVehiclePos));
	VehicleInfo[vid][vX] = randomVehiclePos[rand][0];
	VehicleInfo[vid][vY] = randomVehiclePos[rand][1];
	VehicleInfo[vid][vZ] = randomVehiclePos[rand][2];
	VehicleInfo[vid][vA] = randomVehiclePos[rand][3];
	SetVehiclePos(vid, VehicleInfo[vid][vX], VehicleInfo[vid][vY], VehicleInfo[vid][vZ]);
	SetVehicleZAngle(vid, VehicleInfo[vid][vA]);
	SavePlayerVehicle(VehicleInfo[vid][vOwnerID]);
}

public OnPlayerRequestSpawn(playerid)
{
	if(!PlayerInfo[playerid][playerLogged])
	{
		SendClientMessage(playerid, COLOR_RED, "** Prima devi loggare! **");
		return 0;
	}
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

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	if(PlayerInfo[playerid][playerTeam] != TEAM_POLICE && !IsPlayerInAnyVehicle(playerid))
	{
		for(new i = 0; i < sizeof(BagInfo); i++)
		{
			if(pickupid == BagInfo[i][pMoneyBagPickup])
			{
				GivePlayerLootMoney(playerid, BagInfo[i][pMoneyBagMoney]);
				DestroyBagMoney(i);
				return 1;
			}
		}
		for(new i = 0; i < sizeof(MoneyLaundryPosition); i++)
		{
			if(pickupid == MoneyLaundryPickup[i])
			{
				if(playerLoot[playerid] == 0)return SendClientMessage(playerid, -1, "Non hai soldi da riciclare!");
				new string[128];
				format(string, sizeof(string), "Hai riciclato i soldi delle rapine ricevendo "EMB_DOLLARGREEN"%s"EMB_WHITE"", ConvertPrice(playerLoot[playerid]));
				SendClientMessage(playerid, -1, string);
				SendClientMessage(playerid, -1, "Sarai immune al comando /ruba per 1 minuto.");
				CanBeRobbedTimer[playerid] = SetTimerEx("CanBeRobbedPublic",60*1000, false, "i", playerid);
				SetPlayerRobbableStatus(playerid, PLAYER_UNROBBABLE);
				GivePlayerMoneyEx(playerid, playerLoot[playerid]);
				PlayerInfo[playerid][playerGainRobberies] += playerLoot[playerid];
				playerLoot[playerid] = 0;
				PlayerTextDrawHide(playerid, TextLoot[playerid]);
				return 1;
			}
		}
	}
	for(new i = 0; i < BuildingCount__; i++)
	{
		if(pickupid == BuildingInfo[i][bPickup])
		{
			ShowInfoText(playerid, "Premi ~y~~k~~VEHICLE_ENTER_EXIT~~w~ per entrare!", 1000);
			return 1;
		}
		if(pickupid == BuildingInfo[i][bPickupE])
		{
			ShowInfoText(playerid, "Premi ~y~~k~~VEHICLE_ENTER_EXIT~~w~ per uscire!", 1000);
			return 1;
		}
		if(pickupid == BuildingInfo[i][bBuyPickup])
		{
			ShowInfoText(playerid, "Premi ~y~~k~~CONVERSATION_YES~~w~ per interagire!", 1000);
			return 1;
		}
	}
	for(new i = 0; i < MAX_HOUSES; i++)
	{
		if(HouseInfo[i][hCreated] == false)continue;
		if(pickupid == HouseInfo[i][hPickup])
		{
			if(HouseInfo[i][hOwned] == false)
			{
				GameTextForPlayer(playerid, "~w~Premi ~y~~k~~CONVERSATION_YES~~w~ per acquistare", 1500, 4);
			}
			ShowInfoText(playerid,  "Premi ~y~~k~~VEHICLE_ENTER_EXIT~~w~ per entrare!", 1200);
			if(PlayerInfo[playerid][playerHouse] == i)
			{
				ShowInfoText2(playerid, "~y~~k~~SNEAK_ABOUT~~w~ per aprire il menu' della casa!", 1500);
			}
			return 1;
		}
	}
	return 1;
}

forward LeaveInfoText(playerid);
public LeaveInfoText(playerid)
{
	PlayerTextDrawHide(playerid, InfoText[playerid]);
	PlayerTextDrawHide(playerid, InfoText2[playerid]);
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	if(!IsVehicleComponentLegal(GetVehicleModel(vehicleid), componentid))
	{
		new string[128];
		format(string, sizeof(string), "%s ha provato a modificare il suo veicolo con S0beit!");
		SendMessageToAdmin(string, -1);
		return 0;
	}
	/*if(VehicleInfo[vehicleid][vOwned] == true)
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			for(new i = 0; i < 20; i++)
			{
				if(componentid == spoiler[i][0])
				{
					VehicleInfo[vehicleid][vMod][0] = componentid;
					break;
				}
			}
			for(new i = 0; i < 3; i++)
			{
				if(componentid == nitro[i][0])
				{
					VehicleInfo[vehicleid][vMod][1] = componentid;
					break;
				}
			}
			for(new i = 0; i < 23; i++)
			{
				if(componentid == fbumper[i][0])
				{
					VehicleInfo[vehicleid][vMod][2] = componentid;
					break;
				}
			}
			for(new i = 0; i < 22; i++)
			{
				if(componentid == rbumper[i][0])
				{
					VehicleInfo[vehicleid][vMod][3] = componentid;
					break;
				}
			}
			for(new i = 0; i < 28; i++)
			{
				if(componentid == exhaust[i][0])
				{
					VehicleInfo[vehicleid][vMod][4] = componentid;
					break;
				}
			}
			for(new i = 0; i < 2; i++)
			{
				if(componentid == bventr[i][0])
				{
					VehicleInfo[vehicleid][vMod][5] = componentid;
					break;
				}
			}
			for(new i = 0; i < 2; i++)
			{
				if(componentid == bventl[i][0])
				{
					VehicleInfo[vehicleid][vMod][6] = componentid;
					break;
				}
			}
			for(new i = 0; i < 4; i++)
			{
				if(componentid == bscoop[i][0])
				{
					VehicleInfo[vehicleid][vMod][7] = componentid;
					break;
				}
			}
			for(new i = 0; i < 17; i++)
			{
				if(componentid == rscoop[i][0])
				{
					VehicleInfo[vehicleid][vMod][8] = componentid;
					break;
				}
			}
			for(new i = 0; i < 21; i++)
			{
				if(componentid == lskirt[i][0])
				{
					VehicleInfo[vehicleid][vMod][9] = componentid;
					break;
				}
			}
			for(new i = 0; i < 21; i++)
			{
				if(componentid == rskirt[i][0])
				{
					VehicleInfo[vehicleid][vMod][10] = componentid;
					break;
				}
			}
			for(new i = 0; i < 1; i++)
			{
				if(componentid == hydraulics[i][0])
				{
					VehicleInfo[vehicleid][vMod][11] = componentid;
					break;
				}
			}
			for(new i = 0; i < 1; i++)
			{
				if(componentid == base[i][0])
				{
					VehicleInfo[vehicleid][vMod][12] = componentid;
					break;
				}
			}
			for(new i = 0; i < 4; i++)
			{
				if(componentid == rbbars[i][0])
				{
					VehicleInfo[vehicleid][vMod][13] = componentid;
					break;
				}
			}
			for(new i = 0; i < 2; i++)
			{
				if(componentid == fbbars[i][0])
				{
					VehicleInfo[vehicleid][vMod][14] = componentid;
					break;
				}
			}
			for(new i = 0; i < 17; i++)
			{
				if(componentid == wheels[i][0])
				{
					VehicleInfo[vehicleid][vMod][15] = componentid;
					break;
				}
			}
			for(new i = 0; i < 2; i++)
			{
				if(componentid == lights[i][0])
				{
					VehicleInfo[vehicleid][vMod][16] = componentid;
					break;
				}
			}
		}
	}*/
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	VehicleInfo[vehicleid][vMod][17] = paintjobid;
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	VehicleInfo[vehicleid][vColor1] = color1;
	VehicleInfo[vehicleid][vColor2] = color2;
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
	foreach(new i : Player)
	{
		if(PlayerInfo[i][playerAdmin] == 0)continue;
		if(PlayerInfo[i][playerLogged] && Spectating[i] == true && playerSpectated[i] == playerid)
		{
			SetPlayerInterior(i, newinteriorid);
			SetPlayerVirtualWorld(i, GetPlayerVirtualWorld(playerid));
		}
	}
	return 1;
}

//NPC CALLBACKS

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	#pragma tabsize 0
	if(PRESSED(KEY_LOOK_BEHIND))
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsPlayerInAnyVehicle(playerid))
		{
			new engine, lightz, alarm, doors, bonnet, boot, objective;
			GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lightz, alarm, doors, bonnet, boot, objective);
			if(lightz)
			{
				SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, false, alarm, doors, bonnet, boot, objective);
			}
			else
			{
				SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, true, alarm, doors, bonnet, boot, objective);
			}
		}
		return 1;
	}
	if(PRESSED(KEY_SECONDARY_ATTACK))
	{
		//Police Elevator
		if(PlayerInfo[playerid][playerTeam] == TEAM_POLICE)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, 1568.5887,-1689.9709+3,6.2188))
			{
				return ShowPlayerDialog(playerid, DIALOG_POLICE_ELEVATOR, DIALOG_STYLE_LIST, "Ascensore (Parcheggio)", EMB_YELLOW"Parcheggio\n"EMB_WHITE"Stazione di Polizia\nTetto", "Continua", "Annulla");
			}
			if(IsPlayerInRangeOfPoint(playerid, 3.0, 1565.0767,-1667.0001+3,28.3956))
			{
				return ShowPlayerDialog(playerid, DIALOG_POLICE_ELEVATOR, DIALOG_STYLE_LIST, "Ascensore (Stazione di Polizia)", "Parcheggio\n"EMB_YELLOW"Stazione di Polizia\n"EMB_WHITE"Tetto", "Continua", "Annulla");
			}
			if(IsPlayerInRangeOfPoint(playerid, 3.0, 242.2487,66.3135+3,1003.6406))
			{
				return ShowPlayerDialog(playerid, DIALOG_POLICE_ELEVATOR, DIALOG_STYLE_LIST, "Ascensore (Tetto)", "Parcheggio\nStazione di Polizia\n"EMB_YELLOW"Tetto", "Continua", "Annulla");
			}
		}
		if(IsPlayerInRangeOfPoint(playerid, 3.0, 1555.3945, -1675.6084, 16.1953))
		{
			Streamer_UpdateEx(playerid, 246.8096, 62.4316, 1003.6406, 0, 6);
			SetPlayerPos(playerid,246.8096, 62.4316, 1003.6406);
			SetPlayerInterior(playerid, 6);
			SetPlayerFacingAngle(playerid, 358.8265);
			return 1;
		}
		//Police Exit
		if(IsPlayerInRangeOfPoint(playerid, 3.0, 246.8096, 62.4316, 1003.6406))
		{
			Streamer_UpdateEx(playerid, 1555.3945, -1675.6084, 16.1953, 0, 0);
			SetPlayerPos(playerid, 1555.3945, -1675.6084, 16.1953);
			SetPlayerInterior(playerid, 0);
			SetPlayerFacingAngle(playerid, 93.1735);
			return 1;
		}
		for(new i = 0; i < BuildingCount__; i++)
		{
			if(Cuffed[playerid] == true || Tazed[playerid] == true)return 1;
			if(IsPlayerInRangeOfPoint(playerid, 1.5, BuildingInfo[i][bEnterX], BuildingInfo[i][bEnterY], BuildingInfo[i][bEnterZ]))
			{
				Streamer_UpdateEx(playerid, BuildingInfo[i][bExitX], BuildingInfo[i][bExitY], BuildingInfo[i][bExitZ], BuildingInfo[i][bVirtualWorld], BuildingInfo[i][bInterior]);
				SetPlayerPos(playerid, BuildingInfo[i][bExitX], BuildingInfo[i][bExitY], BuildingInfo[i][bExitZ]);
				SetPlayerPos(playerid, BuildingInfo[i][bExitX], BuildingInfo[i][bExitY], BuildingInfo[i][bExitZ]);
				SetPlayerInterior(playerid, BuildingInfo[i][bInterior]);
				SetPlayerVirtualWorld(playerid, BuildingInfo[i][bVirtualWorld]);
				SetPlayerFacingAngle(playerid, BuildingInfo[i][bExitA]);
				playerInBuilding[playerid] = i;
				SetCameraBehindPlayer(playerid);
				if(BuildingInfo[i][bType] == BUILDING_TYPE_AMMUNATION)
				{
					TogglePlayerDynamicCP(playerid, BuyWeapons, true);
				}
				return 1;
			}
		}
		for(new h = 0; h < MAX_HOUSES; h++)
		{
			if(HouseInfo[h][hCreated] == false)continue;
			if(Cuffed[playerid] == true || Tazed[playerid] == true)return 1;
			if(IsPlayerInRangeOfPoint(playerid, 2, HouseInfo[h][hX], HouseInfo[h][hY], HouseInfo[h][hZ]))
			{
				if(HouseInfo[h][hClosed] == 1 && PlayerInfo[playerid][playerHouse] != h)return SendClientMessage(playerid, COLOR_RED, "La casa e' chiusa!");
				SetPlayerPos(playerid, HouseInfo[h][hXu], HouseInfo[h][hYu], HouseInfo[h][hZu]);
				SetPlayerFacingAngle(playerid, -0);
				SetPlayerInterior(playerid, HouseInfo[h][hInterior]);
				SetPlayerVirtualWorld(playerid, HouseInfo[h][hVirtualW]);
				TogglePlayerDynamicCP(playerid, HouseInfo[h][hRobberyCP], true);
				SetCameraBehindPlayer(playerid);
				playerInHouse[playerid] = h;
				break;
			}
		}
		if(GetPlayerHouseID(playerid) != NO_HOUSE)
		{
			if(IsPlayerInRangeOfPoint(playerid, 5.5, HouseInfo[GetPlayerHouseID(playerid)][hXu], HouseInfo[GetPlayerHouseID(playerid)][hYu], HouseInfo[GetPlayerHouseID(playerid)][hZu]))
			{
				if(Cuffed[playerid] == true || Tazed[playerid] == true)return 1;
				new i = GetPlayerHouseID(playerid);
				SetPlayerPos(playerid, HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ]);
				SetPlayerPos(playerid, HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ]);
				SetPlayerFacingAngle(playerid, -0);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				TogglePlayerControllable(playerid, 1);
				TogglePlayerDynamicCP(playerid, HouseInfo[i][hRobberyCP], false);
				SetCameraBehindPlayer(playerid);
				playerInHouse[playerid] = NO_HOUSE;
				return 1;
			}
		}
		if(GetPlayerBuildingID(playerid) != NO_BUILDING)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.5, BuildingInfo[GetPlayerBuildingID(playerid)][bExitX], BuildingInfo[GetPlayerBuildingID(playerid)][bExitY], BuildingInfo[GetPlayerBuildingID(playerid)][bExitZ]) && GetPlayerVirtualWorld(playerid) == BuildingInfo[GetPlayerBuildingID(playerid)][bVirtualWorld])
			{
				if(Cuffed[playerid] == true || Tazed[playerid] == true)return 1;
				new i = GetPlayerBuildingID(playerid);
				if(BuildingInfo[i][bType] == BUILDING_TYPE_AMMUNATION)
				{
					TogglePlayerDynamicCP(playerid, BuyWeapons, true);
				}
				Streamer_UpdateEx(playerid, BuildingInfo[ i ][bEnterX], BuildingInfo[ i ][bEnterY], BuildingInfo[ i ][bEnterZ], 0, 0);
				SetPlayerPos(playerid, BuildingInfo[ i ][bEnterX], BuildingInfo[ i ][bEnterY], BuildingInfo[ i ][bEnterZ]);
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, BuildingInfo[ i ][bEnterX], BuildingInfo[ i ][bEnterY], BuildingInfo[ i ][bEnterZ]);
				SetPlayerVirtualWorld(playerid, 0);
				SetPlayerFacingAngle(playerid, BuildingInfo[ i ][bEnterA]);
				SetCameraBehindPlayer(playerid);
				playerInBuilding[playerid] = NO_BUILDING;
				return 1;
			}
		}
		/**/
	}// End KEY_SECONDARY_ATTACK
	if(PRESSED(KEY_YES) && !IsPlayerInAnyVehicle(playerid))
	{
		if(GetPlayerHouseID(playerid) != NO_HOUSE)
		{
			if(IsPlayerInDynamicCP(playerid, HouseInfo[GetPlayerHouseID(playerid)][hRobberyCP]))
			{
				if(HouseInfo[GetPlayerHouseID(playerid)][hRobbed] == true)return SendClientMessage(playerid, COLOR_RED, "Questa casa e' stata derubata recentemente!");
				if(GetPlayerHouseID(playerid) == PlayerInfo[playerid][playerHouse])return SendClientMessage(playerid, COLOR_RED, "Non puoi derubare in casa tua!");
				if(GetVehicleModel(playerLastVehicle[playerid]) != 498)return SendClientMessage(playerid, COLOR_RED, "L'ultimo veicolo utilizzato deve essere un Boxville!");
				new Float: distance = GetVehicleDistanceFromPoint(playerLastVehicle[playerid], HouseInfo[GetPlayerHouseID(playerid)][hX], HouseInfo[GetPlayerHouseID(playerid)][hY],HouseInfo[GetPlayerHouseID(playerid)][hZ]);
				if(distance > 35)return SendClientMessage(playerid, COLOR_RED, "Il Boxville e' troppo lontano dalla casa!");
				HouseInfo[GetPlayerHouseID(playerid)][hRobbed] = true;
				SetPlayerSpecialAction(playerid, 25);
				new rdn = random(sizeof(HouseRobberyObjects)), string[128];
				format(string, sizeof(string), "Hai derubato ''%s'' dal valore di "EMB_DOLLARGREEN"%s", HouseRobberyObjects[rdn][robberyHouseName], ConvertPrice(HouseRobberyObjects[rdn][robberyHouseMoney]));
				SendClientMessage(playerid, -1, string);
				SetPlayerAttachedObject(playerid, 0, HouseRobberyObjects[rdn][robberyObjectID], 3);
				GivePlayerLootMoney(playerid, HouseRobberyObjects[rdn][robberyHouseMoney]);
				PlayerRobbingHouse[playerid] = true;
				new Float:X, Float:Y, Float:Z;
				GetXYBehindOfVehicle(playerLastVehicle[playerid], X,Y, 4.0);
				if(BoxvilleCheckpoint[playerid] != -1)
				{
					DestroyDynamicCP(BoxvilleCheckpoint[playerid]);
					BoxvilleCheckpoint[playerid] = -1;
				}
				BoxvilleCheckpoint[playerid] = CreateDynamicCP(X, Y, Z+14, 1.5, 0, 0, playerid, 100.0);
				NoiseBar[playerid] = CreatePlayerProgressBar(playerid, 61.00, 329.00, 55.50, 7.19, -86, 100.0);
				ShowPlayerProgressBar(playerid, NoiseBar[playerid]);
				PlayerNoiseTimer[playerid] = SetTimerEx("PlayerNoise", 600, true, "i", playerid);
				SetTimerEx("ResetHouseRobbable", 3*(60*1000), false, "i", GetPlayerHouseID(playerid));
				return 1;
			}
		}
		else if(GetPlayerBuildingID(playerid) != NO_BUILDING)
		{
			if(BuildingInfo[GetPlayerBuildingID(playerid)][bType] == BUILDING_TYPE_STORE ||BuildingInfo[GetPlayerBuildingID(playerid)][bType] == BUILDING_TYPE_STOREV2)
			{
				for(new i = 0; i < sizeof(buyPickupPosition); i++)
				{
					if(IsPlayerInRangeOfPoint(playerid, 1.5, buyPickupPosition[i][0], buyPickupPosition[i][1], buyPickupPosition[i][2]))
					{
						ShowPlayerDialog(playerid, DIALOG_BUSINESS_247, DIALOG_STYLE_LIST, "24/7", "Motosega\nColtello\nTirapugni\nMazza da Baseball\nPortafoglio (Protezione da /ruba)", "Compra", "Annulla");
						return 1;
					}
				}
			}
		}
	}
	if(PRESSED(KEY_YES)) //Start KEY_YES
	{
		if(!IsPlayerInAnyVehicle(playerid))
		{
			//(BuyHouse System)
			for(new i = 0; i < MAX_HOUSES; i++)
			{
				if(HouseInfo[i][hCreated] == false)continue;
				if(IsPlayerInRangeOfPoint(playerid, 1.5, HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ]))
				{
					if(PlayerInfo[playerid][playerHouse] != NO_HOUSE)return SendClientMessage(playerid, COLOR_RED, "Possiedi gia' una casa!");
					if(HouseInfo[i][hOwned] == true)return SendClientMessage(playerid, COLOR_RED, "Questa casa non e' in vendita!");
					if(GetPlayerMoneyEx(playerid) < HouseInfo[i][hPrice])return SendClientMessage(playerid, COLOR_RED, "Non hai abbastanza soldi!");
					GivePlayerMoneyEx(playerid, -HouseInfo[i][hPrice]);
					HouseInfo[i][hOwnerID] = PlayerInfo[playerid][playerID];
					PlayerInfo[playerid][playerHouse] = i;
					HouseInfo[i][hOwned] = true;
					strcpy(HouseInfo[i][OwnerName], PlayerInfo[playerid][playerName], MAX_PLAYER_NAME);
					new string[128];
					format(string, 128, "%s (%d)\nPropietario: %s\n%s", GetLocationNameFromCoord(HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ]), i, HouseInfo[i][OwnerName], (HouseInfo[i][hClosed] == 1) ? (EMB_RED"Chiusa"EMB_WHITE):(EMB_GREEN"Aperta"EMB_WHITE));
					UpdateDynamic3DTextLabelText(HouseInfo[i][hLabel], -1, string);
					DestroyDynamicMapIcon(HouseInfo[i][hMapIcon]);
					HouseInfo[i][hMapIcon] = CreateDynamicMapIcon(HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ], 32, -1, -1, -1, -1, 20.0);
					SaveHouse(i);
					return 1;
				}
			}
			/*robberySystem*/
			if(IsPlayerInDynamicCP(playerid, CS_CheckRobbery))
			{
				if(PlayerInfo[playerid][playerTeam] == TEAM_POLICE)return SendClientMessage(playerid, COLOR_RED, "I poliziotti non possono rapinare!");
				if(PlayerInfo[playerid][playerC4] < 2)return SendClientMessage(playerid, COLOR_RED, "Non hai abbastanza cariche di C4! (Minimo 2 cariche)");
				new bool:canRob = false, count = 0;
				foreach(new i : Player)
				{
					if(i == playerid)continue;
					if(PlayerInfo[i][playerLogged] == false)continue;
					if(PlayerInfo[i][playerTeam] == TEAM_POLICE)
					{
						count ++;
						if(count == 1)
						{
							count = 0;
							canRob = true;
							break;
						}
					}
				}
				if(canRob == false)return SendClientMessage(playerid, COLOR_RED, "Attualmente non ci sono poliziotti online!");
				if(CS_Robbed == true)return SendClientMessage(playerid, COLOR_RED, "Il Centro Scommesse e' stato rapinato recentemente!");
				new string[110];
				format(string, sizeof(string), "Hai piazzato le bombe. Hai %d secondi per allontanarti o rimarrai coinvolto nell'esplosione!", CS_ROBBERY_TIME/1000);
				SendClientMessage(playerid, COLOR_LIGHTRED, string);
				Dynamite[0] = CreateDynamicObject(1654, 824.4000200, 9.6000000, 1004.7000100, 0.0000000, 224.0000000, 98.0000000); //object(dynamite) (1)
				Dynamite[1] = CreateDynamicObject(1654, 824.4000200, 10.6000000, 1004.0999800, 0.0000000, 322.0000000, 85.9980000); //object(dynamite) (2)
				SetTimer("ExplosionCS", CS_ROBBERY_TIME, false);
				SetTimer("ResetCSRobbery", 1800000, false);
				format(string, sizeof(string), "[ATTENZIONE] %s sta tentando di rapinare il Centro Scommesse!", PlayerInfo[playerid][playerName]);
				SendClientMessageToAll(COLOR_LIGHTRED, string);
				PlayerInfo[playerid][playerC4] -= 2;
				GivePlayerWantedLevelEx(playerid, 9, "** Crimine Commesso: Rapina al Centro Scommesse **");
				CS_Robbed = true;
				return 1;
			}
			//withdraw money from Pay'n'Spray
		}
	}//End KEY_YES
	if(PRESSED(KEY_WALK)) //Start KeyWalk
	{
		if(PlayerInfo[playerid][playerHouse] != NO_HOUSE && IsPlayerInRangeOfPoint(playerid, 1.0, HouseInfo[ PlayerInfo[playerid][playerHouse] ][hX], HouseInfo[ PlayerInfo[playerid][playerHouse] ][hY], HouseInfo[ PlayerInfo[playerid][playerHouse] ][hZ]))
		{
			return ShowPlayerDialog(playerid, DIALOG_HOUSE, DIALOG_STYLE_LIST, "Casa", "Apri/Chiudi Casa\nVendi Casa\nRitira Soldi\nDeposita Soldi", "Okay", "Annulla");
		}
	}// END KEYWALK
	/*		Robbery		*/
		/*	Buying Car System		*/
	if(GetPlayerBuildingID(playerid) != NO_BUILDING)
	{
		if(PRESSED(KEY_HANDBRAKE))
		{
			if(BuildingInfo[GetPlayerBuildingID(playerid)][bRobbed] == false)
			{
				if(PlayerInfo[playerid][playerTeam] == TEAM_POLICE)return SendClientMessage(playerid, COLOR_RED, "I poliziotti non possono rapinare i business!");
				if(BuildingInfo[ GetPlayerBuildingID(playerid) ][bRobbed] == true)return SendClientMessage(playerid, COLOR_RED, "Business rapinato recentemente. Riprova più tardi!");
				new buildingid = GetPlayerBuildingID(playerid);
				new string[156];
				if(BuildingInfo[buildingid][bType] == BUILDING_TYPE_AMMUNATION)
				{
					format(string, sizeof string, "** [ATTENZIONE!] %s sta tentando di rapinare l'Ammunation (%s) **", PlayerInfo[playerid][playerName], GetLocationNameFromCoord(BuildingInfo[buildingid][bEnterX], BuildingInfo[buildingid][bEnterY], BuildingInfo[buildingid][bEnterZ]));
					SendMessageToTeam(TEAM_POLICE, COLOR_LIGHTBLUE, string);
				}
				else if(BuildingInfo[buildingid][bType] == BUILDING_TYPE_GYM)
				{
					format(string, sizeof string, "** [ATTENZIONE!] %s sta tentando di rapinare la Palestra (%s) **", PlayerInfo[playerid][playerName], GetLocationNameFromCoord(BuildingInfo[buildingid][bEnterX], BuildingInfo[buildingid][bEnterY], BuildingInfo[buildingid][bEnterZ]));
					SendMessageToTeam(TEAM_POLICE, COLOR_LIGHTBLUE, string);
				}
				else
				{
					format(string, sizeof string, "** [ATTENZIONE!] %s sta tentando di rapinare il %s (%s) **", PlayerInfo[playerid][playerName], BuildingInfo[buildingid][bName], GetLocationNameFromCoord(BuildingInfo[buildingid][bEnterX], BuildingInfo[buildingid][bEnterY], BuildingInfo[buildingid][bEnterZ]));
					SendMessageToTeam(TEAM_POLICE, COLOR_LIGHTBLUE, string);
				}
				SendClientMessage(playerid, -1, "{FFFFFF}Hai iniziato la rapina. Rimani nel cerchio {FF0000}rosso{FFFFFF} fino a fine rapina!");
				BuildingInfo[buildingid][bRobbed] = true;
				TimeCounter(playerid, BuildingInfo[buildingid][bRobberyTime]);
				RobberyTimer__[playerid] = SetTimerEx("BuildingRob", (BuildingInfo[buildingid][bRobberyTime]-1)*1000, false, "ii", playerid, buildingid);
				RobbingBusiness[playerid] = buildingid;
				GivePlayerWantedLevelEx(playerid, 3, "** Crimine Commesso: Rapina a mano armata **");
				ApplyActorAnimation(BuildingInfo[buildingid][bActor], "PED", "handsup", 4.1, 0, 0, 0, 1, 0);
				SetTimerEx("ResetBuildingVar", TIME_TO_RESET_BUILDING, false, "i", GetPlayerBuildingID(playerid));
				return 1;
			}
			else SendClientMessage(playerid, COLOR_RED, " > Il Building e' stato rapinato di recente!");
		}
	}
	return 1;
}

forward PlayerNoise(playerid);
public PlayerNoise(playerid)
{
	if(GetPlayerHouseID(playerid) != NO_HOUSE)
	{
		if(PlayerRobbingHouse[playerid] == true)
		{
			new Float: v = GetPlayerProgressBarValue(playerid, NoiseBar[playerid]);
			if(GetPlayerSpeed(playerid) > 10)
			{
				SetPlayerProgressBarValue(playerid, NoiseBar[playerid], v+20);
			}
			else if(GetPlayerSpeed(playerid) < 10)
			{
				SetPlayerProgressBarValue(playerid, NoiseBar[playerid], v-10);
			}
			//UpdatePlayerProgressBar(playerid, NoiseBar[playerid]);
			v = GetPlayerProgressBarValue(playerid, NoiseBar[playerid]);
			if(v >= 99)
			{
				GivePlayerWantedLevelEx(playerid, 6, "** Hai fatto troppo rumore e ti hanno scoperto. Adesso scappa! **");
				PlayerRobbingHouse[playerid] = false;
				KillTimer(PlayerNoiseTimer[playerid]);
				DestroyPlayerProgressBar(playerid, NoiseBar[playerid]);
				RemovePlayerAttachedObject(playerid, 0);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
				ClearAnimations(playerid);
				DestroyDynamicCP(BoxvilleCheckpoint[playerid]);
				new i = GetPlayerHouseID(playerid);
				SetPlayerPos(playerid, HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ]);
				SetPlayerPos(playerid, HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ]);
				SetPlayerFacingAngle(playerid, -0);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				TogglePlayerControllable(playerid, 1);
				TogglePlayerDynamicCP(playerid, HouseInfo[i][hRobberyCP], false);
				SetCameraBehindPlayer(playerid);
				playerInHouse[playerid] = NO_HOUSE;
				return 1;
			}
		}
		return 1;
	}
	else
	{
		PlayerRobbingHouse[playerid] = false;
		KillTimer(PlayerNoiseTimer[playerid]);
		DestroyPlayerProgressBar(playerid, NoiseBar[playerid]);
		return 1;
	}
}

// Publics Robbery
forward ExplosionCS();
public ExplosionCS()
{
	CreateExplosion(824.2000100, 10.1000000, 1004.2999900, 12, 5);
	DestroyDynamicObject(CSDoor);
	DestroyDynamicObject(Dynamite[0]);
	DestroyDynamicObject(Dynamite[1]);
	foreach(new i : Player)
	{
		if(!PlayerInfo[i][playerLogged])continue;
		TogglePlayerDynamicCP(i, CS_PickMoneyCP, true);
		TogglePlayerDynamicCP(i, CS_CheckRobbery, false);
	}
	CS_Robbed = true;
	return 1;
}

forward ResetCSRobbery();
public ResetCSRobbery()
{
	print("Il Centro Scommesse e' adesso rapinabile");
	CS_Robbed = false;
	CSDoor = CreateDynamicObject(2634,824.2000100,10.1000000,1004.2999900,0.0000000,0.0000000,272.0000000);
	foreach(new i : Player)
	{
		if(!PlayerInfo[i][playerLogged])continue;
		TogglePlayerDynamicCP(i, CS_PickMoneyCP, false);
		TogglePlayerDynamicCP(i, CS_CheckRobbery, true);
	}
	return 1;
}

stock GetPlayerShowroomID(playerid)
{
	for(new i = 1; i<MAX_SHOWROOM; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 1.3, ShowroomPickupPos[i][0], ShowroomPickupPos[i][1], ShowroomPickupPos[i][2]))return i;
	}
	return 0;
}

stock GetPlayerShowroomArea(playerid)
{
	for(new i = 1; i<MAX_SHOWROOM; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 20.0, ShowroomPickupPos[i][0], ShowroomPickupPos[i][1], ShowroomPickupPos[i][2]))return i;
	}
	return 0;
}

stock FreezePlayer(playerid)
{
	TogglePlayerControllable(playerid, false);
}

stock UnFreezePlayer(playerid)
{
	TogglePlayerControllable(playerid, true);
}

forward BuildingRob(playerid, buildingid);
public BuildingRob(playerid, buildingid)
{
	KillTimer(TimeCounter__[playerid]);
	if(RobbingBusiness[playerid] != GetPlayerBuildingID(playerid)) return FailRobbery(playerid);
	new string[128], rand = random(BuildingInfo[buildingid][bMaxMoney]);
	if(BuildingInfo[buildingid][bType] == BUILDING_TYPE_AMMUNATION)
	{
		format(string, sizeof string, EMB_GREY"** %s ha rubato "EMB_DOLLARGREEN"%s"EMB_GREY" dall'%s (%s) **", PlayerInfo[playerid][playerName], ConvertPrice(rand), BuildingInfo[buildingid][bName], GetLocationNameFromCoord(BuildingInfo[buildingid][bEnterX], BuildingInfo[buildingid][bEnterY], BuildingInfo[buildingid][bEnterZ]));
		SendClientMessageToAll(-1, string);
		format(string, sizeof string, "** [ATTENZIONE!] %s ha rubato %s dall'%s (%s) **", PlayerInfo[playerid][playerName], ConvertPrice(rand), GetLocationNameFromCoord(BuildingInfo[buildingid][bEnterX], BuildingInfo[buildingid][bEnterY], BuildingInfo[buildingid][bEnterZ]));
		SendMessageToTeam(TEAM_POLICE, COLOR_LIGHTBLUE, string);
	}
	else if(BuildingInfo[buildingid][bType] == BUILDING_TYPE_GYM)
	{
		format(string, sizeof string, EMB_GREY"** %s ha rubato "EMB_DOLLARGREEN"%s"EMB_GREY" dalla Palestra (%s) **", PlayerInfo[playerid][playerName], ConvertPrice(rand), GetLocationNameFromCoord(BuildingInfo[buildingid][bEnterX], BuildingInfo[buildingid][bEnterY], BuildingInfo[buildingid][bEnterZ]));
		SendClientMessageToAll(-1, string);
		format(string, sizeof string, "** [ATTENZIONE!] %s ha rubato %s dalla %s (%s) **", PlayerInfo[playerid][playerName], ConvertPrice(rand), GetLocationNameFromCoord(BuildingInfo[buildingid][bEnterX], BuildingInfo[buildingid][bEnterY], BuildingInfo[buildingid][bEnterZ]));
		SendMessageToTeam(TEAM_POLICE, COLOR_LIGHTBLUE, string);
	}
	else if(BuildingInfo[buildingid][bType] == BUILDING_TYPE_ZIP)
	{
		format(string, sizeof string, EMB_GREY"** %s ha rubato "EMB_DOLLARGREEN"%s"EMB_GREY" dalla Palestra (%s) **", PlayerInfo[playerid][playerName], ConvertPrice(rand), GetLocationNameFromCoord(BuildingInfo[buildingid][bEnterX], BuildingInfo[buildingid][bEnterY], BuildingInfo[buildingid][bEnterZ]));
		SendClientMessageToAll(-1, string);
		format(string, sizeof string, "** [ATTENZIONE!] %s ha rubato %s dallo %s (%s) **", PlayerInfo[playerid][playerName], ConvertPrice(rand), GetLocationNameFromCoord(BuildingInfo[buildingid][bEnterX], BuildingInfo[buildingid][bEnterY], BuildingInfo[buildingid][bEnterZ]));
		SendMessageToTeam(TEAM_POLICE, COLOR_LIGHTBLUE, string);
	}
	else
	{
		format(string, sizeof string, EMB_GREY"** %s ha rubato "EMB_DOLLARGREEN"%s"EMB_GREY" dal %s (%s) **", PlayerInfo[playerid][playerName], ConvertPrice(rand), BuildingInfo[buildingid][bName], GetLocationNameFromCoord(BuildingInfo[buildingid][bEnterX], BuildingInfo[buildingid][bEnterY], BuildingInfo[buildingid][bEnterZ]));
		SendClientMessageToAll(-1, string);
		format(string, sizeof string, "** [ATTENZIONE!] %s ha rubato %s dal %s (%s) **", PlayerInfo[playerid][playerName], ConvertPrice(rand), BuildingInfo[buildingid][bName], GetLocationNameFromCoord(BuildingInfo[buildingid][bEnterX], BuildingInfo[buildingid][bEnterY], BuildingInfo[buildingid][bEnterZ]));
		SendMessageToTeam(TEAM_POLICE, COLOR_LIGHTBLUE, string);
	}
	PlayerSkill[playerid][skillRobber] ++;
	GivePlayerLootMoney(playerid, rand);
	SendClientMessage(playerid, -1, "Ricorda che per ricevere i soldi, devi riciclarli!");
	SendClientMessage(playerid, -1, "Se non sai dove andare, utilizza '/gps' > 'Riciclaggio'");
	SavePlayer(playerid);
	RobbingBusiness[playerid] = -1;
	return 1;
}

stock FailRobbery(playerid)
{
	LeaveInfoText(playerid);
	if(RobbingBusiness[playerid] != -1)
	{
		KillTimer(TimeCounter__[playerid]);
		KillTimer(RobberyTimer__[playerid]);
		SendClientMessage(playerid, -1, "Sei uscito dal "EMB_RED"checkpoint"EMB_WHITE" ed hai fallito la rapina!");
		new id = GetPlayerBuildingID(playerid);
		if(BuildingInfo[id][bType] == BUILDING_TYPE_AMMUNATION)
		{
			new string[100];
			format(string, sizeof string, "** [ATTENZIONE!] %s ha fallito la rapina all'Ammunation (%s) **", PlayerInfo[playerid][playerName], GetLocationNameFromCoord(BuildingInfo[id][bEnterX], BuildingInfo[id][bEnterY], BuildingInfo[id][bEnterZ]));
			SendMessageToTeam(TEAM_POLICE, COLOR_BLUE, string);
		}
		else if(BuildingInfo[id][bType] == BUILDING_TYPE_ZIP)
		{
			new string[100];
			format(string, sizeof string, "** [ATTENZIONE!] %s ha fallito la rapina allo Zip (%s) **", PlayerInfo[playerid][playerName], GetLocationNameFromCoord(BuildingInfo[id][bEnterX], BuildingInfo[id][bEnterY], BuildingInfo[id][bEnterZ]));
			SendMessageToTeam(TEAM_POLICE, COLOR_BLUE, string);
		}
		else
		{
			new string[100];
			format(string, sizeof string, "** [ATTENZIONE!] %s ha fallito la rapina al %s (%s) **", PlayerInfo[playerid][playerName], BuildingInfo[id][bName], GetLocationNameFromCoord(BuildingInfo[id][bEnterX], BuildingInfo[id][bEnterY], BuildingInfo[id][bEnterZ]));
			SendMessageToTeam(TEAM_POLICE, COLOR_BLUE, string);
		}
		SetTimerEx("ResetBuildingVar", TIME_TO_RESET_BUILDING, false, "i", RobbingBusiness[playerid]);
		RobbingBusiness[playerid] = -1;
	}
	return 1;
}

GetLocationNameFromCoord(Float:X, Float:Y, Float:Z)
{
	#pragma unused Z
	new ZoneName[24];
	Get2DZoneName(X,Y, ZoneName, 24);
	return ZoneName;
}


public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

/*	{Player Commands}		*/
CMD:stats(playerid, params[])
{
	new string[256], Float:Rateo = floatdiv(PlayerInfo[playerid][playerKills], PlayerInfo[playerid][playerDeaths]);
	if(PlayerInfo[playerid][playerKills] == 0 && PlayerInfo[playerid][playerDeaths] == 0)Rateo = 0.00;
	new time[12], tnt[12];
	SendClientMessage(playerid, COLOR_BYELLOW, "===============[STATS]===============");
	format(string, sizeof string, "|- Nome: %s - Soldi: %s - Banca: %s", PlayerInfo[playerid][playerName], ConvertPrice(GetPlayerMoneyEx(playerid)), ConvertPrice(GetPlayerBankMoney(playerid)));
	SendClientMessage(playerid, COLOR_BYELLOW, string);
	format(string, sizeof string, "|- C4: %d - Droga: %d - Tickets: %d", PlayerInfo[playerid][playerC4], PlayerInfo[playerid][playerDrug], PlayerInfo[playerid][playerTickets]);
	SendClientMessage(playerid, COLOR_BYELLOW, string);
	format(string, sizeof string, "|- Rapine: %d - Arresti: %d - Veicoli Rubati: %d - Score: %d", PlayerSkill[playerid][skillRobber], PlayerSkill[playerid][skillPolice], PlayerSkill[playerid][skillVehicleStolen], GetPlayerScore(playerid));
	SendClientMessage(playerid, COLOR_BYELLOW, string);
	format(string, sizeof string, "|- Uccisioni: %d - Morti: %d - Rateo: %.2f", PlayerInfo[playerid][playerKills], PlayerInfo[playerid][playerDeaths], Rateo);
	SendClientMessage(playerid, COLOR_BYELLOW, string);
	format(string, sizeof string, "|- Casa: %d", PlayerInfo[playerid][playerHouse]);
	SendClientMessage(playerid, COLOR_BYELLOW, string);
	if(PlayerInfo[playerid][playerPremium] != PLAYER_NO_PREMIUM)
	{
		switch(PlayerInfo[playerid][playerPremium])
		{
			case PLAYER_PREMIUM_BRONZE: tnt = "Bronzo";
			case PLAYER_PREMIUM_SILVER: tnt = "Argento";
			case PLAYER_PREMIUM_GOLD: tnt = "Oro";
			default: tnt = "BUG/NO";
		}
		//mtime_UnixToDate(time, PlayerInfo[playerid][playerPremiumTime], DATE_LITTLEENDIAN, CLOCK_EUROPEAN);
		format(string, sizeof string, "|- Admin: %d - Premium: %s - Scadenza: %s", GetPlayerAdminLevel(playerid), tnt, time);
	}
	else
	{
		format(string, sizeof string, "|- Admin: %d - Premium: No", GetPlayerAdminLevel(playerid), tnt, PlayerInfo[playerid][playerPremiumTime]);
	}
	SendClientMessage(playerid, COLOR_BYELLOW, string);
	//mtime_UnixToDate(tnt, PlayerInfo[playerid][playerRegisterDate], DATE_LITTLEENDIAN, CLOCK_EUROPEAN);
	SendClientMessage(playerid, COLOR_BYELLOW, "|- Utilizza /mstats (oppure /minfo) per altre informazioni riguardanti il tuo personaggio!");
	format(string, sizeof string, "|- Registrato dal: %s", tnt);
	SendClientMessage(playerid, COLOR_BYELLOW, string);
	return 1;
}
CMD:info(playerid, params[])return cmd_stats(playerid, params);

CMD:mstats(playerid, params[])
{
	SendClientMessage(playerid, COLOR_BYELLOW, "==============================[STATS]==============================");
	new string[200];
	format(string, sizeof string, "|- Soldi guadagnati rapinando: %s - Soldi guadagnati con i furti di veicoli: %s - Soldi guadagnati con la vendita di armi: %s", ConvertPrice(PlayerInfo[playerid][playerGainRobberies]), ConvertPrice(PlayerInfo[playerid][playerGainVehicleStolen]), ConvertPrice(PlayerInfo[playerid][playerGainWeaponsD]));
	SendClientMessage(playerid, COLOR_BYELLOW, string);
	return 1;
}
CMD:minfo(playerid, params[])return cmd_mstats(playerid, params);

//

CMD:gps(playerid, params[])
{
	if(UsingGPS[playerid] == true)
	{
		SendClientMessage(playerid, COLOR_GREEN, "Destinazione eliminata!");
		DestroyDynamicRaceCP(gps_Checkpoint[playerid]);
		UsingGPS[playerid] = false;
		return 1;
	}
	new string[30], fstring[30*10];
	for(new i = 0; i < sizeof(GPS_POS); i++)
	{
		format(string, sizeof(string), "%s\n", GPS_POS[i][gName]);
		strcat(fstring, string, sizeof(fstring));
	}
	ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS", fstring, "Continua", "Chiudi");
	return 1;
}

CMD:cambiapass(playerid, params[])
{
	if(PlayerInfo[playerid][playerLogged])
	{
		new psw[24];
		if(sscanf(params, "s[22]", psw))return SendClientMessage(playerid, COLOR_GREY, "/cambiapass [nuova password]");
		if(strlen(psw) > 22)return SendClientMessage(playerid, COLOR_GREY, "Password troppo lunga!");
		SendClientMessage(playerid, COLOR_GREY, "Password cambiata con successo!");
		new query[128];
		mysql_format(MySQLC, query, sizeof query, "UPDATE `Players` SET Password = md5('%s') WHERE `Name` = '%s' AND `ID` = '%d'", PlayerInfo[playerid][playerName], PlayerInfo[playerid][playerID]);
		mysql_tquery(MySQLC, query);
	}
	return 1;
}

CMD:cambiapassword(playerid, params[])return cmd_cambiapass(playerid, params);
CMD:cambiapsw(playerid, params[])return cmd_cambiapass(playerid, params);

CMD:aiuto(playerid, params[])
{
	SendClientMessage(playerid, -1, "__________[Comandi]__________");
	SendClientMessage(playerid, -1, "[GENERALE]: /vmenu - /paga - /eject - /pm - /taglia - /taglie - /stats");
	SendClientMessage(playerid, -1, "[GENERALE]: /cambiapassword - /dom - /report - /apri - /chiudi - /kill");
	SendClientMessage(playerid, -1, "[GENERALE]: /pc");
	//SendClientMessage(playerid, -1, "[GRUPPO]:   /creagruppo - /gruppo - /gchat - /accetta - /rifiuta - /lasciagruppo");
	if(PlayerInfo[playerid][playerTeam] == TEAM_POLICE)
	{
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "[POLIZIA]: [/am]manetta - /taze - /arresta - /segnala");
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "[POLIZIA]: [/r]adio");
	}
	else if(PlayerInfo[playerid][playerTeam] == TEAM_CIVILIAN)
	{
		SendClientMessage(playerid, -1, "[CIVILE]: /ruba");
	}
	if(PlayerInfo[playerid][playerAdmin] > 0)
	{
		SendClientMessage(playerid, -1, "[ADMIN]: /acmds");
	}
	if(PlayerInfo[playerid][playerPremium] != PLAYER_NO_PREMIUM)
	{
		SendClientMessage(playerid, COLOR_YELLOW, "[PREMIUM]: /togpm - /pchat");
	}
	return 1;
}

CMD:kill(playerid, params[])
{
	if(GetPlayerWantedLevelEx(playerid) > 0)return SendClientMessage(playerid, COLOR_RED, "Non puoi suicidarti se sei ricercato!");
	if(PlayerInfo[playerid][playerJailTime] > 0)return SendClientMessage(playerid, COLOR_RED, "Non puoi utilizzare questo comando in jail!");
	SetPlayerHealth(playerid, 0);
	new string[128];
	format(string, 128, "%s[%d] si e' suicidato utilizzando /kill", PlayerInfo[playerid][playerName], playerid);
	SendClientMessageToAll(COLOR_RED, string);
	return 1;
}

CMD:pm(playerid, params[])
{
	new id, msg[100];
	if(sscanf(params, "us[100]", id, msg))return SendClientMessage(playerid, COLOR_GREY, "/pm [playerid] [messaggio]");
	if(playerid == id)return SendClientMessage(playerid, COLOR_RED, "Non puoi inivare un PM a te stesso!");
	if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Il giocatore non e' connesso!");
	if(TogPM[id] == true)return SendClientMessage(playerid, COLOR_RED, "Il player ha i PM disabilitati!");
	if(TogPM[playerid] == true)return SendClientMessage(playerid, COLOR_RED, "Hai i PM disabilitati. Usa /togpm per abilitarli!");
	new string[150];
	format(string, sizeof(string), "> PM inviato a %s[%d]:", PlayerInfo[id][playerName], id);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "%s", msg);
	SendMessageToPlayer(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "PM da %s[%d]: %s", PlayerInfo[playerid][playerName], playerid, msg);
	SendMessageToPlayer(id, COLOR_YELLOW, string);
	return 1;
}

CMD:togpm(playerid, params[])
{
	if(PlayerInfo[playerid][playerPremium] == PLAYER_NO_PREMIUM)return SendClientMessage(playerid, COLOR_RED, "Solo i Premium possono usare questo comando!");
	switch(TogPM[playerid])
	{
		case false:
		{
			SendClientMessage(playerid, COLOR_YELLOW, "> PM disabilitati!");
			TogPM[playerid] = true;
		}
		case true:
		{
			SendClientMessage(playerid, COLOR_YELLOW, "> PM abilitati!");
			TogPM[playerid] = false;
		}
	}
	return 1;
}

CMD:vmenu(playerid, params[])
{
	if(GetPlayerVehicleCount(playerid) == 0)return SendClientMessage(playerid, COLOR_RED, "Non possiedi veicoli!");
	new string[50], string2[20*MAX_VEHICLE_SLOT], Float:Pos[3], vlistitem = 1, v_loaded = 0;
	for(new i = 0; i < MAX_VEHICLE_SLOT; i++)
	{
		printf("i: %d, viD: %d",i , PlayerVehicle[playerid][i][vID]);
		if(v_loaded == GetPlayerVehicleCount(playerid))break;
		if(PlayerVehicle[playerid][i][vID] == INVALID_VEHICLE_ID)continue;
		GetVehiclePos(PlayerVehicle[playerid][i][vID], Pos[0], Pos[1], Pos[2]);
		if(GetPlayerVehicleID(playerid) == PlayerVehicle[playerid][i][vID])
		{
			format(string, 50, "%s (Attuale)\n", GetVehicleName(VehicleInfo[ PlayerVehicle[playerid][i][vID] ][vModel]));
			strcat(string2, string, sizeof(string2));
			VmenuVehicles[playerid][i] = vlistitem++;
			v_loaded ++;
			continue;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 6.5, Pos[0], Pos[1], Pos[2]))
		{
			format(string, 50, "%s (Vicino)\n", GetVehicleName(VehicleInfo[ PlayerVehicle[playerid][i][vID] ][vModel]));
			strcat(string2, string, sizeof(string2));
			VmenuVehicles[playerid][i] = vlistitem++;
			v_loaded ++;
			continue;
		}
		else
		{
			format(string, 50, "%s\n", GetVehicleName(VehicleInfo[ PlayerVehicle[playerid][i][vID] ][vModel]));
			strcat(string2, string, sizeof(string2));
			VmenuVehicles[playerid][i] = vlistitem++;
			v_loaded ++;
			continue;
		}
	}
	ShowPlayerDialog(playerid, DIALOG_VMENU, DIALOG_STYLE_LIST, "Veicoli", string2, "Seleziona", "Annulla");
	return 1;
}

CMD:chiudi(playerid, params[])
{
	if(GetPlayerVehicleCount(playerid) == 0)return SendClientMessage(playerid, COLOR_RED, "Non possiedi veicoli!");
	new
	bool:vv = false,
	Float:Pos[3];
	for(new i = 1; i < MAX_VEHICLE_SLOT; i++)
	{
		GetVehiclePos(PlayerVehicle[playerid][i][vID], Pos[0], Pos[1], Pos[2]);
		if(!IsPlayerInRangeOfPoint(playerid, 6.0, Pos[0], Pos[1], Pos[2]))continue;
		if(VehicleInfo[PlayerVehicle[playerid][i][vID]][vClosed] == 1)continue;
		new string[128];
		format(string, sizeof(string), "Hai chiuso il tuo veicolo! "EMB_GREEN"(%s)", GetVehicleName(VehicleInfo[PlayerVehicle[playerid][i][vID]][vModel]));
		SendClientMessage(playerid, -1, string);
		VehicleInfo[PlayerVehicle[playerid][i][vID]][vClosed] = 1;
		vv = true;
		break;
	}
	if(vv == false)SendClientMessage(playerid, COLOR_GREEN, "Non ci sono veicoli aperti vicino a te!");
	return 1;
}

CMD:apri(playerid, params[])
{
	if(GetPlayerVehicleCount(playerid) == 0)return SendClientMessage(playerid, COLOR_RED, "Non possiedi veicoli!");
	new
	bool:vv = false,
	Float:Pos[3];
	for(new i = 1; i < MAX_VEHICLE_SLOT; i++)
	{
		GetVehiclePos(PlayerVehicle[playerid][i][vID], Pos[0], Pos[1], Pos[2]);
		if(!IsPlayerInRangeOfPoint(playerid, 6.0, Pos[0], Pos[1], Pos[2]))continue;
		if(VehicleInfo[PlayerVehicle[playerid][i][vID]][vClosed] == 0)continue;
		new string[128];
		format(string, sizeof(string), "Hai aperto il tuo veicolo! "EMB_GREEN"(%s)", GetVehicleName(VehicleInfo[PlayerVehicle[playerid][i][vID]][vModel]));
		SendClientMessage(playerid, -1, string);
		VehicleInfo[PlayerVehicle[playerid][i][vID]][vClosed] = 0;
		vv = true;
		break;
	}
	if(vv == false)SendClientMessage(playerid, COLOR_GREEN, "Non ci sono veicoli chiusi vicino a te!");
	return 1;
}

CMD:paga(playerid, params[])
{
	new id, somma;
	if(sscanf(params, "ud", id, somma))return SendClientMessage(playerid, COLOR_GREY, "/paga [playerid] [somma]");
	if(playerid == id)return SendClientMessage(playerid, COLOR_RED, "Non puoi utilizzare questo comando su di te!");
	if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Il giocatore non e' connesso!");
	new Float:Pos[3];
	GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
	if(!IsPlayerInRangeOfPoint(id, 3.0, Pos[0], Pos[1], Pos[2]))return SendClientMessage(playerid, COLOR_RED, "Il giocatore non e' vicino a te!");
	if(GetPlayerMoneyEx(playerid) < somma)return SendClientMessage(playerid, COLOR_RED, "Non hai tutti questi soldi");
	new string[128];
	format(string, 128, "> "EMB_GREEN"%s"EMB_WHITE" ti ha dato "EMB_DOLLARGREEN"%s"EMB_WHITE"!", PlayerInfo[playerid][playerName], ConvertPrice(somma));
	SendClientMessage(id, -1, string);
	format(string, 128, "Hai dato "EMB_DOLLARGREEN"%s"EMB_WHITE" a "EMB_GREEN"%s"EMB_WHITE"!", ConvertPrice(somma), PlayerInfo[id][playerName]);
	SendClientMessage(playerid, -1, string);
	GivePlayerMoneyEx(id, somma);
	GivePlayerMoneyEx(playerid, -somma);
	return 1;
}

CMD:ruba(playerid, params[])
{
	if(PlayerInfo[playerid][playerTeam] == TEAM_POLICE)return SendClientMessage(playerid, COLOR_RED, "I poliziotti non possono rapinare le persone!");
	if(RobCommandUsed[playerid] == true)return SendClientMessage(playerid, COLOR_RED, "Comando usato recentemente!");
	if(Cuffed[playerid] == true)return SendClientMessage(playerid, COLOR_RED, "Non puoi utilizzare questo comando se sei ammanettato.");
	if(Tazed[playerid] == true)return SendClientMessage(playerid, COLOR_RED, "Non puoi utilizzare questo comando se sei tazerato.");
	if(playerInBank[playerid] == true)return SendClientMessage(playerid, COLOR_RED, "Non puoi utilizzare questo comando in banca.");
	new id;
	if(sscanf(params, "u", id))return SendClientMessage(playerid, COLOR_GREY, "/ruba [playerid]");
	if(playerid == id)return SendClientMessage(playerid, COLOR_RED, "Non puoi utilizzare questo comando su di te!");
	if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Il giocatore non e' connesso!");
	if(PlayerInfo[id][playerAdmin] >= 1 && playerADuty[id] == true)return SendClientMessage(playerid, COLOR_RED, "Non puoi rapinare questo player adesso!");
	if(PlayerInfo[playerid][playerAdmin] >= 1 && playerADuty[playerid] == true)return SendClientMessage(playerid, COLOR_RED, "Non puoi rapinare se sei Admin Duty (/aduty)");
	new Float:Pos[3];
	GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
	if(!IsPlayerInRangeOfPoint(id, 3.0, Pos[0], Pos[1], Pos[2]))return SendClientMessage(playerid, COLOR_RED, "Il giocatore non e' vicino a te!");
	if(IsPlayerInAnyVehicle(id))return SendClientMessage(playerid, COLOR_RED, "Il giocatore e' in un veicolo!");
	if(IsPlayerInAnyVehicle(playerid))return SendClientMessage(playerid, COLOR_RED, "Non puoi usare questo comando in un veicolo!");
	if(Tazed[id] == true)return SendClientMessage(playerid, COLOR_RED, "Non puoi rapinare un player tazato!");
	if(GetPlayerMoneyEx(id) < 1)return SendClientMessage(playerid, COLOR_RED, "Il giocatore non ha soldi!");
	if(!IsPlayerRobbable(id))return SendClientMessage(playerid, COLOR_RED, "Il giocatore non puo' essere rapinato adesso!");
	if(Cuffed[id] == true)return SendClientMessage(playerid, COLOR_RED, "Il giocatore e' ammanettato!");
	GivePlayerWantedLevelEx(playerid, 3, "** Crimine Commesso: Rapina a civile **");
	RobCommandUsed[playerid] = true;
	SetTimerEx("RobCommandUsedReset", 2*60000, false, "ii", playerid, id);
	if(PlayerInfo[id][playerWallet] > 0)
	{
		PlayerInfo[playerid][playerWallet] --;
		SendClientMessage(playerid, COLOR_RED, "** Hai fallito la rapina al giocatore! (Portafogli) **");
		new string[128];
		format(string, sizeof(string), "** %s ha tentato di rapinarti ma ha fallito! (Portafogli) **");
		SendClientMessage(id, COLOR_RED, string);
		return 1;
	}
	new rand = random(GetPlayerMoneyEx(id)), string[128];
	format(string, 128, "~r~%s~w~ ti ha rubato ~g~%s", PlayerInfo[playerid][playerName], ConvertPrice(rand));
	GameTextForPlayer(id, string, 3000, 3);
	format(string, 128, "~w~Hai rubato ~g~%s", ConvertPrice(rand));
	GameTextForPlayer(playerid, string, 3000, 3);
	PlayerSkill[playerid][skillRobber] ++;
	PlayerInfo[playerid][playerGainRobberies] += rand;
	SetPlayerRobbableStatus(id, PLAYER_UNROBBABLE);
	GivePlayerMoneyEx(playerid, rand);
	GivePlayerMoneyEx(id, -rand);
	return 1;
}

forward RobCommandUsedReset(playerid, id);
public RobCommandUsedReset(playerid, id)
{
	RobCommandUsed[playerid] = false;
	SetPlayerRobbableStatus(id, PLAYER_ROBBABLE);
	return 1;
}

CMD:eject(playerid, params[])
{
	if(GetPlayerVehicleSeat(playerid) != 0)return SendClientMessage(playerid, COLOR_LIGHTRED, "Non sei alla guida del veicolo!");
	new id;
	if(sscanf(params, "u",id)) return SendClientMessage(playerid, COLOR_LIGHTRED, "|<  /eject <playerid/partofname> >|");
	if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_LIGHTRED, "Giocatore non connesso!");
	RemovePlayerFromVehicle(id);
	new string[128];
	SendClientMessage(playerid, COLOR_GREY, "> Giocatore cacciato!");
	format(string, 128, "> %s ti ha cacciato dal suo veicolo!", PlayerInfo[playerid][playerName]);
	SendClientMessage(id, COLOR_GREEN, string);
	return 1;
}


// Work System

CMD:vendiarmi(playerid, params[])
{
	if(PlayerInfo[playerid][playerWork] != WORK_WEAPONSD)return SendClientMessage(playerid, COLOR_RED, "Per utilizzare questo comando devi essere un Trafficante d'Armi!");
	new id;
	if(sscanf(params, "u",id)) return SendClientMessage(playerid, COLOR_LIGHTRED, "|<  /vendiarmi <playerid/partofname> >|");
	if(PlayerInfo[id][playerTeam] == TEAM_POLICE)return SendClientMessage(playerid, COLOR_RED, "Non puoi vendere armi ad un poliziotto!");
	if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Il giocatore non e' connesso!");
	new Float:Pos[3];
	GetPlayerPos(id, Pos[0], Pos[1], Pos[2]);
	if(!IsPlayerInRangeOfPoint(playerid, 6.0, Pos[0], Pos[1], Pos[2]))return SendClientMessage(playerid, COLOR_RED, "Il giocatore e' troppo lontano!");
	new string[128];
	format(string, sizeof(string), "** %s vuole venderti delle armi. Usa /armi per accettare **", PlayerInfo[playerid][playerName]);
	SendClientMessage(id, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "** Richiesta inviata a %s **", PlayerInfo[id][playerName]);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	WorkSellerID[id][WORK_WEAPONSD] = playerid;
	BuyerID[playerid] = id;
	return 1;
}

CMD:armi(playerid, params[])
{
	if(PlayerInfo[playerid][playerTeam] == TEAM_POLICE)return SendClientMessage(playerid, COLOR_RED, "Non puoi utilizzare questo comando se sei poliziotto!");
	if(WorkSellerID[playerid][WORK_WEAPONSD] == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Non hai nessuna richiesta per comprare armi!");
	new Float:Pos[3];
	GetPlayerPos(WorkSellerID[playerid][WORK_WEAPONSD], Pos[0], Pos[1], Pos[2]);
	if(!IsPlayerInRangeOfPoint(playerid, 6.0, Pos[0], Pos[1], Pos[2]))return SendClientMessage(playerid, COLOR_RED, "Il giocatore e' troppo lontano!");
	ShowDealerDialog(playerid);
	new string[128];
	format(string, sizeof(string), "** %s ha accettato la tua richiesta! **", PlayerInfo[playerid][playerName]);
	SendClientMessage(WorkSellerID[playerid][WORK_WEAPONSD], COLOR_LIGHTBLUE, string);
	PlayerSkill[WorkSellerID[playerid][WORK_WEAPONSD]][skillWeaponsD] ++;
	SavePlayer(playerid);
	SavePlayer(WorkSellerID[playerid][WORK_WEAPONSD]);
	return 1;
}

/* =================================================================== */
public OnPlayerUpdate(playerid)
{
	if(IsPlayerNPC(playerid))return 0;
	if(!PlayerInfo[playerid][playerLogged])return 1;
	SetPlayerScore(playerid,
		PlayerSkill[playerid][skillPolice]+
		PlayerSkill[playerid][skillRobber]+
		PlayerSkill[playerid][skillVehicleStolen]+
		PlayerSkill[playerid][skillWeaponsD]+
		PlayerSkill[playerid][skillMechanic]);
	static string[128];
	if(GetPlayerWeapon(playerid) != 40 && GetPlayerWeapon(playerid) != 0 && GetPlayerWeapon(playerid) != 46)
	{
		if(PlayerInfo[playerid][playerWeapons][GetPlayerWeapon(playerid)] == false)
		{
			format(string, sizeof(string), " "EMB_RED"%s"EMB_WHITE" ha tentato di givarsi un'arma!", PlayerInfo[playerid][playerName]);
			SendMessageToAdmin(string, -1);
			KickPlayer(playerid);
		}
	}
	if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK)
	{
		if(PlayerInfo[playerid][playerAdmin] < 1)
		{
			ClearAnimations(playerid);
			format(string, sizeof(string), " "EMB_GREEN"%s"EMB_WHITE" ha tentato di givarsi un Jetpack!", PlayerInfo[playerid][playerName]);
			SendMessageToAdmin(string, -1);
		}
	}
	if(IsPlayerInAnyVehicle(playerid))
	{
		new engine, lightz, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lightz, alarm, doors, bonnet, boot, objective);
		if(!engine)
		{
			SetVehicleParamsEx(GetPlayerVehicleID(playerid), true, lightz, alarm, doors, bonnet, boot, objective);
		}
	}
	if(GetPlayerMoney(playerid) > GetPlayerMoneyEx(playerid))
	{
		SetPlayerMoneyEx(playerid, GetPlayerMoneyEx(playerid));
	}
	if(PlayerInfo[playerid][playerPremium] != PLAYER_NO_PREMIUM)
	{
		if(gettime() >= PlayerInfo[playerid][playerPremiumTime] && PlayerInfo[playerid][playerPremium] != PLAYER_NO_PREMIUM) //Control Time Premium
		{
			PlayerInfo[playerid][playerPremiumTime] = 0;
			SavePlayer(playerid);
			SendClientMessage(playerid, COLOR_GREEN, "** Il tuo Premium e' scaduto! **");
			DestroyDynamic3DTextLabel(playerPremiumLabel[playerid]);
			PlayerInfo[playerid][playerPremium] = PLAYER_NO_PREMIUM;
			mysql_format(MySQLC, string, sizeof(string), "UPDATE `Players` SET PremiumTime = '0', Premium = '0' WHERE `ID` = '%d' AND `Name` = '%s'", PlayerInfo[playerid][playerID], PlayerInfo[playerid][playerName]);
			mysql_tquery(MySQLC, string);
		}
	}
	static Float:AAA;
	AAA = 0.0;
	GetPlayerArmour(playerid, AAA);
	if(AAA > 99.0)
	{
		if(PlayerInfo[playerid][playerDead] == false)
		{
			SetPlayerArmour(playerid, 99.0);
			format(string, sizeof(string), EMB_GREEN"%s"EMB_WHITE" si e' settato l'armatura!", PlayerInfo[playerid][playerName]);
			SendMessageToAdmin(string, -1);
		}
	}
	GetPlayerHealth(playerid, AAA);
	if(AAA > 99.0)
	{
		if(Drugged[playerid] == false)
		{
			if(playerADuty[playerid] == false && PlayerInfo[playerid][playerDead] == false && !IsPlayerUsingVendingMachine(playerid))
			{
				SetPlayerHealth(playerid, 99.0);
				//format(string, sizeof(string), EMB_GREEN"%s"EMB_WHITE" si � settato la vita!", PlayerInfo[playerid][playerName]);
				//SendMessageToAdmin(string, -1);
			}
		}
	}
	if(PlayerInfo[playerid][playerWeapAllowed] != true && GetPlayerWeapon(playerid) != 0) SetPlayerArmedWeapon(playerid, 0);
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
	switch(dialogid)
	{
		case DIALOG_VMENU_SELLTO_FINISH+999:
		{
			if(!response)return 0;
			if(response)return 0;
		}
		case DIALOG_BUSINESS_247:
		{
			if(!response)return 0;
			new string[80];
			switch(listitem)
			{

				case 0: //Chainsaw
				{
					if(GetPlayerMoneyEx(playerid) < CHAINSAW_PRICE)return SendClientMessage(playerid, COLOR_LIGHTRED, "Non hai abbastanza soldi!");
					GivePlayerMoneyEx(playerid, -CHAINSAW_PRICE);
					format(string, sizeof(string), "Hai comprato una Motosega per %s", ConvertPrice(CHAINSAW_PRICE));
					SendClientMessage(playerid, COLOR_GREEN, string);
					GivePlayerWeaponEx(playerid, 9, 1);
				}
				case 1: //Knife
				{
					if(GetPlayerMoneyEx(playerid) < KNIFE_PRICE)return SendClientMessage(playerid, COLOR_LIGHTRED, "Non hai abbastanza soldi!");
					GivePlayerMoneyEx(playerid, -KNIFE_PRICE);
					format(string, sizeof(string), "Hai comprato un Coltello per %s", ConvertPrice(KNIFE_PRICE));
					SendClientMessage(playerid, COLOR_GREEN, string);
					GivePlayerWeaponEx(playerid, 4, 1);
				}
				case 2: //Kane
				{
					if(GetPlayerMoneyEx(playerid) < BRASS_PRICE)return SendClientMessage(playerid, COLOR_LIGHTRED, "Non hai abbastanza soldi!");
					GivePlayerMoneyEx(playerid, -BRASS_PRICE);
					format(string, sizeof(string), "Hai comprato un Tirapugni per %s", ConvertPrice(BRASS_PRICE));
					SendClientMessage(playerid, COLOR_GREEN, string);
					GivePlayerWeaponEx(playerid, 1, 1);
				}
				case  3: //Baseball
				{
					if(GetPlayerMoneyEx(playerid) < BASEBALL_PRICE)return SendClientMessage(playerid, COLOR_LIGHTRED, "Non hai abbastanza soldi!");
					GivePlayerMoneyEx(playerid, -BASEBALL_PRICE);
					format(string, sizeof(string), "Hai comprato una Mazza da Baseball per %s", ConvertPrice(BASEBALL_PRICE));
					SendClientMessage(playerid, COLOR_GREEN, string);
					GivePlayerWeaponEx(playerid, 5, 1);
				}
				case  4: //Wallet
				{
					if(GetPlayerMoneyEx(playerid) < WALLET_PRICE)return SendClientMessage(playerid, COLOR_LIGHTRED, "Non hai abbastanza soldi!");
					if(PlayerInfo[playerid][playerWallet] == MAX_WALLET_CHANCE)return SendClientMessage(playerid, COLOR_LIGHTRED, "Hai gia' il portafoglio!");
					GivePlayerMoneyEx(playerid, -WALLET_PRICE);
					format(string, sizeof(string), "Hai comprato un Portafoglio per %s", ConvertPrice(WALLET_PRICE));
					SendClientMessage(playerid, COLOR_GREEN, string);
					PlayerInfo[playerid][playerWallet] = MAX_WALLET_CHANCE;
				}
			}
		}
		case DIALOG_CHOOSE_WORK:
		{
			if(!response)
			{
				PlayerInfo[playerid][playerWork] = WORK_NOWORK;
				SendClientMessage(playerid, COLOR_GREEN, "> Non hai scelto nessun lavoro!");
				return 1;
			}
			// ShowPlayerDialog(playerid, DIALOG_CHOOSE_WORK, DIALOG_STYLE_LIST, "Lavori", "N/A\nTrafficante d'Armi\nSpacciatore di Droga\n", "Continua", "Annulla");
			switch(listitem)
			{
				case 0:// N/A
				{
					PlayerInfo[playerid][playerWork] = WORK_NOWORK;
					SendClientMessage(playerid, COLOR_GREEN, "> Non hai scelto nessun lavoro!");
					GivePlayerWeaponEx(playerid, 1, 1);//Tirapungi
					GivePlayerWeaponEx(playerid, 22, 100);//9mm
					GivePlayerWeaponEx(playerid, 25, 30);//Shotgun
					GivePlayerWeaponEx(playerid, 30, 100);//AK

				}
				case 1:// Weapons Dealer
				{
					PlayerInfo[playerid][playerWork] = WORK_WEAPONSD;
					SendClientMessage(playerid, COLOR_GREEN, "Lavoro scelto: ''Trafficante d'Armi''.");
					GivePlayerWeaponEx(playerid, 5, 1);//Baseball
					GivePlayerWeaponEx(playerid, 24, 50);//Deagle
					GivePlayerWeaponEx(playerid, 26, 30);//Canne Mozze
					GivePlayerWeaponEx(playerid, 32, 100);//Tec9

				}
				case 2://Drugs Dealer
				{
					PlayerInfo[playerid][playerWork] = WORK_DRUGSD;
					SendClientMessage(playerid, COLOR_GREEN, "Lavoro scelto: ''Spacciatore di Droga''.");
					GivePlayerWeaponEx(playerid, 1, 1);//Tirapungi
					GivePlayerWeaponEx(playerid, 22, 100);//9mm
					GivePlayerWeaponEx(playerid, 25, 30);//Shotgun
					GivePlayerWeaponEx(playerid, 28, 130);//Uzi

				}
			}
		}
		case DIALOG_GPS:
		{
			if(!response)return 0;
			DestroyDynamicRaceCP(gps_Checkpoint[playerid]);
			gps_Checkpoint[playerid] = CreateDynamicRaceCP(1, GPS_POS[listitem][gX], GPS_POS[listitem][gY], GPS_POS[listitem][gZ], 0,0,0, 4.0, 0, 0, playerid, 99999999.0);
			UsingGPS[playerid] = true;
			SendClientMessage(playerid, COLOR_GREEN, "Destinazione impostata. Raggiungi il cerchio rosso!");
			SendClientMessage(playerid, COLOR_GREEN, "Ricorda che puoi usare di nuovo /gps per rimuovere la destinazione attuale!");
		}
		case 999:return 0;
		case DIALOG_REG:
		{
			if(!response)return Kick(playerid);
			if(strlen(inputtext) < 3 || strlen(inputtext) > 24)return ShowPlayerDialog(playerid, DIALOG_REG, DIALOG_STYLE_PASSWORD, "Registrazione", "{FF0000}Password troppo corta o troppo lunga.\n{FFFFFF}Inserisci una password per registrarti", "Registrami!", "Esci");
			new query[450], name[MAX_PLAYER_NAME];
			GetPlayerName(playerid, name, MAX_PLAYER_NAME);
			mysql_format(MySQLC, query, sizeof query, "INSERT INTO `Accounts` (`Name`, `Password`, `Money`, `Bank`, `Admin`, `JailTime`, `PremiumTime`, `AccountBanned`, `Skills`, `BanTime`, `Rewards`, `RewardMoney`, `Drug`, `Kills`, `Deaths`, `Premium`, `RegisterDate`, `LastLogin`) \
				VALUES('%s',md5('%s'), 20000, 0, 0, 0, 0, 0, 'asd.', 0, 0, 0, 0, 0, 0, 0, '%s', '%s')",
				name, inputtext, getdate(), gettime());
			mysql_tquery(MySQLC, query, "RegisterPlayerAccount", "d", playerid);
			ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Adesso che sei registrato inserisci la tua password per loggare!", "Login!", "Esci");
		}
		case DIALOG_LOGIN:
		{
			if(!response)return Kick(playerid);
			new query[256];
			mysql_format(MySQLC, query, sizeof(query), "SELECT * FROM `Players` WHERE `Name` = '%s' AND `Password` = md5('%s') LIMIT 2", PlayerInfo[playerid][playerName], inputtext);
			mysql_tquery(MySQLC, query, "LoginPlayer","d",playerid);
		}
		case DIALOG_HOUSE:
		{
			if(!response)return 0;
			switch(listitem)
			{
				case 0: //Apri/Chiudi
				{
					if(PlayerInfo[playerid][playerHouse] == NO_HOUSE)return 0;
					new i = PlayerInfo[playerid][playerHouse];
					if(HouseInfo[i][hClosed] == 0)
					{
						SendClientMessage(playerid, COLOR_GREEN, "Hai chiuso la casa!");
						HouseInfo[i][hClosed] = 1;
						new string[128];
						format(string, 128, "%s (%d)\nProprietario: %s\n"EMB_RED"Chiusa", GetLocationNameFromCoord(HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ]), i, HouseInfo[i][OwnerName]);
						UpdateDynamic3DTextLabelText(HouseInfo[i][hLabel], -1, string);
						SaveHouse(i);
					}
					else if(HouseInfo[i][hClosed] == 1)
					{
						SendClientMessage(playerid, COLOR_GREEN, "Hai aperto la casa!");
						HouseInfo[i][hClosed] = 0;
						new string[128];
						format(string, 128, "%s (%d)\nProprietario: %s\n"EMB_GREEN"Aperta", GetLocationNameFromCoord(HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ]), i, HouseInfo[i][OwnerName]);
						UpdateDynamic3DTextLabelText(HouseInfo[i][hLabel], -1, string);
						SaveHouse(i);
					}
					return 1;
				}
				case 1:// Vendi
				{
					new i = PlayerInfo[playerid][playerHouse], string[128];
					format(string, sizeof(string), "Sei sicuro di voler vendere la tua casa per "EMB_DOLLARGREEN"%s"EMB_WHITE"", ConvertPrice(HouseInfo[i][hPrice]*75/100));
					ShowPlayerDialog(playerid, DIALOG_HOUSE+999, DIALOG_STYLE_MSGBOX, "Vendita Casa", string, "Si", "No");
					return 1;
				}
				case 2:// Ritira Soldi
				{
					if(PlayerInfo[playerid][playerHouse] == NO_HOUSE)return 0;
					new string[200];
					format(string,sizeof(string), "Inserisci la somma di denaro che vuoi ritirare dalla tua casa!\nBilancio: "EMB_DOLLARGREEN"%d$", HouseInfo[PlayerInfo[playerid][playerHouse]][hMoney]);
					ShowPlayerDialog(playerid, DIALOG_HOUSE_WITHDRAW, DIALOG_STYLE_INPUT, "Ritira", string, "Ritira", "Annulla");
					return 1;
				}
				case 3:// Deposita Soldi
				{
					if(PlayerInfo[playerid][playerHouse] == NO_HOUSE)return 0;
					new string[200];
					format(string,sizeof(string), "Inserisci la somma di denaro che vuoi depositare dalla tua casa!\nBilancio: "EMB_DOLLARGREEN"%d$", HouseInfo[PlayerInfo[playerid][playerHouse]][hMoney]);
					ShowPlayerDialog(playerid, DIALOG_HOUSE_DEPOSIT, DIALOG_STYLE_INPUT, "Deposita", string, "Deposita", "Annulla");
					return 1;
				}
			}
		}
		case DIALOG_HOUSE+999: //Sell House
		{
			if(!response)return 0;
			if(PlayerInfo[playerid][playerHouse] == NO_HOUSE)return SendClientMessage(playerid, COLOR_RED, "Non possiedi una casa!");
			new i = PlayerInfo[playerid][playerHouse], string[128];
			GivePlayerMoneyEx(playerid, HouseInfo[i][hPrice]*75/100);
			HouseInfo[i][hOwnerID] = NO_OWNER;
			HouseInfo[i][hClosed] = 0;
			HouseInfo[i][hOwned] = false;
			PlayerInfo[playerid][playerHouse] = NO_HOUSE;
			strcpy(HouseInfo[i][OwnerName], "NoOne", 24);
			format(string, 128, "%s (%d)\nCasa in vendita!\nCosto: "EMB_DOLLARGREEN"%s"EMB_WHITE"\n"EMB_GREEN"Aperta", GetLocationNameFromCoord(HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ]), i, ConvertPrice(HouseInfo[i][hPrice]));
			UpdateDynamic3DTextLabelText(HouseInfo[i][hLabel], -1, string);
			DestroyDynamicMapIcon(HouseInfo[i][hMapIcon]);
			HouseInfo[i][hMapIcon] = CreateDynamicMapIcon(HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ], 31, -1, -1, -1, -1, 20.0);
			SaveHouse(i);
			return 1;
		}
		case DIALOG_HOUSE_WITHDRAW:
		{
			if(!response) return 0;
			new m = strval(inputtext);
			new i = PlayerInfo[playerid][playerHouse];
			if(m > HouseInfo[i][hMoney] || m < 1)return ShowPlayerDialog(playerid, DIALOG_HOUSE_WITHDRAW, DIALOG_STYLE_INPUT, "Ritira", EMB_RED"Non hai tutti questi soldi in casa!\n"EMB_WHITE"Inserisci la somma di denaro che vuoi ritirare dalla tua casa!", "Ritira", "Annulla");
			HouseInfo[i][hMoney] -= m;
			GivePlayerMoneyEx(playerid, m);
			new string[120];
			format(string, sizeof(string), "** Hai ritirato "EMB_DOLLARGREEN"%s"EMB_WHITE" dalla tua casa **", ConvertPrice(m));
			SendClientMessage(playerid, -1, string);
			SaveHouse(i);
			return 1;
		}
		case DIALOG_HOUSE_DEPOSIT:
		{
			if(!response) return 0;
			new m = strval(inputtext);
			new i = PlayerInfo[playerid][playerHouse];
			if(m > GetPlayerMoneyEx(playerid) || m < 1)return ShowPlayerDialog(playerid, DIALOG_HOUSE_DEPOSIT, DIALOG_STYLE_INPUT, "Deposita", EMB_RED"Non hai tutti questi soldi!\n"EMB_WHITE"Inserisci la somma di denaro che vuoi depositare in casa!", "Deposita", "Annulla");
			HouseInfo[i][hMoney] += m;
			GivePlayerMoneyEx(playerid, -m);
			new string[120];
			format(string, sizeof(string), "** Hai depositato "EMB_DOLLARGREEN"%s"EMB_WHITE" in casa **", ConvertPrice(m));
			SendClientMessage(playerid, -1, string);
			SaveHouse(i);
			return 1;
		}
		case DIALOG_VMENU:
		{
			if(!response)return 0;
			new string[60];
			for(new i = 1; i < MAX_VEHICLE_SLOT; i++)
			{
				if(VmenuVehicles[playerid][i] != listitem+1)continue;
				vehicleMenuChoosed[playerid] = i;
			}
			new slotid = vehicleMenuChoosed[playerid];
			format(string, sizeof(string), "#%d %s (%d)", slotid, GetVehicleName(VehicleInfo[ PlayerVehicle[playerid][slotid][vID] ][vModel]), PlayerVehicle[playerid][slotid][vID]);
			if(PlayerInfo[playerid][playerAdmin] > 0)
			{

				ShowPlayerDialog(playerid, DIALOG_VMENU_RESPONSE, DIALOG_STYLE_LIST, string, "Apri/Chiudi Veicolo\nParcheggia Veicolo\nTrova Veicolo\nVendi Veicolo\nVendi a Giocatore\nApri/Chiudi Cofano\nApri/Chiudi Bagagliaio\
					\n"EMB_GOLD"Admin: "EMB_WHITE"Goto Vehicle\n"EMB_GOLD"Admin: "EMB_WHITE"Get Vehicle Here\n", "Seleziona", "Annulla");
			}
			else
			{
				ShowPlayerDialog(playerid, DIALOG_VMENU_RESPONSE, DIALOG_STYLE_LIST, string, "Apri/Chiudi Veicolo\nParcheggia Veicolo\nTrova Veicolo\nVendi Veicolo\nVendi a Giocatore\nApri/Chiudi Cofano\nApri/Chiudi Bagagliaio", "Seleziona", "Annulla");
			}
		}
		case DIALOG_VMENU_RESPONSE:
		{
			if(!response)
			{
				vehicleMenuChoosed[playerid] = 0;
				return 0;
			}
			switch(listitem)
			{
				case 0://Apri/Chiudi Veicolo
				{
					new vid = PlayerVehicle[playerid][vehicleMenuChoosed[playerid]][vID];
					new Float: Pos[3];
					GetVehiclePos(vid, Pos[0], Pos[1], Pos[2]);
					if(!IsPlayerInRangeOfPoint(playerid, 6.0, Pos[0], Pos[1], Pos[2]))return SendClientMessage(playerid, COLOR_RED, "Non sei vicino al veicolo!");
					if(VehicleInfo[PlayerVehicle[playerid][vehicleMenuChoosed[playerid]][vID]][vClosed] == 1)
					{
						SendClientMessage(playerid, COLOR_GREEN, "Hai aperto il tuo veicolo!");
						VehicleInfo[PlayerVehicle[playerid][vehicleMenuChoosed[playerid]][vID]][vClosed] = 0;
						vehicleMenuChoosed[playerid] = 0;
					}
					else if(VehicleInfo[PlayerVehicle[playerid][vehicleMenuChoosed[playerid]][vID]][vClosed] == 0)
					{
						SendClientMessage(playerid, COLOR_GREEN, "Hai chiuso il tuo veicolo!");
						VehicleInfo[PlayerVehicle[playerid][vehicleMenuChoosed[playerid]][vID]][vClosed] = 1;
						vehicleMenuChoosed[playerid] = 0;
						return 1;
					}
				}
				case 1: //Parcheggia Veicolo
				{
					if(!IsPlayerInAnyVehicle(playerid))return SendClientMessage(playerid, COLOR_RED, "Non sei nel veicolo!");
					if(GetPlayerVehicleID(playerid) != PlayerVehicle[playerid][vehicleMenuChoosed[playerid]][vID])return SendClientMessage(playerid, COLOR_RED, "Non sei nel veicolo!");
					SendClientMessage(playerid, COLOR_GREEN, "Hai parcheggiato qui il tuo veicolo");
					new Float:X, Float:Y, Float:Z, Float:A;
					GetVehiclePos(GetPlayerVehicleID(playerid), X, Y, Z);
					GetVehicleZAngle(GetPlayerVehicleID(playerid), A);
					new vid = PlayerVehicle[playerid][vehicleMenuChoosed[playerid]][vID];
					VehicleInfo[vid][vX] = X;
					VehicleInfo[vid][vY] = Y;
					VehicleInfo[vid][vZ] = Z;
					VehicleInfo[vid][vA] = A;
					SavePlayerVehicle(playerid);
					vehicleMenuChoosed[playerid] = 0;
					return 1;
				}
				case 2:
				{
					if(UsingGPS[playerid] == true)
					{
						SendClientMessage(playerid, COLOR_GREEN, "Destinazione modificata!");
						DestroyDynamicRaceCP(gps_Checkpoint[playerid]);
						UsingGPS[playerid] = true;
					}
					new Float:X, Float:Y, Float:Z;
					GetVehiclePos(PlayerVehicle[playerid][vehicleMenuChoosed[playerid]][vID], X, Y, Z);
					gps_Checkpoint[playerid] = CreateDynamicRaceCP(1, X, Y, Z, 0, 0, 0, 4.0, 0, 0, playerid, 100000.0);
					SendClientMessage(playerid, COLOR_GREEN, "L'auto e' segnata con un punto rosso sulla mappa!");
					vehicleMenuChoosed[playerid] = 0;
					UsingGPS[playerid] = true;
					return 1;
				}
				case 3:
				{
					if(GetPlayerVehicleID(playerid) != PlayerVehicle[playerid][vehicleMenuChoosed[playerid]][vID])return SendClientMessage(playerid, COLOR_GREEN, "Non ti trovi nel veicolo!");
					RemovePlayerVehicle(playerid, PlayerInfo[playerid][playerID], vehicleMenuChoosed[playerid]);
					vehicleMenuChoosed[playerid] = 0;
					return 1;
				}
				case 4:
				{
					if(!response)return 0;
					ShowPlayerDialog(playerid, DIALOG_VMENU_SELLTO, DIALOG_STYLE_INPUT, "Vendi veicolo", "Inserisci l'ID del player a cui vuoi vendere il veicolo!", "Ok", "Annulla");
				}
				case 5: //Apri/Chiudi Cofano
				{
					new engine, lightz, alarm, doors, bonnet, boot, objective, id = PlayerVehicle[playerid][vehicleMenuChoosed[playerid]][vID];
					GetVehicleParamsEx(id, engine, lightz, alarm, doors, bonnet, boot, objective);
					if(bonnet == -1)SetVehicleParamsEx(id, engine, lightz, alarm, doors, false, boot, objective);
					if(bonnet)//Chiudi
					{
						SetVehicleParamsEx(id, engine, lightz, alarm, doors, false, boot, objective);
					}
					else //Apri
					{
						SetVehicleParamsEx(id, engine, lightz, alarm, doors, true, boot, objective);
					}
					return 1;
				}
				case 6: //Apri/Chiudi Bagagliaio
				{
					new engine, lightz, alarm, doors, bonnet, boot, objective, id = PlayerVehicle[playerid][vehicleMenuChoosed[playerid]][vID];
					GetVehicleParamsEx(id, engine, lightz, alarm, doors, bonnet, boot, objective);
					if(boot == -1)SetVehicleParamsEx(id, engine, lightz, alarm, doors, bonnet, false, objective);
					if(boot)//Chiudi
					{
						SetVehicleParamsEx(id, engine, lightz, alarm, doors, bonnet, false, objective);
					}
					else //Apri
					{
						SetVehicleParamsEx(id, engine, lightz, alarm, doors, bonnet, true, objective);
					}
					return 1;
				}
				/*OtherHere*/
				//
				/*OtherHere*/
				case 7: //Goto Vehicle
				{
					if(GetPlayerAdminLevel(playerid) >= 1)
					{
						new id = PlayerVehicle[playerid][vehicleMenuChoosed[playerid]][vID];
						//if(!IsValidVehicle(id))return SendClientMessage(playerid, COLOR_RED, "Il veicolo non esiste!");
						SetPlayerVirtualWorld(playerid, GetVehicleVirtualWorld(id));
						new Float:Pos[3];
						GetVehiclePos(id, Pos[0], Pos[1], Pos[2]);
						if(!IsPlayerInAnyVehicle(playerid))
						{
							SetPlayerPos(playerid, Pos[0], Pos[1]+3.0, Pos[2]);
						}
						else
						{
							SetVehiclePos(GetPlayerVehicleID(playerid), Pos[0]+1, Pos[1]+2.5, Pos[2]+3);
						}
						SendClientMessage(playerid, COLOR_GREY, "Ti sei gotato al veicolo!");
					}
				}
				case 8: //Gethere Vehicle
				{
					if(GetPlayerAdminLevel(playerid) >= 1)
					{
						new id = PlayerVehicle[playerid][vehicleMenuChoosed[playerid]][vID];
					//	if(!IsValidVehicle(id))return SendClientMessage(playerid, COLOR_RED, "Il veicolo non esiste!");
						SetVehicleVirtualWorld(id, GetPlayerVirtualWorld(playerid));
						new Float:Pos[3];
						GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
						SetVehiclePos(id, Pos[0]+2, Pos[1]+1.5, Pos[2]+2);
						SendClientMessage(playerid, COLOR_GREY, "Ti sei gotato il veicolo!");
					}
				}
			}
		}
		case DIALOG_VMENU_SELLTO:
		{
			if(!response)
			{
				vehicleMenuChoosed[playerid] = 0;
				return 0;
			}
			new id;
			if(sscanf(inputtext, "u", id))return ShowPlayerDialog(playerid, DIALOG_VMENU_SELLTO, DIALOG_STYLE_INPUT, "Vendi veicolo", "Inserisci l'ID del player a cui vuoi vendere il veicolo!", "Ok", "Annulla");
			if(id == INVALID_PLAYER_ID)return ShowPlayerDialog(playerid, DIALOG_VMENU_SELLTO, DIALOG_STYLE_INPUT, "Vendi veicolo", "Giocatore non connesso!\nInserisci l'ID del player a cui vuoi vendere il veicolo!", "Ok", "Annulla");
			if(GetPlayerVehicleCount(id) == NORMAL_PLAYER_SLOT-1 && PlayerInfo[playerid][playerPremium] == PLAYER_NO_PREMIUM)
			{
				return SendClientMessage(playerid, COLOR_RED, "Il player possiede troppi veicoli!");
			}
			else if(GetPlayerVehicleCount(id) == PREMIUM_PLAYER_SLOT-1 && PlayerInfo[playerid][playerPremium] != PLAYER_NO_PREMIUM)
			{
				return SendClientMessage(playerid, COLOR_RED, "Il player possiede troppi veicoli!");
			}
			vmenu_SellerID[id] = -1;
			vmenu_PlayerToSellVeh[playerid] = id;
			ShowPlayerDialog(playerid, DIALOG_VMENU_SELLTO_PRICE, DIALOG_STYLE_INPUT, "Vendi veicolo", "Inserisci il prezzo del veicolo!", "Ok", "Annulla");
		}
		case DIALOG_VMENU_SELLTO_PRICE:
		{
			if(!response)
			{
				vehicleMenuChoosed[playerid] = 0;
				vmenu_PlayerToSellVehPrice[playerid] = -1;
				vmenu_PlayerToSellVeh{vmenu_SellerID[playerid]} = -1;
				vmenu_SellerID[playerid] = -1;
				vehicleMenuChoosed[vmenu_SellerID[playerid]] = 0;
				return 0;
			}
			new price;
			if(sscanf(inputtext, "d", price))return ShowPlayerDialog(playerid, DIALOG_VMENU_SELLTO_PRICE, DIALOG_STYLE_INPUT, "Vendi veicolo", "Inserisci il prezzo del veicolo!", "Ok", "Annulla");
			new string[128];
			vmenu_SellerID[vmenu_PlayerToSellVeh[playerid]] = playerid;
			vmenu_PlayerToSellVehPrice[vmenu_PlayerToSellVeh[playerid]] = price;
			format(string, 128, "%s vuole venderti un veicolo (%s) per "EMB_DOLLARGREEN"%s"EMB_WHITE"", PlayerInfo[playerid][playerName], GetVehicleName(GetVehicleModel(GetPlayerVehicleID(playerid))), ConvertPrice(price));
			ShowPlayerDialog(vmenu_PlayerToSellVeh[playerid], DIALOG_VMENU_SELLTO_FINISH, DIALOG_STYLE_MSGBOX, "Richiesta", string, "Ok", "Annulla");
		}
		case DIALOG_VMENU_SELLTO_FINISH:
		{
			if(PlayerInfo[vmenu_SellerID[playerid]][playerLogged] == false)
			{
				SendClientMessage(playerid, -1, "Il giocatore non e' connesso!");
				vmenu_PlayerToSellVehPrice[playerid] = -1;
				vmenu_PlayerToSellVeh{vmenu_SellerID[playerid]} = -1;
				vmenu_SellerID[playerid] = -1;
				vehicleMenuChoosed[vmenu_SellerID[playerid]] = 0;
				return 1;
			}
			if(!response)
			{
				new string[128];
				format(string, 128, "%s non ha accettato il veicolo!", PlayerInfo[playerid][playerName]);
				ShowPlayerDialog(vmenu_SellerID[playerid], DIALOG_VMENU_SELLTO_FINISH+999, DIALOG_STYLE_MSGBOX, "Richiesta", string, "Ok", "Annulla");
				vmenu_PlayerToSellVehPrice[playerid] = -1;
				vmenu_PlayerToSellVeh{vmenu_SellerID[playerid]} = -1;
				vmenu_SellerID[playerid] = -1;
				vehicleMenuChoosed[vmenu_SellerID[playerid]] = 0;
				return 1;
			}
			else
			{
				new string[128];
				format(string, 128, "%s ha comprato il tuo veicolo!", PlayerInfo[playerid][playerName]);
				ShowPlayerDialog(vmenu_SellerID[playerid], DIALOG_VMENU_SELLTO_FINISH+999, DIALOG_STYLE_MSGBOX, "Richiesta", string, "Ok", "Annulla");
				GivePlayerMoneyEx(playerid, -vmenu_PlayerToSellVehPrice[playerid]);
				GivePlayerMoneyEx(vmenu_SellerID[playerid], vmenu_PlayerToSellVehPrice[playerid]);
				SendPlayerVehicle(vmenu_SellerID[playerid], playerid, vehicleMenuChoosed[vmenu_SellerID[playerid]]);
				vmenu_PlayerToSellVehPrice[playerid] = -1;
				vmenu_PlayerToSellVeh[vmenu_SellerID[playerid]]= -1;
				vmenu_SellerID[playerid] = -1;
				vehicleMenuChoosed[vmenu_SellerID[playerid]] = 0;
				return 1;
			}
		}
		case DIALOG_AMMU_BUY:
		{
			if(!response)return 0;
			switch(listitem)
			{
				case 0: ShowPlayerDialog(playerid, DIALOG_AMMU_BUY_PISTOLS, DIALOG_STYLE_LIST, "Pistole", 		"9mm			"EMB_DOLLARGREEN"$400\n"EMB_WHITE"9mm Silenced		"EMB_DOLLARGREEN"$500"EMB_WHITE"\nDesert Eagle		"EMB_DOLLARGREEN"$1.500"EMB_WHITE, "Compra", "Indietro");
				case 1: ShowPlayerDialog(playerid, DIALOG_AMMU_BUY_SMGUN, DIALOG_STYLE_LIST, "SMG", 			"Tec 9			"EMB_DOLLARGREEN"$400\n"EMB_WHITE"Uzi		"EMB_DOLLARGREEN"$600"EMB_WHITE"\nMP5		"EMB_DOLLARGREEN"$2.500"EMB_WHITE, "Compra", "Indietro");
				case 2: ShowPlayerDialog(playerid, DIALOG_AMMU_BUY_SHOTGUNS, DIALOG_STYLE_LIST, "Shotguns", 	"Shotgun		"EMB_DOLLARGREEN"$800\n"EMB_WHITE"Sawnoff Shotgun		"EMB_DOLLARGREEN"$1.200\nSpas 12		"EMB_DOLLARGREEN"$2.500"EMB_WHITE, "Compra", "Indietro");
				case 3: ShowPlayerDialog(playerid, DIALOG_AMMU_BUY_ARMOUR, DIALOG_STYLE_LIST, "Armatura", 		"Armatura		"EMB_DOLLARGREEN"$10.000\n"EMB_WHITE, "Compra", "Indietro");
				case 4: ShowPlayerDialog(playerid, DIALOG_AMMU_BUY_ASSAULT, DIALOG_STYLE_LIST, "Assalti", 		"AK-47			"EMB_DOLLARGREEN"$3.500\n"EMB_WHITE"M4		"EMB_DOLLARGREEN"$4.000"EMB_WHITE"\n", "Compra", "Indietro");
				case 5: ShowPlayerDialog(playerid, DIALOG_AMMU_BUY_UTILITY, DIALOG_STYLE_LIST, "Utilita'", 		"C4(Rapine)x2	"EMB_DOLLARGREEN"$100.000"EMB_WHITE, "Compra", "Indietro");
			}
		}
		case DIALOG_AMMU_BUY_UTILITY:
		{
			if(!response)return ShowPlayerDialog(playerid, DIALOG_AMMU_BUY, DIALOG_STYLE_LIST, "Ammunation", "Pistole\nSMG\nShotguns\nArmatura\nAssalti\nUtilita'", "Avanti", "Chiudi");
			switch(listitem)
			{
				case 0:
				{
					if(GetPlayerMoneyEx(playerid) < 100000)return SendClientMessage(playerid, COLOR_LIGHTRED, "Non hai abbastanza soldi!");
					PlayerInfo[playerid][playerC4] += 2;
					GivePlayerMoneyEx(playerid, -100000);
					new string[128];
					format(string, 128, "Hai acquistato 2 cariche di C4 (%d cariche totali) che possono essere usate per le rapine (Centro Scommesse).", PlayerInfo[playerid][playerC4]);
					SendClientMessage(playerid, COLOR_GREEN, string);
					SendClientMessage(playerid, COLOR_GREEN, "Ricorda però che uscendo dal gioco perderai tutte le cariche attuali!");
					ShowPlayerDialog(playerid, DIALOG_AMMU_BUY_UTILITY, DIALOG_STYLE_LIST, "Utilita'", "C4(Rapine)x2		"EMB_DOLLARGREEN"$100.000", "Compra", "Indietro");
				}
			}
		}

		case DIALOG_AMMU_BUY_ASSAULT:
		{
			if(!response)return ShowPlayerDialog(playerid, DIALOG_AMMU_BUY, DIALOG_STYLE_LIST, "Ammunation", "Pistole\nSMG\nShotguns\nArmatura\nAssalti\nUtilita'", "Avanti", "Chiudi");
			switch(listitem)
			{
				case 0: //AK
				{
					if(GetPlayerMoneyEx(playerid) < 3500)return SendClientMessage(playerid, COLOR_LIGHTRED, "Non hai abbastanza soldi!");
					GivePlayerMoneyEx(playerid, -3500);
					GivePlayerWeaponEx(playerid, 30, 150);
					ShowPlayerDialog(playerid, DIALOG_AMMU_BUY_ASSAULT, DIALOG_STYLE_LIST, "Assalti", "AK-47		"EMB_DOLLARGREEN"$3.500"EMB_WHITE"\nM4		"EMB_DOLLARGREEN"$4.000\n", "Compra", "Indietro");
				}
				case 1://M4
				{
					if(GetPlayerMoneyEx(playerid) < 4000)return SendClientMessage(playerid, COLOR_LIGHTRED, "Non hai abbastanza soldi!");
					GivePlayerMoneyEx(playerid, -4000);
					GivePlayerWeaponEx(playerid, 31, 150);
					ShowPlayerDialog(playerid, DIALOG_AMMU_BUY_ASSAULT, DIALOG_STYLE_LIST, "Assalti", "AK-47		"EMB_DOLLARGREEN"$3.500"EMB_WHITE"\nM4		"EMB_DOLLARGREEN"$4.000\n", "Compra", "Indietro");
				}
			}
		}
		case DIALOG_AMMU_BUY_ARMOUR:
		{
			if(!response)return ShowPlayerDialog(playerid, DIALOG_AMMU_BUY, DIALOG_STYLE_LIST, "Ammunation", "Pistole\nSMG\nShotguns\nArmatura\nAssalti\nUtilita'", "Avanti", "Chiudi");
			if(listitem == 0)//Armatura
			{
				if(GetPlayerMoneyEx(playerid) < 10000)return SendClientMessage(playerid, COLOR_LIGHTRED, "Non hai abbastanza soldi!");
				GivePlayerMoneyEx(playerid, -10000);
				SetPlayerArmour(playerid, 99.0);
				ShowPlayerDialog(playerid, DIALOG_AMMU_BUY, DIALOG_STYLE_LIST, "Ammunation", "Pistole\nSMG\nShotguns\nArmatura\nAssalti\nUtilita'", "Avanti", "Chiudi");
			}
		}
		case DIALOG_AMMU_BUY_PISTOLS:
		{
			if(!response)return ShowPlayerDialog(playerid, DIALOG_AMMU_BUY, DIALOG_STYLE_LIST, "Ammunation", "Pistole\nSMG\nShotguns\nArmatura\nAssalti\nUtilita'", "Avanti", "Chiudi");
			switch(listitem)
			{
				case 0: //9mm
				{
					if(GetPlayerMoneyEx(playerid) < 400)return SendClientMessage(playerid, COLOR_LIGHTRED, "Non hai abbastanza soldi!");
					GivePlayerMoneyEx(playerid, -400);
					GivePlayerWeaponEx(playerid, 22, 50);
				}
				case 1://9mm Silenziata
				{
					if(GetPlayerMoneyEx(playerid) < 500)return SendClientMessage(playerid, COLOR_LIGHTRED, "Non hai abbastanza soldi!");
					GivePlayerMoneyEx(playerid, -500);
					GivePlayerWeaponEx(playerid, 23, 50);
				}
				case 2://Desert Eagle
				{
					if(GetPlayerMoneyEx(playerid) < 1500)return SendClientMessage(playerid, COLOR_LIGHTRED, "Non hai abbastanza soldi!");
					GivePlayerMoneyEx(playerid, -1500);
					GivePlayerWeaponEx(playerid, 24, 50);
				}
			}
			ShowPlayerDialog(playerid, DIALOG_AMMU_BUY_PISTOLS, DIALOG_STYLE_LIST, "Pistole", "9mm		"EMB_DOLLARGREEN"$400"EMB_WHITE"\n9mm Silenziata		"EMB_DOLLARGREEN"$500"EMB_WHITE"\nDesert Eagle		"EMB_DOLLARGREEN"$1.500", "Compra", "Indietro");
		}
		case DIALOG_AMMU_BUY_SMGUN:
		{
			if(!response)return ShowPlayerDialog(playerid, DIALOG_AMMU_BUY, DIALOG_STYLE_LIST, "Ammunation", "Pistole\nSMG\nShotguns\nArmatura\nAssalti\nUtilita'", "Avanti", "Chiudi");
			switch(listitem)
			{
				case 0: //Tec9
				{
					if(GetPlayerMoneyEx(playerid) < 400)return SendClientMessage(playerid, COLOR_LIGHTRED, "Non hai abbastanza soldi!");
					GivePlayerMoneyEx(playerid, -400);
					GivePlayerWeaponEx(playerid, 32, 100);
				}
				case 1://Uzi
				{
					if(GetPlayerMoneyEx(playerid) < 600)return SendClientMessage(playerid, COLOR_LIGHTRED, "Non hai abbastanza soldi!");
					GivePlayerMoneyEx(playerid, -600);
					GivePlayerWeaponEx(playerid, 28, 100);
				}
				case 2://MP5
				{
					if(GetPlayerMoneyEx(playerid) < 2500)return SendClientMessage(playerid, COLOR_LIGHTRED, "Non hai abbastanza soldi!");
					GivePlayerMoneyEx(playerid, -2500);
					GivePlayerWeaponEx(playerid, 29, 100);
				}
			}
			ShowPlayerDialog(playerid, DIALOG_AMMU_BUY_SMGUN, DIALOG_STYLE_LIST, "SMG", "Tec 9		"EMB_DOLLARGREEN"$400"EMB_WHITE"\nUzi		"EMB_DOLLARGREEN"$600"EMB_WHITE"\nMP5		"EMB_DOLLARGREEN"$2.500", "Compra", "Indietro");
		}
		case DIALOG_AMMU_BUY_SHOTGUNS:
		{
			if(!response)return ShowPlayerDialog(playerid, DIALOG_AMMU_BUY, DIALOG_STYLE_LIST, "Ammunation", "Pistole\nSMG\nShotguns\nArmatura\nAssalti\nUtilita'", "Avanti", "Chiudi");
			switch(listitem)
			{
				case 0: //Shotgun
				{
					if(GetPlayerMoneyEx(playerid) < 800)return SendClientMessage(playerid, COLOR_LIGHTRED, "Non hai abbastanza soldi!");
					GivePlayerMoneyEx(playerid, -800);
					GivePlayerWeaponEx(playerid, 25, 25);
				}
				case 1://Sawnoff Shotgun
				{
					if(GetPlayerMoneyEx(playerid) < 1200)return SendClientMessage(playerid, COLOR_LIGHTRED, "Non hai abbastanza soldi!");
					GivePlayerMoneyEx(playerid, -1200);
					GivePlayerWeaponEx(playerid, 26, 25);
				}
				case 2://SPAZZZZZZZZZZZ
				{
					if(GetPlayerMoneyEx(playerid) < 2500)return SendClientMessage(playerid, COLOR_LIGHTRED, "Non hai abbastanza soldi!");
					GivePlayerMoneyEx(playerid, -2500);
					GivePlayerWeaponEx(playerid, 27, 25);
				}
			}
			ShowPlayerDialog(playerid, DIALOG_AMMU_BUY_SHOTGUNS, DIALOG_STYLE_LIST, "Shotguns", "Shotgun		"EMB_DOLLARGREEN"$800"EMB_WHITE"\nSawnoff Shotgun		"EMB_DOLLARGREEN"$1.200"EMB_WHITE"\nSpas 12		"EMB_DOLLARGREEN"$2.500"EMB_WHITE"", "Compra", "Indietro");
		}
		case DIALOG_BANK:
		{
			if(!response)return 0;
			switch(listitem)
			{
				case 0: //Ritira Soldi
				{
					ShowPlayerDialog(playerid, DIALOG_BANK_WITHDRAW, DIALOG_STYLE_INPUT, "Ritira", "Inserisci la somma che vuoi ritirare!", "Ritira", "Chiudi");
				}
				case 1: // Deposita Soldi
				{
					ShowPlayerDialog(playerid, DIALOG_BANK_DEPOSIT, DIALOG_STYLE_INPUT, "Deposita", "Inserisci la somma che vuoi depositare nel tuo conto bancario!", "Deposita", "Chiudi");
				}
				case 2: //Bilancio Bancario
				{
					new string[60];
					format(string, sizeof(string), "Bilancio Bancario: "EMB_DOLLARGREEN"%s"EMB_WHITE"", ConvertPrice(PlayerInfo[playerid][playerBank]));
					SendClientMessage(playerid, COLOR_GREEN, string);
				}
			}
		}
		case DIALOG_BANK_WITHDRAW:
		{
			if(!response)return 0;
			if(!IsNumeric(inputtext))return ShowPlayerDialog(playerid, DIALOG_BANK_WITHDRAW, DIALOG_STYLE_INPUT, "Ritira", "Non hai tutti questi soldi nel tuo conto bancario!\nInserisci la cifra che vuoi ritirare!", "Ritira", "Chiudi");
			if(strval(inputtext) > PlayerInfo[playerid][playerBank])return ShowPlayerDialog(playerid, DIALOG_BANK_WITHDRAW, DIALOG_STYLE_INPUT, "Ritira", "Non hai tutti questi soldi nel tuo conto bancario!\nInserisci la cifra che vuoi ritirare!", "Ritira", "Chiudi");
			if(strval(inputtext) < 1)return SendClientMessage(playerid, COLOR_RED, "Non possiedi questi soldi!");
			new string[128];
			format(string, sizeof(string), "Hai ritirato "EMB_DOLLARGREEN"%s"EMB_WHITE" dal tuo conto bancario. Nuovo bilancio: "EMB_DOLLARGREEN"%s"EMB_WHITE"", ConvertPrice(strval(inputtext)), ConvertPrice(PlayerInfo[playerid][playerBank]-strval(inputtext)));
			SendClientMessage(playerid, -1, string);
			PlayerInfo[playerid][playerBank] -= strval(inputtext);
			GivePlayerMoneyEx(playerid, strval(inputtext));
			SavePlayer(playerid);
		}
		case DIALOG_BANK_DEPOSIT:
		{
			if(!response)return 0;
			if(!IsNumeric(inputtext))return ShowPlayerDialog(playerid, DIALOG_BANK_DEPOSIT, DIALOG_STYLE_INPUT, "Deposita", "Non hai tutti questi soldi!\nInserisci la cifra che vuoi ritirare!", "Ritira", "Chiudi");
			if(strval(inputtext) > GetPlayerMoneyEx(playerid))return ShowPlayerDialog(playerid, DIALOG_BANK_DEPOSIT, DIALOG_STYLE_INPUT, "Deposita", "Non hai tutti questi soldi nel tuo conto bancario!\nInserisci la cifra che vuoi ritirare!", "Ritira", "Chiudi");
			if(strval(inputtext) < 1)return ShowPlayerDialog(playerid, DIALOG_BANK_DEPOSIT, DIALOG_STYLE_INPUT, "Deposita", "Non hai tutti questi soldi nel tuo conto bancario!\nInserisci la cifra che vuoi ritirare!", "Ritira", "Chiudi");
			new string[128];
			format(string, sizeof(string), "Hai depositato "EMB_DOLLARGREEN"%s"EMB_WHITE" nel tuo conto bancario.", ConvertPrice(strval(inputtext)));
			SendClientMessage(playerid, -1, string);
			PlayerInfo[playerid][playerBank] += strval(inputtext);
			format(string, sizeof(string), "Nuovo bilancio: "EMB_DOLLARGREEN"%s"EMB_WHITE"", ConvertPrice(PlayerInfo[playerid][playerBank]));
			SendClientMessage(playerid, -1, string);
			GivePlayerMoneyEx(playerid, -strval(inputtext));
			SavePlayer(playerid);
		}
		case DIALOG_BUY_DRUG:
		{
			if(!response)return 0;
			switch(listitem)
			{
				case 0: //1g		1000$
				{
					if(GetPlayerMoneyEx(playerid) < 1000)
					{
						SendClientMessage(playerid, COLOR_RED, "Non hai abbastanza soldi!");
						ShowPlayerDialog(playerid, DIALOG_BUY_DRUG, DIALOG_STYLE_LIST, "Droga", "1g		"EMB_DOLLARGREEN"$1.000"EMB_WHITE"\n10g		"EMB_DOLLARGREEN"$10.000"EMB_WHITE"\n15g		"EMB_DOLLARGREEN"$15.000"EMB_WHITE"\
							\n20g		"EMB_DOLLARGREEN"$20.000"EMB_WHITE"", "Avanti", "Esci");
						return 0;
					}
					PlayerInfo[playerid][playerDrug] += 1;
					GivePlayerMoneyEx(playerid, -1000);
					SendClientMessage(playerid, COLOR_GREEN, "Hai acquistato 1 grammo di droga per 1000$!");
				}
				case 1: //10g		10000$
				{
					if(GetPlayerMoneyEx(playerid) < 10000)
					{
						SendClientMessage(playerid, COLOR_RED, "Non hai abbastanza soldi!");
						ShowPlayerDialog(playerid, DIALOG_BUY_DRUG, DIALOG_STYLE_LIST, "Droga", "1g		"EMB_DOLLARGREEN"$1.000"EMB_WHITE"\n10g		"EMB_DOLLARGREEN"$10.000"EMB_WHITE"\n15g		"EMB_DOLLARGREEN"$15.000"EMB_WHITE"\
							\n20g		"EMB_DOLLARGREEN"$20.000"EMB_WHITE"", "Avanti", "Esci");
						return 0;
					}
					PlayerInfo[playerid][playerDrug] += 10;
					GivePlayerMoneyEx(playerid, -10000);
					SendClientMessage(playerid, COLOR_GREEN, "Hai acquistato 10 grammi di droga per 10000$!");
				}
				case 2: //15g		15000$
				{
					if(GetPlayerMoneyEx(playerid) < 15000)
					{
						SendClientMessage(playerid, COLOR_RED, "Non hai abbastanza soldi!");
						ShowPlayerDialog(playerid, DIALOG_BUY_DRUG, DIALOG_STYLE_LIST, "Droga", "1g		"EMB_DOLLARGREEN"$1.000"EMB_WHITE"\n10g		"EMB_DOLLARGREEN"$10.000"EMB_WHITE"\n15g		"EMB_DOLLARGREEN"$15.000"EMB_WHITE"\
							\n20g		"EMB_DOLLARGREEN"$20.000"EMB_WHITE"", "Avanti", "Esci");
						return 0;
					}
					PlayerInfo[playerid][playerDrug] += 15;
					GivePlayerMoneyEx(playerid, -15000);
					SendClientMessage(playerid, COLOR_GREEN, "Hai acquistato 15 grammi di droga per 15000$!");
				}
				case 3: //20g		20000$
				{
					if(GetPlayerMoneyEx(playerid) < 20000)
					{
						SendClientMessage(playerid, COLOR_RED, "Non hai abbastanza soldi!");
						ShowPlayerDialog(playerid, DIALOG_BUY_DRUG, DIALOG_STYLE_LIST, "Droga", "1g		"EMB_DOLLARGREEN"$1.000"EMB_WHITE"\n10g		"EMB_DOLLARGREEN"$10.000"EMB_WHITE"\n15g		"EMB_DOLLARGREEN"$15.000"EMB_WHITE"\
							\n20g		"EMB_DOLLARGREEN"$20.000"EMB_WHITE"", "Avanti", "Esci");
						return 0;
					}
					PlayerInfo[playerid][playerDrug] += 20;
					GivePlayerMoneyEx(playerid, -20000);
					SendClientMessage(playerid, COLOR_GREEN, "Hai acquistato 20 grammi di droga per "EMB_DOLLARGREEN"$20.000!");
				}
				case 4: //Importo Personalizzato
				{

				}
			}
		}
		case DIALOG_POLICE_WEAPONS:
		{
			if(!response)return 0;
			switch(listitem)
			{
				case 0://9mm
				{
					if(PlayerInfo[playerid][playerTickets] < COLT_TICKET)return SendClientMessage(playerid, COLOR_RED, "Non hai abbastanza tickets!");
					GivePlayerWeaponEx(playerid, 22, 40);
					PlayerInfo[playerid][playerTickets] -= COLT_TICKET;
					return 1;
				}
				case 1: //D. Eagle
				{
					if(PlayerInfo[playerid][playerTickets] < DEAGLE_TICKET)return SendClientMessage(playerid, COLOR_RED, "Non hai abbastanza tickets!");
					GivePlayerWeaponEx(playerid, 24, 50);
					PlayerInfo[playerid][playerTickets] -= DEAGLE_TICKET;
					return 1;
				}
				case 2: //Shotgun
				{
					if(PlayerInfo[playerid][playerTickets] < SHOTGUN_TICKET)return SendClientMessage(playerid, COLOR_RED, "Non hai abbastanza tickets!");
					GivePlayerWeaponEx(playerid, 25, 30);
					PlayerInfo[playerid][playerTickets] -= SHOTGUN_TICKET;
					return 1;
				}
				case 3: //Shawnoff
				{
					if(PlayerInfo[playerid][playerTickets] < SHAWNOFF_TICKET)return SendClientMessage(playerid, COLOR_RED, "Non hai abbastanza tickets!");
					GivePlayerWeaponEx(playerid, 26, 15);
					PlayerInfo[playerid][playerTickets] -= SHAWNOFF_TICKET;
					return 1;
				}
				case 4: //Spas
				{
					if(PlayerInfo[playerid][playerTickets] < SPAS_TICKET)return SendClientMessage(playerid, COLOR_RED, "Non hai abbastanza tickets!");
					GivePlayerWeaponEx(playerid, 27, 10);
					PlayerInfo[playerid][playerTickets] -= SPAS_TICKET;
					return 1;
				}
				case 5: //Uzi
				{
					if(PlayerInfo[playerid][playerTickets] < UZI_TICKET)return SendClientMessage(playerid, COLOR_RED, "Non hai abbastanza tickets!");
					GivePlayerWeaponEx(playerid, 28, 100);
					PlayerInfo[playerid][playerTickets] -= UZI_TICKET;
					return 1;
				}
				case 6: //Tec9
				{
					if(PlayerInfo[playerid][playerTickets] < TEC_TICKET)return SendClientMessage(playerid, COLOR_RED, "Non hai abbastanza tickets!");
					GivePlayerWeaponEx(playerid, 32, 100);
					PlayerInfo[playerid][playerTickets] -= TEC_TICKET;
					return 1;
				}
				case 7: //MP5
				{
					if(PlayerInfo[playerid][playerTickets] < MP5_TICKET)return SendClientMessage(playerid, COLOR_RED, "Non hai abbastanza tickets!");
					GivePlayerWeaponEx(playerid, 29, 150);
					PlayerInfo[playerid][playerTickets] -= MP5_TICKET;
					return 1;
				}
				case 8: //AK
				{
					if(PlayerInfo[playerid][playerTickets] < AK_TICKET)return SendClientMessage(playerid, COLOR_RED, "Non hai abbastanza tickets!");
					GivePlayerWeaponEx(playerid, 30, 120);
					PlayerInfo[playerid][playerTickets] -= AK_TICKET;
					return 1;
				}
				case 9: //M4
				{
					if(PlayerInfo[playerid][playerTickets] < M4_TICKET)return SendClientMessage(playerid, COLOR_RED, "Non hai abbastanza tickets!");
					GivePlayerWeaponEx(playerid, 31, 150);
					PlayerInfo[playerid][playerTickets] -= M4_TICKET;
					return 1;
				}
				case 10: //Armour
				{
					if(PlayerInfo[playerid][playerTickets] < ARMOUR_TICKET)return SendClientMessage(playerid, COLOR_RED, "Non hai abbastanza tickets!");
					SetPlayerArmour(playerid, 99.0);
					PlayerInfo[playerid][playerTickets] -= ARMOUR_TICKET;
					return 1;
				}
				case 11: //Medikit
				{
					if(PlayerInfo[playerid][playerTickets] < MEDIKIT_TICKET)return SendClientMessage(playerid, COLOR_RED, "Non hai abbastanza tickets!");
					SetPlayerHealth(playerid, 99.0);
					PlayerInfo[playerid][playerTickets] -= MEDIKIT_TICKET;
					return 1;
				}
			}
		}
		case DIALOG_POLICE_ELEVATOR:
		{
			if(!response)return 0;
			switch(listitem)
			{
				case 0:
				{
					if(IsPlayerInRangeOfPoint(playerid, 3.0, 1568.5887,-1689.9709,6.2188))return SendClientMessage(playerid, -1, "Sei gia' al parcheggio!");
					SetPlayerPos(playerid, 1568.5887,-1689.9709,6.2188);
					SetPlayerInterior(playerid, 0);
				}
				case 1:
				{
					if(IsPlayerInRangeOfPoint(playerid, 3.0, 242.2487,66.3135,1003.6406))return SendClientMessage(playerid, -1, "Sei gia' alla Stazione di Polizia");
					SetPlayerPos(playerid, 242.2487,66.3135,1003.6406);
					SetPlayerInterior(playerid, 6);
				}
				case 2:
				{
					if(IsPlayerInRangeOfPoint(playerid, 3.0, 1565.0767,-1667.0001,28.3956))return SendClientMessage(playerid, -1, "Sei gia' sul tetto");
					SetPlayerPos(playerid, 1565.0767,-1667.0001,28.3956);
					SetPlayerInterior(playerid, 0);
				}
			}
		}
		case DIALOG_WEAPOND_SELL:
		{
			if(!response)
			{
				BuyerID[ WorkSellerID[playerid][WORK_WEAPONSD] ] = INVALID_PLAYER_ID;
				WorkSellerID[playerid][WORK_WEAPONSD] = INVALID_PLAYER_ID;
				return 0;
			}
			if(GetPlayerMoneyEx(playerid) < WeaponDealerArray[listitem][Price]) return SendClientMessage(playerid, COLOR_RED, "> Non hai abbastanza soldi!");
			GivePlayerMoneyEx(WorkSellerID[playerid][WORK_WEAPONSD], WeaponDealerArray[listitem][Price]);
			GivePlayerMoneyEx(playerid, -WeaponDealerArray[listitem][Price]);
			GivePlayerWeaponEx(playerid, WeaponDealerArray[listitem][ID], WeaponDealerArray[listitem][Ammo]);
			new string[76], wname[32];
			GetWeaponName(WeaponDealerArray[listitem][ID], wname, sizeof(wname));
			format(string,sizeof(string), "Hai acquistato %s da %s per il costo di "EMB_DOLLARGREEN"%s",wname, PlayerInfo[WorkSellerID[playerid][WORK_WEAPONSD]][playerName], ConvertPrice(WeaponDealerArray[listitem][Price]));
			SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
			return ShowDealerDialog(playerid);
		}
		case DIALOG_DEALERBUY:
		{
			new sid = GetPlayerShowroomArea(playerid), cid;
			for(new i = 0; i < MAX_CARS; i++)
			{
				if(GetVehicleModel(GetPlayerVehicleID(playerid)) == ShowroomVehicle[sid][i][sModel]) cid = i;
			}
			if(GetPlayerMoneyEx(playerid) < ShowroomVehicle[sid][cid][sPrice]) return SendClientMessage(playerid, COLOR_RED, "> Non hai abbastanza soldi!");
			if(PlayerInfo[playerid][playerPremium] == PLAYER_NO_PREMIUM && GetPlayerVehicleCount(playerid) == NORMAL_PLAYER_SLOT-1)
			{
				return SendClientMessage(playerid, COLOR_RED, "Possiedi troppi veicoli!");
			}
			else if(PlayerInfo[playerid][playerPremium] != PLAYER_NO_PREMIUM && GetPlayerVehicleCount(playerid) == PREMIUM_PLAYER_SLOT-1)
			{
				return SendClientMessage(playerid, COLOR_RED, "Possiedi troppi veicoli!");
			}
			if(GetPlayerFreeSlot(playerid) == 0)return SendClientMessage(playerid, COLOR_RED, "Possiedi troppi veicoli!");
			new id = CreatePlayerVehicle(playerid, GetVehicleModel(GetPlayerVehicleID(playerid)),ShowroomPickupPos[sid][0], ShowroomPickupPos[sid][1], ShowroomPickupPos[sid][2], 0.0, random(200), random(200));
			new string[200];
			format(string, sizeof(string), "Hai acquistato questo veicolo per %s!, Ricordati di parcheggiarlo tramite il /vmenu", ConvertPrice(ShowroomVehicle[sid][cid][sPrice]));
			SendClientMessage(playerid, COLOR_GREEN, string);
			PutPlayerInVehicle(playerid, id, 0);
			GivePlayerMoneyEx(playerid, -ShowroomVehicle[sid][cid][sPrice]);
			return 1;			
		}
	}
	return 1;
}

forward LoginPlayer(playerid);
public LoginPlayer(playerid)
{
	new cout;
	cache_get_row_count(cout);
	if(cout)
	{
		new query[132];
		PlayerInfo[playerid][playerLogged] = true;
		mysql_format(MySQLC, query, sizeof(query), "SELECT * FROM `Players` WHERE `Name` = '%e'", PlayerInfo[playerid][playerName]);
		mysql_tquery(MySQLC, query, "LoadPlayer", "d", playerid);
		if(PlayerInfo[playerid][playerAdmin] > 0)
		{
			new string[100];
			format(string, sizeof(string), "Sei loggato come admin livello %d", PlayerInfo[playerid][playerAdmin]);
			SendClientMessage(playerid, COLOR_GREEN, string);
		}
	}
	else
	{
		playerLoggedFails[playerid] ++;
		if(playerLoggedFails[playerid] >= 3)
		{
			SendClientMessage(playerid, COLOR_RED, "Sei stato kickato perche' hai sbagliato password 3 volte!");
			return Kick(playerid);
		}
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "{FF0000}Password errata.\n{FFFFFF}Inserisci la tua password per loggare!", "Login!", "Esci");
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid)
{
	if(issuerid != INVALID_PLAYER_ID && !playerADuty[playerid])
	{
		if(GetPlayerTeam(playerid) != GetPlayerTeam(issuerid))
		{
			new Float:HP, Float:Armour;
			GetPlayerHealth(playerid, HP);
			GetPlayerArmour(playerid, Armour);
			new Damage;
			switch(weaponid)
			{
				case 22: Damage = 14; // 9mm
				case 23: Damage = 15; // 9mm Silenziata
				case 24: Damage = 30; // D.E.
				case 25: Damage = 30; // Shotgun
				case 26: Damage = 15; // Canne Mozze
				case 27: Damage = 10; // Spas
				case 28: Damage = 10; // Micro Uzi
				case 29: Damage = 25; // MP5
				case 30: Damage = 15; // AK47
				case 31: Damage = 10; // M4
				case 32: Damage = 15; // Tec9
				case 33: Damage = 45; // C-Rifle
				case 34: Damage = 95; // Rifle
				case 38: Damage = 0; // Minigun
				case 41: Damage = 3; // Spraygun
			}
			if(Armour > Damage)SetPlayerArmour(playerid, Armour-Damage);
			else if(Armour == Damage)SetPlayerArmour(playerid, 0);
			else if(Armour > 0 && Armour < Damage)
			{
				new val = floatround(Armour)-Damage;
				SetPlayerArmour(playerid, 0);
				SetPlayerHealth(playerid, HP + val);
			}
			else SetPlayerHealth(playerid, HP-Damage);
		}
	}
	return 1;
}

stock SendPlayerVehicle(playerid, playertosend, slotid)
{
	new slotforplayer = GetPlayerFreeSlot(playertosend);
	new query[256];
	mysql_format(MySQLC, query, 256, "UPDATE `PlayerVehicle` SET OwnerID = '%d', Slot = '%d', OwnerName = '%s' WHERE `OwnerID` = '%d' AND `Slot` = '%d'",
		PlayerInfo[playertosend][playerID],
		slotforplayer,
		PlayerInfo[playertosend][playerName],
		PlayerInfo[playerid][playerID],
		slotid);
	mysql_tquery(MySQLC, query);
	PlayerVehicle[playertosend][slotforplayer][vID] = PlayerVehicle[playerid][slotid][vID];
	PlayerVehicle[playerid][slotid][vID] = 0;
	new vid = PlayerVehicle[playertosend][slotforplayer][vID];
	strcpy(VehicleInfo[vid][vOwnerName], PlayerInfo[playertosend][playerName], 24);
	VehicleInfo[vid][vOwnerID] = PlayerInfo[playertosend][playerID];
	SavePlayerVehicle(playertosend);
	vehicleCount[playerid] --;
	vehicleCount[playertosend] ++;
}

stock DeletePlayerVehicles(playerid, slotid)
{
	new query[256];
	DestroyVehicle(PlayerVehicle[playerid][slotid][vID]);
	Iter_Remove(ServerVehicle, PlayerVehicle[playerid][slotid][vID]);
	new vid = PlayerVehicle[playerid][slotid][vID];
	VehicleInfo[vid][vOwned] = false;
	VehicleInfo[vid][vModel] = 0;
	VehicleInfo[vid][vX] = 0.0;
	VehicleInfo[vid][vY] = 0.0;
	VehicleInfo[vid][vZ] = 0.0;
	VehicleInfo[vid][vA] = 0.0;
	VehicleInfo[vid][vColor1] = 0;
	VehicleInfo[vid][vColor2] = 0;
	PlayerVehicle[playerid][slotid][vID] = 0;
	vehicleCount[playerid] --;
}

stock RemovePlayerVehicle(playerid, ownerid, slotid)
{
	new query[256];
	mysql_format(MySQLC, query, 256, "DELETE FROM `PlayerVehicle` WHERE `OwnerID` = '%d' AND `Slot` = '%d'", ownerid, slotid);
	mysql_tquery(MySQLC, query);
	DestroyVehicle(PlayerVehicle[playerid][slotid][vID]);
	Iter_Remove(ServerVehicle, PlayerVehicle[playerid][slotid][vID]);
	new vid = PlayerVehicle[playerid][slotid][vID];
	VehicleInfo[vid][vOwned] = false;
	VehicleInfo[vid][vModel] = 0;
	VehicleInfo[vid][vX] = 0.0;
	VehicleInfo[vid][vY] = 0.0;
	VehicleInfo[vid][vZ] = 0.0;
	VehicleInfo[vid][vA] = 0.0;
	VehicleInfo[vid][vColor1] = 0;
	VehicleInfo[vid][vColor2] = 0;
	PlayerVehicle[playerid][slotid][vID] = 0;
	vehicleCount[playerid] --;
}

forward LoadPlayer(playerid);
public LoadPlayer(playerid)
{
	if(!PlayerInfo[playerid][playerLogged])return 0;
	new cout, field, skills[200];
	cache_get_row_count(cout);
	cache_get_value_index_int(0, 0, PlayerInfo[playerid][playerID]);
	cache_get_value_index_int(0, 3, PlayerInfo[playerid][playerMoney]);
	GivePlayerMoneyEx(playerid, PlayerInfo[playerid][playerMoney]);
	cache_get_value_index_int(0, 4, PlayerInfo[playerid][playerBank]);
	cache_get_value_index_int(0, 5, PlayerInfo[playerid][playerAdmin]);
	cache_get_value_index(0, 6, skills);
	sscanf(skills, "p<,>iiii",
		PlayerSkill[playerid][skillRobber],
		PlayerSkill[playerid][skillPolice],
		PlayerSkill[playerid][skillVehicleStolen],
		PlayerSkill[playerid][skillWeaponsD]);
	cache_get_value_index_int(0, 7, PlayerInfo[playerid][playerJailTime]);
	cache_get_value_index_int(0, 8, PlayerInfo[playerid][playerPremiumTime]);
	cache_get_value_index_int(0, 9, PlayerInfo[playerid][playerPremium]);
	if(PlayerInfo[playerid][playerPremium] != PLAYER_NO_PREMIUM)
	{
		if(PlayerInfo[playerid][playerPremiumTime] != 0)
		{
			if(PlayerInfo[playerid][playerPremiumTime] >= gettime()) //Control Time Premium
			{
				new Float:Pos[3];
				GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
				if(PlayerInfo[playerid][playerPremium] == PLAYER_PREMIUM_BRONZE)
				{
					playerPremiumLabel[playerid] = CreateDynamic3DTextLabel("Premium Bronzo", COLOR_GOLD, Pos[0], Pos[1], Pos[2]+0.3, 30, playerid);
				}
				else if(PlayerInfo[playerid][playerPremium] == PLAYER_PREMIUM_SILVER)
				{
					playerPremiumLabel[playerid] = CreateDynamic3DTextLabel("Premium Argento", COLOR_GOLD, Pos[0], Pos[1], Pos[2]+0.3, 30, playerid);
				}
				else if(PlayerInfo[playerid][playerPremium] == PLAYER_PREMIUM_GOLD)
				{
					playerPremiumLabel[playerid] = CreateDynamic3DTextLabel("Premium Oro", COLOR_GOLD, Pos[0], Pos[1], Pos[2]+0.3, 30, playerid);
				}
			}
			else if(gettime() > PlayerInfo[playerid][playerPremiumTime])
			{
				DestroyDynamic3DTextLabel(playerPremiumLabel[playerid]);
				SendClientMessage(playerid, COLOR_GREEN, "** Il tuo Premium e' scaduto **");
				PlayerInfo[playerid][playerPremium] = PLAYER_NO_PREMIUM;
				PlayerInfo[playerid][playerPremiumTime] = 0;
				new string[140];
				mysql_format(MySQLC, string, sizeof(string), "UPDATE `Players` SET PremiumTime = '0', Premium = '0' WHERE `ID` = '%d' AND `Name` = '%s'", PlayerInfo[playerid][playerID], PlayerInfo[playerid][playerName]);
				mysql_tquery(MySQLC, string);
			}
		}
	}
	cache_get_value_index_int(0, 10, field);
	if(field)
	{
		new string[128];
		format(string, 128, "Questo account (%s) risulta bannato.", PlayerInfo[playerid][playerName]);
		ShowPlayerDialog(playerid, 999, DIALOG_STYLE_MSGBOX, "Account Bannato", string, "...", "...");
		KickPlayer(playerid);
		return 0;
	}
	if(field > gettime()) //Control Time Ban
	{
		new string[100];
		//  mtime_UnixToDate(string, strval(field), DATE_LITTLEENDIAN, CLOCK_EUROPEAN);
		format(string, 128, "Il ban scade il %s.", string);
		ShowPlayerDialog(playerid, 999, DIALOG_STYLE_MSGBOX, "Account Bannato", string, "...", "...");
		KickPlayer(playerid);
		return 0;
	}
	cache_get_value_index_int(0, 11, PlayerInfo[playerid][playerBanTime]);
	cache_get_value_index_int(0, 12, PlayerInfo[playerid][playerRewards]);
	cache_get_value_index_int(0, 13, PlayerInfo[playerid][playerRewardMoney]);
	cache_get_value_index_int(0, 14, PlayerInfo[playerid][playerDrug]);
	cache_get_value_index_int(0, 15, PlayerInfo[playerid][playerKills]);
	cache_get_value_index_int(0, 16, PlayerInfo[playerid][playerDeaths]);
	//cache_get_value_index_int(0, 17, PlayerInfo[playerid][playerGroupID]);
	cache_get_value_index_int(0, 18, PlayerInfo[playerid][playerTickets]);
	cache_get_value_index_int(0, 19, PlayerInfo[playerid][playerRegisterDate]);
	//cache_get_value_index_int(0, 20, PlayerInfo[playerid][player]);
	cache_get_value_index_int(0, 21, PlayerInfo[playerid][playerGainRobberies]);
	cache_get_value_index_int(0, 22, PlayerInfo[playerid][playerGainVehicleStolen]);
	cache_get_value_index_int(0, 23, PlayerInfo[playerid][playerGainWeaponsD]);
	PlayerInfo[playerid][playerHouse] = NO_HOUSE;
	for(new i = 0; i<MAX_HOUSES; i++)
	{
		if(HouseInfo[i][hCreated] == false)continue;
		if(HouseInfo[i][hOwnerID] == PlayerInfo[playerid][playerID])
		{
			PlayerInfo[playerid][playerHouse] = i;
			break;
		}
	}
	new string[128];
	format(string, sizeof(string), "%s[%d] e' entrato nel server!", PlayerInfo[playerid][playerName], playerid);
	SendClientMessageToAll(COLOR_GREY, string);
	new query[124];
	mysql_format(MySQLC, query, sizeof(query), "SELECT * FROM `PlayerStats` WHERE `Name` = '%e' AND `ID` = '%d'", PlayerInfo[playerid][playerName], PlayerInfo[playerid][playerID]);
	mysql_tquery(MySQLC, query, "LoadPlayerStats", "d", playerid);
	mysql_format(MySQLC, query, sizeof(query), "SELECT * FROM `playervehicle` WHERE `OwnerID` = '%d'", PlayerInfo[playerid][playerID]);
	mysql_tquery(MySQLC, query, "LoadPlayerVehicles", "d", playerid);
	return 1;
}

forward LoadPlayerStats(playerid);
public LoadPlayerStats(playerid)
{
	if(!PlayerInfo[playerid][playerLogged])return 0;
	new cout;
	cache_get_row_count(cout);
	for(new i = 0; i < cout; i++)
	{
		cache_get_value_index_int(i, 2, PlayerInfo[playerid][playerGainRobberies]);
		cache_get_value_index_int(i, 3, PlayerInfo[playerid][playerGainVehicleStolen]);
		cache_get_value_index_int(i, 4, PlayerInfo[playerid][playerGainWeaponsD]);
		cache_get_value_index_int(i, 5,	PlayerInfo[playerid][playerGainDrugsD]);
	}
	return 1;
}

forward LoadPlayerVehicles(playerid);
public LoadPlayerVehicles(playerid)
{
	new cout, modstring[4*17*3], vmodel, Float:Pos[4], c1, c2, vowner, vclosed, vid;
	cache_get_row_count(cout);
	for(new i = 0; i < cout; i++)
	{
		cache_get_value_index_int(i, 2, vowner);
		cache_get_value_index(i, 3, VehicleInfo[vid][vOwnerName]);
		cache_get_value_index_int(i, 4, vmodel);
		cache_get_value_index_float(i, 5, Pos[0]);
		cache_get_value_index_float(i, 6, Pos[1]);
		cache_get_value_index_float(i, 7, Pos[2]);
		cache_get_value_index_float(i, 8, Pos[3]);
		cache_get_value_index_int(i, 9, c1);
		cache_get_value_index_int(i, 10, c2);
		cache_get_value_index_int(i, 11, vclosed);
		cache_get_value_index(i, 12, modstring);
		PlayerVehicle[playerid][i][vID] = CreateVehicle(vmodel, Pos[0], Pos[1], Pos[2], Pos[3], c1, c2, -1);
		vid = PlayerVehicle[playerid][i][vID];
		printf("Owner: %d, Color 1: %d, Closed: %d, vvid: %d", vowner, c1, vclosed,vid);
		VehicleInfo[vid][vOwned] = true;
		VehicleInfo[vid][vOwnerID] = vowner;
		VehicleInfo[vid][vModel] = vmodel;
		VehicleInfo[vid][vX] = Pos[0];
		VehicleInfo[vid][vY] = Pos[1];
		VehicleInfo[vid][vZ] = Pos[2];
		VehicleInfo[vid][vA] = Pos[3];
		VehicleInfo[vid][vColor1] = c1;
		VehicleInfo[vid][vColor2] = c2;
		VehicleInfo[vid][vClosed] = vclosed;	
		new idvc = PlayerVehicle[playerid][i][vID];
		sscanf(modstring, "p<,>iiiiiiiiiiiiiiiiii", VehicleInfo[idvc][vMod][0], VehicleInfo[idvc][vMod][1], VehicleInfo[idvc][vMod][2], VehicleInfo[idvc][vMod][3],
			VehicleInfo[idvc][vMod][4], VehicleInfo[idvc][vMod][5], VehicleInfo[idvc][vMod][6], VehicleInfo[idvc][vMod][7],
			VehicleInfo[idvc][vMod][8], VehicleInfo[idvc][vMod][9], VehicleInfo[idvc][vMod][10], VehicleInfo[idvc][vMod][11],
			VehicleInfo[idvc][vMod][12], VehicleInfo[idvc][vMod][13], VehicleInfo[idvc][vMod][14], VehicleInfo[idvc][vMod][15],
			VehicleInfo[idvc][vMod][16], VehicleInfo[idvc][vMod][17]);
		for(new mod = 0; mod < 18; mod++)
		{
			if(!IsVehicleComponentLegal(GetVehicleModel(PlayerVehicle[playerid][i][vID]), VehicleInfo[PlayerVehicle[playerid][i][vID]][vMod][mod]))continue;
			AddVehicleComponent(PlayerVehicle[playerid][i][vID], VehicleInfo[PlayerVehicle[playerid][i][vID]][vMod][mod]);
			if(VehicleInfo[PlayerVehicle[playerid][i][vID]][vMod][17] != 3)
			{
				ChangeVehiclePaintjob(PlayerVehicle[playerid][i][vID], VehicleInfo[idvc][vMod][17]);
			}
		}
		vehicleCount[playerid] ++;
		Iter_Add(ServerVehicle, PlayerVehicle[playerid][i][vID]);
		SetVehicleParamsEx(PlayerVehicle[playerid][i][vID], true, false, false, false, false, false, false);
	}
	return 1;
}

stock SavePlayerVehicle(playerid)
{
	if(GetPlayerVehicleCount(playerid) == 0)return 0;
	new vid, query[512], string[10];
	for(new i = 1; i<MAX_VEHICLE_SLOT; i++)
	{
		if(PlayerVehicle[playerid][i][vID] == 0)continue;
		new stry[256];
		for(new mod = 0; mod<18; mod++)
		{
			format(string, sizeof(string), "%d,", VehicleInfo[ PlayerVehicle[playerid][i][vID] ][vMod][mod]);
			strcat(stry, string);
		}
		vid = PlayerVehicle[playerid][i][vID];
		mysql_format(MySQLC, query, sizeof query, "UPDATE `playervehicle` SET OwnerID = '%d', OwnerName = '%s', Model = '%d', X = '%f', Y = '%f', Z = '%f', A = '%f',\
			Color1 = '%d', Color2 = '%d', Closed = '%d', VehicleMod = '%s' WHERE `OwnerID` = '%d' AND `Slot` = '%d'",
			VehicleInfo[vid][vOwnerID], PlayerInfo[playerid][playerName], VehicleInfo[vid][vModel],VehicleInfo[vid][vX], VehicleInfo[vid][vY], VehicleInfo[vid][vZ], VehicleInfo[vid][vA],
			VehicleInfo[vid][vColor1], VehicleInfo[vid][vColor2], VehicleInfo[vid][vClosed], stry,
			PlayerInfo[playerid][playerID], i);
		mysql_tquery(MySQLC, query);
	}
	return 1;
}

stock GetPlayerVehicleCount(playerid) return vehicleCount[playerid];

forward RegisterPlayerAccount(playerid);
public RegisterPlayerAccount(playerid)
{
	new query[500], finalstring[20], string2[10];
	for(new skill = 0; skill < _: ENUM_SKILLS; skill++)
	{
		format(string2, sizeof(string2), "%d,", PlayerSkill[playerid][ENUM_SKILLS: skill]);
		strcat(finalstring, string2);
	}
	mysql_format(MySQLC, query, sizeof(query), "INSERT INTO `PlayerStats` (`ID`, `Name`, `GainRobberies`, `GainVehicleStolen`, `GainWeaponsDealer`, `GainDrugsDealer`) VALUES('%d', '%s', 0, 0, 0, 0)", cache_insert_id(), PlayerInfo[playerid][playerName]);
	mysql_tquery(MySQLC, query);
	return 1;
}

stock SavePlayer(playerid)
{
	if(!PlayerInfo[playerid][playerLogged])return 0;
	new query[420], finalstring[20], string2[10], weapstring[50];
	for(new skill = 0; skill < _: ENUM_SKILLS; skill++)
	{
		format(string2, sizeof(string2), "%d,", PlayerSkill[playerid][ENUM_SKILLS: skill]);
		strcat(finalstring, string2);
	}
	mysql_format(MySQLC, query, sizeof query, "UPDATE `Players` SET Money = '%d', Bank = '%d', Admin = '%d', Skills = '%s', JailTime = '%d', Drug = '%d', RewardMoney = '%d', Rewards = '%d', Kills = '%d', Deaths = '%d', Tickets = '%d', LastLogin = '%d' WHERE `Name` = '%e' AND `ID` = '%d'",
		PlayerInfo[playerid][playerMoney],
		PlayerInfo[playerid][playerBank],
		PlayerInfo[playerid][playerAdmin],
		finalstring,
		PlayerInfo[playerid][playerJailTime],
		PlayerInfo[playerid][playerDrug],
		PlayerInfo[playerid][playerRewardMoney],
		PlayerInfo[playerid][playerRewards],
		PlayerInfo[playerid][playerKills],
		PlayerInfo[playerid][playerDeaths],
		PlayerInfo[playerid][playerTickets],
		gettime(),
		PlayerInfo[playerid][playerName], PlayerInfo[playerid][playerID]);
	mysql_tquery(MySQLC, query);
	mysql_format(MySQLC, query, sizeof query, "UPDATE `PlayerStats` SET GainRobberies = '%d', GainVehicleStolen = '%d', GainWeaponsDealer = '%d', GainDrugsDealer = '%d' WHERE `ID` = '%d' AND `Name` = '%s'",
		PlayerInfo[playerid][playerGainRobberies], PlayerInfo[playerid][playerGainVehicleStolen], PlayerInfo[playerid][playerGainWeaponsD],
		PlayerInfo[playerid][playerGainDrugsD], PlayerInfo[playerid][playerID], PlayerInfo[playerid][playerName]);
	mysql_tquery(MySQLC, query);
	new weapons[13][2];
	for(new i = 0; i <= 12; i++)
	{
		GetPlayerWeaponData(playerid, i, weapons[i][0], weapons[i][1]);
		if(PlayerInfo[playerid][playerWeapons][i] == true)
		{
			format(weapstring, sizeof(weapstring), "%s,%d,",weapons[i][0],weapons[i][1]);

		}
	}
	mysql_format(MySQLC, query,sizeof(query), "UPDATE `Players` SET Weapons = '%s' WHERE `Name` = '%s'", weapstring, PlayerInfo[playerid][playerName]);
	mysql_tquery(MySQLC, query);
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	if(PlayerInfo[playerid][playerAdmin] > 0)
	{
		if(playerADuty[playerid] == true)
		{
			if(IsPlayerInAnyVehicle(playerid))
			{
				SetVehiclePos(GetPlayerVehicleID(playerid), fX, fY, fZ);
			}
			else SetPlayerPosFindZ(playerid, fX, fY, fZ);
		}
	}
	return 1;
}
/*					Building creator							*/


stock CreateServerBuilding(ssName[], ssType = 0, Float:seX, Float:seY, Float:seZ, Float:seA,
	/*RobberYSystem (Optional for Building)*/ brTime = 0/*Time in Seconds*/, brMaxMoney = 0)
{
	BuildingInfo[BuildingCount__][bRobberyTime] = 0;
	strcpy(BuildingInfo[BuildingCount__][bName], ssName, 44);
	printf("Store: %s [ID: %d]", BuildingInfo[BuildingCount__][bName], BuildingCount__);
	BuildingInfo[BuildingCount__][bEnterX] = seX;
	BuildingInfo[BuildingCount__][bEnterY] = seY;
	BuildingInfo[BuildingCount__][bEnterZ] = seZ;
	BuildingInfo[BuildingCount__][bEnterA] = seA;
	BuildingInfo[BuildingCount__][bVirtualWorld] = 999+BuildingCount__;
	BuildingInfo[BuildingCount__][bRobbed] = false;
	SetBuildingInterior(BuildingCount__, ssType);
		/*	  Robbery System				 */
	if(brTime != 0 && brMaxMoney != 0)
	{
		BuildingInfo[BuildingCount__][bRobberyTime] = brTime;
		BuildingInfo[BuildingCount__][bMaxMoney] = brMaxMoney;
		BuildingInfo[BuildingCount__][bActor] = CreateActor(BuildingActors[ssType][Skin], BuildingActors[ssType][aX],BuildingActors[ssType][aY], BuildingActors[ssType][aZ], BuildingActors[ssType][aA]);
		SetActorVirtualWorld(BuildingInfo[BuildingCount__][bActor], 999+BuildingCount__);
		SetActorInvulnerable(BuildingInfo[BuildingCount__][bActor], false);
	}
		/*	  Pickups, Checkpoint & 3DText	 */
	BuildingInfo[BuildingCount__][bPickup] = CreateDynamicPickup(1318, 1, BuildingInfo[BuildingCount__][bEnterX], BuildingInfo[BuildingCount__][bEnterY], BuildingInfo[BuildingCount__][bEnterZ], 0, 0);
	BuildingInfo[BuildingCount__][bPickupE] = CreateDynamicPickup(1318, 1, BuildingInfo[BuildingCount__][bExitX], BuildingInfo[BuildingCount__][bExitY], BuildingInfo[BuildingCount__][bExitZ], BuildingInfo[BuildingCount__][bVirtualWorld], BuildingInfo[BuildingCount__][bInterior]);
	new string[44];
	format(string, 44, "%s", ssName);
	CreateDynamic3DTextLabel(string, /*COLOR_LAWNGREEN*/-1, seX, seY, seZ+0.8, 30.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0, -1, 50.0);
	BuildingCount__++;
	return BuildingCount__;
}

SetBuildingInterior(buildingid, sType__)
{
	BuildingInfo[buildingid][bType] = sType__;
	switch(BuildingInfo[buildingid][bType])
	{
		case BUILDING_TYPE_PIZZA:
		{
			BuildingInfo[buildingid][bExitX] = 372.4030;
			BuildingInfo[buildingid][bExitY] = -133.5242;
			BuildingInfo[buildingid][bExitZ] = 1001.4922;
			BuildingInfo[buildingid][bExitA] = 351.1090;
			BuildingInfo[buildingid][bInterior] = 5;
		}
		case BUILDING_TYPE_PROLAPS:
		{
			BuildingInfo[buildingid][bExitX] = 207.0199;
			BuildingInfo[buildingid][bExitY] = -140.3738;
			BuildingInfo[buildingid][bExitZ] = 1003.5078;
			BuildingInfo[buildingid][bExitA] = 355.2129;
			BuildingInfo[buildingid][bInterior] = 3;
		}
		case BUILDING_TYPE_AMMUNATION:
		{
			BuildingInfo[buildingid][bExitX] = 285.3919;
			BuildingInfo[buildingid][bExitY] = -41.6959;
			BuildingInfo[buildingid][bExitZ] = 1001.5156;
			BuildingInfo[buildingid][bExitA] = 355.8379;
			BuildingInfo[buildingid][bInterior] = 1;
		}
		case BUILDING_TYPE_SUBURBAN:
		{
			BuildingInfo[buildingid][bExitX] = 203.7045;
			BuildingInfo[buildingid][bExitY] = -50.6653;
			BuildingInfo[buildingid][bExitZ] = 1001.8047;
			BuildingInfo[buildingid][bExitA] = 359.9674;
			BuildingInfo[buildingid][bInterior] = 1;

		}
		case BUILDING_TYPE_VICTIM:
		{
			BuildingInfo[buildingid][bExitX] = 227.1483;
			BuildingInfo[buildingid][bExitY] = -8.2080;
			BuildingInfo[buildingid][bExitZ] = 1002.2109;
			BuildingInfo[buildingid][bExitA] = 87.6945;
			BuildingInfo[buildingid][bInterior] = 5;
		}
		case BUILDING_TYPE_DS:
		{
			BuildingInfo[buildingid][bExitX] = 204.1948;
			BuildingInfo[buildingid][bExitY] = -168.8568;
			BuildingInfo[buildingid][bExitZ] = 1000.5234;
			BuildingInfo[buildingid][bExitA] = 356.2799;
			BuildingInfo[buildingid][bInterior] = 14;
		}
		case BUILDING_TYPE_BINCO:
		{
			BuildingInfo[buildingid][bExitX] = 207.6918;
			BuildingInfo[buildingid][bExitY] = -111.2662;
			BuildingInfo[buildingid][bExitZ] = 1005.1328;
			BuildingInfo[buildingid][bExitA] = 353.0740;
			BuildingInfo[buildingid][bInterior] = 15;
		}
		case BUILDING_TYPE_CLUCKIN:
		{
			BuildingInfo[buildingid][bExitX] = 364.9864;
			BuildingInfo[buildingid][bExitY] = -11.8385;
			BuildingInfo[buildingid][bExitZ] = 1001.8516;
			BuildingInfo[buildingid][bExitA] = 354.7145;
			BuildingInfo[buildingid][bInterior] = 9;
		}
		case BUILDING_TYPE_STORE:
		{
			BuildingInfo[buildingid][bExitX] = -25.7816;
			BuildingInfo[buildingid][bExitY] = -188.2524;
			BuildingInfo[buildingid][bExitZ] = 1003.5469;
			BuildingInfo[buildingid][bExitA] = 356.4411;
			BuildingInfo[buildingid][bInterior] = 17;
			BuildingInfo[buildingid][bBuyPickup] = CreateDynamicPickup(1239, 1, buyPickupPosition[STOREV1][0], buyPickupPosition[STOREV1][1], buyPickupPosition[STOREV1][2], BuildingInfo[buildingid][bVirtualWorld], BuildingInfo[buildingid][bInterior]);
		}
		case BUILDING_TYPE_STOREV2:
		{
			BuildingInfo[buildingid][bExitX] = 6.1196;
			BuildingInfo[buildingid][bExitY] = -31.7604;
			BuildingInfo[buildingid][bExitZ] = 1003.5494;
			BuildingInfo[buildingid][bExitA] = 357.3812;
			BuildingInfo[buildingid][bInterior] = 10;
			BuildingInfo[buildingid][bBuyPickup] = CreateDynamicPickup(1239, 1, buyPickupPosition[STOREV2][0], buyPickupPosition[STOREV2][1], buyPickupPosition[STOREV2][2], BuildingInfo[buildingid][bVirtualWorld], BuildingInfo[buildingid][bInterior]);
		}
		case BUILDING_TYPE_TGB:
		{
			BuildingInfo[buildingid][bExitX] = 502.0562;
			BuildingInfo[buildingid][bExitY] = -67.5634;
			BuildingInfo[buildingid][bExitZ] = 998.7578;
			BuildingInfo[buildingid][bExitA] = 184.0571;
			BuildingInfo[buildingid][bInterior] = 11;
		}
		case BUILDING_TYPE_CS:
		{
			BuildingInfo[buildingid][bExitX] = 834.5635;
			BuildingInfo[buildingid][bExitY] = 7.5157;
			BuildingInfo[buildingid][bExitZ] = 1004.1870;
			BuildingInfo[buildingid][bExitA] = 89.8950;
			BuildingInfo[buildingid][bInterior] = 3;
		}
		case BUILDING_TYPE_DONUTS:
		{
			BuildingInfo[buildingid][bExitX] = 377.0972;
			BuildingInfo[buildingid][bExitY] = -191.6406;
			BuildingInfo[buildingid][bExitZ] = 1000.6328;
			BuildingInfo[buildingid][bExitA] = 358.7881;
			BuildingInfo[buildingid][bInterior] = 17;
		}
		case BUILDING_TYPE_BURGER:
		{
			BuildingInfo[buildingid][bExitX] = 362.8201;
			BuildingInfo[buildingid][bExitY] = -75.1178;
			BuildingInfo[buildingid][bExitZ] = 1001.5078;
			BuildingInfo[buildingid][bExitA] = 320.7571;
			BuildingInfo[buildingid][bInterior] = 10;
		}
		case BUILDING_TYPE_BARBER:
		{
			BuildingInfo[buildingid][bExitX] = 411.6866;
			BuildingInfo[buildingid][bExitY] = -23.0397;
			BuildingInfo[buildingid][bExitZ] = 1001.8047;
			BuildingInfo[buildingid][bExitA] = 3.8250;
			BuildingInfo[buildingid][bInterior] = 2;
		}
		case BUILDING_TYPE_TATTOO:
		{
			BuildingInfo[buildingid][bExitX] = -204.3865;
			BuildingInfo[buildingid][bExitY] = -27.2419;
			BuildingInfo[buildingid][bExitZ] = 1002.2734;
			BuildingInfo[buildingid][bExitA] = 357.8716;
			BuildingInfo[buildingid][bInterior] = 16;
		}
		case BUILDING_TYPE_GYM:
		{
			BuildingInfo[buildingid][bExitX] = 772.2747;
			BuildingInfo[buildingid][bExitY] = -5.4124;
			BuildingInfo[buildingid][bExitZ] = 1000.7285;
			BuildingInfo[buildingid][bExitA] = 0.0361;
			BuildingInfo[buildingid][bInterior] = 5;
		}
		case BUILDING_TYPE_CLUB:
		{
			BuildingInfo[buildingid][bExitX] = 493.4921;
			BuildingInfo[buildingid][bExitY] = -24.8563;
			BuildingInfo[buildingid][bExitZ] = 1000.6797;
			BuildingInfo[buildingid][bExitA] = 10.5771;
			BuildingInfo[buildingid][bInterior] = 17;
		}
		case BUILDING_TYPE_SEXY:
		{
			BuildingInfo[buildingid][bExitX] = -100.2337;
			BuildingInfo[buildingid][bExitY] = -24.9326;
			BuildingInfo[buildingid][bExitZ] = 1000.7188;
			BuildingInfo[buildingid][bExitA] = 1.5693;
			BuildingInfo[buildingid][bInterior] = 3;
		}
		case BUILDING_TYPE_ZIP:
		{
			BuildingInfo[buildingid][bExitX] = 161.3400;
			BuildingInfo[buildingid][bExitY] = -96.9926;
			BuildingInfo[buildingid][bExitZ] = 1001.8047;
			BuildingInfo[buildingid][bExitA] = 356.4966;
			BuildingInfo[buildingid][bInterior] = 18;
		}
	}
}

forward ResetBuildingVar(buildingid);
public ResetBuildingVar(buildingid)
{
	BuildingInfo[ buildingid ][bRobbed] = false;
	ClearActorAnimations(BuildingInfo[buildingid][bActor]);
	printf("Il building ''%s[%d]'' e' adesso derubabile!", BuildingInfo[ buildingid ][bName], buildingid);
	return 1;
}

forward TimeCounter(playerid, cc);
public TimeCounter(playerid, cc)
{
	if(PlayerInfo[playerid][playerJailTime] > 0)
	{
		PlayerInfo[playerid][playerJailTime] --;
	}
	new string[40];
	format(string, sizeof(string), "Tempo Rimanente: ~y~%d", cc);
	GameTextForPlayer(playerid, string, 1050, 3);
	TimeCounter__[playerid] = SetTimerEx("TimeCounter", 1000, false, "dd", playerid, cc - 1);
}


//== ClockSystem ==
forward UpdateClock();
public UpdateClock()
{
	clockSec++;
	format(clockstry, 20, "%02d:%02d", clockMins, clockSec);
	TextDrawSetString(Clock, clockstry);
	TextDrawShowForAll(Clock);
	if(clockSec == 60)
	{
		clockSec = 0;
		clockMins ++;
		format(clockstry, 20, "%02d:%02d", clockMins, clockSec);
		TextDrawSetString(Clock, clockstry);
		TextDrawShowForAll(Clock);
	}
	if(clockMins > 24)
	{
		clockSec = 0;
		clockMins = 0;
		TextDrawSetString(Clock, "00:00");
		TextDrawShowForAll(Clock);
	}
	SetWorldTime(clockMins);
	TextDrawShowForAll(Clock);
}

stock GetServerSeconds()
{
	return clockSec;
}

stock GetServerMinutes()
{
	return clockMins;
}

stock GetPlayerAdminLevel(playerid)return PlayerInfo[playerid][playerAdmin];

stock ClearPlayerVariables(playerid)
{
	/* ==== Enums & Array Reset ==== */
	for(new i = 0; i < _: PlayerEnum__; i++) PlayerInfo[playerid][PlayerEnum__: i] = 0;
	for(new S = 0; S < _: ENUM_SKILLS; S++)PlayerSkill[playerid][ENUM_SKILLS: S] = 0;
	for(new i = 0; i < MAX_WORKS; i++)WorkSellerID[playerid][i] = INVALID_PLAYER_ID;
	/* ==== Labels and Textdraws ==== */
	DestroyDynamic3DTextLabel(playerADutyLabel[playerid]);
	DestroyDynamic3DTextLabel(playerPremiumLabel[playerid]);
	PlayerTextDrawHide(playerid, TextLoot[playerid]);

	/* ==== Reset Checkpoints ==== */
	if(BoxvilleCheckpoint[playerid] != -1)
	{
		DestroyDynamicCP(BoxvilleCheckpoint[playerid]);
		BoxvilleCheckpoint[playerid] = -1;
	}

	/* ==== Spectating ==== */

	if(Spectating[playerid] == true)
	{
		TogglePlayerSpectating(playerid, 0);
		Spectating[playerid] = false;
		playerSpectated[playerid] = -1;
	}
	/* ==== Other Variables ====*/
	ClassSelection[playerid] = false;
	playerADuty[playerid] = false;
	gPlayerAnimLibsPreloaded[playerid] = false;
	playerInBank[playerid] = false;
	TogPM[playerid] = false;
	playerLoggedFails[playerid] = 0;
	RobbingBusiness[playerid] = -1;
	playerLastVehicle[playerid] = INVALID_VEHICLE_ID;
	UnFreezePlayer(playerid);
	Cuffed[playerid] = false;
	Tazed[playerid] = false;
	SetPlayerRobbableStatus(playerid, PLAYER_ROBBABLE);
	Drugged[playerid] = false;
	SetPlayerVirtualWorld(playerid, 0);
	playerInHouse[playerid] = NO_HOUSE;
	playerInBuilding[playerid] = NO_BUILDING;
	playerLoot[playerid] = 0;
	PlayerInfo[playerid][playerPremium] = PLAYER_NO_PREMIUM;
	PlayerInfo[playerid][playerHouse] = NO_HOUSE;
	PlayerInfo[playerid][playerLogged] = false;
	PlayerRobbingHouse[playerid] = false;
	BuyerID[playerid] = INVALID_PLAYER_ID;
	/* ==== Progress bars ==== */
	DestroyPlayerProgressBar(playerid, NoiseBar[playerid]);

	/* ==== Admin Vehicle ==== */
	if(adminVehicleSpawned[playerid] != INVALID_VEHICLE_ID)
	{
		DestroyVehicle(adminVehicleSpawned[playerid]);
		adminVehicleSpawned[playerid] = INVALID_VEHICLE_ID;
	}

	//Buying Vehicle
	if(playerBuyingVehicle[playerid] == true)
	{
		playerBuyingVehicle[playerid] = false;
		for(new i = 0; i < 8; i++)
		{
			PlayerTextDrawHide(playerid, showroomTD[playerid][i]);
		}
		CancelSelectTextDraw(playerid);
		SetVehicleVirtualWorld(showroom_Car[playerid], 0);
		showroom_Car[playerid] = 0;
		DestroyVehicle(showroom_Car[playerid]);
		vehicleColor1[playerid] = 0;
		vehicleColor2[playerid] = 0;
	}
	/* ==== Reset Timers ==== */
	KillTimer(DruggedTimer[playerid]);
	KillTimer(PlayerNoiseTimer[playerid]);
	KillTimer(InfoTextTimer[playerid]);
	KillTimer(InfoTextTimer2[playerid]);
	//VMENU & Player Cars
	vehicleMenuChoosed[playerid] = 0;
	vmenu_PlayerToSellVehPrice[playerid] = -1;
	vmenu_PlayerToSellVeh[playerid] = -1;
	vmenu_SellerID[playerid] = -1;
	for(new i = 1; i < MAX_VEHICLE_SLOT; i++)
	{
		if(PlayerVehicle[playerid][i][vID] == 0)continue;
		DestroyVehicle(PlayerVehicle[playerid][i][vID]);
		VehicleInfo[ PlayerVehicle[playerid][i][vID] ][vOwnerID] = 0;
		VehicleInfo[ PlayerVehicle[playerid][i][vID] ][vModel] = 0;
		VehicleInfo[ PlayerVehicle[playerid][i][vID] ][vX] = 0.0;
		VehicleInfo[ PlayerVehicle[playerid][i][vID] ][vMod][17] = 3;
		VehicleInfo[ PlayerVehicle[playerid][i][vID] ][vY] = 0.0;
		VehicleInfo[ PlayerVehicle[playerid][i][vID] ][vZ] = 0.0;
		VehicleInfo[ PlayerVehicle[playerid][i][vID] ][vA] = 0.0;
		VehicleInfo[ PlayerVehicle[playerid][i][vID] ][vColor1] = 0;
		VehicleInfo[ PlayerVehicle[playerid][i][vID] ][vColor2] = 0;
		VehicleInfo[ PlayerVehicle[playerid][i][vID] ][vOwned] = false;
		PlayerVehicle[playerid][i][vID] = 0;
		Iter_Remove(ServerVehicle, PlayerVehicle[playerid][i][vID]);
	}
	vehicleCount[playerid] = 0;
	/*	==== GPS ====	*/
	UsingGPS[playerid] = false;
	DestroyDynamicRaceCP(gps_Checkpoint[playerid]);
	/* ==== Spikestrips ==== */

	if(SpikeStrip_IsValid(playerSpikeStrip[playerid]))
	{
		SpikeStrip_Delete(playerSpikeStrip[playerid]);
		KillTimer(playerSpikeStripTimer[playerid]);
		playerSpikeStrip[playerid] = INVALID_OBJECT_ID;
	}
}

OnPlayerRequestClass__(playerid, classid)
{
	ClassSelection[playerid] = true;
	if(classid >= 0 && classid <= 8) //Polizia
	{
		GameTextForPlayer(playerid, "~b~Polizia", 3000, 3);
		PlayerInfo[playerid][playerTeam] = TEAM_POLICE;
		SetPlayerTeam(playerid, 0);
		SetPlayerPos(playerid, 2494.2454,-1689.1617,21.8154);
		SetPlayerFacingAngle(playerid, 1.2634);
		SetPlayerCameraPos(playerid, 2494.1138,-1680.6790,24.3791);
		SetPlayerCameraLookAt(playerid, 2494.2454,-1689.1617,21.8154);
	}
	else //Civili
	{
		GameTextForPlayer(playerid, "~b~Civile", 3000, 3);
		PlayerInfo[playerid][playerTeam] = TEAM_CIVILIAN;
		SetPlayerTeam(playerid, 0);
		SetPlayerPos(playerid, 2494.2454,-1689.1617,21.8154);
		SetPlayerFacingAngle(playerid, 1.2634);
		SetPlayerCameraPos(playerid, 2494.1138,-1680.6790,24.3791);
		SetPlayerCameraLookAt(playerid, 2494.2454,-1689.1617,21.8154);
	}
}


forward AntiRobSpawn(playerid);
public AntiRobSpawn(playerid)
{
	SendClientMessage(playerid, COLOR_GREEN, "> ANTI ROB SPAWN: Disabilitato");
	SetPlayerRobbableStatus(playerid, PLAYER_ROBBABLE);
	return 1;
}

SendMessageToTeam(teamid, colorid, text[])
{
	foreach(new i : Player)
	{
		if(!PlayerInfo[i][playerLogged])continue;
		if(PlayerInfo[i][playerTeam] != teamid)continue;
		SendMessageToPlayer(i, colorid, text);
	}
}

/*		Wanted System		*/

stock GivePlayerWantedLevelEx(playerid, level, reason[] = "")
{
	if(PlayerInfo[playerid][playerTeam] == TEAM_POLICE)
	{
		PlayerTextDrawHide(playerid, WantedLevelText[playerid]);
		PlayerInfo[playerid][playerWanted] = 0;
		SetPlayerColor(playerid, COLOR_BLUE);
		return printf("Il server ha tentato di settare il livello ricercato ad un poliziotto!");
	}
	PlayerInfo[playerid][playerWanted] += level;
	SetPlayerWantedLevel(playerid, PlayerInfo[playerid][playerWanted]);
	if(GetPlayerWantedLevelEx(playerid) > 0)
	{
		new stryaaa[5];
		format(stryaaa, sizeof(stryaaa), "%d", PlayerInfo[playerid][playerWanted]);
		PlayerTextDrawSetString(playerid, WantedLevelText[playerid], stryaaa);
		PlayerTextDrawShow(playerid, WantedLevelText[playerid]);
	}
	if(GetPlayerWantedLevelEx(playerid) == 0)
	{
		SetPlayerColor(playerid, COLOR_WHITE);
		SetPlayerTeam(playerid, 0);
	}
	if(GetPlayerWantedLevelEx(playerid) > 0 && 3 > GetPlayerWantedLevelEx(playerid))
	{
		SetPlayerColor(playerid, COLOR_YELLOW);
		SetPlayerTeam(playerid, 0);
	}
	else if(GetPlayerWantedLevelEx(playerid) > 2 && 7 > GetPlayerWantedLevelEx(playerid))
	{
		SetPlayerColor(playerid, COLOR_ORANGE);
		SetPlayerTeam(playerid, NO_TEAM);
	}
	else if(GetPlayerWantedLevelEx(playerid) > 7 && 12 > GetPlayerWantedLevelEx(playerid))
	{
		SetPlayerColor(playerid, COLOR_RED);
		SetPlayerTeam(playerid, NO_TEAM);
	}
	else if(GetPlayerWantedLevelEx(playerid) >= 12)
	{
		SetPlayerColor(playerid, COLOR_DARKRED);
		SetPlayerTeam(playerid, NO_TEAM);
	}
	if(GetPlayerAdminLevel(playerid) && playerADuty[playerid] == true)
	{
		SetPlayerHealth(playerid, 0x7F800000);
		SetPlayerColor(playerid, COLOR_GREEN);
	}
	SendClientMessage(playerid, COLOR_ORANGE, reason);
	new string[32];
	format(string, sizeof(string), "Nuovo livello ricercato: %d", PlayerInfo[playerid][playerWanted]);
	SendClientMessage(playerid, COLOR_ORANGE, string);
	PlayerTextDrawShow(playerid, WantedLevelText[playerid]);
	return 1;
}
/*				{PlayerColours}									*/
/*				1 - 2 Livello Ricercato: Giallo					*/
/*				3 - 6 Livello Ricercato: Arancione				*/
/*				7 - 12 Livello Ricercato: Rosso 				*/
/*				13 > Rosso Scuro     							*/
stock ResetPlayerWantedLevel(playerid)
{
	PlayerInfo[playerid][playerWanted] = 0;
	SetPlayerWantedLevel(playerid, 0);
	if(PlayerInfo[playerid][playerTeam] != TEAM_POLICE)
	{
		PlayerTextDrawSetString(playerid, WantedLevelText[playerid], "0");
		SetPlayerColor(playerid, COLOR_WHITE);
		PlayerTextDrawShow(playerid, WantedLevelText[playerid]);
	}
	SetPlayerTeam(playerid, 0);
}

stock GetPlayerWantedLevelEx(playerid)return PlayerInfo[playerid][playerWanted];

//

stock GivePlayerWeaponEx(playerid, weaponid, ammo)
{
	PlayerInfo[playerid][playerWeapons][weaponid] = true;
	GivePlayerWeapon(playerid, weaponid, ammo);
}

//Loot

stock GivePlayerLootMoney(playerid, money)
{
	new tdstring[15];
	playerLoot[playerid] += money;
	format(tdstring, sizeof(tdstring), "~g~%s", ConvertPrice(playerLoot[playerid]));
	PlayerTextDrawSetString(playerid, TextLoot[playerid], tdstring);
	if(playerLoot[playerid] > 0)
	{
		PlayerTextDrawShow(playerid, TextLoot[playerid]);
	}
}

//Bag Money
stock CreateServerBag(money, Float:X, Float:Y, Float:Z, interior, virtualw, time)//Returna l'ID della bag libera.
{
	for(new i = 0; i < sizeof(BagInfo); i++)
	{
		if(BagInfo[i][pMoneyBagCreated] == true)continue;
		BagInfo[i][pMoneyBagMoney] = money;
		BagInfo[i][pMoneyBagX] = X;
		BagInfo[i][pMoneyBagY] = Y;
		BagInfo[i][pMoneyBagZ] = Z;
		BagInfo[i][pMoneyBagCreated] = true;
		BagInfo[i][pMoneyBagPickup] = CreateDynamicPickup(1550, 1, BagInfo[i][pMoneyBagX], BagInfo[i][pMoneyBagY], BagInfo[i][pMoneyBagZ], virtualw, interior, -1);
		BagInfo[i][pMoneyBagTimer] = SetTimerEx("DestroyBagMoney", time*(60*1000), false, "d", i);
		return i;
	}
	return printf("Sono state create troppe bag!");
}

forward DestroyBagMoney(id);
public DestroyBagMoney(id)
{
	BagInfo[id][pMoneyBagMoney] = 0;
	BagInfo[id][pMoneyBagX] = 0.0;
	BagInfo[id][pMoneyBagY] = 0.0;
	BagInfo[id][pMoneyBagZ] = 0.0;
	BagInfo[id][pMoneyBagCreated] = false;
	DestroyDynamicPickup(BagInfo[id][pMoneyBagPickup]);
	KillTimer(BagInfo[id][pMoneyBagTimer]);
}

/*		Money System		*/
stock GivePlayerMoneyEx(playerid, money)
{
	PlayerInfo[playerid][playerMoney] += money;
	GivePlayerMoney(playerid, money);
}

stock SetPlayerMoneyEx(playerid, money)
{
	PlayerInfo[playerid][playerMoney] = money;
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, money);
}

stock GetPlayerMoneyEx(playerid)return PlayerInfo[playerid][playerMoney];
stock GetPlayerBankMoney(playerid)return PlayerInfo[playerid][playerBank];

//CanBeRobbed Function
stock IsPlayerRobbable(playerid)return CanBeRobbed[playerid];

stock SetPlayerRobbableStatus(playerid, bool:status)
{
	if(status == PLAYER_ROBBABLE)
	{
		KillTimer(CanBeRobbedTimer[playerid]);
	}
	CanBeRobbed[playerid] = status;
}

	/*		{House System}		*/
CMD:createhouse(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 20)
	{
		new price, interior;
		if(sscanf(params, "dd", price, interior))return SendClientMessage(playerid, COLOR_GREY, "/createhouse <Price> <Interior ID>");
		new Float:Pos[3];
		GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
		CreateServerHouse(Pos[0], Pos[1], Pos[2], price, interior);
	}
	return 1;
}

CMD:sethousepos(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 20)
	{
		new id;
		if(sscanf(params, "d", id))return SendClientMessage(playerid, COLOR_GREY, "/sethousepos <houseid>");
		if(HouseInfo[id][hX] == 0.0)return SendClientMessage(playerid, COLOR_RED, "La casa non esiste!");
		new Float:Pos[3];
		GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
		HouseInfo[id][hX] = Pos[0];
		HouseInfo[id][hY] = Pos[1];
		HouseInfo[id][hZ] = Pos[2];
		SaveHouse(id);
		new string[128];
		format(string, 128, "La casa (ID: %d) e' stata spostata alle tue coordinate!", id);
		SendClientMessage(playerid, -1, string);
		new i = id;
		DestroyDynamicPickup(HouseInfo[i][hPickup]);
		DestroyDynamic3DTextLabel(HouseInfo[i][hLabel]);
		DestroyDynamicMapIcon(HouseInfo[i][hMapIcon]);

		if(HouseInfo[i][hOwnerID] == 0)
		{
			HouseInfo[id][hClosed] = 0;
			format(string, 128, "%s (%d)\nCasa in vendita!\nCosto: "EMB_DOLLARGREEN"%s"EMB_WHITE"\n"EMB_GREEN"Aperta", GetLocationNameFromCoord(HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ]), i, ConvertPrice(HouseInfo[i][hPrice]));
			HouseInfo[i][hMapIcon] = CreateDynamicMapIcon(HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ], 31, -1, -1, -1, -1, 20.0);
		}
		else
		{
			HouseInfo[i][hMapIcon] = CreateDynamicMapIcon(HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ], 32, -1, -1, -1, -1, 20.0);
			format(string, 128, "%s (%d)\nProprietario: %s\n%s", GetLocationNameFromCoord(HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ]), i, HouseInfo[i][OwnerName], (HouseInfo[i][hClosed] == 1) ? (EMB_RED"Chiusa"EMB_WHITE):(EMB_GREEN"Aperta"EMB_WHITE));
		}
		HouseInfo[i][hLabel] = CreateDynamic3DTextLabel(string, -1, HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ]+0.2, 30.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0, -1, 50.0);
		HouseInfo[i][hPickup] = CreateDynamicPickup(1273, 1, HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ], 0, 0); //Pickup Entrata

	}
	return 1;
}

CMD:sethouseinterior(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 20)
	{
		new id, interior;
		if(sscanf(params, "dd", id, interior))return SendClientMessage(playerid, COLOR_GREY, "/sethouseinterior <houseid> <interior>");
		if(HouseInfo[id][hX] == 0.0)return SendClientMessage(playerid, COLOR_RED, "La casa non esiste!");
		if(interior < 0 || interior > sizeof(HouseInteriors))return SendClientMessage(playerid, COLOR_RED, "Interior invalido!");
		new string[128];
		format(string, 128, "Hai aggiornato l'interior della casa (ID: %d). Nuovo Interior: %d", id, interior);
		SendClientMessage(playerid, -1, string);
		InteriorHouse(interior, id);
		SaveHouse(id);
	}
	return 1;
}

CMD:sethouseprice(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 20)
	{
		new id, newprice;
		if(sscanf(params, "dd", id, newprice))return SendClientMessage(playerid, COLOR_GREY, "/sethouseprice <houseid> <newprice>");
		if(HouseInfo[id][hX] == 0.0)return SendClientMessage(playerid, COLOR_RED, "La casa non esiste!");
		HouseInfo[id][hPrice] = newprice;
		SaveHouse(id);
		new string[128];
		format(string, 128, "Hai aggiornato il prezzo della casa (ID: %d). Nuovo Prezzo: "EMB_DOLLARGREEN"%s"EMB_WHITE"", id, ConvertPrice(newprice));
		SendClientMessage(playerid, -1, string);
		if(HouseInfo[id][hOwnerID] == 0)
		{
			format(string, 128, "%s (%d)\nCasa in vendita!\nCosto: "EMB_DOLLARGREEN"%s"EMB_WHITE"\n%s", GetLocationNameFromCoord(HouseInfo[id][hX], HouseInfo[id][hY], HouseInfo[id][hZ]), id, ConvertPrice(HouseInfo[id][hPrice]), (HouseInfo[id][hClosed] == 1) ? (EMB_RED"Chiusa"):(EMB_GREEN"Aperta"));
		}
		UpdateDynamic3DTextLabelText(HouseInfo[id][hLabel], -1, string);
	}
	return 1;
}

stock CreateServerHouse(Float:X, Float:Y, Float:Z, price, interior)
{
	new i = 0;
	for(new h = 0; h < MAX_HOUSES; h++)
	{
		if(HouseInfo[h][hCreated] == true)continue;
		i = h;
		break;
	}
	strcpy(HouseInfo[i][OwnerName], "No", 24);
	HouseInfo[i][hX] = X;
	HouseInfo[i][hY] = Y;
	HouseInfo[i][hZ] = Z;
	HouseInfo[i][hOwnerID] = NO_OWNER;
	HouseInfo[i][hClosed] = 0;
	HouseInfo[i][hMoney] = 0;
	InteriorHouse(interior, i);
	HouseInfo[i][hVirtualW] = 999+i;
	HouseInfo[i][hPrice] = price;
	new query[1024];
	mysql_format(MySQLC, query, sizeof query, "INSERT INTO `houses` (`ID`, `OwnerID`, `OwnerName`, `X`, `Y`, `Z`, `InteriorID`, `VirtualWorld`, `Price`, `Closed`) VALUES('%d', '0', 'No', '%f', '%f', '%f', '%d', '%d', '%d', 0)", i, X, Y, Z, HouseInfo[i][hInteriorID], HouseInfo[i][hVirtualW], price);
	mysql_tquery(MySQLC, query);
	HouseInfo[i][hCreated] = true;
	new string[128];
	format(string, 128, "%s (%d)\nCasa in vendita!\nCosto: "EMB_DOLLARGREEN"%s"EMB_WHITE"\n%s", GetLocationNameFromCoord(HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ]), i, ConvertPrice(price), (HouseInfo[i][hClosed] == 1) ? (EMB_RED"Chiusa"EMB_WHITE):(EMB_GREEN"Aperta"EMB_WHITE));
	HouseInfo[i][hLabel] = CreateDynamic3DTextLabel(string, -1, X, Y, Z+0.5, 30.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0, -1, 50.0);
	HouseInfo[i][hPickup] = CreateDynamicPickup(1273, 1, X, Y, Z, 0, 0); //Pickup Entrata
	HouseInfo[i][hMapIcon] = CreateDynamicMapIcon(HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ], 31, -1, -1, -1, -1, 20.0);
	HouseCount__++;
	return i;
}

stock SaveHouse(id)
{
	new query[1024];
	mysql_format(MySQLC, query, sizeof query, "UPDATE `houses` SET OwnerID = '%d', Closed = '%d', OwnerName = '%s', X = '%f', Y = '%f', Z = '%f', InteriorID = '%d', VirtualWorld = '%d', Price = '%d', Money = '%d' WHERE `ID` = '%d'",
		HouseInfo[id][hOwnerID], HouseInfo[id][hClosed], HouseInfo[id][OwnerName], HouseInfo[id][hX], HouseInfo[id][hY], HouseInfo[id][hZ], HouseInfo[id][hInteriorID], HouseInfo[id][hVirtualW], HouseInfo[id][hPrice], HouseInfo[id][hMoney], id);
	mysql_tquery(MySQLC, query);
}

stock InteriorHouse(interiorid, houseid)
{
	HouseInfo[houseid][hInteriorID] = interiorid;
	HouseInfo[houseid][hInterior] = HouseInteriors[interiorid][INTERIOR_ID];
	HouseInfo[houseid][hXu] = HouseInteriors[interiorid][INTERIOR_X];
	HouseInfo[houseid][hYu] = HouseInteriors[interiorid][INTERIOR_Y];
	HouseInfo[houseid][hZu] = HouseInteriors[interiorid][INTERIOR_Z];
	HouseInfo[houseid][hRobberyCP] = CreateDynamicCP(RobberyHouseCP[interiorid][ROBBERY_X], RobberyHouseCP[interiorid][ROBBERY_Y], RobberyHouseCP[interiorid][ROBBERY_Z], 1.2, HouseInfo[houseid][hVirtualW], HouseInfo[houseid][hInterior], -1, 40.0);
}


forward LoadHouses();
public LoadHouses()
{
	new string[128], cout;
	cache_get_row_count(cout);
	for(new i = 0; i < cout; i++)
	{
		cache_get_value_index_int(i, 1, HouseInfo[i][hOwnerID]);
		cache_get_value_index(i, 2, HouseInfo[i][OwnerName]);
		cache_get_value_index_int(i, 3, HouseInfo[i][hClosed]);
		cache_get_value_index_float(i, 4, HouseInfo[i][hX]);
		cache_get_value_index_float(i, 5, HouseInfo[i][hY]);
		cache_get_value_index_float(i, 6, HouseInfo[i][hZ]);
		cache_get_value_index_int(i, 7, HouseInfo[i][hMoney]);
		cache_get_value_index_int(i, 8, HouseInfo[i][hInteriorID]);
		cache_get_value_index_int(i, 9, HouseInfo[i][hVirtualW]);
		cache_get_value_index_int(i, 10, HouseInfo[i][hPrice]);
		HouseInfo[i][hRobbed] = false;
		HouseInfo[i][hCreated] = true;
		if(HouseInfo[i][hOwnerID] == 0)
		{
			format(string, 128, "%s (%d)\nCasa in vendita!\nCosto: "EMB_DOLLARGREEN"%s"EMB_WHITE"\n%s", GetLocationNameFromCoord(HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ]), i, ConvertPrice(HouseInfo[i][hPrice]), (HouseInfo[i][hClosed] == 1) ? (EMB_RED"Chiusa"EMB_WHITE):(EMB_GREEN"Aperta"EMB_WHITE));
			HouseInfo[i][hOwned] = false;
			HouseInfo[i][hMapIcon] = CreateDynamicMapIcon(HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ], 31, -1, -1, -1, -1, 20.0);
		}
		else
		{
			format(string, 128, "%s (%d)\nProprietario: %s\n%s", GetLocationNameFromCoord(HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ]), i, HouseInfo[i][OwnerName], (HouseInfo[i][hClosed] == 1) ? (EMB_RED"Chiusa"EMB_WHITE):(EMB_GREEN"Aperta"EMB_WHITE));
			HouseInfo[i][hOwned] = true;
			HouseInfo[i][hMapIcon] = CreateDynamicMapIcon(HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ], 32, -1, -1, -1, -1, 20.0);
		}
		HouseInfo[i][hLabel] = CreateDynamic3DTextLabel(string, -1, HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ]+0.2, 30.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0, -1, 50.0);
		HouseInfo[i][hPickup] = CreateDynamicPickup(1273, 1, HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ], 0, 0); //Pickup Entrata
		InteriorHouse(HouseInfo[i][hInteriorID], i);
		HouseCount__++;
	}
	printf("Loaded %d Houses", HouseCount__-1);
	return 1;
}

	//Anims Sytem
	#pragma tabsize 0
PreloadAnimLib(playerid, animlib[])
{
	ApplyAnimation(playerid,animlib,"null",0.0,0,0,0,0,0);
}

//stock DB_Escape(text[]){new ret[MAX_INI_ENTRY_TEXT * 2],ch,i,j;while ((ch = text[i++]) && j < sizeof (ret)){if (ch == '\''){if (j < sizeof (ret) - 2){ret[j++] = '\'';ret[j++] = '\'';}}else if (j < sizeof (ret)){ret[j++] = ch;}else{j++;}}ret[sizeof (ret) - 1] = '\0';return ret;}
	/*			{Admin Commands & Functions}			*/
CMD:acmds(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 1)
	{
		SendClientMessage(playerid, COLOR_YELLOW, "____________________________{Admin Commands}____________________________");
		SendClientMessage(playerid, -1, EMB_YELLOW"[LEVEL 1]:"EMB_WHITE" /goto - /gethere - /gotovehicle - /kick - /gotohouse - /gotobuilding - [/a]dminchat");
		SendClientMessage(playerid, -1, EMB_YELLOW"[LEVEL 1]:"EMB_WHITE" /gotopos - /gotoshowroom - /spec - /specoff - /playervehicles - /getvehicle");
		SendClientMessage(playerid, -1, EMB_YELLOW"[LEVEL 1]:"EMB_WHITE" /setinterior - /setworld - /clearchat - /freeze - /unfreeze - /ainfo - /warn");
	}
	if(GetPlayerAdminLevel(playerid) >= 2)
	{
		SendClientMessage(playerid, -1, EMB_YELLOW"[LEVEL 2]:"EMB_WHITE" /sethp - /setarmour - /fix - /ajail");
	}
	if(GetPlayerAdminLevel(playerid) >= 3)
	{
		SendClientMessage(playerid, -1, EMB_YELLOW"[LEVEL 3]:"EMB_WHITE" /givejetpack - /tempban - /setvehiclecolor");
	}
	if(GetPlayerAdminLevel(playerid) >= 5)
	{
		SendClientMessage(playerid, -1, EMB_YELLOW"[LEVEL 5]:"EMB_WHITE" /permaban - /apark - /setpremium - /banaccount - /banofflineaccount - /unbanaccount");
		SendClientMessage(playerid, -1, EMB_YELLOW"[LEVEL 5]:"EMB_WHITE" /giveskill - /kickall");
	}
	if(GetPlayerAdminLevel(playerid) >= 10)
	{
		SendClientMessage(playerid, -1, EMB_YELLOW"[LEVEL 10]:"EMB_WHITE" /setmoney - /givemoney - /setbankmoney - /givebankmoney - /giveservermoney - /giveweapon");
	}
	if(GetPlayerAdminLevel(playerid) >= 20)
	{
		SendClientMessage(playerid, -1, EMB_YELLOW"[LEVEL 20]:"EMB_WHITE" /createhouse - /sethousepos - /sethouseprice - /sethouseinterior");
	}
	if(IsPlayerAdmin(playerid))
	{
		SendClientMessage(playerid, -1, EMB_YELLOW"[RCON]:"EMB_WHITE" /setadmin");
	}
	return 1;
}

CMD:clearchat(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 1)
	{
		for(new i = 0; i < 30; i++)
		{
			SendClientMessageToAll(-1, " ");
		}
		new string[128];
		format(string, sizeof(string), "L'Admin %s [%d] ha pulito la chat!", PlayerInfo[playerid][playerName], playerid);
		SendClientMessageToAll(-1, string);
	}
	return 1;
}

CMD:ainfo(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 1)
	{
		new id;
		if(sscanf(params, "u", id))return SendClientMessage(playerid, COLOR_GREY, "/ainfo <playerid/partofname>");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Giocatore non connesso!");
		new string[128];
		format(string, sizeof(string), " Info di %s[%d] ", PlayerInfo[id][playerName], id);
		SendClientMessage(playerid, -1, string);
		format(string, sizeof(string), "Soldi: %s - Banca: %s", ConvertPrice(GetPlayerMoneyEx(id)), ConvertPrice(PlayerInfo[id][playerBank]));
		SendClientMessage(playerid, COLOR_GREEN, string);
		format(string, sizeof(string), "Livello Ricercato: %d", GetPlayerWantedLevelEx(id));
		SendClientMessage(playerid, COLOR_GREEN, string);
		SendClientMessage(playerid, COLOR_GREEN, "=== Abilita' ===");
		format(string, sizeof(string), "Polizia: %d - Rapine: %d - Veicoli Rubati: %d - Totale: %d", PlayerSkill[id][skillPolice], PlayerSkill[id][skillRobber], PlayerSkill[id][skillVehicleStolen], GetPlayerScore(id));
		SendClientMessage(playerid, COLOR_GREEN, string);
	}
	return 1;
}


CMD:playervehicles(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 1)
	{
		new id;
		if(sscanf(params, "u", id))return SendClientMessage(playerid, COLOR_GREY, "/playervehicles <playerid>");
		//if(!IsValidVehicle(id))return SendClientMessage(playerid, COLOR_RED, "Il veicolo non esiste!");

		new string[128];
		format(string, sizeof(string), "Veicoli di %s [%d] ", PlayerInfo[id][playerName], id);
		SendClientMessage(playerid, -1, string);
		new v_loaded = 0;
		for(new i = 0; i < MAX_VEHICLE_SLOT; i++)
		{
			if(v_loaded == GetPlayerVehicleCount(id))break;
			if(PlayerVehicle[id][i][vID] == 0)continue;
			format(string, sizeof(string), " [#%d] %s [%d] ", i, GetVehicleName(GetVehicleModel(PlayerVehicle[id][i][vID])), PlayerVehicle[id][i][vID]);
			SendClientMessage(playerid, COLOR_GREEN, string);
			v_loaded++;
		}
		if(v_loaded == 0)return SendClientMessage(playerid, COLOR_GREEN, "Non possiede veicoli!");
	}
	return 1;
}


CMD:removevehicle(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 6)
	{
		new id, slotid;
		if(sscanf(params, "ud", id, slotid))
		{
			SendClientMessage(playerid, COLOR_GREY, "/removevehicle [playerid][slotid]");
			SendClientMessage(playerid, COLOR_GREY, "Usa /playervehicles [playerid] per conoscere lo slotid del veicolo!");
			return 1;
		}
		if(PlayerVehicle[id][slotid][vID] == 0)return SendClientMessage(playerid, COLOR_RED, "Questo veicolo non esiste!");
		new string[100];
		format(string, sizeof(string), "%s [%d] ha rimosso il tuo veicolo! (%s)", PlayerInfo[playerid][playerName], playerid, GetVehicleName(GetVehicleModel(PlayerVehicle[id][slotid][vID])));
		SendClientMessage(id, -1, string);
		format(string, sizeof(string), "[ADMIN] %s[%d] ha rimosso il veicolo di %s[%d] (%s).", PlayerInfo[playerid][playerName], playerid, PlayerInfo[id][playerName], id, GetVehicleName(GetVehicleModel(GetPlayerVehicleID(playerid))));
		SendMessageToAdmin(string, -1);
		RemovePlayerVehicle(id, PlayerInfo[id][playerID], slotid);
	}
	return 1;
}

CMD:freeze(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 1)
	{
		new id;
		if(sscanf(params, "u", id))return SendClientMessage(playerid, COLOR_GREY, "/freeze [playerid/partofname]");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Il giocatore non e' connesso!");
		//if(IsPlayerFreeze(id))return SendClientMessage(playerid, COLOR_RED, "Il giocatore � gi� freezato!");
		FreezePlayer(id);
		new string[60+28];
		format(string, sizeof(string), "** Sei stato freezato da "EMB_RED"%s"EMB_WHITE"[%d]. **", PlayerInfo[playerid][playerName], playerid);
		SendClientMessage(id, -1, string);
		format(string, sizeof(string), "** Hai freezato "EMB_RED"%s"EMB_WHITE"[%d]. **", PlayerInfo[id][playerName], id);
		SendClientMessage(playerid, -1, string);
	}
	return 1;
}

CMD:unfreeze(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 1)
	{
		new id;
		if(sscanf(params, "u", id))return SendClientMessage(playerid, COLOR_GREY, "/unfreeze [playerid/partofname]");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Il giocatore non e' connesso!");
		//if(!IsPlayerFreeze(id))return SendClientMessage(playerid, COLOR_RED, "Il giocatore non � gi� freezato!");
		UnFreezePlayer(id);
		Cuffed[playerid] = false;
		Tazed[playerid] = false;
		new string[60+28];
		format(string, sizeof(string), "** Sei stato unfreezato da "EMB_RED"%s"EMB_WHITE"[%d]. **", PlayerInfo[playerid][playerName], playerid);
		SendClientMessage(id, -1, string);
		format(string, sizeof(string), "** Hai unfreezato "EMB_RED"%s"EMB_WHITE"[%d]. **", PlayerInfo[id][playerName], id);
		SendClientMessage(playerid, -1, string);
	}
	return 1;
}

CMD:ajail(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 2)
	{
		new id, time, reason[60];
		if(sscanf(params, "uds[55]", id, time, reason))return SendClientMessage(playerid, COLOR_GREY, "/ajail [playerid/partofname] [minuti] [motivo]");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Il giocatore non e' connesso!");
		if(strlen(reason) > 53)return SendClientMessage(playerid, COLOR_RED, "Motivo troppo lungo!!");
		KillTimer(TimeCounter__[id]);
		KillTimer(RobberyTimer__[id]);
		KillTimer(UnJailTimer__[id]);
		KillTimer(RobberyTimer__[id]);
		if(time == 0)
		{
			PlayerInfo[id][playerJailTime] = 1;
			UnJailTimer__[id] = SetTimerEx("UnJailPlayer", 1*1000, false, "i", id);
		}
		else
		{
			PlayerInfo[id][playerJailTime] = time * 60;
			SetPlayerInterior(id, 6);
			SetPlayerPos(id, 264.6123, 77.6957, 1001.0391);
			SetPlayerVirtualWorld(id, id);
			new string[128];
			format(string, sizeof(string), "** Sei stato punito da "EMB_RED"%s"EMB_WHITE"[%d] per %d secondi. Motivo: %s**", PlayerInfo[playerid][playerName], playerid, PlayerInfo[id][playerJailTime], reason);
			SendClientMessage(id, -1, string);
			format(string, sizeof(string), "** Hai punito "EMB_RED"%s"EMB_WHITE"[%d] per %d secondi. Motivo: %s **", PlayerInfo[id][playerName], id, PlayerInfo[id][playerJailTime], reason);
			SendClientMessage(playerid, -1, string);
			format(string, sizeof(string), "** %s[%d] ha punito "EMB_RED"%s"EMB_WHITE"[%d] per %d secondi. Motivo: %s **", PlayerInfo[playerid][playerName], playerid, PlayerInfo[id][playerName], id, PlayerInfo[id][playerJailTime], reason);
			SendMessageToAdmin(string, -1);
			GivePlayerMoneyEx(id, -500);
			PlayerInfo[playerid][playerWeapAllowed] = false;
			UnJailTimer__[id] = SetTimerEx("UnJailPlayer", PlayerInfo[id][playerJailTime]*1000, false, "i", id);
			TimeCounter(id, PlayerInfo[id][playerJailTime]);
			ResetPlayerWantedLevel(id);
		}
	}
	return 1;
}

CMD:spec(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 1)
	{
		//if(Spectating{playerid} == true)return SendClientMessage(playerid, COLOR_RED, "Usa /specoff per riutilizzare questo comando!");
		new id;
		if(sscanf(params, "u", id))return SendClientMessage(playerid, COLOR_GREY, "/spec <playerid>");
		if(id == playerid)return SendClientMessage(playerid, COLOR_RED, "Non puoi spectare te stesso!");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Giocatore non connesso!");
		if(IsPlayerInAnyVehicle(id))
		{
			TogglePlayerSpectating(playerid, 1);
			PlayerSpectateVehicle(playerid, GetPlayerVehicleID(id));
		}
		else
		{
			TogglePlayerSpectating(playerid, 1);
			PlayerSpectatePlayer(playerid, id, SPECTATE_MODE_NORMAL);
		}
		SetPlayerInterior(playerid, GetPlayerInterior(id));
		SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(id));
		new string[128];
		format(string, sizeof(string), " "EMB_GREEN"%s"EMB_WHITE"(%d) sta spectando "EMB_GREEN"%s"EMB_WHITE"(%d) ", PlayerInfo[playerid][playerName], playerid, PlayerInfo[id][playerName], id);
		SendMessageToAdmin(string, COLOR_YELLOW);
		Spectating[playerid] = true;
		playerSpectated[playerid] = id;
	}
	return 1;
}

CMD:specoff(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 1)
	{
		if(Spectating[playerid] == false)return SendClientMessage(playerid, COLOR_RED, "Non stai spectando nessuno!");
		TogglePlayerSpectating(playerid, 0);
		Spectating[playerid] = false;
		playerSpectated[playerid] = -1;
	}
	return 1;
}

CMD:apark(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 5)
	{
		if(!IsPlayerInAnyVehicle(playerid))return SendClientMessage(playerid, COLOR_RED, "Non ti trovi in un veicolo!");
		SendClientMessage(playerid, COLOR_GREEN, "Hai parcheggiato qui questo veicolo!");
		new Float:X, Float:Y, Float:Z, Float:A, vehicleid = GetPlayerVehicleID(playerid);
		GetVehiclePos(vehicleid, X, Y, Z);
		GetVehicleZAngle(vehicleid, A);
		VehicleInfo[vehicleid][vX] = X;
		VehicleInfo[vehicleid][vY] = Y;
		VehicleInfo[vehicleid][vZ] = Z;
		VehicleInfo[vehicleid][vA] = A;
	}
	return 1;
}

CMD:goto(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 1)
	{
		new id;
		if(sscanf(params, "u", id))return SendClientMessage(playerid, COLOR_GREY, "/goto <playerid/partofname>");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Il giocatore non e' connesso!");
		if(id == playerid)return SendClientMessage(playerid, COLOR_RED, "Non puoi gotarti a te");
		if(!IsPlayerInAnyVehicle(playerid))
		{
			SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(id));
			SetPlayerInterior(playerid, GetPlayerInterior(id));
			new Float:Pos[3];
			GetPlayerPos(id, Pos[0], Pos[1], Pos[2]);
			SetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]+0.5);
			SendClientMessage(playerid, COLOR_GREY, "Ti sei gotato dal player!");
		}
		else
		{
			SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(id));
			SetPlayerInterior(playerid, GetPlayerInterior(id));
			LinkVehicleToInterior(GetPlayerVehicleID(playerid), GetPlayerInterior(id));
			SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), GetPlayerVirtualWorld(id));
			new Float:Pos[3];
			GetPlayerPos(id, Pos[0], Pos[1], Pos[2]);
			new v = GetPlayerVehicleID(playerid);
			SetVehiclePos(v, Pos[0]+2, Pos[1]+2, Pos[2]+2);
			SendClientMessage(playerid, COLOR_GREY, "Ti sei gotato dal player!");
		}
	}
	return 1;
}

CMD:gotopos(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 1)
	{
		new interior, Float:Pos[3];
		if(sscanf(params, "dfff", interior, Pos[0], Pos[1], Pos[2]))return SendClientMessage(playerid, COLOR_GREY, "/gotopos <interiorid> <X> <Y> <Z>");
		SetPlayerInterior(playerid, interior);
		SetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]+0.2);
	}
	return 1;
}

CMD:gotohouse(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 1)
	{
		new id;
		if(sscanf(params, "d", id))return SendClientMessage(playerid, COLOR_GREY, "/gotohouse <houseid>");
		if(HouseInfo[id][hX] == 0.0)return SendClientMessage(playerid, COLOR_RED, "Questa casa non esiste!");
		SetPlayerPos(playerid, HouseInfo[id][hX], HouseInfo[id][hY], HouseInfo[id][hZ]+0.2);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SendClientMessage(playerid, COLOR_GREY, "Ti sei gotato!");
	}
	return 1;
}

CMD:gotobuilding(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 1)
	{
		new id;
		if(sscanf(params, "d", id))return SendClientMessage(playerid, COLOR_GREY, "/gotobuilding <buildingid>");
		if(BuildingInfo[id][bEnterX] == 0.0)return SendClientMessage(playerid, COLOR_RED, "Questo building non esiste!");
		SetPlayerPos(playerid, BuildingInfo[id][bEnterX], BuildingInfo[id][bEnterY], BuildingInfo[id][bEnterZ]+0.2);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SendClientMessage(playerid, COLOR_GREY, "Ti sei gotato!");
	}
	return 1;
}

CMD:buildings(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 1)
	{
		new string[60];
		SendClientMessage(playerid, -1, "=== Buildings ===");
		for(new i = 0; i <BuildingCount__; i++)
		{
			format(string, sizeof(string), "%s - #%d", BuildingInfo[i][bName], i);
			SendClientMessage(playerid, -1, string);
		}
	}
	return 1;
}


CMD:gotovehicle(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 1)
	{
		new id;
		if(sscanf(params, "d", id))return SendClientMessage(playerid, COLOR_GREY, "/gotovehicle <vehicleid>");
		//if(!IsValidVehicle(id))return SendClientMessage(playerid, COLOR_RED, "Il veicolo non esiste!");
		SetPlayerVirtualWorld(playerid, GetVehicleVirtualWorld(id));
		new Float:Pos[3];
		GetVehiclePos(id, Pos[0], Pos[1], Pos[2]);
		if(!IsPlayerInAnyVehicle(playerid))
		{
			SetPlayerPos(playerid, Pos[0], Pos[1]+3.0, Pos[2]);
		}
		else
		{
			SetVehiclePos(GetPlayerVehicleID(playerid), Pos[0]+1, Pos[1]+2.5, Pos[2]+3);
		}
		SendClientMessage(playerid, COLOR_GREY, "Ti sei gotato al veicolo!");
	}
	return 1;
}

CMD:gotoshowroom(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 1)
	{
		new id;
		if(sscanf(params, "d", id))return SendClientMessage(playerid, COLOR_GREY, "/gotoshowroom <showroomid>");
		if(id > MAX_SHOWROOM)return SendClientMessage(playerid, COLOR_RED, "Concessionaria inesistente!");
		SetPlayerPos(playerid, ShowroomPickupPos[id][0], ShowroomPickupPos[id][1], ShowroomPickupPos[id][2]);
	}
	return 1;
}


CMD:gethere(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 1)
	{
		new id;
		if(sscanf(params, "u", id))return SendClientMessage(playerid, COLOR_GREY, "/gethere <playerid/partofname>");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Il giocatore non e' connesso!");
		if(id == playerid)return SendClientMessage(playerid, COLOR_RED, "Non puoi gotarti!");
		SetPlayerVirtualWorld(id, GetPlayerVirtualWorld(playerid));
		SetPlayerInterior(id, GetPlayerInterior(playerid));
		new Float:Pos[3];
		GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
		if(!IsPlayerInAnyVehicle(id))
		{
			SetPlayerPos(id, Pos[0], Pos[1], Pos[2]);
		}
		else
		{
			SetVehiclePos(GetPlayerVehicleID(id), Pos[0]+1, Pos[1]+0.5, Pos[2]+2);
		}
		SendClientMessage(playerid, COLOR_GREY, "Hai gotato a te il player!");
	}
	return 1;
}

CMD:getvehicle(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 1)
	{
		new id;
		if(sscanf(params, "d", id))return SendClientMessage(playerid, COLOR_GREY, "/getvehicle <vehicleid>");
		//if(!IsValidVehicle(id))return SendClientMessage(playerid, COLOR_RED, "Il veicolo non esiste!");
		SetVehicleVirtualWorld(id, GetPlayerVirtualWorld(playerid));
		new Float:Pos[3];
		GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
		SetVehiclePos(id, Pos[0]+2, Pos[1]+1.5, Pos[2]+2);
		SendClientMessage(playerid, COLOR_GREY, "Ti sei gotato il veicolo!");
	}
	return 1;
}

CMD:setadmin(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 20)
	{
		new id, level;
		if(sscanf(params, "ud", id, level))return SendClientMessage(playerid, COLOR_GREY, "/setadmin <playerid/partofname> <Level>");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Giocatore non connesso!");
		new string[128];
		format(string, 128, "> %s ti ha settato admin livello %d", PlayerInfo[playerid][playerName], level);
		SendClientMessage(id, COLOR_GREEN, string);
		format(string, 128, "%s e' stato settato admin livello %d", PlayerInfo[id][playerName], level);
		SendClientMessage(playerid, COLOR_GREEN, string);
		PlayerInfo[id][playerAdmin] = level;
		mysql_format(MySQLC, string, sizeof(string), "UPDATE `Players` SET `Admin` = '%d' WHERE `ID` = '%d' AND `Name` = '%s'", level, PlayerInfo[id][playerID], PlayerInfo[id][playerName]);
		mysql_tquery(MySQLC, string);
	}
	return 1;
}

CMD:giveweapon(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 10)
	{
		new id, wid, ammo;
		if(sscanf(params, "udd", id, wid, ammo))return SendClientMessage(playerid, COLOR_GREY, "/giveweapon <playerid/partofname> <weaponid> <ammo>");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Giocatore non connesso!");
		new string[128];
		format(string, 128, " "EMB_GREEN"%s"EMB_WHITE"(%d) ha givato un'arma (ID: %d) a "EMB_WHITE"%s"EMB_WHITE"(%d) ", PlayerInfo[playerid][playerName], playerid, wid, PlayerInfo[id][playerName], id);
		SendMessageToAdmin(string, COLOR_YELLOW);
		GivePlayerWeaponEx(id, wid, ammo);
	}
	return 1;
}

CMD:givebankmoney(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 10)
	{
		new id, money;
		if(sscanf(params, "ud", id, money))return SendClientMessage(playerid, COLOR_GREY, "/givebankmoney <playerid/partofname> <Money>");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Giocatore non connesso!");
		new string[128];
		format(string, 128, EMB_GREEN"%s ti ha givato "EMB_DOLLARGREEN"%s"EMB_WHITE" in banca", PlayerInfo[playerid][playerName], ConvertPrice(money));
		SendClientMessage(id, COLOR_GREEN, string);
		format(string, 128, " "EMB_GREEN"%s"EMB_WHITE"(%d) ha givato "EMB_DOLLARGREEN"%s"EMB_WHITE" in banca a "EMB_GREEN"%s"EMB_WHITE"(%d) ", PlayerInfo[playerid][playerName], playerid, ConvertPrice(money), PlayerInfo[id][playerName], id);
		SendMessageToAdmin(string, COLOR_YELLOW);
		PlayerInfo[id][playerBank] += money;
		SavePlayer(id);
	}
	return 1;
}

CMD:setbankmoney(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 10)
	{
		new id, money;
		if(sscanf(params, "ud", id, money))return SendClientMessage(playerid, COLOR_GREY, "/setbankmoney <playerid/partofname> <Money>");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Giocatore non connesso!");
		new string[128];
		format(string, 128, "> %s ti ha settato "EMB_DOLLARGREEN"%s"EMB_WHITE" in banca", PlayerInfo[playerid][playerName], ConvertPrice(money));
		SendClientMessage(id, COLOR_GREEN, string);
		format(string, 128, " "EMB_GREEN"%s"EMB_WHITE"(%d) ha settato a "EMB_DOLLARGREEN"%s"EMB_WHITE" il conto bancario di "EMB_GREEN"%s"EMB_WHITE"(%d)", PlayerInfo[playerid][playerName], playerid, ConvertPrice(money), PlayerInfo[id][playerName], id);
		SendMessageToAdmin(string, COLOR_YELLOW);
		PlayerInfo[id][playerBank] = money;
		SavePlayer(id);
	}
	return 1;
}

CMD:givemoney(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 10)
	{
		new id, money;
		if(sscanf(params, "ud", id, money))return SendClientMessage(playerid, COLOR_GREY, "/givemoney <playerid/partofname> <Money>");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Giocatore non connesso!");
		new string[128];
		format(string, 128, EMB_GREEN"%s"EMB_WHITE"(%d) ti ha givato "EMB_DOLLARGREEN"%s"EMB_WHITE"", PlayerInfo[playerid][playerName], playerid, ConvertPrice(money));
		SendClientMessage(id, COLOR_GREEN, string);
		format(string, 128, " "EMB_GREEN"%s"EMB_WHITE"(%d) ha givato "EMB_DOLLARGREEN"%s"EMB_WHITE" a "EMB_GREEN"%s"EMB_WHITE"(%d)", PlayerInfo[playerid][playerName], playerid, ConvertPrice(money), PlayerInfo[id][playerName], id);
		SendMessageToAdmin(string, COLOR_YELLOW);
		GivePlayerMoneyEx(id, money);
		SavePlayer(id);
	}
	return 1;
}

CMD:givelootmoney(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 10)
	{
		new id, money;
		if(sscanf(params, "ud", id, money))return SendClientMessage(playerid, COLOR_GREY, "/givelootmoney <playerid/partofname> <Money>");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Giocatore non connesso!");
		GivePlayerLootMoney(id, money);
		SavePlayer(id);
	}
	return 1;
}

CMD:giveservermoney(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 10)
	{
		new money;
		if(sscanf(params, "d", money))return SendClientMessage(playerid, COLOR_GREY, "/giveservermoney <Money>");
		new string[128];
		format(string, sizeof(string), "** "EMB_RED"[ATTENZIONE] "EMB_WHITE"L'admin "EMB_GREEN"%s"EMB_WHITE"(%d) ha regalato "EMB_DOLLARGREEN"%s"EMB_WHITE" a tutti! **", PlayerInfo[playerid][playerName], playerid, ConvertPrice(money));
		SendClientMessageToAll(-1, string);
		foreach(new id : Player)
		{
			if(id == INVALID_PLAYER_ID)continue;
			GivePlayerMoneyEx(id, money);
		}
	}
	return 1;
}

CMD:setmoney(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 10)
	{
		new id, money;
		if(sscanf(params, "ud", id, money))return SendClientMessage(playerid, COLOR_GREY, "/setmoney <playerid/partofname> <Money>");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Il giocatore non e' connesso!");
		new string[128];
		format(string, 128, "> %s ti ha settato "EMB_DOLLARGREEN"%s"EMB_WHITE"", PlayerInfo[playerid][playerName], ConvertPrice(money));
		SendClientMessage(id, COLOR_GREEN, string);
		format(string, 128, " "EMB_GREEN"%s"EMB_WHITE"(%d) ha settato a "EMB_DOLLARGREEN"%s"EMB_WHITE" i soldi di "EMB_GREEN"%s"EMB_WHITE"(%d)", PlayerInfo[playerid][playerName], playerid, ConvertPrice(money), PlayerInfo[id][playerName], id);
		SendMessageToAdmin(string, -1);
		SetPlayerMoneyEx(id, money);
		SavePlayer(id);
	}
	return 1;
}

CMD:setinterior(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 1)
	{
		new id, interior;
		if(sscanf(params, "ud", id, interior))return SendClientMessage(playerid, COLOR_GREY, "/setinterior <playerid/partofname> <interiorid>");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Il giocatore non e' connesso!");
		new string[128];
		format(string, 128, "> %s ti ha settato l'interiorid %d", PlayerInfo[playerid][playerName], interior);
		SendClientMessage(id, COLOR_GREEN, string);
		format(string, 128, " "EMB_GREEN"%s"EMB_WHITE"(%d) ha settato a "EMB_GREEN"%s"EMB_WHITE"(%d) l'interiorid %d", PlayerInfo[playerid][playerName], playerid, PlayerInfo[id][playerName], id, interior);
		SendMessageToAdmin(string, -1);
		SetPlayerInterior(id, interior);
	}
	return 1;
}

CMD:setworld(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 1)
	{
		new id, ww;
		if(sscanf(params, "ud", id, ww))return SendClientMessage(playerid, COLOR_GREY, "/setworld <playerid/partofname> <worldid>");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Il giocatore non e' connesso!");
		new string[128];
		format(string, 128, "> %s ti ha settato il virtualworld %d", PlayerInfo[playerid][playerName], ww);
		SendClientMessage(id, COLOR_GREEN, string);
		format(string, 128, " "EMB_GREEN"%s"EMB_WHITE"(%d) ha settato a "EMB_GREEN"%s"EMB_WHITE"(%d) il virtualworld %d", PlayerInfo[playerid][playerName], playerid, PlayerInfo[id][playerName], id, ww);
		SendMessageToAdmin(string, -1);
		SetPlayerVirtualWorld(id, ww);
	}
	return 1;
}


CMD:explode(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 1)
	{
		new id, type, radius;
		if(sscanf(params, "udd", id, type, radius))return SendClientMessage(playerid, COLOR_GREY, "/explode <playerid/partofname> <type> <radius>");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Giocatore non connesso!");
		new string[160];
		format(string, 160, " "EMB_GREEN"%s"EMB_WHITE"(%d) ha fatto esplodere "EMB_GREEN"%s"EMB_WHITE"(%d). ", PlayerInfo[playerid][playerName], playerid, PlayerInfo[id][playerName], id);
		SendMessageToAdmin(string, COLOR_YELLOW);
		new Float:Pos[3];
		GetPlayerPos(id, Pos[0], Pos[1], Pos[2]);
		CreateExplosion(Pos[0], Pos[1], Pos[2], type, radius);
	}
	return 1;
}


CMD:asdasdasd(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 1)
	{
		RandomMessage();
	}
	return 1;
}

CMD:respawnvehicles(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 1)
	{
		RespawnUnoccupiedVehicles();
	}
	return 1;
}

CMD:kickall(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 5)
	{
		new reason[50];
		if(sscanf(params, "s[47]", reason))return SendClientMessage(playerid, COLOR_GREY, "/kickall <Reason>");
		new string[160];
		format(string, 160, "** %s ha kickato tutti. Motivo: %s **", PlayerInfo[playerid][playerName], reason);
		SendClientMessageToAll(COLOR_GREEN, string);
		foreach(new i : Player)
		{
			SavePlayer(i);
			KickPlayer(i);
		}
	}
	return 1;
}

CMD:warn(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 1)
	{
		new id, reason[50];
		if(sscanf(params, "us[47]", id, reason))return SendClientMessage(playerid, COLOR_GREY, "/warn <playerid/partofname> <Reason>");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Giocatore non connesso!");
		if(PlayerInfo[id][playerAdmin] > PlayerInfo[playerid][playerAdmin])return SendClientMessage(playerid, COLOR_RED, "Non puoi utilizzare questo comando su questo giocatore!");
		new string[160];
		format(string, 160, "** Sei stato warnato da %s. Motivo: %s **", PlayerInfo[playerid][playerName], reason);
		SendClientMessage(id, COLOR_ORANGE, string);
		format(string, 160, " "EMB_GREEN"%s"EMB_WHITE"(%d) ha warnato "EMB_GREEN"%s"EMB_WHITE"(%d). "EMB_RED"Motivo:"EMB_WHITE" %s", PlayerInfo[playerid][playerName], playerid, PlayerInfo[id][playerName], id, reason);
		SendMessageToAll(-1, string);
		PlayerInfo[id][playerWarns] ++;
		if(PlayerInfo[id][playerWarns] >= 3)
		{
			SendClientMessage(id, COLOR_ORANGE, "** Sei stato kickato automaticamente perche' hai superato il limite di warn! **");
			format(string, 160, " "EMB_GREEN"%s"EMB_WHITE"(%d) e' stato kickato automaticamente per aver ricevuto troppi warn!", PlayerInfo[id][playerName], id);
			SendMessageToAll(-1, string);
			KickPlayer(id);
		}
	}
	return 1;
}

CMD:veh(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 2)
	{
		new id;
		if(sscanf(params, "d", id))return SendClientMessage(playerid, COLOR_GREY, "/veh <vehicleid>");
		new Float:Pos[3];
		GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
		adminVehicleSpawned[playerid] =	CreateVehicle(id, Pos[0], Pos[1], Pos[2], random(100), random(100), random(100), 0);
	}
	return 1;
}


CMD:kick(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 1)
	{
		new id, reason[50];
		if(sscanf(params, "us[47]", id, reason))return SendClientMessage(playerid, COLOR_GREY, "/kick <playerid/partofname> <Reason>");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Giocatore non connesso!");
		if(PlayerInfo[id][playerAdmin] > PlayerInfo[playerid][playerAdmin])return SendClientMessage(playerid, COLOR_RED, "Non puoi utilizzare questo comando su questo giocatore!");
		new string[160];
		format(string, 160, "** Sei stato kickato da %s. Motivo: %s **", PlayerInfo[playerid][playerName], reason);
		SendClientMessage(id, COLOR_ORANGE, string);
		format(string, 160, " "EMB_GREEN"%s"EMB_WHITE"(%d) ha kickato "EMB_GREEN"%s"EMB_WHITE"(%d). "EMB_RED"Motivo:"EMB_WHITE" %s ", PlayerInfo[playerid][playerName], playerid, PlayerInfo[id][playerName], id, reason);
		SendMessageToAdmin(string, -1);
		SavePlayer(id);
		KickPlayer(id);
	}
	return 1;
}

CMD:fakechat(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 1)
	{
		new id, text[60];
		if(sscanf(params, "us[57]", id, text))return SendClientMessage(playerid, COLOR_GREY, "/fakechat <playerid/partofname> <text>");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Giocatore non connesso!");
		if(PlayerInfo[id][playerAdmin] > PlayerInfo[playerid][playerAdmin])return SendClientMessage(playerid, COLOR_RED, "Non puoi utilizzare questo comando su questo giocatore!");
		OnPlayerText(id, text);
	}
	return 1;
}

CMD:sethp(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 2)
	{
		new id, hp;
		if(sscanf(params, "ud", id, hp))return SendClientMessage(playerid, COLOR_GREY, "/sethp <playerid/partofname> <hptoset>");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Giocatore non connesso!");
		new string[160];
		format(string, 160, "> %s ti ha settato gli HP a %d.0 ", PlayerInfo[id][playerName], hp);
		SendClientMessage(playerid, COLOR_YELLOW, string);
		format(string, 160, " "EMB_GREEN"%s"EMB_WHITE"(%d) ha settato gli HP di "EMB_GREEN"%s"EMB_WHITE"(%d) a %d.0 ", PlayerInfo[playerid][playerName], playerid, PlayerInfo[id][playerName], id, hp);
		SendMessageToAdmin(string, COLOR_YELLOW);
		if(hp > 99)return SetPlayerHealth(id, 99.0);
		SetPlayerHealth(id, hp);
	}
	return 1;
}

CMD:setarmour(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 2)
	{
		new id, hp;
		if(sscanf(params, "ud", id, hp))return SendClientMessage(playerid, COLOR_GREY, "/setarmour <playerid/partofname> <armourtoset>");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Giocatore non connesso!");
		new string[160];
		format(string, 160, "> "EMB_GREEN"%s"EMB_WHITE"(%d) ti ha settato l'armatura a %d.0 ", PlayerInfo[playerid][playerName], playerid, hp);
		SendClientMessage(id, -1, string);
		format(string, 160, ""EMB_GREEN"%s"EMB_WHITE"(%d) ha settato l'armatura di "EMB_GREEN"%s"EMB_WHITE"(%d) a %d.0 ", PlayerInfo[playerid][playerName], playerid, PlayerInfo[id][playerName], id,hp);
		SendMessageToAdmin(string, -1);
		if(hp >= 99)
		{
			hp = 99;
		}
		SetPlayerArmour(id, hp);
	}
	return 1;
}

CMD:fix(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 2)
	{
		if(!IsPlayerInAnyVehicle(playerid))return SendClientMessage(playerid, COLOR_RED, "Non sei in un veicolo!");
		new string[160];
		SendClientMessage(playerid, COLOR_GREY, "> Veicolo riparato!");
		format(string, 160, ""EMB_GREEN"%s"EMB_WHITE"(%d) ha riparato il suo veicolo!"EMB_YELLOW" ", PlayerInfo[playerid][playerName], playerid);
		SendMessageToAdmin(string, -1);
		RepairVehicle(GetPlayerVehicleID(playerid));
		SetVehicleHealth(GetPlayerVehicleID(playerid), 999.0);
	}
	return 1;
}

CMD:serialban(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 20)
	{
		new id;
		if(sscanf(params, "u", id))return SendClientMessage(playerid, COLOR_GREY, "/serialban <playerid/partofname>");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Giocatore non connesso!");
		if(PlayerInfo[id][playerAdmin] > PlayerInfo[playerid][playerAdmin])return SendClientMessage(playerid, COLOR_RED, "Non puoi utilizzare questo comando su questo giocatore!");
		new string[256], serial[129];
		gpci(id, serial, sizeof(serial));
		mysql_format(MySQLC, string, sizeof(string), "INSERT INTO `SerialBans` (`SerialID`, `AccountBanned`)  VALUES('%s', '%s')", serial, PlayerInfo[id][playerName]);
		mysql_tquery(MySQLC, string);
		format(string, 160, " %s(%d) ha serialbannato %s! ", PlayerInfo[playerid][playerName], playerid, PlayerInfo[id][playerName]);
		SendMessageToAdmin(string, -1);
		KickPlayer(id);
	}
	return 1;
}

/*CMD:banofflineaccount(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 5)
	{
		new name[30];
		if(sscanf(params, "s[30]", name))return SendClientMessage(playerid, COLOR_GREY, "/banofflineaccount <Nome Completo>");
		new string[256];
		mysql_format(MySQLC, string, sizeof(string), "SELECT AccountBanned FROM `Players` WHERE `Name` = '%s'", name);
		mysql_tquery(MySQLC, string);
		if(mysql_num_rows() == 0)
		{
			format(string, sizeof(string), "L'account ''%s'' non esiste!", name);
			SendClientMessage(playerid, COLOR_RED, string);
			return 1;
		}
		if(mysql_fetch_int() == 1)
		{
			format(string, sizeof(string), EMB_WHITE"L'account ''"EMB_GREEN"%s"EMB_WHITE"'' � gi� bannato!", name);
			SendClientMessage(playerid, -1, string);
			return 1;
		}

		format(string, sizeof(string), "UPDATE `Players` SET AccountBanned = '1' WHERE `Name` = '%s'", name);
		mysql_query(string);
		format(string, 160, " %s(%d) ha bannato l'account di %s! ", PlayerInfo[playerid][playerName], playerid, name);
		SendMessageToAdmin(string, -1);
	}
	return 1;
}*/

/*CMD:changeplayername(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 20)
	{
		new id, newname[25];
		if(sscanf(params, "us[25]", id, newname))return SendClientMessage(playerid, COLOR_GREY, "/changeplayername <playerid/partofname> <newname>");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Giocatore non connesso!");
		new string[256];
		mysql_format(MySQLC, string, sizeof(string), "SELECT * FROM `Players` WHERE `Name` = '%s'", newname);
		mysql_tquery(MySQLC, string);
			if(mysql_num_rows() == 1)return SendClientMessage(playerid, COLOR_RED, "Nome gi� in uso!");
		SetPlayerName(id, newname);
		format(string, sizeof(string), "UPDATE `Players` SET Name = '%s' WHERE `ID` = '%d'", newname, PlayerInfo[id][playerID]);
		mysql_query(string);
		//House
		format(string, sizeof(string), "SELECT ID FROM `Houses` WHERE `OwnerName` = '%s' AND `OwnerID` = '%d'", PlayerInfo[id][playerName], PlayerInfo[id][playerID]);
		mysql_query(string);
		new i = mysql_fetch_int();
		if(mysql_num_rows() == 1)
		{
			format(string, sizeof(string), "UPDATE `Houses` SET Name = '%s' WHERE `OwnerID` = '%d'", newname, PlayerInfo[id][playerID]);
			mysql_query(string);
			format(string, 128, "%s (%d)\nProprietario: %s", GetLocationNameFromCoord(HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ]), i, HouseInfo[i][OwnerName]);
			UpdateDynamic3DTextLabelText(HouseInfo[i][hLabel], -1, string);
		}
		for(new v = 1; v < MAX_VEHICLE_SLOT; v++)
		{
			if(PlayerVehicle[id][v][vID] == 0)continue;
			strcpy(VehicleInfo[PlayerVehicle[id][v][vID]][vOwnerName], PlayerInfo[playerid][playerName], 24);
		}
		SavePlayerVehicle(id);
		format(string, 160, " %s(%d) ha cambiato il nome dell'ID %d. (Nuovo Nome: %s)", PlayerInfo[playerid][playerName], playerid, id, newname);
		SendMessageToAdmin(string, -1);
	}
	return 1;
}*/

/*CMD:unbanaccount(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 5)
	{
		new name[30];
		if(sscanf(params, "s[30]", name))return SendClientMessage(playerid, COLOR_GREY, "/unbanaccount <Nome Completo>");
		new string[256];
		format(string, sizeof(string), "SELECT AccountBanned FROM `Players` WHERE `Name` = '%s'", name);
		mysql_query(string);
		mysql_store_result();
		if(mysql_num_rows() == 0)
		{
			format(string, sizeof(string), "L'account ''%s'' non esiste!", name);
			SendClientMessage(playerid, COLOR_RED, string);
			return 1;
		}
		if(mysql_fetch_int() == 0)
		{
			format(string, sizeof(string), EMB_WHITE"L'account ''"EMB_GREEN"%s"EMB_WHITE"'' non � bannato!", name);
			SendClientMessage(playerid, -1, string);
			return 1;
		}
		format(string, sizeof(string), "UPDATE `Players` SET AccountBanned = '0' WHERE `Name` = '%s'", name);
		mysql_query(string);
		mysql_free_result();
		format(string, 160, " "EMB_GREEN" %s"EMB_WHITE"(%d) ha sbannato l'account di "EMB_GREEN"%s"EMB_WHITE"! ", PlayerInfo[playerid][playerName], playerid, name);
		SendMessageToAdmin(string, -1);
	}
	return 1;
}*/


CMD:banaccount(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 5)
	{
		new id, reason[50];
		if(sscanf(params, "us[50]", id, reason))return SendClientMessage(playerid, COLOR_GREY, "/banaccount <playerid/partofname> <Reason>");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Giocatore non connesso!");
		if(PlayerInfo[id][playerAdmin] > PlayerInfo[playerid][playerAdmin])return SendClientMessage(playerid, COLOR_RED, "Non puoi utilizzare questo comando su questo giocatore!");
		new string[256];
		format(string, 128, " %s ha bannato l'account di %s. Motivo: %s ", PlayerInfo[playerid][playerName], PlayerInfo[id][playerName], reason);
		SendClientMessageToAll(-1, string);
		mysql_format(MySQLC, string, sizeof(string), "UPDATE `Players` SET AccountBanned = '1' WHERE `ID` = '%d' AND `Name` = '%s'", PlayerInfo[id][playerID], PlayerInfo[id][playerName]);
		mysql_tquery(MySQLC, string);
		KickPlayer(id);
	}
	return 1;
}


CMD:permaban(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 5)
	{
		new id, reason[50];
		if(sscanf(params, "us[50]", id, reason))return SendClientMessage(playerid, COLOR_GREY, "/permaban <playerid/partofname> <Reason>");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Giocatore non connesso!");
		if(PlayerInfo[id][playerAdmin] > PlayerInfo[playerid][playerAdmin])return SendClientMessage(playerid, COLOR_RED, "Non puoi utilizzare questo comando su questo giocatore!");
		new string[256];
		format(string, 128, " %s ha bannato permanentemente %s. Motivo: %s ", PlayerInfo[playerid][playerName], PlayerInfo[id][playerName], reason);
		SendClientMessageToAll(-1, string);
		mysql_format(MySQLC, string, sizeof(string), "UPDATE `Players` SET AccountBanned = '1' WHERE `ID` = '%d' AND `Name` = '%s'", PlayerInfo[id][playerID], PlayerInfo[id][playerName]);
		mysql_tquery(MySQLC, string);
		BanPlayer(id);
	}
	return 1;
}

CMD:givejetpack(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 1)
	{
		new string[128];
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
		format(string, 128, " "EMB_GREEN"%s"EMB_WHITE"(%d) si e' givato un Jetpack. ", PlayerInfo[playerid][playerName], playerid);
		SendMessageToAdmin(string, -1);
	}
	return 1;
}

CMD:n(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 1)
	{
		new text[140];
		if(sscanf(params, "s[130]", text))return SendClientMessage(playerid, COLOR_GREY, "/n <messaggio>");
		new string[128];
		format(string, 128, "** Admin %s(%d): %s **", PlayerInfo[playerid][playerName], playerid, text);
		SendMessageToAll(COLOR_PURPLE, string);
	}
	return 1;
}
/**/

CMD:aduty(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 1)
	{
		if(playerADuty[playerid] == true)
		{
			DestroyDynamic3DTextLabel(playerADutyLabel[playerid]);
			playerADuty[playerid] = false;
			SetPlayerHealth(playerid, 99.0);
			if(PlayerInfo[playerid][playerTeam] == TEAM_CIVILIAN)GivePlayerWantedLevelEx(playerid, 0, "Sei uscito dall'Admin Duty!");
			else if(PlayerInfo[playerid][playerTeam] == TEAM_POLICE)SetPlayerColor(playerid, COLOR_BLUE);
		}
		else if(playerADuty[playerid] == false)
		{
			new Float:Pos[3];
			GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
			playerADutyLabel[playerid] = CreateDynamic3DTextLabel("Admin Duty", COLOR_PURPLE, Pos[0], Pos[1]+15.0, Pos[2], 50, playerid);
			playerADuty[playerid] = true;
			SendClientMessage(playerid, COLOR_GREEN, "Adesso sei in AdminDuty. Non puoi essere ucciso o essere rapinato!");
			SendClientMessage(playerid, COLOR_GREEN, "Ricorda che puoi teletrasportarti dove vuoi cliccando con il tasto destro sulla mappa!");
			SetPlayerHealth(playerid, 0x7F800000);
			SetPlayerColor(playerid, COLOR_GREEN);
		}
	}
	return 1;
}

CMD:dom(playerid, params[])
{
	new text[64];
	if(sscanf(params, "s[60]", text))return SendClientMessage(playerid, COLOR_GREY, "/dom <messaggio>");
	new string[128];
	format(string, 128, "** [Domanda] %s[%d]: %s **", PlayerInfo[playerid][playerName], playerid, text);
	SendMessageToAdmin(string, COLOR_LIGHTRED);
	SendClientMessage(playerid, COLOR_GREENYELLOW, "Messaggio inviato a tutti gli amministratori online...");
	return 1;
}

CMD:report(playerid, params[])
{
	new text[64], id;
	if(sscanf(params, "ds[60]", id, text))return SendClientMessage(playerid, COLOR_GREY, "/report <playerid/partofname> <motivo>");
	new string[128];
	format(string, 128, "** [Report] %s[%d] ha reportato %s[%d]. Motivo: %s **", PlayerInfo[playerid][playerName], playerid, PlayerInfo[id][playerName], id, text);
	SendMessageToAdmin(string, COLOR_LIGHTRED);
	SendClientMessage(playerid, COLOR_GREENYELLOW, "Report inviato a tutti gli amministratori online...");
	return 1;
}

CMD:reportbug(playerid, params[])
{
	new text[70];
	if(sscanf(params, "s[68]", text))return SendClientMessage(playerid, COLOR_GREY, "/reportbug <Text>");
	if(strlen(text) < 15)return SendClientMessage(playerid, COLOR_RED, "Messaggio troppo corto!");
	new File:file = fopen("ReportBugs.txt", io_append), txy[100];
	format(txy, sizeof(txy), "Reporta da %s: %s\r\n", PlayerInfo[playerid][playerName], text);
	fwrite(file, txy);
	fclose(file);
	format(txy, sizeof(txy), "Report Bug inviato! ''%s''", text);
	SendMessageToPlayer(playerid, -1, txy);
	return 1;
}


CMD:a(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 1)
	{
		new text[140];
		if(sscanf(params, "s[138]", text))return SendClientMessage(playerid, COLOR_GREY, "/a <messaggio>");
		new string[128];
		format(string, 128, "[ADMINCHAT] %s [%d]: %s ", PlayerInfo[playerid][playerName], playerid, text);
		SendMessageToAdmin(string, COLOR_YELLOW);
	}
	return 1;
}

CMD:pchat(playerid, params[])
{
	if(PlayerInfo[playerid][playerPremium] == PLAYER_NO_PREMIUM)return SendClientMessage(playerid, COLOR_RED, "Solo i premium possono usare questo comando!");
	new text[64];
	if(sscanf(params, "s[60]", text))return SendClientMessage(playerid, COLOR_GREY, "/pchat <messaggio>");
	new string[128], str[10];
	switch(PlayerInfo[playerid][playerPremium])
	{
		case PLAYER_PREMIUM_BRONZE: str = "Bronze";
		case PLAYER_PREMIUM_SILVER: str = "Silver";
		case PLAYER_PREMIUM_GOLD: str = "Gold";
	}
	format(string, 128, "** [PREMIUM %s]: %s[%d]: %s **", str, PlayerInfo[playerid][playerName], playerid, text);
	SendMessageToPremium(string, COLOR_YELLOW);
	return 1;
}

SendMessageToPremium(text[], color)
{
	foreach(new i : Player)
	{
		if(!PlayerInfo[i][playerLogged])continue;
		if(PlayerInfo[i][playerPremium] == PLAYER_NO_PREMIUM)continue;
		SendMessageToPlayer(i, color, text);
	}
}

CMD:adminchat(playerid, params[])
{
	return cmd_a(playerid, params);
}

CMD:setarmor(playerid, params[]) return cmd_setarmour(playerid, params);

CMD:setpremium(playerid, params[])
{
	if(GetPlayerAdminLevel(playerid) >= 5)
	{
		new id, prm, iDays, iHours, iMinutes;
		if(sscanf(params, "udddd", id, prm, iDays, iHours, iMinutes))
		{
			SendClientMessage(playerid, COLOR_GREY, "/setpremium <playerid/partofname> <premiumid> <giorni> <ore> <minuti>");
			SendClientMessage(playerid, COLOR_GREY, "PremiumID: 0: Rimuovi Premium.");
			SendClientMessage(playerid, COLOR_GREY, "PremiumID: 1: Premium Bronze.");
			SendClientMessage(playerid, COLOR_GREY, "PremiumID: 2: Premium Silver.");
			SendClientMessage(playerid, COLOR_GREY, "PremiumID: 3: Premium Gold.");
			return 1;
		}
		if(prm < PLAYER_NO_PREMIUM || prm > PLAYER_PREMIUM_GOLD)return SendClientMessage(playerid, -1, "PremiumID invalido!");
		if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Il giocatore non e' connesso!");
		if(prm == PLAYER_NO_PREMIUM)
		{
			if(PlayerInfo[id][playerPremium] == PLAYER_NO_PREMIUM)return SendClientMessage(playerid, -1, "Questo giocatore non e' un Premium!");
			new string[128];
			format(string, 128, " "EMB_GREEN"%s"EMB_WHITE"(%d) ha rimosso il Premium a "EMB_GREEN"%s"EMB_WHITE"(%d)."EMB_YELLOW" ", PlayerInfo[playerid][playerName], playerid, PlayerInfo[id][playerName], id);
			SendMessageToAdmin(string, -1);
			format(string, 128, " "EMB_GREEN"%s"EMB_WHITE"(%d) ti ha rimosso il Premium. ", PlayerInfo[playerid][playerName], playerid);
			SendClientMessage(id, COLOR_GREEN, string);
			PlayerInfo[id][playerPremiumTime] = 0;
			PlayerInfo[id][playerPremium] = PLAYER_NO_PREMIUM;
			mysql_format(MySQLC,string, sizeof(string), "UPDATE `Players` SET PremiumTime = '0', Premium = '0' WHERE `ID` = '%d' AND `Name` = '%s'", PlayerInfo[id][playerID], PlayerInfo[id][playerName]);
			mysql_tquery(MySQLC, string);
		}
		else
		{
			new calc = gettime()+mktime(iHours, iMinutes, 0, iDays, 0, 0);
			if(calc == gettime())return SendClientMessage(playerid, -1, "Non puoi settare premium una persona per 0 giorni e 0 ore!");
			PlayerInfo[id][playerPremiumTime] = calc;
			PlayerInfo[id][playerPremium] = prm;
			new string[128], stry[10];
			switch(PlayerInfo[id][playerPremium])
			{
				case PLAYER_PREMIUM_BRONZE: stry = "Bronzo";
				case PLAYER_PREMIUM_SILVER: stry = "Argento";
				case PLAYER_PREMIUM_GOLD: stry = "Oro";
			}
			format(string, 128, " "EMB_GREEN"%s"EMB_WHITE"(%d) ha settato "EMB_GREEN"%s"EMB_WHITE"(%d) Premium %s per %d giorni e %d ore."EMB_YELLOW" ", PlayerInfo[playerid][playerName], playerid, PlayerInfo[id][playerName], id, stry, iDays, iHours);
			SendMessageToAdmin(string, -1);
			format(string, 128, " "EMB_GREEN"%s"EMB_WHITE"(%d) ti ha settato Premium %s per %d giorni e %d ore. ", PlayerInfo[playerid][playerName], playerid, stry, iDays, iHours);
			SendClientMessage(id, COLOR_GREEN, string);
			mysql_format(MySQLC, string, sizeof(string), "UPDATE `Players` SET PremiumTime = '%d', Premium = '%d' WHERE `ID` = '%d' AND `Name` = '%s'", PlayerInfo[id][playerPremiumTime], prm, PlayerInfo[id][playerID], PlayerInfo[id][playerName]);
			mysql_tquery(MySQLC, string);
		}
		new Float:Pos[3];
		GetPlayerPos(id, Pos[0], Pos[1], Pos[2]);
		if(PlayerInfo[id][playerPremium] == PLAYER_PREMIUM_BRONZE)
		{
			playerPremiumLabel[id] = CreateDynamic3DTextLabel("Premium Bronzo", COLOR_GOLD, Pos[0], Pos[1], Pos[2]+0.3, 50, id);
		}
		else if(PlayerInfo[id][playerPremium] == PLAYER_PREMIUM_SILVER)
		{
			playerPremiumLabel[id] = CreateDynamic3DTextLabel("Premium Argento", COLOR_GOLD, Pos[0], Pos[1], Pos[2]+0.3, 50, id);
		}
		else if(PlayerInfo[id][playerPremium] == PLAYER_PREMIUM_GOLD)
		{
			playerPremiumLabel[id] = CreateDynamic3DTextLabel("Premium Oro", COLOR_GOLD, Pos[0], Pos[1], Pos[2]+0.3, 50, id);
		}
		else
		{
			DestroyDynamic3DTextLabel(playerPremiumLabel[id]);
		}
		SavePlayer(id);
	}
	return 1;
}

/*CMD:tempban(playerid, params[])
{
if(GetPlayerAdminLevel(playerid) >= 3)
{
	new id, iDays, iMinutes, iHours, reason[41];
	if(sscanf(params, "uddds[40]", id, iDays, iHours, iMinutes, reason))return SendClientMessage(playerid, COLOR_GREY, "/tempban <playerid/partofname> | <Giorni> <Ore> <Minuti> | <Motivo>");
	if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, COLOR_RED, "Il giocatore non � connesso!");
	new calc = gettime()+mktime(iHours, iMinutes, 0, iDays, 0, 0);
	if(calc == gettime())return SendClientMessage(playerid, -1, "Non puoi bannare una persona per 0 giorni, 0 ore e 0 minuti!");
	PlayerInfo[id][playerBanTime] = calc;
	new string[140];
	format(string, sizeof(string), " "EMB_GREEN"%s"EMB_WHITE"(%d) ha bannato "EMB_GREEN"%s"EMB_WHITE"(%d) per %d giorni, %d ore e %d minuti. Motivo: %s. ", PlayerInfo[playerid][playerName], playerid, PlayerInfo[id][playerName], id, iDays, iHours, iMinutes, reason);
	SendMessageToAdmin(string, COLOR_YELLOW);
	format(string, sizeof(string), " "EMB_GREEN"%s"EMB_WHITE"(%d) ti ha bannato per %d giorni, %d ore e %d minuti. Motivo: %s. ", PlayerInfo[playerid][playerName], playerid, iDays, iHours, iMinutes, reason);
	SendClientMessage(id, COLOR_RED, string);
	format(string, sizeof(string), "UPDATE `Players` SET BanTime = '%d' WHERE `ID` = '%d' AND `Name` = '%s'", PlayerInfo[id][playerBanTime], PlayerInfo[id][playerID], PlayerInfo[id][playerName]);
	mysql_query(string);
	mysql_store_result();
	mysql_free_result();
	SavePlayer(id);
	KickPlayer(id);
}
return 1;
}*/

forward KickorBan(playerid, type);
public KickorBan(playerid, type)
{
	SavePlayer(playerid);
	SavePlayerVehicle(playerid);
	if(type == 0)
	{
		Kick(playerid);
	}
	else
	{
		Ban(playerid);
	}
	return 1;
}
/*	Showroom Function & Player Vehicle System	*/

new Float:shX, Float:shY, Float:shZ;
CMD:createshowroom(playerid, params[])
{
	if(PlayerInfo[playerid][playerAdmin] < 8) return 1;
	if(creatingShowroom != playerid && creatingShowroom != -1) return SendClientMessage(playerid, COLOR_RED, "Another showroom is begin created, wait untill it's done");
	new id;
	if(creatingShowroom == playerid)
	{
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_RED, " > You must be in the designated Landstalker to select the vehicle spawn point!");
		new name[32];
		if(sscanf(params, "s[32]", name)) return SendClientMessage(playerid, COLOR_RED, "> /createshowroom <name>");
		new Float:cX, Float:cY, Float:cZ, Float:cA;
		GetVehiclePos(GetPlayerVehicleID(playerid), cX, cY, cZ);
		GetVehicleZAngle(GetPlayerVehicleID(playerid), cA);
		CreateServerShowroom(name, createdShowrooms, shX, shY, shZ, cX, cY, cZ, cA);
		DestroyVehicle(GetPlayerVehicleID(playerid));
		new string[156];
		format(string,sizeof(string), "> You created the showroom %s [ID: %d], use /addvtoshowroom to add vehicles to this showroom",name,createdShowrooms-1);
		SendClientMessage(playerid, COLOR_GREEN, string);
		creatingShowroom = -1;
	}
	else
	{
		GetPlayerPos(playerid, shX, shY, shZ);
		SendClientMessage(playerid, COLOR_GREEN, "> You started creating a Showroom, Now reuse the command where the bought vehicles should spawn");
		SendClientMessage(playerid, COLOR_GREEN, "> Make sure there is enough space for bigger vehicles!");
		id = CreateVehicle(400, shX, shY, shZ, 0.0, 0, 0, 0);
		PutPlayerInVehicle(playerid, id, 0);
		creatingShowroom = playerid;
	}
	return 1;
}

stock CreateServerShowroom(name[], showroomid, Float:X, Float:Y, Float:Z, Float:cX, Float:cY, Float:cZ, Float:cA)
{
	if(showroomid >= MAX_SHOWROOM) return print("Max Showroom created!");
	ShowroomPickupPos[showroomid][0] = X;
	ShowroomPickupPos[showroomid][1] = Y;
	ShowroomPickupPos[showroomid][2] = Z;
	ShowroomPickup[showroomid] = CreateDynamicPickup(1239, 1, X, Y, Z, 0, 0);
	CreateDynamicMapIcon(X, Y, Z, 55, -1, -1, -1, -1, 9999.0);
	CreateDynamic3DTextLabel(name, -1, X, Y, Z+0.5, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, 50.0);
	printf("===== %s =====", name);
	new query[200];
	mysql_format(MySQLC, query, sizeof(query), "INSERT INTO showrooms (name, posx, posy, posz, carx, cary, carz, cara) VALUES('%e', '%f', '%f', '%f', '%f', '%f', '%f', '%f')",name, X,Y,Z, cX, cY, cZ, cA);
	mysql_tquery(MySQLC, query);
	strcpy(ShowroomName[showroomid], name);
	createdShowrooms++;
	return 1;
}

stock CreateShowroomVehicle(ShowroomID, vehicleModel, price, Float:X, Float:Y, Float:Z, Float:A)
{
	ShowroomVehicle[ShowroomID][showroomvehs[ShowroomID]][sModel] = vehicleModel;
	ShowroomVehicle[ShowroomID][showroomvehs[ShowroomID]][sPrice] = price;
	new id = CAR_CreateVehicle(vehicleModel, X, Y, Z, A, random(200), random(200), -1);
	VehicleInfo[id][vShowroom] = true;
	new string[200];
	format(string,sizeof(string), EMB_LIGHTBLUE"Veicolo: %s\nCosto: %s\nConcessionaria: %s\n\nSali su questo veicolo per maggiori informazioni sull'acquisto",GetVehicleName(vehicleModel), ConvertPrice(price), ShowroomName[ShowroomID]);
	CreateDynamic3DTextLabel(string, COLOR_WHITE, X,Y,Z,4.0, _, id, _, _, _, _, _, _);
	showroomvehs[ShowroomID]++;
	return id;
}

forward LoadShowrooms();
public LoadShowrooms()
{
	new cout, field[30], query[300];
	cache_get_row_count(cout);
	for(new i = 0; i < cout; i++)
	{
		cache_get_value_index(i, 1, field);
		strcpy(ShowroomName[i], field, 32);
		cache_get_value_index_float(i, 2, 	ShowroomPickupPos[i][0]);
		cache_get_value_index_float(i, 3, 	ShowroomPickupPos[i][1]);
		cache_get_value_index_float(i, 4, 	ShowroomPickupPos[i][2]);
		CreateDynamic3DTextLabel(field, -1, ShowroomPickupPos[i][0], ShowroomPickupPos[i][1], ShowroomPickupPos[i][2]+0.5, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, 50.0);
		ShowroomPickup[i] = CreateDynamicPickup(1239, 1, ShowroomPickupPos[i][0], ShowroomPickupPos[i][1], ShowroomPickupPos[i][2], 0, 0);
		CreateDynamicMapIcon(ShowroomPickupPos[i][0], ShowroomPickupPos[i][1], ShowroomPickupPos[i][2], 55, -1, -1, -1, -1, 9999.0);
		createdShowrooms++;
		mysql_format(MySQLC, query,sizeof(query), "SELECT * FROM showroomcars WHERE showid = '%d'",i);
		mysql_tquery(MySQLC, query, "LoadShowroomVehicles","d",i);
	}
	printf("Loaded %d showrooms",createdShowrooms);
	return 1;
}

forward LoadShowroomVehicles(sid);
public LoadShowroomVehicles(sid)
{
	new cout,model, price, Float:X, Float:Y, Float:Z, Float:A;
	cache_get_row_count(cout);
	for(new i = 0; i < cout; i++)
	{
		cache_get_value_index_int(i, 2, model);
		cache_get_value_index_int(i, 3, price);
		cache_get_value_index_float(i, 4, X);
		cache_get_value_index_float(i, 5, Y);
		cache_get_value_index_float(i, 6, Z);
		cache_get_value_index_float(i, 7, A);
		CreateShowroomVehicle(sid, model, price, X,Y,Z,A);
	}
	printf("Loaded %d vehicles for %s [%d]", showroomvehs[sid], ShowroomName[sid], sid);
	return 1;
}

stock CreatePlayerVehicle(playerid, cpvModel, Float:cpvX, Float:cpvY, Float:cpvZ, Float:cpvA, cpvColor1, cpvColor2)
{
	new SlotID = GetPlayerFreeSlot(playerid);
	if(SlotID == 0)return SendClientMessage(playerid, COLOR_RED, "Possiedi troppi veicoli!");
	PlayerVehicle[playerid][SlotID][vID] = CreateVehicle(cpvModel, cpvX, cpvY, cpvZ, cpvA, cpvColor1, cpvColor2, -1);
	new vid = PlayerVehicle[playerid][SlotID][vID];
	VehicleInfo[vid][vOwnerID] = PlayerInfo[playerid][playerID];
	VehicleInfo[vid][vModel] = cpvModel;
	VehicleInfo[vid][vX] = cpvX;
	VehicleInfo[vid][vY] = cpvY;
	VehicleInfo[vid][vZ] = cpvZ;
	VehicleInfo[vid][vA] = cpvA;
	VehicleInfo[vid][vColor1] = cpvColor1;
	VehicleInfo[vid][vColor2] = cpvColor2;
	VehicleInfo[vid][vOwned] = true;
	Iter_Add(ServerVehicle, PlayerVehicle[playerid][SlotID][vID]);
	VehicleInfo[vid][vClosed] = 0;
	strcpy(VehicleInfo[vid][vOwnerName], PlayerInfo[playerid][playerName], 24);
	for(new mod = 0; mod<18; mod++)
	{
		if(mod == 17)
		{
			VehicleInfo[ PlayerVehicle[playerid][SlotID][vID] ][vMod][17] = 3;
		}
		else
		{
			VehicleInfo[ PlayerVehicle[playerid][SlotID][vID] ][vMod][mod] = 0;
		}
	}
	new query[512];
	mysql_format(MySQLC, query, sizeof query, "INSERT INTO `playervehicle` (`Slot`, `OwnerID`, `Model`, `OwnerName`, `X`, `Y`, `Z`, `A`, `Color1`, `Color2`, `Closed`) VALUES('%d', '%d', '%d', '%s', '%f', '%f', '%f', '%f', '%d', '%d', 0)",
		SlotID, VehicleInfo[vid][vOwnerID], VehicleInfo[vid][vModel], VehicleInfo[vid][vOwnerName], cpvX, cpvY, cpvZ, cpvA, cpvColor1, cpvColor2);
	mysql_tquery(MySQLC, query);
	print(query);
	vehicleCount[playerid] ++;
	SetVehicleParamsEx(PlayerVehicle[playerid][SlotID][vID], true, false, false, false, false, false, false);
	SavePlayerVehicle(playerid);
	return PlayerVehicle[playerid][SlotID][vID];
}

/**/
new VehicleNames[][] =
{
	"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel",
	"Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
	"Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
	"Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection",
	"Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus",
	"Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie",
	"Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral",
	"Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder",
	"Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair", "Berkley's RC Van",
	"Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale",
	"Oceanic","Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy",
	"Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX",
	"Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper",
	"Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking",
	"Blista Compact", "Police Maverick", "Boxville", "Benson", "Mesa", "RC Goblin",
	"Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher", "Super GT",
	"Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt",
	"Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra",
	"FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck", "Fortune",
	"Cadrona", "FBI Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer",
	"Remington", "Slamvan", "Blade", "Freight", "Streak", "Vortex", "Vincent",
	"Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo",
	"Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite",
	"Windsor", "Monster A", "Monster B", "Uranus", "Jester", "Sultan", "Stratium",
	"Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
	"Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper",
	"Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400",
	"News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
	"Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "Police Car",
	"Police Car", "Police Car", "Police Ranger", "Picador", "S.W.A.T", "Alpha",
	"Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs", "Boxville",
	"Tiller", "Utility Trailer"
};

stock GetVehicleName(model)
{
	new String[22];
	format(String,sizeof(String),"%s",VehicleNames[model - 400]);
	return String;
}


/**/
stock LoadTextDrawForPlayer(playerid)
{
	InfoText[playerid] = CreatePlayerTextDraw(playerid, 143.000000, 360.000000, "");
	PlayerTextDrawBackgroundColor(playerid,InfoText[playerid], 255);
	PlayerTextDrawFont(playerid,InfoText[playerid], 1);
	PlayerTextDrawLetterSize(playerid,InfoText[playerid], 0.259999, 1.899999);
	PlayerTextDrawColor(playerid,InfoText[playerid], -1);
	PlayerTextDrawSetOutline(playerid,InfoText[playerid], 0);
	PlayerTextDrawSetProportional(playerid,InfoText[playerid], 1);
	PlayerTextDrawSetShadow(playerid,InfoText[playerid], 1);
	PlayerTextDrawSetSelectable(playerid,InfoText[playerid], 0);

	InfoText2[playerid] = CreatePlayerTextDraw(playerid,143.000000, 387.000000, "");
	PlayerTextDrawBackgroundColor(playerid,InfoText2[playerid], 255);
	PlayerTextDrawFont(playerid,InfoText2[playerid], 1);
	PlayerTextDrawLetterSize(playerid,InfoText2[playerid], 0.269999, 1.899999);
	PlayerTextDrawColor(playerid,InfoText2[playerid], -1);
	PlayerTextDrawSetOutline(playerid,InfoText2[playerid], 0);
	PlayerTextDrawSetProportional(playerid,InfoText2[playerid], 1);
	PlayerTextDrawSetShadow(playerid,InfoText2[playerid], 1);
	PlayerTextDrawSetSelectable(playerid,InfoText2[playerid], 0);

	WantedLevelText[playerid] = CreatePlayerTextDraw(playerid, 597.364746, 108.500038, "");
	PlayerTextDrawLetterSize(playerid, WantedLevelText[playerid], 0.232605, 1.249998);
	PlayerTextDrawTextSize(playerid, WantedLevelText[playerid], -61.844791, -24.500000);
	PlayerTextDrawAlignment(playerid, WantedLevelText[playerid], 1);
	PlayerTextDrawColor(playerid, WantedLevelText[playerid], -5963521);
	PlayerTextDrawSetShadow(playerid, WantedLevelText[playerid], 0);
	PlayerTextDrawSetOutline(playerid, WantedLevelText[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, WantedLevelText[playerid], 51);
	PlayerTextDrawFont(playerid, WantedLevelText[playerid], 1);
	PlayerTextDrawSetProportional(playerid, WantedLevelText[playerid], 1);


	TextLogin[playerid] = CreatePlayerTextDraw(playerid,1.000000, 0.000000, "");
	PlayerTextDrawBackgroundColor(playerid,TextLogin[playerid], 255);
	PlayerTextDrawFont(playerid,TextLogin[playerid], 1);
	PlayerTextDrawLetterSize(playerid,TextLogin[playerid], 0.490000, 11.399995);
	PlayerTextDrawColor(playerid,TextLogin[playerid], -1);
	PlayerTextDrawSetOutline(playerid,TextLogin[playerid], 0);
	PlayerTextDrawSetProportional(playerid,TextLogin[playerid], 1);
	PlayerTextDrawSetShadow(playerid,TextLogin[playerid], 1);
	PlayerTextDrawUseBox(playerid,TextLogin[playerid], 1);
	PlayerTextDrawBoxColor(playerid,TextLogin[playerid], 255);
	PlayerTextDrawTextSize(playerid,TextLogin[playerid], 714.000000, 118.000000);
	PlayerTextDrawSetSelectable(playerid,TextLogin[playerid], 0);

	TextLogin2[playerid] = CreatePlayerTextDraw(playerid,1.000000, 344.000000, "");
	PlayerTextDrawBackgroundColor(playerid,TextLogin2[playerid], 255);
	PlayerTextDrawFont(playerid,TextLogin2[playerid], 1);
	PlayerTextDrawLetterSize(playerid,TextLogin2[playerid], -0.429998, 16.600006);
	PlayerTextDrawColor(playerid,TextLogin2[playerid], -1);
	PlayerTextDrawSetOutline(playerid,TextLogin2[playerid], 0);
	PlayerTextDrawSetProportional(playerid,TextLogin2[playerid], 1);
	PlayerTextDrawSetShadow(playerid,TextLogin2[playerid], 1);
	PlayerTextDrawUseBox(playerid,TextLogin2[playerid], 1);
	PlayerTextDrawBoxColor(playerid,TextLogin2[playerid], 255);
	PlayerTextDrawTextSize(playerid,TextLogin2[playerid], 714.000000, 118.000000);
	PlayerTextDrawSetSelectable(playerid,TextLogin2[playerid], 0);


	TextLoot[playerid] = CreatePlayerTextDraw(playerid, 501.037994, 420.583282, "");
	PlayerTextDrawLetterSize(playerid, TextLoot[playerid], 0.517467, 2.224167);
	PlayerTextDrawTextSize(playerid, TextLoot[playerid], 60.439323, 8.749993);
	PlayerTextDrawAlignment(playerid, TextLoot[playerid], 1);
	PlayerTextDrawColor(playerid, TextLoot[playerid], -65281);
	PlayerTextDrawSetShadow(playerid, TextLoot[playerid], 0);
	PlayerTextDrawSetOutline(playerid, TextLoot[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, TextLoot[playerid], 51);
	PlayerTextDrawFont(playerid, TextLoot[playerid], 3);
	PlayerTextDrawSetProportional(playerid, TextLoot[playerid], 1);
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	return 1;
}
public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	return 1;
}

stock IsVehicleOwnedFromPlayer(playerid, vehicleid) //Controlla se il veicolo (vehicleid) � comprato dal player (playerid)
{
	if(!PlayerInfo[playerid][playerLogged])return 0;
	if(VehicleInfo[vehicleid][vOwnerID] == PlayerInfo[playerid][playerID])return true;
	return false;
}

stock GetVehicleOwner(vehicleid) //Ritorna l'ID del proprietario dal veicolo (vehicleid).
{
	foreach(new i : Player)
	{
		if(!PlayerInfo[i][playerLogged])continue;
		if(GetPlayerVehicleCount(i) == 0)continue;
		for(new slot = 1; slot < GetPlayerVehicleCount(i); slot++)
		{
			if(PlayerVehicle[i][slot][vID] == 0)continue;
			if(PlayerVehicle[i][slot][vID] == vehicleid)return i;
		}
	}
	return INVALID_PLAYER_ID;
}

stock GetPlayerFreeSlot(playerid) //Ritorna lo slot libero del player. (Ritorna 0 se non ne ha)
{
	for(new i = 1; i < MAX_VEHICLE_SLOT; i++)
	{
		if(PlayerVehicle[playerid][i][vID] != 0) continue;
		return i;
	}
	return 0;
}

stock GetVehicleSlotID(vehicleid)//Ritorna lo slot ID del veicolo (vehicleid)
{
	foreach(new i : Player)
	{
		if(!PlayerInfo[i][playerLogged])continue;
		if(GetPlayerVehicleCount(i) == 0)continue;
		for(new slot = 1; slot < MAX_VEHICLE_SLOT; slot++)
		{
			if(PlayerVehicle[i][slot][vID] == vehicleid)return slot;
		}
	}
	return 0;
}

stock IsNumeric(const string[])
{
	for (new i = 0, j = strlen(string); i < j; i++)
	{
		if (string[i] > '9' || string[i] < '0') return 0;
	}
	return 1;
}




stock SendMessageToAll(color, string[])
{
	new firstString[130], secondString[130];
	if(strlen(string) > 120)
	{
		strmid(firstString, string, 0, 120);
		strins(firstString, " ..", 120);
		SendClientMessageToAll(color, firstString);
		strmid(secondString, string, 120, strlen(string));
		strins(secondString, ".. ", 0);
		SendClientMessageToAll(color, secondString);
	}
	else
	{
		SendClientMessageToAll(color, string);
	}
}

stock SendMessageToPlayer(playerid, color, string[])
{
	new firstString[130], secondString[130];
	if(strlen(string) > 120)
	{
		strmid(firstString, string, 0, 120);
		strins(firstString, " ..", 120);
		SendClientMessage(playerid, color, firstString);
		strmid(secondString, string, 120, strlen(string));
		strins(secondString, ".. ", 0);
		SendClientMessage(playerid, color, secondString);
	}
	else
	{
		SendClientMessage(playerid, color, string);
	}
}

stock SendMessageToAdmin(text[], color)
{
	foreach(new i : Player)
	{
		if(GetPlayerAdminLevel(i) > 0)
		{
			SendMessageToPlayer(i, color, text);
		}
	}
}

stock SendRangedMessage(playerid, color, text[], Float:range = 10.0)
{
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	foreach(new i : Player)
	{
		if(!PlayerInfo[i][playerLogged])continue;
		if(!IsPlayerInRangeOfPoint(i, range, X, Y, Z))continue;
		SendClientMessage(i, color, text);
	}
	return 1;
}

stock IsPlayerAtATM(playerid)
{
	for(new i = 0; i < sizeof(ATMPosition); i++)
	{
		if(IsPlayerInDynamicCP(playerid, ATMCheckpoint[i]))
		{
			return true;
		}
	}
	return false;
}

stock mktime(hour, minute, second, day, month, year)
{
	/* thanks to Y_Less again */
	static
	days_of_month[12] =
	{
		31,
		29,
		31,
		30,
		31,
		30,
		31,
		31,
		30,
		31,
		30,
		31
	},
	lMinute,
	lHour,
	lDay,
	lMonth,
	lYear,
	lMinuteS,
	lHourS,
	lDayS,
	lMonthS,
	lYearS;
	if (year != lYear)
	{
		lYearS = 0;
		for (new j = 1970; j < year; j++)
		{
			lYearS += 31536000;
			if ((!(j % 4) && (j % 100)) || !(j % 400)) lYearS += 86400;
		}
		lYear = year;
	}
	if (month != lMonth)
	{
		lMonthS = 0;
		month--;
		for (new i = 0; i < month; i++)
		{
			lMonthS += days_of_month[i] * 86400;
			if ((i == 1) && ((!(year % 4) && (year % 100)) || !(year % 400))) lMonthS += 86400;
		}
		lMonth = month;
	}
	if (day != lDay)
	{
		lDayS = day * 86400;
		lDay = day;
	}
	if (hour != lHour)
	{
		lHourS = hour * 3600;
		lHour = hour;
	}
	if (minute != lMinute)
	{
		lMinuteS = minute * 60;
		lMinute = minute;
	}
	return lYearS + lMonthS + lDayS + lHourS + lMinuteS + second;
}

stock LoadServerVehicles(bool:mustLoadBoxville)
{
	Iter_Add(ServerVehicle, CAR_CreateVehicle(523,1585.7927,-1671.7357,5.9539,269.5245,0,1, -1)); // Car1Police
	Iter_Add(ServerVehicle, CAR_CreateVehicle(596,1595.6611,-1710.3794,5.5629,358.8535,0,1, -1)); // Car2Police
	Iter_Add(ServerVehicle, CAR_CreateVehicle(596,1583.1389,-1710.4377,5.5638,358.8557,0,1, -1)); // Car3Police
	Iter_Add(ServerVehicle, CAR_CreateVehicle(596,1578.6586,-1710.3464,5.5603,0.0780,0,1, -1)); // Car4Police
	Iter_Add(ServerVehicle, CAR_CreateVehicle(490,1570.3894,-1710.5491,5.9983,0.2501,0,0, -1)); // Car5Police
	Iter_Add(ServerVehicle, CAR_CreateVehicle(523,1564.5081,-1710.2114,6.0509,1.4447,0,1, -1)); // Car6Police
	Iter_Add(ServerVehicle, CAR_CreateVehicle(523,1529.4756,-1688.1504,5.9382,269.8977,0,1, -1)); // Car7Police
	Iter_Add(ServerVehicle, CAR_CreateVehicle(523,1545.5867,-1672.0927,5.5630,91.6041,0,1, -1)); // Car8Police
	Iter_Add(ServerVehicle, CAR_CreateVehicle(523,1529.5497,-1683.7391,5.4613,270.5131,0,0, -1)); // Car9Police
	Iter_Add(ServerVehicle, CAR_CreateVehicle(490,1545.3586,-1663.0673,5.9972,90.0128,0,0, -1)); // Car10Police
	Iter_Add(ServerVehicle, CAR_CreateVehicle(599,1538.8448,-1644.4427,5.9684,179.7218,0,1, -1)); // Car11Police
	Iter_Add(ServerVehicle, CAR_CreateVehicle(421,1545.4321,-1684.3195,5.7731,89.0085,0,0, -1)); // Car12Police
	Iter_Add(ServerVehicle, CAR_CreateVehicle(497,1572.4979,-1646.3291,28.6105,179.3231,0,1, -1)); // Car13Police
	Iter_Add(ServerVehicle, CAR_CreateVehicle(497,1563.5820,-1646.0563,28.5401,181.8017,0,1, -1)); // Car14Police
	//ServerVehicle
	/*	[Public Vehicles]  */
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],980.1360,-924.8698,41.1101,185.6315,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1142.6627,-909.9866,42.7512,274.2201,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1227.0812,-918.5610,42.5283,99.5924,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1227.2549,-914.3937,42.5266,99.9340,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1461.9291,-1506.2062,13.1745,84.1209,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1669.6351,-1697.4783,15.2344,89.2512,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1669.8536,-1703.7388,15.2342,87.6608,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1669.9407,-1712.6472,15.2342,93.1875,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1671.8007,-1718.7469,20.1093,357.7398,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1658.5707,-1720.4526,20.1093,1.8344,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1918.8927,-1787.8694,13.0910,271.2179,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1840.0184,-1852.9855,13.0124,179.1622,random(200), random(200), -1)); // Unity
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1844.2854,-1870.7219,13.0128,1.3314,random(200), random(200), -1)); // Unity
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1838.0256,-1871.0194,13.0147,358.5986,random(200), random(200), -1)); // Unity
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1799.9445,-1933.1119,13.0111,0.5358,random(200), random(200), -1)); // Unity
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1790.1708,-1932.9685,13.0112,356.8899,random(200), random(200), -1)); // Unity
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1776.7902,-1899.5603,13.0120,268.2346,random(200), random(200), -1)); // Unity
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1776.6681,-1891.1387,13.0107,268.7180,random(200), random(200), -1)); // Unity
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1945.7526,-1977.2402,13.1719,268.8762,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],2030.2021,-1919.2935,13.1772,179.2077,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],2062.3269,-1919.7188,13.1719,359.2963,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],2052.5911,-1903.8136,13.1719,180.1955,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],2059.2827,-1903.8871,13.1718,179.3367,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],2065.7190,-1904.1962,13.1716,178.3206,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],2121.1511,-1781.2163,13.0138,89.5082,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],2441.3750,-1664.7710,13.0737,82.3558,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],2413.6897,-1538.2869,23.6248,180.8524,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],2392.7568,-1537.7168,23.6230,179.2654,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],2403.7222,-1537.3391,23.6250,178.4025,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],2390.9612,-1490.7062,23.4532,269.5209,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],2391.3901,-1493.9822,23.4582,269.9108,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],2795.5615,-1562.8317,10.5521,271.5863,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],2796.3296,-1576.0170,10.5516,269.5754,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],2822.4092,-1549.1147,10.5483,89.4491,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],2676.8235,-1672.4884,9.0236,179.1947,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],2681.6968,-1672.1493,9.0476,179.1171,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],2489.2388,-1953.2089,13.0507,0.1821,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],2485.9624,-1953.6348,13.0486,358.6346,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],2479.7297,-1953.1414,13.0529,358.6819,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],2394.1931,-2105.6406,13.1717,265.5450,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],2147.6250,-1203.4717,23.4795,265.4965,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],2161.2463,-1143.6345,24.4807,91.4563,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],2161.7175,-1158.2660,23.4633,89.0595,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],2216.9446,-1156.6973,25.3516,89.4310,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],2205.9675,-1169.0470,25.3539,271.6700,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],2228.3560,-1166.4852,25.3762,88.9955,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1358.7267,-1748.3615,13.0102,89.6858,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1098.7614,-1754.9807,12.9770,90.8224,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1099.0519,-1769.7552,12.9720,89.0377,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],353.6001,-1809.2401,4.1568,0.8619,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],343.9601,-1809.1243,4.1508,0.2148,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],324.5460,-1809.1431,4.1098,0.5236,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],315.0569,-1788.8546,4.2531,179.1826,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],413.3245,-1778.1156,5.0444,271.0960,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],670.7690,-1285.5538,13.1701,357.2714,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],2292.8003,-1671.3690,14.3794,90.9687,random(200), random(200), -1)); // 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],2284.7373,-1683.5405,13.6074,359.0476,random(200), random(200), -1)); // 1 60
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1682.6975,-1010.1321,23.6029,197.3869,random(200), random(200), -1)); // Public Vehicle 1
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1691.1586,-1069.6959,23.6107,179.1205,random(200), random(200), -1)); // Public Vehicle
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1650.0398,-1084.5276,23.6108,89.6662,random(200), random(200), -1)); // Public Vehicle
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1620.4521,-1085.3245,23.6106,90.0469, random(200), random(200), -1)); // Public Vehicle
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1629.6630,-1102.8582,23.6107,270.2871,random(200), random(200), -1)); // Public Vehicle
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1657.4586,-1102.7188,23.6121,270.2889,random(200), random(200), -1)); // Public Vehicle
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1616.0826,-1132.5492,23.6107,269.7352,random(200), random(200), -1)); // Public Vehicle
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1662.0278,-1135.6722,23.6110,0.2500,random(200), random(200), -1)); // Public Vehicle
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1015.1598,-1345.4341,13.0748,90.6661, random(200), random(200), -1)); // Public Vehicle
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1015.9608,-1358.8353,13.0788,87.4479,random(200), random(200), -1)); // Public Vehicle
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1002.8525,-1307.0516,13.0872,357.0521, random(200), random(200), -1)); // Public Vehicle
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1062.1533,-1758.0270,13.1230,270.5825,random(200), random(200), -1)); // Public Vehicle
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1084.5690,-1757.7916,13.0854,270.6667, random(200), random(200), -1));// Public Vehicle
	Iter_Add(ServerVehicle,  CAR_CreateVehicle(publicVehicles[random(sizeof(publicVehicles))],1098.3135,-1766.7501,13.0540,88.2722,random(200), random(200), -1)); // Public Vehicle

	if(mustLoadBoxville == true)
	{
		BoxvilleVehicle[0] = CAR_CreateVehicle(498, 2453.6396, -2112.7012,13.6169,1.0233, 0, 0, -1);
		Iter_Add(ServerVehicle,  BoxvilleVehicle[0]); // Boxville 1
		BoxvilleVehicle[1] = CAR_CreateVehicle(498, 2477.0115, -2115.5334,13.6163,358.4019, 0, 0, -1);
		Iter_Add(ServerVehicle,  BoxvilleVehicle[1]); // Boxville 2
		BoxvilleVehicle[2] = CAR_CreateVehicle(498, 2491.9063, -2114.6838,13.6183,359.5927, 0, 0, -1);
		Iter_Add(ServerVehicle,  BoxvilleVehicle[2]); // Boxville  3
	}
}



stock LoadMaps()
{
	//CS Rapina
	//CreateDynamicObject(1654,824.4000200,9.6000000,1004.7000100,0.0000000,224.0000000,98.0000000); //object(dynamite) (1)
	//CreateDynamicObject(1654,824.4000200,10.6000000,1004.0999800,0.0000000,322.0000000,85.9980000); //object(dynamite) (2)
	CreateDynamicObject(1829,820.5999800,8.8000000,1003.7000100,0.0000000,0.0000000,130.0000000); //object(man_safenew) (1)
	//  ATM Map
	CreateDynamicObject(2754,2112.0000000,-1790.5999800,13.4000000,0.0000000,0.0000000,270.0000000); //object(otb_machine) (1)
	CreateDynamicObject(2754,2685.5000000,-1422.1992200,30.4000000,0.0000000,0.0000000,0.0000000); //object(otb_machine) (2)
	CreateDynamicObject(2754,1367.2998000,-1291.5000000,13.4000000,0.0000000,0.0000000,0.0000000); //object(otb_machine) (3)
	CreateDynamicObject(2754,1074.5000000,-1328.0996100,13.5000000,0.0000000,0.0000000,0.0000000); //object(otb_machine) (4)
	CreateDynamicObject(2754,559.5999800,-1293.9000200,17.2000000,0.0000000,0.0000000,270.0000000); //object(otb_machine) (5)
	CreateDynamicObject(2754,2116.6999500,-1126.9000200,25.2000000,0.0000000,0.0000000,179.9950000); //object(otb_machine) (6)
	for(new i = 0; i < sizeof(ATMPosition); i++)//ATMLOAD
	{
		ATMCheckpoint[i] = CreateDynamicCP(ATMPosition[i][0], ATMPosition[i][1], ATMPosition[i][2],	1.5, 0, 0, -1, 10.0);//ATM
		CreateDynamicMapIcon(ATMPosition[i][0], ATMPosition[i][1], ATMPosition[i][2], 52, -1, -1, -1, -1, 60.0);
	}

	//Grotti
	CreateDynamicObject(3749,2574.8000500,-2371.3999000,18.9000000,0.0000000,0.0000000,45.0000000); //object(clubgate01_lax) (3)
	CreateDynamicObject(3934,2803.5000000,-2558.3999000,12.6300000,0.0000000,0.0000000,0.0000000); //object(helipad01) (1)
	CreateDynamicObject(3934,2788.3000500,-2558.3999000,12.6300000,0.0000000,0.0000000,0.0000000); //object(helipad01) (2)
	CreateDynamicObject(3934,2770.8000500,-2558.3999000,12.6300000,0.0000000,0.0000000,0.0000000); //object(helipad01) (3)
	CreateDynamicObject(3934,2803.5000000,-2528.3994100,12.6300000,0.0000000,0.0000000,90.0000000); //object(helipad01) (5)
	CreateDynamicObject(3934,2788.2998000,-2528.3994100,12.6300000,0.0000000,0.0000000,90.0000000); //object(helipad01) (6)
	CreateDynamicObject(3934,2770.7998000,-2528.3994100,12.6300000,0.0000000,0.0000000,90.0000000); //object(helipad01) (7)
	CreateDynamicObject(3475,2690.6001000,-2562.8000500,15.0000000,0.0000000,0.0000000,180.0000000); //object(vgsn_fncelec_pst) (6)
	CreateDynamicObject(3475,2690.6001000,-2556.8999000,15.0000000,0.0000000,0.0000000,179.9950000); //object(vgsn_fncelec_pst) (7)
	CreateDynamicObject(3475,2690.6001000,-2551.0000000,15.0000000,0.0000000,0.0000000,179.9950000); //object(vgsn_fncelec_pst) (8)
	CreateDynamicObject(3475,2690.6001000,-2545.1001000,15.0000000,0.0000000,0.0000000,179.9950000); //object(vgsn_fncelec_pst) (9)
	CreateDynamicObject(3749,2658.6001000,-2504.1001000,18.4000000,0.0000000,0.0000000,90.0000000); //object(clubgate01_lax) (1)
	CreateDynamicObject(3475,2585.0000000,-2395.6992200,14.9000000,0.0000000,0.0000000,44.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2589.1999500,-2399.8999000,14.9000000,0.0000000,0.0000000,44.9950000); //object(vgsn_fncelec_pst) (11)
	CreateDynamicObject(3475,2593.3999000,-2404.1001000,14.9000000,0.0000000,0.0000000,44.9950000); //object(vgsn_fncelec_pst) (12)
	CreateDynamicObject(3475,2597.5000000,-2408.1999500,14.9000000,0.0000000,0.0000000,44.9950000); //object(vgsn_fncelec_pst) (13)
	CreateDynamicObject(3475,2601.6999500,-2412.3999000,14.9000000,0.0000000,0.0000000,44.9950000); //object(vgsn_fncelec_pst) (14)
	CreateDynamicObject(3475,2605.8999000,-2416.6001000,14.9000000,0.0000000,0.0000000,44.9950000); //object(vgsn_fncelec_pst) (15)
	CreateDynamicObject(3475,2610.0000000,-2420.6999500,14.9000000,0.0000000,0.0000000,44.9950000); //object(vgsn_fncelec_pst) (16)
	CreateDynamicObject(3475,2622.3000500,-2456.0000000,14.9000000,0.0000000,0.0000000,180.0000000); //object(vgsn_fncelec_pst) (17)
	CreateDynamicObject(3475,2622.3000500,-2450.1001000,14.9000000,0.0000000,0.0000000,179.9950000); //object(vgsn_fncelec_pst) (18)
	CreateDynamicObject(3475,2622.2998000,-2444.1992200,14.9000000,0.0000000,0.0000000,179.9950000); //object(vgsn_fncelec_pst) (19)
	CreateDynamicObject(3753,2780.6999500,-2323.3000500,3.3000000,0.0000000,0.0000000,1.5000000); //object(dockwall_las2) (1)
	CreateDynamicObject(3475,2596.3999000,-2376.1001000,14.9000000,0.0000000,0.0000000,180.0000000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2596.3999000,-2370.1001000,14.9000000,0.0000000,0.0000000,179.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2596.3999000,-2364.1001000,14.9000000,0.0000000,0.0000000,179.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2596.3999000,-2358.1001000,14.9000000,0.0000000,0.0000000,179.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2596.3999000,-2352.1001000,14.9000000,0.0000000,0.0000000,179.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2596.3999000,-2346.1001000,14.9000000,0.0000000,0.0000000,179.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2596.3999000,-2340.1001000,14.9000000,0.0000000,0.0000000,179.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2596.3999000,-2334.1001000,14.9000000,0.0000000,0.0000000,179.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2599.6001000,-2331.0000000,14.9000000,0.0000000,0.0000000,89.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2605.6001000,-2331.0000000,14.9000000,0.0000000,0.0000000,89.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2611.6001000,-2331.0000000,14.9000000,0.0000000,0.0000000,89.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2617.6001000,-2331.0000000,14.9000000,0.0000000,0.0000000,89.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2623.6001000,-2331.0000000,14.9000000,0.0000000,0.0000000,89.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2629.6001000,-2331.0000000,14.9000000,0.0000000,0.0000000,89.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2635.6001000,-2331.0000000,14.9000000,0.0000000,0.0000000,89.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2641.6001000,-2331.0000000,14.9000000,0.0000000,0.0000000,89.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2647.6001000,-2331.0000000,14.9000000,0.0000000,0.0000000,89.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2653.6001000,-2331.0000000,14.9000000,0.0000000,0.0000000,89.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2659.6001000,-2331.0000000,14.9000000,0.0000000,0.0000000,89.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2665.6001000,-2331.0000000,14.9000000,0.0000000,0.0000000,89.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2671.6001000,-2331.0000000,14.9000000,0.0000000,0.0000000,89.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2677.6001000,-2331.0000000,14.9000000,0.0000000,0.0000000,89.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2683.5000000,-2331.0000000,14.9000000,0.0000000,0.0000000,89.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2689.5000000,-2331.0000000,14.9000000,0.0000000,0.0000000,89.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2695.5000000,-2331.0000000,14.9000000,0.0000000,0.0000000,89.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2701.5000000,-2331.0000000,14.9000000,0.0000000,0.0000000,89.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2707.5000000,-2331.0000000,14.9000000,0.0000000,0.0000000,89.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2713.5000000,-2331.0000000,14.9000000,0.0000000,0.0000000,89.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2719.5000000,-2331.0000000,14.9000000,0.0000000,0.0000000,89.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2725.5000000,-2331.0000000,14.9000000,0.0000000,0.0000000,89.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2731.5000000,-2331.0000000,14.9000000,0.0000000,0.0000000,89.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2737.5000000,-2331.0000000,14.9000000,0.0000000,0.0000000,89.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2743.5000000,-2331.0000000,14.9000000,0.0000000,0.0000000,89.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2749.5000000,-2331.0000000,14.9000000,0.0000000,0.0000000,89.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2598.5000000,-2381.3000500,14.9000000,0.0000000,0.0000000,225.0000000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2602.6999500,-2385.5000000,14.9000000,0.0000000,0.0000000,225.0000000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2606.8999000,-2389.6999500,14.9000000,0.0000000,0.0000000,225.0000000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2611.6999500,-2393.1001000,14.9000000,0.0000000,0.0000000,245.0000000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2617.3000500,-2394.6999500,14.9000000,0.0000000,0.0000000,264.9950000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2623.3000500,-2395.0000000,14.9000000,0.0000000,0.0000000,270.0000000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2629.3000500,-2395.0000000,14.9000000,0.0000000,0.0000000,270.0000000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2635.3000500,-2395.0000000,14.9000000,0.0000000,0.0000000,270.0000000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2641.3000500,-2395.0000000,14.9000000,0.0000000,0.0000000,270.0000000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2647.3000500,-2395.0000000,14.9000000,0.0000000,0.0000000,270.0000000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2653.3000500,-2395.0000000,14.9000000,0.0000000,0.0000000,270.0000000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2659.1001000,-2395.0000000,14.9000000,0.0000000,0.0000000,270.0000000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2664.8999000,-2395.0000000,14.9000000,0.0000000,0.0000000,270.0000000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2670.6999500,-2395.0000000,14.9000000,0.0000000,0.0000000,270.0000000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2676.5000000,-2395.0000000,14.9000000,0.0000000,0.0000000,270.0000000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2682.3000500,-2395.0000000,14.9000000,0.0000000,0.0000000,270.0000000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2688.1001000,-2395.0000000,14.9000000,0.0000000,0.0000000,270.0000000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2693.8999000,-2395.0000000,14.9000000,0.0000000,0.0000000,270.0000000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2699.6999500,-2395.0000000,14.9000000,0.0000000,0.0000000,270.0000000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2705.5000000,-2395.0000000,14.9000000,0.0000000,0.0000000,270.0000000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2711.3000500,-2395.0000000,14.9000000,0.0000000,0.0000000,270.0000000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2717.0800800,-2395.0000000,14.9000000,0.0000000,0.0000000,270.0000000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2720.3000500,-2392.0000000,14.9000000,0.0000000,0.0000000,0.0000000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3475,2720.3000500,-2386.1999500,14.9000000,0.0000000,0.0000000,0.0000000); //object(vgsn_fncelec_pst) (10)
	CreateDynamicObject(3664,545.5000000,-1259.8000500,8.3000000,0.0000000,0.0000000,123.0000000); //object(lasblastde_las) (1)
	CreateDynamicObject(3664,541.0999800,-1262.8000500,8.3000000,0.0000000,0.0000000,122.9970000); //object(lasblastde_las) (2)
	CreateDynamicObject(3664,537.0999800,-1265.5999800,8.3000000,0.0000000,0.0000000,122.9970000); //object(lasblastde_las) (3)
	CreateDynamicObject(3664,532.2999900,-1269.9000200,8.3000000,0.0000000,0.0000000,128.9970000); //object(lasblastde_las) (4)
	CreateDynamicObject(3664,527.9000200,-1273.3000500,8.3000000,0.0000000,0.0000000,128.9960000); //object(lasblastde_las) (5)
	CreateDynamicObject(3664,523.5000000,-1276.6999500,8.3000000,0.0000000,0.0000000,128.9960000); //object(lasblastde_las) (6)
	CreateDynamicObject(3664,519.0999800,-1280.5000000,8.3000000,0.0000000,0.0000000,128.9960000); //object(lasblastde_las) (7)
	CreateDynamicObject(3664,515.0000000,-1283.8000500,8.3000000,0.0000000,0.0000000,128.9960000); //object(lasblastde_las) (8)
}

stock IsVehicleOccupied(vehicleid)
{
	foreach(new i : Player)
	{
		if(!PlayerInfo[i][playerLogged]) continue;
		if(GetPlayerVehicleID(i) == vehicleid) return 1;
	}
	return 0;
}

stock CAR_CreateVehicle(vvvmodelid, Float:vvvX, Float:vvvY, Float:vvvZ, Float:vvvA, vvvcolor1 = 0, vvvcolor2 = 0, vvvrespawn_delay = -1)
{
	new vid = CreateVehicle(vvvmodelid, vvvX, vvvY, vvvZ, vvvA, vvvcolor1, vvvcolor2, vvvrespawn_delay);
	VehicleInfo[vid][vX] = vvvX;
	VehicleInfo[vid][vY] = vvvY;
	VehicleInfo[vid][vZ] = vvvZ;
	VehicleInfo[vid][vA] = vvvA;
	VehicleInfo[vid][vColor1] = vvvcolor1;
	VehicleInfo[vid][vColor2] = vvvcolor2;
	return vid;
}

stock GetVehicleColor(vehicleid, &c1, &c2)
{
	c1 = VehicleInfo[vehicleid][vColor1];
	c2 = VehicleInfo[vehicleid][vColor2];
}

forward UnJailPlayer(playerid);
public UnJailPlayer(playerid)
{
	KillTimer(TimeCounter__[playerid]);
	KillTimer(RobberyTimer__[playerid]);
	KillTimer(UnJailTimer__[playerid]);
	SendClientMessage(playerid, COLOR_GREEN, "Adesso sei libero. La prossima volta comportati bene!");
	SetPlayerSpawn(playerid);
	return 1;
}

stock JailTimeByWantedLevel(playerid)
{
	new v;
	if(GetPlayerWantedLevelEx(playerid) >= 3 && GetPlayerWantedLevelEx(playerid) < 7)
	{
		v = 30;
	}
	else if(GetPlayerWantedLevelEx(playerid) >= 7 && GetPlayerWantedLevelEx(playerid) < 12)
	{
		v = 45; //1 minuto
	}
	else if(GetPlayerWantedLevelEx(playerid) >= 12 && GetPlayerWantedLevelEx(playerid) < 20)
	{
		v = 60; //3 minuti
	}
	else if(GetPlayerWantedLevelEx(playerid) >= 20 && GetPlayerWantedLevelEx(playerid) < 40)
	{
		v = 60*2; //5 minuti
	}
	else if(GetPlayerWantedLevelEx(playerid) >= 40)
	{
		v = 60*3; //10 minuti
	}
	return v;
}

stock KickPlayer(playerid)return SetTimerEx("KickorBan", 100, false, "ii", playerid, 0);
stock BanPlayer(playerid)return SetTimerEx("KickorBan", 100, false, "ii", playerid, 1);

stock GetVehicleDriverID(vehicleid)
{
	if(vehicleid < 1 || vehicleid > MAX_VEHICLES)
		return INVALID_PLAYER_ID;
	if(VehicleDriverID[vehicleid] != INVALID_PLAYER_ID && IsPlayerInVehicle(VehicleDriverID[vehicleid], vehicleid) && GetPlayerVehicleSeat(VehicleDriverID[vehicleid]) == 0)
		return VehicleDriverID[vehicleid];
	return INVALID_PLAYER_ID;
}

stock ConvertPrice( iValue, iCashSign = 1 ) //thanks to RyDeR' and Lorenc_
{
	static szNum[32];
	format(szNum, sizeof(szNum), "%d", iValue < 0 ? -iValue : iValue );
	for( new i = strlen( szNum ) - 3; i > 0; i -= 3 )
	{
		strins( szNum, ".", i, sizeof(szNum));
	}
	if(iCashSign) strins(szNum, "$", 0);
	if(iValue < 0) strins(szNum, "-", 0, sizeof( szNum ) );
	return szNum;
}

stock uDate(time, &e, &h, &n, &o, &p, &mp, hGMT = 0, mGMT = 0)
{
	new
	temp = time,
	Months[12] = {2678400, 2419200, 2678400, 2592000, 2678400, 2592000, 2678400, 2678400, 2592000, 2678400, 2592000, 2678400}
	;

	e = 0, h = 0, n = 0, o = 0, p = 0, mp = 0;

	time += ((((-12 <= hGMT <= 14) && (0 <= mGMT < 60))) ? ((hGMT * 60 * 60) + (mGMT * 60)) : 0);

	new
	year,
	month
	;

	while((time -= year) >= (year = (!(e % 4) ? 31622400 : 31536000)))
		e++;

	while((time -= month) >= (month = ((!(e % 4) && (h == 1)) ? 2505600 : Months[h])))
		h++;

	e       +=      1970;
	h       +=      1;
	n       =       (floatround(time / 86400) + 1);         time    -=      ((n - 1) * 86400);
	o       =       floatround(time / 3600);                                time    -=      ((o) * 3600);
	p       =       floatround(time / 60);                          time    -=      (p * 60);
	mp      =       time;

	time = temp;
	return true;
}

stock CheckMySQLTable()
{

	//new thisstring[900];
	//Player
	/*strcat(thisstring, "CREATE TABLE IF NOT EXISTS `Players`", sizeof(thisstring));
	strcat(thisstring, "(`ID` int(11) auto_increment PRIMARY KEY, \
	`Name` varchar(30), `Password` varchar(128), `Money` int(11), `Bank` int(11), \
	`Admin` int(11), `Skills` varchar(20), `JailTime` int(11), `PremiumTime` int(11), \
	`Premium` int(11),`AccountBanned` int(11), `BanTime` int(11), `Rewards` int(11),", sizeof(thisstring));
	strcat(thisstring,"`RewardMoney` int(11), \
	`Drug` int(11), \
	`Kills` int(11), \
	`Deaths` int(11), \
	`Gruppo` int(3), \
	`Tickets` int(11),\
	`RegisterDate` int(13),\
	`LastLogin` int(13),\
	`GainRobberies` int(11),\
	`GainVehicleStolen` int(11),\
	`GainWeaponsDealer` int(11))", sizeof(thisstring));*/


	//HOUSE

	/*mysql_query("CREATE TABLE IF NOT EXISTS `houses` \
	(`ID` int(11) PRIMARY KEY, `OwnerID` int(11), `OwnerName` varchar(26),\
	`Closed` int(1), `X` float, `Y` float, `Z` float,\
	`Xu` float, `Yu` float, `Zu` float, \
	`Interior` int(11),`VirtualWorld` int(11), `Price` int(11))");*/
	//Playervehicle
	/*mysql_query("CREATE TABLE IF NOT EXISTS `playervehicle` (`ID` int(5) auto_increment PRIMARY KEY, `Slot` int(3), `OwnerID` int(11), `OwnerName` varchar(26), `Model` int(4), \
	`X` float, `Y` float, `Z` float, `A` float, `Color1` int(11), `Color2` int(11), `Closed` int(11), `VehicleMod` varchar(256))");*/

	//PayNSpray
	/*strcat(thisstring, "CREATE TABLE IF NOT EXISTS `payspray`", sizeof(thisstring));
	strcat(thisstring, "(`ID` int(3) auto_increment PRIMARY KEY , \
	`OwnerID` int(21), \
	`OwnerName` varchar(24), \
	`X` float, \
	`Y` float, \
	`Z` float, \
	`Price` int(11), \
	`Money` int(11))", sizeof(thisstring));
	mysql_query(thisstring);*/

	//SerialBan
	/*strcat(thisstring, "CREATE TABLE IF NOT EXISTS `serialbans`", sizeof(thisstring));
	strcat(thisstring, "(`SerialID` varchar(128) PRIMARY KEY, \
	`AccountBanned` int(11))", sizeof(thisstring));
	mysql_query(thisstring);*/
	//PlayerStats
	/*strcat(thisstring, "CREATE TABLE IF NOT EXISTS `PlayerStats`", sizeof(thisstring));
	strcat(thisstring, "(`ID` int(11) PRIMARY KEY, \
	`Name` varchar(24), \
	`GainRobberies` int(11), \
	`GainVehicleStolen` int(11), \
	`GainWeaponsDealer` int(11), \
	`GainDrugsDealer` int(11))", sizeof(thisstring));
	mysql_query(thisstring);*/
	//	UPDATE `PlayerStats` SET GainRobberies = '%d', GainVehicleStolen = '%d', GainWeaponsDealer = '%d', GainDrugsDealer = '%d' WHERE `ID` = '%d' AND `Name`
}

/* ==== Work Functions ==== */

//Weapons Dealer:


stock SendMessageToWork(workid, color, text[])
{
	foreach(new i : Player)
	{
		if(!PlayerInfo[i][playerLogged])continue;
		if(PlayerInfo[i][playerTeam] != TEAM_CIVILIAN)continue;
		if(PlayerInfo[i][playerWork] != workid)continue;
		SendClientMessage(i, color, text);
	}
}

stock ShowDealerDialog(playerid)
{
	new string[350] = "Arma\tColpi\tPrezzo\n";
	new wname[32];
	for(new i = 0; i < sizeof(WeaponDealerArray); i++)
	{
		GetWeaponName(WeaponDealerArray[i][ID], wname, sizeof(wname));
		format(string,sizeof(string), ""EMB_WHITE"%s%s\t%d\t"EMB_DOLLARGREEN"%s\n",string, wname, WeaponDealerArray[i][Ammo], ConvertPrice(WeaponDealerArray[i][Price]));
	}
	return ShowPlayerDialog(playerid, DIALOG_WEAPOND_SELL, DIALOG_STYLE_TABLIST_HEADERS, "Armi", string, "Compra", "Annulla");
}

stock GetPlayerRangedHouse(playerid)
{
	for(new i = 0; i < MAX_HOUSES; i++)
	{
		if(!PlayerInfo[playerid][playerLogged])return NO_HOUSE;
		if(!IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[i][hX], HouseInfo[i][hY], HouseInfo[i][hZ]))continue;
		return i;
	}
	return NO_HOUSE;
}

stock GetPlayerHouseID(playerid)
{
	return playerInHouse[playerid];
}

stock GetPlayerBuildingID(playerid)
{
	return playerInBuilding[playerid];
}

forward ResetHouseRobbable(houseid);
public ResetHouseRobbable(houseid)
{
	HouseInfo[houseid][hRobbed] = false;
}

//OTHER

GetXYBehindOfVehicle(vehicleid, &Float:x, &Float:y, Float:distance)
{
	new Float:a;
	GetVehiclePos(vehicleid, x, y, a);
	GetVehicleZAngle(vehicleid, a);
	x -= (distance * floatsin(-a, degrees));
	y -= (distance * floatcos(-a, degrees));
}

stock IsVehicleComponentLegal(vehicleid, componentid) {
	new s_LegalMods[][] = {
		{54273792, 0, 16776704, 7, 0, 0},
		{35268602, 0, 16776704, 7, 245760, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{37431173, 0, 16776704, 7, 0, 0},
		{45893379, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{62531466, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{42862474, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{36767556, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{36177722, 0, 16776704, 7, 0, 0},
		{45958913, 0, 16776704, 7, 0, 0},
		{37365632, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{36177786, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{41560010, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{42084234, 0, 16776704, 7, 245760, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{37619648, 0, 16776704, 7, 0, 0},
		{57685808, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{52242293, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{46024584, 0, 16776704, 7, 245760, 0},
		{33621873, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{43651022, 0, 16776704, 7, 49152, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{54011648, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{37717909, 0, 16776704, 7, 0, 0},
		{43976588, 0, 16776704, 7, 245760, 0},
		{43395050, 0, 16776704, 7, 245760, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{37144450, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{43917258, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, -67107785, 0, 35389440},
		{33556224, 0, 16776704, 67002375, 0, 0},
		{33556224, 0, 16776704, 7047, 1, 31457280},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{60688338, 0, 16776704, 7, 245760, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{37537536, 0, 16776704, 7, 196608, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{59639766, 0, 16776704, 7, 245760, 0},
		{37553929, 0, 16776704, 7, 49152, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{43917194, 0, 16776704, 7, 245760, 0},
		{43779962, 0, 16776704, 7, 245760, 0},
		{45942636, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, -512, 7, 0, 504},
		{33556224, 0, 16777214, 7, -1073741824, 8199},
		{-33552640, 3, 16776704, 7, 15360, 1536},
		{-838859008, -8388608, 16776705, 7, 1006632960, 0},
		{33556224, 1020, 16776704, 7, 3932160, 6144},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 8380416, 16776704, 7, 62914560, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 71, 62, 1006632960},
		{33556224, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 7168, 16776704, 15, 0, 245760},
		{33556224, 0, 16776704, 7, 960, -1073741824},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{43386818, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{51849201, 0, 16776704, 7, 196608, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{39200752, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{60688322, 0, 16776704, 7, 245760, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0}
	};

	// These is the only case with componentids > 1191 (saves ~1kb in the array)
	if (vehicleid == 576 && (componentid == 1192 || componentid == 1193))
		return true;

	if (1000 <= componentid <= 1191 && 400 <= vehicleid <= 611) {
		componentid -= 1000;
		vehicleid -= 400;

		return (s_LegalMods[vehicleid][componentid >>> 5] & 1 << (componentid & 31)) || false;
	}

	return false;
}

stock FIXES_valstr(dest[], value, bool:pack = false)//Ty SLice
{
	// format can't handle cellmin properly
	static const cellmin_value[] = !"-2147483648";

	if (value == cellmin)
		pack && strpack(dest, cellmin_value, 12) || strunpack(dest, cellmin_value, 12);
	else
		format(dest, 12, "%d", value) && pack && strpack(dest, dest, 12);
}
#define valstr FIX_valstr

stock GetPlayerSpeed(playerid)
{
	new Float:ST[4];
	GetPlayerVelocity(playerid,ST[0],ST[1],ST[2]);
	ST[3] = floatsqroot(floatpower(floatabs(ST[0]), 2.0) + floatpower(floatabs(ST[1]), 2.0) + floatpower(floatabs(ST[2]), 2.0)) * 179.28625;
	return floatround(ST[3]);
}

stock ShowInfoText(playerid, text[], timer = 0)
{
	KillTimer(InfoTextTimer[playerid]);
	PlayerTextDrawSetString(playerid, InfoText[playerid], text);
	PlayerTextDrawShow(playerid, InfoText[playerid]);
	if(timer != 0)
	{
		InfoTextTimer[playerid] = SetTimerEx("LeaveInfoText", timer, false, "i", playerid);
	}
}

stock ShowInfoText2(playerid, text[], timer = 0)
{
	KillTimer(InfoTextTimer2[playerid]);
	PlayerTextDrawSetString(playerid, InfoText2[playerid], text);
	PlayerTextDrawShow(playerid, InfoText2[playerid]);
	if(timer != 0)
	{
		InfoTextTimer2[playerid] = SetTimerEx("LeaveInfoText", timer, false, "i", playerid);
	}
}

stock IsPlayerUsingVendingMachine(playerid)
{
	new Lib[2][32];
	GetAnimationName(GetPlayerAnimationIndex(playerid), Lib[0], 32, Lib[1], 32);
	//if(!strcmp(Lib[0], "VENDING"))
	if(GetPlayerAnimationIndex(playerid) == 1660)
	{
		printf("Using machine");
		return true;
	}
	printf("Not using machine");
	return false;
}

stock valtobool(value)
{
	if(value > 1)
	{
		return true;
	}
	return false;
}
