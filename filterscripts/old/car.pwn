/*Car Spawner  By Falco3205*/
#define FILTERSCRIPT

#include <a_samp>

#define COLOR_ORANGE 0xF97804FF // arancione
#define COLOR_RED 0xE60000FF // rosso
#define COLOR_GIALLO 0xFFFF00AA // giallo megafono

new CarSpawn;
new pRank[256]; // 1 accademico - 2 agente lspd - 3 istruttore

public OnFilterScriptInit()
{
  		print("\n--------------------------------------");
		print(" [FILTERSCRIPT car]");
        print(" Car Spawner di Falco2305, Editato da Maxel - CARICATO");
        print("--------------------------------------\n");
}

public OnFilterScriptExit()
{
    print("\n--------------------------------------");
    print(" Car Spawner di Falco2305, Editato da Maxel - DISATTIVATO");
    print("--------------------------------------\n");

}
new VehicleName[][] = {
   "Landstalker",
   "Bravura",
   "Buffalo",
   "Linerunner",
   "Perennial",
   "Sentinel",
   "Dumper",
   "Firetruck",
   "Trashmaster",
   "Stretch",
   "Manana",
   "Infernus",
   "Voodoo",
   "Pony",
   "Mule",
   "Cheetah",
   "Ambulance",
   "Leviathan",
   "Moonbeam",
   "Esperanto",
   "Taxi",
   "Washington",
   "Bobcat",
   "MrWhoopee",
   "BFInjection",
   "Hunter",
   "Premier",
   "Enforcer",
   "Securicar",
   "Banshee",
   "Predator",
   "Bus",
   "Rhino",
   "Barracks",
   "Hotknife",
   "Trailer",
   "Previon",
   "Coach",
   "Cabbie",
   "Stallion",
   "Rumpo",
   "RCBandit",
   "Romero",
   "Packer",
   "Monster",
   "Admiral",
   "Squalo",
   "Seasparrow",
   "Pizzaboy",
   "Tram",
   "Trailer",
   "Turismo",
   "Speeder",
   "Reefer",
   "Tropic",
   "Flatbed",
   "Yankee",
   "Caddy",
   "Solair",
   "RCVan",
   "Skimmer",
   "PCJ600",
   "Faggio",
   "Freeway",
   "RCBaron",
   "RCRaider",
   "Glendale",
   "Oceanic",
   "Sanchez",
   "Sparrow",
   "Patriot",
   "Quad",
   "Coastguard",
   "Dinghy",
   "Hermes",
   "Sabre",
   "Rustler",
   "ZR350",
   "Walton",
   "Regina",
   "Comet",
   "BMX",
   "Burrito",
   "Camper",
   "Marquis",
   "Baggage",
   "Dozer",
   "Maverick",
   "NewsChopper",
   "Rancher",
   "FBIRancher",
   "Virgo",
   "Greenwood",
   "Jetmax",
   "Hotring",
   "Sandking",
   "BlistaCompact",
   "PoliceMaverick",
   "Boxville",
   "Benson",
   "Mesa",
   "RCGoblin",
   "HotringA",
   "HotringB",
   "BloodringBanger",
   "Rancher",
   "SuperGT",
   "Elegant",
   "Journey",
   "Bike",
   "MountainBike",
   "Beagle",
   "Cropdust",
   "Stunt",
   "Tanker",
   "RoadTrain",
   "Nebula",
   "Majestic",
   "Buccaneer",
   "Shamal",
   "Hydra",
   "FCR900",
   "NRG500",
   "HPV1000",
   "CementTruck",
   "TowTruck",
   "Fortune",
   "Cadrona",
   "FBITruck",
   "Willard",
   "Forklift",
   "Tractor",
   "Combine",
   "Feltzer",
   "Remington",
   "Slamvan",
   "Blade",
   "Freight",
   "Streak",
   "Vortex",
   "Vincent",
   "Bullet",
   "Clover",
   "Sadler",
   "Firetruck",
   "Hustler",
   "Intruder",
   "Primo",
   "Cargobob",
   "Tampa",
   "Sunrise",
   "Merit",
   "Utility",
   "Nevada",
   "Yosemite",
   "Windsor",
   "MonsterA",
   "MonsterB",
   "Uranus",
   "Jester",
   "Sultan",
   "Stratum",
   "Elegy",
   "Raindance",
   "RCTiger",
   "Flash",
   "Tahoma",
   "Savanna",
   "Bandito",
   "Freight",
   "Trailer",
   "Kart",
   "Mower",
   "Duneride",
   "Sweeper",
   "Broadway",
   "Tornado",
   "AT400",
   "DFT30",
   "Huntley",
   "Stafford",
   "BF400",
   "Newsvan",
   "Tug",
   "Trailer",
   "Emperor",
   "Wayfarer",
   "Euros",
   "Hotdog",
   "Club",
   "Trailer",
   "Trailer",
   "Andromada",
   "Dodo",
   "RCCam",
   "Launch",
   "LSPD",
   "SFPD",
   "LVPD",
   "PoliceRanger",
   "Picador",
   "SWAT",
   "Alpha",
   "Phoenix",
   "Glendale",
   "Sadler",
   "Trailer1",
   "Trailer2",
   "Trailer3",
   "Boxville",
   "FarmPlow",
   "UtilityTrailer"
};

