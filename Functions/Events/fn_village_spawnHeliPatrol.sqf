/* ----------------------------------------------------------------------------
Function: ONL_fnc_village_spawnHeliPatrol

Description:
    Acts as a server event when a heli patrol spawns and lands at the village.

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)
		remoteExec ["ONL_fnc_village_spawnHeliPatrol",2];
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "ONL_fnc_village_spawnHeliPatrol";

if (!isServer) exitWith {
    ["Needs to be executed on the server, remoting on server now...",true] call KISKA_fnc_log;
    remoteExec ["ONL_fnc_village_spawnHeliPatrol",2];
    nil
};


private _helicopter = createVehicle [ONL_spetsnaz_helicopter,getPosATL ONL_spetsnazHeliSpawn_logic,[],0,"FLY"];
_helicopter setDir 307;

private _pilotsGroup = createGroup RESISTANCE;
for "_i" from 1 to 2 do {
    private _unit = _pilotsGroup createUnit [ONL_spetsnaz_crewman,[0,0,0],[],0,"NONE"];
    [_unit] joinSilent _pilotsGroup;

    if (_i isEqualTo 1) then {
        _unit moveInDriver _helicopter;
    } else {
        _unit moveInTurret [_helicopter,[0]];
    };
};

private _group = [8,ONL_spetsnazRegular_unitTypes,RESISTANCE] call KISKA_fnc_spawnGroup;

(units _group) apply {
    _x moveInCargo _helicopter;
};

[_group,ONL_gazLogic_2,100,4] call CBA_fnc_taskPatrol;
((waypoints _group) select 0) setWaypointPosition [ONL_gazLogic_2,0];
[_pilotsGroup,ONL_spetsnazHeliSpawn_logic,0,"MOVE","SAFE","BLUE","FULL"] call CBA_fnc_addwaypoint;

// use kISKA_fnc_land
[_pilotsGroup,ONL_spetsnazHeliLand_logic,0,"TR UNLOAD","SAFE","BLUE","NORMAL"] call CBA_fnc_addwaypoint;

[
    _pilotsGroup,
    ONL_spetsnazHeliSpawn_logic,
    0,
    "MOVE",
    "SAFE",
    "BLUE",
    "FULL",
    "NO CHANGE",
    "
        private _aircraft = objectParent this;
        thisList apply {
            _aircraft deleteVehicleCrew _x;
        };
        deleteVehicle _aircraft;
    ",
    [0,0,0],
    50
] call CBA_fnc_addwaypoint;


nil
