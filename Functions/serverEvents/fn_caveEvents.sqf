if !(isServer) exitWith {};

// Destroy cave generators EHs and sound

private _caveGenerators = 
((getMissionLayerEntities "Cave Generators") select 0) apply {
	_x addEventHandler ["Killed", { 
		if (missionNamespace getVariable ["ONL_cave_GeneratorDeadCount",0] isEqualTo 0) then {
			ONL_cave_GeneratorDeadCount = 1;
		} else {
			[] spawn ONL_fnc_shutOffLights;
			
			ONL_Cave_generatorShutOff_Event_ID call CBA_fnc_removeEventHandler;
		};
	}];
};


// cave generator shutoff event
private _id = [
	"ONL_Cave_generatorShutOff_Event",
	{
		params [
			["_generator",objNull,[objNull]]
		];
		
		["OMLightSwitch",_generator,50,2] call KISKA_fnc_playSound3D;

		_generator setVariable ["ONL_genOff",true,true];

		if (missionNamespace getVariable ["ONL_cave_GeneratorDeadCount",0] isEqualTo 0) then {
			ONL_cave_GeneratorDeadCount = 1;
		} else {
			[] spawn ONL_fnc_shutOffLights;

			ONL_Cave_generatorShutOff_Event_ID call CBA_fnc_removeEventHandler;
		};
	}
] call CBA_fnc_addEventHandler;
ONL_Cave_generatorShutOff_Event_ID = ["ONL_Cave_generatorShutOff_Event",_id]; // so the event handler can be deleted



// Cave Server Destruction
ONL_cave_destroyableServers_count = count ONL_caveServers;

ONL_caveServers apply {
	_x addEventHandler ["Killed", {
		private _destroyedServersCount_plusOne = (missionNamespace getVariable ["ONL_cave_destroyedServers_count",0]) + 1;

		if (_destroyedServersCount_plusOne isEqualTo ONL_cave_destroyableServers_count) then {
			[DestroyCaveServers_TaskID,"DestroyCaveServers_TaskInfo"] call KISKA_fnc_setTaskComplete;
		} else {
			ONL_cave_destroyedServers_count = _destroyedServersCount_plusOne;
		};	
	}];
};



// Collect Cave Intel Event
ONL_cave_collectableIntel_count = count ONL_caveCollectDevices;

private _id1 = [
	"ONL_Cave_CollectedIntel_Event",
	{
		params [
			["_intelObject",objNull,[objNull]]
		];
		
		deleteVehicle _intelObject;

		private _collectedIntelCount_plusOne = (missionNamespace getVariable ["ONL_cave_collectedIntel_count",0]) + 1;

		if (_collectedIntelCount_plusOne isEqualTo ONL_cave_collectableIntel_count) then {
			[CollectCaveData_TaskID,"CollectCaveData_TaskInfo"] call KISKA_fnc_setTaskComplete;
			ONL_Cave_CollectedIntel_Event_ID call CBA_fnc_removeEventHandler;
		} else {
			ONL_cave_collectedIntel_count = _collectedIntelCount_plusOne;
		};
	}
] call CBA_fnc_addEventHandler;
ONL_Cave_generatorShutOff_Event_ID = ["ONL_Cave_CollectedIntel_Event",_id1];



// Destroy cave device
ONL_caveDevices apply {
	_x addEventHandler ["Killed", { 
		if (missionNamespace getVariable ["ONL_cave_devicesDead",0] isEqualTo 0) then {
			ONL_cave_devicesDead = 1;
		} else {
			[DestroyTheDevices_TaskID,"DestroyTheDevices_TaskInfo"] call KISKA_fnc_setTaskComplete;
		};
	}];
};



// Entered Facility Event
private _id2 = [
	"ONL_Cave_entered_Event",
	{
		ONL_Cave_entered_EventID call CBA_fnc_removeEventHandler;

		call ONL_fnc_waitToAddCaveTasks;

		// cave in charges timer begins
		[
			{
				["ONL_caveIn_event"] call CBA_fnc_serverEvent;
			},
			[],
			60*15
		] call CBA_fnc_waitAndExecute;

		// wait to show units at end of tunnel and zombies
		[
			1,
			{
				[((getMissionLayerEntities "CaveAI") select 0),true,true] call KISKA_fnc_showHide;
			},
			{!(((call CBA_fnc_players) findIf {(_x distance2D ONL_logic_cave_3) < 10}) isEqualTo -1)}
		] call KISKA_fnc_waitUntil;

		// start music
		call ONL_fnc_caveMusic;

		// turn on generator audio
		((getMissionLayerEntities "Cave Generators") select 0) apply {
			[_x] spawn {

				params ["_gen"];

				while {alive _gen AND {!(_gen getVariable ["ONL_genOff",false])}} do {

					playSound3D ["A3\Missions_F_Oldman\Data\sound\Energy_Hum\Energy_Hum_Loop.wss",_gen,true,getPosASL _gen,1,1,50];

					sleep 8.5;
				};
			};
		};
	}
] call CBA_fnc_addEventHandler;
ONL_Cave_entered_EventID = ["ONL_Cave_entered_Event",_id2]; // so the event handler can be deleted



// Dead scientist EH
ONL_headScientist addEventHandler ["Killed", { 
	[FindHeadScientist_TaskID,"FindHeadScientist_TaskInfo"] call KISKA_fnc_setTaskComplete;

	["ONL_getToExtraction_Event"] call CBA_fnc_serverEvent;
}];



// cave in event
private _id3 = [
	"ONL_caveIn_event",
	{
		if (alive ONL_charge_1 OR {alive ONL_charge_2} OR {alive ONL_charge_3}) then {
			[ONL_charge_1,ONL_charge_2,ONL_charge_3] apply {
				if (alive _x) then {
					_x enableSimulationGlobal true;
					_x allowDamage true;
					_x setDamage 1;
				};
			};

			// remove defusal actions
			["ONL_charge_1_ID","ONL_charge_2_ID","ONL_charge_3_ID"] apply {
				["ONL_removeDefusalAction_Event",[_x],(call CBA_fnc_players)] call CBA_fnc_targetEvent;
			};
	
			sleep 1;
			
			// show rock cave in
			((getMissionLayerEntities "Cave In") select 0) apply {
				_x hideObjectGlobal false;
			};
			
		};

		ONL_caveIn_EventID call CBA_fnc_removeEventHandler;
	}
] call CBA_fnc_addEventHandler;
ONL_caveIn_EventID = ["ONL_caveIn_event",_id3];



// device defused
private _id4 = [
	"ONL_deviceDefused_event",
	{
		params [
			["_charge",objNull,[objNull]],
			["_chargeGlobalName","",[""]]
		];

		deleteVehicle _charge;
		
		private _defusedCharges_plusOne = (missionNamespace getVariable ["ONL_defusedCharges_count",0]) + 1;

		if (_defusedCharges_plusOne isEqualTo 3) then {
			//[CollectCaveData_TaskID,"CollectCaveData_TaskInfo"] call Kiska_fnc_setTaskComplete; // need a defuse charges task
			ONL_deviceDefused_eventID call CBA_fnc_removeEventHandler;
		} else {
			ONL_defusedCharges_count = _defusedCharges_plusOne;

			["ONL_removeDefusalAction_Event",[_chargeGlobalName],(call CBA_fnc_players)] call CBA_fnc_targetEvent;
		};
	}
] call CBA_fnc_addEventHandler;
ONL_deviceDefused_eventID = ["ONL_deviceDefused_event",_id4];