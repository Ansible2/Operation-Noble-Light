private _helicopter = createVehicle [ONL_orca,position ONL_blackSite_heliPad,[],0,"NONE"];

if !(ONL_snowTigersLoaded) then {
	[
		_helicopter,
		["Black",1], 
		true
	] call BIS_fnc_initVehicle;
};

_helicopter setUnloadInCombat [false,false];


uiSleep 1;


private _pilotsGroup = createGroup OPFOR;
for "_i" from 1 to 2 do {
	private _unit = _pilotsGroup createUnit [ONL_CSAT_crewman,[0,0,0],[],0,"NONE"];
	if (isNull _unit) then {
		_unit = _pilotsGroup createUnit [ONL_CSAT_crewman,[0,0,0],[],0,"NONE"];
	};
	
	if (_i isEqualTo 1) then {
		_unit moveInDriver _helicopter;
	} else {
		_unit moveInTurret [_helicopter,[0]];
	};
};

private _group1 = [4,ONL_CSATVariants,OPFOR] call KISKA_fnc_spawnGroup;
_group1 enableDynamicSimulation false;


uiSleep 1;


private _group2 = [4,ONL_CSATVariants,OPFOR] call KISKA_fnc_spawnGroup;
_group2 enableDynamicSimulation false;

(units _group1) + (units _group2) apply {
	_x moveInCargo _helicopter;
	uiSleep 0.1;
};

// prepare save code
_pilotsGroup setVariable ["ONL_loadCreationCode",{
	params ["_group"];
	private _helicopter = objectParent (leader _group);
	_helicopter engineOn true; 
	[_helicopter,[ONL_heliPatroLogic_blackSite_1,ONL_heliPatroLogic_blackSite_2,ONL_heliPatroLogic_blackSite_3,ONL_heliPatroLogic_blackSite_4],500,100,"LIMITED"] call KISKA_fnc_heliPatrol;
}];

[_helicopter,[ONL_heliPatroLogic_blackSite_1,ONL_heliPatroLogic_blackSite_2,ONL_heliPatroLogic_blackSite_3,ONL_heliPatroLogic_blackSite_4],500,100,"LIMITED"] call KISKA_fnc_heliPatrol;