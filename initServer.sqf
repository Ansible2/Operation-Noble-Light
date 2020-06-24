#include "headers\taskGlobals.hpp";
#include "headers\spawnPositions.hpp";
#include "headers\musicTracks.hpp";
#include "headers\unitTypes.hpp";
#include "headers\unitLoadouts.hpp";
#include "headers\entityGroups.hpp";
#include "headers\newsSounds.hpp";

[[[ONL_redGroup],[ONL_blueGroup]]] call KISKA_fnc_initializeRespawnSystem;

// prepare all the global variables to account for different mods
call ONL_fnc_prepareGlobals;

// Server Event Calls and loop Starts
call ONL_fnc_baseEvents;
call ONL_fnc_blackSiteEvents;
call ONL_fnc_caveEvents;
call ONL_fnc_miscEvents;
call ONL_fnc_villageEvents;
call ONL_fnc_extractionEvents;

// place all static vehicles and the ones the players can choose from at the start
call ONL_fnc_startingVehiclesInit;
call ONL_fnc_placeVehicles;

// add arsenals
[[ONL_arsenal_1,ONL_arsenal_2,ONL_arsenal_3]] call KISKA_fnc_addArsenal;

// start audio effects at start base
call ONL_fnc_startingBaseAudio;

// inittial Task
[true,SecureApollo_TaskID,"SecureApollo_TaskInfo",ONL_ApolloFiles,"ASSIGNED",5,true,"MEET",false] call BIS_fnc_taskCreate;

// spawn most enemy units
call ONL_fnc_spawnUnitsMaster;

// for plane at start
ONL_cargoPlane flyInHeight 500; 

call ONL_fnc_startServerLoops;

// create a respawn at the airfield
ONL_airfieldRespawn = [missionNamespace,getPosATL ONL_airfieldRespawn_Logic,"Airfield Respawn"] call BIS_fnc_addRespawnPosition;

// distribute AI amongst headless client(s) save for some groups
KISKA_hcExcluded = [ONL_cargoPlaneGroup,ONL_extractHeli_group,ONL_extractHeliTurrets_group,ONL_redGroup,ONL_blueGroup];
// exclude units from save
KISKA_hcExcluded apply {
	_x setVariable ["ONL_saveExcluded",true];
};

// make civ triggers less intensive
[ONL_blackSiteCiv_Trigger,ONL_lodgingCiv_Trigger,ONL_facilityCiv_trigger,ONL_caveChemLights_trigger] apply {
	_x setTriggerInterval 2;
};

uiSleep 30;

[] spawn KISKA_fnc_balanceHeadless;

// reassign loadouts for vanilla
if (!ONL_CUPUnitsLoaded AND {!(ONL_loadSave)}) then {
	uiSleep 100;
	["ONL_",ONL_PMCUnits] spawn KISKA_fnc_assignUnitLoadout;
};