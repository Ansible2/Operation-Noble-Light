if (!hasInterface) exitWith {};


if (!ONL_CCMLoaded AND {!ONL_KISKAMusicLoaded}) exitWith {false};

if (ONL_CCMLoaded) exitWith {
	[
		{
			["CCM_sb_horizons",0,true] remoteExec ["KISKA_fnc_playMusic",[0,-2] select isDedicated]; 
		},
		[],
		60
	] call CBA_fnc_waitAndExecute;

	[
		{
			["CCM_GL_classifiedInformation",0,true] remoteExec ["KISKA_fnc_playMusic",[0,-2] select isDedicated]; 
		},
		[],
		(["CCM_sb_horizons"] call KISKA_fnc_getMusicDuration) + 2
	] call CBA_fnc_waitAndExecute;

	[
		{
			["CCM_sb_intervention",0,true] remoteExec ["KISKA_fnc_playMusic",[0,-2] select isDedicated]; 
		},
		[],
		540
	] call CBA_fnc_waitAndExecute;
};


if (ONL_KISKAMusicLoaded) exitWith {
	[
		{
			["Kiska_Whereabouts",0,true] remoteExec ["KISKA_fnc_playMusic",[0,-2] select isDedicated]; 
		},
		[],
		60
	] call CBA_fnc_waitAndExecute;

	[
		{
			["Kiska_Truth",0,true] remoteExec ["KISKA_fnc_playMusic",[0,-2] select isDedicated]; 
		},
		[],
		(["Kiska_Whereabouts"] call KISKA_fnc_getMusicDuration) + 30
	] call CBA_fnc_waitAndExecute;

};