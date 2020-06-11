if !(hasInterface) exitWith {};

hint "added actions";

waitUntil {player isEqualTo player};

ONL_enterBunkerAction_ID = player addAction [ 
	"--Enter Bunker",  
	{
		call ONL_fnc_enterCave;
	}, 
	nil, 
	10,  
	true,  
	false,  
	"", 
	"player distance ONL_logic_cave_2 < 5 AND {isNull (objectParent player)}", 
	2, 
	false 
];

// exit cave
ONL_exitBunkerAction_ID = player addAction [ 
	"--Exit Bunker",  
	{		
		call ONL_fnc_exitCave; 
	}, 
	nil, 
	10,  
	true,  
	false,  
	"", 
	"player distance ONL_logic_cave_1 < 5 AND {isNull (objectParent player)}", 
	2, 
	false 
];


// removeActions when dead
player addEventHandler ["Killed",{
	params ["_unit"];

	[ONL_enterBunkerAction_ID,ONL_exitBunkerAction_ID] apply {
		_corpse removeAction _x;
		_x = nil;
	};

	_unit removeEventHandler ["Killed",_thisEventHandler];

	ONL_defusalKilled_EH_added = false;
}];

ONL_defusalKilled_EH_added = true;