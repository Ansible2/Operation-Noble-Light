if !(isServer) exitWith {};

// Black Site Server Destruction
private _blackSiteServers = (getMissionLayerEntities "Black Site Servers") select 0;
ONL_blackSite_destroyableServers_count = count _blackSiteServers;

_blackSiteServers apply {
	_x addEventHandler ["Killed", {
		private _destroyedServersCount_plusOne = (missionNamespace getVariable ["ONL_blackSite_destroyedServers_count",0]) + 1;

		if (_destroyedServersCount_plusOne isEqualTo ONL_blackSite_destroyableServers_count) then {
			[DestroyBlackSiteServers_TaskID,"DestroyBlackSiteServers_TaskInfo"] call Kiska_fnc_setTaskComplete;
		} else {
			ONL_blackSite_destroyedServers_count = _destroyedServersCount_plusOne;
		};	
	}];
};


// Collect BlackSite intel
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
			ONL_blackSite_CollectedIntel_Event_ID call CBA_fnc_removeEventHandler;
		} else {
			ONL_blackSite_collectedIntel_count = _collectedIntelCount_plusOne;
		};
	}
] call CBA_fnc_addEventHandler;
ONL_blackSite_CollectedIntel_Event_ID = ["ONL_blackSite_CollectedIntel_Event",_id];

// complete investigate task
[
	3,
	{
		[InvestigateBlackSite_TaskID, "SUCCEEDED", true] call BIS_fnc_taskSetState;
	},
	{[CollectBlackSiteIntel_TaskID select 0] call BIS_fnc_taskCompleted AND {[CollectRockSample_TaskID select 0] call BIS_fnc_taskCompleted} AND {[DestroyBlackSiteServers_TaskID select 0] call BIS_fnc_taskCompleted}}
] call KISKA_fnc_waitUntil;