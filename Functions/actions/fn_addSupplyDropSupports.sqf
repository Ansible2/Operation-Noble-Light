if (!hasInterface) exitWith {};

params [
	["_player",player]
];

// these vars are defined by the server on load in order to be compatible with saves and then sent to clients
waitUntil {
	sleep 1;
	!isNil "ONL_supplyDrop1Used";
};
if !(missionNamespace getVariable ["ONL_supplyDrop1Used",false]) then {
	ONL_supplyDrop1MenuID = [_player,"ONL_supplyDrop_1"] call BIS_fnc_addCommMenuItem;
};

waitUntil {
	sleep 1;
	!isNil "ONL_supplyDrop2Used";
};
if !(missionNamespace getVariable ["ONL_supplyDrop2Used",false]) then {
	ONL_supplyDrop2MenuID = [_player,"ONL_supplyDrop_2"] call BIS_fnc_addCommMenuItem;
};