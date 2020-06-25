ONL_basePatrolHelicopter = createVehicle [ONL_CSATHelicopterAttack,position ONL_baseHelipad,[],0,"NONE"];

// if snow tigers is not loaded, make the heli black
if !(ONL_snowTigersLoaded) then {
	[
		ONL_basePatrolHelicopter,
		["Black",1], 
		true
	] call BIS_fnc_initVehicle;
};

ONL_basePatrolHelicopter setUnloadInCombat [false,false];

uiSleep 1;

// create pilots
private _pilotsGroup = createGroup OPFOR;
_pilotsGroup setVariable ["ONL_saveExcluded",true];
for "_i" from 1 to 2 do {
	private _unit = _pilotsGroup createUnit [ONL_CSAT_crewman,[0,0,0],[],0,"NONE"];

	if (isNull _unit) then {
		_unit = _pilotsGroup createUnit [ONL_CSAT_crewman,[0,0,0],[],0,"NONE"];
	};
	
	if (_i isEqualTo 1) then {
		_unit moveInDriver ONL_basePatrolHelicopter;
	} else {
		_unit moveInGunner ONL_basePatrolHelicopter;
	};
};

// create cargo groups
private _group1 = [4,ONL_CSATVariants,OPFOR] call KISKA_fnc_spawnGroup;
_group1 setVariable ["ONL_saveExcluded"];
_group1 enableDynamicSimulation false;

uiSleep 1;

private _group2 = [4,ONL_CSATVariants,OPFOR] call KISKA_fnc_spawnGroup;
_group2 setVariable ["ONL_saveExcluded"];
_group2 enableDynamicSimulation false;

(units _group1) + (units _group2) apply {
	_x moveInCargo ONL_basePatrolHelicopter;
	uiSleep 0.1;
};

// prepare save code
_pilotsGroup setVariable ["ONL_loadCreationCode",{
	params ["_group"];
	private ONL_basePatrolHelicopter = objectParent (leader _group);
	ONL_basePatrolHelicopter engineOn true; 
	[ONL_basePatrolHelicopter,[ONL_heliPatroLogic_1,ONL_heliPatroLogic_2,ONL_heliPatroLogic_3,ONL_heliPatroLogic_4],600,100,"LIMITED",false] call KISKA_fnc_heliPatrol;
}];

[ONL_basePatrolHelicopter,[ONL_heliPatroLogic_1,ONL_heliPatroLogic_2,ONL_heliPatroLogic_3,ONL_heliPatroLogic_4],600,100,"LIMITED",false] call KISKA_fnc_heliPatrol;