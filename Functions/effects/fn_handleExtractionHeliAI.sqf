#define KISKA_LOG(MESSAGE) ["ONL_fnc_handleExtractionHeliAI",MESSAGE] call KISKA_fnc_log;

//[ONL_extractHeliPilots_group,getPosASL ONL_extractionHelipad,-1,"MOVE","SAFE","BLUE","FULL"] call CBA_fnc_addWaypoint;
sleep 1;
[ONL_extractHeli,ONL_extractionHelipad] call KISKA_fnc_heliLand;
//null = [ONL_extractHeliPilots_group, position ONL_extractionHelipad, ONL_extractionHelipad] spawn BIS_fnc_wpLand;

ONL_extractHeliPilots_group setBehaviour "SAFE";
ONL_extractHeliPilots_group setCombatMode "BLUE";
(units ONL_extractHeliPilots_group) apply {
	_x disableAI "TARGET";
	_x disableAI "AUTOTARGET";
	_x disableAI "AUTOCOMBAT";
};

ONL_extractHeliTurrets_group setBehaviour "AWARE";
ONL_extractHeliTurrets_group setCombatMode "RED";

private _doorGunners = units ONL_extractHeliTurrets_group;
_doorGunners apply {
	_x setSkill 1;
};

waitUntil {
	sleep 1;
	ONL_extractHeli distance2D ONL_extractionHelipad <= 500
};

/*
private _vehicleTargets = ONL_extractionHelipad nearEntities [["Car","Tank"],750];
_vehicleTargets = _vehicleTargets select {(side _x) isEqualTo OPFOR};
["ONL_fnc_handleExtractionHeliAI",["Vehicles Found:",_vehicleTargets]] call KISKA_fnc_log;

if !(_vehicleTargets isEqualTo []) then {
	// don't want to shoot too close to extract
	private _index = _vehicleTargets findIf {_x distance2D ONL_extractionHelipad > 100};
	if (_index != -1) then {
		private _target = _vehicleTargets select _index;
		_target sendSimpleCommand "STOP";
		null = [_target,2,random [0,10,20]] spawn KISKA_fnc_CAS;
	};
};
*/

private _manTargets = ONL_extractionHelipad nearEntities ["Man",500];
_manTargets = _manTargets select {(side _x) isEqualTo OPFOR};
["ONL_fnc_handleExtractionHeliAI",["Men Found:",_manTargets]] call KISKA_fnc_log;
if !(_manTargets isEqualTo []) then {
	// don't want to shoot too close to extract
	private _index = _manTargets findIf {_x distance2D ONL_extractionHelipad > 100};
	private "_target";
	if (_index != -1) then {
		_target = _manTargets deleteAt _index;
		null = [_target,0,random [0,10,20]] spawn KISKA_fnc_CAS;
	};

	sleep (round random [3,5,7]);

	_index = _manTargets findIf {_x distance2D ONL_extractionHelipad > 100 AND {!(group _target isEqualTo group _x)}};
	if (_index != -1) then {
		_target = _manTargets deleteAt _index;
		null = [_target,2,random [0,10,20]] spawn KISKA_fnc_CAS;
	};
};