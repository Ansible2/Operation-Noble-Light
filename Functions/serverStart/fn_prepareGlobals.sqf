if (!isServer) exitWith {};

// check optional mods
ONL_snowTigersLoaded = ["IP_CSAT_ST"] call KISKA_fnc_isPatchLoaded;
ONL_CUPVehiclesLoaded = ["CUP_Vehicles_Core"] call KISKA_fnc_isPatchLoaded;
ONL_RHSUSFVehiclesLoaded = ["rhsusf_cars"] call KISKA_fnc_isPatchLoaded;
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


////// Prepare music globals
ONL_CCMLoaded = ["CCM_music"] call KISKA_fnc_isPatchLoaded;
ONL_KISKAMusicLoaded = ["KISKA_music"] call KISKA_fnc_isPatchLoaded;