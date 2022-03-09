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
	Ansible2
---------------------------------------------------------------------------- */
if !(hasInterface) exitWith {};

params [
	["_player",player,[objNull]]
];

[['USAF_C17',13.5], ONL_startingVehicles] call KISKA_fnc_addCargoActions;
