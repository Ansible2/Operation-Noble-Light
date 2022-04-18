/* ----------------------------------------------------------------------------
Function: ONL_fnc_village_collectedIntel

Description:
    Acts as a server event when collecting intel at the village

Parameters:
	0: _intelObject <OBJECT> - The collected intel object

Returns:
	NOTHING

Examples:
    (begin example)
		[intelObject] remoteExec ["ONL_fnc_village_collectedIntel",2];
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "ONL_fnc_village_collectedIntel";

#define SAVE_VAR_STR "ONL_collectedVillageIntel_skip"

if (missionNamespace getVariable [SAVE_VAR_STR,false]) exitWith {};
if (!isServer) exitWith {
    ["Needs to be executed on the server, remoting on server now...",true] call KISKA_fnc_log;
    _this remoteExec ["ONL_fnc_village_collectedIntel",2];
    nil
};


params [
    ["_intelObject",objNull,[objNull]]
];

if !(isNull _intelObject) then {
    deleteVehicle _intelObject;
};


ONL_skipLoopsAndEvents pushBack SAVE_VAR_STR;

remoteExec ["ONL_fnc_village_spawnReinforcements",2];


["ONL_secureApollo_task"] call KISKA_fnc_endTask;
["ONL_investigateBlacksite_task"] call KISKA_fnc_createTaskFromConfig;
["ONL_collectBlackSiteIntel_task"] call KISKA_fnc_createTaskFromConfig;
["ONL_findHeadScientist_task"] call KISKA_fnc_createTaskFromConfig;

// check if coms were already destroyed to create task or not
if !(["ONL_DestroyBaseComs_task"] call BIS_fnc_taskExists) then {
    [
        {
            if !(["ONL_CollectBaseIntel_task"] call BIS_fnc_taskExists) then {
                ["Recommend you knock out CSAT long range coms before kicking the hornets nest. BREAK"] remoteExec ["KISKA_fnc_DataLinkMsg",ONL_allClientsTargetID];
                ["The relay is located at GRID 142-035",4,false] remoteExec ["KISKA_fnc_DataLinkMsg",ONL_allClientsTargetID];

                ["ONL_CollectBaseIntel_task"] call KISKA_fnc_createTaskFromConfig;
            };

            ["ONL_DestroyBaseComs_task"] call KISKA_fnc_createTaskFromConfig;

            ////////////SaveGame/////////////
            call ONL_fnc_saveQuery;
            ////////////SaveGame/////////////

        },
        [],
        30
    ] call CBA_fnc_waitAndExecute;
};


nil
