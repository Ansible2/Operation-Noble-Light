/* ----------------------------------------------------------------------------
Function: ONL_fnc_village_spawnReinforcements

Description:
    Acts as a server event when reinforcements spawn at the village.

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)
		remoteExec ["ONL_fnc_village_spawnReinforcements",2];
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "ONL_fnc_village_spawnReinforcements";

if (!isServer) exitWith {
    ["Needs to be executed on the server, remoting on server now...",true] call KISKA_fnc_log;
    remoteExec ["ONL_fnc_village_spawnReinforcements",2];
    nil
};


// create apc
private _group1 = createGroup resistance;
for "_i" from 1 to 3 do {
    _group1 createUnit [ONL_spetsnaz_crewman,[0,0,0],[],0,"NONE"];
};

private _apc = createVehicle [ONL_spetsnaz_apc,[7028.84,12029,0]];
_apc setDir 102;
if !(ONL_FSGLoaded) then {
    [
        _apc,
        ["Guerilla_03",1],
        ["showCamonetHull",1,"showBags",1,"showBags2",1,"showTools",0,"showSLATHull",0]
    ] call BIS_fnc_initVehicle;
};

{
    [_x moveInTurret [_apc,[[0,0],[1]] select ONL_FSGLoaded],_x moveInDriver _apc,_x moveInGunner _apc] select _forEachIndex;
} forEach (units _group1);
(units _group1) joinSilent _group1;


// Create car
private _group2 = createGroup resistance;
for "_i" from 1 to 2 do {
    _group2 createUnit [ONL_spetsnaz_crewman,[0,0,0],[],0,"NONE"];
};

private _car = createVehicle [ONL_spetsnaz_carArmed,ONL_logic_village_reinforcements];
[
    _car,
    ["Green",1],
    ["Hide_Shield",1,"Hide_Rail",0,"HideDoor1",0,"HideDoor2",0,"HideDoor3",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0]
] call BIS_fnc_initVehicle;

{
    [_x moveInDriver _car,_x moveInGunner _car] select _forEachIndex;
} forEach (units _group2);
(units _group2) joinSilent _group2;


[_group1,_group2] apply {
    _x deleteGroupWhenEmpty true;
    _x setCombatMode "red";
    private _waypoint = _x addWaypoint [ONL_logic_village,200];
    _waypoint setWaypointType "MOVE";
};


nil
