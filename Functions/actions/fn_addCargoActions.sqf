/* ----------------------------------------------------------------------------
Function: ONL_fnc_addCargoActions

Description:
	Adds cargo loadding actions to all the vehicles at the starting base, called in "initPlayerLocal"

Parameters:
	0: _player : <OBJECT> - The player object

Returns:
	Nothing

Examples:
    (begin example)

		[player] call ONL_fnc_addCargoActions;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
if !(hasInterface) exitWith {};

params [
	["_player",player,[objNull]]
];

[['USAF_C17',13.5], ONL_startingVehicles] call KISKA_fnc_addCargoActions;

[	
	ONL_resetSwitch,
	"<t color='#46ab07'>Reset Cargo Plane</t>", 
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa", 
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa", 
	"true", 
	"true", 
	{}, 
	{}, 
	{
		hint "Plane Reset";

		["ONL_resetPlane_Event"] call CBA_fnc_serverEvent;
	}, 
	{}, 
	[], 
	1, 
	10, 
	false, 
	false, 
	true
] call BIS_fnc_holdActionAdd;