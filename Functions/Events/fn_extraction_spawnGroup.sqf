/* ----------------------------------------------------------------------------
Function: ONL_fnc_extraction_spawnGroup

Description:
    Spawns a random group of infantry during extraction phase to attack players.

Parameters:
	NONE

Returns:
	Nothing

Examples:
    (begin example)
		call ONL_fnc_extraction_spawnGroup;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "ONL_fnc_extraction_spawnGroup";

if (!isServer) exitWith {
    ["Needs to be executed on the server, remoting on server now...",true] call KISKA_fnc_log;
    remoteExec ["ONL_fnc_extraction_spawnGroup",2];
    nil
};


private _group = [6,ONL_CSATVariants,opfor,selectRandom [ONL_logic_extraction_spawn_2,ONL_logic_extraction_spawn_3]] call KISKA_fnc_spawnGroup;
_group setVariable ["ONL_saveExcluded",true];

private _waypoint = _group addWaypoint [ONL_logic_extraction,100];
_waypoint setWaypointType "SAD";


nil
