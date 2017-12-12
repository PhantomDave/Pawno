

#include <a_samp>
#include <sscanf2>

/*

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.

Author: iPLEOMAX
Note: Do not release any other version without my permission.

*/

#define ITD_VER                 "Version: 1.16 Stable (13/10/2012)"
#define ITD_List                "projects.lst"
#define ITD_File            	"%s.itd"
#define ITD                     "{62E300}iTD: {FFFFFF}"
#define ITD_E                   "{62E300}iTD: {FF0000}(Error) {FFFFFF}"
#define ITD_W                   "{62E300}iTD: {FFB429}(Warning) {FFFFFF}"
#define ITD_I                   "{62E300}iTD: {00FF00}(Info) {FFFFFF}"

#if !defined isnull
	#define isnull(%1) \
				((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif

#define Send(%0,%1,%2)          SendClientMessage(%0, %1, %2)
#define LoopProjectTextdraws    for (new i = 0; i < MAX_PROJECT_TEXTDRAWS; i++)
#define CountRange(%0,%1)       for (new c = %0; c < %1; c++)
#define EmptyString(%0)         %0[0] = '\0'
#define iShowPlayerDialog       DialogShown = true, ShowPlayerDialog

#define INVALID_INDEX_ID        (-1)
#define MAX_PROJECT_TEXTDRAWS   (100)
#define MAX_UNDO_STATES         (1000)

#define VK_KEY_A	0x41
#define VK_KEY_B	0x42
#define VK_KEY_C	0x43
#define VK_KEY_D	0x44
#define VK_KEY_E	0x45
#define VK_KEY_F	0x46
#define VK_KEY_G	0x47
#define VK_KEY_H	0x48
#define VK_KEY_I	0x49
#define VK_KEY_J	0x4A
#define VK_KEY_K	0x4B
#define VK_KEY_L	0x4C
#define VK_KEY_M	0x4D
#define VK_KEY_N	0x4E
#define VK_KEY_O	0x4F
#define VK_KEY_P	0x50
#define VK_KEY_Q	0x51
#define VK_KEY_R	0x52
#define VK_KEY_S	0x53
#define VK_KEY_T	0x54
#define VK_KEY_U	0x55
#define VK_KEY_V	0x56
#define VK_KEY_W	0x57
#define VK_KEY_X	0x58
#define VK_KEY_Y	0x59
#define VK_KEY_Z	0x5A
#define VK_LBUTTON	0x01
#define VK_MBUTTON	0x04
#define VK_RBUTTON	0x02
#define VK_UP		0x26
#define VK_DOWN		0x28
#define VK_LEFT		0x25
#define VK_RIGHT	0x27
#define VK_LSHIFT	0xA0
#define VK_RSHIFT	0xA1
#define VK_SPACE    0x20

native GetVirtualKeyState(key);
native GetScreenSize(&Width, &Height);
native GetMousePos(&X, &Y);

enum
{
    DIALOG_NEW = 6900,
	DIALOG_LIST,
	DIALOG_CREATE,
	DIALOG_TEXT,
	DIALOG_PROJECTS,
	DIALOG_COLOR,
	DIALOG_HEXCOLOR,
	DIALOG_NUMCOLOR,
	DIALOG_PRECOLOR,
	DIALOG_POSITION,
	DIALOG_POSITIONC,
	DIALOG_SIZE,
	DIALOG_SIZEC,
	DIALOG_LETTER,
	DIALOG_LETTERC,
	DIALOG_WARNING
};

enum
{
	EDITMODE_NONE,
	EDITMODE_TEXTDRAW,
	EDITMODE_USEBOX,
	EDITMODE_TEXTUREBOX,
	EDITMODE_POSITION,
	EDITMODE_SIZE,
	EDITMODE_LETTERSIZE,
	EDITMODE_COLOR,
	EDITMODE_BGCOLOR,
	EDITMODE_BOXCOLOR,
	EDITMODE_OUTLINE,
	EDITMODE_SHADOW,
	EDITMODE_PROPORTION,
	EDITMODE_SELECTABLE,
	EDITMODE_FONT,
	EDITMODE_ALIGNMENT,
	EDITMODE_BOX,
	EDITMODE_TYPE,
	EDITMODE_REMOVE
};

enum
{
	COLORMODE_NONE,
	COLORMODE_RED,
	COLORMODE_GREEN,
	COLORMODE_BLUE,
	COLORMODE_ALPHA
};

enum
	E_TD_STRUCT
{
	Text:iTextdraw,
	iText[128],
	Float:iPositionX,
	Float:iPositionY,
	Float:iLetterX,
	Float:iLetterY,
	Float:iTextX,
	Float:iTextY,
	iAlignment,
	iColor,
	iUsebox,
	iBoxcolor,
	iShadow,
	iOutline,
	iBackgroundcolor,
	iFont,
	iProportion,
	iSelectable,
	iType
};

enum
	E_KEY_STRUCT
{
	bool:KEY_PRESSED,
	KEY_CODE,
};

new
	Float:OffsetZ = 415.0,
	Text:TD_Menu[34] = {Text:INVALID_TEXT_DRAW, ...},
	
	File:Handler,
	ProjectEditor,
	ProjectFile[64],
	
	bool:DialogShown,
	bool:MenuShown,
	bool:MenuHidden,
	bool:EditEnabled,
	Float:EditSpeed = 1.0,
	
	EditMode,
	EditIndex,
	ColorMode,
	Colors[4],
	
	Project[MAX_PROJECT_TEXTDRAWS][E_TD_STRUCT],
	
	String_Large[3584],
	String_Textdraw[512],
	String_Message[128],
	String_Normal[64],
	
	States[MAX_UNDO_STATES][sizeof String_Textdraw],
	
	UpdateTimer,
	CursorOX, CursorOY,
	CursorX, CursorY,
	ScreenWidth, ScreenHeight,
	VirtualKeys[36][E_KEY_STRUCT]
;

new PremadeColors[][] =
{
	{ 0xFF0000FF , "Red" },
	{ 0xFFFFFFFF , "White" },
	{ 0x00FFFFFF , "Cyan" },
	{ 0xC0C0C0FF , "Silver" },
	{ 0x0000FFFF , "Blue" },
	{ 0x808080FF , "Grey" },
	{ 0x0000A0FF , "DarkBlue" },
	{ 0x000000FF , "Black" },
	{ 0xADD8E6FF , "LightBlue" },
	{ 0xFFA500FF , "Orange" },
	{ 0x800080FF , "Purple" },
	{ 0xA52A2AFF , "Brown" },
	{ 0xFFFF00FF , "Yellow" },
	{ 0x800000FF , "Maroon" },
	{ 0x00FF00FF , "Lime" },
	{ 0x008000FF , "Green" },
	{ 0xFF00FFFF , "Fuchsia" },
	{ 0x808000FF , "Olive" }
};

public OnFilterScriptInit()
{
	printf("\n\tiPLEOMAX's TextDraw Editor loaded successfully!\n\t%s\n", ITD_VER);
    Initiate();
	return true;
}

public OnFilterScriptExit()
{
    Dispose();
    return true;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if(!strcmp(cmdtext, "/itd", true, 4))
	{
	    if(ProjectEditor == playerid)
	    {
	        if(strlen(cmdtext) >= 6)
			{
				if(!strcmp(cmdtext[5], "top", true))
				{
					OffsetZ = 0.0;
					if(MenuShown && !MenuHidden) ShowEditor();
					return Send(playerid, -1, #ITD_I"Menu location set to: TOP");
				} else

				if(!strcmp(cmdtext[5], "bottom", true))
				{
					OffsetZ = 415.0;
					if(MenuShown && !MenuHidden) ShowEditor();
					return Send(playerid, -1, #ITD_I"Menu location set to: BOTTOM");
				} else
				
				return Send(playerid, -1, "Usage: /itd (Top / Bottom / Center)");
			}
			return Send(playerid, -1, #ITD_I"Press ESC in main menu to go back or exit editor.");
	    }
		
		GetPlayerIp(playerid, String_Normal, 16);
		
		if(ProjectEditor != playerid && ProjectEditor != INVALID_PLAYER_ID)
		return Send(playerid, -1, #ITD_E"Another host is already using the editor.");
		
		
		Send(playerid, -1, "Welcome to {62E300}iPLEOMAX's Textdraw Editor{FFFFFF}. Pick an option to begin!");
		ProjectEditor = playerid;
		ShowEditor();
		return true;
	}
	return false;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(playerid != ProjectEditor) return false;
	DialogShown = false;
	
	switch(dialogid)
	{
	    case DIALOG_NEW:
	    {
	        if(response)
	        {
	            if( !(1 <= strlen(inputtext) <= 32) )
	            return Send(playerid, -1, #ITD_I"Project name must be within 1 to 32 characters");

				if( !IsValidProjectName(inputtext) )
				return Send(playerid, -1, #ITD_I"Project name must contain only these characters: A-Z, 0-9, -, _, (, )");
				
				if(strlen(ProjectFile)) CloseProject();
				format(ProjectFile, sizeof ProjectFile, ITD_File, inputtext);
				
				if(!CheckProject(inputtext)) AddProject(ProjectFile);
				
				if(fexist(ProjectFile)) {
				    
					LoadProject();
					format(String_Message, 128, "%sProject: '%s' already exists, loaded!", ITD_I, ProjectFile);
	    			Send(ProjectEditor, -1, String_Message);
	    			
				} else {
				    Handler = fopen(ProjectFile, io_write);
				    fclose(Handler);
				}
				
				ShowEditor();
				return true;
			}
	    }
	    case DIALOG_PROJECTS:
	    {
	        if(response)
	        {
	            Handler = fopen(ITD_List, io_read);
             	if(!Handler) return Send(ProjectEditor, -1, #ITD_E"File I/O Error occured (project.lst)");
             	
             	new Index = -1;
             	while(fread(Handler, String_Normal))
             	{
             	    if(!strlen(String_Normal)) continue;
             	    Index++;
             	    
             	    if(Index == listitem)
             	    {
             	    	StripNewLine(String_Normal);
             	    	
             	    	if(strlen(ProjectFile))
             	    	{
	             	    	SaveProject(true);
	             	    	CloseProject();
             	    	}
             	    	
             	    	format(ProjectFile, sizeof ProjectFile, "%s", String_Normal);
             	    	LoadProject(true);
             	    }
             	}
	        }
	        
	        return true;
	    }
	    case DIALOG_LIST:
	    {
	        if(response)
	        {
	            switch(listitem)
	            {
	                case 0: ShowCreateDialog();
	                case 1:
					{
						TextDrawEdit(EDITMODE_REMOVE);
						ShowTextDrawList();
					}
	                default:
	                {
	                    listitem -= 2;
	                    new match = -1;
						LoopProjectTextdraws
						{
						    if(Project[i][iTextdraw] == Text:INVALID_TEXT_DRAW) continue;
						    match++;
						    if(match == listitem)
						    {
						        EditIndex = i;
						        ShowTextDrawList();
						        if(!MenuHidden) ShowEditor();
						    }
						}
	                }
	            }
	        }
	    }
		case DIALOG_CREATE:
		{
		    if(!response) return ShowTextDrawList();

            new Index = GetAvailableIndex();
		    if(Index == INVALID_INDEX_ID)
			return Send(ProjectEditor, -1, #ITD_E"Project Textdraw limit reached! Unable to create new.");
            EditIndex = Index;

		    switch(listitem)
		    {
		        case 0: TextDrawEdit(EDITMODE_TEXTDRAW);
		        case 1: TextDrawEdit(EDITMODE_USEBOX);
		        case 2: TextDrawEdit(EDITMODE_TEXTUREBOX);
		    }
		    
		    return true;
		}
	    case DIALOG_POSITION:
	    {
	        if(!response) return true;
            switch(listitem)
            {
                case 0: TextDrawEdit(EDITMODE_POSITION);
                case 1: ShowPositionCustomDialog();
            }
            return true;
	    }
	    case DIALOG_POSITIONC:
	    {
	        if(!response) return ShowPositionDialog();
	        if(strlen(inputtext) < 3) return ShowPositionCustomDialog();
	        if(EditIndex == INVALID_INDEX_ID) return Send(playerid, -1, #ITD_E"Invalid Edit Index @DIALOGPOSITIONC (Report as bug)");
	        
	        new Float:iTemp1, Float:iTemp2;
	        
	        if(!sscanf(inputtext, "ff", iTemp1, iTemp2) ||
				!sscanf(inputtext, "p<,>ff", iTemp1, iTemp2))
	        {
	            SaveTextDrawState(EditIndex);
	            Project[EditIndex][iPositionX] = iTemp1;
	            Project[EditIndex][iPositionX] = iTemp2;
	            
	            UpdateTextDraw(EditIndex);
	            Send(playerid, -1, #ITD_I"Position updated");
	        } else {
	            ShowPositionCustomDialog();
	            Send(playerid, -1, #ITD_E"Invalid coord format");
	        }
	        return true;
	    }
	    case DIALOG_SIZE:
	    {
	        if(response)
	        {
	            switch(listitem)
	            {
	                case 0: TextDrawEdit(EDITMODE_SIZE);
	                case 1: ShowSizeCustomDialog();
	            }
	        }
	        return true;
	    }
	    case DIALOG_SIZEC:
	    {
	        if(!response) return ShowSizeDialog();
	        if(strlen(inputtext) < 3) return ShowSizeCustomDialog();
	        if(EditIndex == INVALID_INDEX_ID) return Send(playerid, -1, #ITD_E"Invalid Edit Index @DIALOGSIZEC (Report as bug)");
	        
	        new Float:iTemp1, Float:iTemp2;
	        
	        if(!sscanf(inputtext, "ff", iTemp1, iTemp2) ||
				!sscanf(inputtext, "p<,>ff", iTemp1, iTemp2))
	        {
	            SaveTextDrawState(EditIndex);
	            Project[EditIndex][iTextX] = iTemp1;
	            Project[EditIndex][iTextX] = iTemp2;
	        
	            UpdateTextDraw(EditIndex);
	            Send(playerid, -1, #ITD_I"Text Size updated");
	        } else {
	            ShowSizeCustomDialog();
	            Send(playerid, -1, #ITD_E"Invalid size format");
	        }
	        return true;
	    }
	    case DIALOG_LETTER:
	    {
	        if(response)
	        {
	            switch(listitem)
	            {
	                case 0: TextDrawEdit(EDITMODE_LETTERSIZE);
	                case 1: ShowLetterCustomDialog();
	            }
	        }
	        return true;
	    }
	    case DIALOG_LETTERC:
	    {
	        if(!response) return ShowLetterDialog();
	        if(strlen(inputtext) < 3) return ShowLetterCustomDialog();
            if(EditIndex == INVALID_INDEX_ID) return Send(playerid, -1, #ITD_E"Invalid Edit Index @DIALOGLETTERC (Report as bug)");

            new Float:iTemp1, Float:iTemp2;

	        if(!sscanf(inputtext, "ff", iTemp1, iTemp2) ||
				!sscanf(inputtext, "p<,>ff",iTemp1, iTemp2))
	        {
	            SaveTextDrawState(EditIndex);
	            Project[EditIndex][iLetterX] = iTemp1;
	            Project[EditIndex][iLetterY] = iTemp2;
	        
	            UpdateTextDraw(EditIndex);
	            Send(playerid, -1, #ITD_I"Letter Size updated");
	        } else {
	            ShowLetterCustomDialog();
	            Send(playerid, -1, #ITD_E"Invalid size format");
	        }
	        return true;
	    }
	    case DIALOG_TEXT:
	    {
	        if(EditIndex == INVALID_INDEX_ID) return Send(playerid, -1, #ITD_E"Invalid Edit Index @DIALOGTEXT (Report as bug)");
	        if(response)
	        {
	            if(!strlen(inputtext)) return ShowTextDialog();
	            
	            SaveTextDrawState(EditIndex);
	            format(Project[EditIndex][iText], 128, "%s", inputtext);
	            UpdateTextDraw(EditIndex);
	        }
	        return true;
	    }
	    case DIALOG_COLOR:
	    {
	        if(response)
	        {
				switch(listitem)
				{
				    case 0: ShowHEXColorDialog();
				    case 1: ShowNUMColorDialog();
				    case 2: ShowPREColorDialog();
				}
			}
			return true;
	    }
	    case DIALOG_HEXCOLOR:
	    {
	        if(!response) return ShowColorDialog();
	        if(strlen(inputtext) < 8) return ShowHEXColorDialog();
			if(EditIndex == INVALID_INDEX_ID) return Send(playerid, -1, #ITD_E"Invalid Edit Index @DIALOGHEXCOLOR (Report as bug)");
	        
	        if(inputtext[0] == '0' && inputtext[1] == 'x')
	        {
	            Colors[0] = HexToInt(inputtext[2]);
	        } else
			if(inputtext[0] == '#')
	        {
	            Colors[0] = HexToInt(inputtext[1]);
	        } else
	        {
	            Colors[0] = HexToInt(inputtext);
	        }
	        
	        SaveTextDrawState(EditIndex);
	        switch(EditMode)
	        {
	            case EDITMODE_COLOR: 	Project[EditIndex][iColor] = Colors[0];
	            case EDITMODE_BGCOLOR: 	Project[EditIndex][iBackgroundcolor] = Colors[0];
	            case EDITMODE_BOXCOLOR: Project[EditIndex][iBoxcolor] = Colors[0];
	        }
	        
	        UpdateTextDraw(EditIndex);
	        return Send(playerid, Colors[0], "< Color Applied >");
	    }
	    case DIALOG_NUMCOLOR:
	    {
	        if(!response) return ShowColorDialog();
	        if(!strlen(inputtext)) return ShowNUMColorDialog();
	        if(EditIndex == INVALID_INDEX_ID) return Send(playerid, -1, #ITD_E"Invalid Edit Index @DIALOGNUMCOLOR (Report as bug)");
	        
	        if(!sscanf(inputtext, "iiii", Colors[0], Colors[1], Colors[2], Colors[3]) ||
				!sscanf(inputtext, "p<,>iiii", Colors[0], Colors[1], Colors[2], Colors[3]))
	        {
	            SaveTextDrawState(EditIndex);
	            switch(EditMode)
		        {
		            case EDITMODE_COLOR: 	Project[EditIndex][iColor] = RGBAToHex(Colors[0], Colors[1], Colors[2], Colors[3]);
		            case EDITMODE_BGCOLOR: 	Project[EditIndex][iBackgroundcolor] = RGBAToHex(Colors[0], Colors[1], Colors[2], Colors[3]);
		            case EDITMODE_BOXCOLOR: Project[EditIndex][iBoxcolor] = RGBAToHex(Colors[0], Colors[1], Colors[2], Colors[3]);
		        }
	        } else {
				Send(playerid, -1, #ITD_E"Invalid Color Format | Example usage: 255, 0, 0, 125 (Red with 50%% Transparency)");
				return ShowNUMColorDialog();
			}
			
			UpdateTextDraw(EditIndex);
			return Send(playerid, RGBAToHex(Colors[0], Colors[1], Colors[2], Colors[3]), "< Color Applied >");
	    }
	    case DIALOG_PRECOLOR:
	    {
	        if(!response) return ShowColorDialog();
	        if(EditIndex == INVALID_INDEX_ID) return Send(playerid, -1, #ITD_E"Invalid Edit Index @DIALOGPRECOLOR (Report as bug)");
	        
	        SaveTextDrawState(EditIndex);
	        switch(EditMode)
	        {
	            case EDITMODE_COLOR: 	Project[EditIndex][iColor] = PremadeColors[listitem][0];
	            case EDITMODE_BGCOLOR: 	Project[EditIndex][iBackgroundcolor] = PremadeColors[listitem][0];
	            case EDITMODE_BOXCOLOR: Project[EditIndex][iBoxcolor] = PremadeColors[listitem][0];
	        }
	        
	        UpdateTextDraw(EditIndex);
	        return Send(playerid, PremadeColors[listitem][0], "< Color Applied >");
	    }
	    case DIALOG_WARNING:
	    {
	        if(!response) ShowSizeDialog();
	        return true;
	    }
	}
	
	return false;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	//format(String_Message, sizeof String_Message, "Clickedid: %i", _:clickedid);
	//Send(playerid, -1, String_Message);
	
	if(playerid != ProjectEditor) return false;
	
	if(clickedid == Text:INVALID_TEXT_DRAW)
	{
	    if(DialogShown)
	    {
	        Send(ProjectEditor, -1, #ITD_W"Please close this dialog first!");
	        return SelectTextDraw(playerid, -1);
	    }
	    if(MenuHidden) return ShowEditor();
		if(MenuShown) return HideEditor();
	    return true;
	}
	
	if(clickedid == TD_Menu[1]) iShowPlayerDialog(playerid, DIALOG_NEW, DIALOG_STYLE_INPUT,
	"New Project", "\nPlease enter the name of your new project:\n", "OK", "Cancel");
	
	if(clickedid == TD_Menu[2])		return ShowProjectList();
	if(clickedid == TD_Menu[3])     return CloseProject(true);
	if(clickedid == TD_Menu[4])     return ExportProject();
	if(clickedid == TD_Menu[8])     return ShowTextDrawList();
	if(clickedid == TD_Menu[9]) 	return ShowPositionDialog();
	if(clickedid == TD_Menu[10]) 	return ShowSizeDialog(true);
	if(clickedid == TD_Menu[11]) 	return ShowTextDialog();
	if(clickedid == TD_Menu[16]) 	return ShowLetterDialog();
	if(clickedid == TD_Menu[14]) 	return TextDrawEdit(EDITMODE_COLOR);
	if(clickedid == TD_Menu[15]) 	return TextDrawEdit(EDITMODE_BGCOLOR);
	if(clickedid == TD_Menu[32]) 	return TextDrawEdit(EDITMODE_BOXCOLOR);
	if(clickedid == TD_Menu[17]) 	return TextDrawEdit(EDITMODE_OUTLINE);
	if(clickedid == TD_Menu[18]) 	return TextDrawEdit(EDITMODE_SHADOW);
	if(clickedid == TD_Menu[31] || clickedid == TD_Menu[30]) return TextDrawEdit(EDITMODE_PROPORTION);
    if(clickedid == TD_Menu[29] || clickedid == TD_Menu[28]) return TextDrawEdit(EDITMODE_SELECTABLE);
    if(clickedid == TD_Menu[27] || clickedid == TD_Menu[26] || clickedid == TD_Menu[25] || clickedid == TD_Menu[24] || clickedid == TD_Menu[12]) return TextDrawEdit(EDITMODE_FONT);
    if(clickedid == TD_Menu[23] || clickedid == TD_Menu[22] || clickedid == TD_Menu[21]) return TextDrawEdit(EDITMODE_ALIGNMENT);
    if(clickedid == TD_Menu[20] || clickedid == TD_Menu[19]) return TextDrawEdit(EDITMODE_BOX);
	if(clickedid == TD_Menu[5] || clickedid == TD_Menu[33]) return TextDrawEdit(EDITMODE_TYPE);
	return false;
}

forward OnEditorUpdate();
public OnEditorUpdate()
{
	CountRange(0, sizeof VirtualKeys)
	{
		if(GetVirtualKeyState(VirtualKeys[c][KEY_CODE]) & 0x8000)
		{
		    if(!VirtualKeys[c][KEY_PRESSED])
		    {
		        CallLocalFunction("OnVirtualKeyDown", "d", VirtualKeys[c][KEY_CODE]);
		        VirtualKeys[c][KEY_PRESSED] = true;
		    }
		}
		else if(VirtualKeys[c][KEY_PRESSED])
		{
		    CallLocalFunction("OnVirtualKeyRelease", "d", VirtualKeys[c][KEY_CODE]);
		    VirtualKeys[c][KEY_PRESSED] = false;
		}
	}

	GetScreenSize(ScreenWidth, ScreenHeight);
	GetMousePos(CursorX, CursorY);

	if(CursorOX != CursorX || CursorOY != CursorY)
	{
	    CallLocalFunction("OnCursorPositionChange", "dd", CursorX, CursorY);
	    CursorOX = CursorX;
	    CursorOY = CursorY;
	}
}

stock ShowValues(Float:ZPos, Float:X, Float:Y)
{
    if(ZPos >= 220)
	{
	    format(String_Normal, sizeof String_Normal, "~w~%.3f, %.3f", X, Y);
	    GameTextForPlayer(ProjectEditor, String_Normal, 1000, 4);
	} else {
	    format(String_Normal, sizeof String_Normal, "~n~~n~~n~~n~%.3f, %.3f", X, Y);
	    GameTextForPlayer(ProjectEditor, String_Normal, 1000, 5);
	}
}

forward OnCursorPositionChange(NewX, NewY);
public OnCursorPositionChange(NewX, NewY)
{
    if(EditEnabled)
	{
	    switch(EditMode)
	    {
	        case EDITMODE_POSITION:
	        {
	            if(Project[EditIndex][iUsebox] && Project[EditIndex][iLetterX] == 0.0)
			    {
			        Project[EditIndex][iPositionX] -= floatdiv(floatsub(CursorOX, NewX), ScreenWidth) * 640.0 * EditSpeed;
				    Project[EditIndex][iTextX] -= floatdiv(floatsub(CursorOX, NewX), ScreenWidth) * 640.0 * EditSpeed;
		    		Project[EditIndex][iPositionY] -= floatdiv(floatsub(CursorOY, NewY), ScreenHeight) * 448.0 * EditSpeed;
		    		ShowValues(Project[EditIndex][iPositionY], Project[EditIndex][iTextX], Project[EditIndex][iPositionY]);
			    } else {
			        Project[EditIndex][iPositionX] -= floatdiv(floatsub(CursorOX, NewX), ScreenWidth) * 640.0 * EditSpeed;
			    	Project[EditIndex][iPositionY] -= floatdiv(floatsub(CursorOY, NewY), ScreenHeight) * 448.0 * EditSpeed;
			    	ShowValues(Project[EditIndex][iPositionY], Project[EditIndex][iPositionX], Project[EditIndex][iPositionY]);
			    }
			    UpdateTextDraw(EditIndex);
	        }
	        case EDITMODE_USEBOX:
	        {
	            Project[EditIndex][iPositionX] = (floatdiv(NewX, ScreenWidth) * 640.0) + 2.0;
			    Project[EditIndex][iLetterY] = ((floatdiv(NewY, ScreenHeight) * 448.0) - Project[EditIndex][iPositionY])/9.0;
			    Project[EditIndex][iLetterY] -= 0.15;
			    UpdateTextDraw(EditIndex);
	        }
	        case EDITMODE_TEXTUREBOX:
	        {
	            Project[EditIndex][iTextX] = (floatdiv((NewX == ScreenWidth - 1) ? ScreenWidth : NewX, ScreenWidth) * 640.0) - Project[EditIndex][iPositionX];
	    		Project[EditIndex][iTextY] = (floatdiv((NewY == ScreenHeight - 1) ? ScreenHeight : NewY, ScreenHeight) * 448.0) - Project[EditIndex][iPositionY];
    			ShowValues(Project[EditIndex][iPositionY], Project[EditIndex][iTextX], Project[EditIndex][iTextY]);
				UpdateTextDraw(EditIndex);
	        }
	        case EDITMODE_SIZE:
			{
                if(Project[EditIndex][iUsebox] && Project[EditIndex][iLetterX] == 0.0)
			    {
			        Project[EditIndex][iLetterY] -= (floatdiv(floatsub(CursorOY, NewY), ScreenWidth) * 640.0)/10.0 * EditSpeed;
				    Project[EditIndex][iPositionX] -= floatdiv(floatsub(CursorOX, NewX), ScreenWidth) * 640.0 * EditSpeed;
			    } else {
				    Project[EditIndex][iTextX] -= floatdiv(floatsub(CursorOX, NewX), ScreenWidth) * 640.0 * EditSpeed;
				    Project[EditIndex][iTextY] -= floatdiv(floatsub(CursorOY, NewY), ScreenHeight) * 448.0 * EditSpeed;
				    ShowValues(Project[EditIndex][iPositionY], Project[EditIndex][iTextX], Project[EditIndex][iTextY]);
			    }
			    UpdateTextDraw(EditIndex);
			}
			case EDITMODE_LETTERSIZE:
			{
			    Project[EditIndex][iLetterX] -= floatdiv(floatsub(CursorOX, NewX), ScreenWidth) * 640.0 * EditSpeed * 0.001;
			    Project[EditIndex][iLetterY] -= floatdiv(floatsub(CursorOY, NewY), ScreenHeight) * 448.0 * EditSpeed * 0.01;
			    ShowValues(Project[EditIndex][iPositionY], Project[EditIndex][iLetterX], Project[EditIndex][iLetterY]);
			    UpdateTextDraw(EditIndex);
			}
			case EDITMODE_OUTLINE:
			{
			    Project[EditIndex][iOutline] -= floatround(floatdiv(floatsub(CursorOX, NewX), ScreenWidth) * 640.0);
			    Project[EditIndex][iOutline] -= floatround(floatdiv(floatsub(CursorOY, NewY), ScreenHeight) * 448.0);
			    UpdateTextDraw(EditIndex);
			}
			case EDITMODE_SHADOW:
			{
			    Project[EditIndex][iShadow] -= floatround(floatdiv(floatsub(CursorOX, NewX), ScreenWidth) * 640.0);
			    Project[EditIndex][iShadow] -= floatround(floatdiv(floatsub(CursorOY, NewY), ScreenHeight) * 448.0);
			    UpdateTextDraw(EditIndex);
			}
			case EDITMODE_COLOR:
	        {
	            HexToRGBA(Project[EditIndex][iColor], Colors[0], Colors[1], Colors[2], Colors[3]);
	            switch(ColorMode)
	            {
	                case COLORMODE_RED: Colors[0] = floatround(  floatdiv((NewY - 1), (ScreenHeight - 2)) * 255.0  );
	                case COLORMODE_GREEN: Colors[1] = floatround(  floatdiv((NewX - 1), (ScreenWidth - 2)) * 255.0  );
                    case COLORMODE_BLUE: Colors[2] = floatround(  floatdiv((NewY - 1), (ScreenHeight - 2)) * 255.0 );
                    case COLORMODE_ALPHA: Colors[3] = floatround(  floatdiv((NewX - 1), (ScreenWidth - 2)) * 255.0  );
				}
				format(String_Normal, sizeof String_Normal, "~n~~r~R%i~n~~g~G%i~n~~b~B%i~n~~w~A%i", Colors[0], Colors[1], Colors[2], Colors[3]);
				GameTextForPlayer(ProjectEditor, String_Normal, 1000, 3);
	            Project[EditIndex][iColor] = RGBAToHex(Colors[0], Colors[1], Colors[2], Colors[3]);
	            UpdateTextDraw(EditIndex);
	        }
	        case EDITMODE_BGCOLOR:
	        {
	            HexToRGBA(Project[EditIndex][iBackgroundcolor], Colors[0], Colors[1], Colors[2], Colors[3]);
	            switch(ColorMode)
	            {
	                case COLORMODE_RED: Colors[0] = floatround(  floatdiv((NewY - 1), (ScreenHeight - 2)) * 255.0  );
	                case COLORMODE_GREEN: Colors[1] = floatround(  floatdiv((NewX - 1), (ScreenWidth - 2)) * 255.0  );
                    case COLORMODE_BLUE: Colors[2] = floatround(  floatdiv((NewY - 1), (ScreenHeight - 2)) * 255.0 );
                    case COLORMODE_ALPHA: Colors[3] = floatround(  floatdiv((NewX - 1), (ScreenWidth - 2)) * 255.0  );
				}
				format(String_Normal, sizeof String_Normal, "~n~~r~R%i~n~~g~G%i~n~~b~B%i~n~~w~A%i", Colors[0], Colors[1], Colors[2], Colors[3]);
				GameTextForPlayer(ProjectEditor, String_Normal, 1000, 3);
	            Project[EditIndex][iBackgroundcolor] = RGBAToHex(Colors[0], Colors[1], Colors[2], Colors[3]);
	            UpdateTextDraw(EditIndex);
	        }
	        case EDITMODE_BOXCOLOR:
	        {
	            HexToRGBA(Project[EditIndex][iBoxcolor], Colors[0], Colors[1], Colors[2], Colors[3]);
	            switch(ColorMode)
	            {
	                case COLORMODE_RED: Colors[0] = floatround(  floatdiv((NewY - 1), (ScreenHeight - 2)) * 255.0  );
	                case COLORMODE_GREEN: Colors[1] = floatround(  floatdiv((NewX - 1), (ScreenWidth - 2)) * 255.0  );
                    case COLORMODE_BLUE: Colors[2] = floatround(  floatdiv((NewY - 1), (ScreenHeight - 2)) * 255.0 );
                    case COLORMODE_ALPHA: Colors[3] = floatround(  floatdiv((NewX - 1), (ScreenWidth - 2)) * 255.0  );
				}
				format(String_Normal, sizeof String_Normal, "~n~~r~R%i~n~~g~G%i~n~~b~B%i~n~~w~A%i", Colors[0], Colors[1], Colors[2], Colors[3]);
				GameTextForPlayer(ProjectEditor, String_Normal, 1000, 3);
	            Project[EditIndex][iBoxcolor] = RGBAToHex(Colors[0], Colors[1], Colors[2], Colors[3]);
	            UpdateTextDraw(EditIndex);
	        }
	    }
	}
	return true;
}

forward OnVirtualKeyDown(key);
public OnVirtualKeyDown(key)
{
    if(!EditEnabled && ProjectEditor != INVALID_PLAYER_ID && MenuHidden && MenuShown && !DialogShown)
	{
	    switch(key)
	    {
	        case VK_KEY_M: ShowTextDrawList();
			case VK_KEY_N: ShowCreateDialog();
			case VK_KEY_Z: UndoTextDrawState();
	    }
	    if(EditIndex != INVALID_INDEX_ID)
	    {
			if(Project[EditIndex][iTextdraw] != Text:INVALID_TEXT_DRAW)
			{
			    switch(key)
			    {
			        case VK_KEY_C: 
			        {
						new ToIndex = GetAvailableIndex();
						if(ToIndex == INVALID_INDEX_ID) return Send(ProjectEditor, -1, #ITD_E"Project Textdraw limit reached! Unable to create new.");
						CopyTextDraw(EditIndex, ToIndex);
			        }
			        case VK_KEY_X:
			        {
			            TextDrawEdit(EDITMODE_REMOVE);
						ShowTextDrawList();
			        }
			        case VK_KEY_F: TextDrawEdit(EDITMODE_FONT);
			        case VK_KEY_P: TextDrawEdit(EDITMODE_POSITION);
			        case VK_KEY_S: ShowSizeDialog(true);
			        case VK_KEY_Y: ShowTextDialog();
			        case VK_KEY_L: ShowLetterDialog();
			        case VK_KEY_Q: TextDrawEdit(EDITMODE_COLOR);
			        case VK_KEY_B: TextDrawEdit(EDITMODE_BGCOLOR);
			        case VK_KEY_I: TextDrawEdit(EDITMODE_BOXCOLOR);
			        case VK_KEY_U: TextDrawEdit(EDITMODE_BOX);
			        case VK_KEY_O: TextDrawEdit(EDITMODE_OUTLINE);
			        case VK_KEY_W: TextDrawEdit(EDITMODE_SHADOW);
			        case VK_KEY_G: TextDrawEdit(EDITMODE_TYPE);
			        case VK_KEY_A: TextDrawEdit(EDITMODE_ALIGNMENT);
			        case VK_KEY_K: TextDrawEdit(EDITMODE_SELECTABLE);
			        case VK_KEY_R: TextDrawEdit(EDITMODE_PROPORTION);
				}
			}
	    }
	}
	
	switch(key)
	{
	    case VK_LBUTTON:
	    {
	        switch(EditMode)
	        {
	            case EDITMODE_COLOR, EDITMODE_BOXCOLOR, EDITMODE_BGCOLOR:
		        {
              		SaveTextDrawState(EditIndex);

		            if(!CursorX && (0 < CursorY < (ScreenHeight - 1)) && ColorMode != COLORMODE_RED)
					ColorMode = COLORMODE_RED;

		            if(CursorX == (ScreenWidth - 1) && (0 < CursorY < (ScreenHeight - 1)) && ColorMode != COLORMODE_BLUE)
					ColorMode = COLORMODE_BLUE;

		            if(!CursorY && (0 < CursorX < (ScreenWidth - 1)) && ColorMode != COLORMODE_GREEN)
					ColorMode = COLORMODE_GREEN;

		            if(CursorY == (ScreenHeight - 1) && (0 < CursorX < (ScreenWidth - 1)) && ColorMode != COLORMODE_ALPHA)
					ColorMode = COLORMODE_ALPHA;

		            EditEnabled = true;
		        }
	            case EDITMODE_TEXTDRAW:
	            {
	                SaveTextDrawState(EditIndex, true);
	                
					format(Project[EditIndex][iText], 128, "New Textdraw");
	                Project[EditIndex][iPositionX] = floatdiv(CursorX, ScreenWidth) * 640.0;
				    Project[EditIndex][iPositionY] = floatdiv(CursorY, ScreenHeight) * 448.0;
		            Project[EditIndex][iLetterX] = 0.45, Project[EditIndex][iLetterY] = 1.6;
		            Project[EditIndex][iColor] = 0xFFFFFFFF;
				    Project[EditIndex][iBackgroundcolor] = 51;
				    Project[EditIndex][iFont] = 1;
				    Project[EditIndex][iOutline] = 1;
				    Project[EditIndex][iProportion] = 1;
				    Project[EditIndex][iAlignment] = 1;
				    UpdateTextDraw(EditIndex);
				    EditMode = EDITMODE_POSITION;
				    EditEnabled = true;
	            }
	            case EDITMODE_USEBOX:
	            {
	                SaveTextDrawState(EditIndex, true);
	                
	                format(Project[EditIndex][iText], 128, "usebox");
	                Project[EditIndex][iAlignment] = 1;
	                Project[EditIndex][iBoxcolor] = 0x00000066;
	                Project[EditIndex][iUsebox] = 1;
	                Project[EditIndex][iPositionX] = (floatdiv(CursorX, ScreenWidth) * 640.0) - 2.0;
					Project[EditIndex][iPositionY] = (floatdiv(CursorY, ScreenHeight) * 448.0) + 1.5;
					Project[EditIndex][iTextX] = Project[EditIndex][iPositionX];
					Project[EditIndex][iLetterX] = 0.0;
					Project[EditIndex][iLetterY] = 0.0;
					EditEnabled = true;
	            }
	            case EDITMODE_TEXTUREBOX:
	            {
	                SaveTextDrawState(EditIndex, true);
	                
	                format(Project[EditIndex][iText], 128, "LD_SPAC:white");
				    Project[EditIndex][iAlignment] = 1;
				    Project[EditIndex][iFont] = 4;
				    Project[EditIndex][iPositionX] = floatdiv(CursorX, ScreenWidth) * 640.0;
				    Project[EditIndex][iPositionY] = floatdiv(CursorY, ScreenHeight) * 448.0;
				    Project[EditIndex][iColor] = 0xFFFFFFFF;
					EditEnabled = true;
	            }
	            case EDITMODE_POSITION, EDITMODE_SIZE, EDITMODE_LETTERSIZE, EDITMODE_OUTLINE, EDITMODE_SHADOW:
	            {
	                SaveTextDrawState(EditIndex);
	                EditEnabled = true;
	            }
	        }
	    }
	    case VK_RBUTTON:
	    {
	        switch(EditMode)
		    {
		        case EDITMODE_OUTLINE:
				{
					SaveTextDrawState(EditIndex);
					Project[EditIndex][iOutline] = 0;
					UpdateTextDraw(EditIndex);
				}
		        case EDITMODE_SHADOW:
				{
					SaveTextDrawState(EditIndex);
					Project[EditIndex][iShadow] = 0;
					UpdateTextDraw(EditIndex);
				}
				case EDITMODE_POSITION:
				{
				    SaveTextDrawState(EditIndex);
				    Project[EditIndex][iPositionX] = floatdiv(floatdiv(ScreenWidth, 2), ScreenWidth) * 640.0;
				    Project[EditIndex][iPositionY] = floatdiv(floatdiv(ScreenHeight, 2), ScreenHeight) * 448.0;
                    UpdateTextDraw(EditIndex);
				}
		    }
	    }
	    case VK_SPACE: EditSpeed = 0.1;
	    case VK_LSHIFT, VK_RSHIFT: EditSpeed = 5.0;
	}
	return true;
}

forward OnVirtualKeyRelease(key);
public OnVirtualKeyRelease(key)
{
    if(key == VK_LBUTTON)
	{
	    if(EditEnabled)
	    {
	        if(ColorMode) ColorMode = 0;
	        EditEnabled = false;
	        SaveProject();
	    }
	}
	if(key == VK_SPACE || key == VK_LSHIFT) EditSpeed = 1.0;
	return true;
}

//============================================================================//

stock TextDrawEdit(mode)
{
	if(!mode)
	{
	    if(EditEnabled)
	    {
	        ColorMode 	= COLORMODE_NONE;
	        EditMode  	= EDITMODE_NONE;
	        EditEnabled = false;
	        SaveProject(false);
	    }
	} else
	{
	    if(EditIndex == INVALID_INDEX_ID)
		{
		    ShowTextDrawList();
			Send(ProjectEditor, -1, #ITD_W"You need to select a textdraw from the menu first!");
			return true;
	    }
	    
	    switch(mode)
	    {
         	case EDITMODE_TEXTDRAW:
	        {
				Send(ProjectEditor, -1, "Create {00FF00}New Textdraw{FFFFFF}: Press LMB to place and MOVE cursor to relocate");
	            EditMode = EDITMODE_TEXTDRAW;
	            HideEditor(true);
	        }
	        case EDITMODE_USEBOX:
	        {
	            Send(ProjectEditor, -1, "Create {00FF00}Box{FFFFFF}: Press LMB to start and MOVE cursor to resize and release LMB to stop");
	            EditMode = EDITMODE_USEBOX;
	            HideEditor(true);
	        }
	        case EDITMODE_TEXTUREBOX:
	        {
	            Send(ProjectEditor, -1, "Create {00FF00}Texture Box{FFFFFF}: Press LMB to start and MOVE cursor to resize and release LMB to stop");
	            EditMode = EDITMODE_TEXTUREBOX;
	            HideEditor(true);
	        }
	        case EDITMODE_POSITION:
	        {
	            Send(ProjectEditor, -1, "Modify {00FF00}Position{FFFFFF}: Hold LMB and MOVE cursor to relocate");
	            EditMode = EDITMODE_POSITION;
	            HideEditor(true);
	        }
	        case EDITMODE_SIZE:
	        {
	            Send(ProjectEditor, -1, "Modify {00FF00}Size{FFFFFF}: Hold LMB and MOVE cursor to resize (If you want to resize font, use LetterSize Mode)");
                EditMode = EDITMODE_SIZE;
                HideEditor(true);
			}
			case EDITMODE_LETTERSIZE:
	        {
	            Send(ProjectEditor, -1, "Modify {00FF00}LetterSize{FFFFFF}: Hold LMB and MOVE cursor to adjust");
                EditMode = EDITMODE_LETTERSIZE;
                HideEditor(true);
			}
			case EDITMODE_COLOR:
	        {
	            EditMode = EDITMODE_COLOR;
	            ShowColorDialog();
			}
			case EDITMODE_BGCOLOR:
			{
			    EditMode = EDITMODE_BGCOLOR;
			    ShowColorDialog();
			}
			case EDITMODE_BOXCOLOR:
			{
			    EditMode = EDITMODE_BOXCOLOR;
			    ShowColorDialog();
			}
			case EDITMODE_OUTLINE:
			{
			    Project[EditIndex][iShadow] = 0;
                Send(ProjectEditor, -1, "Modify {00FF00}Outline{FFFFFF}: Hold LMB and MOVE cursor to adjust | RMB to disable outline.");
                EditMode = EDITMODE_OUTLINE;
                HideEditor(true);
			}
			case EDITMODE_SHADOW:
			{
			    Project[EditIndex][iOutline] = 0;
				Send(ProjectEditor, -1, "Modify {00FF00}Shadow{FFFFFF}: Hold LMB and MOVE cursor to adjust | RMB to disable shadow.");
                EditMode = EDITMODE_SHADOW;
                HideEditor(true);
			}
			case EDITMODE_ALIGNMENT:
			{
			    SaveTextDrawState(EditIndex);
			    switch(Project[EditIndex][iAlignment])
			    {
			        case 1: Project[EditIndex][iAlignment] = 2, Send(ProjectEditor, -1, "Textdraw {00FF00}Alignment{FFFFFF}: Centered");
			        case 2: Project[EditIndex][iAlignment] = 3, Send(ProjectEditor, -1, "Textdraw {00FF00}Alignment{FFFFFF}: Right");
			        case 3: Project[EditIndex][iAlignment] = 1, Send(ProjectEditor, -1, "Textdraw {00FF00}Alignment{FFFFFF}: Left");
			    }
			    if(!MenuHidden) ShowEditor();
			    UpdateTextDraw(EditIndex);
			}
			case EDITMODE_PROPORTION:
			{
			    SaveTextDrawState(EditIndex);
			    switch(Project[EditIndex][iProportion])
			    {
			        case 0: Project[EditIndex][iProportion] = 1, Send(ProjectEditor, -1, "Textdraw {00FF00}Proportional{FFFFFF}: Yes");
			        case 1: Project[EditIndex][iProportion] = 0, Send(ProjectEditor, -1, "Textdraw {00FF00}Proportional{FFFFFF}: No");
				}
			    if(!MenuHidden) ShowEditor();
			    UpdateTextDraw(EditIndex);
			}
			case EDITMODE_SELECTABLE:
			{
			    SaveTextDrawState(EditIndex);
			    switch(Project[EditIndex][iSelectable])
			    {
			        case 0: Project[EditIndex][iSelectable] = 1, Send(ProjectEditor, -1, "Textdraw {00FF00}Selectable{FFFFFF}: Yes");
			        case 1: Project[EditIndex][iSelectable] = 0, Send(ProjectEditor, -1, "Textdraw {00FF00}Selectable{FFFFFF}: No");
				}
			    if(!MenuHidden) ShowEditor();
			    UpdateTextDraw(EditIndex);
			}
			case EDITMODE_BOX:
			{
			    SaveTextDrawState(EditIndex);
			    switch(Project[EditIndex][iUsebox])
			    {
			        case 0: Project[EditIndex][iUsebox] = 1, Project[EditIndex][iBoxcolor] = 255, Send(ProjectEditor, -1, "Textdraw {00FF00}Box{FFFFFF}: Enabled");
			        case 1: Project[EditIndex][iUsebox] = 0, Send(ProjectEditor, -1, "Textdraw {00FF00}Box{FFFFFF}: Disabled");
			    }
			    if(!MenuHidden) ShowEditor();
			    UpdateTextDraw(EditIndex);
			}
			case EDITMODE_FONT:
			{
			    SaveTextDrawState(EditIndex);
			    switch(Project[EditIndex][iFont])
			    {
			        case 0: Project[EditIndex][iFont] = 1, Send(ProjectEditor, -1, "Textdraw {00FF00}Font{FFFFFF}: 1 Normal");
			        case 1: Project[EditIndex][iFont] = 2, Send(ProjectEditor, -1, "Textdraw {00FF00}Font{FFFFFF}: 2 Modern");
			        case 2: Project[EditIndex][iFont] = 3, Send(ProjectEditor, -1, "Textdraw {00FF00}Font{FFFFFF}: 3 Bold");
			        case 3: Project[EditIndex][iFont] = 4, Send(ProjectEditor, -1, "Textdraw {00FF00}Font{FFFFFF}: 4 TXD Image");
			        case 4: Project[EditIndex][iFont] = 0, Send(ProjectEditor, -1, "Textdraw {00FF00}Font{FFFFFF}: 0 Oldschool");
			    }
			    if(!MenuHidden) ShowEditor();
			    UpdateTextDraw(EditIndex);
			}
			case EDITMODE_TYPE:
			{
			    SaveTextDrawState(EditIndex);
			    switch(Project[EditIndex][iType])
			    {
			        case 0: Project[EditIndex][iType] = 1, Send(ProjectEditor, -1, "Textdraw {00FF00}Type{FFFFFF}: PlayerTextDraw");
			        case 1: Project[EditIndex][iType] = 0, Send(ProjectEditor, -1, "Textdraw {00FF00}Type{FFFFFF}: Global TextDraw");
			    }
			    if(!MenuHidden) ShowEditor();
			    UpdateTextDraw(EditIndex);
			}
			case EDITMODE_REMOVE:
			{
			    SaveTextDrawState(EditIndex);
			    
			    format(String_Normal, sizeof String_Normal, #ITD_I"Deleted Textdraw(%i)", EditIndex);
			    Send(ProjectEditor, -1, String_Normal);
			    RemoveTextDraw(EditIndex);
				ShowEditor();
			}
	    }
	}
	return true;
}

//============================================================================//

stock ShowTextSizeWarning()
{
	String_Textdraw = "{FFFF00}WARNING\n\n{FFFFFF}You are trying to edit the Text Size when you don't have any box or image enabled.\n";
	strcat(String_Textdraw, "This will result the textdraws to automatically create new lines in order to adjust your desired text size.\n\n");
	strcat(String_Textdraw, "\n{00FF00}Q: I'm trying to resize FONT.\n{FFFFFF}A: Please use the 'Letter Size' tool (Size tool is for texture/box)\n");
	strcat(String_Textdraw, "\n{00FF00}Q: I'm trying to resize CLICKABLE AREA.\n{FFFFFF}A: You may continue.\n");
	strcat(String_Textdraw, "\n{00FF00}Q: I'm trying to make a FIXED REGION for my display text.\n{FFFFFF}A: You may continue.");

	return iShowPlayerDialog(ProjectEditor, DIALOG_WARNING, DIALOG_STYLE_MSGBOX,
	"Text Size Warning", String_Textdraw, "Cancel", "Continue");
}

stock ShowCreateDialog()
{
    return iShowPlayerDialog(ProjectEditor, DIALOG_CREATE, DIALOG_STYLE_LIST,
	"Create a new TextDraw",
	"+ Create Normal Textdraw\n\
	+ Create Box (Uses \"TextDrawUseBox\" method)\n\
	+ Create Texture Box(uses \"LD_SPAC:white\" texture)",
	"OK", "Back");
}

stock ShowTextDialog()
{
	format(String_Message, sizeof String_Message,
	"Please enter a new text below.\n\nCurrent Text: %s", Project[EditIndex][iText]);
	
	return iShowPlayerDialog(ProjectEditor, DIALOG_TEXT, DIALOG_STYLE_INPUT,
	"Change TextDraw String", String_Message, "OK", "Cancel");
}

stock ShowPositionDialog()
{
    return iShowPlayerDialog(ProjectEditor, DIALOG_POSITION, DIALOG_STYLE_LIST, "Change Position",
	"- Use the Mouse Pointer\n\
     - Set the Position Manually\n", "OK", "Cancel");
}

stock ShowPositionCustomDialog()
{
	format(String_Textdraw, sizeof String_Textdraw,
	"Current Position: X: %f Y: %f\n\n\
	 Please enter the desired coordinates\n\
     Make sure you use one the following formats:\n\
	 X Y | X, Y | X.00, Y.00 | X.00 Y.00",
	 Project[EditIndex][iPositionX],
	 Project[EditIndex][iPositionY]);
	 
    return iShowPlayerDialog(ProjectEditor, DIALOG_POSITIONC, DIALOG_STYLE_INPUT, "Enter Coordinates",
	String_Textdraw, "OK", "Back");
}

stock ShowSizeDialog(bool:warn = false)
{
	if(warn && Project[EditIndex][iFont] != 4 && !Project[EditIndex][iUsebox]) return ShowTextSizeWarning();
	return iShowPlayerDialog(ProjectEditor, DIALOG_SIZE, DIALOG_STYLE_LIST, "Change Text Size",
	"- Use the Mouse Pointer\n\
     - Set the Text Size Manually\n", "OK", "Cancel");
}

stock ShowSizeCustomDialog()
{
	format(String_Textdraw, sizeof String_Textdraw,
	"Current Text Size: Width: %f Height: %f\n\n\
	 Please enter the desired size\n\
     Make sure you use one the following formats:\n\
	 Width Height | Width, Height | Width.00 Height.00 | Width.00, Height.00",
	 Project[EditIndex][iTextX],
	 Project[EditIndex][iTextY]);

    return iShowPlayerDialog(ProjectEditor, DIALOG_SIZEC, DIALOG_STYLE_INPUT, "Enter Text Size",
	String_Textdraw, "OK", "Back");
}

stock ShowLetterDialog()
{
	return iShowPlayerDialog(ProjectEditor, DIALOG_LETTER, DIALOG_STYLE_LIST, "Change Letter Size",
	"- Use the Mouse Pointer\n\
     - Set the Letter Size Manually\n", "OK", "Cancel");
}

stock ShowLetterCustomDialog()
{
	format(String_Textdraw, sizeof String_Textdraw,
	"Current Letter Size: Width: %f Height: %f\n\n\
	 Please enter the desired size\n\
     Make sure you use one the following formats:\n\
	 Width Height | Width, Height | Width.00 Height.00 | Width.00, Height.00",
	 Project[EditIndex][iLetterX],
	 Project[EditIndex][iLetterY]);

    return iShowPlayerDialog(ProjectEditor, DIALOG_LETTERC, DIALOG_STYLE_INPUT, "Enter Letter Size",
	String_Textdraw, "OK", "Back");
}

stock ShowColorDialog()
{
	new heading[32];
	switch(EditMode)
	{
	    case EDITMODE_COLOR: heading = "TextDraw Color";
	    case EDITMODE_BGCOLOR: heading = "TextDraw Background Color";
	    case EDITMODE_BOXCOLOR: heading = "TextDraw Box Color";
	    default: return Send(ProjectEditor, -1, #ITD_E"Color edit type undefined (Report as bug)");
	}
	
    return iShowPlayerDialog(ProjectEditor, DIALOG_COLOR, DIALOG_STYLE_LIST, heading,
	"- Use Hexadecimal RGBA Code (e.g: 0xFFFFFFFF)\n\
     - Enter Alphanumeric RGBA Code (e.g: 255, 255, 255, 255)\n\
     - Select a Premade Color\n\
	 - Use the in-built color editor", "OK", "Cancel");
}

stock ShowHEXColorDialog()
{
	return iShowPlayerDialog(ProjectEditor, DIALOG_HEXCOLOR, DIALOG_STYLE_INPUT,
	"Input HEX Color Code", "Please enter a hexadecimal color code:\n\nMake sure it has one of the following forms:\n\
	0xRRGGBBAA | #RRGGBBAA | RRGGBBAA", "Done", "Back");
}

stock ShowNUMColorDialog()
{
	return iShowPlayerDialog(ProjectEditor, DIALOG_NUMCOLOR, DIALOG_STYLE_INPUT, "Input Numeric Color Code",
	"Please enter a numeric color code:\n\nMake sure it has one of the following forms:\n\
	R G B A | R, G, B, A | (Values from 0 to 255)", "Done", "Back");
}

stock ShowPREColorDialog()
{
	EmptyString(String_Textdraw);
	CountRange(0, sizeof PremadeColors)
	{
	    format(String_Normal, sizeof String_Normal, "{%06x}%s", PremadeColors[c][0] >>> 8, PremadeColors[c][1]);
	    strcat(String_Textdraw, String_Normal);
	    strcat(String_Textdraw, "\n");
	}
	
	return iShowPlayerDialog(ProjectEditor, DIALOG_PRECOLOR, DIALOG_STYLE_LIST, "Select a color",
	String_Textdraw, "Done", "Back");
}

stock ShowProjectList()
{
    String_Large = "(No projects created yet)";
    new bool:Found;

    Handler = fopen(ITD_List, io_read);
    if(Handler)
    {
	    while(fread(Handler, String_Normal))
	    {
			if(strlen(String_Normal))
			{
			    if(!Found)
				{
					EmptyString(String_Large);
					Found = true;
				}
				strcat(String_Large, String_Normal);
			}
		}
	    fclose(Handler);
    } else return Send(ProjectEditor, -1, #ITD_E"File I/O Error occured (project.lst)");
    
	return iShowPlayerDialog(ProjectEditor, DIALOG_PROJECTS, DIALOG_STYLE_LIST, "Projects", String_Large, "Open", "Cancel");
}

stock ShowTextDrawList()
{
	EmptyString(String_Large);
	strcat(String_Large, "{00FF00}> Create New TextDraw\n{FF0000}> Destroy Selected TextDraw");
	
	LoopProjectTextdraws
	{
	    if(Project[i][iTextdraw] == Text:INVALID_TEXT_DRAW) continue;
	    
	    format(String_Normal, sizeof String_Normal, "\n%s(%i)%s", EditIndex == i ? ("{00BFFF}"):(""), i, Project[i][iText]);
	    strcat(String_Large, String_Normal);
	}
	
	return iShowPlayerDialog(ProjectEditor, DIALOG_LIST, DIALOG_STYLE_LIST, "Project Textdraw List", String_Large, "Select", "Close");
}

//============================================================================//

stock AddProject(name[])
{
    Handler = fopen(ITD_List, io_append);
    if(!Handler) return Send(ProjectEditor, -1, #ITD_E"File I/O Error occured (project.lst)");

    fwrite(Handler, name);
    fwrite(Handler, "\r\n");
    fclose(Handler);
    
    printf("iTD: %s added to Projects.lst", name);
    return true;
}

stock CheckProject(name[])
{
    if(!fexist(ITD_List)) return false;
    
    Handler = fopen(ITD_List, io_read);
    if(!Handler) return Send(ProjectEditor, -1, #ITD_E"File I/O Error occured (project.lst)");
    
	while(fread(Handler, String_Normal))
	if(!strcmp(String_Normal, name, true, strlen(name)))
	{
	    //printf("iTD: %s exists in Projects.lst", name);
	    fclose(Handler);
	    return true;
	}
	
	//printf("iTD: %s does not exist in Projects.lst", name);
	fclose(Handler);
	return false;
}

stock RemoveProject(name[])
{
	if(!fexist(ITD_List)) return true;
	if(fexist(name)) fremove(name);

	Handler = fopen(ITD_List, io_read);
	if(!Handler) return Send(ProjectEditor, -1, #ITD_E"File I/O Error occured (project.lst)");

	EmptyString(String_Large);
	while(fread(Handler, String_Normal))
	if(strcmp(Project, name, true, strlen(name))) strcat(String_Large, String_Normal);

	fclose(Handler);
	fremove(ITD_List);
	
	Handler = fopen(ITD_List, io_append);
	if(!Handler) return Send(ProjectEditor, -1, #ITD_E"File I/O Error occured (project.lst)");
	
	fwrite(Handler, String_Large);
	fclose(Handler);
	return true;
}

stock SaveProject(bool:response = false)
{
	if(!strlen(ProjectFile)) return Send(ProjectEditor, -1, #ITD_E"No project is open to save");
    if(fexist(ProjectFile)) fremove(ProjectFile);

	Handler = fopen(ProjectFile, io_append);
    if(!Handler) return Send(ProjectEditor, -1, #ITD_E"File I/O Error occured (.iTD)");
    
    LoopProjectTextdraws
	{
	    if(Project[i][iTextdraw] == Text:INVALID_TEXT_DRAW) continue;
	    
	    format(String_Textdraw, sizeof String_Textdraw,
		"%f|%f|%f|%f|%f|%f|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%s\r\n",
	    Project[i][iPositionX], 		Project[i][iPositionY],
		Project[i][iLetterX], 			Project[i][iLetterY],
		Project[i][iTextX], 			Project[i][iTextY],
		Project[i][iAlignment], 		Project[i][iColor],
		Project[i][iUsebox], 			Project[i][iBoxcolor],
		Project[i][iShadow], 			Project[i][iOutline],
		Project[i][iBackgroundcolor], 	Project[i][iFont],
		Project[i][iProportion], 		Project[i][iSelectable],
		Project[i][iType], 				Project[i][iText]);
		fwrite(Handler, String_Textdraw);
	}
    fclose(Handler);
    
	if(response)
	{
	    format(String_Message, 128, "%sProject: '%s' has been saved!", ITD, ProjectFile);
	    Send(ProjectEditor, -1, String_Message);
	}
	return true;
}

stock CloseProject(bool:response = false)
{
    if(!strlen(ProjectFile)) return Send(ProjectEditor, -1, #ITD_E"No project is open to close");
    
    SaveProject();
    LoopProjectTextdraws RemoveTextDraw(i);
    
    if(response)
	{
	    format(String_Message, 128, "%sProject: '%s' has been closed!", ITD, ProjectFile);
	    Send(ProjectEditor, -1, String_Message);
	}
	
	EditIndex = INVALID_INDEX_ID;
	EditMode = EDITMODE_NONE;
	ColorMode = COLORMODE_NONE;
	EmptyString(ProjectFile);
	CountRange(0, sizeof States) EmptyString(States[c]);
	ShowEditor();
    return true;
}

stock LoadProject(bool:response = false)
{
    if(!strlen(ProjectFile)) return Send(ProjectEditor, -1, #ITD_E"Unexpected error occured while trying to load a project. (Report as bug)");
    
    Handler = fopen(ProjectFile, io_read);
    
    new Index;
    
    while(fread(Handler, String_Textdraw))
    {
        StripNewLine(String_Textdraw);
        
		if(!sscanf(String_Textdraw, "p<|>ffffffiiiiiiiiiiis[128]",
		Project[Index][iPositionX], 		Project[Index][iPositionY],
		Project[Index][iLetterX], 			Project[Index][iLetterY],
		Project[Index][iTextX], 			Project[Index][iTextY],
		Project[Index][iAlignment], 		Project[Index][iColor],
		Project[Index][iUsebox], 			Project[Index][iBoxcolor],
		Project[Index][iShadow], 			Project[Index][iOutline],
		Project[Index][iBackgroundcolor], 	Project[Index][iFont],
		Project[Index][iProportion], 		Project[Index][iSelectable],
		Project[Index][iType], 				Project[Index][iText]))
		{
		    EditIndex = Index;
		    UpdateTextDraw(Index, false);
		    TextDrawShowForPlayer(ProjectEditor, Project[Index][iTextdraw]);
		    Index++;
		}
    }
    
    fclose(Handler);
	ShowEditor();
    
    if(response)
	{
	    format(String_Message, 128, "%sProject: '%s' has been loaded!", ITD, ProjectFile);
	    Send(ProjectEditor, -1, String_Message);
	}
	return true;
}

stock ExportProject()
{
    if(!strlen(ProjectFile)) return Send(ProjectEditor, -1, #ITD_E"No project is open to export. (If this is a bug, please report)");
    
    new ExportFile[64];
    format(ExportFile, sizeof ExportFile, "%s", ProjectFile);
    strins(ExportFile, "TD_", 0);
    new len = strlen(ExportFile);
	strdel(ExportFile, len - 3, len);
	strcat(ExportFile, "pwn");
	
	format(String_Message, sizeof String_Message, #ITD"Exporting Project to '%s'..", ExportFile);
    
    if(fexist(ExportFile)) fremove(ExportFile);
	new File:ExportIO = fopen(ExportFile, io_append);
	if(!ExportIO) return Send(ProjectEditor, -1, #ITD_E"File I/O Error occurred (.pwn)");

	new bool:Type;

	new Index = -1;
	LoopProjectTextdraws
	{
	    if(Project[i][iTextdraw] == Text:INVALID_TEXT_DRAW) continue;
	    if(Project[i][iType]) continue;
	    if(!Type) fwrite(ExportIO, "//Global Textdraws:\r\n\r\n"), Type = true;
	    
	    Index++;
	    format(String_Textdraw, sizeof String_Textdraw, "new Text:Textdraw%i;\r\n", Index);
	    fwrite(ExportIO, String_Textdraw);
	}
	
	if(Type)
	{
		fwrite(ExportIO, "\r\n\r\n");
		Index = -1;
		LoopProjectTextdraws
		{
		    if(Project[i][iTextdraw] == Text:INVALID_TEXT_DRAW) continue;
		    if(Project[i][iType]) continue;

			Index++;
			format(String_Textdraw, sizeof String_Textdraw, "Textdraw%i = TextDrawCreate(%f, %f, \"%s\");\r\n", Index, Project[i][iPositionX], Project[i][iPositionY], Project[i][iText]);
			fwrite(ExportIO, String_Textdraw);

			format(String_Textdraw, sizeof String_Textdraw, "TextDrawLetterSize(Textdraw%i, %f, %f);\r\n", Index, Project[i][iLetterX], Project[i][iLetterY]);
			fwrite(ExportIO, String_Textdraw);

            if(floatadd(Project[i][iTextX], Project[i][iTextY]))
			{
				format(String_Textdraw, sizeof String_Textdraw, "TextDrawTextSize(Textdraw%i, %f, %f);\r\n", Index, Project[i][iTextX], Project[i][iTextY]);
				fwrite(ExportIO, String_Textdraw);
			}

			format(String_Textdraw, sizeof String_Textdraw, "TextDrawAlignment(Textdraw%i, %i);\r\n", Index, Project[i][iAlignment]);
			fwrite(ExportIO, String_Textdraw);

			format(String_Textdraw, sizeof String_Textdraw, "TextDrawColor(Textdraw%i, %i);\r\n", Index, Project[i][iColor]);
			fwrite(ExportIO, String_Textdraw);

			if(Project[i][iUsebox])
			{
				format(String_Textdraw, sizeof String_Textdraw, "TextDrawUseBox(Textdraw%i, true);\r\n", Index);
				fwrite(ExportIO, String_Textdraw);

				format(String_Textdraw, sizeof String_Textdraw, "TextDrawBoxColor(Textdraw%i, %i);\r\n", Index, Project[i][iBoxcolor]);
				fwrite(ExportIO, String_Textdraw);
			}

			format(String_Textdraw, sizeof String_Textdraw, "TextDrawSetShadow(Textdraw%i, %i);\r\n", Index, Project[i][iShadow]);
			fwrite(ExportIO, String_Textdraw);

			format(String_Textdraw, sizeof String_Textdraw, "TextDrawSetOutline(Textdraw%i, %i);\r\n", Index, Project[i][iOutline]);
			fwrite(ExportIO, String_Textdraw);

			if(Project[i][iBackgroundcolor])
			{
				format(String_Textdraw, sizeof String_Textdraw, "TextDrawBackgroundColor(Textdraw%i, %i);\r\n", Index, Project[i][iBackgroundcolor]);
				fwrite(ExportIO, String_Textdraw);
			}

			format(String_Textdraw, sizeof String_Textdraw, "TextDrawFont(Textdraw%i, %i);\r\n", Index, Project[i][iFont]);
			fwrite(ExportIO, String_Textdraw);

			if(Project[i][iProportion])
			{
				format(String_Textdraw, sizeof String_Textdraw, "TextDrawSetProportional(Textdraw%i, %i);\r\n", Index, Project[i][iProportion]);
				fwrite(ExportIO, String_Textdraw);
			}

			if(Project[i][iSelectable])
			{
				format(String_Textdraw, sizeof String_Textdraw, "TextDrawSetSelectable(Textdraw%i, true);\r\n", Index);
				fwrite(ExportIO, String_Textdraw);
			}
			fwrite(ExportIO, "\r\n");
		}
	}
	
	Type = false;
	
	new gTexts = Index; Index = -1;
	LoopProjectTextdraws
	{
	    if(Project[i][iTextdraw] == Text:INVALID_TEXT_DRAW) continue;
	    if(!Project[i][iType]) continue;
	    if(!Type) fwrite(ExportIO, "\r\n//Player Textdraws:\r\n\r\n"), Type = true;
	    Index++;
	    format(String_Textdraw, sizeof String_Textdraw, "new PlayerText:Textdraw%i[MAX_PLAYERS];\r\n", Index);
	    fwrite(ExportIO, String_Textdraw);
	}

    Index = -1;
	if(Type)
	{
		fwrite(ExportIO, "\r\n\r\n");
		LoopProjectTextdraws
		{
		    if(Project[i][iTextdraw] == Text:INVALID_TEXT_DRAW) continue;
		    if(!Project[i][iType]) continue;

			Index++;
			format(String_Textdraw, sizeof String_Textdraw, "Textdraw%i[playerid] = CreatePlayerTextDraw(playerid, %f, %f, \"%s\");\r\n", Index, Project[i][iPositionX], Project[i][iPositionY], Project[i][iText]);
			fwrite(ExportIO, String_Textdraw);

			format(String_Textdraw, sizeof String_Textdraw, "PlayerTextDrawLetterSize(playerid, Textdraw%i[playerid], %f, %f);\r\n", Index, Project[i][iLetterX], Project[i][iLetterY]);
			fwrite(ExportIO, String_Textdraw);

            if(floatadd(Project[i][iTextX], Project[i][iTextY]))
			{
				format(String_Textdraw, sizeof String_Textdraw, "PlayerTextDrawTextSize(playerid, Textdraw%i[playerid], %f, %f);\r\n", Index, Project[i][iTextX], Project[i][iTextY]);
				fwrite(ExportIO, String_Textdraw);
			}
			
			format(String_Textdraw, sizeof String_Textdraw, "PlayerTextDrawAlignment(playerid, Textdraw%i[playerid], %i);\r\n", Index, Project[i][iAlignment]);
			fwrite(ExportIO, String_Textdraw);

			format(String_Textdraw, sizeof String_Textdraw, "PlayerTextDrawColor(playerid, Textdraw%i[playerid], %i);\r\n", Index, Project[i][iColor]);
			fwrite(ExportIO, String_Textdraw);

			if(Project[i][iUsebox])
			{
				format(String_Textdraw, sizeof String_Textdraw, "PlayerTextDrawUseBox(playerid, Textdraw%i[playerid], true);\r\n", Index);
				fwrite(ExportIO, String_Textdraw);

				format(String_Textdraw, sizeof String_Textdraw, "PlayerTextDrawBoxColor(playerid, Textdraw%i[playerid], %i);\r\n", Index, Project[i][iBoxcolor]);
				fwrite(ExportIO, String_Textdraw);
			}

			format(String_Textdraw, sizeof String_Textdraw, "PlayerTextDrawSetShadow(playerid, Textdraw%i[playerid], %i);\r\n", Index, Project[i][iShadow]);
			fwrite(ExportIO, String_Textdraw);
				
			format(String_Textdraw, sizeof String_Textdraw, "PlayerTextDrawSetOutline(playerid, Textdraw%i[playerid], %i);\r\n", Index, Project[i][iOutline]);
			fwrite(ExportIO, String_Textdraw);

			if(Project[i][iBackgroundcolor])
			{
				format(String_Textdraw, sizeof String_Textdraw, "PlayerTextDrawBackgroundColor(playerid, Textdraw%i[playerid], %i);\r\n", Index, Project[i][iBackgroundcolor]);
				fwrite(ExportIO, String_Textdraw);
			}

			format(String_Textdraw, sizeof String_Textdraw, "PlayerTextDrawFont(playerid, Textdraw%i[playerid], %i);\r\n", Index, Project[i][iFont]);
			fwrite(ExportIO, String_Textdraw);

			if(Project[i][iProportion])
			{
				format(String_Textdraw, sizeof String_Textdraw, "PlayerTextDrawSetProportional(playerid, Textdraw%i[playerid], %i);\r\n", Index, Project[i][iProportion]);
				fwrite(ExportIO, String_Textdraw);
			}

			if(Project[i][iSelectable])
			{
				format(String_Textdraw, sizeof String_Textdraw, "PlayerTextDrawSetSelectable(playerid, Textdraw%i[playerid], true);\r\n", Index);
				fwrite(ExportIO, String_Textdraw);
			}
			
			fwrite(ExportIO, "\r\n");
		}
	}
	
	fclose(ExportIO);
	format(String_Message, sizeof String_Message, #ITD"Project Exported to '%s'! (%i Global Textdraws / %i Player Textdraws)", ExportFile, gTexts + 1, Index + 1);
	Send(ProjectEditor, -1, String_Message);
	return true;
}

stock UpdateTextDraw(Index, bool:Show = true)
{
	if(!(0 <= Index < sizeof Project)) return;
	
    TextDrawDestroy(Project[Index][iTextdraw]);
    Project[Index][iTextdraw] = Text:INVALID_TEXT_DRAW;
    
	Project[Index][iTextdraw] = TextDrawCreate
	(
		Project[Index][iPositionX],
		Project[Index][iPositionY],
		Project[Index][iText]
	);

	TextDrawLetterSize		(Project[Index][iTextdraw], Project[Index][iLetterX], Project[Index][iLetterY]);
	
	if(Project[Index][iUsebox] || Project[Index][iFont] == 4)
	TextDrawTextSize    	(Project[Index][iTextdraw], Project[Index][iTextX], Project[Index][iTextY]);
	
	TextDrawAlignment   	(Project[Index][iTextdraw], Project[Index][iAlignment] ? Project[Index][iAlignment] : 1);
	TextDrawColor   		(Project[Index][iTextdraw], Project[Index][iColor]);
	TextDrawUseBox   		(Project[Index][iTextdraw], Project[Index][iUsebox]);
	TextDrawBoxColor   		(Project[Index][iTextdraw], Project[Index][iBoxcolor]);
	TextDrawSetShadow   	(Project[Index][iTextdraw], Project[Index][iShadow]);
	TextDrawSetOutline  	(Project[Index][iTextdraw], Project[Index][iOutline]);
	TextDrawBackgroundColor (Project[Index][iTextdraw], Project[Index][iBackgroundcolor]);
	TextDrawFont   			(Project[Index][iTextdraw], Project[Index][iFont]);
	TextDrawSetProportional	(Project[Index][iTextdraw], Project[Index][iProportion]);

	if(Show) TextDrawShowForPlayer(ProjectEditor, Project[Index][iTextdraw]);
}

stock RemoveTextDraw(Index)
{
    if(!(0 <= Index < sizeof Project)) return;
    
	TextDrawDestroy(Project[Index][iTextdraw]);
	format(Project[Index][iText], 128, " ");
	Project[Index][iTextdraw] = Text:INVALID_TEXT_DRAW;
	Project[Index][iLetterX] = 0.0;
	Project[Index][iLetterY] = 0.0;
	Project[Index][iTextX] = 0.0;
	Project[Index][iTextY] = 0.0;
	Project[Index][iAlignment] = 1;
	Project[Index][iColor] = 0;
	Project[Index][iUsebox] = 0;
	Project[Index][iBoxcolor] = 0;
	Project[Index][iShadow] = 0;
	Project[Index][iOutline] = 0;
	Project[Index][iBackgroundcolor] = 0;
	Project[Index][iFont] = 0;
	Project[Index][iProportion] = 0;
	Project[Index][iSelectable] = 0;
	
	if(EditIndex == Index)
	{
	    EditMode = EDITMODE_NONE;
	    EditIndex = INVALID_INDEX_ID;
	}
}


stock CopyTextDraw(Index, ToIndex)
{
	if(!(0 <= Index < sizeof Project) || !(0 <= ToIndex < sizeof Project)) return;
	
	format(Project[ToIndex][iText], 128, "%s", Project[Index][iText]);
	Project[ToIndex][iPositionX] = Project[Index][iPositionX] + 1;
	Project[ToIndex][iPositionY] = Project[Index][iPositionY] + 1;
	Project[ToIndex][iLetterY] = Project[Index][iLetterY];
	Project[ToIndex][iLetterX] = Project[Index][iLetterX];
	Project[ToIndex][iLetterY] = Project[Index][iLetterY];
	Project[ToIndex][iTextX] = Project[Index][iTextX];
	Project[ToIndex][iTextY] = Project[Index][iTextY];
	Project[ToIndex][iAlignment] = Project[Index][iAlignment];
	Project[ToIndex][iColor] = Project[Index][iColor];
	Project[ToIndex][iUsebox] = Project[Index][iUsebox];
	Project[ToIndex][iBoxcolor] = Project[Index][iBoxcolor];
	Project[ToIndex][iShadow] = Project[Index][iShadow];
	Project[ToIndex][iOutline] = Project[Index][iOutline];
	Project[ToIndex][iBackgroundcolor] = Project[Index][iBackgroundcolor];
	Project[ToIndex][iFont] = Project[Index][iFont];
	Project[ToIndex][iProportion] = Project[Index][iProportion];
	Project[ToIndex][iSelectable] = Project[Index][iSelectable];
	
	EditIndex = ToIndex;
	UpdateTextDraw(ToIndex);
	SaveTextDrawState(EditIndex, true);
	
	format(String_Message, sizeof String_Message, #ITD_I"Textdraw (%i) Copied as new Textdraw (%i)", Index, ToIndex);
	Send(ProjectEditor, -1, String_Message);
	if(EditMode) EditMode = EDITMODE_POSITION;
}

stock SaveTextDrawState(Index, bool:Remove = false)
{
	for( new i = 0; i < MAX_UNDO_STATES - 1; i++ )
	States[i] = States[i + 1];

	if(Remove) format(States[MAX_UNDO_STATES - 1], sizeof States[], "%i", Index);
	else
	{
	    format(States[MAX_UNDO_STATES - 1], sizeof States[],
	    
		"%i|%f|%f|%f|%f|%f|%f|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%s",
		
		Index,
	    Project[Index][iPositionX], 		Project[Index][iPositionY],
		Project[Index][iLetterX], 			Project[Index][iLetterY],
		Project[Index][iTextX], 			Project[Index][iTextY],
		Project[Index][iAlignment], 		Project[Index][iColor],
		Project[Index][iUsebox], 			Project[Index][iBoxcolor],
		Project[Index][iShadow], 			Project[Index][iOutline],
		Project[Index][iBackgroundcolor],	Project[Index][iFont],
		Project[Index][iProportion], 		Project[Index][iSelectable],
		Project[Index][iType], 				Project[Index][iText]);
	}
}

stock UndoTextDrawState()
{
	new
		iCount,
		iIndex = INVALID_INDEX_ID
	;

	CountRange(0, MAX_UNDO_STATES) if(!isnull(States[c])) iIndex = c, iCount++;
	if(iIndex == INVALID_INDEX_ID) return Send(ProjectEditor, -1, #ITD_E"Can't undo anymore.");

	new index = -1, Float:ucX, Float:ucY, Float:ulX, Float:ulY, Float:utX, Float:utY,
	uAl, uCl, uUb, uBc, uSd, uOl, uBg, uFt, uPr, uSl, uT, uS[64];

	if(!sscanf(States[iIndex], "p<|>iffffffiiiiiiiiiiis[128]", index, ucX, ucY, ulX, ulY, utX, utY,
	uAl, uCl, uUb, uBc, uSd, uOl, uBg, uFt, uPr, uSl, uT, uS))
	{
	    if(index != -1)
	    {
	        Project[index][iPositionX] = ucX;
			Project[index][iPositionY] = ucY;
			Project[index][iLetterX] = ulX;
			Project[index][iLetterY] = ulY;
			Project[index][iTextX] = utX;
			Project[index][iTextY] = utY;
			Project[index][iAlignment] = uAl;
			Project[index][iColor] = uCl;
			Project[index][iUsebox] = uUb;
			Project[index][iBoxcolor] = uBc;
			Project[index][iShadow] = uSd;
			Project[index][iOutline] = uOl;
			Project[index][iBackgroundcolor] = uBg;
			Project[index][iFont] = uFt;
			Project[index][iProportion] = uPr;
			Project[index][iSelectable] = uSl;
			Project[index][iType] = uT;
			format(Project[index][iText], 128, "%s", uS);
			EditIndex = index;
			UpdateTextDraw(EditIndex);
	    }
	} else if(!sscanf(States[iIndex], "i", index))
	{
		if(0 <= index < sizeof Project) RemoveTextDraw(index);
	}

	EmptyString(States[iIndex]);
	format(String_Message, sizeof String_Message, #ITD_I"{00FF00}Undo{FFFFFF} applied (%i remaining)", iCount - 1);
	return Send(ProjectEditor, -1, String_Message);
}

stock ShowEditor()
{
    DestroyMenuTextDraws();
    CreateMenuTextDraws();
    
	TogglePlayerControllable(ProjectEditor, false);
	
	if(EditIndex != INVALID_INDEX_ID)
	{
	    CountRange(0, sizeof TD_Menu)
	    {
	        TextDrawColor(TD_Menu[c], 0xDDDDDDFF);
	        TextDrawSetSelectable(TD_Menu[c], true);
	        
	        switch(c)
	        {
	            case 24, 25, 26, 27, 12:
		        {
			        switch(Project[EditIndex][iFont])
					{
					    case 0: TextDrawShowForPlayer(ProjectEditor, TD_Menu[24]);
					    case 1: TextDrawShowForPlayer(ProjectEditor, TD_Menu[25]);
					    case 2: TextDrawShowForPlayer(ProjectEditor, TD_Menu[26]);
					    case 3: TextDrawShowForPlayer(ProjectEditor, TD_Menu[27]);
					    case 4: TextDrawShowForPlayer(ProjectEditor, TD_Menu[12]);
					}
				}
				case 5, 33:
		        {
			        switch(Project[EditIndex][iType])
					{
					    case 0: TextDrawShowForPlayer(ProjectEditor, TD_Menu[5]);
					    case 1: TextDrawShowForPlayer(ProjectEditor, TD_Menu[33]);
					}
				}
				case 30, 31:
		        {
			        switch(Project[EditIndex][iProportion])
					{
					    case 0: TextDrawShowForPlayer(ProjectEditor, TD_Menu[30]);
					    case 1: TextDrawShowForPlayer(ProjectEditor, TD_Menu[31]);
					}
				}
				case 28, 29:
		        {
			        switch(Project[EditIndex][iSelectable])
					{
					    case 0: TextDrawShowForPlayer(ProjectEditor, TD_Menu[28]);
					    case 1: TextDrawShowForPlayer(ProjectEditor, TD_Menu[29]);
					}
				}
				case 21, 22, 23:
		        {
			        switch(Project[EditIndex][iAlignment])
					{
					    case 1: TextDrawShowForPlayer(ProjectEditor, TD_Menu[21]);
					    case 2: TextDrawShowForPlayer(ProjectEditor, TD_Menu[22]);
					    case 3: TextDrawShowForPlayer(ProjectEditor, TD_Menu[23]);
					    default:
						{
						    Project[EditIndex][iAlignment] = 1;
							TextDrawShowForPlayer(ProjectEditor, TD_Menu[21]);
						}
					}
				}
				case 19, 20:
		        {
			        switch(Project[EditIndex][iUsebox])
					{
					    case 0: TextDrawShowForPlayer(ProjectEditor, TD_Menu[19]);
					    case 1: TextDrawShowForPlayer(ProjectEditor, TD_Menu[20]);
					}
				}
				case 6, 7, 13:
				{
				    TextDrawColor(TD_Menu[c], 0xFFFFFFFF);
				    TextDrawSetSelectable(TD_Menu[c], false);
				    TextDrawShowForPlayer(ProjectEditor, TD_Menu[c]);
				}
				case 0:
				{
				    TextDrawColor(TD_Menu[c], 0x000000FF);
				    TextDrawSetSelectable(TD_Menu[c], false);
				    TextDrawShowForPlayer(ProjectEditor, TD_Menu[c]);
				}
				default: TextDrawShowForPlayer(ProjectEditor, TD_Menu[c]);
	        }
	    }
	    
	} else {
	    CountRange(0, sizeof TD_Menu)
	    {
	        switch(c)
	        {
	            case 1, 2:
	            {
	                TextDrawColor(TD_Menu[c], 0xDDDDDDFF);
	                TextDrawSetSelectable(TD_Menu[c], true);
	            }
	            case 3, 4, 8:
				{
				    if(strlen(ProjectFile))
				    {
						TextDrawColor(TD_Menu[c], 0xDDDDDDFF);
						TextDrawSetSelectable(TD_Menu[c], true);
					} else {
					    TextDrawColor(TD_Menu[c], 0x888888FF);
					    TextDrawSetSelectable(TD_Menu[c], false);
					}
				}
				case 5, 9..12, 14..33:
				{
				    TextDrawColor(TD_Menu[c], 0x888888FF);
				    TextDrawSetSelectable(TD_Menu[c], false);
				}
	        }
	        TextDrawShowForPlayer(ProjectEditor, TD_Menu[c]);
	    }
	}
	
	SelectTextDraw(ProjectEditor, 0xFFFFFFFF);
	MenuShown = true;
	MenuHidden = false;
	EditMode = EDITMODE_NONE;
	if(strlen(ProjectFile)) SaveProject(false);
	return true;
}

stock HideEditor(bool:temp = false)
{
	if(temp)
	{
	    DestroyMenuTextDraws();
	    MenuHidden = true;
	    return true;
	}
	
    DestroyMenuTextDraws();
    TogglePlayerControllable(ProjectEditor, true);
    EditMode = EDITMODE_NONE;
	EditIndex = INVALID_INDEX_ID;
	MenuHidden = false;
	ProjectEditor = INVALID_PLAYER_ID;
	MenuShown = false;
	return true;
}

stock Initiate()
{
	if(!fexist(ITD_List)) {
		new File:IO = fopen(ITD_List, io_write);
		fclose(IO);
	}
	
    VirtualKeys[0][KEY_CODE] = VK_KEY_A;
    VirtualKeys[1][KEY_CODE] = VK_KEY_B;
    VirtualKeys[2][KEY_CODE] = VK_KEY_C;
    VirtualKeys[3][KEY_CODE] = VK_KEY_D;
    VirtualKeys[4][KEY_CODE] = VK_KEY_E;
    VirtualKeys[5][KEY_CODE] = VK_KEY_F;
    VirtualKeys[6][KEY_CODE] = VK_KEY_G;
    VirtualKeys[7][KEY_CODE] = VK_KEY_H;
    VirtualKeys[8][KEY_CODE] = VK_KEY_I;
    VirtualKeys[9][KEY_CODE] = VK_KEY_J;
    VirtualKeys[10][KEY_CODE] = VK_KEY_K;
    VirtualKeys[11][KEY_CODE] = VK_KEY_L;
    VirtualKeys[12][KEY_CODE] = VK_KEY_M;
    VirtualKeys[13][KEY_CODE] = VK_KEY_N;
    VirtualKeys[14][KEY_CODE] = VK_KEY_O;
    VirtualKeys[15][KEY_CODE] = VK_KEY_P;
    VirtualKeys[16][KEY_CODE] = VK_KEY_Q;
    VirtualKeys[17][KEY_CODE] = VK_KEY_R;
    VirtualKeys[18][KEY_CODE] = VK_KEY_S;
    VirtualKeys[19][KEY_CODE] = VK_KEY_T;
    VirtualKeys[20][KEY_CODE] = VK_KEY_U;
    VirtualKeys[21][KEY_CODE] = VK_KEY_V;
    VirtualKeys[22][KEY_CODE] = VK_KEY_W;
    VirtualKeys[23][KEY_CODE] = VK_KEY_X;
    VirtualKeys[24][KEY_CODE] = VK_KEY_Y;
    VirtualKeys[25][KEY_CODE] = VK_KEY_Z;
    VirtualKeys[26][KEY_CODE] = VK_LBUTTON;
    VirtualKeys[27][KEY_CODE] = VK_MBUTTON;
    VirtualKeys[28][KEY_CODE] = VK_RBUTTON;
    VirtualKeys[29][KEY_CODE] = VK_LEFT;
    VirtualKeys[30][KEY_CODE] = VK_RIGHT;
	VirtualKeys[31][KEY_CODE] = VK_UP;
    VirtualKeys[32][KEY_CODE] = VK_DOWN;
    VirtualKeys[33][KEY_CODE] = VK_LSHIFT;
    VirtualKeys[34][KEY_CODE] = VK_RSHIFT;
    VirtualKeys[35][KEY_CODE] = VK_SPACE;

	EditMode = EDITMODE_NONE;
	EditIndex = INVALID_INDEX_ID;
	ProjectEditor = INVALID_PLAYER_ID;
    LoopProjectTextdraws Project[i][iTextdraw] = Text:INVALID_TEXT_DRAW;
    UpdateTimer = SetTimer("OnEditorUpdate", 25, true);
}

stock CreateMenuTextDraws()
{
    TD_Menu[0] = TextDrawCreate(0.0, OffsetZ - 2.0, "LD_SPAC:white");
	TextdrawSettings(TD_Menu[0], Float:{0.5, 1.0, 640.0, 37.0}, {0,0x000000FF,0,0,0,0,255,4,1,0});

	new Float:OffsetX = 0.01;

	TD_Menu[1] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_new"); OffsetX += 32.0;
	TD_Menu[2] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_open"); OffsetX += 32.0;

	CountRange(1, 3)
	TextdrawSettings(TD_Menu[c], Float:{0.5, 1.0, 32.0, 32.0}, {0,0xDDDDDDFF,0,0,0,0,0,4,1,0});

	TD_Menu[3] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_close"); OffsetX += 32.0;
	TD_Menu[4] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_export"); OffsetX += 32.0;
    TD_Menu[8] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_manage"); OffsetX += 32.0;
    TD_Menu[24] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_font0");
    TD_Menu[25] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_font1");
    TD_Menu[26] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_font2");
    TD_Menu[27] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_font3");
    TD_Menu[12] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_image"); OffsetX += 32.0;
	TD_Menu[9] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_pos"); OffsetX += 32.0;
    TD_Menu[10] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_size"); OffsetX += 32.0;
    TD_Menu[11] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_text"); OffsetX += 32.0;
    TD_Menu[14] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_color"); OffsetX += 32.0;
    TD_Menu[15] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_bgcolor"); OffsetX += 32.0;
    TD_Menu[32] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_boxcolor"); OffsetX += 32.0;
    TD_Menu[16] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_lettersize"); OffsetX += 32.0;
    TD_Menu[17] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_outline"); OffsetX += 32.0;
    TD_Menu[18] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_shadow"); OffsetX += 32.0;
    TD_Menu[19] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_useboxno");
    TD_Menu[20] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_useboxyes"); OffsetX += 32.0;
    TD_Menu[21] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_alignmentleft");
    TD_Menu[22] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_alignmentcenter");
    TD_Menu[23] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_alignmentright"); OffsetX += 32.0;
    TD_Menu[5] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_global");
	TD_Menu[33] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_player"); OffsetX += 32.0;
    TD_Menu[28] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_selectableno");
    TD_Menu[29] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_selectableyes"); OffsetX += 32.0;
    TD_Menu[30] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_proportionno");
    TD_Menu[31] = TextDrawCreate(OffsetX, OffsetZ, "PLEO:btn_proportionyes"); OffsetX += 32.0;
    
    //TD_Menu[6] = TextDrawCreate(222.0, 173.0, "Project tools:");
	//TD_Menu[7] = TextDrawCreate(222.0, 234.0, "Textdraw tools:");
	//TD_Menu[13] = TextDrawCreate(222.0, 334.0, "Textdraw Toggles:");

    CountRange(3, sizeof TD_Menu)
    TextdrawSettings(TD_Menu[c], Float:{0.5, 1.0, 32.0, 32.0}, {0,0x888888FF,0,0,0,0,0,4,1,0});
}

stock DestroyMenuTextDraws()
{
    CountRange(0, sizeof TD_Menu)
	{
		TextDrawDestroy(TD_Menu[c]);
		TD_Menu[c] = Text:INVALID_TEXT_DRAW;
	}
}

stock TextdrawSettings(Text:textid, Float:Sizes[4], Options[10])
{
	TextDrawLetterSize		(textid, Sizes[0], Sizes[1]);
	TextDrawTextSize    	(textid, Sizes[2], Sizes[3]);
	TextDrawAlignment   	(textid, Options[0] ? Options[0] : 1);
	TextDrawColor   		(textid, Options[1]);
	TextDrawUseBox   		(textid, Options[2]);
	TextDrawBoxColor   		(textid, Options[3]);
	TextDrawSetShadow   	(textid, Options[4]);
	TextDrawSetOutline  	(textid, Options[5]);
	TextDrawBackgroundColor (textid, Options[6]);
	TextDrawFont   			(textid, Options[7]);
	TextDrawSetProportional	(textid, Options[8]);
	TextDrawSetSelectable   (textid, Options[9]);
}

stock Dispose()
{
	CountRange(0, sizeof States) EmptyString(States[c]);
    KillTimer(UpdateTimer);
    LoopProjectTextdraws TextDrawDestroy(Project[i][iTextdraw]);
    DestroyMenuTextDraws();
}

stock IsValidProjectName(name[])
{
	CountRange(0, strlen(name))
	{
	    switch(name[c])
	    {
	        case 'A' .. 'Z', 'a' .. 'z', '0' .. '9', '-', '_', '(', ')': continue;
	        default: return false;
	    }
	}
	return true;
}

stock GetAvailableIndex()
{
	LoopProjectTextdraws if(Project[i][iTextdraw] == Text:INVALID_TEXT_DRAW) return i;
	return INVALID_INDEX_ID;
}

stock StripNewLine(string[]) //DracoBlue (bugfix idea by Y_Less)
{
	new len = strlen(string);
	if (string[0]==0) return ;
	if ((string[len - 1] == '\n') || (string[len - 1] == '\r')) {
		string[len - 1] = 0;
		if (string[0]==0) return ;
		if ((string[len - 2] == '\n') || (string[len - 2] == '\r')) string[len - 2] = 0;
	}
}

stock HexToInt(string[])//DracoBlue
{
   if (string[0] == 0) return 0;
   new i, cur=1, res = 0;
   for (i=strlen(string);i>0;i--) {
     if (string[i-1]<58) res=res+cur*(string[i-1]-48); else res=res+cur*(string[i-1]-65+10);
     cur=cur*16;
   }
   return res;
 }

stock RGBAToHex(r, g, b, a) //By Betamaster
{
    return (r<<24 | g<<16 | b<<8 | a);
}

stock HexToRGBA(colour, &r, &g, &b, &a) //By Betamaster
{
    r = (colour >> 24) & 0xFF;
    g = (colour >> 16) & 0xFF;
    b = (colour >> 8) & 0xFF;
    a = colour & 0xFF;
}
