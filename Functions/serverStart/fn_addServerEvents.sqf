/* ----------------------------------------------------------------------------
Function: ONL_fnc_addServerEvents

Description:
	This adds CBA events and general eventHandlers to the server.
	These CBA events were used for certain "insignificant" things I did not want functions for and more so are reactions to players.

	You'll see several if statements wrapping events with globals ending in '_skip'.
	These are used to track if an event has fired in order to have it be null when loading a save.
	
	It is executed from the "initServer.sqf".
	
Parameters:
	NONE

Returns:
	Nothing

Examples:
    (begin example)

		call ONL_fnc_addServerEvents

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
if (!isServer) exitWith {false};

/* ----------------------------------------------------------------------------
	
	BASE

---------------------------------------------------------------------------- */
call {
	// destroy coms
	if !(missionNamespace getVariable ["ONL_comsAlive_skip",false]) then {
		ONL_comRelay addEventHandler ["Killed", {
			[DestroyComs_TaskID,"DestroyComs_TaskInfo"] call Kiska_fnc_setTaskComplete;

			ONL_skipLoopsAndEvents pushBack "ONL_comsAlive_skip";
		}];
	};

	// read file
	if !(missionNamespace getVariable ["ONL_baseFileRead_skip",false]) then {
		private _id = [
			"ONL_base_readFile_Event",
			{
				params [
					["_file",objNull,[objNull]]
				];

				[_file] remoteExec ["deleteVehicle",_file];

				[CollectBaseIntel_TaskID,"CollectBaseIntel_TaskInfo"] call Kiska_fnc_setTaskComplete;

				if !([SearchLodging_TaskID] call BIS_fnc_taskExists) then {
					[true,SearchLodging_TaskID,"SearchLodging_TaskInfo",objNull,"AUTOASSIGNED",5,true,"SEARCH",false] call BIS_fnc_taskCreate;
				};

				ONL_skipLoopsAndEvents pushBack "ONL_baseFileRead_skip";
				////////////SaveGame/////////////
				call ONL_fnc_saveQuery;
				////////////SaveGame/////////////

				ONL_base_readFile_EventID call CBA_fnc_removeEventHandler;
			}
		] call CBA_fnc_addEventHandler;
		ONL_base_readFile_EventID = ["ONL_base_readFile_Event",_id];
	};
};



/* ----------------------------------------------------------------------------
	
	BLACK SITE
	
---------------------------------------------------------------------------- */
call {
	// Black Site Server Destruction
	if !(missionNamespace getVariable ["ONL_blackSiteServersDestroyed_skip",false]) then {
		private _blackSiteServers = (getMissionLayerEntities "Black Site Servers") select 0;
		ONL_blackSite_destroyableServers_count = count _blackSiteServers;

		_blackSiteServers apply {
			_x addEventHandler ["Killed", {
				private _destroyedServersCount_plusOne = (missionNamespace getVariable ["ONL_blackSite_destroyedServers_count",0]) + 1;

				if (_destroyedServersCount_plusOne isEqualTo ONL_blackSite_destroyableServers_count) then {
					[DestroyBlackSiteServers_TaskID,"DestroyBlackSiteServers_TaskInfo"] call Kiska_fnc_setTaskComplete;
					
					ONL_skipLoopsAndEvents pushBack "ONL_blackSiteServersDestroyed_skip";
					////////////SaveGame/////////////
					call ONL_fnc_saveQuery;
					////////////SaveGame/////////////
				} else {
					ONL_blackSite_destroyedServers_count = _destroyedServersCount_plusOne;
				};	
			}];
		};
	};

	// Collect BlackSite intel
	if !(missionNamespace getVariable ["ONL_blackSite_CollectedIntelEvent_skip",false]) then {
		ONL_blackSite_collectableIntel_count = count ((getMissionLayerEntities "Black Site Collects") select 0);

		private _id = [
			"ONL_blackSite_CollectedIntel_Event",
			{
				params [
					["_intelObject",objNull,[objNull]]
				];
				
				deleteVehicle _intelObject;

				private _collectedIntelCount_plusOne = (missionNamespace getVariable ["ONL_blackSite_collectedIntel_count",0]) + 1;

				if (_collectedIntelCount_plusOne isEqualTo ONL_blackSite_collectableIntel_count) then {
					[CollectBlackSiteIntel_TaskID,"CollectBlackSiteIntel_TaskInfo"] call Kiska_fnc_setTaskComplete;
					
					ONL_skipLoopsAndEvents pushBack "ONL_blackSite_CollectedIntelEvent_skip";
					////////////SaveGame/////////////
					call ONL_fnc_saveQuery;
					////////////SaveGame/////////////

					ONL_blackSite_CollectedIntel_Event_ID call CBA_fnc_removeEventHandler;
				} else {
					ONL_blackSite_collectedIntel_count = _collectedIntelCount_plusOne;
				};
			}
		] call CBA_fnc_addEventHandler;
		ONL_blackSite_CollectedIntel_Event_ID = ["ONL_blackSite_CollectedIntel_Event",_id];
	};
};	



