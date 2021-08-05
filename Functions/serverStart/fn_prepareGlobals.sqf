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
	Ansible2
---------------------------------------------------------------------------- */
if (!isServer) exitWith {};

#define GET_UNIT_ARRAY(class,property) _arrayConfigs >> class >> property
#define GET_SIMPLE_CLASS(class,property) _simpleClassesConfig >> class >> property
#define GET_CIV_ARRAY(property) getArray(missionConfigFile >> "KISKA_loadouts" >> "civGear" >> property)


ONL_allClientsTargetID = [0,-2] select isDedicated;
publicVariable "ONL_allClientsTargetID";


/* ----------------------------------------------------------------------------
	civilian gear
---------------------------------------------------------------------------- */
ONL_loadoutConfig = missionConfigFile >> "KISKA_loadouts" >> "ONL";
ONL_civUniforms = GET_CIV_ARRAY("uniforms");
ONL_civFacewear = GET_CIV_ARRAY("facewear");
ONL_civVests = GET_CIV_ARRAY("vests");
ONL_civHeadgear = GET_CIV_ARRAY("headgear");


/* ----------------------------------------------------------------------------

	Load save

---------------------------------------------------------------------------- */
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


// this is prepared for saves to put the index of dead vehicles so they can be deleted when loading a game
// in other words, since they are created in a certain order, the exact vehicle can be deleted through an array index
ONL_deadVehicleIndexes = [];
// this is for loops and events that do not need to be created again after loading a save
ONL_skipLoopsAndEvents = [];



// so that the defusal actions can check if these are alive
// interesting note. as of 1.98, global names assigned in the Eden Editor for mines
/// are NOT propigated across all machines unlike every other object.
publicVariable "ONL_charge_1";
publicVariable "ONL_charge_2";
publicVariable "ONL_charge_3";

/* ----------------------------------------------------------------------------

	Check mods

---------------------------------------------------------------------------- */
ONL_snowTigersLoaded = ["IP_CSAT_ST"] call KISKA_fnc_isPatchLoaded;
ONL_CUPVehiclesLoaded = ["CUP_Vehicles_Core"] call KISKA_fnc_isPatchLoaded;
ONL_RHSUSFVehiclesLoaded = ["rhsusf_cars"] call KISKA_fnc_isPatchLoaded;
ONL_preferredVehicleMod = ["CUP","RHSUSAF"] select (["PreferredVehicleMod",0] call BIS_fnc_getParamValue);
ONL_CUPUnitsLoaded = ["CUP_Creatures_People_Core"] call KISKA_fnc_isPatchLoaded;
ONL_FSGLoaded = ["fsg_units"] call KISKA_fnc_isPatchLoaded;



/* ----------------------------------------------------------------------------

	Unit classes

---------------------------------------------------------------------------- */
private _unitTypeConfig = missionConfigFile >> "Mission_unitTypes";
private _simpleClassesConfig = _unitTypeConfig >> "SimpleClasses";
private _arrayConfigs = _unitTypeConfig >> "ClassArrays";

/* ----------------------------------------------------------------------------
	CSAT types
---------------------------------------------------------------------------- */
ONL_CSATVariants = [
	GET_UNIT_ARRAY("csat_units","vanilla"),
	GET_UNIT_ARRAY("csat_units","snowTigers")
] select ONL_snowTigersLoaded;

ONL_CSAT_crewman = [
	GET_SIMPLE_CLASS("csat_crewman","vanilla"),
	GET_SIMPLE_CLASS("csat_crewman","snowTigers")
] select ONL_snowTigersLoaded;

// CSAT Vehicles
ONL_CSATVehicleVariants = [
	GET_UNIT_ARRAY("csat_vehicle_types", "vanilla"),
	GET_UNIT_ARRAY("csat_vehicle_types", "snowTigers")
] select ONL_snowTigersLoaded;

ONL_CSATHelicopterAttack = [
	GET_SIMPLE_CLASS("csat_attackHeli","vanilla"),
	GET_SIMPLE_CLASS("csat_attackHeli","snowTigers")
] select ONL_snowTigersLoaded;

ONL_CSAT_MBT = [
	GET_SIMPLE_CLASS("csat_tank","vanilla"),
	GET_SIMPLE_CLASS("csat_tank","snowTigers")
] select ONL_snowTigersLoaded;

ONL_CSAT_APCWheeled = [
	GET_SIMPLE_CLASS("csat_apc_wheeled","vanilla"),
	GET_SIMPLE_CLASS("csat_apc_wheeled","snowTigers")
] select ONL_snowTigersLoaded;

ONL_CSAT_APCTracked = [
	GET_SIMPLE_CLASS("csat_apc_tracked","vanilla"),
	GET_SIMPLE_CLASS("csat_apc_tracked","snowTigers")
] select ONL_snowTigersLoaded;



