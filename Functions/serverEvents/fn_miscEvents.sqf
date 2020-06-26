if !(isServer) exitWith {};

// Was studied Event
[
	"ONL_wasStudied_Event",
	{
		params [
			["_studiedObject",objNull,[objNull]]
		];
		
		// ensure no one else has the action
		_studiedObject setVariable ["ONL_wasStudied",true,[0,-2] select isDedicated];
		private _typeOfObject = typeOf _studiedObject;

		// checking if it was a device
		if (_typeOfObject isEqualTo "Land_Device_disassembled_F" OR {_typeOfObject isEqualTo "Land_Device_assembled_F"}) exitWith {
			if (missionNamespace getVariable ["ONL_deviceLogsCollected",0] isEqualTo 0) then {
				ONL_deviceLogsCollected = 1;
			} else {
				[CollectDeviceLogs_TaskID,"CollectDeviceLogs_TaskInfo"] call KISKA_fnc_setTaskComplete;
			};
		};

		// check if the object was the rock at the black site
		if (_typeOfObject isEqualTo "Land_W_sharpStone_02") exitWith {
			[CollectRockSample_TaskID,"CollectRockSample_TaskInfo"] call KISKA_fnc_setTaskComplete;
		};

		if (_studiedObject isEqualTo ONL_lodgingLaptop) exitWith {
			["OMIntelGrabLaptop_01",ONL_lodgingLaptop,50,2] call KISKA_fnc_playSound3D;

			[SearchLodging_TaskID,"SearchLodging_TaskInfo"] call KISKA_fnc_setTaskComplete;

			if !([InvestigateFacility_TaskID] call BIS_fnc_taskExists) then {
				[true,InvestigateFacility_TaskID,"InvestigateFacility_TaskInfo",objNull,"AUTOASSIGNED",5,true,"SEARCH",false] call BIS_fnc_taskCreate;
			};
		};

		if (_studiedObject isEqualTo ONL_caveTankComputer) exitWith {
			["OMIntelGrabLaptop_02",ONL_caveTankComputer,50,2] call KISKA_fnc_playSound3D;
		};		
	}
] call CBA_fnc_addEventHandler;



// reset plane
[
	"ONL_resetPlane_Event",
	{
		private _position = getPosATL ONL_cargoPlane_resetLogic;
		private _vectorDir = vectorDir ONL_cargoPlane_resetLogic;
		private _vectorUp = vectorUp ONL_cargoPlane_resetLogic;

		ONL_cargoPlane setPosATL _position;

		[ONL_cargoPlane,[_vectorDir,_vectorUp]] remoteExec ["setVectorDirAndUp",ONL_cargoPlane];

		["Alarm",ONL_logic_startingBaseSpeaker_1,200,3] call KISKA_fnc_playSound3D;
	}
] call CBA_fnc_addEventHandler;


/*
// Spawn CSAT patrol events
[
	"ONL_spawnCSATPatrol_Event",
	{
		params [
			["_center",[0,0,0],[[],objNull]]
		];

		private _randomPosition = [_center,500] call CBA_fnc_randPos;

		private _group = [6,ONL_CSATVariants,opfor,_randomPosition] call KISKA_fnc_spawnGroup;

		[_group,_center,1000,5,"MOVE","SAFE","YELLOW","NORMAL","STAG COLUMN"] call CBA_fnc_taskPatrol;

	}
] call CBA_fnc_addEventHandler;
*/



// Supply drop 1
private _id = [
	"ONL_supplyDrop_1_Event",
	{
		params [
			["_classNames",[],[[]]],
			["_altittude",100,[1]],
			["_caller",objNull,[objNull]],
			["_radio",-1,[1]]
		];
		
		[_classNames,_altittude,_caller,_radio] remoteExec ["KISKA_fnc_supplyDrop",2];

		ONL_supplyDrop_1_EventID call CBA_fnc_removeEventHandler;
	}
] call CBA_fnc_addEventHandler;
ONL_supplyDrop_1_EventID = ["ONL_supplyDrop_1_Event",_id];


// Supply drop 2
private _id1 = [
	"ONL_supplyDrop_2_Event",
	{
		params [
			["_classNames",[],[[]]],
			["_altittude",100,[1]],
			["_caller",objNull,[objNull]],
			["_radio",-1,[1]]
		];
		
		[_classNames,_altittude,_caller,_radio] remoteExec ["KISKA_fnc_supplyDrop",2];

		ONL_supplyDrop_2_EventID call CBA_fnc_removeEventHandler;
	}
] call CBA_fnc_addEventHandler;
ONL_supplyDrop_2_EventID = ["ONL_supplyDrop_2_Event",_id1];