/* ----------------------------------------------------------------------------
	
	CAVE
	
---------------------------------------------------------------------------- */
call {
	// Destroy cave generators EHs and sound
	private _caveGenerators = 
	((getMissionLayerEntities "Cave Generators") select 0) apply {
		_x addEventHandler ["Killed", { 
			if (missionNamespace getVariable ["ONL_cave_GeneratorDeadCount",0] isEqualTo 0) then {
				ONL_cave_GeneratorDeadCount = 1;
			} else {
				null = [] spawn ONL_fnc_shutOffLights;
				
				ONL_Cave_generatorShutOff_Event_ID call CBA_fnc_removeEventHandler;
			};
		}];
	};


	// cave generator shutoff event
	private _id = [
		"ONL_cave_generatorShutOff_Event",
		{
			params [
				["_generator",objNull,[objNull]]
			];
			
			["OMLightSwitch",_generator,50,2] call KISKA_fnc_playSound3D;

			_generator setVariable ["ONL_genOff",true,true];

			if (missionNamespace getVariable ["ONL_cave_GeneratorDeadCount",0] isEqualTo 0) then {
				ONL_cave_GeneratorDeadCount = 1;
			} else {
				null = [] spawn ONL_fnc_shutOffLights;

				ONL_Cave_generatorShutOff_Event_ID call CBA_fnc_removeEventHandler;
			};
		}
	] call CBA_fnc_addEventHandler;
	ONL_Cave_generatorShutOff_Event_ID = ["ONL_Cave_generatorShutOff_Event",_id]; // so the event handler can be deleted



	// Cave Server Destruction
	if !(missionNamespace getVariable ["ONL_caveServersDestroyed_skip",false]) then {
		ONL_cave_destroyableServers_count = count ONL_caveServers;

		ONL_caveServers apply {
			_x addEventHandler ["Killed", {
				private _destroyedServersCount_plusOne = (missionNamespace getVariable ["ONL_cave_destroyedServers_count",0]) + 1;

				if (_destroyedServersCount_plusOne isEqualTo ONL_cave_destroyableServers_count) then {
					[DestroyCaveServers_TaskID,"DestroyCaveServers_TaskInfo"] call KISKA_fnc_setTaskComplete;

					ONL_skipLoopsAndEvents pushBack "ONL_caveServersDestroyed_skip";
					////////////SaveGame/////////////
					call ONL_fnc_saveQuery;
					////////////SaveGame/////////////
				} else {
					ONL_cave_destroyedServers_count = _destroyedServersCount_plusOne;
				};	
			}];
		};
	};



	// Collect Cave Intel Event
	if !(missionNamespace getVariable ["ONL_collectedCaveIntel_skip",false]) then {
		ONL_cave_collectableIntel_count = count ONL_caveCollectDevices;

		private _id1 = [
			"ONL_cave_CollectedIntel_Event",
			{
				params [
					["_intelObject",objNull,[objNull]]
				];
				
				deleteVehicle _intelObject;

				private _collectedIntelCount_plusOne = (missionNamespace getVariable ["ONL_cave_collectedIntel_count",0]) + 1;

				if (_collectedIntelCount_plusOne isEqualTo ONL_cave_collectableIntel_count) then {
					[CollectCaveData_TaskID,"CollectCaveData_TaskInfo"] call KISKA_fnc_setTaskComplete;

					ONL_skipLoopsAndEvents pushBack "ONL_collectedCaveIntel_skip";
					////////////SaveGame/////////////
					call ONL_fnc_saveQuery;
					////////////SaveGame/////////////

					ONL_Cave_CollectedIntel_Event_ID call CBA_fnc_removeEventHandler;
				} else {
					ONL_cave_collectedIntel_count = _collectedIntelCount_plusOne;
				};
			}
		] call CBA_fnc_addEventHandler;
		ONL_Cave_generatorShutOff_Event_ID = ["ONL_Cave_CollectedIntel_Event",_id1];
	};



	// Destroy cave devices
	if !(missionNamespace getVariable ["ONL_caveDevicesDestroyed_skip",false]) then { 
		ONL_caveDevices apply {
			_x addEventHandler ["Killed", { 
				if (missionNamespace getVariable ["ONL_cave_devicesDead",0] isEqualTo 0) then {
					ONL_cave_devicesDead = 1;
				} else {
					[DestroyTheDevices_TaskID,"DestroyTheDevices_TaskInfo"] call KISKA_fnc_setTaskComplete;

					ONL_skipLoopsAndEvents pushBack "ONL_caveDevicesDestroyed_skip";
					////////////SaveGame/////////////
					call ONL_fnc_saveQuery;
					////////////SaveGame/////////////
				};
			}];
		};
	};


	// Entered Facility Event
	private _id2 = [
		"ONL_Cave_entered_Event",
		{
			ONL_Cave_entered_EventID call CBA_fnc_removeEventHandler;

			call ONL_fnc_waitToAddCaveTasks;

			// cave in charges timer begins
			[
				{
					["ONL_caveIn_event"] call CBA_fnc_serverEvent;
				},
				[],
				60*15
			] call CBA_fnc_waitAndExecute;

			// wait to show units at end of tunnel
			[
				1,
				{
					[((getMissionLayerEntities "CaveAI") select 0),true,true] call KISKA_fnc_showHide;
				},// check if a player is within 10m of either ONL_logic_cave_3 or ONL_logic_cave_4
				{!(((call CBA_fnc_players) findIf {(_x distance2D ONL_logic_cave_3) < 10 OR {(_x distance2D ONL_logic_cave_4) < 10}}) isEqualTo -1)}
			] call KISKA_fnc_waitUntil;

			// start music
			call ONL_fnc_caveMusic;

			// turn on generator audio
			((getMissionLayerEntities "Cave Generators") select 0) apply {
				[_x] spawn {

					params ["_gen"];

					while {alive _gen AND {!(_gen getVariable ["ONL_genOff",false])}} do {

						playSound3D ["A3\Missions_F_Oldman\Data\sound\Energy_Hum\Energy_Hum_Loop.wss",_gen,true,getPosASL _gen,1,1,50];

						sleep 8.5;
					};
				};
			};
		}
	] call CBA_fnc_addEventHandler;
	ONL_Cave_entered_EventID = ["ONL_Cave_entered_Event",_id2]; // so the event handler can be deleted



	// Dead scientist EH
	if !(missionNamespace getVariable ["ONL_scientistDead_skip",false]) then { 
		ONL_headScientist addEventHandler ["Killed", { 
			[FindHeadScientist_TaskID,"FindHeadScientist_TaskInfo"] call KISKA_fnc_setTaskComplete;

			ONL_skipLoopsAndEvents pushBack "ONL_scientistDead_skip";
			////////////SaveGame/////////////
			call ONL_fnc_saveQuery;
			////////////SaveGame/////////////

			["ONL_getToExtraction_Event"] call CBA_fnc_serverEvent;
		}];
	};



	// cave in event
	if !(missionNamespace getVariable ["ONL_caveChargesDead_skip",false]) then {
		private _id3 = [
			"ONL_caveIn_event",
			{
				null = [] spawn {
					if (alive ONL_charge_1 OR {alive ONL_charge_2} OR {alive ONL_charge_3}) then {
						[ONL_charge_1,ONL_charge_2,ONL_charge_3] apply {
							if (alive _x) then {
								_x enableSimulationGlobal true;
								_x allowDamage true;
								_x setDamage 1;
							};
						};

						// remove defusal actions
						["ONL_charge_1_ID","ONL_charge_2_ID","ONL_charge_3_ID"] apply {
							["ONL_removeDefusalAction_Event",[_x],(call CBA_fnc_players)] call CBA_fnc_targetEvent;
						};
				
						sleep 1;
						
						// show rock cave in
						((getMissionLayerEntities "Cave In") select 0) apply {
							_x hideObjectGlobal false;
						};
						
						ONL_skipLoopsAndEvents pushBack "ONL_caveInHappened_skip";
					};

					ONL_skipLoopsAndEvents pushBack "ONL_caveChargesDead_skip";
					ONL_caveIn_EventID call CBA_fnc_removeEventHandler;
				};
			}
		] call CBA_fnc_addEventHandler;
		ONL_caveIn_EventID = ["ONL_caveIn_event",_id3];
	


		// device defused
		private _id4 = [
			"ONL_deviceDefused_event",
			{
				params [
					["_charge",objNull,[objNull]],
					["_chargeGlobalName","",[""]]
				];

				deleteVehicle _charge;
				
				private _defusedCharges_plusOne = (missionNamespace getVariable ["ONL_defusedCharges_count",0]) + 1;

				if (_defusedCharges_plusOne isEqualTo 3) then {
					//[CollectCaveData_TaskID,"CollectCaveData_TaskInfo"] call Kiska_fnc_setTaskComplete; // need a defuse charges task
					ONL_skipLoopsAndEvents pushBack "ONL_caveChargesDead_skip";
					ONL_deviceDefused_eventID call CBA_fnc_removeEventHandler;
				} else {
					ONL_defusedCharges_count = _defusedCharges_plusOne;

					["ONL_removeDefusalAction_Event",[_chargeGlobalName],(call CBA_fnc_players)] call CBA_fnc_targetEvent;
				};
			}
		] call CBA_fnc_addEventHandler;
		ONL_deviceDefused_eventID = ["ONL_deviceDefused_event",_id4];
	};
};



