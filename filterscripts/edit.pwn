/*
 * ---- breadfishs object editor ----
 * -- copyright (c) 2011 breadfish and [BR]Allan --
 * ----- breadfish@breadfish.de -----
 *----- avs.009@gmail.com -----
 */
#include <a_samp>
#include <dutils>

// Edit this value for up or down stack size
#pragma dynamic 9216

#define OBJECT_DISTANCE 300.0

/* -- COLORS -- */
#define COLOR_RED 		0xFF0000FF
#define COLOR_YELLOW 	0xFFFF00FF
#define COLOR_GREEN 	0x00FF00FF
#define COLOR_WHITE 	0xFFFFFFFF
#define COLOR_BLUE 		0x0000FFFF

#define menu_add    	(2565) 	// Anything number unsed into other menus
#define INVALID_OBJECT 	(-1) 	// Please don't edit this value

/* -- OBJECT-EDITINGMODES -- */
#define OED_NONE 		0
#define OED_MOVE 		1
#define OED_ROTATE 		2
#define OED_MOVE_XY 	3
#define OED_MOVE_Z 		4
#define OED_ROTATE_XY 	5
#define OED_ROTATE_Z 	6

/* -- EIXOS -- */
#define AXIS_NONE 		0
#define AXIS_X 			1
#define AXIS_Y 			2
#define AXIS_Z 			3

/* -- VKEYS -- */
#define VKEY_LEFT 		32768
#define VKEY_RIGHT 		65536
#define VKEY_UP 		131072
#define VKEY_DOWN 		262144

/* -- MENUMODES -- */
#define MM_SELECT_EDITMODE 				1
#define MM_SELECT_EDITMODE_DETACHONLY 	2
#define MM_SELECT_MULTIPLIER 			3
#define MM_SELECT_ADDMODE 				4


/* -- Directory of files -- */

#define F_DIRECTORY "oed/"

/* -- Multi-Language variables -- */

#define MAX_LANGS   100

new plang[MAX_PLAYERS][256];

new Langs[MAX_LANGS][256];

new Langs_Imp=0;

enum ELANG
{
	DESC_ADD,
	DESC_COPY,
	DESC_DEL,
	DESC_DESEL,
	DESC_FAKTOR,
	DESC_GOTO,
	DESC_LANG,
	DESC_LISTLANG,
	DESC_MODE,
	DESC_NEXT,
	DESC_RELEASE,
	DESC_SEL,
	DESC_STICK,
	M_ADD,
	M_ATTACH,
	M_CANCEL,
	M_COPY,
	M_DEL,
	M_DESC_ADD_CATEGORY,
	M_DESC_ADD_MODELID,
	M_DESC_ONAME,
	M_DETACH,
	M_GOTO,
	M_MOVEXY,
	M_MOVEZ,
	M_MULT,
	M_NEXTPAGE,
	M_NEXT,
	M_ONAME_TITLE,
	M_RELOADALL,
	M_ROTXY,
	M_ROTZ,
	M_SELECT,
	M_VIEW,
	MSG_ADD_OPEN,
	MSG_ADDED,
	MSG_CANCELED,
	MSG_COPY,
	MSG_COMMANDS,
	MSG_DELETED,
	MSG_DESELECTED,
	MSG_EXISTS,
	MSG_FNOTFOUND,
	MSG_LANG,
	MSG_LANGDEF,
	MSG_LANGSEL,
	MSG_LANGINV,
	MSG_MOVEENABLED,
	MSG_MOVEDISABLED,
    MSG_MULTIPLER,
	MSG_NOSELECTED,
	MSG_NEWMODE,
	MSG_NEAREST,
	MSG_NOTFOUND,
	MSG_PAGE,
	MSG_RELEASE,
	MSG_SAVEDALL,
	MSG_SELECTED,
	MSG_STICK,
	MSG_SYNTAX
};

/* -- FORWARDS -- */
forward Float:strflt(string[]);
forward Float:GetDistanceBetweenCoords(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2);
forward Float:FloatBubbleSort(Float:lArray[MAX_OBJECTS][2], lArraySize);
//Timer
forward ObjectEditTimer(playerid, editmode, axis, Float:value);
forward UpDownLeftRightAdditionTimer();
forward SetObjectCoords(playerid, obj_id);

//Objectdaten
enum OBJECTDATA() {
	id_o,
    ModelID,
    Float:obj_x,
    Float:obj_y,
    Float:obj_z,
    Float:rot_x,
    Float:rot_y,
    Float:rot_z,
    Name[MAX_STRING],
    bool:savetofile
}
//Player data
enum PLAYERDATA {
    Name[25],
    //Level,
    vfile[256],
	vindex,
	id_sel
}

//currently edited object
enum EDITINGOBJECT {
    object_id,
    mode,
    bool:domove,
    Float:movestep,
    Float:rotatestep,
    Float:StickDistance,
    Float:EditMultiplier,
    bool:stuck
}

// Vars used into menu objects
new listcat[4096], lista[MAX_PLAYERS][4096];

//datenhaltung
new gPlayer[MAX_PLAYERS][PLAYERDATA];   //player-infos
new gObjects[150][OBJECTDATA];          //Objecte

new gEditingObject[MAX_PLAYERS][EDITINGOBJECT];
new gObjectEditTimer[MAX_PLAYERS];
new gCameraSetTimer[MAX_PLAYERS];
new gLastPlayerKeys[MAX_PLAYERS][2];
new bool:gPlayerMenu[MAX_PLAYERS];
new gSelectedMultiplier[MAX_PLAYERS];
new Menu:gMenus[MAX_PLAYERS];
new gMenuMode[MAX_PLAYERS];

//limits
new gObjectCount=0;
//Timer ids
new Timer;

/*---------------------------------------------------------------------------------------------------*/

public OnFilterScriptInit() {
	ReadLangs();
	ReadListObjetects(listcat);
    ReadObjects();
    Timer = SetTimer("UpDownLeftRightAdditionTimer", 50, 1);
   	for(new playerid=0; playerid<MAX_PLAYERS; playerid++)
		OnPlayerConnect(playerid);
    print("+----------------------------+");
    print("| Object Editor Filterscript |");
    print("|       by breadfish and     |");
    print("|     Edited by [BR]Allan    |");
    print("|         Revision  8        |");
    print("|           LOADED!          |");
    print("+----------------------------+");
    return 1;
}
/*---------------------------------------------------------------------------------------------------*/

public OnFilterScriptExit() {
	for(new playerid=0; playerid<MAX_PLAYERS; playerid++)
		CancelEditObject(playerid);
	SaveObjects();
    DestroyObjects();
    KillTimer(Timer);
    print("+----------------------------+");
    print("| Object Editor Filterscript |");
    print("|       by breadfish and     |");
    print("|     Edited by [BR]Allan    |");
    print("|         Revision  8        |");
    print("|          UNLOADED!         |");
    print("+----------------------------+");
}    

/*---------------------------------------------------------------------------------------------------*/

public OnPlayerConnect(playerid) {
    new name[25];

    GetPlayerName(playerid, name, sizeof name);

    //reset playerdata
    gPlayer[playerid][Name] = name;
    gEditingObject[playerid][domove] = false;
    gPlayerMenu[playerid] = false;
    gEditingObject[playerid][EditMultiplier]  = 1;
    gSelectedMultiplier[playerid] = 3;
    gEditingObject[playerid][object_id] = INVALID_OBJECT;
    set(plang[playerid],Langs[0]);
    return 1;
}

/*---------------------------------------------------------------------------------------------------*/

public OnPlayerText(playerid, text[]) {
    return 1;
}

/*---------------------------------------------------------------------------------------------------*/

