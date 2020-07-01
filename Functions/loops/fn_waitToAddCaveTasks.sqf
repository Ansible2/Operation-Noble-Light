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
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
if (!isServer) exitWith {};

if !([CollectDeviceLogs_TaskID select 0] call BIS_fnc_taskExists) then {
    [
        1,
        {		
            [true,CollectDeviceLogs_TaskID,"CollectDeviceLogs_TaskInfo",objNull,"AUTOASSIGNED",5,true,"INTERACT",false] call BIS_fnc_taskCreate;            
            [true,DestroyTheDevices_TaskID,"DestroyTheDevices_TaskInfo",objNull,"AUTOASSIGNED",5,true,"DESTROY",false] call BIS_fnc_taskCreate;
        },
        {!(((call CBA_fnc_players) findIf {(_x distance ONL_deviceAss) < 5}) isEqualTo -1) OR {!(((call CBA_fnc_players) findIf {(_x distance ONL_deviceDiss) < 5}) isEqualTo -1)}}
    ] call KISKA_fnc_waitUntil;
};

// destroy servers/collect data
if !([DestroyCaveServers_TaskID select 0] call BIS_fnc_taskExists) then {
    [
        1,
        {		
            [true,DestroyCaveServers_TaskID,"DestroyCaveServers_TaskInfo",ONL_caveServer_1,"AUTOASSIGNED",5,true,"DESTROY",false] call BIS_fnc_taskCreate;            
            [true,CollectCaveData_TaskID,"CollectCaveData_TaskInfo",objNull,"AUTOASSIGNED",5,true,"INTERACT",false] call BIS_fnc_taskCreate;
        },
        {!(((call CBA_fnc_players) findIf {(_x distance ONL_caveServer_1) < 5}) isEqualTo -1)}
    ] call KISKA_fnc_waitUntil;
};

// complete investigate task
if !([InvestigateFacility_TaskID] call BIS_fnc_taskExists) then {
    [
        3,
        {
            [InvestigateFacility_TaskID] call Kiska_fnc_setTaskComplete;
        },
        {[CollectCaveData_TaskID select 0] call BIS_fnc_taskCompleted AND {[CollectDeviceLogs_TaskID select 0] call BIS_fnc_taskCompleted} AND {[DestroyCaveServers_TaskID select 0] call BIS_fnc_taskCompleted} AND {[DestroyTheDevices_TaskID select 0] call BIS_fnc_taskCompleted}}
    ] call KISKA_fnc_waitUntil;
};