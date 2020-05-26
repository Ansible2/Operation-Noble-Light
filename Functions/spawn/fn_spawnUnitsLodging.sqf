// Interior
private _PMCUnits1 = [4,1,ONL_pmc_Variants,ONL_lodging_interiorPositions,true] call KISKA_fnc_spawn;

// exterior
[4,1,ONL_CSATVariants,ONL_lodging_exteriorPositions,true] call KISKA_fnc_spawn;


uiSleep 1;


// patrol
private _randomPosition = [ONL_logic_lodging,300] call CBA_fnc_randPos;
private _pmcGroup = [4,ONL_pmc_Variants,opfor,_randomPosition] call KISKA_fnc_spawnGroup;
[_pmcGroup,ONL_logic_lodging,300,5,"MOVE","AWARE","RED","LIMITED","STAG COLUMN"] call CBA_fnc_taskPatrol;


uiSleep 1;


// turrets fnc
private _fn_create = {
	params [
		["_logic",objNull,[objNull]],
		["_unit",objNull,[objNull]]
	];

	private _object = createVehicle [ONL_PMC_guntruck,getPosATL _logic,[],0,"CAN_COLLIDE"];
	_object setVectorDirAndUp [vectorDir _logic,vectorUp _logic];
	_object enableDynamicSimulation true;

	allCurators apply {
		_x addCuratorEditableObjects [[_object],true];
	};

	_unit moveInTurret [_object,[0]];
};


uiSleep 1;


// turrets
private _PMCUnits2 = [3,1,ONL_pmc_Variants,[[0,0,0],[0,0,0],[0,0,0]],false] call KISKA_fnc_spawn; 
[ONL_rg31Logic_1,_PMCUnits2 select 0] call _fn_create;
[ONL_rg31Logic_2,_PMCUnits2 select 1] call _fn_create;
(_PMCUnits2 select 2) moveInGunner ONL_turret_lodging;


if !(ONL_CUPUnitsLoaded) then {
	ONL_PMCUnits append (units _pmcGroup);
	ONL_PMCUnits append _PMCUnits1;
	ONL_PMCUnits append _PMCUnits2;
};


["Lodge spawns are complete"] remoteExec ["hint",[0,-2] select isDedicated];