public OnPlayerCommandText(playerid, cmdtext[]) {
    new cmd[MAX_STRING], idx;
    new syntax[MAX_STRING];
    new Float:x, Float:y, Float:z, Float:angle;
    new msg[MAX_STRING];

    //wird immer mal wieder gebraucht...
    if (IsPlayerInAnyVehicle(playerid)) {
        GetVehiclePos(GetPlayerVehicleID(playerid),x, y, z);
        GetVehicleZAngle(GetPlayerVehicleID(playerid), angle);
    } 
    else {
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, angle);
    }

    cmd = strtok(cmdtext, idx);

    if (IsPlayerAdmin(playerid)) {

        // Objecte erzeugen
        if (strcmp(cmd, "/oadd", true) == 0) {
            new modelid, name[MAX_STRING], newoid;
            set(syntax,GetLMsg(playerid,MSG_SYNTAX));
			strcat(syntax,"/oadd ");
			strcat(syntax,GetLMsg(playerid,DESC_ADD));

            //modelid
            cmd = strtok(cmdtext, idx);
            if (!(strlen(cmd))) {
                SystemMessage(playerid, GetLMsg(playerid,MSG_ADD_OPEN), COLOR_YELLOW);
                ShowPlayerDialog(playerid, menu_add, DIALOG_STYLE_LIST, GetLMsg(playerid,M_DESC_ADD_CATEGORY), listcat, GetLMsg(playerid,M_VIEW), GetLMsg(playerid,M_CANCEL));
                return 1;
            } else {
                modelid = strval(cmd);
            }

            //name
            strmid(cmd, cmdtext, idx, strlen(cmdtext));
            if (!(strlen(cmd))) {
                SystemMessage(playerid, syntax, COLOR_YELLOW);
                return 1;
            } else {
                name = cmd;
            }
            
            for (new i=0;i<gObjectCount;i++) {
                if (strlen(gObjects[i][Name]) != 0 && strcmp(gObjects[i][Name], name, true) == 0){
                    SystemMessage(playerid, GetLMsg(playerid,MSG_EXISTS), COLOR_RED);
                    return 1;
                } 
            }

			CancelEditObject(playerid);

            newoid = AddNewObjectToScript(modelid, x, y + 2, z, 0, 0, 0, name);
            gEditingObject[playerid][object_id] = newoid;
            if (gEditingObject[playerid][mode] == OED_NONE) gEditingObject[playerid][mode] = OED_MOVE_XY;
            gEditingObject[playerid][EditMultiplier]  = 1;
	    	gSelectedMultiplier[playerid] = 3;
            gEditingObject[playerid][movestep] = 0.05;
            gEditingObject[playerid][rotatestep] = 1.0;
            gObjects[newoid][savetofile] = true;
            if (gEditingObject[playerid][EditMultiplier] == 0) gEditingObject[playerid][EditMultiplier] = 1;

            SaveObjects();

            format(msg, sizeof msg, "'%s' ModelID: %d - %s ", name, gObjects[newoid][ModelID], GetLMsg(playerid,MSG_ADDED));
            SystemMessage(playerid, msg, COLOR_GREEN);

            return 1;
        }
        
        else if (strcmp(cmd, "/olang", true) == 0) {
        	new id;
        	set(syntax, GetLMsg(playerid,MSG_SYNTAX));
        	strcat(syntax, ": /olang ");
            strcat(syntax, GetLMsg(playerid,DESC_LANG));

            //name
            cmd = strtok(cmdtext, idx);
            if (!(strlen(cmd))) {
                SystemMessage(playerid, syntax, COLOR_YELLOW);
                return 1;
            } else {
                id = strval(cmd);
                if(id < Langs_Imp)
                {
					set(plang[playerid], Langs[id]);
					SystemMessage(playerid, GetLMsg(playerid, MSG_LANGSEL), COLOR_YELLOW);
				}
				else
				    SystemMessage(playerid, GetLMsg(playerid, MSG_LANGINV), COLOR_RED);
            }
            return 1;
        }
        
        else if (strcmp(cmd, "/olistlangs", true) == 0) {
            new str[256];
            SystemMessage(playerid, GetLMsg(playerid,MSG_LANG), COLOR_GREEN);
			format(str, sizeof(str), "0 - %s - %s", Langs[0], GetLMsg(playerid,MSG_LANGDEF));
            SystemMessage(playerid, str, COLOR_YELLOW);
            for(new i=1; i<Langs_Imp; i++)
            {
                format(str, sizeof(str), "%d - %s", i, Langs[i]);
				SystemMessage(playerid, str, COLOR_YELLOW);
			}
			return 1;
        }

        // Objecte kopieren
        else if (strcmp(cmd, "/ocopy", true) == 0) {
            new name[MAX_STRING], newoid;
            new Float:rx, Float:ry, Float:rz;
        	set(syntax, GetLMsg(playerid,MSG_SYNTAX));
        	strcat(syntax, ": /ocopy ");
            strcat(syntax, GetLMsg(playerid,DESC_COPY));

            //name
            strmid(cmd, cmdtext, 7, strlen(cmdtext));
            if (!(strlen(cmd))) {
                SystemMessage(playerid, syntax, COLOR_YELLOW);
                return 1;
            } else {
                name = cmd;
            }

            CancelEditObject(playerid);

            x = gObjects[gEditingObject[playerid][object_id]][obj_x];
            y = gObjects[gEditingObject[playerid][object_id]][obj_y];
            z = gObjects[gEditingObject[playerid][object_id]][obj_z];
            rx = gObjects[gEditingObject[playerid][object_id]][rot_x];
            ry = gObjects[gEditingObject[playerid][object_id]][rot_y];
            rz = gObjects[gEditingObject[playerid][object_id]][rot_z];

            newoid = AddNewObjectToScript(gObjects[gEditingObject[playerid][object_id]][ModelID], x, y, z, rx, ry, rz, name);
            gEditingObject[playerid][object_id] = newoid;
            if (gEditingObject[playerid][mode] == OED_NONE) gEditingObject[playerid][mode] = OED_MOVE_XY;
            gEditingObject[playerid][movestep] = 0.05;
            gEditingObject[playerid][rotatestep] = 1.0;
            
            gEditingObject[playerid][EditMultiplier]  = 1;
	    	gSelectedMultiplier[playerid] = 3;
	    	
            gObjects[newoid][savetofile] = true;
            if (gEditingObject[playerid][EditMultiplier] == 0) gEditingObject[playerid][EditMultiplier] = 1;

            SaveObjects();

            format(msg, sizeof msg, "'%s' ModelID: %d - %s", name, gObjects[newoid][ModelID], GetLMsg(playerid,MSG_COPY));
            SystemMessage(playerid, msg, COLOR_GREEN);

            return 1;
        }

        // Object löschen
        else if (strcmp(cmd, "/odel", true) == 0) {
            if (gEditingObject[playerid][object_id] > INVALID_OBJECT) {
                new oid = gEditingObject[playerid][object_id];
                format(msg, sizeof msg, "'%s' (ModelID:%d) - %s",  gObjects[oid][Name], gObjects[oid][ModelID], GetLMsg(playerid,MSG_DELETED));
                gObjects[oid][savetofile] = false;
                gEditingObject[playerid][object_id] = INVALID_OBJECT;

                CancelEditObject(playerid);

                DestroyObjects();
                ReadObjects();
                SystemMessage(playerid, msg, COLOR_GREEN);
                return 1;
            } else {
                SystemMessage(playerid, GetLMsg(playerid,MSG_NOSELECTED), COLOR_YELLOW);
                return 1;
            }
        }

        // bearbeitungsmodus setzen
        else if (strcmp(cmd, "/omode", true) == 0) {
            if (gEditingObject[playerid][object_id] > INVALID_OBJECT) {
                new newmode;
           		set(syntax, GetLMsg(playerid,MSG_SYNTAX));
        		strcat(syntax, ": /omode [m_xy|m_z|r_xy|r_z]: ");
            	strcat(syntax, GetLMsg(playerid,DESC_MODE));

                //mode
                cmd = strtok(cmdtext, idx);
                if (!(strlen(cmd))) {
                    SystemMessage(playerid, syntax, COLOR_YELLOW);
                    return 1;
                } else {
                    if (strcmp(cmd, "m_xy", true) == 0) newmode = OED_MOVE_XY;
                    if (strcmp(cmd, "m_z", true) == 0) newmode = OED_MOVE_Z;
                    if (strcmp(cmd, "r_xy", true) == 0) newmode = OED_ROTATE_XY;
                    if (strcmp(cmd, "r_z", true) == 0) newmode = OED_ROTATE_Z;
                }

                if (!(newmode == 0)) {
                    gEditingObject[playerid][mode] = newmode;

                    SystemMessage(playerid, GetLMsg(playerid,MSG_NEWMODE), COLOR_GREEN);
                    return 1;
                } else {
                    SystemMessage(playerid, syntax, COLOR_YELLOW);
                    return 1;
                }
            } else {
                SystemMessage(playerid, GetLMsg(playerid,MSG_NOSELECTED), COLOR_YELLOW);
            }
        }

        // Objecte in der umgebung zeigen
        else if (strcmp(cmd, "/onext", true) == 0) {
            new objects[24], oid, objnames[MAX_STRING];
            objects = GetPlayerNearestObjects(playerid);

            for (new i=0;(i<gObjectCount) && (i<24);i++) {
                oid = objects[i];

                strcat(objnames, gObjects[oid][Name]);
                strcat(objnames, ", ");
            }

            if (strlen(objnames)) {
                strmid(objnames, objnames, 0, strlen(objnames) - 2);
            }

            format(objnames, sizeof objnames, "%s %s", objnames, GetLMsg(playerid,MSG_NEAREST));
            SystemMessage(playerid, objnames, COLOR_YELLOW);
            return 1;
        }

        //Object zum bearbeiten auswählen
        else if (strcmp(cmd, "/osel", true) == 0) {
            new name[MAX_STRING], oid;
            set(syntax, GetLMsg(playerid,MSG_SYNTAX));
        	strcat(syntax, ": /osel ");
            strcat(syntax, GetLMsg(playerid,DESC_SEL));

            //name
            strmid(cmd, cmdtext, 6, strlen(cmdtext));
            if (!(strlen(cmd))) {
                SystemMessage(playerid, syntax, COLOR_YELLOW);
                return 1;
            } else {
                name = cmd;
            }
            
			new i;
            for (i=0;i<gObjectCount;i++) {
                if (strlen(gObjects[i][Name]) != 0 && strcmp(gObjects[i][Name], name, true) == 0){
                    oid = i;
                    break;
                } 
            }

            if (i < gObjectCount) {
                CancelEditObject(playerid);

                gEditingObject[playerid][object_id] = oid;
                if (gEditingObject[playerid][mode] == OED_NONE) gEditingObject[playerid][mode] = OED_MOVE_XY;
                gEditingObject[playerid][movestep] = 0.05;
                gEditingObject[playerid][rotatestep] = 1.0;
                
                gEditingObject[playerid][EditMultiplier]  = 1;
	    		gSelectedMultiplier[playerid] = 3;

                format(msg, sizeof msg, "'%s' (ModelID: %d) - %s", name, gObjects[oid][ModelID], GetLMsg(playerid,MSG_SELECTED));
                SystemMessage(playerid, msg, COLOR_GREEN);
                return 1;
            } else {
                format(msg, sizeof msg, "'%s' %s", name, GetLMsg(playerid,MSG_NOTFOUND));
                SystemMessage(playerid, msg, COLOR_YELLOW);
                return 1;
            }
        }
        
        //deselect a object
        else if (strcmp(cmd, "/odesel",true) == 0){
            new oid = gEditingObject[playerid][object_id];
            if(oid > INVALID_OBJECT)
            {
                format(msg, sizeof msg, "'%s' (ModelID:%d) - ",  gObjects[oid][Name], gObjects[oid][ModelID], GetLMsg(playerid,MSG_DESELECTED));
                gEditingObject[playerid][object_id] = INVALID_OBJECT;
                gEditingObject[playerid][mode] = OED_NONE;
                
		        CancelEditObject(playerid);
            }
            else
                format(msg, sizeof msg,GetLMsg(playerid,MSG_NOSELECTED));
            SystemMessage(playerid, msg, COLOR_YELLOW);
            return 1;
        }
        
        //goto to a objeckt by name
        else if (strcmp(cmd, "/ogoto", true) == 0) {
            new name[MAX_STRING], oid;
            set(syntax, GetLMsg(playerid,MSG_SYNTAX));
        	strcat(syntax, ": /ogoto ");
            strcat(syntax, GetLMsg(playerid,DESC_GOTO));

            //name
            strmid(cmd, cmdtext, 7, strlen(cmdtext));
            if (!(strlen(cmd))) {
                SystemMessage(playerid, syntax, COLOR_YELLOW);
                return 1;
            } else {
                name = cmd;
            }
            
			new i;
            for (i=0;i<gObjectCount;i++) {
                if (strlen(gObjects[i][Name]) && strcmp(gObjects[i][Name], name, true) == 0){
                    oid = i;
                    break;
                }
            }

            if (i < gObjectCount) {
            
                CancelEditObject(playerid);

                gEditingObject[playerid][object_id] = oid;
                if (gEditingObject[playerid][mode] == OED_NONE) gEditingObject[playerid][mode] = OED_MOVE_XY;
                gEditingObject[playerid][movestep] = 0.05;
                gEditingObject[playerid][rotatestep] = 1.0;
                
                gEditingObject[playerid][EditMultiplier]  = 1;
	    		gSelectedMultiplier[playerid] = 3;
	    	
                new Float:lx,Float:ly,Float:lz;
                lx = gObjects[gEditingObject[playerid][object_id]][obj_x];
                ly = gObjects[gEditingObject[playerid][object_id]][obj_y];
                lz = gObjects[gEditingObject[playerid][object_id]][obj_z];
                SetPlayerPos(playerid,lx,ly,lz);

                format(msg, sizeof msg, "'%s' (ModelID: %d) - %s", name, gObjects[oid][ModelID], GetLMsg(playerid,MSG_SELECTED));
                SystemMessage(playerid, msg, COLOR_GREEN);
                return 1;
            } else {
                format(msg, sizeof msg, "'%s' %s", name, GetLMsg(playerid,MSG_NOTFOUND));
                SystemMessage(playerid, msg, COLOR_YELLOW);
                return 1;
            }
        }        

        //Object an player pappen
        else if (strcmp(cmd, "/ostick", true) == 0) {
            new Float:distance;
            set(syntax, GetLMsg(playerid,MSG_SYNTAX));
        	strcat(syntax, ": /ostick ");
            strcat(syntax, GetLMsg(playerid,DESC_STICK));
            //distance
            cmd = strtok(cmdtext, idx);
            if (!(strlen(cmd))) {
                distance = 2;
            } else {
                distance = floatstr(cmd);
            }

            CancelEditObject(playerid);

            gEditingObject[playerid][StickDistance] = distance;
            gEditingObject[playerid][stuck] = true;

            AttachObjectToPlayer(gObjects[gEditingObject[playerid][object_id]][id_o],playerid, 0, gEditingObject[playerid][StickDistance], 0, 0, 0, 0);
            
            SystemMessage(playerid, GetLMsg(playerid,MSG_STICK), COLOR_YELLOW);
            return 1;
        }

        //objeckt lösen
        else if (strcmp(cmd, "/orelease", true) == 0) {
            new oid;
            new model_id;
            new Float:x2, Float:y2;
            new objname[MAX_STRING];

            if (gEditingObject[playerid][stuck]) {
                gEditingObject[playerid][stuck] = false;

                oid = gEditingObject[playerid][object_id];
                model_id = gObjects[oid][ModelID];
                format(objname, sizeof objname, "%s", gObjects[oid][Name]);

                x2 = x + (gEditingObject[playerid][StickDistance] * floatsin(-angle, degrees));
                y2 = y + (gEditingObject[playerid][StickDistance] * floatcos(-angle, degrees));

                DestroyObject(gObjects[oid][id_o]);

                oid = AddNewObjectToScript(model_id, x2, y2, z, 0, 0, angle, objname, oid);
                gEditingObject[playerid][mode] = OED_MOVE_XY;
                gEditingObject[playerid][movestep] = 0.05;
                gEditingObject[playerid][rotatestep] = 1.0;
                gObjects[oid][savetofile] = true;

                SaveObjects();
                
                SystemMessage(playerid, GetLMsg(playerid,MSG_RELEASE), COLOR_YELLOW);
            }
            return 1;
        }

        //multiplikator setzen
        else if (strcmp(cmd, "/ofaktor", true) == 0) {
        	set(syntax, GetLMsg(playerid,MSG_SYNTAX));
        	strcat(syntax, ": /ofaktor ");
            strcat(syntax, GetLMsg(playerid,DESC_FAKTOR));
            new Float:mul;

            //mul
            cmd = strtok(cmdtext, idx);
            if (!(strlen(cmd))) {
                SystemMessage(playerid, syntax, COLOR_YELLOW);
                return 1;
            } else {
                mul = floatstr(cmd);
            }

            gEditingObject[playerid][EditMultiplier] = mul;
            format(msg, sizeof msg, "%f %s", mul, GetLMsg(playerid,MSG_MULTIPLER));
            SystemMessage(playerid, msg, COLOR_GREEN);
            return 1;
        }
        //help command
        else if (strcmp(cmd, "/ohelp", true) == 0) {
            SystemMessage(playerid, GetLMsg(playerid,MSG_COMMANDS), COLOR_YELLOW);
            
            format(msg, sizeof(msg), "/oadd %s", GetLMsg(playerid,DESC_ADD));
            SystemMessage(playerid, msg, COLOR_YELLOW);
            
            format(msg, sizeof(msg), "/ocopy %s", GetLMsg(playerid,DESC_ADD));
            SystemMessage(playerid, msg, COLOR_YELLOW);
            
            format(msg, sizeof(msg), "/odel %s", GetLMsg(playerid,DESC_DEL));
            SystemMessage(playerid, msg, COLOR_YELLOW);
            
            format(msg, sizeof(msg), "/olang [id] %s", GetLMsg(playerid,DESC_LANG));
            SystemMessage(playerid, msg, COLOR_YELLOW);
            
            format(msg, sizeof(msg), "/olistlangs %s", GetLMsg(playerid,DESC_LISTLANG));
            SystemMessage(playerid, msg, COLOR_YELLOW);
            
            format(msg, sizeof(msg), "/omode [m_xy|m_z|r_xy|r_z] %s", GetLMsg(playerid,DESC_MODE));
            SystemMessage(playerid, msg, COLOR_YELLOW);
            
            format(msg, sizeof(msg), "/onext %s", GetLMsg(playerid,DESC_NEXT));
            SystemMessage(playerid, msg, COLOR_YELLOW);
            
            format(msg, sizeof(msg), "/osel %s", GetLMsg(playerid,DESC_SEL));
            SystemMessage(playerid, msg, COLOR_YELLOW);
            
            format(msg, sizeof(msg), "/odesel %s", GetLMsg(playerid,DESC_DESEL));
            SystemMessage(playerid, msg, COLOR_YELLOW);
            
            format(msg, sizeof(msg), "/ostick %s", GetLMsg(playerid,DESC_STICK));
            SystemMessage(playerid, msg, COLOR_YELLOW);
            
            format(msg, sizeof(msg), "/orelease %s", GetLMsg(playerid,DESC_RELEASE));
            SystemMessage(playerid, msg, COLOR_YELLOW);
            
            format(msg, sizeof(msg), "/ofaktor %s", GetLMsg(playerid,DESC_FAKTOR));
            SystemMessage(playerid, msg, COLOR_YELLOW);
            
            format(msg, sizeof(msg), "/ogoto %s", GetLMsg(playerid,DESC_GOTO));
            SystemMessage(playerid, msg, COLOR_YELLOW);
            return 1;
        }
        //save all objects in memory
        else if (strcmp(cmd, "/osaveall", true) == 0) {
            SaveObjects();          
            format(msg, sizeof msg, "%d %s", gObjectCount, GetLMsg(playerid,MSG_SAVEDALL));
            SystemMessage(playerid, msg, COLOR_GREEN);
            return 1;
        }        
    }

    return 0;
}

