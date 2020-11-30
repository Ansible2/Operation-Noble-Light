/* ----------------------------------------------------------------------------
Function: ONL_fnc_extractionMusic

Description:
	Plays music during the extraction site defense.

	Executes from the event "ONL_getToExtraction_Event" which is located in ONL_fnc_extractionEvents.

Parameters:
	NONE

Returns:
	Nothing

Examples:
    (begin example)

		call ONL_fnc_extractionMusic;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
if (!hasInterface) exitWith {};

if (!ONL_CCMLoaded AND {!ONL_KISKAMusicLoaded}) exitWith {false};

if (ONL_CCMLoaded) exitWith {
	[
		{
			["CCM_sb_horizons",0,true] remoteExec ["KISKA_fnc_playMusic",ONL_allClientsTargetID]; 
		},
		[],
		60
	] call CBA_fnc_waitAndExecute;

	[
		{
			["CCM_GL_classifiedInformation",0,true] remoteExec ["KISKA_fnc_playMusic",ONL_allClientsTargetID]; 
		},
		[],
		(["CCM_sb_horizons"] call KISKA_fnc_getMusicDuration) + 62
	] call CBA_fnc_waitAndExecute;

	[
		{
			["CCM_sb_intervention",0,true] remoteExec ["KISKA_fnc_playMusic",ONL_allClientsTargetID]; 
		},
		[],
		540
	] call CBA_fnc_waitAndExecute;
};


if (ONL_KISKAMusicLoaded) exitWith {
	[
		{
			["Kiska_Whereabouts",0,true] remoteExec ["KISKA_fnc_playMusic",ONL_allClientsTargetID]; 
		},
		[],
		60
	] call CBA_fnc_waitAndExecute;

	[
		{
			["Kiska_Truth",0,true] remoteExec ["KISKA_fnc_playMusic",ONL_allClientsTargetID]; 
		},
		[],
		(["Kiska_Whereabouts"] call KISKA_fnc_getMusicDuration) + 30
	] call CBA_fnc_waitAndExecute;
};