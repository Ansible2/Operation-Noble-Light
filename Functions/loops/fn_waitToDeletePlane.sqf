/* ----------------------------------------------------------------------------
Function: ONL_fnc_waitToDeletePlane

Description:
	Waits until all players are outside of the drop plane before deleting it.

    Executed from cargo plane takeoff loop which is located inside "ONL_fnc_startServerLoops"

Parameters:
	NONE

Returns:
	Nothing

Examples:
    (begin example)

		call ONL_fnc_waitToDeletePlane;

    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
if !(isServer) exitWith {};

[
    5,
    {
   
        [
            {
                (crew ONL_cargoPlane) apply {
					if (alive _x) then {
						deleteVehicle _x;
					};
				};

				deleteVehicle ONL_cargoPlane;

                call ONL_fnc_createDrone;
            },
            [],
            10
        ] call CBA_fnc_waitAndExecute;				

        [missionNamespace,ONL_cargoPlaneRespawn select 1] call BIS_fnc_removeRespawnPosition;             
    },
    {((call CBA_fnc_players) findIf {(_x distance ONL_cargoPlane) < 500}) isEqualTo -1}
] call KISKA_fnc_waitUntil;