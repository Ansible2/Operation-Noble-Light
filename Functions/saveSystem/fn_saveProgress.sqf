/* ----------------------------------------------------------------------------
Function: ONL_fnc_saveProgress

Description:
	Essentially saves the mission state.
	
	Executed from "ONL_fnc_saveQuery" which was used to obtain the remoteExecutedOwner var.
	
Parameters:
	NONE

Returns:
	Nothing

Examples:
    (begin example)

		call ONL_fnc_saveProgress;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
if (!isServer) exitWith {};

if ((admin remoteExecutedOwner) != 2 AND {remoteExecutedOwner != 2}) exitWith {};

// master array
private _ONLSaveData = [];

//////////////////////////////////Vehicles (and turrets)/////////////////////////////////////////////////////////////////////////////////////////
// filter vehicles
private _vehiclesToSave = vehicles select {
	alive _x AND 
	{!(isNull _x)} AND 
	{!(_x in ONL_startingVehicles)} AND 
	{!(_x getVariable ["ONL_saveExcluded",false])}
};

// create storage arrays
private _vehicleSaveInfoArray = [];
private _vehiclesWithCrew = [];

_vehiclesToSave apply {
	private _vehicle = _x;
	private _vehicleType = typeOf _vehicle;
	
	// check if the vehicle has crew
	// this bool is used to push the vehicle into an array when spawned (save is loaded) so that its index
	/// will be the exact same and units can move into the appropriate indexes
	private _vehicleIsCrewed = !((crew _vehicle) isEqualTo []);
	if (_vehicleIsCrewed) then {_vehiclesWithCrew pushBack _vehicle};

	// position & vector
	private _vectorDirAndUp = [vectorDirVisual _vehicle, vectorUpVisual _vehicle];
	private _vehiclePosWorld = getPosWorldVisual _vehicle;

	// simulation status
	private _isVehicleSimulated = simulationEnabled _vehicle;
	private _isVehicleDySimmed = dynamicSimulationEnabled _vehicle;

	// cargo
	private _vehicleCargo = [_vehicle] call KISKA_fnc_copyContainerCargo;

	// put into info array
	_vehicleSaveInfoArray pushBack [_vehicleType,_vectorDirAndUp,_vehiclePosWorld,_isVehicleSimulated,_isVehicleDySimmed,_vehicleCargo,_vehicleIsCrewed];
};
// add to master
_ONLSaveData pushBack _vehicleSaveInfoArray;




//////////////////////////////////Groups///////////////////////////////////////////////////////////////////////////////////////////
// filter groups
private _groupsToSave = allGroups select {
	!(_x getVariable ["ONL_saveExcluded",false]) AND
	{!(isNull _x)} AND
	{((side _x) isEqualTo OPFOR) OR {(side _x) isEqualTo independent}}
};

// create storage array
private _savedGroupsInfoArray = [];

_groupsToSave apply {
	// group info
	private _group = _x;

	// specific units info ///////////////////////
	private _unitsInfo = [];
	(units _group) apply {
		private _unit = _x;

		// if unit is in a vehicle, find its index in the vehicles with crew array that was made 
		/// so that we can load units into that vehicle index when the save is loaded and the vehicles created 
		private _vehicleInfo = [];
		private _unitVehicle = objectParent _unit;
		if !(isNull _unitVehicle) then {
			private _vehicleIndex = _vehiclesWithCrew findIf {_x isEqualTo _unitVehicle};
			private _vehicleCrew = fullCrew _unitVehicle;
			private _vehicleRole = _vehicleCrew select (_vehicleCrew findIf {(_x select 0) isEqualTo _unit});

			_vehicleInfo pushBack _vehicleIndex;
			_vehicleInfo pushBack _vehicleRole;
		};

		// push unit info to group info array
		private _unitType = typeOf _unit;
		private _unitLoadout = getUnitLoadout _unit;
		private _isManSimulated = simulationEnabled _unit;	
		private _canUnitMove = _unit checkAIFeature "PATH";
		_unitsInfo pushBack [_unitType,_unitLoadout,_isManSimulated,_vehicleInfo,_canUnitMove];
	};


	// waypoints ////////////////////////
	private _waypoints = waypoints _group;
	private _savedWaypoints = [];
	if !(_waypoints isEqualTo []) then {
		_waypoints apply {
			private _wp = _x;
			
			// check if current waypoint
			private _currentWaypoint = (currentWaypoint _group) isEqualTo _wp;

			// get info for waypoint
			private _waypointType = waypointType _wp;
			private _waypointPosition = waypointPosition _wp;
			private _waypointSpeed = waypointSpeed _wp;
			private _waypointBehaviour = waypointBehaviour _wp;
			private _waypointCombatMode = waypointCombatMode _wp;
			private _waypointFormation = waypointFormation _wp;
			private _waypointStatements = waypointStatements _wp;
			private _waypointCompletionRadius = waypointCompletionRadius _wp;
			private _waypointTimeout = waypointTimeout _wp;

			_savedWaypoints pushBack [_waypointType,_waypointPosition,_waypointSpeed,_waypointBehaviour,_waypointCombatMode,_waypointFormation,_waypointStatements,_waypointCompletionRadius,_waypointTimeout,_currentWaypoint];
		};
	};

	// misc group info for spawning /////////////////////
	private _groupBehaviour = behaviour _group;
	private _combatMode = combatMode _group;
	private _groupSide = side _group;
	private _isGroupDySimmed = dynamicSimulationEnabled _group;
	private _deleteWhenEmpty = isGroupDeletedWhenEmpty _group;
	private _groupFormation = formation _group;

	// special code to run upon creating the group when loading a save
	private _onCreateCode = _group getVariable ["ONL_loadCreationCode",{}];

	// add to master group list
	_savedGroupsInfoArray pushBack [_groupSide,_isGroupDySimmed,_combatMode,_groupBehaviour,_groupFormation,_deleteWhenEmpty,_unitsInfo,_savedWaypoints,_onCreateCode];
};
// add master
_ONLSaveData pushBack _savedGroupsInfoArray;




//////////////////////////////////Tasks///////////////////////////////////////////////////////////////////////////////////////////
private _fn_taskStatus = {
	params ["_task"];

	// get Task ID if configured as [task ID,Parent Task ID]
	private "_taskID";
	if (_task isEqualType []) then {
		_taskID = _task select 0;
	} else {
		_taskID = _task;
	};

	private _taskExists = [_task] call BIS_fnc_taskExists;
	private "_taskState"; 
	if (_taskExists) then {
		_taskState = [_task] call BIS_fnc_taskState;
	} else {
		_taskState = "";
	};

	[_taskExists,_taskState]
};

private _taskInfoArray = [];
ONL_taskIdsAndInfo apply {
	private _taskIdAndInfo = _x;
	private _taskIdGlobal = _taskIdAndInfo select 0;

	private _taskStatus = [_x] call _fn_taskStatus;
	_taskIdAndInfo pushBack _taskStatus;
	_taskInfoArray pushBack _taskIdAndInfo;
};
// add to master
_ONLSaveData pushBack _taskInfoArray;




//////////////////////////////////Specials/////////////////////////////////////////////////////////////////////////////////////
private _specialSaveData = [];
private _fn_aliveAndHasCrew = {
	params ["_vehicle"];
	
	(alive _vehicle AND {!((crew _vehicle) isEqualTo [])})
};

// arty pieces, decide if they need eventhandelers
private _artyAlive_1 = [ONL_arty_1] call _fn_aliveAndHasCrew;
private _artyAlive_2 = [ONL_arty_2] call _fn_aliveAndHasCrew;
_specialSaveData pushBack _artyAlive_1;
_specialSaveData pushBack _artyAlive_2;

// helicopter patrols
private _blackSiteHeliAlive = [ONL_blackSitePatrolHelicopter] call _fn_aliveAndHasCrew;
private _baseHeliAlive = [ONL_basePatrolHelicopter] call _fn_aliveAndHasCrew;
_specialSaveData pushBack _blackSiteHeliAlive;
_specialSaveData pushBack _baseHeliAlive;

// cave charges
private "_chargesAlive";
if (!isNull ONL_charge_1 OR {!isNull ONL_charge_2} OR {!isNull ONL_charge_3}) then {
	_chargesAlive = true;
	_specialSaveDate pushBack _chargesAlive;
} else {
	_chargesAlive = false;
	_specialSaveDate pushBack _chargesAlive;
};

// add to master
_ONLSaveData pushBack _specialSaveData;




//////////////////////////////////Dependencies/////////////////////////////////////////////////////////////////////////////////////
_ONLSaveData pushBack [ONL_snowTigersLoaded,ONL_CUPVehiclesLoaded,ONL_RHSUSFVehiclesLoaded,ONL_CUPUnitsLoaded,ONL_FSGLoaded];

//////////////////////////////////SAVE/////////////////////////////////////////////////////////////////////////////////////////////
profileNamespace setVariable ["ONL_saveData",_ONLSaveData];
saveProfileNamespace;