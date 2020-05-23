// turrets
private _turretUnits = [4,1,ONL_CSATVariants,[[0,0,0],[0,0,0],[0,0,0],[0,0,0]],true] call KISKA_fnc_spawn;
private _turrets = [ONL_turretBase_1,ONL_turretBase_2,ONL_turretBase_3,ONL_turretBase_4];
{
	_x moveInGunner (_turrets select _forEachIndex);
} forEach _turretUnits;


uiSleep 1;


// Entry checkpoint
private _checkpointUnits = [3,3,ONL_CSATVariants,ONL_base_checkPoint_positions] call KISKA_fnc_spawn;
(_checkpointUnits select 2) moveInTurret [ONL_baseIfrit_1,[0]];


uiSleep 1;


// patrols
for "_i" from 1 to 2 do {
	private _randomPosition = [ONL_logic_base_2,300] call CBA_fnc_randPos;

	private _group = [3,ONL_CSATVariants,OPFOR,_randomPosition] call KISKA_fnc_spawnGroup;
	
	uiSleep 1;

	[_group,_randomPosition,300,4,"MOVE","AWARE","YELLOW","LIMITED","STAG COLUMN"] call CBA_fnc_taskPatrol;
};


// building interiors
[5,5,ONL_CSATVariants,ONL_base_buildingInterior_positions] call KISKA_fnc_spawn;


uiSleep 1;

// building exteriors
[5,5,ONL_CSATVariants,ONL_base_buildingExterior_positions] call KISKA_fnc_spawn;


uiSleep 1;


// general positions
[10,1,ONL_CSATVariants,ONL_base_general_positions,true] call KISKA_fnc_spawn;


uiSleep 1;


// bunker interior
[8,4,ONL_CSATVariants,ONL_base_bunkerInterior_positions] call KISKA_fnc_spawn;


uiSleep 1;

// bunker exterior
private _bunkerUnits = [5,1,ONL_CSATVariants,ONL_base_bunkerExterior_positions] call KISKA_fnc_spawn;
(_bunkerUnits select 4) moveInTurret [ONL_baseIfrit_2,[0]];


uiSleep 1;


// bunker patrols
[ONL_baseBunker_patrolLogic_1,ONL_baseBunker_patrolLogic_2] apply {
	private _group = [3,ONL_CSATVariants,OPFOR,_x] call KISKA_fnc_spawnGroup;

	[_group,_x,200,4,"MOVE","AWARE","RED","LIMITED","STAG COLUMN"] call CBA_fnc_taskPatrol;

	uiSleep 1;
};


// Helicopter Patrol
call {
	private _helicopter = createVehicle [ONL_CSATHelicopterAttack,position ONL_baseHelipad,[],0,"NONE"];

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
			_unit moveInGunner _helicopter;
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
	

	[_helicopter,[ONL_heliPatroLogic_1,ONL_heliPatroLogic_2,ONL_heliPatroLogic_3,ONL_heliPatroLogic_4],600,100,"LIMITED",false] call KISKA_fnc_heliPatrol;
};


// Artillery
[ONL_arty_1,ONL_arty_2] apply {
	private _group = createVehicleCrew _x;
	_group enableDynamicSimulation true;

	_x addEventHandler ["KILLED", {
		private _deadCount = missionNamespace getVariable ["ONL_deadArty",0];
		
		if (_deadCount isEqualTo 1) then {
			[DestroyArty_taskID,DestroyArty_taskInfo] call KISKA_fnc_setTaskComplete;
		} else {
			ONL_deadArty = 1;
		};
	}];
};