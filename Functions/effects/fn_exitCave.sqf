/* ----------------------------------------------------------------------------
Function: ONL_fnc_exitCave

Description:
	Executes from "--Exit Bunker" action which is added in "ONL_fnc_addPlayerActions"

Parameters:
	NONE

Returns:
	Nothing

Examples:
    (begin example)

		call ONL_fnc_exitCave;

    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
if (!hasInterface) exitWith {};

titleText ["<t font='PuristaSemibold' align='center' size='5'>Now Exiting...</t>", "BLACK OUT", 3, true, true];

3 fadeSound 0;

player allowDamage false;

playSound "garage_doors";

[
	{
		player setPosATL (getPosATL ONL_logic_cave_2);
		player setDir 88; 

		setViewDistance -1;
		setObjectViewDistance -1;

		if (viewDistance > 1700) then {
			setViewDistance 1700;
		};

		if ((getObjectViewDistance select 0) > 1500) then {
			setObjectViewDistance 1500;
		};

		if !(environmentEnabled isEqualTo [true,true]) then {
			enableEnvironment [true,true];
		};

		3 fadeSound 1;
	},
	[],
	3
] call CBA_fnc_waitAndExecute; 

[
	{
		player allowDamage true;
		titleText ["<t font='PuristaSemibold' align='center' size='5'>Now Exiting...</t>", "BLACK IN", 3, true, true];
	},
	[],
	6
] call CBA_fnc_waitAndExecute; 