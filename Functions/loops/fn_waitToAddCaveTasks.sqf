[
    1,
    {		
        [true, CollectDeviceLogs_TaskID,"CollectDeviceLogs_TaskInfo",objNull,"AUTOASSIGNED",5,true,"INTERACT",false] call BIS_fnc_taskCreate;            
		[true, DestroyTheDevices_TaskID,"DestroyTheDevices_TaskInfo",objNull,"AUTOASSIGNED",5,true,"DESTROY",false] call BIS_fnc_taskCreate;
    },
    {!(((call CBA_fnc_players) findIf {(_x distance ONL_deviceAss) < 5}) isEqualTo -1) OR {!(((call CBA_fnc_players) findIf {(_x distance ONL_deviceDiss) < 5}) isEqualTo -1)}}
] call KISKA_fnc_waitUntil;

// destroy servers/collect data
[
    1,
    {		
        [true, DestroyCaveServers_TaskID,"DestroyCaveServers_TaskInfo",caveServer1,"AUTOASSIGNED",5,true,"DESTROY",false] call BIS_fnc_taskCreate;            
		[true, CollectCaveData_TaskID,"CollectCaveData_TaskInfo",objNull,"AUTOASSIGNED",5,true,"INTERACT",false] call BIS_fnc_taskCreate;
    },
    {!(((call CBA_fnc_players) findIf {(_x distance ONL_caveServer_1) < 5}) isEqualTo -1)}
] call KISKA_fnc_waitUntil;

// complete investigate task
[
	3,
	{
		[InvestigateFacility_TaskID] call Kiska_fnc_setTaskComplete;
	},
	{[CollectCaveData_TaskID select 0] call BIS_fnc_taskCompleted AND {[CollectDeviceLogs_TaskID select 0] call BIS_fnc_taskCompleted} AND {[DestroyCaveServers_TaskID select 0] call BIS_fnc_taskCompleted} AND {[DestroyTheDevices_TaskID select 0] call BIS_fnc_taskCompleted}}
] call KISKA_fnc_waitUntil;