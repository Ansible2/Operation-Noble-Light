/* ----------------------------------------------------------------------------
Function: ONL_fnc_removeDefusalAction

Description:
    Because cave charge defusal actions are added directly to the player object,
     they need to be removed when the charge is destroyed (and from all players).

Parameters:
	0: _chargeGlobalName <STRING> - The action id global var (as string) of the corresponding charge

Returns:
	NOTHING

Examples:
    (begin example)
		["ONL_charge_1_ID"] remoteExec ["ONL_fnc_removeDefusalAction",call CBA_fnc_players];
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "ONL_fnc_removeDefusalAction";

if (!hasInterface) exitWith {};

params [
    ["_chargeGlobalName","",[""]]
];

if (!isNil _chargeGlobalName_chargeGlobalName) then {
    player removeAction (missionNamespace getVariable _chargeGlobalName);
};
