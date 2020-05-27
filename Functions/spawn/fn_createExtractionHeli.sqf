if (!isServer) exitWith {};


ONL_extractHeli = createVehicle [["B_Heli_Transport_03_F","CUP_B_UH60M_US"] select ONL_CUPVehiclesLoaded,[7213.91,5574.56,46.871],[],0,"FLY"];

if (ONL_CUPVehiclesLoaded) then {
	[
		ONL_extractHeli,
		["Grey",1], 
		["Hide_ESSS2x",1,"Hide_ESSS4x",1,"Hide_Nose",0,"Navyclan_hide",0,"Navyclan2_hide",1,"Blackhawk_Hide",0,"Hide_FlirTurret",0,"Hide_Probe",0,"Doorcock_Hide",0,"Filters_Hide",1]
	] call BIS_fnc_initVehicle;
};

ONL_extractHeli_group = createVehicleCrew ONL_extractHeli;

// so turrets can fire without pilot freaking out
ONL_extractHeliTurrets_group = createGroup WEST;
[ONL_extractHeli turretUnit [1], ONL_extractHeli turretUnit [2]] joinSilent ONL_extractHeliTurrets_group;

private _extractHeli_turretUnits = units ONL_extractHeliTurrets_group;

{
	if (_forEachIndex isEqualTo 0) then {
		_x assignAsTurret [ONL_extractHeli,[1]];
	} else {
		_x assignAsTurret [ONL_extractHeli,[2]];
	};
} forEach _extractHeli_turretUnits;

ONL_extractHeliTurrets_group setBehaviour "AWARE";
ONL_extractHeliTurrets_group setCombatMode "RED";

(units ONL_extractHeli_group + _extractHeli_turretUnits) apply {
	_x setUnitLoadout [[],[],["hgun_P07_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_CombatUniform_mcam_wdl_f",[]],["V_CarrierRigKBT_01_light_Olive_F",[]],["B_LegStrapBag_black_F",[]],"H_CrewHelmetHeli_B","",[],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","NVGoggles"]];
	_x allowDamage false;
	_x enableSimulationGlobal false;
	_x hideObjectGlobal true;
};

(currentPilot ONL_extractHeli) disableAI "RADIOPROTOCOL";
ONL_extractHeli setUnloadInCombat [false,false];
ONL_extractHeli allowDamage false;
ONL_extractHeli enableSimulationGlobal false;
ONL_extractHeli hideObjectGlobal true; 

// to be used in player respawn script
missionNamespace setVariable ["ONL_extractHeli",ONL_extractHeli,true];