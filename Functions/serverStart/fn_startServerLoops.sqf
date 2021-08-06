#include "..\..\Headers\Common Defines.hpp"

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

						["ONL_extract_task"] call KISKA_fnc_createTaskFromConfig;

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
if !(["ONL_investigateBlacksite_task"] call BIS_fnc_taskCompleted) then {
	[
		3,
		{
			["ONL_investigateBlacksite_task"] call KISKA_fnc_endTask;
			////////////SaveGame/////////////
			call ONL_fnc_saveQuery;
			////////////SaveGame/////////////
		},
		{
			["ONL_CollectBaseIntel_task"] call BIS_fnc_taskCompleted AND
			{["ONL_CollectRockSample_task"] call BIS_fnc_taskCompleted} AND
			{["ONL_DestroyBlackSiteServers_task"] call BIS_fnc_taskCompleted}
		}
	] call KISKA_fnc_waitUntil;
};


// waiting to add some blacksite tasks
if !(["ONL_CollectRockSample_task"] call BIS_fnc_taskExists) then {
    [
        3,
        {
			["ONL_CollectRockSample_task"] call KISKA_fnc_createTaskFromConfig;
			["ONL_DestroyBlackSiteServers_task"] call KISKA_fnc_createTaskFromConfig;

            [] spawn ONL_fnc_blackSiteArty;
        },
        {CONDITION_PLAYER_WITHIN_RADIUS_2D(ONL_glowingRock,10)}
    ] call KISKA_fnc_waitUntil;
};




//// Near location loops
// village
if !(["ONL_secureApollo_task"] call BIS_fnc_taskCompleted) then { // get found files task complete
	[
		3,
		{
			["nearVillage"] call ONL_fnc_playMusicForScene;

			// Heli patrol
			[
				{
					[] spawn ONL_fnc_village_spawnHeliPatrol;
				},
				[],
				random [240,300,360]
			] call CBA_fnc_waitAndExecute;

			ONL_apollo setDamage 1;

		},
		{CONDITION_PLAYER_WITHIN_RADIUS_2D(ONL_logic_village,400)}
	] call KISKA_fnc_waitUntil;
};


// base
if !(["ONL_CollectBaseIntel_task"] call BIS_fnc_taskCompleted) then { //get found base files task
	[
		3,
		{
			["Left flank is beginning diversion at this time.",random 10] remoteExec ["KISKA_fnc_dataLinkMsg",ONL_allClientsTargetID];

			[ONL_logic_battleSound,15000,500] spawn KISKA_fnc_battleSound;


			// set off arty fire
			[
				3,
				{
					["nearBase"] call ONL_fnc_playMusicForScene;
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

					if !(["ONL_DestroyBaseArty_task"] call BIS_fnc_taskExists) then {
						["ONL_DestroyBaseArty_task"] call KISKA_fnc_createTaskFromConfig;
						["our lines are taking fire from enemy artillery",4] remoteExec ["KISKA_fnc_DataLinkMsg",ONL_allClientsTargetID];

					};

				},
				{CONDITION_PLAYER_WITHIN_RADIUS_3D(ONL_logic_base_2,800)}
			] call KISKA_fnc_waitUntil;
		},
		{CONDITION_PLAYER_WITHIN_RADIUS_3D(ONL_logic_base_2,1000)}
	] call KISKA_fnc_waitUntil;
};


// lodging
if !(["ONL_SearchLodging_task"] call BIS_fnc_taskCompleted) then {
	[
		3,
		{
			["searchingLodging",0.5] call ONL_fnc_playMusicForScene;
			[ONL_newsRadio_lodging,600] spawn KISKA_fnc_ambientRadio;
		},
		{CONDITION_PLAYER_WITHIN_RADIUS_3D(ONL_logic_lodging,500)}
	] call KISKA_fnc_waitUntil;
};

// facility
if !(["ONL_InvestigateFacility_task"] call BIS_fnc_taskCompleted) then {
	[
		3,
		{
			["investigatingFacility",0.65] call ONL_fnc_playMusicForScene;
		},
		{CONDITION_PLAYER_WITHIN_RADIUS_3D(ONL_logic_facility,600)}
	] call KISKA_fnc_waitUntil;
};

// blacksite
if !(["ONL_CollectRockSample_task"] call BIS_fnc_taskCompleted) then {
	[
		3,
		{
			["nearBlacksite"] call ONL_fnc_playMusicForScene;

			[
				4,
				{
					[ONL_newsRadio_blackSite,600] spawn KISKA_fnc_ambientRadio;
				},
				{CONDITION_PLAYER_WITHIN_RADIUS_3D(ONL_newsRadio_blackSite,50)}
			] call KISKA_fnc_waitUntil;
		},
		{CONDITION_PLAYER_WITHIN_RADIUS_3D(ONL_logic_blackSite_base,800)}
	] call KISKA_fnc_waitUntil;
};

// start random music system
waitUntil {
	if (time > 0) exitWith {
		[false,"",ONL_randomMusicTracks,[120,180,240]] spawn KISKA_fnc_randomMusic;
		true
	};
	false
};
