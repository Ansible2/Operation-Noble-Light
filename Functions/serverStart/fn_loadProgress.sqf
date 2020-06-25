if !(isServer) exitWith {};

(profileNamespace getVariable "ONL_saveData") params [
	"_vehicleSaveInfoArray",
	"_savedGroupsInfoArray",
	"_taskInfoArray",
	"_specialSaveData",
	"_dependencies"
];

// check dependencies and exit to new game if not all present in same way
private _activeDependencies = [ONL_snowTigersLoaded,ONL_CUPVehiclesLoaded,ONL_RHSUSFVehiclesLoaded,ONL_CUPUnitsLoaded,ONL_FSGLoaded];
if !(_activeDependencies isEqualTo _dependencies) exitWith {
	ONL_loadSave = false;

	[
		{
			["WARNING: IMPROPER DEPENDENT MODS LOADED, SAVE LOAD ABORTED AND NEW GAME STARTED"] remoteExec ["KISKA_fnc_dataLinkMsg",allPlayers,true];
		},
		[],
		15
	] call CBA_fnc_waitAndExecute;

	call ONL_fnc_spawnUnitsVillage;

	call ONL_fnc_spawnUnitsCave;

	call ONL_fnc_spawnUnitsLodging;

	call ONL_fnc_spawnUnitsBlacksite;

	call ONL_fnc_spawnUnitsBase;

	call ONL_fnc_spawnUnitsFacility;
};



////////////////TASKS////////////////////////////////////////////////////////////////////
// need more details about tasks
// e.g. what ones were created
_taskInfoArray apply {
	_x params ["_task","_taskExists","_taskState"];

	if (_taskExists) then {
		if (_taskState == "COMPLETED")
	};
	_x call KISKA_fnc_setTaskComplete;
}; 


////////////////VEHICLES (and turrets)////////////////////////////////////////////////////////////////////
private _crewedVehicles = [];
_vehicleSaveInfoArray apply {
	_x params [
		"_vehicleType",
		"_vectorDirAndUp",
		"_vehiclePosWorld",
		"_isVehicleSimulated",
		"_isVehicleDySimmed",
		"_vehicleCargo",
		"_vehicleIsCrewed"
	];

	private _vehicle = _vehicleType createVehicle [0,0,0];
	_vehicle setPosWorld _vehiclePosWorld;
	_vehicle setVectorDirAndUp _vectorDirAndUp;

	_vehicle enableSimulationGlobal _isVehicleSimulated;
	_vehicle enableDynamicSimulation _isVehicleDySimmed;

	[_vehicle,_vehicleCargo] call KISKA_fnc_pasteContainerCargo;

	if (_vehicleIsCrewed) then {
		_crewedVehicles pushBack _vehicle;
	};
};



////////////////GROUPS////////////////////////////////////////////////////////////////////
private _fn_assignVehiclePosition = {
	params ["_unit","_vehicle","_vehicleRoleInfo"];

	private _vehicleRoleType = toLower (_vehicleRoleInfo select 1);
	
	if (_vehicleRoleType == "cargo") exitWith {
		_unit moveInCargo [_vehicle,_vehicleRoleInfo select 2];
	};
	
	if (_vehicleRoleType == "commander") exitWith {
		_unit moveInCommander _vehicle;
	};
	
	if (_vehicleRoleType == "gunner") exitWith {
		_unit moveInGunner _vehicle;
	};
	
	if (_vehicleRoleType == "driver") exitWith {
		_unit moveInDriver _vehicle;
	};
	
	if (_vehicleRoleType == "turret") exitWith {
		_unit moveInTurret [_vehicle,_vehicleRoleInfo select 3];
	};
};

private _fn_createWaypoint = {
	params [
		"_waypointType",
		"_waypointPosition",
		"_waypointSpeed",
		"_waypointBehaviour",
		"_waypointCombatMode",
		"_waypointFormation",
		"_waypointStatements",
		"_waypointCompletionRadius",
		"_waypointTimeout",
		"_currentWaypoint",
		"_group"
	];

	private _wp = _group addWaypoint [_waypointPosition,0];
	_wp setWaypointSpeed _waypointSpeed;
	_wp setWaypointBehaviour _waypointBehaviour;
	_wp setWaypointCombatMode _waypointCombatMode;
	_wp setWaypointFormation _waypointFormation;
	_wp setWaypointStatements _waypointStatements;
	_wp setWaypointCompletionRadius _waypointCompletionRadius;
	_wp setWaypointTimeout _waypointTimeout;

	if (_currentWaypoint) then {
		_group setCurrentWaypoint _wp;
	};
};