/*---------------------------------------------------------------------------------------------------*/

stock CancelEditObject(playerid)
{
	if(!IsPlayerConnected(playerid))
	    return;
	new oid = gEditingObject[playerid][object_id];
	if (!(gObjectEditTimer[playerid] == 0)) {
	    KillTimer(gObjectEditTimer[playerid]);
		gObjectEditTimer[playerid] = 0;
	}
	if (!(gCameraSetTimer[playerid] == 0)) {
		KillTimer(gCameraSetTimer[playerid]);
		gCameraSetTimer[playerid] = 0;
		SetCameraBehindPlayer(playerid);
	}
	if(oid > INVALID_OBJECT)
		StopObject(gObjects[oid][id_o]);
		
	if(gEditingObject[playerid][domove])
		gEditingObject[playerid][domove] = false;
	
	if (gEditingObject[playerid][stuck]) {
	    new Float:x, Float:y, Float:z, Float:angle;

	    if (IsPlayerInAnyVehicle(playerid)) {
	        GetVehiclePos(GetPlayerVehicleID(playerid),x, y, z);
	        GetVehicleZAngle(GetPlayerVehicleID(playerid), angle);
	    }
	    else {
	        GetPlayerPos(playerid, x, y, z);
	        GetPlayerFacingAngle(playerid, angle);
	    }
	    
 		new model_id;
		new Float:x2, Float:y2;
        new objname[MAX_STRING];

	    gEditingObject[playerid][stuck] = false;

	    model_id = gObjects[oid][ModelID];
	    
	    set(objname, gObjects[oid][Name]);

	    x2 = x + (gEditingObject[playerid][StickDistance] * floatsin(-angle, degrees));
	    y2 = y + (gEditingObject[playerid][StickDistance] * floatcos(-angle, degrees));

	    DestroyObject(gObjects[oid][id_o]);

	    oid = AddNewObjectToScript(model_id, x2, y2, z, 0, 0, angle, objname, oid);
	    gEditingObject[playerid][mode] = OED_MOVE_XY;
	    gEditingObject[playerid][movestep] = 0.05;
	    gEditingObject[playerid][rotatestep] = 1.0;
	    gObjects[oid][savetofile] = true;
	}
	
	TogglePlayerControllable(playerid, 1);
	
	SaveObjects();
}

