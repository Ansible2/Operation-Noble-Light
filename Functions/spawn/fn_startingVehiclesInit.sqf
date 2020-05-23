if (!ONL_CUPVehiclesLoaded AND {!ONL_RHSUSFVehiclesLoaded}) exitWith {
	missionNamespace setVariable ["ONL_startingVehicles",ONL_startingVehicles,true];
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

[ONL_startingVehicle_logic_1,["rhsusf_m1025_w_m2","CUP_B_M1151_M2_WDL_USA"] select ONL_CUPVehiclesLoaded] call _fn_create;
[ONL_startingVehicle_logic_2,["rhsusf_m1025_w_mk19","CUP_B_M1165_GMV_WDL_USA"] select ONL_CUPVehiclesLoaded] call _fn_create;
[ONL_startingVehicle_logic_3,["rhsusf_m998_w_s_2dr_halftop","CUP_B_M1167_WDL_USA"] select ONL_CUPVehiclesLoaded] call _fn_create;
[ONL_startingVehicle_logic_4,["rhsusf_stryker_m1126_mk19_wd","CUP_B_M1126_ICV_MK19_Woodland"] select ONL_CUPVehiclesLoaded] call _fn_create;
[ONL_startingVehicle_logic_5,["rhsusf_stryker_m1126_m2_wd","CUP_B_M1126_ICV_M2_Woodland"] select ONL_CUPVehiclesLoaded] call _fn_create;
[ONL_startingVehicle_logic_8,["RHS_M2A3_BUSKIII_wd","CUP_B_M2A3Bradley_USA_W"] select ONL_CUPVehiclesLoaded] call _fn_create;
[ONL_startingVehicle_logic_9,["rhsusf_m1a2sep1tuskiwd_usarmy","CUP_B_M1A2_TUSK_MG_US_Army"] select ONL_CUPVehiclesLoaded] call _fn_create;

if (ONL_CUPVehiclesLoaded) then {
	[ONL_startingVehicle_logic_6,["CUP_B_M1128_MGS_Woodland"] select ONL_CUPVehiclesLoaded] call _fn_create;
	[ONL_startingVehicle_logic_7,["CUP_B_M1130_CV_M2_Woodland_Slat"] select ONL_CUPVehiclesLoaded] call _fn_create;
	[ONL_startingVehicle_logic_10,["CUP_B_LAV25M240_USMC"] select ONL_CUPVehiclesLoaded] call _fn_create;
	[ONL_startingVehicle_logic_11,["CUP_B_LAV25_HQ_green"] select ONL_CUPVehiclesLoaded] call _fn_create;

	[ONL_startingVehicle_logic_12,ONL_startingVehicle_logic_13,ONL_startingVehicle_logic_14,ONL_startingVehicle_logic_15] apply {
		[_x,"CUP_B_M1030_USMC"] call _fn_create;
	};
};

ONL_startingVehicles apply {
	_x allowDamage false;
};

missionNamespace setVariable ["ONL_startingVehicles",ONL_startingVehicles,true];