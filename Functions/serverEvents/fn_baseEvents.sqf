if !(isServer) exitWith {};

// destroy coms
ONL_comRelay addEventHandler ["Killed", {
	[DestroyComs_TaskID,"DestroyComs_TaskInfo"] call Kiska_fnc_setTaskComplete;
}];

// read file
private _id = [
	"ONL_base_readFile_Event",
	{
		params [
			["_file",objNull,[objNull]]
		];

		[_file] remoteExec ["deleteVehicle",_file];

		[CollectBaseIntel_TaskID,"CollectBaseIntel_TaskInfo"] call Kiska_fnc_setTaskComplete;

		if !([SearchLodging_TaskID] call BIS_fnc_taskCompleted) then {
			[true,SearchLodging_TaskID,"SearchLodging_TaskInfo",objNull,"AUTOASSIGNED",5,true,"SEARCH",false] call BIS_fnc_taskCreate;
		};
		 
		ONL_base_readFile_EventID call CBA_fnc_removeEventHandler;
	}
] call CBA_fnc_addEventHandler;
ONL_base_readFile_EventID = ["ONL_base_readFile_Event",_id];