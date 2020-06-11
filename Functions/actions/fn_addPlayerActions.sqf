if !(hasInterface) exitWith {};

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
player addEventHandler ["KILLED",{
	params ["_unit"];

	[ONL_enterBunkerAction_ID,ONL_exitBunkerAction_ID] apply {
		_unit removeAction _x;
	};
}];