/*---------------------------------------------------------------------------------------------------*/

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

    new msg[MAX_STRING];
    new axis_updown, axis_leftright;
    new editmode;
    new Float:value;
    new Float:x, Float:y, Float:z, Float:angle;

    if (IsPlayerInAnyVehicle(playerid)) {
        GetVehiclePos(GetPlayerVehicleID(playerid),x, y, z);
        GetVehicleZAngle(GetPlayerVehicleID(playerid), angle);
    } else {
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, angle);
    }

    if (IsPlayerAdmin(playerid)) 
    {
            if ((gEditingObject[playerid][object_id]) > INVALID_OBJECT)
			{
                new oid = gEditingObject[playerid][object_id];

                if ((gEditingObject[playerid][domove]) && (!gPlayerMenu[playerid]))  {
                    switch(gEditingObject[playerid][mode]) {
                    case OED_MOVE_XY:
                        {
                            editmode = OED_MOVE;
                            axis_updown = AXIS_Y;
                            axis_leftright = AXIS_X;
                            value = gEditingObject[playerid][movestep];
                        }
                    case OED_MOVE_Z:
                        {
                            editmode = OED_MOVE;
                            axis_updown = AXIS_Z;
                            axis_leftright = AXIS_NONE;
                            value = gEditingObject[playerid][movestep];
                        }
                    case OED_ROTATE_XY:
                        {
                            editmode = OED_ROTATE;
                            axis_updown = AXIS_X;
                            axis_leftright = AXIS_Y;
                            value = gEditingObject[playerid][rotatestep];
                        }
                    case OED_ROTATE_Z:
                        {
                            editmode = OED_ROTATE;
                            axis_updown = AXIS_NONE;
                            axis_leftright = AXIS_Z;
                            value = gEditingObject[playerid][rotatestep];
                        }
                    }

                    if (!(gObjectEditTimer[playerid] == 0)) {
                        axis_updown = AXIS_NONE;
                        axis_leftright = AXIS_NONE;
                    }

                    //hoch+runter
                    if (newkeys & VKEY_UP) {
                        if (editmode == OED_ROTATE) {
                            if (!(axis_updown == AXIS_NONE)) gObjectEditTimer[playerid] = SetTimerEx("ObjectEditTimer", 50, 1, "iiif", playerid, editmode, axis_updown, value);
                        } else if (editmode == OED_MOVE) {
                            switch (axis_updown) {
                            case AXIS_Y: MoveObject(gObjects[oid][id_o], gObjects[oid][obj_x],gObjects[oid][obj_y]+2000,gObjects[oid][obj_z],value*gEditingObject[playerid][EditMultiplier]*10);
                            case AXIS_Z: MoveObject(gObjects[oid][id_o], gObjects[oid][obj_x],gObjects[oid][obj_y],gObjects[oid][obj_z]+2000,value*gEditingObject[playerid][EditMultiplier]*10);
                            }
                        }
                    }
                    if (newkeys & VKEY_DOWN) {
                        if (editmode == OED_ROTATE) {
                            if (!(axis_updown == AXIS_NONE)) gObjectEditTimer[playerid] = SetTimerEx("ObjectEditTimer", 50, 1, "iiif", playerid, editmode, axis_updown, -value);
                        } else if (editmode == OED_MOVE) {
                            switch (axis_updown) {
                            case AXIS_Y: MoveObject(gObjects[oid][id_o], gObjects[oid][obj_x],gObjects[oid][obj_y]-2000,gObjects[oid][obj_z],value*gEditingObject[playerid][EditMultiplier]*10);
                            case AXIS_Z: MoveObject(gObjects[oid][id_o], gObjects[oid][obj_x],gObjects[oid][obj_y],gObjects[oid][obj_z]-2000,value*gEditingObject[playerid][EditMultiplier]*10);
                            }
                        }
                    }
                    //links+rechts
                    if (newkeys & VKEY_LEFT) {
                        if (editmode == OED_ROTATE) {
                            if (!(axis_leftright == AXIS_NONE)) gObjectEditTimer[playerid] = SetTimerEx("ObjectEditTimer", 50, 1, "iiif", playerid, editmode, axis_leftright, -value);
                        } else if (editmode == OED_MOVE) {
                            switch (axis_leftright) {
                            case AXIS_X: MoveObject(gObjects[oid][id_o], gObjects[oid][obj_x]-2000,gObjects[oid][obj_y],gObjects[oid][obj_z],value*gEditingObject[playerid][EditMultiplier]*10);
                            }
                        }
                    }
                    if (newkeys & VKEY_RIGHT) {
                        if (editmode == OED_ROTATE) {
                            if (!(axis_leftright == AXIS_NONE)) gObjectEditTimer[playerid] = SetTimerEx("ObjectEditTimer", 50, 1, "iiif", playerid, editmode, axis_leftright, value);
                        } else if (editmode == OED_MOVE) {
                            switch (axis_leftright) {
                            case AXIS_X: MoveObject(gObjects[oid][id_o], gObjects[oid][obj_x]+2000,gObjects[oid][obj_y],gObjects[oid][obj_z],value*gEditingObject[playerid][EditMultiplier]*10);
                            }
                        }
                    }


                    if ((oldkeys & VKEY_UP) |
                        (oldkeys & VKEY_DOWN) |
                        (oldkeys & VKEY_LEFT) |
                        (oldkeys & VKEY_RIGHT))  {

                        if (!(gObjectEditTimer[playerid] == 0)) {
                            KillTimer(gObjectEditTimer[playerid]);
                            gObjectEditTimer[playerid] = 0;
                        }

                        StopObject(gObjects[oid][id_o]);
                        SaveObjects();
                    }
                }

                if (newkeys & KEY_WALK) {
                        format(msg, sizeof msg, "- %s -", gObjects[gEditingObject[playerid][object_id]][Name]);
                        gMenus[playerid] = CreateMenu(msg, 1, 350, 190, 250, 0);
                        if (gEditingObject[playerid][stuck]) {
                            AddMenuItem(gMenus[playerid], 0, GetLMsg(playerid,M_DETACH));
                            gMenuMode[playerid] = MM_SELECT_EDITMODE_DETACHONLY;
                        } else {
                            AddMenuItem(gMenus[playerid], 0, GetLMsg(playerid,M_ATTACH));
                            AddMenuItem(gMenus[playerid], 0, GetLMsg(playerid,M_MOVEXY));
                            AddMenuItem(gMenus[playerid], 0, GetLMsg(playerid,M_MOVEZ));
                            AddMenuItem(gMenus[playerid], 0, GetLMsg(playerid,M_ROTXY));
                            AddMenuItem(gMenus[playerid], 0, GetLMsg(playerid,M_ROTZ));
                            AddMenuItem(gMenus[playerid], 0, GetLMsg(playerid,M_ADD));
                            AddMenuItem(gMenus[playerid], 0, GetLMsg(playerid,M_COPY));
                            AddMenuItem(gMenus[playerid], 0, GetLMsg(playerid,M_DEL));
                            AddMenuItem(gMenus[playerid], 0, GetLMsg(playerid,M_MULT));
                            AddMenuItem(gMenus[playerid], 0, GetLMsg(playerid,M_CANCEL));
                            AddMenuItem(gMenus[playerid], 0, GetLMsg(playerid,M_GOTO));

                            gMenuMode[playerid] = MM_SELECT_EDITMODE;
                        }
                        if (!(gObjectEditTimer[playerid] == 0)) {
                            KillTimer(gObjectEditTimer[playerid]);
                            gObjectEditTimer[playerid] = 0;
                        }

                        StopObject(gObjects[oid][id_o]);
                        SaveObjects();

                        TogglePlayerControllable(playerid, 0);
                        ShowMenuForPlayer(gMenus[playerid], playerid);
                        gPlayerMenu[playerid] = true;
                }

                if (newkeys & KEY_CROUCH) {
                    gEditingObject[playerid][domove] = !gEditingObject[playerid][domove];
                    if (gEditingObject[playerid][domove]) {
                        format(msg, sizeof msg, "%s - %s", gObjects[gEditingObject[playerid][object_id]][Name], GetLMsg(playerid,MSG_MOVEENABLED));
                        OnPlayerCommandText(playerid, "/orelease");
                        TogglePlayerControllable(playerid, 0);
                        if (gCameraSetTimer[playerid] == 0) gCameraSetTimer[playerid] = SetTimerEx("SetObjectCoords", 25, 1, "ii", playerid, oid);
                    } else {
                        CancelEditObject(playerid);

                        format(msg, sizeof msg, "%s - %s", gObjects[gEditingObject[playerid][object_id]][Name], GetLMsg(playerid,MSG_MOVEDISABLED));
                    }
                    SystemMessage(playerid, msg, COLOR_YELLOW);
                }
            }
            else if (newkeys & KEY_WALK)
            {
                gMenus[playerid] = CreateMenu(GetLMsg(playerid,M_SELECT), 1, 350, 200, 250, 0);
                AddMenuItem(gMenus[playerid], 0, GetLMsg(playerid,M_ADD));
                AddMenuItem(gMenus[playerid], 0, GetLMsg(playerid,M_RELOADALL));
                AddMenuItem(gMenus[playerid], 0, GetLMsg(playerid,M_MULT));
                AddMenuItem(gMenus[playerid], 0, GetLMsg(playerid,M_CANCEL));
                gMenuMode[playerid] = MM_SELECT_ADDMODE;
				TogglePlayerControllable(playerid, 0);
                ShowMenuForPlayer(gMenus[playerid], playerid);
    			gPlayerMenu[playerid] = true;
            }
    }

    return 1;
}

