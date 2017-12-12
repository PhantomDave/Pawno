SA-MP Audio Plugin v0.5 R2
==========================

Preface
-------

This plugin creates a TCP server that can communicate with external
clients to transfer and play back audio files, stream audio files
from the Internet, and control in-game radio stations. It has several
features, including:

- Seamless integration with SA-MP (San Andreas Multiplayer)
- Audio playback with looping, pausing, resuming, and stopping,
  restarting, seeking, and volume adjusting
- Internet audio file streaming that supports nearly all online
  stations, including SHOUTcast and Icecast
- Sequence system for gapless playback of multiple audio files
- Support for multiple audio streams per client
- In-game 3D sound support with dynamic volume adjustment and panning
- Support for MOD, WAV, AIFF, MP3/MP2/MP1, OGG, WMA, FLAC, MIDI, WV,
  SPX, MPC, AC3, AAC, ALAC, TTA, and APE formats
- Support for multiple sound effects that can be applied instantly
- In-game radio station adjustment support
- Audio pack system for organizing audio files and ensuring easy
  distribution among clients
- Local file transfers with CRC checks and remote file transfers with
  file size checks to ensure that files do not get re-downloaded
- Player authentication system with name and IP address verification

Natives
-------

* Audio_CreateTCPServer(port);
      o Creates the TCP server
        Note #1: This must be on the same port that the SA-MP server
        is using. It must also be forwarded properly.
        Note #2: This is done automatically via callback hooking.

* Audio_DestroyTCPServer();
      o Destroys the TCP server

* Audio_SetPack(const audiopack[], bool:transferable = true, bool:automated = true);
      o Maps audio files specified under the audio pack name in
        audio.ini and specifies whether the audio pack should be
        transferable and automated
        Note #1: If the pack is not transferable, no CRC or file size
        checks will take place server-side. The files in the pack
        will only be checked if they exist client-side.
        Note #2: If the pack is automated, it will transfer to all
        connected players as soon as it is set and to all future
        players as soon as they connect. If it is not automated, the
        Audio_TransferPack native must be used instead.

* Audio_IsClientConnected(playerid);
      o Returns the player's TCP server connection status

* Audio_SendMessage(playerid, const message[]);
      o Sends a custom message to a player
        Note: This message will appear in the player's log if
        logging is enabled client-side.

* Audio_TransferPack(playerid);
      o Transfers the currently set audio pack to a player
        Note: If automatic transfers are enabled, this native will
        not work.

* Audio_CreateSequence();
      o Creates a sequence
        Note: This returns a sequence ID.

* Audio_DestroySequence(sequenceid);
      o Destroys a sequence

* Audio_AddToSequence(sequenceid, audioid);
      o Adds a mapped audio file to a sequence

* Audio_RemoveFromSequence(sequenceid, audioid);
      o Removes all instances of a mapped audio file from a sequence

* Audio_Play(playerid, audioid, bool:pause = false, bool:loop = false, bool:downmix = false);
      o Plays a mapped audio file for a player and specifies whether
        it should start paused, whether it should be looped, and
        whether the audio stream should be downmixed to mono
        Note: This returns a handle ID.

* Audio_PlayStreamed(playerid, const url[], bool:pause = false, bool:loop = false, bool:downmix = false);
      o Streams a URL for a player and specifies whether it should
        start paused, whether it should be looped, and whether the
        audio stream should be downmixed to mono
        Note: This returns a handle ID.

* Audio_PlaySequence(playerid, sequenceid, bool:pause = false, bool:loop = false, bool:downmix = false);
      o Plays a sequence for a player and specifies whether it should
        start paused, whether it should be looped, and whether the
        audio stream should be downmixed to mono
        Note: This returns a handle ID.

* Audio_Pause(playerid, handleid);
      o Pauses playback for an audio stream assigned to a player's
        handle ID

* Audio_Resume(playerid, handleid);
      o Resumes playback for an audio stream assigned to a player's
        handle ID

* Audio_Stop(playerid, handleid);
      o Stops playback for an audio stream assigned to a player's
        handle ID

* Audio_Restart(playerid, handleid);
      o Restarts playback for an audio stream assigned to a player's
        handle ID

* Audio_GetPosition(playerid, handleid, const callback[] = "Audio_OnGetPosition");
      o Gets the position in seconds for an audio stream assigned to
        a player's handle ID and stores it in the specified callback
        Note: The callback, by default, is Audio_OnGetPosition. A
        custom callback may be used that resembles the form of the
        default callback, but it must be forwarded in the script.

* Audio_SetPosition(playerid, handleid, seconds);
      o Sets position in seconds for an audio stream assigned to a
        player's handle ID

* Audio_SetVolume(playerid, handleid, volume);
      o Adjusts volume (0-100) for an audio stream assigned to a
        player's handle ID

* Audio_SetFX(playerid, handleid, type);
      o Applies a sound effect to an audio stream assigned to a
        player's handle ID
        Note: Valid values for type are as follows:
            + 0: Chorus
            + 1: Compression
            + 2: Distortion
            + 3: Echo
            + 4: Flanger
            + 5: Gargle
            + 6: I3DL2 Reverb
            + 7: Parametric Equalizer
            + 8: Reverb

