if (!hasInterface) exitWith {};


["ONL_Cave_entered_Event"] call CBA_fnc_serverEvent;
		
titleText ["<t font='PuristaSemibold' align='center' size='5'>Now Entering...</t>", "BLACK OUT", 3, true, true];

3 fadeSound 0;

player allowDamage false;

playSound "garage_doors";

[
	{
		if !(environmentEnabled isEqualTo [false,false]) then {
			enableEnvironment [false,false];
		};

		setObjectViewDistance 200;
		setViewDistance 200;
		player setPosATL (getPosATL ONL_logic_cave_1);
		player setDir 306;

		3 fadeSound 1;
	},
	[],
	3
] call CBA_fnc_waitAndExecute; 

[
	{
		player allowDamage true;
		titleText ["<t font='PuristaSemibold' align='center' size='5'>Now Entering...</t>", "BLACK IN", 3, true, true];
	},
	[],
	6
] call CBA_fnc_waitAndExecute; 