/*---------------------------------------------------------------------------------------------------*/

public OnPlayerExitedMenu(playerid) {
	if(gPlayerMenu[playerid])
	{
	    HideMenuForPlayer(gMenus[playerid], playerid);
	    DestroyMenu(gMenus[playerid]);
	 	gPlayerMenu[playerid] = false;
 		TogglePlayerControllable(playerid, !(gEditingObject[playerid][domove]));
 	}
    return 1;
}

/*---------------------------------------------------------------------------------------------------*/

public OnPlayerSelectedMenuRow(playerid, row) {
    new Menu:current = GetPlayerMenu(playerid);
    
    if(current == gMenus[playerid])
    {
	 	TogglePlayerControllable(playerid, !(gEditingObject[playerid][domove]));
	    new obj_id = gEditingObject[playerid][object_id];
	    
        HideMenuForPlayer(gMenus[playerid], playerid);
	    DestroyMenu(gMenus[playerid]);
	    gPlayerMenu[playerid] = false;
        
        new temp[MAX_STRING];
        new items[10][MAX_STRING] = {
            "0.005x",
            "0.05x",
            "0.5x",
            "1x",
            "2x",
            "5x",
            "10x",
            "20x",
            "25x",
            "45x"
		 };

	    switch (gMenuMode[playerid]) {
		    case MM_SELECT_EDITMODE:
		        {
		            switch (row) {
		            case 0: //"Attach to player",
		                {
		                    OnPlayerCommandText(playerid, "/ostick");
		                }
		            case 1: //"Move on X/Y Axis"
		                {
		                    gEditingObject[playerid][domove] = true;
		                    TogglePlayerControllable(playerid, 0);
		                    if (gCameraSetTimer[playerid] == 0) gCameraSetTimer[playerid] = SetTimerEx("SetObjectCoords", 25, 1, "ii", playerid, obj_id);
		                    OnPlayerCommandText(playerid, "/omode m_xy");
		                }
		            case 2: //"Move on Z Axis"
		                {
		                    gEditingObject[playerid][domove] = true;
		                    TogglePlayerControllable(playerid, 0);
		                    if (gCameraSetTimer[playerid] == 0) gCameraSetTimer[playerid] = SetTimerEx("SetObjectCoords", 25, 1, "ii", playerid, obj_id);
		                    OnPlayerCommandText(playerid, "/omode m_z");
		                }
		            case 3: //"Rotate on X/Y Axis"
		                {
		                    gEditingObject[playerid][domove] = true;
		                    TogglePlayerControllable(playerid, 0);
		                    if (gCameraSetTimer[playerid] == 0) gCameraSetTimer[playerid] = SetTimerEx("SetObjectCoords", 25, 1, "ii", playerid, obj_id);
		                    OnPlayerCommandText(playerid, "/omode r_xy");
		                }
		            case 4: //"Rotate on Z Axis"
		                {
		                    gEditingObject[playerid][domove] = true;
		                    TogglePlayerControllable(playerid, 0);
		                    if (gCameraSetTimer[playerid] == 0) gCameraSetTimer[playerid] = SetTimerEx("SetObjectCoords", 25, 1, "ii", playerid, obj_id);
		                    OnPlayerCommandText(playerid, "/omode r_z");
		                }
		            case 5: //"Add objetct"
		                {
		                    ShowPlayerDialog(playerid, menu_add, DIALOG_STYLE_LIST, GetLMsg(playerid,M_DESC_ADD_CATEGORY), listcat, GetLMsg(playerid,M_VIEW), GetLMsg(playerid,M_CANCEL));
		                }
		            case 6: //"Copy"
		                {
		                    new objname[MAX_STRING];
		                    format(objname, sizeof objname, "/ocopy cpy_%s", gObjects[obj_id][Name]);
		                    OnPlayerCommandText(playerid, objname);
		                }
		            case 7: //"Delete"
		                {
		                    OnPlayerCommandText(playerid, "/odel");
		                }
		            case 8: //"Multiplier"
		                {
		                    gMenus[playerid] = CreateMenu(GetLMsg(playerid,M_MULT), 1, 350,180, 250, 0);
		                    temp = "~w~";
		                    strcat(temp, items[gSelectedMultiplier[playerid]]);
		                    items[gSelectedMultiplier[playerid]] = temp;

		                    for(new i=0;i<=9;i++) {
		                        AddMenuItem(gMenus[playerid], 0, items[i]);
		                    }

		                    gMenuMode[playerid] = MM_SELECT_MULTIPLIER;
		                    TogglePlayerControllable(playerid, 0);
		                    ShowMenuForPlayer(gMenus[playerid], playerid);
		                    gPlayerMenu[playerid] = true;
		                }
		            case 9: //"Cancel"
		                {
		                   CancelEditObject(playerid);
						}
		            case 10: //Goto
		            	{
			                new str[256];
			                format(str,sizeof(str),"/ogoto %s", gObjects[obj_id][Name]);
			                OnPlayerCommandText(playerid, str);
		            	}
		            }
		        }
		    case MM_SELECT_EDITMODE_DETACHONLY:
		        {
		            switch (row) {
		            case 0: //"Detach from player",
		                {
		                    OnPlayerCommandText(playerid, "/orelease");
		                }
		            }
		        }
		    case MM_SELECT_MULTIPLIER:
		        {
		            switch (row) {
		            case 0: gEditingObject[playerid][EditMultiplier]  = 0.005;       //"0.005x",
		            case 1: gEditingObject[playerid][EditMultiplier]  = 0.050;       //"0.05x",
		            case 2: gEditingObject[playerid][EditMultiplier]  = 0.5;       //"0.5x",
		            case 3: gEditingObject[playerid][EditMultiplier]  = 1;       //"1x",
		            case 4: gEditingObject[playerid][EditMultiplier]  = 2;       //"2x",
		            case 5: gEditingObject[playerid][EditMultiplier]  = 5;       //"5x",
		            case 6: gEditingObject[playerid][EditMultiplier]  = 10;       //"10x",
		            case 7: gEditingObject[playerid][EditMultiplier]  = 20;       //"20x",
		            case 8: gEditingObject[playerid][EditMultiplier]  = 25;       //"25x",
		            case 9: gEditingObject[playerid][EditMultiplier]  = 45;       //"45x"
		            }

		            gSelectedMultiplier[playerid] = row;
		            TogglePlayerControllable(playerid, !gEditingObject[playerid][domove]);
		        }
		    case MM_SELECT_ADDMODE:
		    	{
		    	    switch (row) {
			    	    case 0:
							ShowPlayerDialog(playerid, menu_add, DIALOG_STYLE_LIST, GetLMsg(playerid,M_DESC_ADD_CATEGORY), listcat, GetLMsg(playerid,M_VIEW), GetLMsg(playerid,M_CANCEL)); // Add Object
						case 1://Reload all
						{
							SaveObjects();
							DestroyObjects();
							ReadObjects();
						}
			    	    case 2://Multipler
						{
			                    gMenus[playerid] = CreateMenu(GetLMsg(playerid,M_MULT), 1, 350,180, 250, 0);
			                    temp = "~w~";
			                    strcat(temp, items[gSelectedMultiplier[playerid]]);
			                    items[gSelectedMultiplier[playerid]] = temp;
			                    for(new i=0;i<=9;i++) {
			                        AddMenuItem(gMenus[playerid], 0, items[i]);
			                    }
			                    gMenuMode[playerid] = MM_SELECT_MULTIPLIER;
			                    TogglePlayerControllable(playerid, 0);
			                    ShowMenuForPlayer(gMenus[playerid], playerid);
			                    gPlayerMenu[playerid] = true;
						}
						case 3: //Cancel
						{
							CancelEditObject(playerid);
						}
					}
		    	}
     	}
	}
    return 1;
}

