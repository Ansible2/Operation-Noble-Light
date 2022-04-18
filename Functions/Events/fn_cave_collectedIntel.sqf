/* ----------------------------------------------------------------------------
Function: ONL_fnc_cave_collectedIntel

Description:
    Acts as a server event when collecting intel in the cave

Parameters:
	0: _intelObject <OBJECT> - The collected intel object

Returns:
	NOTHING

Examples:
    (begin example)
		[intelObject] remoteExec ["ONL_fnc_cave_collectedIntel",2];
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "ONL_fnc_cave_collectedIntel";

#define SAVE_VAR_STR "ONL_collectedCaveIntel_skip"

if (missionNamespace getVariable [SAVE_VAR_STR,false]) exitWith {};
if (!isServer) exitWith {
    ["Needs to be executed on the server, remoting on server now...",true] call KISKA_fnc_log;
    _this remoteExec ["ONL_fnc_cave_collectedIntel",2];
    nil
};


params [
    ["_intelObject",objNull,[objNull]]
];

deleteVehicle _intelObject;

private _collectedIntelCount_plusOne = (missionNamespace getVariable ["ONL_cave_collectedIntel_count",0]) + 1;
if (_collectedIntelCount_plusOne isEqualTo ONL_cave_collectableIntel_count) then {
    ["ONL_CollectCaveIntel_Task"] call KISKA_fnc_endTask;

    ONL_skipLoopsAndEvents pushBack SAVE_VAR_STR;
    ////////////SaveGame/////////////
    call ONL_fnc_saveQuery;
    ////////////SaveGame/////////////

} else {
    ONL_cave_collectedIntel_count = _collectedIntelCount_plusOne;

};


nil
