if (!canSuspend) exitWith {};

params [
	["_open",true,[true]]
];

if (_open) then {
	missionNamespace setVariable ["ONL_testingAreaOpen",true,true];

	[ONL_logic_caveSpeaker_1,ONL_logic_caveSpeaker_2] apply {
		["air_raid",_x,200,2] call KISKA_fnc_playSound3D;
	};
	
	sleep 10;

	["Testing Area Open"] remoteExec ["hintSilent",[0,-2] select isDedicated];
	
	ONL_entryWalls apply {
		_x setObjectTextureGlobal [0,"#(argb,1,1,1)color(1,1,1,0,ca)"];
	};

	ONL_entryWallsInvisible apply {
		_x hideObjectGlobal true;
	};

} else {
	missionNamespace setVariable ["ONL_testingAreaOpen",false,true];

	[ONL_logic_caveSpeaker_1,ONL_logic_caveSpeaker_2] apply {
		["alarm",_x,200,2] call KISKA_fnc_playSound3D;
	};

	["Testing Area Closed"] remoteExec ["hintSilent",[0,-2] select isDedicated];
	
	ONL_entryWalls apply {
		_x setObjectTextureGlobal [0,"#(argb,1,1,1)color(1,1,1,1,ca)"];
	};
	
	ONL_entryWallsInvisible apply {
		_x hideObjectGlobal false;
	};
};