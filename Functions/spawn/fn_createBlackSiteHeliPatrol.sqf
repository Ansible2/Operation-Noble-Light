/* ----------------------------------------------------------------------------
Function: ONL_fnc_createBlackSiteHeliPatrol

Description:
	Creates a patroling helicopter around the black site.
	
	It is executed from "ONL_fnc_waitToDeletePlane".
	
Parameters:
	NONE

Returns:
	Nothing

Examples:
    (begin example)

		call ONL_fnc_createBlackSiteHeliPatrol;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
ONL_blackSitePatrolHelicopter = createVehicle [ONL_orca,position ONL_blackSite_heliPad,[],0,"NONE"];

if !(ONL_snowTigersLoaded) then {
	[
		ONL_blackSitePatrolHelicopter,
		["Black",1], 
		true
	] call BIS_fnc_initVehicle;
};

ONL_blackSitePatrolHelicopter setUnloadInCombat [false,false];

//////////////////////////////////////////////////////////////////////////////////////////////
uiSleep 1;
//////////////////////////////////////////////////////////////////////////////////////////////

private _pilotsGroup = createGroup OPFOR;
_pilotsGroup setVariable ["ONL_saveExcluded",true];

for "_i" from 1 to 2 do {
	private _unit = _pilotsGroup createUnit [ONL_CSAT_crewman,[0,0,0],[],0,"NONE"];
	if (isNull _unit) then {
		_unit = _pilotsGroup createUnit [ONL_CSAT_crewman,[0,0,0],[],0,"NONE"];
	};
	
	if (_i isEqualTo 1) then {
		_unit moveInDriver ONL_blackSitePatrolHelicopter;
	} else {
		_unit moveInTurret [ONL_blackSitePatrolHelicopter,[0]];
	};
};

private _group1 = [4,ONL_CSATVariants,OPFOR] call KISKA_fnc_spawnGroup;
_group1 setVariable ["ONL_saveExcluded",true];
_group1 enableDynamicSimulation false;

//////////////////////////////////////////////////////////////////////////////////////////////
uiSleep 1;
//////////////////////////////////////////////////////////////////////////////////////////////

private _group2 = [4,ONL_CSATVariants,OPFOR] call KISKA_fnc_spawnGroup;
_group2 setVariable ["ONL_saveExcluded",true];
_group2 enableDynamicSimulation false;

(units _group1) + (units _group2) apply {
	_x moveInCargo ONL_blackSitePatrolHelicopter;
	uiSleep 0.1;
};

// prepare save code
_pilotsGroup setVariable ["ONL_loadCreationCode",{
	params ["_group"];
	ONL_blackSitePatrolHelicopter = objectParent (leader _group);
	ONL_blackSitePatrolHelicopter engineOn true; 
	[ONL_blackSitePatrolHelicopter,[ONL_heliPatroLogic_blackSite_1,ONL_heliPatroLogic_blackSite_2,ONL_heliPatroLogic_blackSite_3,ONL_heliPatroLogic_blackSite_4],500,100,"LIMITED"] call KISKA_fnc_heliPatrol;
}];

[ONL_blackSitePatrolHelicopter,[ONL_heliPatroLogic_blackSite_1,ONL_heliPatroLogic_blackSite_2,ONL_heliPatroLogic_blackSite_3,ONL_heliPatroLogic_blackSite_4],500,100,"LIMITED"] call KISKA_fnc_heliPatrol;