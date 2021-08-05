/* ----------------------------------------------------------------------------
Function: ONL_fnc_supplyDrop

Description:
	Spawns a supply drop near the requested position. Crates will parachute in.

Parameters:
	0: _dropNumber <NUMBER> - Either 1 or 2 for which drop
	1: _dropPosition <ARRAY> - Position you want the drop to be near

Returns:
	NOTHING

Examples:
    (begin example)

		[1,position player,player] call ONL_fnc_supplyDrop;

    (end)

Author(s):
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "ONL_fnc_supplyDrop";

params ["_dropNumber","_dropPosition",["_caller",player]];

private _commMenuClass = ["ONL_supplyDrop_1","ONL_supplyDrop_2"] select _dropNumber;

if !(leader (group _caller) isEqualTo _caller) exitWith {
	hint "Only group leaders can call in supply drops";
	[_caller,_commMenuClass,nil,nil,""] call BIS_fnc_addCommMenuItem;
};

if (_targetPosition isEqualTo []) exitWith {
	hint "Position is invalid, try again";
	[_caller,_commMenuClass,nil,nil,""] call BIS_fnc_addCommMenuItem;
};



// tell everyone about the drop
private _message = "Supply drop inbound to " + str (mapGridPosition _dropPosition);
[_message] remoteExecCall ["hint",ONL_allClientsTargetID];
["supply drop requested"] call KISKA_fnc_supportRadioGlobal;

// do drop on server
[
	["B_Slingload_01_Repair_F","B_Slingload_01_Fuel_F","B_Slingload_01_Ammo_F"],
	2000,
	_dropPosition
] remoteExec ["KISKA_fnc_supplyDrop",2];

// remove comm item from everyone
[_dropNumber] remoteExecCall ["ONL_fnc_removeSupplyDrop",call CBA_fnc_players];

// sync pub var for use with save games and adding supports to JIP players
private _saveGlobal = ["ONL_supplyDrop",str _dropNumber,"Used"] joinString "";
missionNamespace setVariable [_saveGlobal,true,true];