if !(isServer) exitWith {};

private _id = [
	"ONL_village_CollectedIntel_Event",
	{
		params [
			["_intelObject",objNull,[objNull]]
		];

		if !(isNull _intelObject) then {
			deleteVehicle _intelObject;
		};

		["ONL_village_spawnReinforcements_Event"] call CBA_fnc_ServerEvent;
		
		[SecureApollo_TaskID, "SUCCEEDED", true] call BIS_fnc_taskSetState;
		
		if !([InvestigateBlackSite_TaskID] call BIS_fnc_taskCompleted) then {
			[true,InvestigateBlackSite_TaskID,"InvestigateBlackSite_TaskInfo",objNull,"ASSIGNED",10,true,"SEARCH",false] call BIS_fnc_taskCreate;
		};

		if !([CollectBlackSiteIntel_TaskID select 0] call BIS_fnc_taskCompleted) then {
			[true,CollectBlackSiteIntel_TaskID,"CollectBlackSiteIntel_TaskInfo",objNull,"AUTOASSIGNED",10,true,"SEARCH",false] call BIS_fnc_taskCreate;
		};

		if !([FindHeadScientist_TaskID] call BIS_fnc_taskCompleted) then {
			[true,FindHeadScientist_TaskID,"FindHeadScientist_TaskInfo",objNull,"AUTOASSIGNED",5,true,"SEARCH",false] call BIS_fnc_taskCreate;
		};
		
		// check if coms were already destroyed to create task or not
		if !([DestroyComs_TaskID] call BIS_fnc_taskCompleted) then {
			[
				{
					if !([CollectBaseIntel_TaskID] call BIS_fnc_taskCompleted) then {
						["Recommend you knock out CSAT long range coms before kicking the hornets nest. BREAK"] remoteExec ["KISKA_fnc_DataLinkMsg",[0,-2] select isDedicated];
						["The relay is located at GRID 142-035",4,false] remoteExec ["KISKA_fnc_DataLinkMsg",[0,-2] select isDedicated]; 
						
						[true,CollectBaseIntel_TaskID,"CollectBaseIntel_TaskInfo",ONL_BaseFile,"AUTOASSIGNED",5,true,"LISTEN",false] call BIS_fnc_taskCreate;
					};

					if !([DestroyComs_TaskID] call BIS_fnc_taskCompleted) then {
						[true,DestroyComs_TaskID,"DestroyComs_TaskInfo",ONL_comRelay,"AUTOASSIGNED",5,true,"DESTROY",false] call BIS_fnc_taskCreate;
					};					
					
				},
				[],
				30
			] call CBA_fnc_waitAndExecute;
		};
		
		ONL_village_CollectedIntel_Event_ID call CBA_fnc_removeEventHandler;
	}
] call CBA_fnc_addEventHandler;
ONL_village_CollectedIntel_Event_ID = ["ONL_village_CollectedIntel_Event",_id];



// spawns

// reinforcements
private _id2 = [	
	"ONL_village_spawnReinforcements_Event",
	{
		// create apc
		private _group1 = createGroup resistance;

		for "_i" from 1 to 3 do {
			_group1 createUnit [ONL_spetsnaz_crewman,[0,0,0],[],0,"NONE"];
		}; 
		
		private _apc = createVehicle [ONL_spetsnaz_apc,[7028.84,12029,0]];
		_apc setDir 102;

		if !(ONL_FSGLoaded) then {
			[
				_apc,
				["Guerilla_03",1], 
				["showCamonetHull",1,"showBags",1,"showBags2",1,"showTools",0,"showSLATHull",0]
			] call BIS_fnc_initVehicle;
		};
		
		{
			[_x moveInTurret [_apc,[[0,0],[1]] select ONL_FSGLoaded],_x moveInDriver _apc,_x moveInGunner _apc] select _forEachIndex;
		} forEach (units _group1);

		(units _group1) joinSilent _group1;


		// Create car
		private _group2 = createGroup resistance;

		for "_i" from 1 to 2 do {
			_group2 createUnit [ONL_spetsnaz_crewman,[0,0,0],[],0,"NONE"];
		}; 
		
		private _car = createVehicle [ONL_spetsnaz_carArmed,ONL_logic_village_reinforcements];

		[
			_car,
			["Green",1], 
			["Hide_Shield",1,"Hide_Rail",0,"HideDoor1",0,"HideDoor2",0,"HideDoor3",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0]
		] call BIS_fnc_initVehicle;

		{
			[_x moveInDriver _car,_x moveInGunner _car] select _forEachIndex;
		} forEach (units _group2);

		(units _group2) joinSilent _group2;


		[_group1,_group2] apply {			
			_x deleteGroupWhenEmpty true;
			_x setCombatMode "red";
			private _waypoint = _x addWaypoint [ONL_logic_village,200];
			_waypoint setWaypointType "MOVE";
		};
		
		ONL_village_spawnReinforcements_EventID call CBA_fnc_removeEventHandler;
	}
] call CBA_fnc_addEventHandler;
ONL_village_spawnReinforcements_EventID = ["ONL_village_spawnReinforcements_Event",_id2];


// Helicopter patrol
private _id3 = [	
	"ONL_village_spawnHeliPatrol_Event",
	{
		private _helicopter = createVehicle [ONL_spetsnaz_helicopter,getPosATL ONL_spetsnazHeliSpawn_logic,[],0,"FLY"];
		_helicopter setDir 307;

		private _pilotsGroup = createGroup RESISTANCE;
		for "_i" from 1 to 2 do {
			private _unit = _pilotsGroup createUnit [ONL_spetsnaz_crewman,[0,0,0],[],0,"NONE"];
			[_unit] joinSilent _pilotsGroup;
			
			if (_i isEqualTo 1) then {
				_unit moveInDriver _helicopter;
			} else {
				_unit moveInTurret [_helicopter,[0]];
			};
		};

		private _group = [8,ONL_spetsnazRegular_unitTypes,RESISTANCE] call KISKA_fnc_spawnGroup;

		(units _group) apply {
			_x moveInCargo _helicopter;
		};

		[_group,ONL_gazLogic_2,100,4] call CBA_fnc_taskPatrol;

		((waypoints _group) select 0) setWaypointPosition [ONL_gazLogic_2,0];

		[_pilotsGroup,ONL_spetsnazHeliSpawn_logic,0,"MOVE","SAFE","BLUE","FULL"] call CBA_fnc_addwaypoint;

		[_pilotsGroup,ONL_spetsnazHeliLand_logic,0,"TR UNLOAD","SAFE","BLUE","NORMAL"] call CBA_fnc_addwaypoint;

	
		[
			1,
			{
				params [
					"_helicopter"
				];

				(crew _helicopter) apply {
					_helicopter deleteVehicleCrew _x;
				}; 

				deleteVehicle _helicopter;
			},
			{(_this select 0) distance2D ONL_spetsnazHeliSpawn_logic <= 100 AND {count (crew (_this select 0)) isEqualTo 2}},
			[_helicopter]
		] call KISKA_fnc_waitUntil;

		ONL_village_spawnHeliPatrol_EventID call CBA_fnc_removeEventHandler;
	}
] call CBA_fnc_addEventHandler;
ONL_village_spawnHeliPatrol_EventID = ["ONL_village_spawnHeliPatrol_Event",_id3];