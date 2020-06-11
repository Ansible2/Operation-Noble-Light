if !(hasInterface) exitWith {};

waitUntil {player isEqualTo player};

// cave In charges
// Defuse chages actions
if !(isNull ONL_charge_1) then {
	ONL_charge_1_ID = [	
		player,
		"<t color='#b5041e'>Disarm Explosive</t>", 
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa", 
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa", 
		"cursorObject isEqualTo ONL_charge_1", 
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
		"<t color='#b5041e'>Disarm Explosive</t>", 
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa", 
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa", 
		"cursorObject isEqualTo ONL_charge_2", 
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
		"<t color='#b5041e'>Disarm Explosive</t>", 
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa", 
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa", 
		"cursorObject isEqualTo ONL_charge_3", 
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

// remove action event, actions persist even when the charge is detonated
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
	player addEventHandler ["Killed",{
		params ["_unit"];

		[ONL_charge_1_ID,ONL_charge_2_ID,ONL_charge_3_ID] apply {
			[_unit,_x] call BIS_fnc_holdActionRemove;
			_x = nil;
		};

		_unit removeEventHandler ["Killed",_thisEventHandler];

		ONL_defusalKilled_EH_added = false;
	}];

	ONL_defusalKilled_EH_added = true;
};