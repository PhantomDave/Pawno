/*---------------------------------------------------
	Inizio Lavoro: 06/04/2016 Fine lavoro: 10/04/06 ALLE PORCODDIO DI 3:10 di notte.

	Potrebbe esserci qualche piccolo bug, ma niente di grave.


	NON DEVI COPIARE l'ONPLAYERCONNECT, Devi solo mettere il pID caricato dal BD nei posti dove serve (Sostiuisiscilo con il tuo nel pI!
	Cerca tutti i GetPlayerMoney e GivePlayerMoney e sosituiscili con quelli dell'AC, Stessa cosa con il GivePlayerWeapon
	Devi fare il GivePlayerOfflineMoney in modo da poterli vendere offline.

	E' STATO UN CANCRO DIOCANE. Non mi basta più la mamma di Morello ora.
-----------------------------------------------------*/


#include <a_samp>
#include <a_mysql>
//Ho modificato l'include ZONES, ricordami di passartelo'
#include <zones>
#include <SmartCMD>
#include <streamer>
#include <sscanf2>
#include <easyDialog>
#include <foreach>

#define MYSQL_HOST "87.98.243.201"
#define MYSQL_PSW "JP,nmBJA~m){m7VS"
#define MYSQL_USER "samp6244"
#define MYSQL_DB "samp6244_dave"

new MySQL:serverdb;

#define AC_NAME "Morello"

#define Loop(%0,%1) \
	for(new %0 = 0; %0 != %1; %0++)

#define strcpy(%0,%1,%2) \
	strcat((%0[0] = '\0', %0), %1, %2)

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

#define EMB_ORANGE "{f2a53a}"
#define EMB_GREEN "{32ff36}"
#define EMB_YELLOW "{fbff31}"
#define EMB_WHITE "{FFFFFF}"
#define EMB_RED "{ff0000}"
#define EMB_LIGHTGREEN "{80ff72}"
#define EMB_BLUE "{0026ff}"
#define EMB_LIGHTBLUE "{00fffa}"
#define EMB_PINK "{f200ff}"
#define EMB_PURPLE "{aa00ff}"
#define EMB_DGREEN "{8C9566}"

enum BuildingInt
{
	bInt,
	Float:IntPosX,
	Float:IntPosY,
	Float:IntPosZ,
	Float:IntPosA,
	Type[32],
	Float:iPickupX,
	Float:iPickupY,
	Float:iPickupZ,
	Float:ActorX,
	Float:ActorY,
	Float:ActorZ,
	Float:ActorA,
	ActorSkin

};

new BuildingArray[][BuildingInt] =
{
	{17, Float:-25.7624,Float:-187.5468,Float:1003.5469,Float:0.7348, "24/7 1", Float:-29.0252,Float:-185.1315,Float:1003.5469,Float:-29.1388,Float:-186.8163,Float:1003.5469,Float:352.2747,93}, //24/7 1
	{10, Float:5.9052,Float:-31.7663,Float:1003.5494,Float:0.4449, "24/7 2", Float:2.2449,Float:-29.0126,Float:1003.5494, Float:2.1876,Float:-30.7010,Float:1003.5494,Float:359.1916,93}, // 24/7 2
	{18, Float:-31.0474,Float:-92.0097,Float:1003.5469,Float:0.1449, "24/7 3", Float:-28.0551,Float:-89.9482,Float:1003.5469,Float:-28.0240,Float:-91.6380,Float:1003.5469,Float:1.8799,93}, // 24/7 3
	{16, Float:-25.132598, Float:-139.066986, Float:1003.546875,Float:0.0, "24/7 (BUG)"}, //24/7 4
	{4, Float:-27.1195,Float:-31.7600,Float:1003.5573,Float:1.6749, "24/7 4",Float:-30.8051,Float:-29.0102,Float:1003.5573,Float:-30.9846,Float:-30.7141,Float:1003.5573,Float:1.5300,93}, //24/7 5
	{6, Float:-27.5036,Float:-58.2724,Float:1003.5469,Float:355.1315, "24/7 5",Float:-23.4197,Float:-55.6346,Float:1003.5469,Float:-23.6645,Float:-57.3110,Float:1003.5469,Float:353.4199,93}, //24/7 6
	{1, Float:285.2804,Float:-41.5888,Float:1001.5156,Float:2.0349, "Ammunation 1", Float:295.6236,Float:-38.4777,Float:1001.5156,Float:295.4522,Float:-40.2161,Float:1001.5156,Float:2.6616,179}, //Ammunation 1
	{4, Float:285.6463,Float:-86.5454,Float:1001.5229,Float:356.0814, "Ammunation 2",Float:295.9685,Float:-80.8115,Float:1001.5156,Float:295.9018,Float:-82.5284,Float:1001.5156,Float:359.5046,179}, //Ammunation 2
	{6, Float:297.0346,Float:-111.8541,Float:1001.5156,Float:0.4681, "Ammunation 3",Float:290.1569,Float:-109.7815,Float:1001.5156,Float:290.2807,Float:-111.5130,Float:1001.5156,Float:4.8548,179}, //Ammunation 3
	{7, Float:315.6392,Float:-143.6631,Float:999.6016,Float:357.6480, "Ammunation 4", Float:308.3753,Float:-141.4632,Float:999.6016,Float:308.4088,Float:-143.0904,Float:999.6016,Float:0.7814,179}, //Ammunation 4
	{6, Float:316.3236,Float:-170.2963,Float:999.5938,Float:357.6482, "Ammunation 5", Float:312.5658, Float:-166.1395, Float:999.6010,Float:312.5350,Float:-167.7646,Float:999.5938,Float:1.7449,179}, //Ammunation 5
	{11, Float:501.980987, Float:-69.150199, Float:998.757812, Float:0.0, "Bar",Float:497.6604,Float:-76.0410,Float:998.7578,Float:497.6451,Float:-77.4661,Float:998.7651,Float:358.1199,172}, //Bar
	{18, Float:-229.2950,Float:1401.4362,Float:27.7656,Float:274.0824, "Lil' probe inn", Float:-224.7811, Float:1403.9369, Float:27.7734,Float:-223.3083,Float:1404.0576,Float:27.7734,Float:91.1173,172}, // Lil' probe inn
	{10, Float:363.0292,Float:-74.8660,Float:1001.5078,Float:309.1528, "Burgher Shot", Float:376.2597,Float:-67.4344,Float:1001.5078,Float:375.962463,Float:-65.816848,Float:1001.507812,Float:180.0,205}, //Burgher Shot
	{9, Float:364.9563,Float:-11.5001,Float:1001.8516,Float:359.9134, "Cluckin' Bell", Float:369.6195,Float:-6.0175,Float:1001.8589,Float:369.579528,Float:-4.487294,Float:1001.858886,Float:180.0,167}, // Cluckin' Bell
	{5, Float:372.4531,Float:-133.5233,Float:1001.4922,Float:0.8767, "Pizza Stack", Float:375.6373,Float:-118.8026,Float:1001.4995,Float:373.825653,Float:-117.270904,Float:1001.499511,Float:180.0,155}, // Pizza Stack
	{17, Float:376.8684,Float:-193.1275,Float:1000.6328,Float:355.5500, "Donut Shop"}, // Donut
	{3, Float:834.2784,Float:7.4321,Float:1004.1870,Float:93.6244, "Betting Shop"}, // Centro Scomesse
	{3, Float:-100.4937,Float:-24.7553,Float:1000.7188,Float:2.7568, "Sexy Shop", Float:-103.9737,Float:-22.6786,Float:1000.7188,Float:-103.7911,Float:-24.2024,Float:1000.7188,Float:3.4068,178}, // Sexy Shop
	{6, Float:-103.9737,Float:-22.6786,Float:1000.7188,Float:186.8301, "Electronics Shop (BUG)"}, // Zero's RC Shop
	{15, Float:208.0535,Float:-111.1437,Float:1005.1328,Float:3.6242, "Binco", Float:207.5978,Float:-100.3269,Float:1005.2578,Float:207.4065,Float:-98.7054,Float:1005.2578,Float:183.4558,93}, //Binco
	{14, Float:204.2928,Float:-168.5321,Float:1000.5234,Float:359.6233, "Dider Sachs", Float:204.4226,Float:-159.9458,Float:1000.5234,Float:204.4333,Float:-157.8283,Float:1000.5234,Float:178.2016,93}, // Dider Sachs
	{3, Float:206.8947,Float:-139.9997,Float:1003.5078,Float:359.9132, "Pro Laps", Float:207.1322,Float:-129.7025,Float:1003.5078,Float:206.9372,Float:-127.8058,Float:1003.5078,Float:181.9382,93}, //ProLaps
	{1, Float:203.6376,Float:-49.6787,Float:1001.8047,Float:0.8299, "SubUrban", Float:203.7952,Float:-43.7465,Float:1001.8047,Float:204.0635,Float:-41.6708,Float:1001.8047,Float:176.9015,93}, // SubUrban
	{5, Float:227.0963,Float:-8.3193,Float:1002.2109,Float:89.8173, "Victim", Float:206.3759,Float:-8.1675,Float:1001.2109,Float:204.8535,Float:-8.1855,Float:1001.2109,Float:265.2856,93}, //Victim
	{18, Float:161.5555,Float:-96.7665,Float:1001.8047,Float:359.2632, "Zip", Float:161.4990,Float:-84.2473,Float:1001.8047,Float:161.5055,Float:-81.1912,Float:1001.8047,Float:180.684,93}, //Zip
	{15, Float:2214.7705,Float:-1150.4320,Float:1025.7969,Float:273.0723, "Jefferson Motel", Float:2217.2002,Float:-1146.4058,Float:1025.7969}, //Jefferson Motel
	{0, Float:0.0, Float:0.0, Float: 0.0,Float:0.0, "Building"}
};

