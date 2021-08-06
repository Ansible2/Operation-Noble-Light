/* ----------------------------------------------------------------------------
Function: ONL_fnc_addDefusalActions

Description:
	Adds defuse actionst to the charges inside the cave, called in "ONL_fnc_enterCave"

Parameters:
	NONE

Returns:
	Nothing

Examples:
    (begin example)
		[] spawn ONL_fnc_addDefusalActions;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "ONL_fnc_addDefusalActions"

if (!hasInterface) exitWith {};

	if (!canSuspend) exitWith {
		["Was not run in scheduled, exiting to scheduled...",true] call KISKA_fnc_log;
		_this spawn ONL_fnc_addDefusalActions;
	};

waitUntil {player isEqualTo player};

if !(isNull ONL_charge_1) then {
	ONL_charge_1_ID = [
		player,
		"<t color='#b5041e'>Disarm Explosive 1</t>",
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
		"(player distance2D ONL_charge_1) <= 2",
		"true",
		{hint "Do NOT Let Go"},
		{},
		{
			hint "Device Defused";
			[ONL_charge_1,"ONL_charge_1_ID"] remoteExec ["ONL_fnc_cave_defusedCharge",2];
		},
		{remoteExec ["ONL_fnc_cave_caveIn",2];},
		[],
		10,
		10,
		false,
		false,
		true
	] call BIS_fnc_holdActionAdd;
};

if !(isNull ONL_charge_2) then {
	ONL_charge_2_ID = [
		player,
		"<t color='#b5041e'>Disarm Explosive 2</t>",
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
		"(player distance2D ONL_charge_2) <= 2",
		"true",
		{hint "Do NOT Let Go"},
		{},
		{
			hint "Device Defused";
			[ONL_charge_2,"ONL_charge_2_ID"] remoteExec ["ONL_fnc_cave_defusedCharge",2];
		},
		{remoteExec ["ONL_fnc_cave_caveIn",2];},
		[],
		10,
		10,
		false,
		false,
		true
	] call BIS_fnc_holdActionAdd;
};


if !(isNull ONL_charge_3) then {
	ONL_charge_3_ID = [
		player,
		"<t color='#b5041e'>Disarm Explosive 3</t>",
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
		"(player distance2D ONL_charge_3) <= 2",
		"true",
		{hint "Do NOT Let Go"},
		{},
		{
			hint "Device Defused";
			[ONL_charge_3,"ONL_charge_3_ID"] remoteExec ["ONL_fnc_cave_defusedCharge",2];
		},
		{remoteExec ["ONL_fnc_cave_caveIn",2];},
		[],
		10,
		10,
		false,
		false,
		true
	] call BIS_fnc_holdActionAdd;
};


// remove actions when dead
if (!(missionNamespace getVariable ["ONL_defusalKilled_EH_added",false])) then {
	private _player = call KISKA_fnc_getPlayerObject;

	_player addEventHandler ["Killed",{
		params ["_corpse"];

		[ONL_charge_1_ID,ONL_charge_2_ID,ONL_charge_3_ID] apply {
			[_corpse,_x] call BIS_fnc_holdActionRemove;
			_x = nil;
		};
	}];

	ONL_defusalKilled_EH_added = true;
};
