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

	if (_i isEqualTo 1) then {
		_group setVariable ["ONL_loadCreationCode",{
			params ["_group"];
			ONL_villagePatrol_1 = _group;
			[_group] call CBA_fnc_clearWaypoints;
			private _randomPosition = [ONL_logic_village,500] call CBA_fnc_randPos;
			[_group,_randomPosition,500,5,"MOVE","AWARE","YELLOW","LIMITED","STAG COLUMN"] call CBA_fnc_taskPatrol;
		}];
	} else {
		_group setVariable ["ONL_loadCreationCode",{
			params ["_group"];
			ONL_villagePatrol_2 = _group;
			[_group] call CBA_fnc_clearWaypoints;
			private _randomPosition = [ONL_logic_village,500] call CBA_fnc_randPos;
			[_group,_randomPosition,500,5,"MOVE","AWARE","YELLOW","LIMITED","STAG COLUMN"] call CBA_fnc_taskPatrol;
		}];
	};
};


/// need to find the reference for this
ONL_villagePatrols = [ONL_villagePatrol_1,ONL_villagePatrol_2];