enum LaundryEnum
{
	Float:lX,
	Float:lY,
	Float:lZ
};

new Float:LaundryArray[][LaundryEnum] =
{
	{2804.0864,-1431.7927,40.0513},
	{1803.1080,-2139.4685,13.5469},
	{1541.0785,-1208.5658,17.4354},
	{392.0189,-2058.4219,10.7193}
};


enum ShopEnum
{
	sID,
	sName[20],
	sPrice
};

new AmmunationArray[][ShopEnum] = // Format: WeapID, Name, Price
{
	{-1, "Bulletproof Vest", 5000},
	{4, "Knife", 50000},
	{8, "Katana", 25000},
	{22, "Colt 45", 1500},
	{23, "Silenced Pistol", 3000},
	{24, "Desert Eagle", 30000},
	{25, "Shotgun", 10000},
	{26, "Sawn-off Shotgun", 50000},
	{27, "Combat Shotgun", 150000},
	{28, "UZI", 100000},
	{29, "MP5", 200000},
	{30, "AK47", 400000},
	{31, "M4", 500000},
	{32, "TEC9", 100000},
	{33, "Rifle", 30000},
	{34, "Sniper Rifle", 800000}
};

new ShopArray[][ShopEnum] = // ID(If Needed), Name, price
{
	{2, "Golf Club", 200},
	{5, "Baseball Bat", 150},
	{6, "Shovel", 100},
	{7, "Pool Cue", 100},
	{9, "Chainsaw", 30000},
	{14, "Flowers", 10},
	{15, "Cane", 125},
	{41, "Spray can", 3000},
	{43, "Camera", 200}
};

new BarArray[][ShopEnum] =
{
	{-1, "Water", 10},
	{-1, "Sprunk", 50},
	{-1, "Beer", 1},
	{-1, "Whiskey", 100},
	{-1, "Surprise Me", 666}
};

new FastFoodArray[][ShopEnum] =
{
	{-1, "Kids Menu'", 10},
	{-1, "Normal Menu'", 25},
	{-1, "Big Smoke's Menu'", 50},
	{-1, "Salad", 10}
};

new SexyShopArray[][ShopEnum] =
{
	{10, "Double Edged Dildo", 10},
	{11, "Used Dildo", 5},
	{12, "Vibrator", 20},
	{13, "Silver Vibrator", 100},
	{14, "Flowers", 10}
};

new BuildingStatus[2][16] =	{"{32ff36}Open", "{ff0000}Closed"};

#define MAX_BUILDINGS 150

enum ENUM_PLAYER_INFO
{
	pID,
	pName,
	pSalt,
	pPsw,
	pBag,
	pBagAmount
};

new PlayerInfo[MAX_PLAYERS][ENUM_PLAYER_INFO];

enum ENUM_BUILDING_INFO
{
	bID,
	Float:bPosX,
	Float:bPosY,
	Float:bPosZ,
	bPickup,
	bIntPickup,
	Text3D:bLabel,
	bLocked,
	bName[32],
	bPrice,
	bOriginalprice,
	bOwned,
	bType,
	bOwner[MAX_PLAYER_NAME],
	bRegister,
	bOwnerID,
	bActor,
	bRobbed
};

new BuildingInfo[MAX_BUILDINGS][ENUM_BUILDING_INFO];

#define MAX_SPAWNED_BAGS 200

enum ENUM_BAG
{
	bAmount,
	bPickupID
};

new BagInfo[MAX_SPAWNED_BAGS][ENUM_BAG];

new createdBiz = 1,
	Iterator:Buildings<MAX_BUILDINGS>,
	Iterator:Bags<MAX_SPAWNED_BAGS>,
	InBuilding[MAX_PLAYERS],
	WeaponList[12][MAX_PLAYERS],
	spawnedBag = 1;



main()
{
	print("\n----------------------------------");
	print(" Building System");
	print("----------------------------------\n");
}

public OnGameModeInit()
{
	new wname[50];
	GetWeaponName(32, wname, 50);
	print(wname);
	DisableInteriorEnterExits();
	SetGameModeText("Building System");
	SendRconCommand("hostname Building System Testing");
	serverdb = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PSW, MYSQL_DB);
	if(!mysql_errno()) printf("[MYSQL] Connection failed");
	mysql_tquery(serverdb, "SELECT * FROM Buildings", "LoadBuildings");
	AddPlayerClass(46, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	LoadBuildings();
	CreateLaundrys();
	return 1;
}

CreateLaundrys()
{
	Loop(i, sizeof(LaundryArray))
	{
		CreateDynamicMapIcon(LaundryArray[i][lX], LaundryArray[i][lY], LaundryArray[i][lZ], 52, 0xFF0000FF, 0);
		CreateDynamicCP(LaundryArray[i][lX], LaundryArray[i][lY], LaundryArray[i][lZ], 1.5, 0,-1,-1,30.0);
	}
	return 1;
}

public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	if(PlayerInfo[playerid][pBagAmount] != 0)
	{
		new str[145];
		format(str,sizeof(str), ""EMB_GREEN"[INFO:]"EMB_WHITE" You managed to steal "EMB_DGREEN"%d$!"EMB_WHITE" The recycling cost is 20 %%!, your cut is: "EMB_DGREEN"%d$",PlayerInfo[playerid][pBagAmount],PlayerInfo[playerid][pBagAmount] * 80 / 100);
		SendClientMessage(playerid, -1, str);
		SetPlayerColor(playerid, 0xFFFFFF00);
		PlayerInfo[playerid][pBagAmount] = 0;
		RemovePlayerAttachedObject(playerid, 0);
		GivePlayerMoney(playerid, PlayerInfo[playerid][pBagAmount] * 80 / 100);
		return 1;
	}
	return 1;
}


CreateBuilding(type, price, Float:x, Float:y, Float:z)
{
	BuildingInfo[createdBiz][bType] = type;
	BuildingInfo[createdBiz][bPosX] = x;
	BuildingInfo[createdBiz][bPosY] = y;
	BuildingInfo[createdBiz][bPosZ] = z;
	BuildingInfo[createdBiz][bOriginalprice] = price;
	BuildingInfo[createdBiz][bLocked] = 0;
	BuildingInfo[createdBiz][bOwned] = 0;
	strcpy(BuildingInfo[createdBiz][bName], BuildingArray[type][Type], 32);
	UpdateBuildingLabelAndPickup(createdBiz);
	BuildingInfo[createdBiz][bPickup] = CreateDynamicPickup(1239, 1, x, y, z);
	new query[156];
	mysql_format(serverdb, query,sizeof(query), "INSERT INTO `Buildings` (`Type`,`PosX`,`PosY`,`PosZ`,`OriginalPrice`,`Locked`,`Owned`) VALUES('%d','%.2f','%.2f','%.2f','%d','0','0')",type,x,y,z,price);
	mysql_tquery(serverdb, query);
	SaveBuilding(createdBiz);
	CreateDynamic3DTextLabel(BuildingArray[BuildingInfo[createdBiz][bType]][Type], 0x026FFFF, BuildingArray[BuildingInfo[createdBiz][bType]][iPickupX], BuildingArray[BuildingInfo[createdBiz][bType]][iPickupY], BuildingArray[BuildingInfo[createdBiz][bType]][iPickupZ]+0.5, 5.0);
	CreateDynamicPickup(1239, 1, BuildingArray[BuildingInfo[createdBiz][bType]][iPickupX], BuildingArray[BuildingInfo[createdBiz][bType]][iPickupY], BuildingArray[BuildingInfo[createdBiz][bType]][iPickupZ]);
	Iter_Add(Buildings, createdBiz);
	return createdBiz, createdBiz++;
}

