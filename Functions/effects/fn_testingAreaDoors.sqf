/* ----------------------------------------------------------------------------
Function: ONL_fnc_testingAreaDoors

Description:
	Either opens or closes the testing area doors inside the cave depending upon the input param.

	Executed from the hold actions added from "ONL_fnc_addActionsMaster"

Parameters:
	0: _open : <BOOL> - Should the doors open or close

Returns:
	Nothing

Examples:
    (begin example)

		null = [] spawn ONL_fnc_testingAreaDoors;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */

if (!canSuspend) exitWith {};

params [
	["_open",true,[true]]
];

if (_open) then {
	missionNamespace setVariable ["ONL_testingAreaOpen",true,true];

	[ONL_logic_caveSpeaker_1,ONL_logic_caveSpeaker_2] apply {
		["air_raid",_x,200,2] call KISKA_fnc_playSound3D;
	};
	
	sleep 10;

	["Testing Area Open"] remoteExec ["hintSilent",[0,-2] select isDedicated];
	
	ONL_entryWalls apply {
		_x setObjectTextureGlobal [0,"#(argb,1,1,1)color(1,1,1,0,ca)"];
	};

	ONL_entryWallsInvisible apply {
		_x hideObjectGlobal true;
	};

} else {
	missionNamespace setVariable ["ONL_testingAreaOpen",false,true];

	[ONL_logic_caveSpeaker_1,ONL_logic_caveSpeaker_2] apply {
		["alarm",_x,200,2] call KISKA_fnc_playSound3D;
	};

	["Testing Area Closed"] remoteExec ["hintSilent",[0,-2] select isDedicated];
	
	ONL_entryWalls apply {
		_x setObjectTextureGlobal [0,"#(argb,1,1,1)color(1,1,1,1,ca)"];
	};
	
	ONL_entryWallsInvisible apply {
		_x hideObjectGlobal false;
	};
};