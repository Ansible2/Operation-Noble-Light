if (hasInterface AND {call KISKA_fnc_isMusicPlaying}) then {
	10 fadeMusic 0;
};

[nil,nil,nil,false,true] call bis_fnc_endMission;