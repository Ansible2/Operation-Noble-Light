/* ----------------------------------------------------------------------------
Function: ONL_fnc_cave_entered

Description:
    Acts as a server event when a player first enteres the cave.

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)
		remoteExec ["ONL_fnc_cave_entered",2];
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "ONL_fnc_cave_entered";

if (!isServer) exitWith {
    ["Needs to be executed on the server, remoting on server now...",true] call KISKA_fnc_log;
    remoteExec ["ONL_fnc_cave_entered",2];
    nil
};

if (missionNamespace getVariable ["ONL_caveWasEntered",false]) exitWith {};
missionNamespace setVariable ["ONL_caveWasEntered",true];


call ONL_fnc_waitToAddCaveTasks;

// cave in charges timer begins
[
    {
        ["ONL_caveIn_event"] call CBA_fnc_serverEvent;
    },
    [],
    60*15
] call CBA_fnc_waitAndExecute;

// wait to show units at end of tunnel
[
    1,
    {
        [((getMissionLayerEntities "CaveAI") select 0),true,true] call KISKA_fnc_showHide;
    },// check if a player is within 10m of either ONL_logic_cave_3 or ONL_logic_cave_4
    {!(((call CBA_fnc_players) findIf {(_x distance2D ONL_logic_cave_3) < 10 OR {(_x distance2D ONL_logic_cave_4) < 10}}) isEqualTo -1)}
] call KISKA_fnc_waitUntil;

// start music
call ONL_fnc_caveMusic;

// turn on generator audio
((getMissionLayerEntities "Cave Generators") select 0) apply {
    [_x] spawn {

        params ["_gen"];

        while {alive _gen AND {!(_gen getVariable ["ONL_genOff",false])}} do {

            playSound3D ["A3\Missions_F_Oldman\Data\sound\Energy_Hum\Energy_Hum_Loop.wss",_gen,true,getPosASL _gen,1,1,50];

            sleep 8.5;
        };
    };
};


nil
