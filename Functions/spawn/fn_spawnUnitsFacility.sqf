if (!isServer) exitWith {};

// Interior
[4,1,ONL_CSATVariants,ONL_facility_interiorPositions] call KISKA_fnc_spawn;

// Exterior
[4,1,ONL_CSATVariants,ONL_facility_exteriorPositions,true] call KISKA_fnc_spawn;
	
// patrol 1
private _randomPosition = [ONL_logic_facility,300] call CBA_fnc_randPos;
private _patrol1 = [3,ONL_pmc_Variants,opfor,_randomPosition] call KISKA_fnc_spawnGroup;
[_patrol1,ONL_logic_facility,300,5,"MOVE","AWARE","RED","LIMITED","STAG COLUMN"] call CBA_fnc_taskPatrol;

_patrol1 setVariable ["ONL_loadCreationCode",{
	params ["_group"];
	[_group] call CBA_fnc_clearWaypoints;
	[_group,ONL_logic_facility,300,5,"MOVE","AWARE","RED","LIMITED","STAG COLUMN"] call CBA_fnc_taskPatrol;
}];

// patrol 2
private _randomPosition = [ONL_logic_facility,300] call CBA_fnc_randPos;
private _patrol2 = [3,ONL_pmc_Variants,opfor,_randomPosition] call KISKA_fnc_spawnGroup;
[_patrol2,ONL_logic_facility,300,5,"MOVE","AWARE","RED","LMITED","STAG COLUMN"] call CBA_fnc_taskPatrol;

_patrol2 setVariable ["ONL_loadCreationCode",{
	params ["_group"];
	[_group] call CBA_fnc_clearWaypoints;
	[_group,ONL_logic_facility,300,5,"MOVE","AWARE","RED","LMITED","STAG COLUMN"] call CBA_fnc_taskPatrol;
}];


if !(ONL_CUPUnitsLoaded) then {
	ONL_PMCUnits append (units _patrol1);
	ONL_PMCUnits append (units _patrol2);
};