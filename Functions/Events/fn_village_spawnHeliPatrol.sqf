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

if (!canSuspend) then {
    [] spawn ONL_fnc_village_spawnHeliPatrol;
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
        _unit moveInTurret [_helicopter,[0]]; // copilot

    };
};

ONL_spetsnaz_heliInfantry_group = [8,ONL_spetsnazRegular_unitTypes,RESISTANCE] call KISKA_fnc_spawnGroup;

(units ONL_spetsnaz_heliInfantry_group) apply {
    _x moveInCargo _helicopter;
};

[ONL_spetsnaz_heliInfantry_group,ONL_gazLogic_2,100,4] call CBA_fnc_taskPatrol;
((waypoints ONL_spetsnaz_heliInfantry_group) select 0) setWaypointPosition [ONL_gazLogic_2,0];

[
    _helicopter,
    ONL_spetsnazHeliLand_logic,
    "GET OUT",
    true,
    {
        ONL_spetsnaz_heliInfantry_group enableDynamicSimulation true;
        ONL_spetsnaz_heliInfantry_group leaveVehicle (_this select 0);
        (units ONL_spetsnaz_heliInfantry_group) apply {
            moveOut _x;
            sleep 0.25;
        };
    }
] call KISKA_fnc_heliLand;

waitUntil {
    sleep 1;
    count (crew _helicopter) isEqualTo 2 // wait for pilots to be the only one left
};

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
