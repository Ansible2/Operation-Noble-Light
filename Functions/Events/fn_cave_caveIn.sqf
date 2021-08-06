/* ----------------------------------------------------------------------------
Function: ONL_fnc_cave_caveIn

Description:
    Reveals several rocks and sets of explosives in the cave

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)
		remoteExec ["ONL_fnc_cave_caveIn",2];
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "ONL_fnc_cave_caveIn";

if (!isServer) exitWith {
    ["Needs to be executed on the server, remoting on server now...",true] call KISKA_fnc_log;
    remoteExec ["ONL_fnc_cave_caveIn",2];
    nil
};

if (!canSuspend) exitWith {
	["Was not run in scheduled, exiting to scheduled...",true] call KISKA_fnc_log;
	_this spawn ONL_fnc_cave_caveIn;
};


if (missionNamespace getVariable ["ONL_caveCollapsed",false] OR {missionNamespace getVariable ["ONL_caveChargesDead_skip",false]}) exitWith {};


if (alive ONL_charge_1 OR {alive ONL_charge_2} OR {alive ONL_charge_3}) then {
    missionNamespace setVariable ["ONL_caveCollapsed",true];

    [ONL_charge_1,ONL_charge_2,ONL_charge_3] apply {
        if (alive _x) then {
            _x enableSimulationGlobal true;
            _x allowDamage true;
            _x setDamage 1;
        };
    };

    // remove defusal actions
    ["ONL_charge_1_ID","ONL_charge_2_ID","ONL_charge_3_ID"] apply {
        [_x] remoteExec ["ONL_fnc_removeDefusalAction",call CBA_fnc_players];
    };

    sleep 1;

    // show rock cave in
    ((getMissionLayerEntities "Cave In") select 0) apply {
        _x hideObjectGlobal false;
    };

};

ONL_skipLoopsAndEvents pushBack "ONL_caveChargesDead_skip";


nil
