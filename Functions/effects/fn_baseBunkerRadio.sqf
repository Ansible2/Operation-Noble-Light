[
	1,
	{
		[ONL_logic_bunkerRadio,35] spawn KISKA_fnc_radioChatter;
		
		[
			2,
			{
				deleteVehicle ONL_logic_bunkerRadio;
			},
			{!(((call CBA_fnc_players) findIf {(_x distance2D ONL_logic_bunkerRadio) > 50}) isEqualTo -1)}
		] call KISKA_fnc_waitUntil;
	},
	{!(((call CBA_fnc_players) findIf {(_x distance2D ONL_logic_bunkerRadio) < 50}) isEqualTo -1)}
] call KISKA_fnc_waitUntil;