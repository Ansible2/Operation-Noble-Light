/* ----------------------------------------------------------------------------
Function: ONL_fnc_cave_defusedCharge

Description:
    Fires when each of the cave-in explosive devices is defused.

Parameters:
	0: _charge <OBJECT> - The defused explosive
    1: _chargeGlobalName <STRING> - The stringified global variable that houses the action id for the charge's defusal

Returns:
	NOTHING

Examples:
    (begin example)
		[ONL_charge_1,"ONL_charge_1_ID"] remoteExec ["ONL_fnc_cave_defusedCharge",2];
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "ONL_fnc_cave_defusedCharge";

if (!isServer) exitWith {
    ["Needs to be executed on the server, remoting on server now...",true] call KISKA_fnc_log;
    remoteExec ["ONL_fnc_cave_caveIn",2];
    nil
};

if (missionNamespace getVariable ["ONL_caveChargesDead_skip",false]) exitWith {};


params [
    ["_charge",objNull,[objNull]],
    ["_chargeGlobalName","",[""]]
];

deleteVehicle _charge;

private _defusedCharges_plusOne = (missionNamespace getVariable ["ONL_defusedCharges_count",0]) + 1;
if (_defusedCharges_plusOne isEqualTo 3) then {
    ONL_skipLoopsAndEvents pushBack "ONL_caveChargesDead_skip";

} else {
    ONL_defusedCharges_count = _defusedCharges_plusOne;
    [_chargeGlobalName] remoteExec ["ONL_fnc_removeDefusalAction",call CBA_fnc_players];

};


nil
