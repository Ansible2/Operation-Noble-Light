/* ----------------------------------------------------------------------------
Function: ONL_fnc_addActionsMaster

Description:
	Adds all relevant actions across the map, called in "initPlayerLocal"

Parameters:
	NONE

Returns:
	Nothing

Examples:
    (begin example)
		call ONL_fnc_addActionsMaster;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
if !(hasInterface) exitWith {};

/* ----------------------------------------------------------------------------
	Base
---------------------------------------------------------------------------- */
ONL_BaseFile addAction [
	"-- Collect File --",
	{
		params ["_file"];

		[_file] remoteExec ["ONL_fnc_readBaseFile",2];
		playSound "FD_Timer_F";
		["You flip through the pages and find transport routes to a living area with mentions of engineers. Could be a lodging location. Seems to be the northern area Snikesnoken Hyttetun"] call KISKA_fnc_hintDiary;

	},
	nil,
	10,
	true,
	false,
	"",
	"true",
	2,
	false
];



/* ----------------------------------------------------------------------------
	Black Site
---------------------------------------------------------------------------- */
// Collect Rock sample
ONL_glowingRock addAction [
	"-- Collect Rock Sample --",
	{
		params ["_rock"];

		playSound "FD_Timer_F";
		["You collect a sample of the rock"] call KISKA_fnc_hintDiary;
		[_rock] remoteExec ["ONL_fnc_studyObject",2];
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
	"-- Study Device --",
	{
		params ["_computer"];

		["OMIntelGrabLaptop_01",_computer,25,3,true] call KISKA_fnc_playSound3D;
		["You decipiher some mentions of a weapon and also references to a facility directly SOUTH of the BORDER CROSSING surrounded by mountains"] call KISKA_fnc_hintDiary;
		[_computer] remoteExec ["ONL_fnc_studyObject",2];
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
		"-- Collect Device --",
		{
			params ["_intelObject"];

			playSound "FD_Timer_F";
			hint "Collected Device";
			[_intelObject] remoteExec ["ONL_fnc_blacksite_collectedIntel",2];
		},
		nil,
		10,
		true,
		false,
		"",
		"true",
		2,
		false
	];

	sleep 1;
};




/* ----------------------------------------------------------------------------
	Cave
---------------------------------------------------------------------------- */
// Computers to collect
ONL_caveCollectDevices apply {
	_x addAction [
		"-- Collect Device --",
		{
			params ["_device"];

			playSound "FD_Timer_F";
			hint "Collected Device";
			[_device] remoteExec ["ONL_fnc_cave_collectedIntel",2];
		},
		nil,
		10,
		true,
		false,
		"",
		"true",
		2,
		false
	];
};


// Cave Generators
ONL_caveGenerators apply {
	_x addAction [
		"-- ShutDown Generator --",
		{
			params ["_generator"];

			hintSilent "Generator Shutdown";
			[_generator] remoteExec ["ONL_fnc_cave_genShutoff",2];
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
	"-- Study Data --",
	{
		params ["_computer"];

		["Seems this data is on an experimental piece of armor they were building here."] call KISKA_fnc_hintDiary;
		[_computer] remoteExec ["ONL_fnc_studyObject",2];
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
			[_device] remoteExec ["ONL_fnc_studyObject",2];
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




/* ----------------------------------------------------------------------------
	Lodging
---------------------------------------------------------------------------- */
ONL_lodgingLaptop addAction [
	"-- Check Laptop --",
	{
		params ["_laptop"];

		playSound "FD_Timer_F";
		["You find partial routes to a facility SOUTHWEST of here. It is directly SOUTH of the Vardefjell Border Crossing"] call KISKA_fnc_hintDiary;
		[_laptop] remoteExec ["ONL_fnc_studyObject",2];
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



/* ----------------------------------------------------------------------------
	Village
---------------------------------------------------------------------------- */
// Apollo's Truck
ONL_ApolloTruck addAction [
	"-- Check Truck --",
	{
		params ["_truck"];

		playSound "FD_Timer_F";
		["You note several mines in the back of the truck."] call KISKA_fnc_hintDiary;
		[_truck] remoteExec ["ONL_fnc_studyObject",2];
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

ONL_ApolloFiles addAction [
	"-- Pickup Files --",
	{
		params ["_files"];

		playSound "FD_Timer_F";
		["You open the file and find statements from an unnamed informant. Talk of weapons being developed in a mountain facility from some new material found. There's a dig site apparently up the road to the EAST where it was found."] call KISKA_fnc_hintDiary;
		[_files] remoteExec ["ONL_fnc_village_collectedIntel",2];
	},
	nil,
	10,
	true,
	false,
	"",
	"!(_target getVariable ['ONL_wasStudied',false])",
	5,
	false
];



/* ----------------------------------------------------------------------------
	player
---------------------------------------------------------------------------- */
call ONL_fnc_addPlayerActions;