forward LoadBuildings();
public LoadBuildings()
{
	new cout;
	cache_get_row_count(cout);
	Loop(i, cout+1)
	{
		cache_get_value_index_int(i, 0, BuildingInfo[createdBiz][bID]);
		cache_get_value_index_int(i, 1, BuildingInfo[createdBiz][bType]);
		cache_get_value_index_float(i, 2, BuildingInfo[createdBiz][bPosX]);
		cache_get_value_index_float(i, 3, BuildingInfo[createdBiz][bPosY]);
		cache_get_value_index_float(i, 4, BuildingInfo[createdBiz][bPosZ]);
		cache_get_value_index_int(i, 5, BuildingInfo[createdBiz][bLocked]);
		cache_get_value_index_int(i, 6, BuildingInfo[createdBiz][bPrice]);
		cache_get_value_index_int(i, 7, BuildingInfo[createdBiz][bOriginalprice]);
		cache_get_value_index_int(i, 8, BuildingInfo[createdBiz][bOwned]);
		cache_get_value_index_int(i, 9, BuildingInfo[createdBiz][bOwnerID]);
		cache_get_value_index_int(i, 10, BuildingInfo[createdBiz][bRegister]);
		cache_get_value_index(i, 11, BuildingInfo[createdBiz][bName]);
		cache_get_value_index(i, 12, BuildingInfo[createdBiz][bOwner]);
		UpdateBuildingLabelAndPickup(createdBiz);
		CreateDynamic3DTextLabel(BuildingArray[BuildingInfo[createdBiz][bType]][Type], 0x026FFFF, BuildingArray[BuildingInfo[createdBiz][bType]][iPickupX], BuildingArray[BuildingInfo[createdBiz][bType]][iPickupY], BuildingArray[BuildingInfo[createdBiz][bType]][iPickupZ]+0.5, 5.0);
		CreateDynamicPickup(1239, 1, BuildingArray[BuildingInfo[createdBiz][bType]][iPickupX], BuildingArray[BuildingInfo[createdBiz][bType]][iPickupY], BuildingArray[BuildingInfo[createdBiz][bType]][iPickupZ]);
		BuildingInfo[createdBiz][bActor] = CreateActor(BuildingArray[BuildingInfo[createdBiz][bType]][ActorSkin],BuildingArray[BuildingInfo[createdBiz][bType]][ActorX],BuildingArray[BuildingInfo[createdBiz][bType]][ActorY],BuildingArray[BuildingInfo[createdBiz][bType]][ActorZ],BuildingArray[BuildingInfo[createdBiz][bType]][ActorA]);
		SetActorVirtualWorld(BuildingInfo[createdBiz][bActor],createdBiz+1);
		Iter_Add(Buildings, createdBiz);
		createdBiz++;
		printf("Created building ID: %d, Type: %s, Owner: %s",createdBiz, BuildingArray[BuildingInfo[createdBiz][bType]][Type], BuildingInfo[createdBiz][bOwner]);
	}
	return 1;
}

SaveBuilding(bid)
{
	new query[356];
	mysql_format(serverdb, query,sizeof(query), "UPDATE Buildings SET \
		PosX = '%.2f',\
		PosY = '%.2f',\
		PosZ = '%.2f',\
		Price = '%d',\
		Locked = '%d',\
		Owned = '%d',\
		OwnerID = '%d',\
		Cash = '%d',\
		Name = '%s',\
		OwnerName = '%s' WHERE bID = '%d'",
		BuildingInfo[bid][bPosX],
		BuildingInfo[bid][bPosY],
		BuildingInfo[bid][bPosZ],
		BuildingInfo[bid][bPrice],
		BuildingInfo[bid][bLocked],
		BuildingInfo[bid][bOwned],
		BuildingInfo[bid][bOwnerID],
		BuildingInfo[bid][bRegister],
		BuildingInfo[bid][bName],
		BuildingInfo[bid][bOwner],
		BuildingInfo[bid][bID]);
	mysql_tquery(serverdb, query);
	return 1;
}

IsPlayerNearBuilding(playerid, Float:range)
{
	foreach(new i : Buildings)
	{
		if(IsPlayerInRangeOfPoint(playerid, range, BuildingInfo[i][bPosX], BuildingInfo[i][bPosY], BuildingInfo[i][bPosZ])) return i;
	}
	return -1;
}

IsPlayerNearBuildingExit(playerid, Float:range)
{
	foreach(new i : Buildings)
	{
		if(IsPlayerInRangeOfPoint(playerid, range, BuildingArray[BuildingInfo[i][bType]][IntPosX], BuildingArray[BuildingInfo[i][bType]][IntPosY], BuildingArray[BuildingInfo[i][bType]][IntPosZ])) return i;
	}
	return -1;
}

IsPlayerNearBuyingPoint(playerid)
{
	foreach(new i : Buildings)
	{
		if(IsPlayerInRangeOfPoint(playerid, 1.0, BuildingArray[BuildingInfo[i][bType]][iPickupX], BuildingArray[BuildingInfo[i][bType]][iPickupY], BuildingArray[BuildingInfo[i][bType]][iPickupZ])) return i;
	}
	return -1;
}

UpdateBuildingLabelAndPickup(bid)
{
	DestroyDynamic3DTextLabel(BuildingInfo[bid][bLabel]);
	DestroyDynamicPickup(BuildingInfo[bid][bPickup]);
	switch(BuildingInfo[bid][bOwned])
	{
		case 0:
		{
			new bstr[256];
			BuildingInfo[bid][bPickup] = CreateDynamicPickup(1239, 1, BuildingInfo[bid][bPosX], 	BuildingInfo[bid][bPosY], BuildingInfo[bid][bPosZ]);
			format(bstr,sizeof(bstr), ""EMB_GREEN"Building for sale!\n\nBuilding type:"EMB_WHITE" %s"EMB_GREEN"\nPrice: "EMB_DGREEN"%d$"EMB_WHITE"\n\nPlease press ALT inside the pickup to buy this building",BuildingArray[BuildingInfo[bid][bType]][Type],BuildingInfo[bid][bOriginalprice]);
			BuildingInfo[bid][bLabel] = CreateDynamic3DTextLabel(bstr, 0xFFFFFFFF, BuildingInfo[bid][bPosX], 	BuildingInfo[bid][bPosY], BuildingInfo[bid][bPosZ]+0.7, 10.0);
			return 1;
		}
		case 1:
		{
			new bstr[256];
			BuildingInfo[bid][bPickup] = CreateDynamicPickup(1239, 1, BuildingInfo[bid][bPosX], 	BuildingInfo[bid][bPosY], BuildingInfo[bid][bPosZ]);
			format(bstr,sizeof(bstr), ""EMB_GREEN"Name: "EMB_WHITE"%s\n"EMB_GREEN"Type:"EMB_WHITE" %s\n"EMB_GREEN"Owner: "EMB_WHITE"%s",BuildingInfo[bid][bName],BuildingArray[BuildingInfo[bid][bType]][Type],BuildingInfo[bid][bOwner]);
			BuildingInfo[bid][bLabel] = CreateDynamic3DTextLabel(bstr, 0xFFFFFFFF, BuildingInfo[bid][bPosX], BuildingInfo[bid][bPosY], BuildingInfo[bid][bPosZ]+0.7, 10.0);
			return 1;
		}
		case 2:
		{
			new bstr[256];
			BuildingInfo[bid][bPickup] = CreateDynamicPickup(1239, 1, BuildingInfo[bid][bPosX], 	BuildingInfo[bid][bPosY], BuildingInfo[bid][bPosZ]);
			format(bstr,sizeof(bstr), ""EMB_GREEN"Name: "EMB_WHITE"%s\n"EMB_GREEN"Type:"EMB_WHITE" %s\n"EMB_GREEN"Owner: "EMB_WHITE"%s\n"EMB_GREEN"This building is for sale at the price of "EMB_DGREEN"%d$"EMB_GREEN"\nPress ALT inside the pickup to buy it!",BuildingInfo[bid][bName],BuildingArray[BuildingInfo[bid][bType]][Type],BuildingInfo[bid][bOwner],BuildingInfo[bid][bPrice]);
			BuildingInfo[bid][bLabel] = CreateDynamic3DTextLabel(bstr, 0xFFFFFFFF, BuildingInfo[bid][bPosX], BuildingInfo[bid][bPosY], BuildingInfo[bid][bPosZ]+0.7, 10.0);
			return 1;
		}
	}
	return 1;
}

CMD:createbuilding(cmdid, playerid, params[])
{
	//ADMINFLAG
	if(createdBiz >= MAX_BUILDINGS) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE" You cannot create more buildings, the limit was reached. please contact the developers about this.");
   	new bstr[1024];
   	strcpy(bstr, "Building name\tInterior ID\n",sizeof(bstr));
    Loop(i, sizeof(BuildingArray))
    {
    	if(i < 6) format(bstr,sizeof(bstr), "%s"EMB_LIGHTGREEN"%s\t%d"EMB_WHITE"\n",bstr,BuildingArray[i][Type],BuildingArray[i][bInt]);
    	else if(i < 11) format(bstr,sizeof(bstr), "%s"EMB_ORANGE"%s\t%d"EMB_WHITE"\n",bstr,BuildingArray[i][Type],BuildingArray[i][bInt]);
    	else if(i < 13) format(bstr,sizeof(bstr), "%s"EMB_YELLOW"%s\t%d"EMB_WHITE"\n",bstr,BuildingArray[i][Type],BuildingArray[i][bInt]);
    	else if(i < 17) format(bstr,sizeof(bstr), "%s"EMB_BLUE"%s\t%d"EMB_WHITE"\n",bstr,BuildingArray[i][Type],BuildingArray[i][bInt]);
    	else if(i < 18) format(bstr,sizeof(bstr), "%s"EMB_LIGHTBLUE"%s\t%d"EMB_WHITE"\n",bstr,BuildingArray[i][Type],BuildingArray[i][bInt]);
    	else if(i < 19) format(bstr,sizeof(bstr), "%s"EMB_PINK"%s\t%d"EMB_WHITE"\n",bstr,BuildingArray[i][Type],BuildingArray[i][bInt]);
    	else if(i < 20) format(bstr,sizeof(bstr), "%s"EMB_WHITE"%s\t%d"EMB_WHITE"\n",bstr,BuildingArray[i][Type],BuildingArray[i][bInt]);
    	else if(i < 27) format(bstr,sizeof(bstr), "%s"EMB_PURPLE"%s\t%d"EMB_WHITE"\n",bstr,BuildingArray[i][Type],BuildingArray[i][bInt]);
    	else format(bstr,sizeof(bstr), "%s\n"EMB_WHITE"%s\t%d"EMB_WHITE"\n",bstr,BuildingArray[i][Type],BuildingArray[i][bInt]);
    }
    Dialog_Show(playerid, dialog_CreateBusiness, DIALOG_STYLE_TABLIST_HEADERS, "Create Building", bstr, "Create", "Exit");
	return 1;
}

