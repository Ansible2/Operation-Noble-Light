if (!isServer) exitWith {};

private _randomArray = [ONL_caveMusicTracks,count ONL_caveMusicTracks] call CBA_fnc_selectRandomArray;

private _durationArray = [];

{
	private _track = _x;

	if (_forEachIndex isEqualTo 0) then {
		[_track,0,true,0.5] remoteExec ["KISKA_fnc_playMusic",[0,-2] select isDedicated];

		_durationArray pushBack (_track call KISKA_fnc_getMusicDuration);
	} else {
		private _waitTime = 0;
				
		_durationArray apply {
			_waitTime = _waitTime + _x + 2;
		};

		[
			{
				[_this select 0,0,true,0.5] remoteExec ["KISKA_fnc_playMusic",[0,-2] select isDedicated];
			},
			[_track],
			_waitTime
		] call CBA_fnc_waitAndExecute;
		
		_durationArray pushBack (_track call KISKA_fnc_getMusicDuration);
	};
} forEach _randomArray;