/* ----------------------------------------------------------------------------
Function: ONL_fnc_studyObject

Description:
    Checks unique objects after being studied to see if tasks should be completed.

Parameters:
	0: _config <CONFIG> - The config to search for the array of loadouts in
	1: _units <ARRAY, GROUP, or OBJECT> - The unit(s) to apply the function to

Returns:
	NOTHING

Examples:
    (begin example)
		[someObject] remoteExec ["ONL_fnc_studyObject",2];
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "ONL_fnc_studyObject";

#define DEVICE_TYPES ["land_device_disassembled_f","land_device_assembled_f"]
#define GLOWING_ROCK_TYPE "land_w_sharpstone_02"

if (!isServer) exitWith {
    ["Needs to be executed on the server, remoting on server now...",true] call KISKA_fnc_log;
    _this remoteExec ["ONL_fnc_studyObject",2];
    nil
};

params [
    ["_studiedObject",objNull,[objNull]]
];


// ensure no one else has the action
_studiedObject setVariable ["ONL_wasStudied",true,ONL_allClientsTargetID];
private _typeOfObject = toLowerANSI (typeOf _studiedObject);


// checking if it was a device
if (_typeOfObject in DEVICE_TYPES) exitWith {
    if (missionNamespace getVariable ["ONL_deviceLogsCollected",0] isEqualTo 0) then {
        ONL_deviceLogsCollected = 1;

    } else {
        ["ONL_CollectDeviceLogs_Task"] call KISKA_fnc_endTask;

    };

    nil
};


// check if the object was the rock at the black site
if (_typeOfObject == GLOWING_ROCK_TYPE) exitWith {
    ["ONL_CollectRockSample_task"] call KISKA_fnc_endTask;
    nil

};



if (_studiedObject isEqualTo ONL_lodgingLaptop) exitWith {
    ["OMIntelGrabLaptop_01",ONL_lodgingLaptop,50,2] call KISKA_fnc_playSound3D;
    ["ONL_SearchLodging_task"] call KISKA_fnc_endTask;
    ["ONL_InvestigateFacility_task"] call KISKA_fnc_createTaskFromConfig;

    nil
};



if (_studiedObject isEqualTo ONL_caveTankComputer) exitWith {
    ["OMIntelGrabLaptop_02",ONL_caveTankComputer,50,2] call KISKA_fnc_playSound3D;
    nil
};


nil
