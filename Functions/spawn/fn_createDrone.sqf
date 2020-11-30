/* ----------------------------------------------------------------------------
Function: ONL_fnc_createDrone

Description:
	Creates the UAV predator for the players
	
	It is executed from "ONL_fnc_waitToDeletePlane".

Parameters:
	NONE

Returns:
	Nothing

Examples:
    (begin example)

		call ONL_fnc_createDrone;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
if (!isServer) exitWith {};

ONL_drone = ([[18728,14207.7,1137.77], 180, "USAF_MQ9", west] call BIS_fnc_spawnVehicle) select 0;

{
    ONL_drone setPylonLoadout [_forEachIndex + 1, _x, false, [0]];
} forEach ["USAF_PylonRack_4Rnd_GBU53","","USAF_PylonRack_4Rnd_GBU39",""];

//["USAF_PylonRack_4Rnd_GBU53","USAF_PylonRack_4Rnd_GBU39","USAF_PylonRack_4Rnd_GBU39","USAF_PylonRack_4Rnd_GBU53"];

["USAF_AGM114P_Launcher","USAF_GBU12_Launcher"] apply {
    ONL_drone removeWeaponTurret [_x,[0]]
};

// make drone easy to use
ONL_drone setCaptive true;
ONL_drone allowDamage false;

// set initial waypoint
private _waypoint0 = (group ONL_drone) addWaypoint [getPosATL ONL_loiterLogic, 10];
_waypoint0 setWaypointType "LOITER";
_waypoint0 setWaypointLoiterType "CIRCLE";
_waypoint0 setWaypointCombatMode "BLUE";
_waypoint0 setWaypointLoiterRadius 800;

ONL_drone flyInHeight 500; 

// ensure ease of use if drone changes locality
[
    ONL_drone,
    ["Local", {
            params ["_drone", "_isLocal"];

            if (_isLocal) then {
                _drone setCaptive true;
                _drone allowDamage false;
            };
        }
    ]
] remoteExec ["addEventHandler",0,true];

// inform players drone is airborne
["Be advised, 1x Reaper callsign WildFire is entering the AO"] remoteExecCall ["KISKA_fnc_DatalinkMsg",ONL_allClientsTargetID];

["Armament: 8x GBU",4,false] remoteExecCall ["KISKA_fnc_DatalinkMsg",ONL_allClientsTargetID];

// exclude from Saves
ONL_drone setVariable ["ONL_saveExcluded",true];