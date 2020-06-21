if (!isServer) exitWith {};

[count ONL_village_positions_group1,1,ONL_spetsnazSFVariants,ONL_village_positions_group1,true,true,resistance] call KISKA_fnc_spawn;
	
uiSleep 1;

[count ONL_village_positions_group2,3,ONL_spetsnazSFVariants,ONL_village_positions_group2,false,true,resistance] call KISKA_fnc_spawn;

uiSleep 1;

private _animatedUnits = [count ONL_village_positions_group3,3,ONL_spetsnazSFVariants,ONL_village_positions_group3,false,true,resistance] call KISKA_fnc_spawn;

_animatedUnits apply {
	[_x] call BIS_fnc_ambientAnimCombat;
};

uiSleep 1;

// village patrols
for "_i" from 1 to 2 do {
	private _randomPosition = [ONL_logic_village,500] call CBA_fnc_randPos;

	private _group = [6,ONL_spetsnazRegular_unitTypes,resistance,_randomPosition] call KISKA_fnc_spawnGroup;
	
	uiSleep 1;
	
	missionNamespace setVariable ["ONL_villagePatrol_" + (str _i),_group];

	[_group,_randomPosition,500,5,"MOVE","AWARE","YELLOW","LIMITED","STAG COLUMN"] call CBA_fnc_taskPatrol;
};

ONL_villagePatrols = [ONL_villagePatrol_1,ONL_villagePatrol_2];