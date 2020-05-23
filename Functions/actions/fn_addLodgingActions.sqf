if !(hasInterface) exitWith {};

ONL_lodgingLaptop addAction [ 
	"--Check Laptop",  
	{
		params ["_laptop"];

		playSound "FD_Timer_F";

		["You find partial routes to a facility SOUTHWEST of here. It is directly SOUTH of the Vardefjell Border Crossing"] call KISKA_fnc_hintDiary;

		["ONL_wasStudied_Event",[_laptop]] call CBA_fnc_serverEvent;	
	}, 
	[], 
	10,  
	true,  
	false,  
	"", 
	"!(_target getVariable ['ONL_wasStudied',false])",
	2, 
	false 
];