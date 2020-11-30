/* ----------------------------------------------------------------------------
Function: ONL_fnc_prepareGlobals

Description:
	Does exactly what it says. Most globals in the scenario are initialized here.
	
	It is executed from the "initServer.sqf".
	
Parameters:
	NONE

Returns:
	Nothing

Examples:
    (begin example)

		call ONL_fnc_prepareGlobals

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
if (!isServer) exitWith {};

ONL_allClientsTargetID = ONL_allClientsTargetID;
publicVariable "ONL_allClientsTargetID";

// load save game
ONL_loadSave = [false,true] select (["LoadSave",0] call BIS_fnc_getParamValue);
if (ONL_loadSave AND {(profileNamespace getVariable ["ONL_saveData",[]]) isEqualTo []}) then {
	ONL_loadSave = false;

	[
		{
			["WARNING: SAVE NOT FOUND, NEW GAME STARTED"] remoteExec ["KISKA_fnc_dataLinkMsg",allPlayers,true];
		},
		[],
		15
	] call CBA_fnc_waitAndExecute;
};

// so that the defusal actions can check if these are alive
// interesting note. as of 1.98, global names assigned in the Eden Editor for mines
/// are NOT propigated across all machines unlike every other object.
publicVariable "ONL_charge_1";
publicVariable "ONL_charge_2";
publicVariable "ONL_charge_3";

// check optional mods
ONL_snowTigersLoaded = ["IP_CSAT_ST"] call KISKA_fnc_isPatchLoaded;
ONL_CUPVehiclesLoaded = ["CUP_Vehicles_Core"] call KISKA_fnc_isPatchLoaded;
ONL_RHSUSFVehiclesLoaded = ["rhsusf_cars"] call KISKA_fnc_isPatchLoaded;
ONL_preferredVehicleMod = ["CUP","RHSUSAF"] select (["PreferredVehicleMod",0] call BIS_fnc_getParamValue);
ONL_CUPUnitsLoaded = ["CUP_Creatures_People_Core"] call KISKA_fnc_isPatchLoaded;
ONL_FSGLoaded = ["fsg_units"] call KISKA_fnc_isPatchLoaded;


////// prepare globals for unitTypes

// CSAT
ONL_CSATVariants = [ONL_VanillaCSAT_unitTypes,ONL_FSTCSAT_unitTypes] select ONL_snowTigersLoaded;
ONL_CSAT_crewman = ["O_T_Crew_F","IP_O_crew_FST"] select ONL_snowTigersLoaded;
// CSAT Vehicles
ONL_CSATVehicleVariants = [ONL_vanillaCSAT_vehicleUnitTypes,ONL_FST_vehicleUnitTypes] select ONL_snowTigersLoaded;
ONL_CSATHelicopterAttack = ["O_Heli_Attack_02_dynamicLoadout_F","IP_O_Heli_Attack_02_SnowHex_FST"] select ONL_snowTigersLoaded;
ONL_CSAT_MBT = ["O_T_MBT_02_cannon_ghex_F","IP_O_MBT_02_cannon_FST"] select ONL_snowTigersLoaded;
ONL_CSAT_APCWheeled = ["O_T_APC_Wheeled_02_rcws_v2_ghex_F","IP_O_APC_Wheeled_02_rcws_FST"] select ONL_snowTigersLoaded;
ONL_CSAT_APCTracked = ["O_T_APC_Tracked_02_cannon_ghex_F","IP_O_APC_Tracked_02_cannon_FST"] select ONL_snowTigersLoaded;

// spetsnaz
ONL_spetsnazRegular_unitTypes = [ONL_spetsnazRegVanilla_unitTypes,ONL_fsg_unitTypes] select ONL_FSGLoaded;
ONL_spetsnazSFVariants = [ONL_vanillaSpetsnazSF_unitTypes,ONL_fsgSF_unitTypes] select ONL_FSGLoaded;
ONL_spetsnaz_crewman = ["O_R_Patrol_Soldier_Engineer_F","fsg_o_regular_crewman"] select ONL_FSGLoaded;
// spetsnaz vehicles
ONL_spetsnaz_apc = ["I_APC_Wheeled_03_cannon_F","fsg_btr_1"] select ONL_FSGLoaded;
ONL_spetsnaz_carArmed = ["I_G_Offroad_01_armed_F","fsg_tigr_2"] select ONL_FSGLoaded;
ONL_spetsnaz_car = ["C_Offroad_01_comms_F","fsg_tigr_1"] select ONL_FSGLoaded;
ONL_spetsnaz_helicopter = "O_Heli_Light_02_unarmed_F";


// PMC
ONL_pmc_Variants = [ONL_PMCVanilla_unitTypes,ONL_ion_unitTypes] select ONL_CUPUnitsLoaded;
ONL_PMC_guntruck = ["I_G_Offroad_01_armed_F","CUP_I_RG31E_M2_W_ION"] select ONL_CUPVehiclesLoaded;


// static object replacement globals
ONL_tempestVariants = [ONL_tempestVariants_Vanilla,ONL_tempestVariants_FST] select ONL_snowTigersLoaded;
ONL_taruPodsVariants = [ONL_taruPodsVariants_vanilla,ONL_taruPodsVariants_FST] select ONL_snowTigersLoaded;
ONL_ifritVariants = [ONL_ifritVariants_vanilla,ONL_ifritVariants_FST] select ONL_snowTigersLoaded;
ONL_orca = ["O_Heli_Light_02_unarmed_F","IP_O_Heli_Light_02_unarmed_FST"] select ONL_snowTigersLoaded;


ONL_startingVehicles = (getMissionLayerEntities "Starting Vehicles") select 0;

ONL_prePlacedVehicles = vehicles select {
	!(_x isKindOf "THING") AND
	{!(_x in ONL_startingVehicles)}
};
// this is prepared for saves to put the index of dead vehicles so they can be deleted when loading a game
// in other words, since they are created in a certain order, the exact vehicle can be deleted through an array index
ONL_deadVehicleIndexes = [];
// this is for loops and events that do not need to be created again after loading a save
ONL_skipLoopsAndEvents = [];


// Task stuff for saves
ONL_taskIdsAndInfo = [
	[FindHeadScientist_TaskID,"FindHeadScientist_TaskInfo","","SEARCH"],
	[CollectBaseIntel_TaskID,"CollectBaseIntel_TaskInfo","","SEARCH"],
	[DestroyComs_TaskID,"DestroyComs_TaskInfo",ONL_comRelay,"DESTROY"],
	[DestroyArty_taskID,"DestroyArty_taskInfo","","DESTROY"],
	[CollectBlackSiteIntel_TaskID,"CollectBlackSiteIntel_TaskInfo","","SEARCH"],
	[CollectRockSample_TaskID,"CollectRockSample_TaskInfo",ONL_glowingRock,"INTERACT"],
	[DestroyBlackSiteServers_TaskID,"DestroyBlackSiteServers_TaskInfo",ONL_blackSiteServer_2,"DESTROY"],
	[InvestigateBlackSite_TaskID,"InvestigateBlackSite_TaskInfo","","SEARCH"],
	[CollectCaveData_TaskID,"CollectCaveData_TaskInfo","","INTERACT"],
	[CollectDeviceLogs_TaskID,"CollectDeviceLogs_TaskInfo","","INTERACT"],
	[DestroyCaveServers_TaskID,"DestroyCaveServers_TaskInfo",ONL_caveServer_1,"DESTROY"],
	[DestroyTheDevices_TaskID,"DestroyTheDevices_TaskInfo","","DESTROY"],
	[InvestigateFacility_TaskID,"InvestigateFacility_TaskInfo","","SEARCH"],
	[SearchLodging_TaskID,"SearchLodging_TaskInfo","","SEARCH"],
	[SecureApollo_TaskID,"SecureApollo_TaskInfo",ONL_ApolloFiles,"MEET"],
	[Extract_TaskID,"Extract_TaskInfo",[6388.54,9555.92,0],"TAKEOFF"]
];


////// Prepare music globals
private _musicType = ["CCM","NONE"/*,"KISKA"*/] select (["MusicType",0] call BIS_fnc_getParamValue);
if (_musicType != "None") then {
	if (_musicType == "CCM") then {
		ONL_CCMLoaded = true;
		ONL_KISKAMusicLoaded = false;
	} else {
		ONL_KISKAMusicLoaded = true;
		ONL_CCMLoaded = false;
	};
} else {
	ONL_CCMLoaded = false;
	ONL_KISKAMusicLoaded = false;
};