if !(hasInterface) exitWith {};

// Apollo's Truck
ONL_ApolloTruck addAction [ 
	"--Check Truck",  
	{
		params ["_truck"];

		playSound "FD_Timer_F";

		["You note several mines in the back of the truck."] call KISKA_fnc_hintDiary;

		["ONL_wasStudied_Event", [_truck]] call CBA_fnc_serverEvent;	
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
	"--Pickup Files",  
	{
		params ["_files"];

		playSound "FD_Timer_F";

		["You open the file and find statements from an unnamed informant. Talk of weapons being developed in a mountain facility from some new material found. There's a dig site apparently up the road to the EAST where it was found."] call KISKA_fnc_hintDiary;

		["ONL_village_CollectedIntel_Event", [_files]] call CBA_fnc_serverEvent;	
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