/* ----------------------------------------------------------------------------
	spetsnaz type
---------------------------------------------------------------------------- */
ONL_spetsnazRegular_unitTypes = [
	GET_UNIT_ARRAY("spetsnaz_regular_units","vanilla"),
	GET_UNIT_ARRAY("spetsnaz_regular_units","foxhound")
] select ONL_FSGLoaded;

ONL_spetsnazSFVariants = [
	GET_UNIT_ARRAY("spetsnaz_sf_units","vanilla"),
	GET_UNIT_ARRAY("spetsnaz_sf_units","foxhound")
] select ONL_FSGLoaded;

ONL_spetsnaz_crewman = [
	GET_SIMPLE_CLASS("spetsnaz_crewman","vanilla"),
	GET_SIMPLE_CLASS("spetsnaz_crewman","foxhound")
] select ONL_FSGLoaded;

// spetsnaz vehicles
ONL_spetsnaz_apc = [
	GET_SIMPLE_CLASS("spetsnaz_apc","vanilla"),
	GET_SIMPLE_CLASS("spetsnaz_apc","foxhound")
] select ONL_FSGLoaded;

ONL_spetsnaz_carArmed = [
	GET_SIMPLE_CLASS("spetsnaz_armedCar","vanilla"),
	GET_SIMPLE_CLASS("spetsnaz_armedCar","foxhound")
] select ONL_FSGLoaded;

ONL_spetsnaz_car = [
	GET_SIMPLE_CLASS("spetsnaz_car","vanilla"),
	GET_SIMPLE_CLASS("spetsnaz_car","foxhound")
] select ONL_FSGLoaded;

ONL_spetsnaz_helicopter = GET_SIMPLE_CLASS("spetsnaz_helicopter","vanilla");


/* ----------------------------------------------------------------------------
	PMC types
---------------------------------------------------------------------------- */
ONL_pmc_Variants = [
	GET_UNIT_ARRAY("pmc_units","vanilla"),
	GET_UNIT_ARRAY("pmc_units","cup")
] select ONL_CUPUnitsLoaded;

ONL_PMC_guntruck = [
	GET_SIMPLE_CLASS("pmc_gunTruck","vanilla"),
	GET_SIMPLE_CLASS("pmc_gunTruck","cup")
] select ONL_CUPUnitsLoaded;


/* ----------------------------------------------------------------------------
	static object types
---------------------------------------------------------------------------- */
ONL_tempestVariants = [
	GET_UNIT_ARRAY("tempest","vanilla"),
	GET_UNIT_ARRAY("tempest","snowTigers")
] select ONL_snowTigersLoaded;

ONL_taruPodsVariants = [
	GET_UNIT_ARRAY("taruPods","vanilla"),
	GET_UNIT_ARRAY("taruPods","snowTigers")
] select ONL_snowTigersLoaded;

ONL_ifritVariants = [
	GET_UNIT_ARRAY("ifrits","vanilla"),
	GET_UNIT_ARRAY("ifrits","snowTigers")
] select ONL_snowTigersLoaded;

ONL_orca = [
	GET_SIMPLE_CLASS("orca","vanilla"),
	GET_SIMPLE_CLASS("orca","snowTigers")
] select ONL_snowTigersLoaded;

ONL_CSATHazmat_unitType = "O_T_Soldier_F";




ONL_startingVehicles = (getMissionLayerEntities "Starting Vehicles") select 0;

ONL_prePlacedVehicles = vehicles select {
	!(_x isKindOf "THING") AND
	{!(_x in ONL_startingVehicles)}
};


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


// arrays of eden entities
#include "..\..\headers\entityGroups.hpp";

//ONL_newsSounds = getMissionConfigValue "newsSounds";
//ONL_usedNewsSounds = [];

/* ----------------------------------------------------------------------------
	Music
---------------------------------------------------------------------------- */
private _musicType = ["CCM","NONE"/*,"KISKA"*/] select (["MusicType",0] call BIS_fnc_getParamValue);
if (_musicType != "None") then {
	if (_musicType == "CCM") then {
		ONL_CCMLoaded = true;
		ONL_randomMusicTracks = getArray(missionConfigFile >> "Music_Tracks" >> "ONL_randomMusicTracksCCM");
		ONL_KISKAMusicLoaded = false;

	} else {
		ONL_KISKAMusicLoaded = true;
		ONL_randomMusicTracks = getArray(missionConfigFile >> "Music_Tracks" >> "ONL_randomMusicTracksKISKA");
		ONL_CCMLoaded = false;

	};

} else {
	ONL_CCMLoaded = false;
	ONL_randomMusicTracks = [];
	ONL_KISKAMusicLoaded = false;

};
