#include "..\..\Headers\Common Defines.hpp"
/* ----------------------------------------------------------------------------
Function: ONL_fnc_waitToAddCaveTasks

Description:
	Starts several loops that search for a near player before adding some tasks inside the cave.

    Executed from the server event "ONL_Cave_entered_Event" which is located inside "ONL_fnc_addServerEvents"

Parameters:
	NONE

Returns:
	Nothing

Examples:
    (begin example)
		call ONL_fnc_waitToAddCaveTasks;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
if (!isServer) exitWith {};

if !(["ONL_CollectDeviceLogs_Task"] call BIS_fnc_taskExists) then {
    [
        1,
        {
            ["ONL_DestroyTheDevices_task"] call KISKA_fnc_createTaskFromConfig;
            ["ONL_CollectDeviceLogs_Task"] call KISKA_fnc_createTaskFromConfig;
        },
        {(CONDITION_PLAYER_WITHIN_RADIUS_3D(ONL_deviceAss,5)) OR {CONDITION_PLAYER_WITHIN_RADIUS_3D(ONL_deviceDiss,5)}}
    ] call KISKA_fnc_waitUntil;
};

// destroy servers/collect data
if !(["ONL_DestroyCaveServers_Task"] call BIS_fnc_taskExists) then {
    [
        1,
        {
            ["ONL_DestroyCaveServers_Task"] call KISKA_fnc_createTaskFromConfig;
            ["ONL_CollectCaveIntel_Task"] call KISKA_fnc_createTaskFromConfig;
        },
        {CONDITION_PLAYER_WITHIN_RADIUS_3D(ONL_caveServer_1,5)}
    ] call KISKA_fnc_waitUntil;
};

// complete investigate task
if !(["ONL_InvestigateFacility_task"] call BIS_fnc_taskExists) then {
    [
        3,
        {
            ["ONL_InvestigateFacility_task"] call KISKA_fnc_endTask;
        },
        {
            ["ONL_CollectCaveIntel_Task"] call BIS_fnc_taskCompleted AND
            {["ONL_CollectDeviceLogs_Task"] call BIS_fnc_taskCompleted} AND
            {["ONL_DestroyCaveServers_Task"] call BIS_fnc_taskCompleted} AND
            {["ONL_DestroyTheDevices_task"] call BIS_fnc_taskCompleted}
        }
    ] call KISKA_fnc_waitUntil;
};
