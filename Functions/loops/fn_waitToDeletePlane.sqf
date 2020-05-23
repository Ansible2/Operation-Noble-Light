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