/* ----------------------------------------------------------------------------
	
	EXTRACTION
	
---------------------------------------------------------------------------- */
// this one would be a little much to have here
call ONL_fnc_extractionEvents;



/* ----------------------------------------------------------------------------
	
	VILLAGE
	
---------------------------------------------------------------------------- */
call {
	
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
			
			[SecureApollo_TaskID,"SUCCEEDED",true] call BIS_fnc_taskSetState;
			
			if !([InvestigateBlackSite_TaskID] call BIS_fnc_taskExists) then {
				[true,InvestigateBlackSite_TaskID,"InvestigateBlackSite_TaskInfo",objNull,"ASSIGNED",10,true,"SEARCH",false] call BIS_fnc_taskCreate;
			};

			if !([CollectBlackSiteIntel_TaskID select 0] call BIS_fnc_taskExists) then {
				[true,CollectBlackSiteIntel_TaskID,"CollectBlackSiteIntel_TaskInfo",objNull,"AUTOASSIGNED",10,true,"SEARCH",false] call BIS_fnc_taskCreate;
			};

			if !([FindHeadScientist_TaskID] call BIS_fnc_taskExists) then {
				[true,FindHeadScientist_TaskID,"FindHeadScientist_TaskInfo",objNull,"AUTOASSIGNED",5,true,"SEARCH",false] call BIS_fnc_taskCreate;
			};
			
			// check if coms were already destroyed to create task or not
			if !([DestroyComs_TaskID] call BIS_fnc_taskExists) then {
				[
					{
						if !([CollectBaseIntel_TaskID] call BIS_fnc_taskExists) then {
							["Recommend you knock out CSAT long range coms before kicking the hornets nest. BREAK"] remoteExec ["KISKA_fnc_DataLinkMsg",ONL_allClientsTargetID];
							["The relay is located at GRID 142-035",4,false] remoteExec ["KISKA_fnc_DataLinkMsg",ONL_allClientsTargetID]; 
							
							[true,CollectBaseIntel_TaskID,"CollectBaseIntel_TaskInfo",ONL_BaseFile,"AUTOASSIGNED",5,true,"LISTEN",false] call BIS_fnc_taskCreate;
						};

						if !([DestroyComs_TaskID] call BIS_fnc_taskExists) then {
							[true,DestroyComs_TaskID,"DestroyComs_TaskInfo",ONL_comRelay,"AUTOASSIGNED",5,true,"DESTROY",false] call BIS_fnc_taskCreate;
						};
						

						////////////SaveGame/////////////
						call ONL_fnc_saveQuery;
						////////////SaveGame/////////////				
						
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
};



/* ----------------------------------------------------------------------------
	
	MISC
	
---------------------------------------------------------------------------- */
call {
	// Was studied Event
	[
		"ONL_wasStudied_Event",
		{
			params [
				["_studiedObject",objNull,[objNull]]
			];
			
			// ensure no one else has the action
			_studiedObject setVariable ["ONL_wasStudied",true,ONL_allClientsTargetID];
			private _typeOfObject = typeOf _studiedObject;

			// checking if it was a device
			if (_typeOfObject isEqualTo "Land_Device_disassembled_F" OR {_typeOfObject isEqualTo "Land_Device_assembled_F"}) exitWith {
				if (missionNamespace getVariable ["ONL_deviceLogsCollected",0] isEqualTo 0) then {
					ONL_deviceLogsCollected = 1;
				} else {
					[CollectDeviceLogs_TaskID,"CollectDeviceLogs_TaskInfo"] call KISKA_fnc_setTaskComplete;
				};
			};

			// check if the object was the rock at the black site
			if (_typeOfObject isEqualTo "Land_W_sharpStone_02") exitWith {
				[CollectRockSample_TaskID,"CollectRockSample_TaskInfo"] call KISKA_fnc_setTaskComplete;
			};

			if (_studiedObject isEqualTo ONL_lodgingLaptop) exitWith {
				["OMIntelGrabLaptop_01",ONL_lodgingLaptop,50,2] call KISKA_fnc_playSound3D;

				[SearchLodging_TaskID,"SearchLodging_TaskInfo"] call KISKA_fnc_setTaskComplete;

				if !([InvestigateFacility_TaskID] call BIS_fnc_taskExists) then {
					[true,InvestigateFacility_TaskID,"InvestigateFacility_TaskInfo",objNull,"AUTOASSIGNED",5,true,"SEARCH",false] call BIS_fnc_taskCreate;
				};
			};

			if (_studiedObject isEqualTo ONL_caveTankComputer) exitWith {
				["OMIntelGrabLaptop_02",ONL_caveTankComputer,50,2] call KISKA_fnc_playSound3D;
			};		
		}
	] call CBA_fnc_addEventHandler;



	// reset plane
	[
		"ONL_resetPlane_Event",
		{
			private _position = getPosATL ONL_cargoPlane_resetLogic;
			private _vectorDir = vectorDir ONL_cargoPlane_resetLogic;
			private _vectorUp = vectorUp ONL_cargoPlane_resetLogic;

			ONL_cargoPlane setPosATL _position;

			[ONL_cargoPlane,[_vectorDir,_vectorUp]] remoteExec ["setVectorDirAndUp",ONL_cargoPlane];

			["Alarm",ONL_logic_startingBaseSpeaker_1,200,3] call KISKA_fnc_playSound3D;
		}
	] call CBA_fnc_addEventHandler;


	// Supply drop 1
	private _id = [
		"ONL_supplyDrop_1_Event",
		{
			params [
				["_classNames",[],[[]]],
				["_altittude",100,[1]],
				["_caller",objNull,[objNull]],
				["_radio",-1,[1]]
			];

			ONL_supplyDrop1Used = true;
			
			[_classNames,_altittude,_caller,_radio] remoteExec ["KISKA_fnc_supplyDrop",2];

			ONL_supplyDrop_1_EventID call CBA_fnc_removeEventHandler;
		}
	] call CBA_fnc_addEventHandler;
	ONL_supplyDrop_1_EventID = ["ONL_supplyDrop_1_Event",_id];


	// Supply drop 2
	private _id1 = [
		"ONL_supplyDrop_2_Event",
		{
			params [
				["_classNames",[],[[]]],
				["_altittude",100,[1]],
				["_caller",objNull,[objNull]],
				["_radio",-1,[1]]
			];

			ONL_supplyDrop2Used = true;
			
			[_classNames,_altittude,_caller,_radio] remoteExec ["KISKA_fnc_supplyDrop",2];

			ONL_supplyDrop_2_EventID call CBA_fnc_removeEventHandler;
		}
	] call CBA_fnc_addEventHandler;
	ONL_supplyDrop_2_EventID = ["ONL_supplyDrop_2_Event",_id1];


	// saving dead pre placed vics
	ONL_prePlacedVehicles apply {
		_x addEventHandler ["KILLED",{
			private _index = ONL_prePlacedVehicles findIf {_x isEqualTo _unit};
			ONL_deadVehicleIndexes pushBack _index;
		}];
	};
};


true