/*---------------------------------------------------------------------------------------------------*/

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == menu_add)
	{
	    if(response)
	    {
	        new file[256], n;
	        set(file,inputtext);
	        strcat(file,".txt");
	        n = GetNumberObjects(file);
	        if(n <=80)
	        {
		        ReadListObjetects(lista[playerid],file);
		        format(file, sizeof(file), "%s", inputtext);
		        ShowPlayerDialog(playerid, menu_add+2, DIALOG_STYLE_LIST, file, lista[playerid], GetLMsg(playerid,M_NEXT), GetLMsg(playerid,M_CANCEL));
	        }
	        else
	        {
				gPlayer[playerid][vindex] = 1;
				set(gPlayer[playerid][vfile],file);
	            ReadListObjetects(lista[playerid],file);
		        format(file, sizeof(file), "%s - Page 1", inputtext);
		        ShowPlayerDialog(playerid, menu_add+3, DIALOG_STYLE_LIST, file, lista[playerid], GetLMsg(playerid,M_NEXT), GetLMsg(playerid,M_NEXTPAGE));
	        }
	    }
	    else
	        SystemMessage(playerid, GetLMsg(playerid,MSG_CANCELED), COLOR_RED);
	}
	else if(dialogid == menu_add+1)
	{
	    if(response)
	    {
			new str[256];
	        format(str, sizeof(str), "/oadd %d %s", gPlayer[playerid][id_sel], inputtext);
	        OnPlayerCommandText(playerid, str);
	    }
	    else
	        SystemMessage(playerid, GetLMsg(playerid,MSG_CANCELED), COLOR_RED);
	}
	else if(dialogid == menu_add+2)
	{
	    if(response)
		{
		    new i=0;
	        gPlayer[playerid][id_sel] = strval(strtok(inputtext,i,'-'));
			ShowPlayerDialog(playerid, menu_add+1, DIALOG_STYLE_INPUT, GetLMsg(playerid,M_ONAME_TITLE), GetLMsg(playerid,M_DESC_ONAME), GetLMsg(playerid,M_ADD), GetLMsg(playerid,M_CANCEL));
	    }
	    else
	        SystemMessage(playerid, GetLMsg(playerid,MSG_CANCELED), COLOR_RED);
	}
	else if(dialogid == menu_add+3)
	{
	    if(response)
		{
		    new i=0;
	        gPlayer[playerid][id_sel] = strval(strtok(inputtext,i,'-'));
			ShowPlayerDialog(playerid, menu_add+1, DIALOG_STYLE_INPUT, GetLMsg(playerid,M_ONAME_TITLE), GetLMsg(playerid,M_DESC_ONAME), GetLMsg(playerid,M_ADD), GetLMsg(playerid,M_CANCEL));
	    }
	    else
	    {
	    	gPlayer[playerid][vindex]++;
	        new n = GetNumberObjectsPage(gPlayer[playerid][vfile], gPlayer[playerid][vindex]);
	        new str[256];
	        ReadListObjetects(lista[playerid],gPlayer[playerid][vfile],gPlayer[playerid][vindex]);
	        strmid(str,gPlayer[playerid][vfile],0,strlen(gPlayer[playerid][vfile])-5);
   			format(str, sizeof(str), "%s - Page %d", str, gPlayer[playerid][vindex]);
			if(n == 80)
	        	ShowPlayerDialog(playerid, menu_add+3, DIALOG_STYLE_LIST, str, lista[playerid], GetLMsg(playerid,M_NEXT), GetLMsg(playerid,M_NEXTPAGE));
	        else
	            ShowPlayerDialog(playerid, menu_add+2, DIALOG_STYLE_LIST, str, lista[playerid], GetLMsg(playerid,M_NEXT), GetLMsg(playerid,M_CANCEL));
	    }
	}
	return 1;
}

