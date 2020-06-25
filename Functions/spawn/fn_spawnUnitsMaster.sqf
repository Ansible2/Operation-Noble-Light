if (!isServer) exitWith {false};

// this is used to assign vanilla loadouts
if (!ONL_CUPUnitsLoaded) then {
	ONL_PMCUnits = [];
};


// Extraction Helicopter
call ONL_fnc_createExtractionHeli;

if !(ONL_loadSave) then {
	call ONL_fnc_spawnUnitsVillage;

	call ONL_fnc_spawnUnitsCave;

	call ONL_fnc_spawnUnitsLodging;

	call ONL_fnc_spawnUnitsBlacksite;

	call ONL_fnc_spawnUnitsBase;

	call ONL_fnc_spawnUnitsFacility;
} else {
	call ONL_fnc_loadProgress;
};

// add arty events

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