ShowPlayerBuyMenu(playerid, bid)
{
	new bstr[700];
	switch(BuildingInfo[bid][bType])
	{
		case 0 .. 5:
		{
			strcpy(bstr, "Item\tPrice\n",sizeof(bstr));
			Loop(i, sizeof(ShopArray))
			{
				format(bstr, sizeof(bstr), "%s"EMB_WHITE"%s\t"EMB_DGREEN"%d$"EMB_WHITE"\n",bstr,ShopArray[i][sName],ShopArray[i][sPrice]);
			}
			Dialog_Show(playerid, dialog_Shopbuy, DIALOG_STYLE_TABLIST_HEADERS, "24/7",bstr,"Buy","Cancel");
			return 1;
		}
		case 6 .. 10:
		{

			strcpy(bstr, "Weapon\tPrice\n",sizeof(bstr));
			Loop(i, sizeof(AmmunationArray))
			{
				format(bstr, sizeof(bstr), "%s"EMB_WHITE"%s\t"EMB_DGREEN"%d$"EMB_WHITE"\n",bstr,AmmunationArray[i][sName],AmmunationArray[i][sPrice]);
			}
			Dialog_Show(playerid, dialog_Ammubuy, DIALOG_STYLE_TABLIST_HEADERS, "Ammunation",bstr,"Buy","Ammo");
			return 1;
		}
		case 11, 12:
		{
			strcpy(bstr, "Drink\tPrice\n",sizeof(bstr));
			Loop(i, sizeof(BarArray))
			{
				format(bstr, sizeof(bstr), "%s"EMB_WHITE"%s\t"EMB_DGREEN"%d$"EMB_WHITE"\n",bstr,BarArray[i][sName],BarArray[i][sPrice]);
			}
			Dialog_Show(playerid, dialog_Barbuy, DIALOG_STYLE_TABLIST_HEADERS, "Bar",bstr,"Buy","Cancel");
			return 1;
		}
		case 13 .. 16:
		{
			strcpy(bstr, "Menu\tPrice\n",sizeof(bstr));
			Loop(i, sizeof(FastFoodArray))
			{
				format(bstr, sizeof(bstr), "%s"EMB_WHITE"%s\t"EMB_DGREEN"%d$"EMB_WHITE"\n",bstr,FastFoodArray[i][sName],FastFoodArray[i][sPrice]);
			}
			Dialog_Show(playerid, dialog_Fastfoodbuy, DIALOG_STYLE_TABLIST_HEADERS, "Fast Food",bstr,"Buy","Cancel");
			return 1;
		}
		case 18:
		{
			strcpy(bstr, "Sexy Item\tPrice\n",sizeof(bstr));
			Loop(i, sizeof(SexyShopArray))
			{
				format(bstr, sizeof(bstr), "%s"EMB_WHITE"%s\t"EMB_DGREEN"%d$"EMB_WHITE"\n",bstr,SexyShopArray[i][sName],SexyShopArray[i][sPrice]);
			}
			Dialog_Show(playerid, dialog_Sexybuy, DIALOG_STYLE_TABLIST_HEADERS, "Sexy Shop",bstr,"Buy","Cancel");
			return 1;
		}
		case 20 .. 26: return Dialog_Show(playerid, dialog_Clothesbuy, DIALOG_STYLE_INPUT, "Clothes Shop", "Insert the Skin ID\nThe skin will cost 1000$", "Buy", "Exit");

	}
	return 1;
}

Dialog:dialog_Clothesbuy(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;
	if(GetPlayerMoney(playerid) < 1000) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE" You don't have enough money!");
	if(!IsNumeric(inputtext)) return Dialog_Show(playerid, dialog_Clothesbuy, DIALOG_STYLE_INPUT, "Clothes Shop", "Insert the Skin ID\nINVALID ID", "Buy", "Exit");
	if(strval(inputtext) <= 0 || strval(inputtext) == 74 || strval(inputtext) > 311) return Dialog_Show(playerid, dialog_Clothesbuy, DIALOG_STYLE_INPUT, "Clothes Shop", "Insert the Skin ID\nINVALID ID", "Buy", "Exit");
	SetPlayerSkin(playerid, strval(inputtext));
	GivePlayerMoney(playerid, -1000);
	new bstr[145];
	format(bstr,sizeof(bstr), ""EMB_GREEN"[INFO:]"EMB_WHITE" You bought some clothes ("EMB_ORANGE"Skin ID %d"EMB_WHITE"), for "EMB_DGREEN"1000$",strval(inputtext));
	SendClientMessage(playerid, -1, bstr);
	return 1;
}

GetWeapArrayID(itemname[])
{
	Loop(i, sizeof(AmmunationArray))
	{
		if(!strcmp(itemname, AmmunationArray[i][sName])) return i;
	}
	return -1;
}

GetWeaponSlot(weaponid)
{
	new slot;
	switch(weaponid)
	{
		case 0,1: slot = 0;
		case 2 .. 9: slot = 1;
		case 10 .. 15: slot = 10;
		case 16 .. 18, 39: slot = 8;
		case 22 .. 24: slot =2;
		case 25 .. 27: slot = 3;
		case 28, 29, 32: slot = 4;
		case 30, 31: slot = 5;
		case 33, 34: slot = 6;
		case 35 .. 38: slot = 7;
		case 40: slot = 12;
		case 41 .. 43: slot = 9;
		case 44 .. 46: slot = 11;
	}
	return slot;
}

ShowPlayerAmmoMenu(playerid)
{
	new weap,ammo,bstr[720],wname[32],price,id,list;
	strcpy(bstr,"Weapon\tAmmo\tPack\tPrice\n", sizeof(bstr));
	list = 0;
	for(new i = 2; i < 12; i++)
	{
		GetPlayerWeaponData(playerid, i, weap, ammo);
		if(weap == 0) continue;
		GetWeaponName(weap, wname, sizeof(wname));
		id = GetWeapArrayID(wname);
		price = AmmunationArray[id][sPrice] * 5 / 100;
		format(bstr,sizeof(bstr), "%s"EMB_WHITE"%s\t"EMB_BLUE"%d"EMB_WHITE"\t100\t"EMB_DGREEN"%d$\n",bstr,wname,ammo,price);
		WeaponList[list][playerid] = weap;
		list++;
	}
	Dialog_Show(playerid, dialog_Ammobuy, DIALOG_STYLE_TABLIST_HEADERS, "Cartridges", bstr, "Conifrm", "Exit");
	return 1;
}

Dialog:dialog_Ammobuy(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;
	new wname[32];
	GetWeaponName(WeaponList[listitem][playerid], wname, sizeof(wname));
	new id = GetWeapArrayID(wname);
	if(GetPlayerMoney(playerid) < AmmunationArray[id][sPrice] * 7 / 100) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]" EMB_WHITE"You don't have enough money!");
	GivePlayerMoney(playerid, - AmmunationArray[id][sPrice] * 7 / 100);
	new wid, ammo, slot = GetWeaponSlot(WeaponList[listitem][playerid]);
	GetPlayerWeaponData(playerid, slot, wid, ammo);
	GivePlayerWeapon(playerid, wid, ammo+100);
	BuildingInfo[InBuilding[playerid]][bRegister] += AmmunationArray[listitem][sPrice] * 7 / 100;
	new str[145];
	format(str,sizeof(str), ""EMB_GREEN"[INFO:]"EMB_WHITE" You bought a pack of cartridges for your "EMB_ORANGE"%s"EMB_WHITE" for "EMB_DGREEN"%d$",wname, AmmunationArray[id][sPrice] * 7 / 100);
	SendClientMessage(playerid, -1, str);
	return 1;
}

Dialog:dialog_Ammubuy(playerid, response, listitem, inputtext[])
{
	if(!response) return ShowPlayerAmmoMenu(playerid);
	if(listitem == 0)
	{
		SetPlayerArmour(playerid, 100);
	}
	if(GetPlayerMoney(playerid) < AmmunationArray[listitem][sPrice]) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]" EMB_WHITE"You don't have enough money!");
	GivePlayerWeapon(playerid, AmmunationArray[listitem][sID], 1);
	GivePlayerMoney(playerid, -AmmunationArray[listitem][sPrice]);
	new str[145];
	format(str,sizeof(str), ""EMB_GREEN"[INFO:]"EMB_WHITE" You have bought a "EMB_ORANGE"%s"EMB_WHITE" for "EMB_DGREEN"%d$",AmmunationArray[listitem][sName],AmmunationArray[listitem][sPrice]);
	SendClientMessage(playerid, -1, str);
	SendClientMessage(playerid, -1, ""EMB_GREEN"[INFO:]"EMB_WHITE" Now use the ammo button in the same dialog to get the ammo!");
	new bid = InBuilding[playerid];
	BuildingInfo[bid][bRegister] += AmmunationArray[listitem][sPrice];
	SaveBuilding(bid);
	return 1;
}

