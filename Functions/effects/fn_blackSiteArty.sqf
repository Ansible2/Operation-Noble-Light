if !(canSuspend) exitWith {false};

if (alive ONL_arty_1) then {
	group (driver ONL_arty_1) enableDynamicSimulation false;
	ONL_arty_1 enableDynamicSimulation false;

	if !(simulationEnabled ONL_arty_1) then {
		ONL_arty_1 enableSimulationGlobal true;
	};

	null = [ONL_arty_1,ONL_glowingRock,4,200,300,[9,10,11]] spawn KISKA_fnc_arty;
};

if (alive ONL_arty_2) then {
	group (driver ONL_arty_2) enableDynamicSimulation false;
	ONL_arty_2 enableDynamicSimulation false;

	if !(simulationEnabled ONL_arty_2) then {
		ONL_arty_2 enableSimulationGlobal true;
	};

	null = [ONL_arty_2,ONL_glowingRock,4,200,300,[9,10,11]] spawn KISKA_fnc_arty;
};

sleep 100;

if !([DestroyArty_taskID] call BIS_fnc_taskExists) then {
	[true,DestroyArty_taskID,"DestroyArty_taskInfo",objNull,"AUTOASSIGNED",5,true,"DESTROY",false] call BIS_fnc_taskCreate;
};

if (alive ONL_arty_1) then {
	group (driver ONL_arty_1) enableDynamicSimulation false;
	ONL_arty_1 enableDynamicSimulation true;
};
if (alive ONL_arty_2) then {
	group (driver ONL_arty_2) enableDynamicSimulation false;
	ONL_arty_2 enableDynamicSimulation true;
};