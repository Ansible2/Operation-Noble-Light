	// entry
	[4,2,ONL_CSATViper_unitTypes,ONL_cave_entryWayPositions,true] call KISKA_fnc_spawn;
	

	uiSleep 1;
	

	// garage
	[3,3,ONL_CSATViper_unitTypes,ONL_cave_garagePositions,true] call KISKA_fnc_spawn;
	
	
	uiSleep 1;
	
	
	// left Path 1
	[3,1,ONL_CSATViper_unitTypes,ONL_cave_leftPath_positions_1,true] call KISKA_fnc_spawn;
	
	
	uiSleep 1;
	
	
	// left Path 2
	[3,1,ONL_CSATViper_unitTypes,ONL_cave_leftPath_positions_2,true] call KISKA_fnc_spawn;
	
	
	uiSleep 1;
	
	
	// living area
	[4,2,ONL_CSATViper_unitTypes,ONL_cave_livingArea_positions,true] call KISKA_fnc_spawn;
	
	
	uiSleep 1;
	
	
	// office area
	[4,2,ONL_CSATViper_unitTypes,ONL_cave_officeArea_positions,true] call KISKA_fnc_spawn;
	
	
	uiSleep 1;
	
	
	// right Path 1
	[3,1,ONL_CSATViper_unitTypes,ONL_cave_rightPath_positions_1,true] call KISKA_fnc_spawn;
	
	
	uiSleep 1;
	
	
	// right Path 2
	[3,1,ONL_CSATViper_unitTypes,ONL_cave_rightPath_positions_2,true] call KISKA_fnc_spawn;
	
	
	uiSleep 1;

	
	[4,4,ONL_CSATViper_unitTypes,ONL_cave_center_positions_1,true] call KISKA_fnc_spawn;
	private _units = [5,4,ONL_CSATViper_unitTypes,ONL_cave_center_positions_2,true] call KISKA_fnc_spawn;
	(_units select 4) moveInTurret [ONL_caveMarid,[0]];
	
	
	uiSleep 1;
	
	
	[4,4,ONL_CSATViper_unitTypes,ONL_cave_center_positions_3,true] call KISKA_fnc_spawn;
	
	
	uiSleep 1;
	
	
	[4,4,ONL_CSATViper_unitTypes,ONL_cave_center_positions_4,true] call KISKA_fnc_spawn;


	["Dark Area spawns are complete"] remoteExec ["hint",[0,-2] select isDedicated];