Dialog:dialog_Fastfoodbuy(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;
	if(GetPlayerMoney(playerid) < FastFoodArray[listitem][sPrice]) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]" EMB_WHITE"You don't have enough money!");
	switch(listitem)
	{
		case 0:
		{
			new Float:Health;
			GetPlayerHealth(playerid, Health);
			if(Health < 100.0) { SetPlayerHealth(playerid, Health+10); GivePlayerMoney(playerid, -FastFoodArray[listitem][sPrice]); }
			else return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE" You aren't hungry");
			new str[145];
			format(str,sizeof(str), ""EMB_GREEN"[INFO:]"EMB_WHITE" You bought a "EMB_ORANGE"%s"EMB_WHITE" (Health: +10)",FastFoodArray[listitem][sName]);
			SendClientMessage(playerid, -1, str);
			return 1;
		}
		case 1:
		{
			new Float:Health;
			GetPlayerHealth(playerid, Health);
			if(Health < 100.0) { SetPlayerHealth(playerid, Health+40); GivePlayerMoney(playerid, -FastFoodArray[listitem][sPrice]); }
			else return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE" You aren't hungry");
			new str[145];
			format(str,sizeof(str), ""EMB_GREEN"[INFO:]"EMB_WHITE" You bought a "EMB_ORANGE"%s"EMB_WHITE" (Health: +40)",FastFoodArray[listitem][sName]);
			SendClientMessage(playerid, -1, str);
			return 1;
		}
		case 2:
		{
			new Float:Health;
			GetPlayerHealth(playerid, Health);
			if(Health < 100.0) { SetPlayerHealth(playerid, Health+50); GivePlayerMoney(playerid, -FastFoodArray[listitem][sPrice]); }
			else return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE" You aren't hungry");
			new str[145];
			format(str,sizeof(str), ""EMB_GREEN"[INFO:]"EMB_WHITE" You bought a "EMB_ORANGE"%s"EMB_WHITE" (Health: +50)",FastFoodArray[listitem][sName]);
			SendClientMessage(playerid, -1, str);
			SendClientMessage(playerid, -1, ""EMB_LIGHTGREEN"Big Smoke:"EMB_WHITE" I'll have two number 9s, a number 9 large, a number 6 with extra dip, a number 7, two number 45s, one with cheese and a large soda.");
			return 1;
		}
		case 3:
		{
			new Float:Health;
			GetPlayerHealth(playerid, Health);
			if(Health < 100.0) { SetPlayerHealth(playerid, Health+15); GivePlayerMoney(playerid, -FastFoodArray[listitem][sPrice]); }
			else return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE" You aren't hungry");
			new str[145];
			format(str,sizeof(str), ""EMB_GREEN"[INFO:]"EMB_WHITE" You bought a "EMB_ORANGE"%s"EMB_WHITE" (Health: +15)",FastFoodArray[listitem][sName]);
			SendClientMessage(playerid, -1, str);
			return 1;
		}
	}
	return 1;
}

Dialog:dialog_Barbuy(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;
	if(GetPlayerMoney(playerid) < BarArray[listitem][sPrice]) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]" EMB_WHITE"You don't have enough money!");
	switch(listitem)
	{
		case 0:
		{
			new Float:Health;
			GetPlayerHealth(playerid, Health);
			if(Health < 100.0){ SetPlayerHealth(playerid, Health+5);	GivePlayerMoney(playerid, -BarArray[listitem][sPrice]); }
			else SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE" You aren't thirsty");
		}
		case 1:
		{
			new Float:Health;
			GetPlayerHealth(playerid, Health);
			if(Health < 100.0){ SetPlayerHealth(playerid, Health+15);	GivePlayerMoney(playerid, -BarArray[listitem][sPrice]); }
			else SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE" You aren't thirsty");
		}
		case 2:
		{
			SendClientMessage(playerid, -1, ""EMB_GREEN"[INFO:]"EMB_WHITE" Just one dollar, because a man is made of 70%% beer");
			SetPlayerDrunkLevel(playerid, GetPlayerDrunkLevel(playerid)+100);
			GivePlayerMoney(playerid, -BarArray[listitem][sPrice]);
		}
		case 3:
		{
			SendClientMessage(playerid, -1, ""EMB_GREEN"[INFO:]"EMB_WHITE" Don't drive after this.");
			SetPlayerDrunkLevel(playerid, GetPlayerDrunkLevel(playerid)+1000);
			GivePlayerMoney(playerid, -BarArray[listitem][sPrice]);
		}
		case 4:
		{
			SendClientMessage(playerid, -1, ""EMB_GREEN"[INFO:]"EMB_WHITE" This is special!");
			SetPlayerDrunkLevel(playerid, GetPlayerDrunkLevel(playerid)+random(10000));
			GivePlayerMoney(playerid, -BarArray[listitem][sPrice]);
		}
	}
	return 1;
}

Dialog:dialog_Shopbuy(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;
	if(GetPlayerMoney(playerid) < ShopArray[listitem][sPrice]) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]" EMB_WHITE"You don't have enough money!");
	GivePlayerWeapon(playerid, ShopArray[listitem][sID], 1);
	GivePlayerMoney(playerid, -ShopArray[listitem][sPrice]);
	new str[145];
	format(str,sizeof(str), ""EMB_GREEN"[INFO:]"EMB_WHITE" You have bought a "EMB_ORANGE"%s"EMB_WHITE" for "EMB_DGREEN"%d$",ShopArray[listitem][sName],ShopArray[listitem][sPrice]);
	SendClientMessage(playerid, -1, str);
	new bid = InBuilding[playerid];
	BuildingInfo[bid][bRegister] += ShopArray[listitem][sPrice];
	SaveBuilding(bid);
	return 1;
}

Dialog:dialog_Sexybuy(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;
	if(GetPlayerMoney(playerid) < SexyShopArray[listitem][sPrice]) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]" EMB_WHITE"You don't have enough money!");
	GivePlayerWeapon(playerid, SexyShopArray[listitem][sID], 1);
	GivePlayerMoney(playerid, -SexyShopArray[listitem][sPrice]);
	new str[145];
	format(str,sizeof(str), ""EMB_GREEN"[INFO:]"EMB_WHITE" You have bought a "EMB_ORANGE"%s"EMB_WHITE" for "EMB_DGREEN"%d$",SexyShopArray[listitem][sName],SexyShopArray[listitem][sPrice]);
	SendClientMessage(playerid, -1, str);
	new bid = InBuilding[playerid];
	BuildingInfo[bid][bRegister] += SexyShopArray[listitem][sPrice];
	SaveBuilding(bid);
	return 1;
}

ShowPlayerBuildingMenu(playerid, bid)
{
	new bstr[200];
	format(bstr,sizeof(bstr), ""EMB_WHITE"Name "EMB_GREEN"%s\n"EMB_WHITE"Status %s"EMB_WHITE"\nBuilding safe\nSell building to server for"EMB_DGREEN" %d$"EMB_WHITE"\nPut the building on sale",
								BuildingInfo[bid][bName],
								BuildingStatus[BuildingInfo[bid][bLocked]],
								BuildingInfo[bid][bOriginalprice] * 75 / 100);
	Dialog_Show(playerid, dialog_bMenu, DIALOG_STYLE_LIST,"Building Menu'", bstr, "Confirm", "Exit");
	InBuilding[playerid] = bid;
	return 1;
}

Dialog:dialog_bMenu(playerid, response, listitem, inputtext[])
{
	if(!response)
	{
		InBuilding[playerid] = -1;
		return 1;
	}
	new bid = InBuilding[playerid];
	switch(listitem)
	{
		case 0: Dialog_Show(playerid, dialog_bName, DIALOG_STYLE_INPUT, "Building Name", "Select a name for your building!", "Confirm", "Exit");
		case 1:
		{
			switch(BuildingInfo[bid][bLocked])
			{
				case 0:
				{
					BuildingInfo[bid][bLocked] = 1;
					new bstr[80];
					format(bstr,sizeof(bstr), ""EMB_GREEN"[INFO:]"EMB_WHITE" Your buiding is now %s",BuildingStatus[BuildingInfo[bid][bLocked]]);
					SendClientMessage(playerid, -1, bstr);
					InBuilding[playerid] = -1;
					SaveBuilding(bid);
				}
				case 1:
				{
					BuildingInfo[bid][bLocked] = 0;
					new bstr[80];
					format(bstr,sizeof(bstr), ""EMB_GREEN"[INFO:]"EMB_WHITE" Your buiding is now %s",BuildingStatus[BuildingInfo[bid][bLocked]]);
					SendClientMessage(playerid, -1, bstr);
					InBuilding[playerid] = -1;
					SaveBuilding(bid);
				}
			}
			return 1;
		}
		case 2:
		{
			Dialog_Show(playerid, dialog_Safemenu, DIALOG_STYLE_LIST, "Safe Menu", "Deposit\nWithdraw", "Confirm", "Exit");
			return 1;
		}
		case 3:
		{
			new bstr[150];
			format(bstr,sizeof(bstr), ""EMB_WHITE" You are going to sell this building ("EMB_ORANGE"%s"EMB_WHITE") for "EMB_DGREEN"%d$"EMB_WHITE"\n\nAre you sure?",BuildingArray[BuildingInfo[bid][bType]][Type],BuildingInfo[bid][bOriginalprice] * 75 / 100);
			Dialog_Show(playerid, dialog_bSell, DIALOG_STYLE_MSGBOX, "Sell Building", bstr, "Confirm", "Exit");
		}
		case 4: Dialog_Show(playerid, dialog_Setprice, DIALOG_STYLE_INPUT, "Set Building Price", "Please insert the price down below\nInsert 0 if you don't wanna sell your building.", "Confirm","Exit");
	}
	return 1;
}

