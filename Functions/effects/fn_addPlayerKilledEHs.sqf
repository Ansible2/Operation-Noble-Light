if (!hasInterface) exitWith {};

params [
	["_player",player]
];

_player addEventHandler ["KILLED",{
	params ["_unit"];
	missionNamespace setVariable ["ONL_playerGroup",group _unit];
	missionNamespace setVariable ["ONL_playerLoadout",getUnitLoadout _unit];

	_unit removeEventHandler ["KILLED",_thisEventHandler];
}];