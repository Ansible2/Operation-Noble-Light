params [
	"_newUnit"
];

_newUnit setUnitLoadout ONL_playerLoadout;

_newunit setCustomAimCoef 0.75;

// set envrionmental and view distance if player respawns in or out of cave accordingly
[
	{
		params [
			"_newUnit"
		];

		// make sure awful engine noise on c17 can't be heard if they respawn in it
		if (((getPosATLVisual _newUnit) distance ONL_logic_jumpPosition) < 20) exitWith {
			2 fadeSound 0.1;
		};

		// if people are in the extraction helicopter, move the person into it cuz we. are. leaving.
		if !(((call CBA_fnc_players) findIf {(objectParent _x) isEqualTo ONL_extractHeli}) isEqualTo -1) then {
			_newUnit moveInCargo ONL_extractHeli;
		};

		// make sure environmental sounds and view distance are correct if inside the cave
		if (((getPosATLVisual _newUnit) distance2D ONL_logic_cave_1) < 1200) then {
			if !(environmentEnabled isEqualTo [false,false]) then {
				enableEnvironment [false,false];
			};

			setObjectViewDistance 200;
			setViewDistance 200;
		} else {
			if !(environmentEnabled isEqualTo [true,true]) then {
				enableEnvironment [true,true];
			};
			
			setObjectViewDistance -1;
			setViewDistance -1;

			if (viewDistance > 1700) then {
				setViewDistance 1700;
			};

			if ((getObjectViewDistance select 0) > 1500) then {
				setObjectViewDistance 1500;
			};
		};

	},
	[_newUnit],
	2
] call CBA_fnc_waitAndExecute;