Dialog:dialog_Setprice(playerid, response, listitem, inputtext[])
{
	if(!response)
	{
		InBuilding[playerid] = -1;
		return 1;
	}
	new bid = InBuilding[playerid];
	InBuilding[playerid] = -1;
	new bstr[145];
	if(!IsNumeric(inputtext)) return Dialog_Show(playerid, dialog_Setprice, DIALOG_STYLE_INPUT, "Set Building Price", "Please insert the price down below\nInsert 0 if you don't wanna sell your building\nINVALID NUMBER", "Confirm","Exit");
	if(strval(inputtext) <= 0)
	{
		SendClientMessage(playerid, -1, ""EMB_GREEN"[INFO:]"EMB_WHITE" Your building is no longer for sale");
		BuildingInfo[bid][bOwned] = 1;
		UpdateBuildingLabelAndPickup(bid);
		SaveBuilding(bid);
		return 1;
	}
	BuildingInfo[bid][bOwned] = 2;
	BuildingInfo[bid][bPrice] = strval(inputtext);
	format(bstr,sizeof(bstr), ""EMB_GREEN"[INFO:]"EMB_WHITE" You are selling this building for "EMB_DGREEN"%d$",BuildingInfo[bid][bPrice]);
	SendClientMessage(playerid, -1, bstr);
	UpdateBuildingLabelAndPickup(bid);
	SaveBuilding(bid);
	return 1;
}

Dialog:dialog_Safemenu(playerid, response, listitem, inputtext)
{
	if(!response)
	{
		InBuilding[playerid] = -1;
		return 1;
	}
	switch(listitem)
	{
		case 0:
		{
			new bstr[120];
			format(bstr,sizeof(bstr), ""EMB_WHITE"There are "EMB_DGREEN"%d$"EMB_WHITE" in the safe, how much you wanna deposit?",BuildingInfo[InBuilding[playerid]][bRegister]);
			Dialog_Show(playerid, dialog_safeDep, DIALOG_STYLE_INPUT, "Deposit", bstr, "Confirm", "Exit");
			return 1;
		}
		case 1:
		{
			new bstr[120];
			format(bstr,sizeof(bstr), ""EMB_WHITE"There are "EMB_DGREEN"%d$"EMB_WHITE" in the safe, how much you wanna withdraw?",BuildingInfo[InBuilding[playerid]][bRegister]);
			Dialog_Show(playerid, dialog_safewith, DIALOG_STYLE_INPUT, "Withdraw", bstr, "Confirm", "Exit");
			return 1;
		}
	}
	return 1;
}

Dialog:dialog_safeDep(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;
	new bstr[120];
	if(!IsNumeric(inputtext))
	{
			format(bstr,sizeof(bstr), ""EMB_WHITE"There are "EMB_DGREEN"%d$"EMB_WHITE" in the safe, how much you wanna deposit?\nINVALID NUMBER",BuildingInfo[InBuilding[playerid]][bRegister]);
			Dialog_Show(playerid, dialog_safeDep, DIALOG_STYLE_INPUT, "Deposit", bstr, "Confirm", "Exit");
			return 1;
	}
	if(strval(inputtext) < 0)
	{
		format(bstr,sizeof(bstr), ""EMB_WHITE"There are "EMB_DGREEN"%d$"EMB_WHITE" in the safe, how much you wanna deposit?\nINVALID NUMBER",BuildingInfo[InBuilding[playerid]][bRegister]);
		Dialog_Show(playerid, dialog_safeDep, DIALOG_STYLE_INPUT, "Deposit", bstr, "Confirm", "Exit");
		return 1;
	}
	if(GetPlayerMoney(playerid) < strval(inputtext)) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE" You don't have enough money!");
	new bid = InBuilding[playerid];
	InBuilding[playerid] = -1;
	BuildingInfo[bid][bRegister] += strval(inputtext);
	GivePlayerMoney(playerid, -strval(inputtext));
	format(bstr,sizeof(bstr), ""EMB_GREEN"[INFO:]"EMB_WHITE" You deposited "EMB_DGREEN"%d$"EMB_WHITE" inside the safe. New safe balance: "EMB_DGREEN"%d$",strval(inputtext), BuildingInfo[bid][bRegister]);
	SendClientMessage(playerid, -1, bstr);
	SaveBuilding(bid);
	return 1;
}

Dialog:dialog_safewith(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;
	new bstr[120];
	if(!IsNumeric(inputtext))
	{
		format(bstr,sizeof(bstr), ""EMB_WHITE"There are "EMB_DGREEN"%d$"EMB_WHITE" in the safe, how much you wanna withdraw?\nINVALID NUMBER",BuildingInfo[InBuilding[playerid]][bRegister]);
		Dialog_Show(playerid, dialog_safewith, DIALOG_STYLE_INPUT, "Withdraw", bstr, "Confirm", "Exit");
		return 1;
	}
	if(strval(inputtext) < 0)
	{
		format(bstr,sizeof(bstr), ""EMB_WHITE"There are "EMB_DGREEN"%d$"EMB_WHITE" in the safe, how much you wanna withdraw?\nINVALID NUMBER",BuildingInfo[InBuilding[playerid]][bRegister]);
		Dialog_Show(playerid, dialog_safewith, DIALOG_STYLE_INPUT, "Withdraw", bstr, "Confirm", "Exit");
		return 1;
	}
	new bid = InBuilding[playerid];
	InBuilding[playerid] = -1;
	if(BuildingInfo[bid][bRegister] < strval(inputtext)) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE" There aren't enough money in the safe!");
	BuildingInfo[bid][bRegister] -= strval(inputtext);
	GivePlayerMoney(playerid, strval(inputtext));
	format(bstr,sizeof(bstr), ""EMB_GREEN"[INFO:]"EMB_WHITE" You withdraw "EMB_DGREEN"%d$"EMB_WHITE" inside the safe. New safe balance: "EMB_DGREEN"%d$",strval(inputtext), BuildingInfo[bid][bRegister]);
	SendClientMessage(playerid, -1, bstr);
	SaveBuilding(bid);
	return 1;
}

Dialog:dialog_bSell(playerid, response, listitem, inputtext[])
{
	if(!response)
	{
		InBuilding[playerid] = -1;
		return 1;
	}
	new bid = InBuilding[playerid];
	InBuilding[playerid] = -1;
	BuildingInfo[bid][bOwned] = 0;
	BuildingInfo[bid][bOwnerID] = 0;
	GivePlayerMoney(playerid, BuildingInfo[bid][bOriginalprice] * 75 / 100);
	new bstr[145];
	format(bstr,sizeof(bstr), ""EMB_GREEN"[INFO:]"EMB_WHITE" You sold your "EMB_ORANGE"%s"EMB_WHITE" for "EMB_DGREEN"%d$.",BuildingArray[BuildingInfo[bid][bType]][Type], BuildingInfo[bid][bOriginalprice] * 75 / 100);
	SendClientMessage(playerid, -1, bstr);
	SaveBuilding(bid);
	UpdateBuildingLabelAndPickup(bid);
	return 1;
}

Dialog:dialog_bSetprice(playerid, response, listitem, inputtext[])
{
	if(!response)
	{
		InBuilding[playerid] = -1;
		return 1;
	}
	if(!IsNumeric(inputtext)) return Dialog_Show(playerid, dialog_bSetprice, DIALOG_STYLE_INPUT, "Building Price", "Please insert a VALID NUMBER!", "Confirm", "Exit");
	new bid = InBuilding[playerid];
	InBuilding[playerid] = -1;
	if(strval(inputtext) <= 0)
	{
		BuildingInfo[bid][bOwned] = 1;
		SendClientMessage(playerid, -1, ""EMB_GREEN"[INFO:]"EMB_WHITE" Your building is no longer for sale");
		return 1;
	}
	BuildingInfo[bid][bOwned] = 2;
	BuildingInfo[bid][bPrice] = strval(inputtext);
	new bstr[145];
	format(bstr,sizeof(bstr), ""EMB_GREEN"[INFO:]"EMB_WHITE" You have put for sale your "EMB_ORANGE"%s"EMB_WHITE" for "EMB_DGREEN"%d$",BuildingArray[BuildingInfo[bid][bType]][Type],BuildingInfo[bid][bPrice]);
	SendClientMessage(playerid, -1, bstr);
	SaveBuilding(bid);
	UpdateBuildingLabelAndPickup(bid);
	return 1;
}

Dialog:dialog_bName(playerid, response, listitem, inputtext[])
{
	if(!response)
	{
		InBuilding[playerid] = -1;
		return 1;
	}
	new bid = InBuilding[playerid];
	InBuilding[playerid] = -1;
	if(strlen(inputtext) > 32) return Dialog_Show(playerid, dialog_bName, DIALOG_STYLE_INPUT, "Building Name", "Select a name for your building!\nThe Name inserted was too long!", "Confirm", "Exit");
	if(strlen(inputtext) <= 0) return Dialog_Show(playerid, dialog_bName, DIALOG_STYLE_INPUT, "Building Name", "Select a name for your building!\nThe Name inserted was too short!", "Confirm", "Exit");
	strcpy(BuildingInfo[bid][bName], inputtext, 32);
	new bstr[144];
	format(bstr,sizeof(bstr), ""EMB_GREEN"[INFO:]"EMB_WHITE" Your "EMB_ORANGE"%s"EMB_WHITE" is now named "EMB_ORANGE"%s.",BuildingArray[BuildingInfo[bid][bType]][Type],BuildingInfo[bid][bName]);
	SendClientMessage(playerid, -1, bstr);
	UpdateBuildingLabelAndPickup(bid);
	SaveBuilding(bid);
	return 1;
}

