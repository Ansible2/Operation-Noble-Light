if (!isServer) exitWith {};

params [
	["_radio",objNull,[objNull]],
	["_duration",300,[123]]
];

private _endTime = _duration + time;

waitUntil {
	if (_endTime <= time OR {!(((call CBA_fnc_players) findIf {(_x distance2d _radio) > 200}) isEqualTo -1)}) exitWith {true};

	if (ONL_newsSounds isEqualTo []) then {
		ONL_newsSounds = ONL_usedNewsSounds;
		ONL_usedNewsSounds = [];
	};

	private _randomNews = selectRandom ONL_newsSounds;

	ONL_newsSounds deleteAt (ONL_newsSounds findIf {_x isEqualTo _randomNews});
	
	ONL_usedNewsSounds pushBack _randomNews;

	[_randomNews,_radio,20,2,true] spawn KISKA_fnc_playSound3d;
	
	sleep (random [30,35,40]);

	false
};