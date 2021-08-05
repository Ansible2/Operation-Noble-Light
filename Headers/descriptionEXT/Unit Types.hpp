class Mission_unitTypes
{
    // unit type arrays used to randomly select from their strings during spawns
    class ClassArrays
    {
        class tempest
        {
            vanilla[] = {
            	"O_T_Truck_03_covered_ghex_F",
            	"O_T_Truck_03_transport_ghex_F",
            	"O_T_Truck_03_repair_ghex_F",
            	"O_T_Truck_03_medical_ghex_F",
            	"O_T_Truck_03_fuel_ghex_F",
            	"O_T_Truck_03_ammo_ghex_F"
            };

            snowTigers[] = {
            	"IP_O_Truck_03_transport_FST",
            	"IP_O_Truck_03_repair_FST",
            	"IP_O_Truck_03_fuel_FST",
            	"IP_O_Truck_03_ammo_FST"
            };
        };

        class taruPods
        {
            vanilla[] = {
            	"Land_Pod_Heli_Transport_04_box_F",
            	"Land_Pod_Heli_Transport_04_fuel_F",
            	"Land_Pod_Heli_Transport_04_repair_F"
            };
            snowTigers[] = {
            	"IP_O_Land_Pod_Heli_Transport_04_box_FST",
            	"IP_O_Land_Pod_Heli_Transport_04_fuel_FST",
            	"IP_O_Land_Pod_Heli_Transport_04_repair_FST"
            };
        };

        class ifrits
        {
            vanilla[] = {
            	"O_T_MRAP_02_hmg_ghex_F",
            	"O_T_MRAP_02_gmg_ghex_F",
            	"O_T_MRAP_02_ghex_F"
            };
            snowTigers[] = {
            	"IP_O_MRAP_02_FST",
            	"IP_O_MRAP_02_gmg_FST",
            	"IP_O_MRAP_02_hmg_FST"
            };
        };

        class pmc_units
        {
            CUP[] = {
            	"CUP_I_PMC_Winter_Sniper",
            	"CUP_I_PMC_Winter_Medic",
            	"CUP_I_PMC_Winter_Soldier_MG",
            	"CUP_I_PMC_Winter_Soldier_MG_PKM",
            	"CUP_I_PMC_Winter_Soldier_AT",
            	"CUP_I_PMC_Winter_Engineer",
            	"CUP_I_PMC_Winter_Soldier_M4A3",
            	"CUP_I_PMC_Winter_Soldier",
            	"CUP_I_PMC_Winter_Soldier_GL",
            	"CUP_I_PMC_Winter_Crew",
            	"CUP_I_PMC_Winter_Sniper_KSVK",
            	"CUP_I_PMC_Winter_Soldier_AA",
            	"CUP_I_PMC_Winter_Soldier_TL"
            };
            vanilla[] = {
            	"I_E_Soldier_TL_F",
            	"I_E_Soldier_SL_F",
            	"I_E_Soldier_LAT_F",
            	"I_E_Soldier_F",
            	"I_E_RadioOperator_F",
            	"I_E_Soldier_Pathfinder_F",
            	"I_E_Soldier_AT_F",
            	"I_E_soldier_M_F",
            	"I_E_Soldier_Exp_F",
            	"I_E_Engineer_F",
            	"I_E_Medic_F",
            	"I_E_Soldier_AR_F"
            };
        };

        class csat_units
        {
            snowTigers[] = {
            	"IP_O_Soldier_A_FST",
            	"IP_O_Soldier_AAR_FST",
            	"IP_O_Soldier_AAA_FST",
            	"IP_O_Soldier_AAT_FST",
            	"IP_O_Soldier_AR_FST",
            	"IP_O_Medic_FST",
            	"IP_O_Engineer_FST",
            	"IP_O_Soldier_exp_FST",
            	"IP_O_Soldier_GL_FST",
            	"IP_O_HeavyGunner_FST",
            	"IP_O_Soldier_M_FST",
            	"IP_O_Soldier_AA_FST",
            	"IP_O_Soldier_AT_FST",
            	"IP_O_Soldier_repair_FST",
            	"IP_O_Soldier_FST",
            	"IP_O_Soldier_LAT_FST",
            	"IP_O_Soldier_lite_FST",
            	"IP_O_Sharpshooter_FST",
            	"IP_O_Soldier_SL_FST",
            	"IP_O_Soldier_TL_FST"
            };
            vanilla[] = {
            	"O_T_Soldier_AR_F",
            	"O_T_Medic_F",
            	"O_T_Engineer_F",
            	"O_T_Soldier_Exp_F",
            	"O_T_Soldier_M_F",
            	"O_T_Soldier_AT_F",
            	"O_T_Soldier_F",
            	"O_T_Soldier_LAT_F",
            	"O_T_Soldier_SL_F",
            	"O_T_Soldier_TL_F"
            };
        };

        class spetsnaz_sf_units
        {
            // spetsnaz recon
            foxhound[] = {
            	"fsg_o_sf_operator_3",
            	"fsg_o_sf_operator_1",
            	"fsg_o_sf_operator_2",
            	"fsg_o_sf_squadleader",
            	"fsg_o_sf_teamleader"
            };
            vanilla[] = {
            	"O_R_recon_TL_F",
            	"O_R_recon_AR_F",
            	"O_R_recon_exp_F",
            	"O_R_recon_JTAC_F",
            	"O_R_recon_M_F",
            	"O_R_recon_medic_F",
            	"O_R_recon_LAT_F"
            };
        };
        class spetsnaz_regular_units
        {
            foxhound[] = {
            	"fsg_o_regular_at",
            	"fsg_o_regular_grenadier",
            	"fsg_o_regular_mg",
            	"fsg_o_regular_medic",
            	"fsg_o_regular_rifleman_1",
            	"fsg_o_regular_rifleman_2",
            	"fsg_o_regular_rifleman_3",
            	"fsg_o_regular_sniper",
            	"fsg_o_regular_squadleader"
            };
            vanilla[] = {
            	"O_R_Soldier_AR_F",
            	"O_R_medic_F",
            	"O_R_soldier_exp_F",
            	"O_R_JTAC_F",
            	"O_R_soldier_M_F",
            	"O_R_Soldier_LAT_F",
            	"O_R_Soldier_TL_F"
            };
        };

        class csat_vehicle_types
        {
            // weighted array for end waves
            snowTigers[] = {
            	"IP_O_MRAP_02_hmg_FST",0.30,
            	"IP_O_MRAP_02_gmg_FST",0.20,
            	"IP_O_MBT_02_cannon_FST",0.15,
            	"IP_O_APC_Tracked_02_cannon_FST",0.20,
            	"IP_O_APC_Wheeled_02_rcws_FST",0.20
            };
            vanilla[] = {
            	"O_T_MRAP_02_hmg_ghex_F",0.30,
            	"O_T_MRAP_02_gmg_ghex_F",0.20,
            	"O_T_MBT_04_command_F",0.15,
            	"O_T_APC_Tracked_02_cannon_ghex_F",0.20,
            	"O_T_APC_Wheeled_02_rcws_v2_ghex_F",0.20
            };
        };


        ONL_CSATViper_unitTypes[] = {
        	"O_V_Soldier_Exp_ghex_F",
        	"O_V_Soldier_JTAC_ghex_F",
        	"O_V_Soldier_M_ghex_F",
        	"O_V_Soldier_ghex_F",
        	"O_V_Soldier_Medic_ghex_F",
        	"O_V_Soldier_LAT_ghex_F",
        	"O_V_Soldier_TL_ghex_F"
        };

        // CSAT with masks
        ONL_CSATMask_unitTypes[] = {
        	"O_T_Recon_F",
        	"O_T_Recon_TL_F",
        	"O_T_Recon_Exp_F"
        };

    };

    class SimpleClasses
    {
        class csat_crewman
        {
            vanilla = "O_T_Crew_F";
            snowTigers = "IP_O_crew_FST";
        };
        class csat_tank
        {
            vanilla = "O_T_MBT_02_cannon_ghex_F";
            snowTigers = "IP_O_MBT_02_cannon_FST";
        };
        class csat_apc_wheeled
        {
            vanilla = "O_T_APC_Wheeled_02_rcws_v2_ghex_F";
            snowTigers = "IP_O_APC_Wheeled_02_rcws_FST";
        };
        class csat_apc_tracked
        {
            vanilla = "O_T_APC_Tracked_02_cannon_ghex_F";
            snowTigers = "IP_O_APC_Tracked_02_cannon_FST";
        };
        class csat_attackHeli
        {
            vanilla = "O_Heli_Attack_02_dynamicLoadout_F";
            snowTigers = "IP_O_Heli_Attack_02_SnowHex_FST";
        };
        class orca
        {
            vanilla = "O_Heli_Light_02_unarmed_F";
            snowTigers = "IP_O_Heli_Light_02_unarmed_FST";
        };
        class pmc_gunTruck
        {
            vanilla = "I_G_Offroad_01_armed_F";
            CUP = "CUP_I_RG31E_M2_W_ION";
        };
        class spetsnaz_apc
        {
            vanilla = "I_APC_Wheeled_03_cannon_F";
            foxhound = "fsg_btr_1";
        };
        class spetsnaz_armedCar
        {
            vanilla = "I_G_Offroad_01_armed_F";
            foxhound = "fsg_tigr_2";
        };
        class spetsnaz_car
        {
            vanilla = "C_Offroad_01_comms_F";
            foxhound = "fsg_tigr_1";
        };
        class spetsnaz_crewman
        {
            vanilla = "O_R_Patrol_Soldier_Engineer_F";
            foxhound = "fsg_o_regular_crewman";
        };
        class spetsnaz_helicopter
        {
            vanilla = "O_Heli_Light_02_unarmed_F";
        };
    };

};
