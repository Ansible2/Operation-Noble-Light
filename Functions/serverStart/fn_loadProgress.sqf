(profileNamespace getVariable "ONL_saveData") params [
	"_vehicleSaveInfoArray",
	"_savedGroupsInfoArray",
	"_completedTasks",
	"_specialSaveData",
	"_dependencies"
];

// check dependencies and exit to new game if not all present in same way
private _activeDependencies = [ONL_snowTigersLoaded,ONL_CUPVehiclesLoaded,ONL_RHSUSFVehiclesLoaded,ONL_CUPUnitsLoaded,ONL_FSGLoaded];
if !(_activeDependencies isEqualTo _dependencies) exitWith {
	ONL_loadSave = false;

	[
		{
			["WARNING: SAVE NOT FOUND, NEW GAME STARTED"] remoteExec ["KISKA_fnc_dataLinkMsg",allPlayers,true];
		},
		[],
		15
	] call CBA_fnc_waitAndExecute;

	call ONL_fnc_spawnUnitsVillage;

	call ONL_fnc_spawnUnitsCave;

	call ONL_fnc_spawnUnitsLodging;

	call ONL_fnc_spawnUnitsBlacksite;

	call ONL_fnc_spawnUnitsBase;

	call ONL_fnc_spawnUnitsFacility;
};