if (!hasInterface) exitWith {};

if (!canSuspend) exitWith {
	"ONL_fnc_addplayerActions must be run in scheduled envrionment" call BIS_fnc_error;
};

params ["_player",player,[objNull]];

waitUntil {!isNull _player};

ONL_enterBunkerAction_ID = _player addAction [ 
	"--Enter Bunker",  
	{
		call ONL_fnc_enterCave;
	}, 
	nil, 
	10,  
	true,  
	false,  
	"", 
	"_target distance ONL_logic_cave_2 < 5 AND {isNull (objectParent _target)}", 
	2, 
	false 
];

// exit cave
ONL_exitBunkerAction_ID = _player addAction [ 
	"--Exit Bunker",  
	{		
		call ONL_fnc_exitCave; 
	}, 
	nil, 
	10,  
	true,  
	false,  
	"", 
	"_target distance ONL_logic_cave_1 < 5 AND {isNull (objectParent _target)}", 
	2, 
	false 
];


// removeActions when dead
_player addEventHandler ["Killed",{
	params ["_unit"];

	[ONL_enterBunkerAction_ID,ONL_exitBunkerAction_ID] apply {
		_unit removeAction _x;
		_x = nil;
	};

	_unit removeEventHandler ["Killed",_thisEventHandler];
}];