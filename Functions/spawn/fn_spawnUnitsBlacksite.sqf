if (!isServer) exitWith {};

private _fn_create = {
	params [
		["_logic",objNull,[objNull]],
		["_type","",[""]]
	];
	private _object = createVehicle [_type,getPosATL _logic,[],0,"CAN_COLLIDE"];
	_object setVectorDirAndUp [vectorDir _logic,vectorUp _logic];
	_object enableDynamicSimulation true;
	private _group = createVehicleCrew _object;
	_group setCombatMode "RED";

	allCurators apply {
		_x addCuratorEditableObjects [[_object],true];
	};
};


[ONL_maridLogic_1,ONL_CSAT_APCWheeled] call _fn_create;


uiSleep 1;


[ONL_kamyshLogic_1,ONL_CSAT_APCTracked] call _fn_create;


uiSleep 1;


[ONL_varsukLogic_1,ONL_CSAT_MBT] call _fn_create;


uiSleep 1;

// spawn patrol
private _randomPosition = [ONL_logic_blackSite_perimeter,500] call CBA_fnc_randPos;
private _patrolGroup = [6,ONL_pmc_Variants,opfor,_randomPosition] call KISKA_fnc_spawnGroup;
[_patrolGroup,ONL_logic_blackSite_perimeter,500,5,"MOVE","AWARE","YELLOW","LIMITED","STAG COLUMN"] call CBA_fnc_taskPatrol;

if !(ONL_CUPUnitsLoaded) then {
	ONL_PMCUnits append (units _patrolGroup);
};


// Helicopter Patrol
call {
	private _helicopter = createVehicle [ONL_orca,position ONL_blackSite_heliPad,[],0,"NONE"];

	if !(ONL_snowTigersLoaded) then {
		[
			_helicopter,
			["Black",1], 
			true
		] call BIS_fnc_initVehicle;
	};

	_helicopter setUnloadInCombat [false,false];


	uiSleep 1;


	private _pilotsGroup = createGroup OPFOR;
	for "_i" from 1 to 2 do {
		private _unit = _pilotsGroup createUnit [ONL_CSAT_crewman,[0,0,0],[],0,"NONE"];
		if (isNull _unit) then {
			_unit = _pilotsGroup createUnit [ONL_CSAT_crewman,[0,0,0],[],0,"NONE"];
		};
		
		if (_i isEqualTo 1) then {
			_unit moveInDriver _helicopter;
		} else {
			_unit moveInTurret [_helicopter,[0]];
		};
	};

	private _group1 = [4,ONL_CSATVariants,OPFOR] call KISKA_fnc_spawnGroup;
	_group1 enableDynamicSimulation false;


	uiSleep 1;


	private _group2 = [4,ONL_CSATVariants,OPFOR] call KISKA_fnc_spawnGroup;
	_group2 enableDynamicSimulation false;

	(units _group1) + (units _group2) apply {
		_x moveInCargo _helicopter;
		uiSleep 0.1;
	};

	[_helicopter,[ONL_heliPatroLogic_blackSite_1,ONL_heliPatroLogic_blackSite_2,ONL_heliPatroLogic_blackSite_3,ONL_heliPatroLogic_blackSite_4],500,100,"LIMITED"] call KISKA_fnc_heliPatrol;
};


uiSleep 1;


// checkpoints
private _fn_popCheckpoint = {
	params [
		["_turret",objNull,[objNull]],
		["_gunTruckLogic",objNull,[objNull]],
		["_checkpointPositions",[],[[]]]
	];

	private _gunTruck = createVehicle [ONL_PMC_guntruck,getPosATL _gunTruckLogic,[],0,"CAN_COLLIDE"];
	_gunTruck setVectorDirAndUp [vectorDir _gunTruckLogic,vectorUp _gunTruckLogic];
	_gunTruck enableDynamicSimulation true;

	allCurators apply {
		_x addCuratorEditableObjects [[_gunTruck],true];
	};

	[_gunTruck,true] remoteExec ["setPilotLight",_gunTruck];
	private _group1Units = [4,1,ONL_pmc_Variants,_checkpointPositions,true] call KISKA_fnc_spawn;

	private _group2 = [2,ONL_pmc_Variants,opfor] call KISKA_fnc_spawnGroup;
	{
		if (_forEachIndex isEqualTo 0) then {_x moveInGunner _turret};

		if (_forEachIndex isEqualTo 1) then {_x moveInTurret [_gunTruck,[0]]};
	} foreach (units _group2);

	if (!ONL_CUPUnitsLoaded) then {
		ONL_PMCUnits append _group1Units;
		ONL_PMCUnits append (units _group2);
	};
};


[ONL_turret_checkpoint1,ONL_rg31Logic_5,ONL_blackSite_checkpointPositions_1] call _fn_popCheckpoint;


uiSleep 1;


[ONL_turret_checkpoint2,ONL_rg31Logic_3,ONL_blackSite_checkpointPositions_2] call _fn_popCheckpoint;


uiSleep 1;


[ONL_turret_checkpoint3,ONL_rg31Logic_4,ONL_blackSite_checkpointPositions_3] call _fn_popCheckpoint;


uiSleep 1;


// interior
[4,1,ONL_CSATVariants,ONL_blackSite_interiorPositions_1a] call KISKA_fnc_spawn;


uiSleep 1;


// exterior
[4,1,ONL_CSATVariants,ONL_blackSite_exteriorPositions,true] call KISKA_fnc_spawn;


uiSleep 1;


// dig site
[4,1,ONL_CSATVariants,ONL_blackSite_interiorPositions_1b,false,true,opfor] call KISKA_fnc_spawn;