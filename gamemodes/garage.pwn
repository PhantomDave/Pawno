/* Ho fatto in modo che i GetPlayerCash siano già adattati
	I Dialog non dovrebbero dare conflitti in teoria
	Da aggiungere nel DB: Una variabile per salvare OwnedGarages
	Creare la tabella per i garage
	ASSICURATI CHE IL pID CHE USO IO QUI SIA LO STESSO CHE USA PEPPE.
*/

#include <a_samp>
					#include <colors> // NOPE NOPE NOPE
					#include <a_mysql>
					#include <zones>
#include sscanf2
#include <streamer>
#include <foreach>
#include <zcmd>

#define MAX_GARAGES 150


#define EMB_GREEN "{32ff36}"
#define EMB_WHITE "{FFFFFF}"

// non te servono
#define GetPlayerCash(%0) GetPlayerMoney(%0)
#define GivePlayerCash(%0,%1) GivePlayerMoney(%0,%1)
#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
#define strcpy(%0,%1,%2) \
	strcat((%0[0] = '\0', %0), %1, %2)

#define HOST "localhost"
#define PSW ""
#define DB "arp"
#define USER "root"

new MySQL;

#define GarageDialog 10232
#define DialogGCreation 10233
#define DialogGCreation2 10234
#define GarageSell 10235

enum pInfo
{
	pID,
	OwnedGarages
};

new PlayerInfo[MAX_PLAYERS][pInfo];

enum aInfo
{
	Premium
};

new AccountInfo[MAX_PLAYERS][aInfo];

enum gInfo
{
	gID,
	Float:gPosX,
	Float:gPosY,
	Float:gPosZ,
	Float:gPosA,
	gIntID,
	Float:gSpawnX,
	Float:gSpawnY,
	Float:gSpawnZ,
	Float:gSpawnA,
	Float:gVehSpawnX,
	Float:gVehSpawnY,
	Float:gVehSpawnZ,
	Float:gVehSpawnA,
	gWorld,
	gType,
	gOwned,
	gLocked,
	Text3D:gLabel,
	gPickup,
	gPrice,
	gSlots,
	gMaxSlots,
	gOwner[24],
	gOwnerID
};

new GarageInfo[MAX_GARAGES][gInfo];

enum gArray
{
	Float:VehX,
	Float:VehY,
	Float:VehZ,
	Float:VehA,
	Type[16],
	IntID,
	Float:FootX,
	Float:FootY,
	Float:FootZ,
	Float:FootA
};

new GarageArray[][gArray] =
{
	 {1431.5432,-545.5558,1001.8763,270.7152, "Piccolo", 10, 1434.4926, -545.4053, 1001.1231, 86.5550},
	 {-203.8044,-347.7874,1149.4297,272.4241, "Piccolo",10, -207.9678,-347.7831,1149.6842,270.2275},
	 {-454.8379,265.8506,1083.5730,0.0025, "Medio(Bug)", 10, -455.1605,263.3434,1083.8279,2.0938},
	 {-2138.0408,208.1793,1070.5095,270.0, "Medio", 10, -2140.6345,208.6718,1070.7640, 270.0}
};

new createdGarage = 1,
	Iterator:Garages<MAX_GARAGES>,
	InGarage[MAX_PLAYERS];

main()
{
	print("\n----------------------------------");
	print(" Blank Gamemode by your name here");
	print("----------------------------------\n");
}

SQLConnect()
{
    mysql_connect(HOST, USER, DB, PSW);
 	if(MySQL) printf("[MYSQL]: Connessione al database %s riuscita!",DB);
    else printf("[MYSQL ERROR]: Connessione al database %s fallita!",DB);
    return 1;			
}

