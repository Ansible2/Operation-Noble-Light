/* ----------------------------------------------------------------------------
Function: ONL_fnc_addServerEvents

Description:
	This adds CBA events and general eventHandlers to the server.
	These CBA events were used for certain "insignificant" things I did not want functions for and more so are reactions to players.

	You'll see several if statements wrapping events with globals ending in '_skip'.
	These are used to track if an event has fired in order to have it be null when loading a save.

	It is executed from the "initServer.sqf".

Parameters:
	NONE

Returns:
	Nothing

Examples:
    (begin example)
		call ONL_fnc_addServerEvents
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
if (!isServer) exitWith {false};

/* ----------------------------------------------------------------------------

	BASE

---------------------------------------------------------------------------- */
// destroy coms
if !(missionNamespace getVariable ["ONL_comsAlive_skip",false]) then {
	ONL_comRelay addMPEventHandler ["MPKilled", {
		if (isServer) then {
			["ONL_DestroyBaseComs_task"] call KISKA_fnc_endTask;

			ONL_skipLoopsAndEvents pushBack "ONL_comsAlive_skip";
		};
	}];
};




/* ----------------------------------------------------------------------------

	BLACK SITE

---------------------------------------------------------------------------- */
// Black Site Server Destruction
if !(missionNamespace getVariable ["ONL_blackSiteServersDestroyed_skip",false]) then {
	ONL_blackSiteServers apply {
		_x addMPEventHandler ["MPKilled", {
			if (isServer) then {
				private _destroyedServersCount_plusOne = (missionNamespace getVariable ["ONL_blackSite_destroyedServers_count",0]) + 1;

				if (_destroyedServersCount_plusOne isEqualTo ONL_blackSite_destroyableServers_count) then {
					["ONL_DestroyBlackSiteServers_task"] call KISKA_fnc_endTask;

					ONL_skipLoopsAndEvents pushBack "ONL_blackSiteServersDestroyed_skip";
					////////////SaveGame/////////////
					call ONL_fnc_saveQuery;
					////////////SaveGame/////////////

				} else {
					ONL_blackSite_destroyedServers_count = _destroyedServersCount_plusOne;

				};
			};
		}];
	};
};




/* ----------------------------------------------------------------------------

	CAVE

---------------------------------------------------------------------------- */
// Destroy cave generators EHs and sound
ONL_caveGenerators apply {
	_x addMPEventHandler ["MPKilled", {
		if (isServer) then {
			if (missionNamespace getVariable ["ONL_cave_GeneratorDeadCount",0] isEqualTo 0) then {
				ONL_cave_GeneratorDeadCount = 1;

			} else {
				[] spawn ONL_fnc_shutOffLights;

			};
		};

	}];
};



// Cave Server Destruction
if !(missionNamespace getVariable ["ONL_caveServersDestroyed_skip",false]) then {
	ONL_caveServers apply {
		_x addMPEventHandler ["mpKilled", {
			if (isServer) then {
				private _destroyedServersCount_plusOne = (missionNamespace getVariable ["ONL_cave_destroyedServers_count",0]) + 1;

				if (_destroyedServersCount_plusOne isEqualTo ONL_cave_destroyableServers_count) then {
					["ONL_DestroyCaveServers_Task"] call KISKA_fnc_endTask;

					ONL_skipLoopsAndEvents pushBack "ONL_caveServersDestroyed_skip";
					////////////SaveGame/////////////
					call ONL_fnc_saveQuery;
					////////////SaveGame/////////////
				} else {
					ONL_cave_destroyedServers_count = _destroyedServersCount_plusOne;
				};
			};
		}];
	};
};



// Destroy cave devices
if !(missionNamespace getVariable ["ONL_caveDevicesDestroyed_skip",false]) then {
	ONL_caveDevices apply {
		_x addMPEventHandler ["MPKilled", {
			if (isServer) then {
				if (missionNamespace getVariable ["ONL_cave_devicesDead",0] isEqualTo 0) then {
					ONL_cave_devicesDead = 1;

				} else {
					["ONL_DestroyTheDevices_task"] call KISKA_fnc_endTask;

					ONL_skipLoopsAndEvents pushBack "ONL_caveDevicesDestroyed_skip";
					////////////SaveGame/////////////
					call ONL_fnc_saveQuery;
					////////////SaveGame/////////////

				};
			};
		}];
	};
};


// Dead scientist EH
if !(missionNamespace getVariable ["ONL_scientistDead_skip",false]) then {
	ONL_headScientist addMPEventHandler ["MPKilled", {
		if (isServer) then {
			["ONL_findHeadScientist_task"] call KISKA_fnc_endTask;

			ONL_skipLoopsAndEvents pushBack "ONL_scientistDead_skip";
			call ONL_fnc_extraction_init;
			////////////SaveGame/////////////
			call ONL_fnc_saveQuery;
			////////////SaveGame/////////////
		};
	}];
};



/* ----------------------------------------------------------------------------

	MISC

---------------------------------------------------------------------------- */
// saving dead pre placed vics
ONL_prePlacedVehicles apply {
	_x addMPEventHandler ["MPKILLED",{
		params ["_unit"];

		if (isServer) then {
			private _index = ONL_prePlacedVehicles find _x;
			ONL_deadVehicleIndexes pushBack _index;
		};
	}];
};


true
