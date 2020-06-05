if !(hasInterface) exitWith {};

// Computers to collect
ONL_caveCollectDevices apply {
	_x addAction [ 
		"--Collect Device",  
		{
			params ["_device"];

			playSound "FD_Timer_F";

			hint "Collected Device";

			["ONL_Cave_CollectedIntel_Event",[_device]] call CBA_fnc_serverEvent;
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


// Cave Generators
ONL_caveGenerators apply {

	_x addAction [ 
		"--ShutDown Generator",  
		{
			params ["_generator"];

			hintSilent "Generator Shutdown";

			["ONL_Cave_generatorShutOff_Event",[_generator]] call CBA_fnc_serverEvent;
		}, 
		nil, 
		10,  
		true,  
		false,  
		"", 
		"!(_target getVariable ['ONL_genOff',false])", 
		3, 
		false 
	];
};

// Tank Computer
ONL_caveTankComputer addAction [ 
	"--Study Data",  
	{
		params ["_computer"];

		["Seems this data is on an experimental piece of armor they were building here."] call KISKA_fnc_hintDiary;

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


// Devices
ONL_caveDevices apply {
	_x addAction [ 
		"--Collect Device Logs",  
		{
			params ["_device"];

			playSound "FD_Timer_F";

			hint "Logs Collected";

			["ONL_wasStudied_Event",[_device]] call CBA_fnc_serverEvent;			
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
};


// exit cave
player addAction [ 
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


// Open testing area actions
[	
	ONL_entryWallComputer,
	"<t color='#c91306'>Open Testing Area</t>", 
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa", 
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa", 
	"!(missionNamespace getVariable ['ONL_testingAreaOpen',false])", 
	"true", 
	{
		["OMIntelGrabLaptop_02",ONL_entryWallComputer,50,3] call KISKA_fnc_playSound3D;
	}, 
	{}, 
	{
		[true] remoteExec ["ONL_fnc_testingAreaDoors",2];
	}, 
	{}, 
	[], 
	2, 
	10, 
	false, 
	false, 
	true
] call BIS_fnc_holdActionAdd;

[	
	ONL_entryWallComputer,
	"<t color='#46ab07'>Close Testing Area</t>", 
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa", 
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa", 
	"(missionNamespace getVariable ['ONL_testingAreaOpen',false])", 
	"true", 
	{
		["OMIntelGrabLaptop_03",ONL_entryWallComputer,50,3] call KISKA_fnc_playSound3D;
	}, 
	{}, 
	{
		[false] remoteExec ["ONL_fnc_testingAreaDoors",2];
	}, 
	{}, 
	[], 
	2, 
	10, 
	false, 
	false, 
	true
] call BIS_fnc_holdActionAdd;