_savedGroupsInfoArray apply {
	_x params [
		"_groupSide",
		"_isGroupDySimmed",
		"_combatMode",
		"_groupBehaviour",
		"_groupFormation",
		"_deleteWhenEmpty",
		"_unitsInfo",
		"_savedWaypoints",
		"_onCreateCode"
	];

	// create group
	private _group = createGroup _groupSide;
	_group enableDynamicSimulation _isGroupDySimmed;
	_group setCombatMode _combatMode;
	_group setBehaviour _groupBehaviour;
	_group setFormation _groupFormation;
	_group deleteGroupWhenEmpty _deleteWhenEmpty;
	
	// create units
	_unitsInfo apply {
		_x params [
			"_unitType",
			"_unitLoadout",
			"_isManSimulated",
			"_vehicleInfo",
			"_canUnitMove"
		];

		private _unit = _unitType createVehicle [0,0,0];
		if !((getUnitLoadout _unit) isEqualTo _unitLoadout) then {
			// for use AFTER headless rebalance
			_unit setVariable ["ONL_savedLoadout",_unitLoadout];
		};
		
		if !(_vehicleInfo isEqualTo []) then {
			_vehicleInfo params ["_vehicleIndex","_vehicleRoleInfo"];
			[_unit,_crewedVehicles select _vehicleIndex,_vehicleRoleInfo] call _fn_assignVehiclePosition;
		};
		
		if (!_canUnitMove) then {
			_unit disableAI "PATH"; 
		};

		private _randomDir = floor (random 360);
		_unit setDir _randomDir;
		_unit doWatch (_unit getRelPos [50,_randomDir]);
		
		_unit triggerDynamicSimulation false;
		_unit enableSimulationGlobal _isManSimulated;
	};

	// setup waypoints
	if !(_savedWaypoints isEqualTo []) then {
		_savedWaypoints apply {
			(_x + [_group]) call _fn_createWaypoint;
		};
	};

	if !(_onCreateCode isEqualTo {}) then {
		[_group] call _onCreateCode;
	};
};



////////////////Special Save Data////////////////////////////////////////////////////////////////////
_specialSaveData params [
	"_artyAlive_1",
	"_artyAlive_2",
	"_blackSiteHeliAlive",
	"_baseHeliAlive"
];

// arty 1
if (_artyAlive_1) then {
	private _group = createVehicleCrew ONL_arty_1;
	_group enableDynamicSimulation true;

	ONL_arty_1 addEventHandler ["KILLED", {
		private _deadCount = missionNamespace getVariable ["ONL_deadArty",0];
		
		if (_deadCount isEqualTo 1) then {
			[DestroyArty_taskID,DestroyArty_taskInfo] call KISKA_fnc_setTaskComplete;
		} else {
			ONL_deadArty = 1;
		};
	}];

	_group setVariable ["ONL_saveExcluded",true];
	ONL_arty_1 setVariable ["ONL_saveExcluded",true];
} else {
	deleteVehicle ONL_arty_1;
};

// arty 2
if (_artyAlive_2) then {
	private _group = createVehicleCrew ONL_arty_2;
	_group enableDynamicSimulation true;

	ONL_arty_2 addEventHandler ["KILLED", {
		private _deadCount = missionNamespace getVariable ["ONL_deadArty",0];
		
		if (_deadCount isEqualTo 1) then {
			[DestroyArty_taskID,DestroyArty_taskInfo] call KISKA_fnc_setTaskComplete;
		} else {
			ONL_deadArty = 1;
		};
	}];

	_group setVariable ["ONL_saveExcluded",true];
	ONL_arty_2 setVariable ["ONL_saveExcluded",true];
} else {
	deleteVehicle ONL_arty_2;
};

// black site heli 
if (_blackSiteHeliAlive) then {
	call ONL_fnc_createBlackSiteHeliPatrol;
};
// base heli
if (_baseHeliAlive) then {
	call ONL_fnc_createBaseHeliPatrol;
};