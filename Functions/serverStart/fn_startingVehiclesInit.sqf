/* ----------------------------------------------------------------------------
Function: ONL_fnc_startingVehiclesInit

Description:
	Clears cargo of all starter vehicles (all the ones player's can choose from at the start).
	Also discerns whether add-ons are installed and which vehicles to also spawn in accordance with the player preference.

	It is executed from the "initServer.sqf".

Parameters:
	NONE

Returns:
	Nothing

Examples:
    (begin example)
		call ONL_fnc_startingVehiclesInit
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
if (!isServer) exitWith {};

if (!ONL_CUPVehiclesLoaded AND {!ONL_RHSUSFVehiclesLoaded}) exitWith {
	missionNamespace setVariable ["ONL_startingVehicles",ONL_startingVehicles,true];

	ONL_startingVehicles apply {
		_x allowDamage false;

		clearWeaponCargoGlobal _x;
		clearItemCargoGlobal _x;
		clearBackpackCargoGlobal _x;
		clearMagazineCargoGlobal _x;
	};
};

private _fn_create = {
	params [
		["_logic",objNull,[objNull]],
		["_type","",[""]]
	];

	private _object = createVehicle [_type,getPosATL _logic,[],0,"CAN_COLLIDE"];
	_object setVectorDirAndUp [vectorDir _logic,vectorUp _logic];
	_object enableDynamicSimulation true;

	ONL_startingVehicles pushBack _object;
};

private _prferredVehicles = ONL_preferredVehicleMod == "CUP";

[ONL_startingVehicle_logic_1,["rhsusf_m1025_w_m2","CUP_B_M1151_M2_WDL_USA"] select _prferredVehicles] call _fn_create;
[ONL_startingVehicle_logic_2,["rhsusf_m1025_w_mk19","CUP_B_M1165_GMV_WDL_USA"] select _prferredVehicles] call _fn_create;
[ONL_startingVehicle_logic_3,["rhsusf_m998_w_s_2dr_halftop","CUP_B_M1167_WDL_USA"] select _prferredVehicles] call _fn_create;
[ONL_startingVehicle_logic_4,["rhsusf_stryker_m1126_mk19_wd","CUP_B_M1126_ICV_MK19_Woodland"] select _prferredVehicles] call _fn_create;
[ONL_startingVehicle_logic_5,["rhsusf_stryker_m1126_m2_wd","CUP_B_M1126_ICV_M2_Woodland"] select _prferredVehicles] call _fn_create;
[ONL_startingVehicle_logic_8,["B_APC_Wheeled_01_cannon_F","CUP_B_M2A3Bradley_USA_W"] select _prferredVehicles] call _fn_create;
[ONL_startingVehicle_logic_9,["B_MBT_01_cannon_F","CUP_B_M1A2_TUSK_MG_US_Army"] select _prferredVehicles] call _fn_create;


[ONL_startingVehicle_logic_6,["B_AFV_Wheeled_01_cannon_F","CUP_B_M1128_MGS_Woodland"] select ONL_CUPVehiclesLoaded] call _fn_create; // RHS support will be added if they have like vehicles in the future
[ONL_startingVehicle_logic_7,["B_AFV_Wheeled_01_up_cannon_F","CUP_B_M1130_CV_M2_Woodland_Slat"] select ONL_CUPVehiclesLoaded] call _fn_create;
[ONL_startingVehicle_logic_10,["B_APC_Wheeled_01_cannon_F","CUP_B_LAV25M240_USMC"] select ONL_CUPVehiclesLoaded] call _fn_create;
[ONL_startingVehicle_logic_11,["B_APC_Wheeled_01_cannon_F","CUP_B_LAV25_HQ_green"] select ONL_CUPVehiclesLoaded] call _fn_create;

if (ONL_CUPVehiclesLoaded) then {
	[ONL_startingVehicle_logic_12,ONL_startingVehicle_logic_13,ONL_startingVehicle_logic_14,ONL_startingVehicle_logic_15] apply {
		[_x,"CUP_B_M1030_USMC"] call _fn_create;
	};
};

{
	[_x,false] remoteExec ["allowDamage",0,"ONL_startingVehicleDamage_" + (str _forEachIndex)];

	clearWeaponCargoGlobal _x;
	clearItemCargoGlobal _x;
	clearBackpackCargoGlobal _x;
	clearMagazineCargoGlobal _x;
} forEach ONL_startingVehicles;

missionNamespace setVariable ["ONL_startingVehicles",ONL_startingVehicles,true];
