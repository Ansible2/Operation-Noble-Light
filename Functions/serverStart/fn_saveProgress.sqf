// filter vehicles
private _vehiclesToSave = vehicles select {
	alive _x AND 
	{!(isNull _x)} AND 
	{!(_x in ONL_startingVehicles)} AND 
	{!(_x in ONL_savedExclueded_Vehicles)}
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

	[_vehicleType,_vectorDirAndUp,_vehiclePosWorld,_isVehicleSimulated,_isVehicleDySimmed,_vehicleCargo,_vehicleIsCrewed];
};