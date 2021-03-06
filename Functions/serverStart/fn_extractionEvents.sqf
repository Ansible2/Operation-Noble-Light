/* ----------------------------------------------------------------------------
Function: ONL_fnc_extractionEvents

Description:
	This adds CBA events relevant to the extraction defense of the mission.
	
	It is executed from the "ONL_fnc_addServerEvents".
	
Parameters:
	NONE

Returns:
	Nothing

Examples:
    (begin example)

		call ONL_fnc_extractionEvents

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
if !(isServer) exitWith {};

missionNameSpace setVariable ["ONL_extractionEventsAdded",true];

private _id = [
	"ONL_getToExtraction_Event",
	{
		ONL_skipLoopsAndEvents pushBack "ONL_extractionReady_skip";
		[
			3,
			{
				call ONL_fnc_extractionMusic;
				
				["Be advised, GoalPost is inbound for extract, ETA 10 minutes."] remoteExecCall ["KISKA_fnc_DatalinkMsg",ONL_allClientsTargetID];

				["Enemy reinforcements are inbound to your position, hold out.",10] remoteExecCall ["KISKA_fnc_DatalinkMsg",ONL_allClientsTargetID];

				[
					{
						null = ["1 minute out"] remoteExec ["KISKA_fnc_DatalinkMsg",ONL_allClientsTargetID];

						// unhide stuff
						[ONL_extractHeli] + (crew ONL_extractHeli) apply {
							_x hideObjectGlobal false; 
							_x enableSimulationGlobal true;
							_x setCaptive true;
						};

						// make sure players can't take turret positions in helicopter
						(allTurrets ONL_extractHeli) apply {
							ONL_extractHeli lockTurret [_x,true];
						};
						ONL_extractHeli lockDriver true;

						// create waypoint
						null = [] spawn ONL_fnc_handleExtractionHeliAI;
						
						// create waypoint when everyone is in
						[
							1,
							{
								[ONL_extractHeliPilots_group,ONL_extractHeliMove_Logic,-1,"MOVE","SAFE","BLUE","FULL"] call CBA_fnc_addWaypoint;
							},
							{
								private _alivePlayers = count (call KISKA_fnc_alivePlayers);

								((count (crew ONL_extractHeli) isEqualTo (4 + _alivePlayers)) AND {_alivePlayers > 0})
							}
						] call KISKA_fnc_waitUntil;				

						// play music when near completion logic and end misssion when even closer
						[
							1,
							{
								if (ONL_CCMLoaded) then {
									["CCM_sb_theoryOfMachines",0,true,1.5] remoteExec ["KISKA_fnc_playMusic",ONL_allClientsTargetID];
								} else {
									if (ONL_KISKAMusicLoaded) then {
										["Kiska_MainTheme2",0,true] remoteExec ["KISKA_fnc_playMusic",ONL_allClientsTargetID];
									};
								};
								 

								[
									1,
									{
										[Extract_TaskID,"Extract_TaskInfo"] call KISKA_fnc_setTaskComplete;

										sleep 1;
																				
										null = remoteExec ["ONL_fnc_endMission",0,true];
									},
									{!(((call CBA_fnc_players) findIf {(_x distance2D ONL_logic_extractionComplete) < 350}) isEqualTo -1)}
								] call KISKA_fnc_waitUntil;
								
							},
							{!(((call CBA_fnc_players) findIf {(_x distance2D ONL_extractHeli) < 500}) isEqualTo -1)}
						] call KISKA_fnc_waitUntil;	
						
					},
					[],
					540 // takes approx 1 minute to reach the extract
				] call CBA_fnc_waitAndExecute;
				
				// attack helicopter if there are enough players
				if (count (call CBA_fnc_players) >= 4) then {
					[
						{
							private _vehicle = createVehicle [ONL_CSATHelicopterAttack,[8210.23,11883.4,0],[],20,"FLY"];
							if !(ONL_snowTigersLoaded) then {
								[
									_vehicle,
									["Black",1], 
									true
								] call BIS_fnc_initVehicle;
							};
							private _group = createVehicleCrew _vehicle;
							private _waypoint = _group addWaypoint [ONL_logic_extraction,50];
							_waypoint setWaypointType "SAD";					
						},
						[],
						(6*60)
					] call CBA_fnc_waitAndExecute;
				};

				[
					{
						null = [] spawn {
							["ONL_spawnVehicle_Event"] call CBA_fnc_serverEvent;
							sleep 1;
							["ONL_spawnVehicle_Event"] call CBA_fnc_serverEvent;
							sleep 1;
							["ONL_spawnGroup_Event"] call CBA_fnc_serverEvent;
							sleep 1;
							["ONL_spawnGroup_Event"] call CBA_fnc_serverEvent;
						};				
					},
					[],
					60
				] call CBA_fnc_waitAndExecute;

				[
					{
						null = [] spawn {
							["ONL_spawnVehicle_Event"] call CBA_fnc_serverEvent;
							sleep 1;
							["ONL_spawnVehicle_Event"] call CBA_fnc_serverEvent;
							sleep 1;
							["ONL_spawnGroup_Event"] call CBA_fnc_serverEvent;
							sleep 1;
							["ONL_spawnGroup_Event"] call CBA_fnc_serverEvent;
							
							if (isDedicated) then {
								["ONL_spawnGroup_Event"] call CBA_fnc_serverEvent;
								sleep 1;
								["ONL_spawnGroup_Event"] call CBA_fnc_serverEvent;
							};
						};

						["About 6 minutes out"] remoteExec ["KISKA_fnc_DatalinkMsg",ONL_allClientsTargetID];						
					},
					[],
					(4.5*60)
				] call CBA_fnc_waitAndExecute;

				[
					{
						null = [] spawn {
							["ONL_spawnVehicle_Event"] call CBA_fnc_serverEvent;
							sleep 1;
							["ONL_spawnVehicle_Event"] call CBA_fnc_serverEvent;
							sleep 1;
							["ONL_spawnGroup_Event"] call CBA_fnc_serverEvent;
							sleep 1;
							["ONL_spawnGroup_Event"] call CBA_fnc_serverEvent;
							
							// add more infantry if on dedicated server
							if (isDedicated) then {
								["ONL_spawnGroup_Event"] call CBA_fnc_serverEvent;
							};
						};

						["3 minutes out"] remoteExec ["KISKA_fnc_DatalinkMsg",ONL_allClientsTargetID];				
					},
					[],
					(7*60)
				] call CBA_fnc_waitAndExecute;

			},
			{!(((call CBA_fnc_players) findIf {(_x distance ONL_logic_extraction) < 50}) isEqualTo -1)}
		] call KISKA_fnc_waitUntil;

		ONL_getToExtract_EventID call CBA_fnc_removeEventHandler;
	}
] call CBA_fnc_addEventHandler;
ONL_getToExtract_EventID = ["ONL_getToExtraction_Event",_id];










[
	"ONL_spawnVehicle_Event",
	{
		private _type = selectRandomWeighted ONL_CSATVehicleVariants;
		private _vehicle = createVehicle [_type,selectRandom [ONL_logic_extraction_spawn_1,ONL_logic_extraction_spawn_2,ONL_logic_extraction_spawn_3],[],20,"NONE"];
		_vehicle setVariable ["ONL_saveExcluded",true];
		
		private _group = createVehicleCrew _vehicle;
		_group setVariable ["ONL_saveExcluded",true];
		
		private _waypoint = _group addWaypoint [ONL_logic_extraction,250];
		_waypoint setWaypointType "SAD";
	}
] call CBA_fnc_addEventHandler;

[
	"ONL_spawnGroup_Event",
	{
		private _group = [6,ONL_CSATVariants,opfor,selectRandom [ONL_logic_extraction_spawn_2,ONL_logic_extraction_spawn_3]] call KISKA_fnc_spawnGroup;
		_group setVariable ["ONL_saveExcluded",true];
		
		private _waypoint = _group addWaypoint [ONL_logic_extraction,100];
		_waypoint setWaypointType "SAD";
	}
] call CBA_fnc_addEventHandler;