* Audio_RemoveFX(playerid, handleid, type);
      o Removes a sound effect from an audio stream assigned to a
        player's handle ID
        Note: Valid values for type are listed above.

* Audio_Set3DPosition(playerid, handleid, Float:x, Float:y, Float:z, Float:distance);
      o Sets the 3D position (game world coordinates) of an audio
        stream assigned to a player's handle ID
        Note: The audio stream must be downmixed to mono (see the
        last parameter of Audio_Play, Audio_PlayStreamed, and
        Audio_PlaySequence) for panning to work properly.

* Audio_Remove3DPosition(playerid, handleid);
      o Removes the 3D position of an audio stream assigned to a
        player's handle ID

* Audio_SetRadioStation(playerid, station);
      o Sets a player's current in-game radio station
        Note: Valid values for station are as follows:
            + 0: Radio Off (Emergency Vehicle Radio)
            + 1: Playback FM
            + 2: K-Rose
            + 3: K-DST
            + 4: Bounce FM
            + 5: SF-UR
            + 6: Radio Los Santos
            + 7: Radio X
            + 8: CSR 103.9
            + 9: K-Jah West
            + 10: Master Sounds 98.3
            + 11: WCTR
            + 12: User Track Player

* Audio_StopRadio(playerid);
      o Stops, or turns off, a player's in-game radio station

Callbacks
---------

* Audio_OnClientConnect(playerid);
      o Called when a player connects to the TCP server

* Audio_OnClientDisconnect(playerid);
      o Called when a player disconnects from the TCP server

* Audio_OnTransferFile(playerid, file[], current, total, result);
      o Called when a player completes the transfer of a file
        Note: The result can be one of the following:
            + 0: Local file downloaded successfully
            + 1: Remote file downloaded successfully
            + 2: File passed CRC check or file size check
            + 3: Error transferring or checking file

* Audio_OnPlay(playerid, handleid);
      o Called when a player starts any event associated with a
        handle ID

* Audio_OnStop(playerid, handleid);
      o Called when a player stops any event associated with a
        handle ID

* Audio_OnTrackChange(playerid, handleid, track[]);
      o Called when a player reports that a track change has occurred
        in an online station

* Audio_OnRadioStationChange(playerid, station);
      o Called when a player changes the radio station in-game

* Audio_OnGetPosition(playerid, handleid, seconds);
      o Called by default when a result from Audio_GetPosition is
        retrieved

Tutorial (Client)
-----------------

Installation and use of the client plugin is simple. Just run the
installer and extract the files to the GTA: San Andreas directory.
The ASI plugin detects when SA-MP is loaded and obtains the current
player name, server address, and server port automatically. It will
then attempt to connect to the TCP server (if there is one) some time
after the game has started. By default, there will be a total of ten
retry attempts with a delay of tenseconds each. To adjust these
numbers, along with a few other settings, audio.ini will need to be
edited. To locate this file, go to Start, click Run, and type in the
following:

%APPDATA%\SA-MP Audio Plugin

An Explorer window should open. This directory contains all
downloaded audio packs, audio.ini, and audio.txt. Note that these
files will only be created once the audio plugin is loaded for the
first time.

Tutorial (Server)
-----------------

Create a directory called "plugins" inside of the server directory if
one does not already exist. Place the plugin file (audio.dll or
audio.so) inside of this directory.

Add the following line to server.cfg so that the plugin will load the
next time the server starts: 

Windows:
plugins audio.dll

Linux:
plugins audio.so

On Windows, add audio.inc to the pawno\include folder. Include this
file in any of the scripts the server is running:

#include <audio>

Recompile the scripts with any desired natives and callbacks provided
by the include file. Start the server.

The server log should indicate that the TCP server was created
successfully on the same port that the SA-MP sever is using.

Ensure that both the audiopacks folder and the audio.ini file are in
the root directory of the server. Open audio.ini and add a section
for the audio pack name. For demonstration purposes, this will be
called "default_pack":

[default_pack]

Navigate to the audiopacks directory and create a folder called
"default_pack" within it. This is where all of the local audio files
will go. Add an audio file to the "default_pack" folder. This will be
called "file.wav". Map it under the section that was just created in
audio.ini:

[default_pack]
1 = file.wav

The number to the left of the file name (1) is the audio ID. It is
completely arbitrary. It can be used in Audio_Play like this:

Audio_Play(playerid, 1);

Remote files that don't need to be in the audiopacks directory can
also be mapped. They must start with "http://". Here is an example:

[default_pack]
1 = file.wav
2 = http://www.website.com/file.wav

Now the audio pack simply needs to be set when the gamemode loads:

public OnGameModeInit()
{
	Audio_SetPack("default_pack");
}

Alternatively, it is possible to completely ignore audio.ini and
stream all of the files with the Audio_PlayStreamed native instead.
This will consume more client-side bandwidth, however, if the files
are played repeatedly.

More detailed examples of nearly every native and callback can be
found in the filterscript.

Dependencies
------------

The Windows version requires the Microsoft Visual C++ 2010
Redistributable Package.
