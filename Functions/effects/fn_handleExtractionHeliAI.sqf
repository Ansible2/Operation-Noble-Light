[
	ONL_extractHeli,
	ONL_extractionHelipad,
	"GET IN",
	false,
	{
		waituntil {
			sleep 1;
			private _alivePlayers = count (call KISKA_fnc_alivePlayers);
			((_alivePlayers > 0) AND {count (crew ONL_extractHeli) isEqualTo (4 + _alivePlayers)})
		};

		[
			_this select 0,
			ONL_extractHeliMove_Logic,
			"LAND",
			false
		] call KISKA_fnc_heliLand;

		[ONL_extractHeliPilots_group,ONL_extractHeliMove_Logic,-1,"MOVE","SAFE","BLUE","FULL"] call CBA_fnc_addWaypoint;
	}
] call KISKA_fnc_heliLand;

[ONL_extractHeli,5,4,650] spawn KISKA_fnc_engageHeliTurretsLoop;


waitUntil {
	sleep 1;
	ONL_extractHeli distance2D ONL_extractionHelipad <= 500
};


private _manTargets = ONL_extractionHelipad nearEntities ["Man",500];
_manTargets = _manTargets select {(side _x) isEqualTo OPFOR};

if (_manTargets isNotEqualTo []) then {
	// don't want to shoot too close to extract
	private _index = _manTargets findIf {_x distance2D ONL_extractionHelipad > 100};
	private "_target";
	if (_index != -1) then {
		_target = _manTargets deleteAt _index;
		[_target,0,random [0,10,20]] spawn KISKA_fnc_CAS;
	};

	sleep (round random [3,5,7]);

	_index = _manTargets findIf {_x distance2D ONL_extractionHelipad > 100 AND {!(group _target isEqualTo group _x)}};
	if (_index != -1) then {
		_target = _manTargets deleteAt _index;
		[_target,2,random [0,10,20]] spawn KISKA_fnc_CAS;
	};
};
