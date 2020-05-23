if !(hasInterface) exitWith {};

ONL_BaseFile addAction [ 
	"--Collect File",  
	{
		params ["_file"];

		["ONL_base_readFile_Event",[_file]] call CBA_fnc_serverEvent;

		playSound "FD_Timer_F";

		["You flip through the pages and find transport routes to a living area with mentions of engineers. Could be a lodging location. Seems to be the northern area Snikesnoken Hyttetun"] call KISKA_fnc_hintDiary;

	}, 
	[], 
	10,  
	true,  
	false,  
	"", 
	"", 
	2, 
	false 
];