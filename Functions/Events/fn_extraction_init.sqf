#include "..\..\Headers\Common Defines.hpp"
/* ----------------------------------------------------------------------------
Function: ONL_fnc_extraction_init

Description:
    inits several waituntil's relevant for the extraction phase.

Parameters:
	NONE

Returns:
	Nothing

Examples:
    (begin example)
		call ONL_fnc_extraction_init;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "ONL_fnc_extraction_init";

if (!isServer) exitWith {
    ["Needs to be executed on the server, remoting on server now...",true] call KISKA_fnc_log;
    remoteExec ["ONL_fnc_cave_caveIn",2];
    nil
};


ONL_skipLoopsAndEvents pushBack "ONL_extractionReady_skip";

[
    3,
    {
        call ONL_fnc_extractionMusic;

        ["Be advised, GoalPost is inbound for extract, ETA 10 minutes."] remoteExecCall ["KISKA_fnc_DatalinkMsg",ONL_allClientsTargetID];
        ["Enemy reinforcements are inbound to your position, hold out.",10] remoteExecCall ["KISKA_fnc_DatalinkMsg",ONL_allClientsTargetID];

        [
            {
                ["1 minute out"] remoteExec ["KISKA_fnc_DatalinkMsg",ONL_allClientsTargetID];

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
                [] spawn ONL_fnc_handleExtractionHeliAI;

                // play music when near completion logic and end misssion when even closer
                [
                    1,
                    {
                        ["extractionFinal"] call ONL_fnc_playMusicForScene;

                        [
                            1,
                            {
                                ["ONL_extract_task"] call KISKA_fnc_endTask;
                                sleep 1;
                                remoteExec ["ONL_fnc_endMission",0,true];
                            },
                            {CONDITION_PLAYER_WITHIN_RADIUS_2D(ONL_logic_extractionComplete,350)}
                        ] call KISKA_fnc_waitUntil;

                    },
                    {CONDITION_PLAYER_WITHIN_RADIUS_2D(ONL_extractHeli,500)}
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
                [] spawn {
                    call ONL_fnc_extraction_spawnVehicle;
                    sleep 3;
                    call ONL_fnc_extraction_spawnVehicle;
                    sleep 3;
                    call ONL_fnc_extraction_spawnGroup;
                    sleep 3;
                    call ONL_fnc_extraction_spawnGroup;
                    
                    if (count CBA_fnc_players >= 4) then {
                        sleep 3;
                        call ONL_fnc_extraction_spawnGroup;
                        sleep 3;
                        call ONL_fnc_extraction_spawnGroup;
                    };
                };
            },
            [],
            60
        ] call CBA_fnc_waitAndExecute;

        [
            {
                [] spawn {
                    call ONL_fnc_extraction_spawnVehicle;
                    sleep 3;
                    call ONL_fnc_extraction_spawnVehicle;
                    sleep 3;
                    call ONL_fnc_extraction_spawnGroup;
                    sleep 3;
                    call ONL_fnc_extraction_spawnGroup;


                    if (count CBA_fnc_players >= 4) then {
                        sleep 3;
                        call ONL_fnc_extraction_spawnGroup;
                        sleep 3;
                        call ONL_fnc_extraction_spawnGroup;
                    };
                };

                ["About 6 minutes out"] remoteExec ["KISKA_fnc_DatalinkMsg",ONL_allClientsTargetID];
            },
            [],
            (4.5*60)
        ] call CBA_fnc_waitAndExecute;

        [
            {
                [] spawn {
                    call ONL_fnc_extraction_spawnVehicle;
                    sleep 3;
                    call ONL_fnc_extraction_spawnVehicle;
                    sleep 3;
                    call ONL_fnc_extraction_spawnGroup;
                    sleep 3;
                    call ONL_fnc_extraction_spawnGroup;

                    if (count CBA_fnc_players >= 4) then {
                        sleep 3;
                        call ONL_fnc_extraction_spawnGroup;
                        sleep 3;
                        call ONL_fnc_extraction_spawnGroup;
                    };
                };

                ["3 minutes out"] remoteExec ["KISKA_fnc_DatalinkMsg",ONL_allClientsTargetID];
            },
            [],
            (7*60)
        ] call CBA_fnc_waitAndExecute;

    },
    {CONDITION_PLAYER_WITHIN_RADIUS_3D(ONL_logic_extraction,50)}
] call KISKA_fnc_waitUntil;
