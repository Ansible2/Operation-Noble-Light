/* ----------------------------------------------------------------------------
Function: ONL_fnc_base_readFile

Description:
    Acts as an event when a player reads the file located at the large military base.

Parameters:
	0: _file <OBJECT> - The read file object

Returns:
	NOTHING

Examples:
    (begin example)
		[file] remoteExec ["ONL_fnc_base_readFile",2];
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "ONL_fnc_base_readFile";

#define SAVE_VAR_STR "ONL_baseFileRead_skip"

if (missionNamespace getVariable [SAVE_VAR_STR,false]) exitWith {};

if (!isServer) exitWith {
    ["Needs to be executed on the server, remoting on server now...",true] call KISKA_fnc_log;
    _this remoteExec ["ONL_fnc_base_readFile",2];
    nil
};

params [
    ["_file",objNull,[objNull]]
];

deleteVehicle _file;

["ONL_CollectBaseIntel_task"] call KISKA_fnc_endTask;
["ONL_SearchLodging_task"] call KISKA_fnc_createTaskFromConfig;


ONL_skipLoopsAndEvents pushBack SAVE_VAR_STR;
////////////SaveGame/////////////
call ONL_fnc_saveQuery;
////////////SaveGame/////////////


nil
