if (!isServer) exitWith {};
// master array
private _ONLSaveData = [];


////////Vehicles/////////
// filter vehicles
private _vehiclesToSave = vehicles select {
	alive _x AND 
	{!(isNull _x)} AND 
	{!(_x in ONL_startingVehicles)} AND 
	{!(_x in ONL_saveExclueded_Vehicles)}
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


////////Groups/////////
private _groupsSaveInfoArray = [];

private _groupsToSave = allGroups select {
	!(_x in ONL_saveExclueded_groups) AND
	{!(isNull _x)} AND
	{((side _x) isEqualTo OPFOR) OR {(side _x) isEqualTo independent}}
};

_groupsToSave apply {
	// group info
	private _group = _x;

	// specific units info
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
		_unitsInfo pushBack [_unitType,_unitLoadout,_isManSimulated,_vehicleInfo];
	};


	// waypoints
	private _waypoints = waypoints _group;
	private _savedWaypoints = [];
	if !(_waypoints isEqualTo []) then {
		_waypoints apply {
			private _wp = _x;
			
			// check if current waypoint
			private _currentWaypoint = currentWaypoint isEqualTo _wp;

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


	// misc group info for spawning
	private _groupBehaviour = behaviour _group;
	private _combatMode = combatMode _group;
	private _groupSide = side _group;
	private _isGroupDySimmed = dynamicSimulationEnabled _group;
	private _deleteWhenEmpty = isGroupDeletedWhenEmpty _group;
	private _groupFormation = formation _group;

	// add to master group list
	_groupsSaveInfoArray pushBack [_groupSide,_isGroupDySimmed,_combatMode,_groupBehaviour,_groupFormation,_deleteWhenEmpty,_unitsInfo,_savedWaypoints];
};
// add masters to actual save
_ONLSaveData pushBack _groupsSaveInfoArray;

////////Tasks/////////
private _fn_isTaskComplete = {
	params ["_task"];

	if (_task isEqualType []) exitWith {
		[(_task select 0)] call BIS_fnc_taskCompleted;
	};
	
	[_task] call BIS_fnc_taskCompleted;
};

private _tasks = [
	FindHeadScientist_TaskID,
	CollectBaseIntel_TaskID,
	DestroyComs_TaskID,
	DestroyArty_taskID,
	CollectBlackSiteIntel_TaskID,
	CollectRockSample_TaskID,
	DestroyBlackSiteServers_TaskID,
	InvestigateBlackSite_TaskID,
	CollectCaveData_TaskID,
	CollectDeviceLogs_TaskID,
	DestroyCaveServers_TaskID,
	DestroyTheDevices_TaskID,
	InvestigateFacility_TaskID,
	SearchLodging_TaskID,
	SecureApollo_TaskID,
	Extract_TaskID
];

private _completedTasks = [];
_tasks apply {
	if ([_x] call _fn_isTaskComplete) then {
		_completedTasks pushBack _x;
	};
};
_ONLSaveData pushBack _completedTasks;



////////SAVE/////////
profileNamespace setVariable ["ONL_saveData",_ONLSaveData];
saveProfileNamespace;