Dialog:dialog_CreateBusiness(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;
	BuildingInfo[createdBiz][bType] = listitem;
	new bstr[126];
	format(bstr,sizeof(bstr), ""EMB_WHITE"You are creating a "EMB_ORANGE"%s"EMB_WHITE", please insert the price down below.",BuildingArray[listitem][Type]);
	Dialog_Show(playerid, dialog_Createbuildgprice,DIALOG_STYLE_INPUT, "Building Price", bstr, "Create", "Exit");
	return 1;
}

Dialog:dialog_Createbuildgprice(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;
	if(!strval(inputtext)) return Dialog_Show(playerid, dialog_Createbuildingprice, DIALOG_STYLE_INPUT, "Building Price", "Please insert a VALID NUMBER!", "Confirm", "Exit");
	if(!IsNumeric(inputtext)) return Dialog_Show(playerid, dialog_Createbuildingprice, DIALOG_STYLE_INPUT, "Building Price", "Please insert a VALID NUMBER!", "Confirm", "Exit");
	BuildingInfo[createdBiz][bOriginalprice] = strval(inputtext);
	new bid = BuildingInfo[createdBiz][bType];
	new bstr[500];
	format(bstr,sizeof(bstr), ""EMB_WHITE"You are creating a building.\n\nBuilding Type: "EMB_LIGHTBLUE"%s"EMB_WHITE"\nInterior ID: "EMB_ORANGE"%d"EMB_WHITE"\nPrice: "EMB_DGREEN"%d$"EMB_WHITE"\nInterior Pos X: "EMB_LIGHTGREEN"%.2f"EMB_WHITE"\nInterior Pos Y: "EMB_LIGHTGREEN"%.2f"EMB_WHITE"\nInterior Pos Z: "EMB_LIGHTGREEN"%.2f"EMB_WHITE"\n\nPlease, check the data again before pressing continue.",BuildingArray[bid][Type],BuildingArray[bid][bInt],BuildingInfo[createdBiz][bOriginalprice],BuildingArray[bid][IntPosX],BuildingArray[bid][IntPosY],BuildingArray[bid][IntPosZ]);
	Dialog_Show(playerid, dialog_BuildingConf, DIALOG_STYLE_MSGBOX,"Confirm Building Creation", bstr, "Confirm", "Exit");
	return 1;
}

Dialog:dialog_BuildingConf(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;
	new Float:X, Float:Y,Float:Z;
	GetPlayerPos(playerid, X,Y,Z);
	CreateBuilding(BuildingInfo[createdBiz][bType],BuildingInfo[createdBiz][bOriginalprice], X,Y,Z);
	SendClientMessage(playerid, -1, ""EMB_GREEN"[INFO:]"EMB_WHITE" The building was successfully created");
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	new query[106];
	mysql_format(serverdb, query,sizeof(query), "SELECT username, password, salt, pid FROM accounts WHERE username = '%e'", GetPlayerNameEx(playerid));
	mysql_tquery(serverdb, query, "LoadPlayerData","d",playerid);
	printf("%s",query);
	SetPlayerPos(playerid, 2026.6663,1343.7274,10.8203);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	TogglePlayerSpectating(playerid, true);
	return 1;
}

forward LoadPlayerData(playerid);
public LoadPlayerData(playerid)
{
	print("Porcoddio");
	new count;
	if(!cache_get_row_count(count))
	{
		Dialog_Show(playerid, dialog_Login, DIALOG_STYLE_PASSWORD, "Login", "Bentornato nel server, usa la tua password per loggarti","Login","Annulla");
		cache_get_value_index(0, 0, PlayerInfo[playerid][pName]);
		cache_get_value_index(0, 1, PlayerInfo[playerid][pPsw]);
		cache_get_value_index(0, 2, PlayerInfo[playerid][pSalt]);
		cache_get_value_index_int(0, 3, PlayerInfo[playerid][pID]);
	}
	else Dialog_Show(playerid, dialog_Register, DIALOG_STYLE_PASSWORD, "Registrazione", "Benvenuto nel server, inserisci la password per registrarti", "Registrati", "Annulla");
}

Dialog:dialog_Register(playerid, response, listitem, inputtext[])
{
	if(!response) return KickEx(playerid, AC_NAME, "Hai rifiutato la registrazione, sei stato kickato.");
	if(strlen(inputtext) <= 0) return Dialog_Show(playerid, dialog_Register, DIALOG_STYLE_PASSWORD, "Registrazione", "La tua password è troppo corta, riprova", "Registrati", "");
	new salt[11], hashpass[65], query[200];
	for(new i = 0; i < 10; i++)
	{
		salt[i] = random(79) + 47;
	}
	salt[10] = 0;
	SHA256_PassHash(inputtext, salt, hashpass, 65);
	mysql_format(serverdb, query,sizeof(query), "INSERT INTO accounts (username, salt, password) VALUES('%e', '%e', '%e')",GetPlayerNameEx(playerid), salt, hashpass);
	mysql_tquery(serverdb, query);
	printf("%s",query);
	SendClientMessage(playerid, -1, ""EMB_LIGHTGREEN"[INFO] Ti sei registrato con successo, ora loggati");
	Dialog_Show(playerid, dialog_Login, DIALOG_STYLE_PASSWORD, "Login", "Congratulazioni per esserti registrato\nOra inserisci la tua password per loggarti!","Login","Annulla");
	return 1;
}

stock KickEx(playerid, kicker[], reason[])
{
	new string[100];
	format(string,sizeof(string), ""EMB_RED"[INFO:] Sei stato kickato da %s. Motivo: %s",kicker, reason);
	SendClientMessage(playerid, -1, string);
	SetTimerEx("KickPlayer", 1000, 0, "d", playerid);
	return 1;
}

forward KickPlayer(playerid);
public KickPlayer(playerid)
{
	Kick(playerid);
}

// A TE NON SERVE QUESTO!!11!111
public OnPlayerConnect(playerid)
{
	EnablePlayerCameraTarget(playerid, 1);
	InBuilding[playerid] = -1;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	InBuilding[playerid] = -1;
	return 1;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerPos(playerid,2026.6663,1343.7274,10.8203);
	GivePlayerMoney(playerid, 5000000);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	InBuilding[playerid] = -1;
	if(PlayerInfo[playerid][pBagAmount] != 0)
	{
		RemovePlayerAttachedObject(playerid, 0);
		new Float:X,Float:Y,Float:Z;
		GetPlayerPos(playerid, X,Y,Z);
		BagInfo[spawnedBag][bPickupID] = CreateDynamicPickup(1550, 2, X,Y,Z);
		BagInfo[spawnedBag][bAmount] = PlayerInfo[playerid][pBagAmount];
		PlayerInfo[playerid][pBagAmount] = 0;
		Iter_Add(Bags, spawnedBag);
		spawnedBag++;
	}
	return 1;
}

CMD:kill(cmdid,playerid,parms[])
{
	SetPlayerHealth(playerid, 0.0);
	return 1;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	foreach(new i : Bags)
	{
		if(pickupid == BagInfo[i][bPickupID])
		{
				new str[145];
				if(PlayerInfo[playerid][pBagAmount] <= 0)
				{
					PlayerInfo[playerid][pBagAmount] += BagInfo[i][bAmount];
					SetPlayerColor(playerid, 0x00FFFFFF);
					DestroyDynamicPickup(BagInfo[i][bPickupID]);
					format(str,sizeof(str), ""EMB_GREEN"[INFO:]"EMB_WHITE" The bag had"EMB_DGREEN" %d$"EMB_WHITE", you took the bag, now you can be killed by other players!",BagInfo[i][bAmount]);
					SendClientMessage(playerid, -1, str);
					SetPlayerAttachedObject(playerid, 0, 2295, 1,-0.122999, -0.167000, 0.049999, 0.000000, 107.599945, 2.199999, 0.250999, 0.315999, 0.798999);
					Iter_Remove(Bags, i);
					break;

				}
				format(str,sizeof(str), ""EMB_GREEN"[INFO:]"EMB_WHITE" The bag had "EMB_DGREEN"%d$"EMB_WHITE", you have added the content to your bag!",BagInfo[i][bAmount]);
				SendClientMessage(playerid, -1, str);
				DestroyDynamicPickup(BagInfo[i][bPickupID]);
				PlayerInfo[playerid][pBagAmount] += BagInfo[i][bAmount];
				Iter_Remove(Bags, i);
				break;
		}
	}
	return 1;
}

