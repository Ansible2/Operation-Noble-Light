if (!isServer) exitWith {};

private _fn_createSimple = {
	params [
		["_logic",objNull,[objNull]],
		["_type","",[""]]
	];
	
	private "_object";
	if (_type isEqualTo "fsg_tigr_1") then {
		_object = createVehicle [_type, getPosATL _logic];
		_object enableSimulationGlobal false;
		_object setVectorDirAndUp [vectorDir _logic,vectorUp _logic];
	} else {
		_object = createSimpleObject [_type, getPosASL _logic, false];
		_object setVectorDirAndUp [vectorDir _logic,vectorUp _logic];
	};

	_object
};

// gaz
ONL_gazCompatLogics apply {
	[_x,ONL_spetsnaz_car] call _fn_createSimple;
};

// ifrits
ONL_ifritCompatLogics apply {
	private _type = selectRandom ONL_ifritVariants;
	[_x,_type] call _fn_createSimple;
};

// Tempest
ONL_tempestCompatLogics apply {
	private _type = selectRandom ONL_tempestVariants;
	[_x,_type] call _fn_createSimple;
};

// orca
ONL_orcaCompatLogics apply {
	[_x,ONL_orca] call _fn_createSimple;
};

// taru pods
ONL_taruPodsCompatLogics apply {
	private _type = selectRandom ONL_taruPodsVariants;
	[_x,_type] call _fn_createSimple;
};