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

		null = [] spawn ONL_fnc_addDefusalActions;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
if (!hasInterface) exitWith {};

if (!canSuspend) exitWith {
	"ONL_fnc_addDefusalActions must be run in scheduled envrionment" call BIS_fnc_error;
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

			["ONL_deviceDefused_event",[ONL_charge_1,"ONL_charge_1_ID"]] call CBA_fnc_serverEvent;
		}, 
		{["ONL_caveIn_event"] call CBA_fnc_serverEvent}, 
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

			["ONL_deviceDefused_event",[ONL_charge_2,"ONL_charge_2_ID"]] call CBA_fnc_serverEvent;
		}, 
		{["ONL_caveIn_event"] call CBA_fnc_serverEvent}, 
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

			["ONL_deviceDefused_event",[ONL_charge_3,"ONL_charge_3_ID"]] call CBA_fnc_serverEvent;
		}, 
		{["ONL_caveIn_event"] call CBA_fnc_serverEvent}, 
		[], 
		10, 
		10, 
		false, 
		false, 
		true
	] call BIS_fnc_holdActionAdd;
};



// remove action event, keeps actions from persisting even when the charge is detonated
if (!(missionNamespace getVariable ["ONL_removeDefusalAction_EventCreated",false])) then {
	[
		"ONL_removeDefusalAction_Event",
		{
			params [
				["_chargeGlobalName","",[""]]
			];
			
			if (!isNil _chargeGlobalName) then {
				player removeAction (missionNamespace getVariable _chargeGlobalName);
			};
		}
	] call CBA_fnc_addEventHandler;

	ONL_removeDefusalAction_EventCreated = true;
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