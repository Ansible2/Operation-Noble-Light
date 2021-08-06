/* ----------------------------------------------------------------------------
Function: ONL_fnc_extraction_spawnVehicle

Description:
    Spawns a random vehicle during extraction phase to attack players.

Parameters:
	NONE

Returns:
	Nothing

Examples:
    (begin example)
		call ONL_fnc_extraction_spawnVehicle;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "ONL_fnc_extraction_spawnVehicle";

if (!isServer) exitWith {
    ["Needs to be executed on the server, remoting on server now...",true] call KISKA_fnc_log;
    remoteExec ["ONL_fnc_extraction_spawnVehicle",2];
    nil
};


private _type = selectRandomWeighted ONL_CSATVehicleVariants;
private _vehicle = createVehicle [_type,selectRandom [ONL_logic_extraction_spawn_1,ONL_logic_extraction_spawn_2,ONL_logic_extraction_spawn_3],[],20,"NONE"];
_vehicle setVariable ["ONL_saveExcluded",true];

private _group = createVehicleCrew _vehicle;
_group setVariable ["ONL_saveExcluded",true];

private _waypoint = _group addWaypoint [ONL_logic_extraction,250];
_waypoint setWaypointType "SAD";


nil