stock GetVehicleIDFromName(modelname[]) {
  for (new i = 400; i <= 611; i++) {
    if (strcmp(modelname, VehicleName[i-400], true) == 0) {
      return i;
    }
  }
  return 0;
}



public OnPlayerCommandText(playerid, cmdtext[])
{

   if (strcmp("/carspawn", cmdtext, true, 10) == 0)
	{
	    if(IsPlayerAdmin(playerid) || pRank[playerid]>=3)
		{
			if(CarSpawn == true){
			CarSpawn = false;
			SendClientMessageToAll(COLOR_GIALLO, "[SERVER] Lo spawn delle auto con /car è stato disattivato per gli utenti.");
			}
			else{
			CarSpawn = true;
			SendClientMessageToAll(COLOR_GIALLO, "[SERVER] Lo spawn delle auto con /car è stato attivato per gli utenti.");
			}
		}

        return 1;
	}


new tmp[256];
new cmd[256], idx; cmd = strtok(cmdtext, idx);
new stringa[256];
if(strcmp(cmd,"/car", true)== 0)
{

if(CarSpawn == true){ // IF

  new Float:vx, Float:vy, Float:vz, vid;
  tmp = strtok(cmdtext, idx);

  if (!strlen(tmp)) return SendClientMessage(playerid, 0x00D90044, "[Uso:] /car [veicoloID/nome]");

  if (IsNumeric(tmp) == 1)
  {
    vid = strval(tmp);
  } else {
    vid = GetVehicleIDFromName(tmp);
  }
  
  if ((vid < 400) || (vid > 611) || (vid == 590) || (vid == 569) || (vid == 570) || (vid == 537) || (vid == 538) || (vid == 449))
  {
    return SendClientMessage(playerid, 0x00D90044, "[Errore] Veicolo non riconosciuto.");
  }
  else
  {
    GetPlayerPos(playerid, vx, vy, vz);
    CreateVehicle(vid, vx + random(9) - 4, vy + random(9) - 4, vz, 0, -1, -1, -1);
    new car = GetPlayerVehicleID(playerid);
    format(stringa,sizeof(stringa),"{FF0A00}T{FFFFFF}B{00FF1E}D{FFFFFF} %d",random(999));
    SetVehicleNumberPlate(car, stringa);
    PutPlayerInVehicle(playerid, car, 0);
    SendClientMessage(playerid, COLOR_ORANGE, "Hai spawnato l'auto con successo.");
        return 1;
   }
   
  }else{ // ELSE PRINCIPALE

	if(IsPlayerAdmin(playerid) || pRank[playerid]>=3){ // SE IL PLAYER E' ADMIN
	
	
  new Float:vx, Float:vy, Float:vz, vid;
  tmp = strtok(cmdtext, idx);

  if (!strlen(tmp)) return SendClientMessage(playerid, 0x00D90044, "[Uso:] /car [veicoloID/nome]");

  if (IsNumeric(tmp) == 1)
  {
    vid = strval(tmp);
  } else {
    vid = GetVehicleIDFromName(tmp);
  }

  if ((vid < 400) || (vid > 611) || (vid == 590) || (vid == 569) || (vid == 570) || (vid == 537) || (vid == 538) || (vid == 449))
  {
    return SendClientMessage(playerid, 0x00D90044, "[Errore] Veicolo non riconosciuto.");
  }
  else
  {
    GetPlayerPos(playerid, vx, vy, vz);
    CreateVehicle(vid, vx + random(9) - 4, vy + random(9) - 4, vz, 0, -1, -1, -1);
    new car = GetPlayerVehicleID(playerid);
    format(stringa,sizeof(stringa),"{FF0A00}T{FFFFFF}B{00FF1E}D{FFFFFF} %d",random(999));
    SetVehicleNumberPlate(car, stringa);
    PutPlayerInVehicle(playerid, car, 0);
    SendClientMessage(playerid, COLOR_ORANGE, "Hai spawnato l'auto con successo.");
        return 1;
   }

	
   }else{ // ALTRIMENTI

  		ErroreSpa(playerid);
	}
	
	return 1;

  }
}

return 0;
}

strtok(const string[], &index)
{
        new length = strlen(string);
        while ((index < length) && (string[index] <= ' '))
        {
                index++;
        }

        new offset = index;
        new result[20];
        while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
        {
                result[index - offset] = string[index];
                index++;
        }
        result[index - offset] = EOS;
        return result;
}

stock ErroreSpa(playerid)
{
	SendClientMessage(playerid, COLOR_RED, "[Errore] Lo spawn delle auto con /car è attualmente disattivato per gli utenti.");
}



stock IsNumeric(const string[]) {
        new length=strlen(string);
        if (length==0) return false;
        for (new i = 0; i < length; i++) {
                if (
                (string[i] > '9' || string[i] < '0' && string[i]!='-' && string[i]!='+')
                || (string[i]=='-' && i!=0)
                || (string[i]=='+' && i!=0)
                ) return false;
        }
        if (length==1 && (string[0]=='-' || string[0]=='+')) return false;
        return true;
}