/*---------------------------------------------------------------------------------------------------*/

stock SystemMessage(playerid, text[], color) {
    new msg[MAX_STRING];

    format(msg, sizeof msg, "[OED] %s", text);

    if (playerid == -1) {   //an alle
        SendClientMessageToAll(color, msg);
    } else {
        if (IsPlayerConnected(playerid)) {
            SendClientMessage(playerid, color, msg);
        }
    }

    return 1;
}

/*===================================================================================================*/
/* Objectfunktionen */
stock ReadObjects() {
    new File:hFile;
    new tmpres[MAX_STRING],i=0;

    new newoid;

    new modelid;
    new Float:x;
    new Float:y;
    new Float:z;
    new Float:rotx;
    new Float:roty;
    new Float:rotz;
    new ObjectName[MAX_STRING];
    
    new file[256];
    set(file, F_DIRECTORY);
    strcat(file,"BREAD_OED.TXT");

    if (!(fexist(file))) {
        new msg[256];
        format(msg,sizeof(msg), "[OED] %s File: '%s'", GetLMsg(-1,MSG_FNOTFOUND), file);
        printf("[OED] %s", msg);
        return 0;
    }
    else {
        hFile = fopen(file, io_read);
        tmpres[0]=0;
        while (fread(hFile, tmpres)) {
            StripNewLine(tmpres);
            if (tmpres[0]!=0) {       
                //modelid
                modelid = strval(strtok(tmpres,i,','));
                //spawn X
                x = Float:floatstr(strtok(tmpres,i,','));
                //spawn Y
                y = Float:floatstr(strtok(tmpres,i,','));
                //spawn Z
                z = Float:floatstr(strtok(tmpres,i,','));
                //rotation x
                rotx = Float:floatstr(strtok(tmpres,i,','));
                //rotation y
                roty = Float:floatstr(strtok(tmpres,i,','));
                //rotation z
                rotz = Float:floatstr(strtok(tmpres,i,','));
                //name
                set(ObjectName,strtok(tmpres,i,','));
				//printf("Objeto %d - %d , %f , %f , %f, %f, %f, %f, %s", gObjectCount, modelid, x, y, z, rotx, roty, rotz, ObjectName);
                if (gObjectCount < MAX_OBJECTS) {
                    newoid = gObjectCount;
                    gObjects[newoid][id_o] = CreateObject(modelid, x, y, z, rotx, roty, rotz, OBJECT_DISTANCE);
                    gObjects[newoid][ModelID] = modelid;
                    gObjects[newoid][obj_x] = x;
                    gObjects[newoid][obj_y] = y;
                    gObjects[newoid][obj_z] = z;
                    gObjects[newoid][rot_x] = rotx;
                    gObjects[newoid][rot_y] = roty;
                    gObjects[newoid][rot_z] = rotz;
                    gObjects[newoid][Name] = ObjectName;
                    gObjects[newoid][savetofile] = true;
                    gObjectCount++;
                }
            }
            tmpres[0]=0;
            i=0;
        }
        fclose(hFile);
        return 1;
    }
}


/*---------------------------------------------------------------------------------------------------*/
stock DestroyObjects() {
    for(new i=0; i<gObjectCount;i++)
    {
        DestroyObject(gObjects[i][id_o]);
    } 
    gObjectCount = 0;
}
/*---------------------------------------------------------------------------------------------------*/
stock SaveObjects() {
    new File:hFile;
    new line[MAX_STRING];
    
    new file[256];
    set(file, F_DIRECTORY);
    strcat(file,"BREAD_OED.TXT");

    hFile = fopen(file, io_write);

    for (new i=0;i<gObjectCount;i++) {
        if (gObjects[i][savetofile]) {
            format(line, sizeof line, "%d,%f,%f,%f,%f,%f,%f,%s\r\n", gObjects[i][ModelID], gObjects[i][obj_x], gObjects[i][obj_y], gObjects[i][obj_z], gObjects[i][rot_x], gObjects[i][rot_y], gObjects[i][rot_z], gObjects[i][Name]);
            fwrite(hFile, line);
        }
    }

    fclose(hFile);

    return 1;
}

/*---------------------------------------------------------------------------------------------------*/

stock AddNewObjectToScript(modelid,Float:x,Float:y,Float:z,Float:rotx,Float:roty,Float:rotz,ObjectName[MAX_STRING], oid=INVALID_OBJECT) {
    new newoid;

	if(oid > INVALID_OBJECT)
	    newoid = oid;
	else if(gObjectCount < MAX_OBJECTS)
	{
	    newoid = gObjectCount;
	    gObjectCount++;
	}

    if (gObjectCount < MAX_OBJECTS) {
    
    	gObjects[newoid][id_o] = CreateObject(modelid, x, y, z, rotx, roty, rotz, OBJECT_DISTANCE);
        gObjects[newoid][ModelID] = modelid;
        gObjects[newoid][obj_x] = x;
        gObjects[newoid][obj_y] = y;
        gObjects[newoid][obj_z] = z;
        gObjects[newoid][rot_x] = rotx;
        gObjects[newoid][rot_y] = roty;
        gObjects[newoid][rot_z] = rotz;
        gObjects[newoid][Name] = ObjectName;

        return newoid;
    } else {
        return 0;
    }
}

/*---------------------------------------------------------------------------------------------------*/

stock GetPlayerNearestObjects(playerid) {
    new Float:x1, Float:y1, Float:z1;
    new Float:x2, Float:y2, Float:z2;
    new Float:distances[MAX_OBJECTS][2];
    new j;
    new objects[24];

    GetPlayerPos(playerid, x1, y1, z1);

    for (new i=0;i<gObjectCount;i++) {
        GetObjectPos(gObjects[i][id_o], x2, y2, z2);
        distances[i][0] = GetDistanceBetweenCoords(x1, y1, z1, x2, y2, z2);
        distances[i][1] = float(i);
    }

    distances = FloatBubbleSort(distances, MAX_OBJECTS);

    for (new i=0;i<MAX_OBJECTS;i++) {
        if (!(floatround(distances[i][1]) == 0)) {
            if (j < 24) {
                j++;
                objects[j] = floatround(distances[i][1]);
            }
        }
    }

    return objects;
}

/*---------------------------------------------------------------------------------------------------*/

stock Float:GetDistanceBetweenCoords(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2) {
    return floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
}

/*---------------------------------------------------------------------------------------------------*/

