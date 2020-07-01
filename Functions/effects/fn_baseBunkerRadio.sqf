/* ----------------------------------------------------------------------------
Function: ONL_fnc_baseBunkerRadio

Description:
	Starts a loop that will find if a player is nearby the base's bunker and start player ambient radio chatter once near.
	Also deletes the audio once players move away.
	Executed from the near location loop for the base in ONL_fnc_startServerLoops. Was place in a seperate function for readability.

Parameters:
	NONE

Returns:
	Nothing

Examples:
    (begin example)

		call ONL_fnc_baseBunkerRadio;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */

if (!isServer) exitWith {};

[
	1,
	{
		[ONL_logic_bunkerRadio,35,3] spawn KISKA_fnc_radioChatter;
		
		[
			2,
			{
				deleteVehicle ONL_logic_bunkerRadio;
			},
			{!(((call CBA_fnc_players) findIf {(_x distance2D ONL_logic_bunkerRadio) > 50}) isEqualTo -1)}
		] call KISKA_fnc_waitUntil;
	},
	{!(((call CBA_fnc_players) findIf {(_x distance2D ONL_logic_bunkerRadio) < 50}) isEqualTo -1)}
] call KISKA_fnc_waitUntil;