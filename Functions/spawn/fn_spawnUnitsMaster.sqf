/* ----------------------------------------------------------------------------
Function: ONL_fnc_prepareGlobals

Description:
	Discerns if load or new game spawns are to take place.
	Also changes AI skills.
	
	It is executed from the "initServer.sqf".
	
Parameters:
	NONE

Returns:
	BOOL

Examples:
    (begin example)

		call ONL_fnc_prepareGlobals

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
if (!isServer) exitWith {false};

// this is used to assign vanilla loadouts if needed
if (!ONL_CUPUnitsLoaded) then {
	ONL_PMCUnits = [];
};

// Extraction Helicopter
call ONL_fnc_createExtractionHeli;

if !(ONL_loadSave) then {
	call ONL_fnc_spawnUnitsNewGame;
	missionNamespace setVariable ["ONL_supplyDrop1Used",false,true];
	missionNamespace setVariable ["ONL_supplyDrop2Used",false,true];
} else {
	call ONL_fnc_loadProgress;
};

ONL_unitsSpawned = true;
publicVariable "ONL_unitsSpawned";

uiSleep 2;

allUnits apply {
	if !(side _x isEqualTo BLUFOR) then {		
		_x setSkill ["courage",1];
		_x setSkill ["commanding",1];
		_x setSkill ["spotDistance",1];
	};

	uiSleep 0.1;
};

true