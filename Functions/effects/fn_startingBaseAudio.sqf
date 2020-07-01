/* ----------------------------------------------------------------------------
Function: ONL_fnc_startingBaseAudio

Description:
	Starts to sources of audio at the base when the mission starts.

	Executed in the "initServer.sqf"

Parameters:
	NONE

Returns:
	Nothing

Examples:
    (begin example)

		call ONL_fnc_startingBaseAudio;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
if (!isServer) exitWith {};

[
	1,
	{
		[ONL_logic_startingBaseRadio,35,2] spawn KISKA_fnc_radioChatter;
		
		[
			2,
			{
				deleteVehicle ONL_logic_startingBaseRadio;

			},// if all players have left the base, end
			{!(((call CBA_fnc_players) findIf {(_x distance ONL_logic_startingBaseRadio) > 200}) isEqualTo -1)}
		] call KISKA_fnc_waitUntil;

	},// if any player is at the base, start
	{!(((call CBA_fnc_players) findIf {(_x distance2D ONL_logic_startingBaseRadio) < 200}) isEqualTo -1)}
] call KISKA_fnc_waitUntil;


[] spawn {
	private _usedSounds = [];
	private _sounds = ["c_in1_20_broadcast_SPE_0","c_in1_20_broadcast_SPE_1","c_in1_21_broadcast_SPE_0","c_in1_21_broadcast_SPE_1","c_in1_22_broadcast_SPE_0","c_in1_22_broadcast_SPE_1","c_in1_23_broadcast_SPE_0"];
	
	// while any player is at the base
	while {!(((call CBA_fnc_players) findIf {(_x distance ONL_airfieldRespawn_Logic) < 200}) isEqualTo -1)} do {
		if (_sounds isEqualTo []) then {
			_sounds = _usedSounds;
			_usedSounds = [];
		};

		private _randomSound = selectRandom _sounds;
		_sounds deleteAt (_sounds findIf {_x isEqualTo _randomSound});
		
		_usedSounds pushBack _randomSound;

		[_randomSound,ONL_logic_startingBaseSpeaker_1,200,4] call KISKA_fnc_playSound3D;

		sleep (random [120,140,180]);
	};
};