public OnGameModeInit()
{

	SQLConnect();
	SetGameModeText("Garage Script");
	mysql_tquery(MySQL, "SELECT * FROM Garages", "LoadGarages");
	/*mysql_tquery(MySQL,"CREATE TABLE IF NOT EXISTS `Garages`(\
					`gID` int(5) NOT NULL AUTO_INCREMENT,\
					`Type` int(5) NOT NULL,\
					`PosX` float NOT NULL,\
					`PosY` float NOT NULL,\
					`PosZ` float NOT NULL,\
					`PosA` float NOT NULL,\
					`Locked` int(5) NOT NULL,\
					`Price` int(5) NOT NULL,\
					`Owned` int(5) NOT NULL,\
					`OwnerID` int(5) NOT NULL,\
					`OwnerName` varchar(25) NOT NULL,\
					PRIMARY KEY(gID)) ENGINE MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1");*/ // RIferimento su come creare la Table
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	CreateDynamicObject(19378, 1431.54565, -545.54547, 1000.03717,   0.00000, 90.00000, 0.00000,-1,10);
	CreateDynamicObject(19377, 1434.96802, -545.46429, 999.85516,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(19377, 1427.36707, -545.64142, 1000.03131,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(19377, 1431.65723, -542.26874, 1000.01233,   0.00000, 0.00000, 90.00000,-1,10); 
	CreateDynamicObject(19377, 1431.17822, -548.67926, 1000.05011,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(19325, 1434.86646, -545.47498, 1000.33984,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(18762, 1435.33655, -548.26898, 1000.92383,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(18762, 1435.36450, -542.67224, 1000.92108,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(18762, 1435.36047, -545.65369, 1002.92358,   90.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(19834, 1434.83093, -544.32629, 1000.17566,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(19834, 1434.83472, -546.64673, 1000.17572,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(19834, 1434.83472, -546.64673, 1002.38013,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(19834, 1434.83496, -544.32629, 1002.37592,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(19834, 1434.83594, -547.74670, 1001.27588,   0.00000, -90.00000, 90.00000,-1,10);
	CreateDynamicObject(19834, 1434.83704, -543.22626, 1001.27588,   0.00000, -90.00000, 90.00000,-1,10);
	CreateDynamicObject(19981, 1434.87891, -543.93658, 999.73193,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(19981, 1434.86108, -544.71863, 999.72742,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(19981, 1434.86340, -545.49982, 999.75153,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(19981, 1434.87769, -546.28088, 999.75140,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(19981, 1434.85901, -547.04303, 999.75140,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(19981, 1434.86328, -545.92224, 1001.78241,   0.00000, 90.00000, 90.00000,-1,10);
	CreateDynamicObject(19981, 1434.88220, -545.96252, 1001.25208,   0.00000, 90.00000, 90.00000,-1,10);
	CreateDynamicObject(19981, 1434.86304, -545.92206, 1000.72791,   0.00000, 90.00000, 90.00000,-1,10);
	CreateDynamicObject(19981, 1434.87183, -545.88312, 1001.79169,   0.00000, -90.00000, 90.00000,-1,10);
	CreateDynamicObject(19981, 1434.87183, -545.88312, 1001.24921,   0.00000, -90.00000, 90.00000,-1,10);
	CreateDynamicObject(19981, 1434.87183, -545.88312, 1000.72491,   0.00000, -90.00000, 90.00000,-1,10);
	CreateDynamicObject(19981, 1434.86328, -545.82617, 1002.46240,   0.00000, 90.00000, 90.00000,-1,10);
	CreateDynamicObject(19981, 1434.87183, -545.83508, 1002.46240,   0.00000, -90.00000, 90.00000,-1,10);
	CreateDynamicObject(19981, 1434.85254, -543.17078, 999.81189,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(19981, 1434.85425, -547.80090, 999.80792,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(927, 1434.18018, -548.59802, 1000.99860,   180.00000, 180.00000, 180.00000,-1,10);
	CreateDynamicObject(2063, 1429.84033, -548.19971, 1001.02722,   0.00000, 0.00000, 180.00000,-1,10);
	CreateDynamicObject(1744, 1427.31274, -547.92310, 1001.77338,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(1744, 1427.33069, -547.20313, 1001.77301,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(1409, 1429.72021, -543.11188, 1000.23132,   0.00000, 0.00000, 18.00000,-1,10);
	CreateDynamicObject(1409, 1430.75378, -542.85461, 1000.23132,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(1025, 1427.65869, -546.55652, 1000.61548,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(17564, 1427.60864, -544.90900, 1001.48590,   0.00000, 0.00000, -90.00000,-1,10);
	CreateDynamicObject(19858, 1427.44922, -545.45673, 1001.66272,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(2270, 1427.62793, -542.85291, 1002.35840,   0.00000, 90.00000, 0.00000,-1,10);
	CreateDynamicObject(2270, 1428.67834, -542.85748, 1002.35840,   0.00000, 90.00000, 0.00000,-1,10);
	CreateDynamicObject(2270, 1429.72827, -542.86212, 1002.35840,   0.00000, 90.00000, 0.00000,-1,10);
	CreateDynamicObject(2270, 1427.95850, -542.85107, 1002.35840,   0.00000, 90.00000, 90.00000,-1,10);
	CreateDynamicObject(18880, 1431.49524, -544.32507, 1003.13800,   90.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(18880, 1431.49512, -546.50098, 1003.13397,   90.00000, 0.00000, 180.00000,-1,10);
	CreateDynamicObject(19375, 1431.54565, -545.54547, 1003.47791,   0.00000, 90.00000, 0.00000,-1,10);
	CreateDynamicObject(19981, 1433.57324, -543.19025, 1002.85895,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(19981, 1434.49365, -543.18170, 1002.86407,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(19981, 1433.58545, -547.80878, 1002.87097,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(19981, 1434.50586, -547.80634, 1002.86688,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(19981, 1434.75671, -543.18622, 1002.60480,   180.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(19981, 1434.79614, -547.81409, 1002.60480,   180.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(1025, 1427.98462, -547.07080, 1000.61548,   0.00000, 0.00000, 0.00000,-1,10); //


	CreateDynamicObject(19459, -464.20911, 267.44577, 1084.57080,   0.00000, 0.00000, 0.00000,-1,10); // Leonardo MAp // SOSRITUIRE CON AGGIORNATO
	CreateDynamicObject(19459, -459.47711, 262.71411, 1084.57080,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(19459, -463.78134, 267.79099, 1084.57080,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(19459, -464.20911, 277.08401, 1084.57080,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(19459, -449.85309, 262.71411, 1084.57080,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(19378, -458.89319, 267.59869, 1082.74194,   0.00000, 90.00000, 0.00000,-1,10);
	CreateDynamicObject(19378, -448.42700, 267.59781, 1082.74194,   0.00000, 90.00000, 0.00000,-1,10);
	CreateDynamicObject(19459, -448.53024, 267.53073, 1084.57080,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(19459, -448.53021, 277.17300, 1084.57080,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(19459, -454.81622, 274.60574, 1084.57080,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(19459, -464.42419, 274.60220, 1084.57080,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(19378, -458.95850, 277.21921, 1082.74194,   0.00000, 90.00000, 0.00000,-1,10);
	CreateDynamicObject(19378, -448.46149, 277.21420, 1082.74194,   0.00000, 90.00000, 0.00000,-1,10);
	CreateDynamicObject(19863, -454.94189, 262.82840, 1085.33264,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(19816, -448.80069, 270.63708, 1084.14502,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(19816, -449.04477, 270.73877, 1083.96497,   0.00000, 90.00000, 45.00000,-1,10);
	CreateDynamicObject(19899, -461.81339, 268.34659, 1082.83069,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(19903, -459.79532, 268.21918, 1082.80908,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(2911, -464.11191, 270.17361, 1082.84009,   0.00000, 0.00000, -90.00000,-1,10);
	CreateDynamicObject(19900, -463.62845, 268.41043, 1082.82935,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(19900, -463.62839, 268.41040, 1083.68933,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(19459, -457.44431, 278.82791, 1084.57080,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(11730, -456.99460, 274.26041, 1082.80286,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(11729, -456.33459, 274.26041, 1082.80286,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(11727, -458.26419, 262.82040, 1084.81934,   0.00000, 0.00000, 180.00000,-1,10);
	CreateDynamicObject(11711, -464.14679, 269.67801, 1085.15613,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(19627, -461.83951, 268.47940, 1084.10352,   0.00000, 0.00000, 50.00000,-1,10);
	CreateDynamicObject(19627, -461.98480, 268.59302, 1084.10352,   0.00000, 0.00000, -50.00000,-1,10);
	CreateDynamicObject(19621, -462.13013, 268.26749, 1084.18335,   0.00000, 0.00000, 132.89159);
	CreateDynamicObject(19613, -462.63190, 268.40680, 1084.08362,   0.00000, 0.00000, 180.00000,-1,10);
	CreateDynamicObject(19627, -461.81528, 268.69940, 1084.10352,   0.00000, 0.00000, 182.94086);
	CreateDynamicObject(18635, -460.88339, 268.42633, 1084.06409,   90.00000, 90.00000, -55.00000,-1,10);
	CreateDynamicObject(18634, -461.27170, 268.22220, 1084.10413,   0.00000, 90.00000, 319.48651);
	CreateDynamicObject(18633, -461.36179, 268.47861, 1084.46411,   0.00000, 90.00000, 180.00000,-1,10);
	CreateDynamicObject(18644, -461.11227, 268.54532, 1084.46533,   0.00000, 90.00000, 59.86210,-1,10);
	CreateDynamicObject(19615, -448.96631, 268.82791, 1083.88354,   0.00000, 0.00000, -90.00000,-1,10);
	CreateDynamicObject(18765, -465.58047, 275.44376, 1080.81885,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(18765, -456.09171, 276.24420, 1079.99658,   0.00000, 10.00000, 0.00000,-1,10);
	CreateDynamicObject(11729, -463.86719, 271.93051, 1083.30286,   0.00000, 0.00000, 89.00000,-1,10);
	CreateDynamicObject(11729, -463.86719, 271.05719, 1083.30286,   0.00000, 0.00000, 89.00000,-1,10);
	CreateDynamicObject(4100, -467.22421, 270.51721, 1083.16919,   0.00000, 0.00000, 320.17950,-1,10);
	CreateDynamicObject(19429, -448.55731, 270.24649, 1083.79883,   0.00000, 90.00000, 90.00000,-1,10);
	CreateDynamicObject(19429, -448.53799, 271.90900, 1082.13000,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(19429, -448.55319, 268.58609, 1082.13000,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(19815, -448.59940, 270.31409, 1084.66321,   0.00000, 0.00000, -90.00000,-1,10);
	CreateDynamicObject(19429, -449.30487, 271.19119, 1082.13000,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(336, -449.12100, 271.51096, 1083.96655,   0.00000, 90.00000, -50.00000,-1,10);
	CreateDynamicObject(19429, -448.53455, 270.28394, 1085.47876,   0.00000, 90.00000, 90.00000,-1,10);
	CreateDynamicObject(938, -449.15359, 270.21588, 1085.24768,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(2479, -448.97650, 269.34241, 1082.96863,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(2479, -448.99649, 269.34241, 1083.22864,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(1010, -448.95691, 269.35999, 1083.84668,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(19900, -460.24219, 270.87781, 1082.82202,   0.00000, 0.00000, -90.00000,-1,10);
	CreateDynamicObject(19614, -460.24329, 270.87659, 1083.68359,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(1220, -463.67798, 274.14636, 1083.64978,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(1497, -463.54471, 272.28491, 1083.31653,   -13.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(4227, -453.45309, 274.60999, 1085.24890,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(3034, -448.62628, 265.64322, 1084.54810,   0.00000, 0.00000, -90.00000,-1,10);
	CreateDynamicObject(2163, -455.49643, 274.49841, 1082.82910,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(2163, -453.73120, 274.49841, 1082.82910,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(19459, -452.51389, 274.57571, 1084.57080,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(19815, -454.21530, 274.43259, 1084.66321,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(1716, -454.10706, 273.58716, 1082.80872,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(19900, -452.08130, 274.35733, 1082.82202,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(19900, -452.08130, 274.35730, 1083.68201,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(11729, -451.39297, 274.27090, 1082.80286,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(11729, -450.63150, 274.27090, 1082.80286,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(19459, -459.04373, 263.05823, 1084.57080,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(3034, -458.95050, 265.36652, 1084.54810,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(19878, -459.00000, 7210.00000, 3277.00000,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(2228, -463.00000, 4079.00000, 265.00000,   90.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(19828, -452.04599, 262.84451, 1084.21729,   0.00000, 0.00000, 180.00000,-1,10);
	CreateDynamicObject(19829, -452.04599, 262.84451, 1084.33728,   0.00000, 0.00000, 180.00000,-1,10);
	CreateDynamicObject(1810, -449.64389, 273.85956, 1082.82813,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(1810, -448.91907, 273.86929, 1082.82813,   0.00000, 0.00000, 0.00000,-1,10);

	SetDynamicObjectMaterial(CreateDynamicObject(17951, -2141.02002, 208.65520, 1071.54382,   0.00000, 0.00000, 359.56149,-1,10), 0, 17951, "contachou1_lae2", "alleydoor9b", 0xFFE0E0E0); // Garage Piccolo By Purves
	SetDynamicObjectMaterial(CreateDynamicObject(19451, -2141.03320, 200.74170, 1072.03564,   0.00000, 0.00000, 0.00000,-1,10), 0, 4600, "theatrelan2", "gm_labuld2_b", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateDynamicObject(19451, -2141.03320, 216.57590, 1072.03564,   0.00000, 0.00000, 0.00000,-1,10), 0, 4600, "theatrelan2", "gm_labuld2_b", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateDynamicObject(19451, -2136.18213, 203.94411, 1072.03564,   0.00000, 0.00000, 90.00000,-1,10), 0, 4600, "theatrelan2", "gm_labuld2_b", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateDynamicObject(19451, -2136.18213, 213.22470, 1072.03564,   0.00000, 0.00000, 90.00000,-1,10), 0, 4600, "theatrelan2", "gm_labuld2_b", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateDynamicObject(19451, -2131.32178, 208.40041, 1072.03564,   0.00000, 0.00000, 0.00000,-1,10), 0, 4600, "theatrelan2", "gm_labuld2_b", 0xFFFFFFFF);
	new tmpobjid = CreateDynamicObject(19983, -2140.96118, 205.57420, 1069.76501,   0.00000, 0.00000, 0.00000,-1,10,-1,450.000,450.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 0, 19297, "matlights", "invisible", 0);
	SetDynamicObjectMaterial(tmpobjid, 2, 19297, "matlights", "invisible", 0);
	tmpobjid = CreateDynamicObject(19983, -2140.96118, 211.73520, 1069.76501,   0.00000, 0.00000, 0.00000,-1,10,-1,450.000,450.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 0, 19297, "matlights", "invisible", 0);
	SetDynamicObjectMaterial(tmpobjid, 2, 19297, "matlights", "invisible", 0);
	tmpobjid = CreateDynamicObject(19983, -2140.96118, 205.57420, 1072.43701,   0.00000, 0.00000, 0.00000,-1,10,-1,450.000,450.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 2, 19297, "matlights", "invisible", 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 19297, "matlights", "invisible", 0);
	tmpobjid = CreateDynamicObject(19983, -2140.96118, 211.73520, 1072.43701,   0.00000, 0.00000, 0.00000,-1,10,-1,450.000,450.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 2, 19297, "matlights", "invisible", 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 19297, "matlights", "invisible", 0);
	SetDynamicObjectMaterial(CreateDynamicObject(19377, -2135.99219, 208.6331, 1069.67810,   0.00000, 90.00000, 0.00000,-1,10), 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19983, -2140.96289, 205.53551, 1073.34351,   0.00000, 90.00000, 90.00000,-1,10,-1,450.000,450.000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19297, "matlights", "invisible", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 0, 19297, "matlights", "invisible", 0);
	tmpobjid = CreateDynamicObject(19983, -2140.96289, 208.20650, 1073.34351,   0.00000, 90.00000, 90.00000,-1,10,-1,450.000,450.000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19297, "matlights", "invisible", 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 19297, "matlights", "invisible", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19983, -2140.96289, 210.87849, 1073.34351,   0.00000, 90.00000, 90.00000,-1,10,-1,450.000,450.000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19297, "matlights", "invisible", 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 19297, "matlights", "invisible", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateDynamicObject(19451, -2141.03369, 209.63460, 1075.11694,   0.00000, 0.00000, 0.00000,-1,10), 0, 4600, "theatrelan2", "gm_labuld2_b", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateDynamicObject(19451, -2141.03125, 200.74370, 1069.20618,   0.00000, 0.00000, 0.00000,-1,10), 0, 4600, "theatrelan2", "gm_labuld2_b", 0xFF606060);
	SetDynamicObjectMaterial(CreateDynamicObject(19451, -2136.18213, 203.94611, 1069.20618,   0.00000, 0.00000, 90.00000,-1,10), 0, 4600, "theatrelan2", "gm_labuld2_b", 0xFF606060);
	SetDynamicObjectMaterial(CreateDynamicObject(19451, -2131.32373, 208.40041, 1069.20618,   0.00000, 0.00000, 0.00000,-1,10), 0, 4600, "theatrelan2", "gm_labuld2_b", 0xFF606060);
	SetDynamicObjectMaterial(CreateDynamicObject(19451, -2136.18213, 213.22270, 1069.20618,   0.00000, 0.00000, 90.00000,-1,10), 0, 4600, "theatrelan2", "gm_labuld2_b", 0xFF606060);
	SetDynamicObjectMaterial(CreateDynamicObject(19451, -2141.03125, 216.57390, 1069.20618,   0.00000, 0.00000, 0.00000,-1,10), 0, 4600, "theatrelan2", "gm_labuld2_b", 0xFF606060);
	SetDynamicObjectMaterial(CreateDynamicObject(19451, -2136.18213, 203.94611, 1075.40710,   0.00000, 0.00000, 90.00000,-1,10), 0, 4600, "theatrelan2", "gm_labuld2_b", 0xFF606060);
	SetDynamicObjectMaterial(CreateDynamicObject(19451, -2141.03125, 200.74370, 1075.40710,   0.00000, 0.00000, 0.00000,-1,10), 0, 4600, "theatrelan2", "gm_labuld2_b", 0xFF606060);
	SetDynamicObjectMaterial(CreateDynamicObject(19451, -2141.03125, 216.57390, 1075.40710,   0.00000, 0.00000, 0.00000,-1,10), 0, 4600, "theatrelan2", "gm_labuld2_b", 0xFF606060);
	SetDynamicObjectMaterial(CreateDynamicObject(19451, -2136.18213, 213.22270, 1075.40710,   0.00000, 0.00000, 90.00000,-1,10), 0, 4600, "theatrelan2", "gm_labuld2_b", 0xFF606060);
	SetDynamicObjectMaterial(CreateDynamicObject(19451, -2131.32373, 208.40041, 1075.40710,   0.00000, 0.00000, 0.00000,-1,10), 0, 4600, "theatrelan2", "gm_labuld2_b", 0xFF606060);
	SetDynamicObjectMaterial(CreateDynamicObject(19451, -2141.03320, 208.15970, 1075.40710,   0.00000, 0.00000, 0.00000,-1,10), 0, 4600, "theatrelan2", "gm_labuld2_b", 0xFF606060);
	SetDynamicObjectMaterial(CreateDynamicObject(19377, -2135.99219, 208.63310, 1073.8350,   0.00000, 90.00000, 0.00000,-1,10), 0, 14595, "papaerchaseoffice", "ab_mottleGrey", 0);
	tmpobjid = CreateDynamicObject(18075, -2136.10303, 210.82420, 1073.74377,   0.00000, 0.00000, 0.00000,-1,10,-1,450.000,450.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFF606060);
	SetDynamicObjectMaterial(tmpobjid, 1, 5848, "mainlcawn", "striplight01_128", 0xFFFFFFFF);
	CreateDynamicObject(2141, -2131.91577, 204.54179, 1069.76355,   0.00000, 0.00000, 270.00000,-1,10);
	CreateDynamicObject(2134, -2131.91577, 205.54601, 1069.76379,   0.00000, 0.00000, 270.00000,-1,10);
	CreateDynamicObject(2134, -2131.91577, 206.54500, 1069.76379,   0.00000, 0.00000, 270.00000,-1,10);
	CreateDynamicObject(2133, -2131.92383, 207.55110, 1069.76379,   0.00000, 0.00000, 270.00000,-1,10);
	CreateDynamicObject(18635, -2131.94922, 206.72350, 1070.80664,   90.00000, 0.00000, 54.92595,-1,10);
	CreateDynamicObject(18634, -2131.60425, 205.56650, 1070.82861,   0.00000, 90.00000, 0.00000,-1,10);
	CreateDynamicObject(18644, -2131.84375, 205.40289, 1070.83203,   0.00000, 90.00000, 294.29947,-1,10);
	CreateDynamicObject(19627, -2131.90381, 206.19621, 1070.81616,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(19627, -2131.72461, 206.32851, 1070.81616,   0.00000, 0.00000, 324.16779,-1,10);
	CreateDynamicObject(19621, -2131.77490, 207.25198, 1070.91895,   0.00000, 0.00000, 340.41779,-1,10);
	CreateDynamicObject(1650, -2131.55981, 208.28230, 1070.05579,   0.00000, 0.00000, 180.00000,-1,10);
	CreateDynamicObject(1650, -2131.55981, 208.11729, 1070.05579,   0.00000, 0.00000, 180.00000,-1,10);
	CreateDynamicObject(1343, -2131.90747, 209.61600, 1070.5176,   0.00000, 0.00000, 90.00000,-1,10);
	SetDynamicObjectMaterial(CreateDynamicObject(2063, -2131.66650, 211.60460, 1071.5227,   0.00000, 0.00000, 270.00000,-1,10), 0, 14479, "skuzzy_motelmain", "mp_CJ_Laminate1", 0);
	CreateDynamicObject(1437, -2132.32910, 208.72639, 1068.08936,   0.00000, 0.00000, 270.00000,-1,10);
	SetDynamicObjectMaterial(CreateDynamicObject(2258, -2131.41821, 206.38490, 1071.87134,   0.00000, 0.00000, 270.00000,-1,10), 0, 14530, "estate2", "Auto_windsor", 0);
	SetDynamicObjectMaterial(CreateDynamicObject(2063, -2131.66650, 211.60460, 1069.70654,   0.00000, 0.00000, 270.40607,-1,10), 0, 14479, "skuzzy_motelmain", "mp_CJ_Laminate1", 0);

	//map garage piccolo
	//mura
	SetObjectMaterial(CreateDynamicObject(19463, -198.74510, -347.92160, 1150.43335,   0.00000, 0.00000, 0.00000,-1,10), 0, 16150, "ufo_bar", "offwhitebrix", 0xFFFFFFFF); // Map di Nicola Aka SNR4NK
	SetObjectMaterial(CreateDynamicObject(19377, -203.91000, -347.92581, 1148.59827,   0.00000, 90.00000, 0.00000,-1,10), 0, 10941, "silicon2_sfse", "ws_stationfloor", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(14751, -195.27000, -352.91071, 1146.94556,   0.00000, 0.00000, 0.00000,-1,10), 1, 11388, "newhubgrg1_sfse", "ws_hubbeams1", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(14751, -200.04080, -344.56461, 1151.48547,   0.00000, 0.00000, 0.00000,-1,10), 1, 11388, "newhubgrg1_sfse", "ws_hubbeams1", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(19447, -203.5251, -339.5414, 1149.9647,   0.00000, 90.00000, 0.00000,-1,10), 0, 896, "underwater", "greyrockbig", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(1649, -203.50728, -344.20938, 1150.24512,   0.00000, 0.00000, 0.00000,-1,10), 0, -1, "ufo_bar", "GEwhite1_64", 0xFF9FF5FF);
	SetObjectMaterial(CreateDynamicObject(19411, -203.49390, -344.23529, 1150.60388,   0.00000, 0.00000, 90.00000,-1,10), 0, 16150, "ufo_bar", "offwhitebrix", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(19463, -209.87151, -344.23499, 1150.43335,   0.00000, 0.00000, 90.00000,-1,10), 0, 16150, "ufo_bar", "offwhitebrix", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(19463, -197.04201, -344.23499, 1150.43335,   0.00000, 0.00000, 90.00000,-1,10), 0, 16150, "ufo_bar", "offwhitebrix", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(19463, -201.51346, -344.05615, 1150.43335,   0.00000, 0.00000, 90.00000,-1,10), 0, 18265, "w_town3cs_t", "ws_whitewall2_top", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(19463, -203.64191, -351.68839, 1150.43335,   0.00000, 0.00000, 90.00000,-1,10), 0, 16150, "ufo_bar", "offwhitebrix", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(19463, -208.43199, -348.01758, 1150.43335,   0.00000, 0.00000, 0.00000,-1,10), 0, 16150, "ufo_bar", "offwhitebrix", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(19910, -208.3466, -347.9423, 1149.8900,   0.00000, 0.00000, -90.00000,-1,10), 0, 11315, "sprayshp_sfse", "sf_spraydoor1", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(19377, -203.91000, -347.92581, 1152.25830,   0.00000, 90.00000, 0.00000,-1,10), 0, 18265, "w_town3cs_t", "ws_whitewall2_top", 0xFFFFFFFF);
	//sbarre finestra
	SetObjectMaterial(CreateDynamicObject(19983, -203.49870, -344.19769, 1151.63196,   0.00000, 180.00000, 0.00000,-1,10), 0, 18265, "w_town3cs_t", "ws_whitewall2_top", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(19983, -202.61459, -344.19769, 1151.63196,   0.00000, 180.00000, 0.00000,-1,10), 0, 18265, "w_town3cs_t", "ws_whitewall2_top", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(19983, -204.37750, -344.19769, 1151.63196,   0.00000, 180.00000, 0.00000,-1,10), 0, 18265, "w_town3cs_t", "ws_whitewall2_top", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(19983, -204.58220, -344.19800, 1151.45203,   0.00000, 90.00000, 0.00000,-1,10), 0, 18265, "w_town3cs_t", "ws_whitewall2_top", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(19983, -204.58220, -344.19800, 1150.06995,   0.00000, 90.00000, 0.00000,-1,10), 0, 18265, "w_town3cs_t", "ws_whitewall2_top", 0xFFFFFFFF);
    //battiscopa
	SetObjectMaterial(CreateDynamicObject(19463, -203.5819, -344.289, 1147.1133,   0.00000, 0.00000, 90.00000,-1,10), 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(19463, -198.76511, -347.90161, 1147.11328,   0.00000, 0.00000, 0.00000,-1,10), 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(19463, -203.64191, -351.66840, 1147.11328,   0.00000, 0.00000, 90.00000,-1,10), 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(19463, -208.4091, -341.2490, 1147.1133,   0.00000, 0.00000, 0.00000,-1,10), 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(19463, -208.4091, -354.6383, 1147.1133,   0.00000, 0.00000, 0.00000,-1,10), 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(1278, -205.27110, -344.32471, 1148.68555,   0.00000, 0.00000, 0.00000,-1,10), 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(1278, -201.72400, -344.32471, 1148.68555,   0.00000, 0.00000, 0.00000,-1,10), 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(1278, -203.04781, -344.36069, 1152.12549,   0.00000, 90.00000, 0.00000,-1,10), 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(1278, -202.90100, -351.67380, 1152.14001,   0.00000, 90.00000, 0.00000,-1,10), 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(1278, -198.76750, -345.60889, 1152.15601,   0.00000, 90.00000, 90.00000,-1,10), 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(1278, -208.28889, -345.91391, 1152.15002,   0.00000, 90.00000, 90.00000,-1,10), 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(19387, -209.92599, -345.97900, 1149.33997,   0.00000, 0.00000, 90.00000,-1,10), 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(19387, -209.92599, -349.89841, 1149.33997,   0.00000, 0.00000, 90.00000,-1,10), 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(19387, -210.07100, -348.38300, 1151.1790,   0.00000, 90.00000, 0.00000,-1,10), 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(19387, -210.07111, -347.49500, 1151.1790,   0.00000, 90.00000, 0.00000,-1,10), 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF);
	//altro
 	CreateDynamicObject(14902, -202.35254, -346.02612, 1148.68518,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(19983, -203.49870, -344.19769, 1151.63196,   0.00000, 180.00000, 0.00000,-1,10);
	CreateDynamicObject(19983, -202.61459, -344.19769, 1151.63196,   0.00000, 180.00000, 0.00000,-1,10);
	CreateDynamicObject(19983, -204.37750, -344.19769, 1151.63196,   0.00000, 180.00000, 0.00000,-1,10);
	CreateDynamicObject(19983, -204.58220, -344.19800, 1151.45203,   0.00000, 90.00000, 0.00000,-1,10);
	CreateDynamicObject(19983, -204.58220, -344.19800, 1150.06995,   0.00000, 90.00000, 0.00000,-1,10);
	CreateDynamicObject(19815, -198.81050, -348.39899, 1150.46594,   0.00000, 0.00000, -90.00000,-1,10);
	CreateDynamicObject(1623, -198.85580, -351.05789, 1151.72485,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(11315, -202.60870, -347.72699, 1149.68530,   0.00000, 0.00000, 90.00000,-1,10);
	SetObjectMaterial(CreateDynamicObject(1505, -201.7797, -351.6301, 1148.6801,   0.00000, 0.00000, 0.00000,-1,10), 0, 10932, "station_sfse", "comptdoor4", 0xFFFFFFFF);
	CreateDynamicObject(3498, -202.43556, -344.03433, 1148.68530,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(3498, -204.55540, -344.03430, 1148.68530,   0.00000, 0.00000, 0.00000,-1,10);
	SetObjectMaterial(CreateDynamicObject(19325, -203.62210, -344.19370, 1149.68591,   0.00000, 0.00000, 90.00000,-1,10), 0, -1, "ufo_bar", "GEwhite1_64", 0xFF9FF5FF);
	SetObjectMaterial(CreateDynamicObject(3386, -199.23650, -347.38000, 1146.84570,   0.00000, 0.00000, 180.00000,-1,10), 1, 11391, "hubprops2_sfse", "blackmetal", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(3386, -199.23650, -348.37860, 1146.84570,   0.00000, 0.00000, 180.00000,-1,10), 1, 11391, "hubprops2_sfse", "blackmetal", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(3386, -199.23650, -349.37860, 1146.84570,   0.00000, 0.00000, 180.00000,-1,10), 1, 11391, "hubprops2_sfse", "blackmetal", 0xFFFFFFFF);
	CreateDynamicObject(19922, -199.10870, -348.34930, 1149.13416,   0.00000, 0.00000, 90.00000,-1,10);
	CreateDynamicObject(1437, -199.78065, -350.39020, 1146.75220,   0.00000, 0.00000, -78.24002,-1,10);
	CreateDynamicObject(19903, -199.60330, -351.03094, 1148.68579,   0.00000, 0.00000, -206.34006,-1,10);
	CreateDynamicObject(19899, -199.37740, -345.63461, 1148.68567,   0.00000, 0.00000, -178.07990,-1,10);
	CreateDynamicObject(1431, -207.28174, -350.82629, 1149.22620,   0.00000, 0.00000, -15.18000,-1,10);
	CreateDynamicObject(18645, -199.59004, -345.07886, 1150.41833,   0.00000, -15.00000, -159.47998,-1,10);
	CreateDynamicObject(18645, -199.59917, -344.63708, 1150.41833,   0.00000, -15.00000, -159.47998,-1,10);
	CreateDynamicObject(18635, -199.62260, -345.74219, 1149.91882,   90.00000, 0.00000, 142.92000,-1,10);
	CreateDynamicObject(18633, -199.59401, -346.49945, 1149.96167,   0.00000, 90.00000, -152.52003,-1,10);
	CreateDynamicObject(18634, -199.32310, -346.17999, 1149.95166,   0.00000, 90.00000, 0.00000,-1,10);
	CreateDynamicObject(11706, -205.91896, -351.10648, 1148.68494,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(11738, -199.3054, -346.5450, 1150.8033,   0.00000, 0.00000, 92.40000,-1,10);
	CreateDynamicObject(11738, -199.30540, -345.67609, 1150.80334,   0.00000, 0.00000, 92.40000,-1,10);
	CreateDynamicObject(11743, -199.29160, -349.54535, 1149.92529,   0.00000, 0.00000, -142.86000,-1,10);
	CreateDynamicObject(11745, -199.26280, -347.26749, 1150.06494,   0.00000, 0.00000, 20.88000,-1,10);
	CreateDynamicObject(11730, -205.29480, -351.16293, 1148.68542,   0.00000, 0.00000, -180.00000,-1,10);
	CreateDynamicObject(11730, -204.58099, -351.16290, 1148.68542,   0.00000, 0.00000, -180.00000,-1,10);
	CreateDynamicObject(11730, -203.86720, -351.16290, 1148.68542,   0.00000, 0.00000, -180.00000,-1,10);
	CreateDynamicObject(11730, -203.12970, -351.16290, 1148.68542,   0.00000, 0.00000, -180.00000,-1,10);
	CreateDynamicObject(19621, -199.50571, -347.34052, 1150.02466,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(19814, -202.12511, -351.59671, 1149.05212,   0.00000, 0.00000, -180.00000,-1,10);
	CreateDynamicObject(19814, -201.05760, -344.31830, 1149.05212,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(19814, -206.96027, -344.31503, 1149.05212,   0.00000, 0.00000, 0.00000,-1,10);
	CreateDynamicObject(1084, -200.24095, -344.67108, 1149.12585,   0.00000, -15.00000, 232.02002,-1,10);
	CreateDynamicObject(18635, -199.21867, -349.27856, 1149.91882,   90.00000, 0.00000, 142.92000,-1,10);
	SetObjectMaterial(CreateDynamicObject(19174, -206.87460, -344.32501, 1150.35925,   0.00000, 0.00000, 0.00000,-1,10), 0, 11631, "mp_ranchcut", "CJ_PAINTING20", 0xFFFFFFFF);
	CreateDynamicObject(14826, -206.90874, -342.80435, 1148.88586,   0.00000, 0.00000, -160.20010,-1,10);
	SetObjectMaterial(CreateDynamicObject(19387, -197.36591, -348.27960, 1151.40515,   0.00000, -90.00000, 0.00000,-1,10), 0, 11391, "hubprops2_sfse", "CJ_WOOD1", 0xFFFFFFFF);
	SetObjectMaterial(CreateDynamicObject(19387, -197.36400, -346.09821, 1151.40527,   0.00000, -90.00000, 0.00000,-1,10), 0, 11391, "hubprops2_sfse", "CJ_WOOD1", 0xFFFFFFFF);


	return 1;
}

CreateGarage(type, price, Float:X, Float:Y, Float:Z, Float:A)
{
	GarageInfo[createdGarage][gPosX] = X;
	GarageInfo[createdGarage][gPosY] = Y;
	GarageInfo[createdGarage][gPosZ] = Z;
	GarageInfo[createdGarage][gPosA] = A;
	GarageInfo[createdGarage][gType] = type;
	GarageInfo[createdGarage][gVehSpawnX] = GarageArray[type][VehX];
	GarageInfo[createdGarage][gVehSpawnY] = GarageArray[type][VehY];
	GarageInfo[createdGarage][gVehSpawnZ] = GarageArray[type][VehZ];
	GarageInfo[createdGarage][gVehSpawnA] = GarageArray[type][VehA];
	GarageInfo[createdGarage][gIntID] = GarageArray[type][IntID];
	GarageInfo[createdGarage][gSpawnX] = GarageArray[type][FootX];
	GarageInfo[createdGarage][gSpawnY] = GarageArray[type][FootY];
	GarageInfo[createdGarage][gSpawnZ] = GarageArray[type][FootZ];
	GarageInfo[createdGarage][gSpawnA] = GarageArray[type][FootA];
	GarageInfo[createdGarage][gPrice] = price;
	GarageInfo[createdGarage][gLocked] = 1;
	strcpy(GarageInfo[createdGarage][gOwner], "Nessuno", 32);
	UpdateGarageLabelsAndPickup(createdGarage);
	Iter_Add(Garages, createdGarage);
	new query[156];
	mysql_format(MySQL, query,sizeof(query),"INSERT INTO Garages (PosX,PosY,PosZ,PosA,Type,Price) VALUES ('%f','%f','%f','%f','%d','%d')",X,Y,Z,A,type,price);
	mysql_tquery(MySQL, query);
	createdGarage++;
	return 1;
}

forward LoadGarages();
public LoadGarages()
{
	new count = cache_get_row_count();
	for(new idx; idx < count+1; idx++)
	{
		GarageInfo[createdGarage][gID] = cache_get_row_int(idx, 0);
		GarageInfo[createdGarage][gType] = cache_get_row_int(idx, 1);
		GarageInfo[createdGarage][gPosX] = cache_get_row_float(idx, 2);
		GarageInfo[createdGarage][gPosY] = cache_get_row_float(idx, 3);
		GarageInfo[createdGarage][gPosZ] = cache_get_row_float(idx, 4);
		GarageInfo[createdGarage][gPosA] = cache_get_row_float(idx, 5);
		GarageInfo[createdGarage][gLocked] = cache_get_row_int(idx, 6);
		GarageInfo[createdGarage][gPrice] = cache_get_row_int(idx, 7);
		GarageInfo[createdGarage][gOwned] = cache_get_row_int(idx, 8);
		GarageInfo[createdGarage][gOwnerID] = cache_get_row_int(idx, 9);
		cache_get_row(idx, 10, GarageInfo[createdGarage][gOwner]);
		new type = GarageInfo[createdGarage][gType];
		GarageInfo[createdGarage][gVehSpawnX] = GarageArray[type][VehX];
		GarageInfo[createdGarage][gVehSpawnY] = GarageArray[type][VehY];
		GarageInfo[createdGarage][gVehSpawnZ] = GarageArray[type][VehZ];
		GarageInfo[createdGarage][gVehSpawnA] = GarageArray[type][VehA];
		GarageInfo[createdGarage][gIntID] = GarageArray[type][IntID];
		GarageInfo[createdGarage][gSpawnX] = GarageArray[type][FootX];
		GarageInfo[createdGarage][gSpawnY] = GarageArray[type][FootY];
		GarageInfo[createdGarage][gSpawnZ] = GarageArray[type][FootZ];
		GarageInfo[createdGarage][gSpawnA] = GarageArray[type][FootA];
		UpdateGarageLabelsAndPickup(idx);
		Iter_Add(Garages, createdGarage);
		createdGarage++;
	}
	return 1;
}

UpdateGarageLabelsAndPickup(gid)
{
	DestroyDynamicPickup(GarageInfo[gid][gPickup]);
	DestroyDynamic3DTextLabel(GarageInfo[gid][gLabel]);
	switch(GarageInfo[gid][gOwned])
	{
		case 0:
		{
			new str[170];
			format(str,sizeof(str), ""EMB_GREEN"Questo garage e' in vendita'! digita /compragarage per acquistarlo.\n\nDimensioni: "EMB_WHITE"%s\n"EMB_GREEN"Costo: "EMB_WHITE"%d$",GarageArray[GarageInfo[gid][gType]][Type],GarageInfo[gid][gPrice]);
			GarageInfo[gid][gLabel] = CreateDynamic3DTextLabel(str, 0xFFFFFFFF,  GarageInfo[gid][gPosX], GarageInfo[gid][gPosY], GarageInfo[gid][gPosZ], 10.0);
			GarageInfo[gid][gPickup] = CreateDynamicPickup(19524, 1, GarageInfo[gid][gPosX], GarageInfo[gid][gPosY], GarageInfo[gid][gPosZ]);
			return 1;
		}
		case 1:
		{
			new str[156],zone[MAX_ZONE_NAME];
			Get2DZoneName(GarageInfo[gid][gPosX], GarageInfo[gid][gPosY],zone,MAX_ZONE_NAME);
			format(str,sizeof(str), ""EMB_GREEN"Garage %s (%d)\nDimensioni: "EMB_WHITE"%s\n"EMB_GREEN"Propietario: "EMB_WHITE"%s",zone,gid,GarageArray[GarageInfo[gid][gType]][Type],GarageInfo[gid][gOwner]);
			GarageInfo[gid][gLabel] = CreateDynamic3DTextLabel(str, 0xFFFFFFFF,  GarageInfo[gid][gPosX], GarageInfo[gid][gPosY], GarageInfo[gid][gPosZ], 10.0);
			GarageInfo[gid][gPickup] = CreateDynamicPickup(19522, 1, GarageInfo[gid][gPosX], GarageInfo[gid][gPosY], GarageInfo[gid][gPosZ]);
			return 1;	
		}
	}
	return 1;
}

IsPlayerNearGarage(playerid)
{
	foreach(new gid : Garages)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.0, GarageInfo[gid][gPosX], GarageInfo[gid][gPosY], GarageInfo[gid][gPosZ])) return gid;
		if(IsPlayerInRangeOfPoint(playerid, 2.0,  GarageInfo[gid][gSpawnX], GarageInfo[gid][gSpawnY], GarageInfo[gid][gSpawnZ])) return gid;
	}
	return 0;
}

CMD:entragarage(playerid, params[])
{
	if(!IsPlayerNearGarage(playerid)) return 1;
	new gid = IsPlayerNearGarage(playerid);
	if(GarageInfo[gid][gLocked] == 1) return SendClientMessage(playerid, COLOR_RED, "Garage chiuso");
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new vid = GetPlayerVehicleID(playerid);
		SetVehiclePos(vid, GarageInfo[gid][gVehSpawnX],GarageInfo[gid][gVehSpawnY],GarageInfo[gid][gVehSpawnZ]+0.7);
		SetVehicleZAngle(vid, GarageInfo[gid][gVehSpawnA]);
		LinkVehicleToInterior(vid, GarageInfo[gid][gIntID]);
		SetVehicleVirtualWorld(vid, gid);
		foreach(new i : Player)
		{
			if(!IsPlayerInVehicle(i, vid)) continue;
			SetPlayerInterior(i, GarageInfo[gid][gIntID]);
			SetPlayerVirtualWorld(i, gid);
			InGarage[playerid] = gid;
		}		
		return 1;
	}
	if(!IsPlayerInAnyVehicle(playerid))
	{
		SetPlayerPos(playerid, GarageInfo[gid][gSpawnX],GarageInfo[gid][gSpawnY],GarageInfo[gid][gSpawnZ]);
		SetPlayerInterior(playerid, GarageInfo[gid][gIntID]);
		SetPlayerVirtualWorld(playerid, gid);
		InGarage[playerid] = gid;
		return 1;
	}
	return 1;
}

CMD:amovegarage(playerid, params[])
{
	if(!IsPlayerAdmin(playerid)) return 1;
	new gid;
	if(sscanf(params, "d",gid)) return SendClientMessage(playerid, COLOR_WHITE, "USO: /amovegarage <garage id>");
	if(gid < 1 || gid > createdGarage) return SendClientMessage(playerid, COLOR_RED, "ID invalido");
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_RED, "Devi essere in un veicolo!");
	new vid = GetPlayerVehicleID(playerid), Float:X, Float:Y, Float:Z, Float:A;
	GetVehiclePos(vid, X, Y, Z);
	GetVehicleZAngle(vid, A);
	GarageInfo[gid][gPosX] = X, GarageInfo[gid][gPosY] = Y ,GarageInfo[gid][gPosZ] = Z ,GarageInfo[gid][gPosA] = A;
	SendClientMessage(playerid, COLOR_YELLOW, "Garage spostato");
	UpdateGarageLabelsAndPickup(gid);
	return 1;
}

CMD:aopengarage(playerid, params[])
{
	if(!IsPlayerAdmin(playerid)) return 1;
	new gid;
	if(sscanf(params, "d", gid)) return SendClientMessage(playerid, COLOR_WHITE, "USO: /aopengarage <garage id>");
	if(gid < 1 || gid > createdGarage) return SendClientMessage(playerid, COLOR_RED, "ID invalido");
	if(GarageInfo[gid][gLocked] == 1) GarageInfo[gid][gLocked] = 0, SendClientMessage(playerid, COLOR_YELLOW, "Garage aperto");
	else if(GarageInfo[gid][gLocked] == 0) GarageInfo[gid][gLocked] = 1, SendClientMessage(playerid, COLOR_YELLOW, "Garage chiuso");
	return 1;
}

CMD:agotogarage(playerid, params[])
{
	if(!IsPlayerAdmin(playerid)) return 1; // Aggiungi il check per i mod
	new gid;
	if(sscanf(params, "d",gid)) return SendClientMessage(playerid, COLOR_WHITE, "USO: /agotogarage <garage id>");
	if(gid < 1 || gid > createdGarage) return SendClientMessage(playerid, COLOR_RED, "ID invalido");
	SetPlayerPos(playerid,  GarageInfo[gid][gPosX],GarageInfo[gid][gPosY],GarageInfo[gid][gPosZ]);
	return 1;
}

CMD:asellgarage(playerid, params[])
{
	if(!IsPlayerAdmin(playerid)) return 1;
	new gid;
	if(sscanf(params, "d",gid)) return SendClientMessage(playerid, COLOR_WHITE, "USO: /asellgarage <garage id>");
	if(gid < 1 || gid > createdGarage) return SendClientMessage(playerid, COLOR_RED, "ID invalido");
	GarageInfo[gid][gOwned] = 0;
	GarageInfo[gid][gOwnerID] = 0;
	UpdateGarageLabelsAndPickup(gid);
	SendClientMessage(playerid, COLOR_YELLOW, "Garage venduto");
	return 1;
}

CMD:escigarage(playerid, params[])
{
	if(InGarage[playerid] != 0)
	{
		new gid = InGarage[playerid];
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			new vid = GetPlayerVehicleID(playerid);
			SetVehiclePos(vid, GarageInfo[gid][gPosX],GarageInfo[gid][gPosY],GarageInfo[gid][gPosZ]);
			LinkVehicleToInterior(vid, 0);
			SetVehicleVirtualWorld(vid, 0);
			SetVehicleZAngle(vid, GarageInfo[gid][gPosA]);
			foreach(new i : Player)
			{
				if(!IsPlayerInVehicle(i, vid)) continue;
				SetPlayerInterior(i, 0);
				SetPlayerVirtualWorld(i, 0);
			}
			return 1;
		}
		if(!IsPlayerInAnyVehicle(playerid))
		{
			SetPlayerPos(playerid, GarageInfo[gid][gPosX],GarageInfo[gid][gPosY],GarageInfo[gid][gPosZ]);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);	
			return 1;		
		}
	}
	return 1;
}

CMD:creategarage(playerid,params[])
{
	if(!IsPlayerAdmin(playerid)) return 1;
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_RED, "Devi essere in un veicolo per utilizzare questo comando.");
	if(createdGarage >= MAX_GARAGES) return SendClientMessage(playerid, COLOR_RED, "Limite raggiunto, contatta i developer!");
	new str[156];
	for(new i = 0; i < sizeof(GarageArray); i++)
	{
		format(str,sizeof(str), "%s\n%s",str,GarageArray[i][Type]);
	}
	ShowPlayerDialog(playerid, DialogGCreation, DIALOG_STYLE_LIST, "Creazione Garage", str, "Crea", "Annulla");
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DialogGCreation:
		{
			if(!response) return 1;
			SetPVarInt(playerid, "Listitem", listitem);
			ShowPlayerDialog(playerid, DialogGCreation2, DIALOG_STYLE_INPUT, "Prezzo Garage", "Inserisci il prezzo del garage qua", "Conferma", "Annulla");
			return 1;
		}
		case DialogGCreation2:
		{
			if(!response) return 1;
			if(!IsNumeric(inputtext)) return ShowPlayerDialog(playerid, DialogGCreation2, DIALOG_STYLE_INPUT, "Prezzo Garage", "Inserisci il prezzo del garage qua\nSOLO NUMERI!", "Conferma", "Annulla");
			if(strval(inputtext) < 0) return ShowPlayerDialog(playerid, DialogGCreation2, DIALOG_STYLE_INPUT, "Prezzo Garage", "Inserisci il prezzo del garage qua\nSOLO NUMERI SUPERIORI A 0!", "Conferma", "Annulla");
			listitem = GetPVarInt(playerid, "Listitem");
			DeletePVar(playerid, "Listitem");
			new Float:X,Float:Y,Float:Z,Float:A, vid = GetPlayerVehicleID(playerid);
			GetVehiclePos(vid, X,Y,Z);
			GetVehicleZAngle(vid, A);
			SendClientMessage(playerid, COLOR_YELLOW, "Garage creato.");	
			CreateGarage(listitem, strval(inputtext), X,Y,Z,A);
			return 1;
		}
		case GarageDialog:
		{
			if(!response) return 1;
			new gid = IsPlayerNearGarage(playerid);
			switch(listitem)
			{

				case 0:
				{
					switch(GarageInfo[gid][gLocked])
					{
						case 0:
						{
							GarageInfo[gid][gLocked] = 1;
							SendClientMessage(playerid, COLOR_RED, "Garage chiuso");
							return 1;
						}
						case 1:
						{
							GarageInfo[gid][gLocked] = 0;
							SendClientMessage(playerid, COLOR_GREEN, "Garage aperto");
							return 1;
						}
					}
					return 1;
				}
				case 1:
				{
					new str[126],cost;
					switch(AccountInfo[playerid][Premium])
					{
						case 0: cost = GarageInfo[gid][gPrice]*60/100;
						case 1: cost = GarageInfo[gid][gPrice]*75/100;
						case 2: cost = GarageInfo[gid][gPrice]*85/100;
						case 3: cost = GarageInfo[gid][gPrice]*95/100;
					}
					format(str,sizeof(str), ""EMB_WHITE"Sicuro di voler vendere questo garage per %d$?",cost);
					ShowPlayerDialog(playerid, GarageSell, DIALOG_STYLE_MSGBOX, "Vendi Garage", str, "Accetta", "Annulla");
					return 1;
				}
			}
			return 1;
		}
		case GarageSell:
		{
			if(!response) return 1;
			new gid = IsPlayerNearGarage(playerid);
			GarageInfo[gid][gOwned] = 0;
			GarageInfo[gid][gOwnerID] = 0;
			strcpy(GarageInfo[gid][gOwner], "Nessuno", 32);
			new cost;
			switch(AccountInfo[playerid][Premium])
			{
				case 0: cost = GarageInfo[gid][gPrice]*60/100;
				case 1: cost = GarageInfo[gid][gPrice]*75/100;
				case 2: cost = GarageInfo[gid][gPrice]*85/100;
				case 3: cost = GarageInfo[gid][gPrice]*95/100;
			}
			GivePlayerCash(playerid, cost);
			new str[50];
			format(str,sizeof(str), "Hai venduto questo garage per %d$",cost);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, str);
			PlayerInfo[playerid][OwnedGarages]--;
			SaveGarage(gid);
			UpdateGarageLabelsAndPickup(gid);
			return 1;			
		}
	}
	return 1;
}

SaveGarage(gid)
{
	new query[250];
	format(query, sizeof(query), "UPDATE Garages SET \
								 Type = '%d',\
								 PosX = '%f',\
								 PosY = '%f',\
								 PosZ = '%f',\
								 PosA = '%f',\
								 Locked = '%d',\
								 Price = '%d',\
								 Owned = '%d',\
								 OwnerID = '%d',\
								 OwnerName = '%s' WHERE gID = '%d'",
								 GarageInfo[gid][gType],
								 GarageInfo[gid][gPosX],
								 GarageInfo[gid][gPosY],
								 GarageInfo[gid][gPosZ],
								 GarageInfo[gid][gPosA],
								 GarageInfo[gid][gLocked],
								 GarageInfo[gid][gPrice],
								 GarageInfo[gid][gOwned],
								 GarageInfo[gid][gOwnerID],
								 GarageInfo[gid][gOwner], GarageInfo[gid][gID]);
	mysql_tquery(MySQL, query);	
	print(query);
	return 1;
}

CMD:compragarage(playerid, params[])
{
	if(!IsPlayerNearGarage(playerid)) return 1;
	new gid = IsPlayerNearGarage(playerid);
	if(GarageInfo[gid][gOwned] != 0) return 1;
	switch(AccountInfo[playerid][Premium])
	{
		case 0..1: if(PlayerInfo[playerid][OwnedGarages] >= 1) return SendClientMessage(playerid, COLOR_RED, "Come utente base non premium puoi avere solo un garage!");
		case 2: if(PlayerInfo[playerid][OwnedGarages] >= 2) return SendClientMessage(playerid, COLOR_RED, "Come utente premium silver puoi avere massimo due garage!"); 
		case 3: if(PlayerInfo[playerid][OwnedGarages] >= 3) return SendClientMessage(playerid, COLOR_RED, "Come utente premium gold puoi avere massimo tre garage!");
	}
	if(GetPlayerCash(playerid) < GarageInfo[gid][gPrice]) return SendClientMessage(playerid, COLOR_RED, "Non hai abbastanza soldi per comprare il garage!");
	GarageInfo[gid][gOwnerID] = PlayerInfo[playerid][pID];
	GivePlayerCash(playerid, -GarageInfo[gid][gPrice]);
	GarageInfo[gid][gOwned] = 1;
	PlayerInfo[playerid][OwnedGarages]++;
	strcpy(GarageInfo[gid][gOwner], GetPlayerNameEx(playerid), 32);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "Hai acquistato questo garage!");
	UpdateGarageLabelsAndPickup(gid);
	SaveGarage(gid);
	return 1;
}

CMD:id(playerid, params[])
{
	new pid;
	if(sscanf(params, "d", pid)) return SendClientMessage(playerid, -1, "Andasdasdas");
	PlayerInfo[playerid][pID] = pid;
	SendClientMessage(playerid, -1, "PorcoDio");
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

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(RELEASED(KEY_WALK))
	{
		new gid = IsPlayerNearGarage(playerid);
		if(gid != 0 && GarageInfo[gid][gOwnerID] == PlayerInfo[playerid][pID])
		{
			ShowPlayerDialog(playerid, GarageDialog, DIALOG_STYLE_LIST, "Garage", "Apri/Chiudi\nVendi garage", "Conferma", "Annulla");
		}
	}
	return 1;
}

// NON TI SERVONO

GetPlayerNameEx(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
}

IsNumeric(const string[])
{
	for (new i = 0, j = strlen(string); i < j; i++)
	{
		if (string[i] > '9' || string[i] < '0') return 0;
	}
    return 1;
}