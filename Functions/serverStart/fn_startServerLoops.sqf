call ONL_fnc_waitToAddBlackSiteTasks;

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
				remoteExecCall ["ONL_fnc_transitionToJump",[0,-2] select isDedicated];
				
				[
					{
						ONL_cargoPlane attachTo [ONL_logic_jumpPosition,[0,0,0]];

						[true,Extract_TaskID,"Extract_TaskInfo",[6388.54,9555.92,0],"AUTOASSIGNED",5,false,"takeoff",false] call BIS_fnc_taskCreate;

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


// music loops

// village
[
	3,
	{
		if (ONL_CCMLoaded) then {
			["CCM_SB_cobalt",0,true] remoteExec ["KISKA_fnc_playMusic",[0,-2] select isDedicated];
		} else {
			if (ONL_KISKAMusicLoaded) then {
				["Kiska_Omen",0,true] remoteExec ["KISKA_fnc_playMusic",[0,-2] select isDedicated];
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


// base
[
	3,
	{
		["Left flank is beginning diversion at this time.",random 10] remoteExec ["KISKA_fnc_dataLinkMsg",[0,-2] select isDedicated];

		[ONL_logic_battleSound,15000,500] spawn KISKA_fnc_battleSound;


		// set off arty fire
		[
			3,
			{
				if (ONL_CCMLoaded) then {
					["CCM_sb_extrapolation",0,true] remoteExec ["KISKA_fnc_playMusic",[0,-2] select isDedicated];
				} else {
					if (ONL_KISKAMusicLoaded) then {
						["Kiska_Escape",0,true] remoteExec ["KISKA_fnc_playMusic",[0,-2] select isDedicated];
					};
				};

				call ONL_fnc_baseBunkerRadio;

				if (alive ONL_arty_1) then {
					null = [ONL_arty_1,ONL_extractHeliMove_Logic,5,200,300,[9,10,11]] spawn KISKA_fnc_arty;
				};

				sleep 3;

				if (alive ONL_arty_2) then {
					null = [ONL_arty_2,ONL_extractHeliMove_Logic,5,200,300,[9,10,11]] spawn KISKA_fnc_arty;
				};

				sleep 45;

				if !([DestroyArty_taskID] call BIS_fnc_taskExists) then {
					[true,DestroyArty_taskID,"DestroyArty_taskInfo",objNull,"AUTOASSIGNED",5,true,"DESTROY",false] call BIS_fnc_taskCreate;
					
					["Frontlines are taking fire from enemy artillery",4] remoteExec ["KISKA_fnc_DataLinkMsg",[0,-2] select isDedicated];
				};
			},
			{!(((call CBA_fnc_players) findIf {(_x distance ONL_logic_base_2) < 800}) isEqualTo -1)}
		] call KISKA_fnc_waitUntil;		
	},
	{!(((call CBA_fnc_players) findIf {(_x distance ONL_logic_base_2) < 1000}) isEqualTo -1)}
] call KISKA_fnc_waitUntil;


// lodging
[
	3,
	{
		if (ONL_CCMLoaded) then {
			["CCM_GL_cry",0,true,0.5] remoteExec ["KISKA_fnc_playMusic",[0,-2] select isDedicated];
		} else {
			if (ONL_KISKAMusicLoaded) then {
				["Kiska_Investigation",0,true] remoteExec ["KISKA_fnc_playMusic",[0,-2] select isDedicated];
			};
		};

		[ONL_newsRadio_lodging,600] spawn ONL_fnc_newsRadio;
	},
	{!(((call CBA_fnc_players) findIf {(_x distance ONL_logic_lodging) < 1000}) isEqualTo -1)}
] call KISKA_fnc_waitUntil;


// facility
[
	3,
	{
		if (ONL_CCMLoaded) then {
			["CCM_GL_fate",0,true,0.6] remoteExec ["KISKA_fnc_playMusic",[0,-2] select isDedicated];
		} else {
			if (ONL_KISKAMusicLoaded) then {
				["Kiska_TheSite",0,true,0.7] remoteExec ["KISKA_fnc_playMusic",[0,-2] select isDedicated];
			};
		};
	},
	{!(((call CBA_fnc_players) findIf {(_x distance ONL_logic_facility) < 600}) isEqualTo -1)}
] call KISKA_fnc_waitUntil;


// blacksite
[
	3,
	{
		if (ONL_CCMLoaded) then {
			["CCM_GL_earthFromAMillionMilesAway",0,true] remoteExec ["KISKA_fnc_playMusic",[0,-2] select isDedicated];
		} else {
			if (ONL_KISKAMusicLoaded) then {
				["Kiska_Suspicion",0,true] remoteExec ["KISKA_fnc_playMusic",[0,-2] select isDedicated];
			};
		};

		[
			4,
			{
				[ONL_newsRadio_blackSite,600] spawn ONL_fnc_newsRadio;
			},
			{!(((call CBA_fnc_players) findIf {(_x distance ONL_newsRadio_blackSite) < 50}) isEqualTo -1)}
		] call KISKA_fnc_waitUntil;

		/* find a better condition for this, current use is located in ONL_fnc_waitToAddBlackSiteTasks
		[
			4,
			{
				call ONL_fnc_blackSiteArty;
			},
			{}// needs condition
		] call KISKA_fnc_waitUntil;
		*/
	},
	{!(((call CBA_fnc_players) findIf {(_x distance ONL_logic_blackSite_base) < 800}) isEqualTo -1)}
] call KISKA_fnc_waitUntil;




// start random music system
waitUntil {
	if (time > 0) exitWith {
		if (ONL_CCMLoaded) then {
			[ONL_randomMusicTracksCCM,[300,360,420]] spawn KISKA_fnc_randomMusic;
		} else {
			if (ONL_KISKAMusicLoaded) then {
				[ONL_randomMusicTracksKISKA,[300,360,420]] spawn KISKA_fnc_randomMusic;
			};
		};
		true
	};
	false
};