if !(isServer) exitWith {};

(profileNamespace getVariable "ONL_saveData") params [
	"_vehicleSaveInfoArray",
	"_savedGroupsInfoArray",
	"_completedTasks",
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
_completedTasks apply {
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

	private _wp = _group addWaypoint [];
};

_savedGroupsInfoArray apply {
	_x params [
		"_groupSide",//
		"_isGroupDySimmed",//
		"_combatMode",//
		"_groupBehaviour",//
		"_groupFormation",//
		"_deleteWhenEmpty",//
		"_unitsInfo",//
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
			"_vehicleInfo"
		];

		private _unit = _unitType createVehicle [0,0,0];
		if !((getUnitLoadout _unit) isEqualTo _unitLoadout) then {
			_unit setVariable ["ONL_savedLoadout",_unitLoadout];
		};
		
		if !(_vehicleInfo isEqualTo []) then {
			_vehicleInfo params ["_vehicleIndex","_vehicleRoleInfo"];
			[_unit,_crewedVehicles select _vehicleIndex,_vehicleRoleInfo] call _fn_assignVehiclePosition;
		};

		_unit enableSimulationGlobal _isManSimulated;
	};

	if !(_savedWaypoints isEqualTo []) then {
		_savedWaypoints apply {
			(_x + [_group]) call _fn_createWaypoint;
		};
	};
};