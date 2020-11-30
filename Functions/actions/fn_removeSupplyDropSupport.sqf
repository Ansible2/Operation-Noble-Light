if (!hasInterface) exitWith {};

params ["_dropNumber"];

private _id = [ONL_supplyDrop1MenuID,ONL_supplyDrop2MenuID] select (_dropNumber + 1);

[player,_id] call BIS_fnc_removeCommMenuItem;