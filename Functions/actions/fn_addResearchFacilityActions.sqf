if !(hasInterface) exitWith {};

player addAction [ 
	"--Enter Bunker",  
	{
		call ONL_fnc_enterCave;
	}, 
	[], 
	10,  
	true,  
	false,  
	"", 
	"player distance ONL_logic_cave_2 < 5 AND {isNull (objectParent player)}", 
	2, 
	false 
];