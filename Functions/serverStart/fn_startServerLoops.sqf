if (!isServer) exitWith {};

// cargo plane takeoff loop
[
	2,
	{
		if ((ONL_cargoPlane animationSourcePhase "back_ramp") isEqualTo 1) then {
			ONL_cargoPlane animateSource ["back_ramp",0];
			ONL_cargoPlane animateSource ["back_ramp_switch",0];
		};

		ONL_cargoPlaneGroup move (getPosATL ONL_logic_dummy_1);
		
		[
			1,
			{
				remoteExecCall ["ONL_fnc_transitionToJump",ONL_allClientsTargetID];
				
				[
					{
						ONL_cargoPlane attachTo [ONL_logic_jumpPosition,[0,0,0]];
						
						if !([Extract_TaskID] call BIS_fnc_taskExists) then {
							[true,Extract_TaskID,"Extract_TaskInfo",[6388.54,9555.92,0],"AUTOASSIGNED",5,false,"takeoff",false] call BIS_fnc_taskCreate;
						};

						ONL_airfieldRespawn call BIS_fnc_removeRespawnPosition;
						
						ONL_cargoPlaneRespawn = [missionNamespace,(getPosATLVisual ONL_cargoPlane) vectorAdd [0,-2,0.5],"Cargo Plane Respawn"] call BIS_fnc_addRespawnPosition;
						
						call ONL_fnc_waitToDeletePlane;
					},
					[],
					4
				] call CBA_fnc_waitAndExecute;				
								
			},
			{(ONL_cargoPlane distance ONL_logic_dummy_1) < 300},
			[],
			true
		] call KISKA_fnc_waitUntil;

	},
	{count (crew ONL_cargoPlane) isEqualTo (count (call CBA_fnc_players)) + 2 AND {count (call CBA_fnc_players) > 0}}
] call KISKA_fnc_waitUntil;




// wait to set investigate black site task complete
if !([InvestigateBlackSite_TaskID] call BIS_fnc_taskCompleted) then {
	[
		3,
		{
			[InvestigateBlackSite_TaskID,"SUCCEEDED",true] call BIS_fnc_taskSetState;
			////////////SaveGame/////////////
			call ONL_fnc_saveQuery;
			////////////SaveGame/////////////
		},
		{[CollectBlackSiteIntel_TaskID select 0] call BIS_fnc_taskCompleted AND {[CollectRockSample_TaskID select 0] call BIS_fnc_taskCompleted} AND {[DestroyBlackSiteServers_TaskID select 0] call BIS_fnc_taskCompleted}}
	] call KISKA_fnc_waitUntil;
};


// waiting to add some blacksite tasks
if !([CollectRockSample_TaskID select 0] call BIS_fnc_taskExists) then {
    [
        3,
        {		
            [true,CollectRockSample_TaskID,"CollectRockSample_TaskInfo",ONL_glowingRock,"AUTOASSIGNED",5,true,"INTERACT",false] call BIS_fnc_taskCreate;            
            [true,DestroyBlackSiteServers_TaskID,"DestroyBlackSiteServers_TaskInfo",ONL_blackSiteServer_2,"AUTOASSIGNED",5,true,"DESTROY",false] call BIS_fnc_taskCreate;

            [] spawn ONL_fnc_blackSiteArty;
        },
        {!(((call CBA_fnc_players) findIf {(_x distance2D ONL_glowingRock) < 10}) isEqualTo -1)}
    ] call KISKA_fnc_waitUntil;
};




//// Near location loops
// village
if !([SecureApollo_TaskID] call BIS_fnc_taskCompleted) then { // get found files task complete
	[
		3,
		{
			if (ONL_CCMLoaded) then {
				["CCM_SB_cobalt",0,true] remoteExec ["KISKA_fnc_playMusic",ONL_allClientsTargetID];
			} else {
				if (ONL_KISKAMusicLoaded) then {
					["Kiska_Omen",0,true] remoteExec ["KISKA_fnc_playMusic",ONL_allClientsTargetID];
				};
			};

			// Heli patrol
			[
				{
					["ONL_village_spawnHeliPatrol_Event"] call CBA_fnc_serverEvent;
				},
				[],
				random [240,300,360]
			] call CBA_fnc_waitAndExecute;

			ONL_apollo setDamage 1;

		},
		{!(((call CBA_fnc_players) findIf {(_x distance ONL_logic_village) < 400}) isEqualTo -1)}
	] call KISKA_fnc_waitUntil;
};