// Devi adattare i GetPlayerMoney
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(PRESSED(KEY_WALK))
	{
		if(IsPlayerNearBuilding(playerid, 1.0) != -1)
		{
			new bid = IsPlayerNearBuilding(playerid, 1.0);
			if(BuildingInfo[bid][bType] == 27) return 1;
			if(BuildingInfo[bid][bOwned] == 0)
			{
				if(GetPlayerMoney(playerid) < BuildingInfo[bid][bOriginalprice]) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE" You don't have enough money!");
				new bstr[156];
				format(bstr,sizeof(bstr), ""EMB_WHITE"You are buying a(n) "EMB_ORANGE"%s"EMB_WHITE" for "EMB_DGREEN"%d$"EMB_WHITE"\n\nClick the 'Confirm' button if you accept the deal",BuildingArray[BuildingInfo[bid][bType]][Type],BuildingInfo[bid][bOriginalprice]);
				Dialog_Show(playerid, dialog_BuyBuilding, DIALOG_STYLE_MSGBOX, "Buy Building", bstr, "Confirm", "Exit");
				InBuilding[playerid] = bid;
				return 1;
			}
			if(BuildingInfo[bid][bOwnerID] == PlayerInfo[playerid][pID]) return ShowPlayerBuildingMenu(playerid, bid);
			if(BuildingInfo[bid][bOwned] == 2 && BuildingInfo[bid][bOwnerID] != PlayerInfo[playerid][pID])
			{
				if(GetPlayerMoney(playerid) < BuildingInfo[bid][bPrice]) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE" You don't have enough money!");
				new bstr[156];
				format(bstr,sizeof(bstr), ""EMB_WHITE"You are buying a(n) "EMB_ORANGE"%s"EMB_WHITE" from "EMB_ORANGE"%s"EMB_WHITE" for "EMB_DGREEN"%d$"EMB_WHITE"\n\nClick the 'Confirm' button if you accept the deal",BuildingArray[BuildingInfo[bid][bType]][Type],BuildingInfo[bid][bOwner],BuildingInfo[bid][bPrice]);
				Dialog_Show(playerid, dialog_BuyBuilding2, DIALOG_STYLE_MSGBOX, "Buy Building", bstr, "Confirm", "Exit");
				InBuilding[playerid] = bid;
				return 1;
			}
		}
		return 1;
	}
	if(PRESSED(KEY_SECONDARY_ATTACK))
	{
		if(IsPlayerNearBuilding(playerid, 1.0) != -1 && InBuilding[playerid] == -1)
		{
			new bid = IsPlayerNearBuilding(playerid, 1.0);
			if(BuildingInfo[bid][bLocked] == 1) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE" Building Closed!");
			InBuilding[playerid] = bid;
			SetPlayerInterior(playerid, BuildingArray[BuildingInfo[bid][bType]][bInt]);
			SetPlayerPos(playerid, BuildingArray[BuildingInfo[bid][bType]][IntPosX],BuildingArray[BuildingInfo[bid][bType]][IntPosY],BuildingArray[BuildingInfo[bid][bType]][IntPosZ]);
			SetPlayerFacingAngle(playerid, BuildingArray[BuildingInfo[bid][bType]][IntPosA]);
			SetCameraBehindPlayer(playerid);
			SetPlayerVirtualWorld(playerid, bid+1);
			return 1;
		}
		else if(IsPlayerNearBuildingExit(playerid, 1.0) != -1 && InBuilding[playerid] != -1)
		{
			new bid = IsPlayerNearBuildingExit(playerid, 1.0);
			if(BuildingInfo[bid][bLocked] == 1) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE" Building Closed!");
			SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid, BuildingInfo[bid][bPosX],BuildingInfo[bid][bPosY],BuildingInfo[bid][bPosZ]);
			InBuilding[playerid] = -1;
			SetCameraBehindPlayer(playerid);
			SetPlayerVirtualWorld(playerid, 0);
			return 1;
		}
		return 1;
	}
	if(RELEASED(KEY_SECONDARY_ATTACK))
	{
		if(IsPlayerNearBuyingPoint(playerid) != -1 && InBuilding[playerid] != -1)
		{
			new id = IsPlayerNearBuyingPoint(playerid);
			ShowPlayerBuyMenu(playerid, id);
			return 1;
		}
		return 1;
	}
	if(PRESSED(KEY_HANDBRAKE))
	{
		if(GetPlayerCameraTargetActor(playerid) != INVALID_ACTOR_ID)
		{
			if(BuildingInfo[InBuilding[playerid]][bRobbed] == 0)
			{
				new actorid = GetPlayerCameraTargetActor(playerid);
				ApplyActorAnimation(actorid, "SHOP", "SHP_HandsUp_Scr",4.1,0,0,0,1,0);
				StartRobbery(playerid, InBuilding[playerid]);
				return 1;
			}
			else return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE" The building was already robbed!");
		}
		return 1;
	}
	return 1;
}

StartRobbery(playerid, bid)
{
	if(BuildingInfo[bid][bRobbed] == 1) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE" The building was already robbed!");
	BuildingInfo[bid][bRobbed] = 1;
	SetTimerEx("ResetBuilding",1800000,false,"d",bid);
	SetPlayerAttachedObject(playerid, 0, 2295, 1,-0.122999, -0.167000, 0.049999, 0.000000, 107.599945, 2.199999, 0.250999, 0.315999, 0.798999);
	SetTimerEx("RobBuilding",30000,false,"dd",playerid,bid);
	new str[145];
	format(str,sizeof(str),""EMB_GREEN"[INFO:]"EMB_WHITE" You are robbing "EMB_ORANGE"%s"EMB_WHITE" please stay inside the building until the end!",BuildingInfo[bid][bName]);
	SendClientMessage(playerid,-1,str);
	new zone[30];
	Get2DZoneName(BuildingInfo[bid][bPosX],BuildingInfo[bid][bPosY],zone,30);
	format(str,sizeof(str), ""EMB_LIGHTBLUE"[ROBBERY:]"EMB_ORANGE" %s"EMB_LIGHTBLUE" is robbing the"EMB_ORANGE" %s"EMB_LIGHTBLUE" in "EMB_GREEN"%s"EMB_LIGHTBLUE" go stop him!",GetPlayerNameEx(playerid),BuildingInfo[bid][bName],zone);
	SendClientMessageToAll(-1, str);
	SetPlayerColor(playerid, 0x00FFFFFF);
	return 1;
}

forward RobBuilding(playerid, bid);
public RobBuilding(playerid, bid)
{
	if(InBuilding[playerid] != bid) return SendClientMessage(playerid, -1, ""EMB_RED"[ERROR:]"EMB_WHITE" You failed the robbery!");
	new str[145], rand = random(10000);
	PlayerInfo[playerid][pBagAmount] += rand;
	format(str,sizeof(str), ""EMB_GREEN"[INFO:]"EMB_WHITE" You robbed "EMB_DGREEN"%d$"EMB_WHITE" from "EMB_ORANGE"%s",rand, BuildingInfo[bid][bName]);
	SendClientMessage(playerid, -1, str);
	return 1;
}

forward ResetBuilding(bid);
public ResetBuilding(bid)
{
	BuildingInfo[bid][bRobbed] = 0;
	ClearActorAnimations(BuildingInfo[bid][bActor]);
	return 1;
}

Dialog:dialog_BuyBuilding2(playerid, response, listitem, inputtext[])
{
	if(!response)
	{
		InBuilding[playerid] = -1;
		return 1;
	}
	new bid = InBuilding[playerid];
	// GivePlayerOfflineMoney(playername, amount);
	InBuilding[playerid] = -1;
	strcpy(BuildingInfo[bid][bOwner], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
	BuildingInfo[bid][bOwned] = 1;
	BuildingInfo[bid][bOwnerID] = PlayerInfo[playerid][pID];
	new str[145];
	format(str,sizeof(str), ""EMB_GREEN"[INFO:]"EMB_WHITE" You bought the building "EMB_ORANGE"%s"EMB_WHITE"from "EMB_ORANGE"%s"EMB_WHITE" for "EMB_DGREEN"%d$",BuildingArray[BuildingInfo[bid][bType]][Type],BuildingInfo[bid][bOwner],BuildingInfo[bid][bOriginalprice]);
	SendClientMessage(playerid, -1, str);
	UpdateBuildingLabelAndPickup(bid);
	SaveBuilding(bid);
	return 1;
}

Dialog:dialog_BuyBuilding(playerid, response, listitem, inputtext[])
{
	if(!response)
	{
		InBuilding[playerid] = -1;
		return 1;
	}
	new bid = InBuilding[playerid];
	GivePlayerMoney(playerid, -BuildingInfo[bid][bOriginalprice]);
	InBuilding[playerid] = -1;
	strcpy(BuildingInfo[bid][bOwner], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
	BuildingInfo[bid][bOwned] = 1;
	BuildingInfo[bid][bOwnerID] = PlayerInfo[playerid][pID];
	new str[145];
	format(str,sizeof(str), ""EMB_GREEN"[INFO:]"EMB_WHITE" You bought the building "EMB_ORANGE"%s"EMB_WHITE" for "EMB_DGREEN"%d$",BuildingArray[BuildingInfo[bid][bType]][Type],BuildingInfo[bid][bOriginalprice]);
	SendClientMessage(playerid, -1, str);
	UpdateBuildingLabelAndPickup(bid);
	SaveBuilding(bid);
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}

GetPlayerNameEx(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

IsNumeric(const string[])
{
	for (new i = 0, j = strlen(string); i < j; i++)
	{
		if (string[i] > '9' || string[i] < '0') return 0;
	}
    return 1;
}
