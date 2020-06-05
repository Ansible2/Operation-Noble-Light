if !(hasInterface) exitWith {};

// Collect Rock sample
ONL_glowingRock addAction [ 
	"--Collect Rock Sample",  
	{
		params ["_rock"];

		playSound "FD_Timer_F";

		["You collect a sample of the rock"] call KISKA_fnc_hintDiary;

		["ONL_wasStudied_Event",[_rock]] call CBA_fnc_serverEvent;	
	}, 
	nil, 
	10,  
	true,  
	false,  
	"", 
	"!(_target getVariable ['ONL_wasStudied',false])", 
	3, 
	false 
];

// Study computer near rock
ONL_blackSiteComputer addAction [ 
	"--Study Device",  
	{
		params ["_computer"];

		["OMIntelGrabLaptop_01",_computer,25,3,true] call KISKA_fnc_playSound3D;
		
		["You decipiher some mentions of a weapon and also references to a facility directly SOUTH of the BORDER CROSSING surrounded by mountains"] call KISKA_fnc_hintDiary;	

		["ONL_wasStudied_Event",[_computer]] call CBA_fnc_serverEvent;
	}, 
	nil, 
	10,  
	true,  
	false,  
	"", 
	"!(_target getVariable ['ONL_wasStudied',false])", 
	2, 
	false 
];

// Collect Computers near rock
ONL_blackSiteCollects apply {
	_x addAction [ 
		"--Collect Device",  
		{
			params ["_intelObject"];

			playSound "FD_Timer_F";

			hint "Collected Device";

			["ONL_blackSite_CollectedIntel_Event",[_intelObject]] call CBA_fnc_serverEvent;		
		}, 
		nil, 
		10,  
		true,  
		false,  
		"", 
		"", 
		2, 
		false 
	];
};