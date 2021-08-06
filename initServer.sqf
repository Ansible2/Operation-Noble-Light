call KISKA_fnc_addCargoEvents
call ONL_fnc_prepareGlobals;

[[ONL_arsenal_1,ONL_arsenal_2,ONL_arsenal_3]] call KISKA_fnc_addArsenal;

call ONL_fnc_addServerEvents;
// place all static vehicles and the ones the players can choose from at the start
call ONL_fnc_startingVehiclesInit;
call ONL_fnc_placeVehicles;
call ONL_fnc_startingBaseAudio;
// spawn MOST enemy units
call ONL_fnc_spawnUnitsMaster;
call ONL_fnc_startServerLoops;


// create initial Task
["ONL_secureApollo_task"] call KISKA_fnc_createTaskFromConfig;


// create a respawn at the airfield
ONL_airfieldRespawn = [missionNamespace,getPosATL ONL_airfieldRespawn_Logic,"Airfield Respawn"] call BIS_fnc_addRespawnPosition;


// make civ triggers less intensive
[ONL_blackSiteCiv_Trigger,ONL_lodgingCiv_Trigger,ONL_facilityCiv_trigger,ONL_caveChemLights_trigger] apply {
	_x setTriggerInterval 4;
};


// for plane at start
ONL_cargoPlane flyInHeight 500;


// distribute AI amongst headless client(s) save for these groups
KISKA_hcExcluded = [ONL_cargoPlaneGroup,ONL_extractHeliPilots_group,/*ONL_extractHeliTurrets_group,*/ONL_redGroup,ONL_blueGroup];

// exclude from saves
[ONL_caveGroup_1,ONL_caveGroup_2,ONL_caveGroup_3,ONL_caveGroup_4,ONL_caveGroup_5,ONL_redGroup,ONL_blueGroup,ONL_cargoPlane,ONL_cargoPlaneGroup] apply {
	_x setVariable ["ONL_saveExcluded",true];
};


[ONL_redGroup] call KISKA_fnc_allowGroupRally;
[ONL_blueGroup] call KISKA_fnc_allowGroupRally;


// to keep gear from being lost when transfering AI to headless, they need to sleep for a bit
uiSleep 30;
[] spawn KISKA_fnc_balanceHeadless;


// assign loadouts if save was loaded
if (ONL_loadSave) then {
	uiSleep 100;
	private "_loadout_temp";
	allUnits apply {
		_loadout_temp = _x getVariable ["ONL_savedLoadout",[]];
		if !(_loadout_temp isEqualTo []) then {
			_x setUnitLoadout _loadout_temp;
		};
	};

} else {
	// reassign loadouts for vanilla if needed
	if (!ONL_CUPUnitsLoaded) then {
		uiSleep 100;
		[ONL_loadoutConfig,ONL_PMCUnits] spawn KISKA_fnc_assignUnitLoadout;
	};

};
