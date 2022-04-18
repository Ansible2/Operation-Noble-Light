/* ----------------------------------------------------------------------------
Function: ONL_fnc_blackSiteArty

Description:
	Calls an artillery strike onto the Black Site. The artillery pieces are those located at the base.
	Strike will only happen if they are alive.
	Executed from loop inside ONL_fnc_startServerLoops.

Parameters:
	NONE

Returns:
	Nothing

Examples:
    (begin example)

		[] spawn ONL_fnc_blackSiteArty;

    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
#define FIRE_AT_ROCK(unitToFire) [unitToFire,ONL_glowingRock,8,150,360,12] spawn KISKA_fnc_arty

if (!canSuspend) exitWith {};

if (!isServer) exitWith {};

if (alive ONL_arty_1) then {
	group (driver ONL_arty_1) enableDynamicSimulation false;
	ONL_arty_1 enableDynamicSimulation false;

	if !(simulationEnabled ONL_arty_1) then {
		ONL_arty_1 enableSimulationGlobal true;
	};

	FIRE_AT_ROCK(ONL_arty_1);
};

if (alive ONL_arty_2) then {
	group (driver ONL_arty_2) enableDynamicSimulation false;
	ONL_arty_2 enableDynamicSimulation false;

	if !(simulationEnabled ONL_arty_2) then {
		ONL_arty_2 enableSimulationGlobal true;
	};

	FIRE_AT_ROCK(ONL_arty_2);
};

sleep 100;

["ONL_DestroyBaseArty_task"] call KISKA_fnc_createTaskFromConfig;

if (alive ONL_arty_1) then {
	group (driver ONL_arty_1) enableDynamicSimulation false;
	ONL_arty_1 enableDynamicSimulation true;
};
if (alive ONL_arty_2) then {
	group (driver ONL_arty_2) enableDynamicSimulation false;
	ONL_arty_2 enableDynamicSimulation true;
};
