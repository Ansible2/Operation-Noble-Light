/* ----------------------------------------------------------------------------
Function: ONL_fnc_spawnUnitsNewGame

Description:
	Opposite of ONL_fnc_loadProgress.
	This will spawn most of the enemy units in the mission when starting a new game.

Parameters:
	NONE

Returns:
	Nothing

Examples:
    (begin example)

		null = [] spawn ONL_fnc_spawnUnitsNewGame;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
if (!isServer) exitWith {};

//////////////////////////////
/////////////BASE/////////////
//////////////////////////////
call {
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

		_group setVariable ["ONL_loadCreationCode",{
			params ["_group"];
			[_group] call CBA_fnc_clearWaypoints;
			private _randomPosition = [ONL_logic_base_2,300] call CBA_fnc_randPos;
			[_group,_randomPosition,300,4,"MOVE","AWARE","YELLOW","LIMITED","STAG COLUMN"] call CBA_fnc_taskPatrol;
		}];
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

	//// bunker patrols
	// patrol 1
	private _patrol1 = [3,ONL_CSATVariants,OPFOR,ONL_baseBunker_patrolLogic_1] call KISKA_fnc_spawnGroup;

	_patrol1 setVariable ["ONL_loadCreationCode",{
		params ["_group"];
		[_group] call CBA_fnc_clearWaypoints;
		[_group,ONL_baseBunker_patrolLogic_1,300,4,"MOVE","AWARE","YELLOW","LIMITED","STAG COLUMN"] call CBA_fnc_taskPatrol;
	}];

	[_patrol1,ONL_baseBunker_patrolLogic_1,200,4,"MOVE","AWARE","RED","LIMITED","STAG COLUMN"] call CBA_fnc_taskPatrol;

	uiSleep 1;

	// patrol 2
	private _patrol2 = [3,ONL_CSATVariants,OPFOR,ONL_baseBunker_patrolLogic_2] call KISKA_fnc_spawnGroup;
	_patrol2 setVariable ["ONL_loadCreationCode",{
		params ["_group"];
		[_group] call CBA_fnc_clearWaypoints;
		[_group,ONL_baseBunker_patrolLogic_2,300,4,"MOVE","AWARE","YELLOW","LIMITED","STAG COLUMN"] call CBA_fnc_taskPatrol;
	}];
	[_patrol2,ONL_baseBunker_patrolLogic_2,200,4,"MOVE","AWARE","RED","LIMITED","STAG COLUMN"] call CBA_fnc_taskPatrol;

	uiSleep 1;

	// Helicopter Patrol
	call ONL_fnc_createBaseHeliPatrol;

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

		_group setVariable ["ONL_saveExcluded",true];
		_x setVariable ["ONL_saveExcluded",true];
	};
};



//////////////////////////////
/////////////Black site///////
//////////////////////////////
call {
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

	_patrolGroup setVariable ["ONL_loadCreationCode",{
		params ["_group"];
		[_group] call CBA_fnc_clearWaypoints;
		[_group,ONL_logic_blackSite_perimeter,500,5,"MOVE","AWARE","YELLOW","LIMITED","STAG COLUMN"] call CBA_fnc_taskPatrol;
	}];

	if !(ONL_CUPUnitsLoaded) then {
		ONL_PMCUnits append (units _patrolGroup);
	};


	// Helicopter Patrol
	call ONL_fnc_createBlackSiteHeliPatrol;

	uiSleep 1;


	// checkpoints
	private _fn_popCheckpoint = {
		params [
			["_turret",objNull,[objNull]],
			["_gunTruckLogic",objNull,[objNull]],
			["_checkpointPositions",[],[[]]]
		];

		private _gunTruck = createVehicle [ONL_PMC_guntruck,getPosATL _gunTruckLogic,[],0,"CAN_COLLIDE"];

		// if cup is not loaded stop BIS randomization on trucks and make them look a certain way
		if (!ONL_CUPVehiclesLoaded) then {
			[
				_gunTruck,
				["Green",1], 
				["Hide_Shield",1,"Hide_Rail",1,"HideDoor1",0,"HideDoor2",0,"HideDoor3",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0]
			] call BIS_fnc_initVehicle;
		};

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
};



//////////////////////////////
/////////////CAVE/////////////
//////////////////////////////
call {
	// entry
	[4,2,ONL_CSATViper_unitTypes,ONL_cave_entryWayPositions,false] call KISKA_fnc_spawn;
	uiSleep 1;

	// garage
	[3,3,ONL_CSATViper_unitTypes,ONL_cave_garagePositions,false] call KISKA_fnc_spawn;
	
	uiSleep 1;
	
	// left Path 1
	[3,1,ONL_CSATViper_unitTypes,ONL_cave_leftPath_positions_1,false] call KISKA_fnc_spawn;
	
	uiSleep 1;
	
	// left Path 2
	[3,1,ONL_CSATViper_unitTypes,ONL_cave_leftPath_positions_2,false] call KISKA_fnc_spawn;
	
	uiSleep 1;
	
	// living area
	[4,2,ONL_CSATViper_unitTypes,ONL_cave_livingArea_positions,false] call KISKA_fnc_spawn;
	
	uiSleep 1;
	
	// office area
	[4,2,ONL_CSATViper_unitTypes,ONL_cave_officeArea_positions,false] call KISKA_fnc_spawn;
	
	uiSleep 1;
	
	// right Path 1
	[3,1,ONL_CSATViper_unitTypes,ONL_cave_rightPath_positions_1,false] call KISKA_fnc_spawn;
	
	uiSleep 1;
	
	// right Path 2
	[3,1,ONL_CSATViper_unitTypes,ONL_cave_rightPath_positions_2,false] call KISKA_fnc_spawn;
	
	uiSleep 1;
	
	[4,4,ONL_CSATViper_unitTypes,ONL_cave_center_positions_1,false] call KISKA_fnc_spawn;
	private _units = [5,4,ONL_CSATViper_unitTypes,ONL_cave_center_positions_2,false] call KISKA_fnc_spawn;
	(_units select 4) moveInTurret [ONL_caveMarid,[0]];
	
	uiSleep 1;
	
	[4,4,ONL_CSATViper_unitTypes,ONL_cave_center_positions_3,false] call KISKA_fnc_spawn;
	
	uiSleep 1;
	
	[4,4,ONL_CSATViper_unitTypes,ONL_cave_center_positions_4,false] call KISKA_fnc_spawn;
};



//////////////////////////////
/////////////FACILITY/////////
//////////////////////////////
call {
	// Interior
	[4,1,ONL_CSATVariants,ONL_facility_interiorPositions] call KISKA_fnc_spawn;

	// Exterior
	[4,1,ONL_CSATVariants,ONL_facility_exteriorPositions,true] call KISKA_fnc_spawn;
		
	// patrol 1
	private _randomPosition = [ONL_logic_facility,300] call CBA_fnc_randPos;
	private _patrol1 = [3,ONL_pmc_Variants,opfor,_randomPosition] call KISKA_fnc_spawnGroup;
	[_patrol1,ONL_logic_facility,300,5,"MOVE","AWARE","RED","LIMITED","STAG COLUMN"] call CBA_fnc_taskPatrol;

	_patrol1 setVariable ["ONL_loadCreationCode",{
		params ["_group"];
		[_group] call CBA_fnc_clearWaypoints;
		[_group,ONL_logic_facility,300,5,"MOVE","AWARE","RED","LIMITED","STAG COLUMN"] call CBA_fnc_taskPatrol;
	}];

	// patrol 2
	private _randomPosition = [ONL_logic_facility,300] call CBA_fnc_randPos;
	private _patrol2 = [3,ONL_pmc_Variants,opfor,_randomPosition] call KISKA_fnc_spawnGroup;
	[_patrol2,ONL_logic_facility,300,5,"MOVE","AWARE","RED","LMITED","STAG COLUMN"] call CBA_fnc_taskPatrol;

	_patrol2 setVariable ["ONL_loadCreationCode",{
		params ["_group"];
		[_group] call CBA_fnc_clearWaypoints;
		[_group,ONL_logic_facility,300,5,"MOVE","AWARE","RED","LMITED","STAG COLUMN"] call CBA_fnc_taskPatrol;
	}];


	if !(ONL_CUPUnitsLoaded) then {
		ONL_PMCUnits append (units _patrol1);
		ONL_PMCUnits append (units _patrol2);
	};
};



//////////////////////////////
/////////////LODGING//////////
//////////////////////////////
call {
	// Interior
	private _PMCUnits1 = [4,1,ONL_pmc_Variants,ONL_lodging_interiorPositions,true] call KISKA_fnc_spawn;

	// exterior
	[4,1,ONL_CSATVariants,ONL_lodging_exteriorPositions,true] call KISKA_fnc_spawn;


	uiSleep 1;


	// patrol
	private _randomPosition = [ONL_logic_lodging,300] call CBA_fnc_randPos;
	private _pmcGroup = [4,ONL_pmc_Variants,opfor,_randomPosition] call KISKA_fnc_spawnGroup;
	[_pmcGroup,ONL_logic_lodging,300,5,"MOVE","AWARE","RED","LIMITED","STAG COLUMN"] call CBA_fnc_taskPatrol;

	_pmcGroup setVariable ["ONL_loadCreationCode",{
		params ["_group"];
		[_group] call CBA_fnc_clearWaypoints;
		[_group,ONL_logic_lodging,300,5,"MOVE","AWARE","RED","LIMITED","STAG COLUMN"] call CBA_fnc_taskPatrol;
	}];

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
};



//////////////////////////////
/////////////VILLAGE//////////
//////////////////////////////
call {
	[count ONL_village_positions_group1,1,ONL_spetsnazSFVariants,ONL_village_positions_group1,true,true,resistance] call KISKA_fnc_spawn;
		
	uiSleep 1;

	[count ONL_village_positions_group2,3,ONL_spetsnazSFVariants,ONL_village_positions_group2,false,true,resistance] call KISKA_fnc_spawn;

	uiSleep 1;

	private _animatedUnits = [count ONL_village_positions_group3,3,ONL_spetsnazSFVariants,ONL_village_positions_group3,false,true,resistance] call KISKA_fnc_spawn;

	_animatedUnits apply {
		[_x] call BIS_fnc_ambientAnimCombat;
	};

	uiSleep 1;

	// village patrols
	for "_i" from 1 to 2 do {
		private _randomPosition = [ONL_logic_village,500] call CBA_fnc_randPos;
		private _group = [6,ONL_spetsnazRegular_unitTypes,resistance,_randomPosition] call KISKA_fnc_spawnGroup;
		
		uiSleep 1;
		
		missionNamespace setVariable ["ONL_villagePatrol_" + (str _i),_group];
		[_group,_randomPosition,500,5,"MOVE","AWARE","YELLOW","LIMITED","STAG COLUMN"] call CBA_fnc_taskPatrol;

		if (_i isEqualTo 1) then {
			_group setVariable ["ONL_loadCreationCode",{
				private _group = param [0];
				missionNamespace setVariable ["ONL_villagePatrol_1",_group];
				[_group] call CBA_fnc_clearWaypoints;
				private _randomPosition = [ONL_logic_village,500] call CBA_fnc_randPos;
				[_group,_randomPosition,500,5,"MOVE","AWARE","YELLOW","LIMITED","STAG COLUMN"] call CBA_fnc_taskPatrol;
			}];
		} else {
			_group setVariable ["ONL_loadCreationCode",{
				private _group = param [0];
				missionNamespace setVariable ["ONL_villagePatrol_2",_group];
				[_group] call CBA_fnc_clearWaypoints;
				private _randomPosition = [ONL_logic_village,500] call CBA_fnc_randPos;
				[_group,_randomPosition,500,5,"MOVE","AWARE","YELLOW","LIMITED","STAG COLUMN"] call CBA_fnc_taskPatrol;
			}];
		};
	};


	/// need to find the reference for this
	ONL_villagePatrols = [ONL_villagePatrol_1,ONL_villagePatrol_2];
};