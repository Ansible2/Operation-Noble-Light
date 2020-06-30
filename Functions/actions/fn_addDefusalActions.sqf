//// why is this a seperate file instead of in the fn_addActionMaster?
// suspension (use of waitUntil) and the desire to save on perfomance for the conidition checks on each of the seperate actions
// for a 6 hour mission, there is no point in having 3 condition checks every frame if it can easily be avoided. 
// this function is called upon entering the cave

if (!hasInterface) exitWith {};

if (!canSuspend) exitWith {
	"ONL_fnc_addDefusalActions must be run in scheduled envrionment" call BIS_fnc_error;
};

waitUntil {player isEqualTo player};

// cave In charges
// Defuse chages actions
if !(isNull ONL_charge_1) then {
	ONL_charge_1_ID = [	
		player,
		"<t color='#b5041e'>Disarm Explosive 1</t>", 
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
		"<t color='#b5041e'>Disarm Explosive 2</t>", 
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
		"<t color='#b5041e'>Disarm Explosive 3</t>", 
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



// remove action event, actions will persist even when the charge is detonated
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