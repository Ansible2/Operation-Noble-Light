/* ----------------------------------------------------------------------------
Function: ONL_fnc_blacksite_collectedIntel

Description:
    Acts as a server event when collecting intel at blacksite

Parameters:
	0: _intelObject <OBJECT> - The collected intel object

Returns:
	NOTHING

Examples:
    (begin example)
		[intelObject] remoteExec ["ONL_fnc_blacksite_collectedIntel",2];
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "ONL_fnc_blacksite_collectedIntel";

#define SAVE_VAR_STR "ONL_blackSite_CollectedIntelEvent_skip"

if (missionNamespace getVariable [SAVE_VAR_STR,false]) exitWith {};
if (!isServer) exitWith {
    ["Needs to be executed on the server, remoting on server now...",true] call KISKA_fnc_log;
    _this remoteExec ["ONL_fnc_blacksite_collectedIntel",2];
    nil
};


params [
    ["_intelObject",objNull,[objNull]]
];

deleteVehicle _intelObject;

private _collectedIntelCount_plusOne = (missionNamespace getVariable ["ONL_blackSite_collectedIntel_count",0]) + 1;
if (_collectedIntelCount_plusOne isEqualTo ONL_blackSite_collectableIntel_count) then {
    ["ONL_collectBlackSiteIntel_task"] call KISKA_fnc_endTask;
    [CollectBlackSiteIntel_TaskID,"CollectBlackSiteIntel_TaskInfo"] call Kiska_fnc_setTaskComplete;

    ONL_skipLoopsAndEvents pushBack SAVE_VAR_STR;
    ////////////SaveGame/////////////
    call ONL_fnc_saveQuery;
    ////////////SaveGame/////////////

} else {
    ONL_blackSite_collectedIntel_count = _collectedIntelCount_plusOne;

};