// base
if !([CollectBaseIntel_TaskID] call BIS_fnc_taskCompleted) then { //get found base files task
	[
		3,
		{
			["Left flank is beginning diversion at this time.",random 10] remoteExec ["KISKA_fnc_dataLinkMsg",ONL_allClientsTargetID];

			[ONL_logic_battleSound,15000,500] spawn KISKA_fnc_battleSound;


			// set off arty fire
			[
				3,
				{
					if (ONL_CCMLoaded) then {
						["CCM_sb_extrapolation",0,true] remoteExec ["KISKA_fnc_playMusic",ONL_allClientsTargetID];
					} else {
						if (ONL_KISKAMusicLoaded) then {
							["Kiska_Escape",0,true] remoteExec ["KISKA_fnc_playMusic",ONL_allClientsTargetID];
						};
					};

					call ONL_fnc_baseBunkerRadio;

					// fire some ambient arty shots to alert players to their location
					if (alive ONL_arty_1) then {
						[ONL_arty_1,ONL_extractHeliMove_Logic,5,200,300,[10,11,12]] spawn KISKA_fnc_arty;
					};

					sleep 3;

					if (alive ONL_arty_2) then {
						[ONL_arty_2,ONL_extractHeliMove_Logic,5,200,300,[11,12,13]] spawn KISKA_fnc_arty;
					};

					sleep 45;

					if !([DestroyArty_taskID] call BIS_fnc_taskExists) then {
						[true,DestroyArty_taskID,"DestroyArty_taskInfo",objNull,"AUTOASSIGNED",5,true,"DESTROY",false] call BIS_fnc_taskCreate;
						
						["Frontlines are taking fire from enemy artillery",4] remoteExec ["KISKA_fnc_DataLinkMsg",ONL_allClientsTargetID];
					};

				},
				{!(((call CBA_fnc_players) findIf {(_x distance ONL_logic_base_2) < 800}) isEqualTo -1)}
			] call KISKA_fnc_waitUntil;		
		},
		{!(((call CBA_fnc_players) findIf {(_x distance ONL_logic_base_2) < 1000}) isEqualTo -1)}
	] call KISKA_fnc_waitUntil;
};


// lodging
if !([SearchLodging_TaskID] call BIS_fnc_taskCompleted) then {
	[
		3,
		{
			if (ONL_CCMLoaded) then {
				["CCM_GL_cry",0,true,0.5] remoteExec ["KISKA_fnc_playMusic",ONL_allClientsTargetID];
			} else {
				if (ONL_KISKAMusicLoaded) then {
					["Kiska_Investigation",0,true] remoteExec ["KISKA_fnc_playMusic",ONL_allClientsTargetID];
				};
			};

			[ONL_newsRadio_lodging,600] spawn ONL_fnc_newsRadio;
		},
		{!(((call CBA_fnc_players) findIf {(_x distance ONL_logic_lodging) < 500}) isEqualTo -1)}
	] call KISKA_fnc_waitUntil;
};

// facility
if !([InvestigateFacility_TaskID] call BIS_fnc_taskCompleted) then {
	[
		3,
		{
			if (ONL_CCMLoaded) then {
				["CCM_GL_fate",0,true,0.6] remoteExec ["KISKA_fnc_playMusic",ONL_allClientsTargetID];
			} else {
				if (ONL_KISKAMusicLoaded) then {
					["Kiska_TheSite",0,true,0.7] remoteExec ["KISKA_fnc_playMusic",ONL_allClientsTargetID];
				};
			};
		},
		{!(((call CBA_fnc_players) findIf {(_x distance ONL_logic_facility) < 600}) isEqualTo -1)}
	] call KISKA_fnc_waitUntil;
};

// blacksite
if !([CollectRockSample_TaskID select 0] call BIS_fnc_taskCompleted) then {
	[
		3,
		{
			if (ONL_CCMLoaded) then {
				["CCM_GL_earthFromAMillionMilesAway",0,true] remoteExec ["KISKA_fnc_playMusic",ONL_allClientsTargetID];
			} else {
				if (ONL_KISKAMusicLoaded) then {
					["Kiska_Suspicion",0,true] remoteExec ["KISKA_fnc_playMusic",ONL_allClientsTargetID];
				};
			};

			[
				4,
				{
					[ONL_newsRadio_blackSite,600] spawn ONL_fnc_newsRadio;
				},
				{!(((call CBA_fnc_players) findIf {(_x distance ONL_newsRadio_blackSite) < 50}) isEqualTo -1)}
			] call KISKA_fnc_waitUntil;
		},
		{!(((call CBA_fnc_players) findIf {(_x distance ONL_logic_blackSite_base) < 800}) isEqualTo -1)}
	] call KISKA_fnc_waitUntil;
};

// start random music system
waitUntil {
	if (time > 0) exitWith {
		if (ONL_CCMLoaded) then {
			[false,"",ONL_randomMusicTracksCCM,[120,180,240]] spawn KISKA_fnc_randomMusic;
		} else {
			if (ONL_KISKAMusicLoaded) then {
				[false,"",ONL_randomMusicTracksKISKA,[120,180,240]] spawn KISKA_fnc_randomMusic;
			};
		};
		true
	};
	false
};