stock Float:FloatBubbleSort(Float:lArray[MAX_OBJECTS][2], lArraySize) {
    new Float:lSwap;
    new bool:bSwapped = true;
    new I;

    while(bSwapped) {
        bSwapped = false;
        for(I = 0; I < lArraySize - 1; I++) {
            if(lArray[I+1][0] < lArray[I][0]) {
                lSwap = lArray[I][0];
                lArray[I][0] = lArray[I+1][0];
                lArray[I+1][0] = lSwap;

                lSwap = lArray[I][1];
                lArray[I][1] = lArray[I+1][1];
                lArray[I+1][1] = lSwap;

                bSwapped = true;
            }
        }
    }

    return lArray;
}

/*---------------------------------------------------------------------------------------------------*/

public ObjectEditTimer(playerid, editmode, axis, Float:value){
    new Float:x, Float:y, Float:z;
    new Float:rotx, Float:roty, Float:rotz;
    new oid;

    if ((gEditingObject[playerid][domove]) && (gEditingObject[playerid][object_id] > INVALID_OBJECT)) {
        value = floatmul(value, gEditingObject[playerid][EditMultiplier]);

        oid = gEditingObject[playerid][object_id];

        GetObjectPos(gObjects[oid][id_o], x, y, z);
        GetObjectRot(gObjects[oid][id_o], rotx, roty, rotz);

        switch(axis) {
        case AXIS_X:
            {
                x = floatadd(x, value);
                rotx = floatadd(rotx, value);
            }
        case AXIS_Y:
            {
                y = floatadd(y, value);
                roty = floatadd(roty, value);
            }
        case AXIS_Z:
            {
                z = floatadd(z, value);
                rotz = floatadd(rotz, value);
            }
        }

        switch (editmode) {
        case OED_MOVE:
            {
                SetObjectPos(gObjects[oid][id_o], x, y, z);
                gObjects[oid][obj_x] = x;
                gObjects[oid][obj_y] = y;
                gObjects[oid][obj_z] = z;
            }
        case OED_ROTATE:
            {
                SetObjectRot(gObjects[oid][id_o], rotx, roty, rotz);
                gObjects[oid][rot_x] = rotx;
                gObjects[oid][rot_y] = roty;
                gObjects[oid][rot_z] = rotz;
            }
        }
    }

    return 1;
}

/*---------------------------------------------------------------------------------------------------*/

public UpDownLeftRightAdditionTimer() {
    new keys, leftright, updown;
    new oldkeys;

    for (new i=0;i<MAX_PLAYERS;i++) {
        if (IsPlayerConnected(i) && IsPlayerAdmin(i)) {
            GetPlayerKeys(i, keys, updown, leftright);

            //links+rechts
            if (leftright == KEY_LEFT) {
                if (!(gLastPlayerKeys[i][0] == leftright)) OnPlayerKeyStateChange(i, VKEY_LEFT, 0);
            } else if (leftright == KEY_RIGHT) {
                if (!(gLastPlayerKeys[i][0] == leftright)) OnPlayerKeyStateChange(i, VKEY_RIGHT, 0);
            } else {
                if (gLastPlayerKeys[i][0] == KEY_LEFT) {
                    oldkeys = VKEY_LEFT;
                } else if (gLastPlayerKeys[i][0] == KEY_RIGHT) {
                    oldkeys = VKEY_DOWN;
                }
                if (!(gLastPlayerKeys[i][0] == leftright)) OnPlayerKeyStateChange(i, 0, oldkeys);
            }

            //hoch+runter
            if (updown == KEY_UP) {
                if (!(gLastPlayerKeys[i][1] == updown)) OnPlayerKeyStateChange(i, VKEY_UP, 0);
            } else if (updown == KEY_DOWN) {
                if (!(gLastPlayerKeys[i][1] == updown)) OnPlayerKeyStateChange(i, VKEY_DOWN, 0);
            } else {
                if (gLastPlayerKeys[i][1] == KEY_UP) {
                    oldkeys = VKEY_UP;
                } else if (gLastPlayerKeys[i][1] == KEY_DOWN){
                    oldkeys = VKEY_DOWN;
                }
                if (!(gLastPlayerKeys[i][1] == updown)) OnPlayerKeyStateChange(i, 0, oldkeys);
            }

            gLastPlayerKeys[i][0] = leftright;
            gLastPlayerKeys[i][1] = updown;
        }
    }

    return 1;
}

/*---------------------------------------------------------------------------------------------------*/

public SetObjectCoords(playerid, obj_id) {
    new Float:x, Float:y, Float:z;

    GetObjectPos(gObjects[obj_id][id_o], x, y, z);

    if (!((x == gObjects[obj_id][obj_x]) &&
          (y == gObjects[obj_id][obj_y]) &&
          (z == gObjects[obj_id][obj_z]))) {

        gObjects[obj_id][obj_x] = x;
        gObjects[obj_id][obj_y] = y;
        gObjects[obj_id][obj_z] = z;
    }

    GetPlayerPos(playerid, x, y, z);
    SetPlayerCameraPos(playerid, x, y, z);
    SetPlayerCameraLookAt(playerid, gObjects[obj_id][obj_x], gObjects[obj_id][obj_y], gObjects[obj_id][obj_z]);

    return 1;
}
/*---------------------------------------------------------------------------------------------------*/

stock ReadListObjetects(list [], file[]="index.ini", index=1)
{
	new farq[256];
	set(farq,file);
	format(file,MAX_STRING,"%slist_objects/%s",F_DIRECTORY, file);
	new line[256], File:fl = fopen(file,io_append), first=(index-1)*80, i=0, last = index*80;
	list[0] = 0;
	fclose(fl);
	fl = fopen(file,io_read);
	while(i < last && fread(fl, line))
	{
	    if(i < first)
	    {
	        i++;
	        continue;
	    }
  		StripNewLine(line);
  		if(line[0] == '/')
  		    continue;
  		strcat(list,line,4096);
  		strcat(list,"\n",4096);
  		i++;
	}
	if(list[strlen(list)-1] == '\n')
	    list[strlen(list)-1] = 0;
 	fclose(fl);
 	set(file,farq);
	return list;
}

stock GetNumberObjects(file[]="index.ini")
{
	new farq[256];
	set(farq,file);
	format(file,MAX_STRING,"%slist_objects/%s",F_DIRECTORY, file);
	new line[256], File:fl = fopen(file,io_append), i=0;
	fclose(fl);
	fl = fopen(file,io_read);
	while(fread(fl, line))
  		i++;
 	fclose(fl);
 	set(file,farq);
 	return i;
}


stock GetNumberObjectsPage(file[]="index.ini", index)
{
	new farq[256];
	set(farq,file);
	format(file,MAX_STRING,"%slist_objects/%s",F_DIRECTORY, file);
	new line[256], File:fl = fopen(file,io_append), first=(index-1)*80, i=0, last = index*80;
	fclose(fl);
	fl = fopen(file,io_read);
	while(i < last && fread(fl, line))
	{
	    if(i < first)
	    {
	        i++;
	        continue;
	    }
	    i++;
 	}
 	fclose(fl);
 	set(file,farq);
 	return (i-first);
}
/*---------------------------------------------------------------------------------------------------*/

stock ReadLangs()
{
	new file[256], line[256], i=0;
	format(file,MAX_STRING,"%slanguages/index.ini",F_DIRECTORY);
	new File:fl = fopen(file,io_append);
	fclose(fl);
	fl = fopen(file,io_read);
	while(i < MAX_LANGS && fread(fl, line))
	{
  		StripNewLine(line);
		set(Langs[i], line);
  		i++;
	}
	Langs_Imp = i;
 	fclose(fl);
}

stock GetLMsg(playerid, ELANG:message)
{
    new lfile[256];
	if(playerid > -1)
		format(lfile,sizeof(lfile),"%slanguages/%s.txt",F_DIRECTORY,plang[playerid]);
	else
	    format(lfile,sizeof(lfile),"%slanguages/%s.txt",F_DIRECTORY,Langs[0]);
	new ret[256], line[256], File:fl, i=0;
	ret[0] = 0;
	fl = fopen(lfile,io_read);
	if(!fl)
	{
	    printf("[OED] %s File: %s", GetLMsg(-1,MSG_FNOTFOUND), lfile);
	    return ret;
	}
	while(ELANG: i < message && fread(fl, line))
  	{
	  	i++;
	  	StripNewLine(line);
	}
	if(fread(fl, line))
	{
	    StripNewLine(line);
	    set(ret,line);
	}
 	fclose(fl);
 	return ret;
}