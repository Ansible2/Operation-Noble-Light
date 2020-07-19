[
    {!isNil "ONL_extractHeli"},
    {
        ONL_extractHeli addEventHandler ["Local", {
            params ["_helicopter", "_isLocal"];

            if (_isLocal) then {
                _helicopter allowDamage false;
                _helicopter setUnloadInCombat [false,false];
            };
        }];
    }
] call CBA_fnc_waitUntilAndExecute;

fn_respawnSM = {
	KISKA_respawnStateMachine = [[player]] call CBA_statemachine_fnc_create;

	// create a starting state to sit at while we wait for group and player to be defined
	_check1 = [KISKA_respawnStateMachine,{},{},{},"start_state"] call CBA_statemachine_fnc_addState;
	// dummy state to proceed to once player is ready, this is for easier mapping of the machine
	_check3 = [KISKA_respawnStateMachine,{},{diag_log "player and group ready";},{},"playerAndGroupReady_state"] call CBA_statemachine_fnc_addState;

	// checking if player and his group is defined first before moving to next state
	_check2 = [
		KISKA_respawnStateMachine,
		"start_state",
		"playerAndGroupReady_state",
		{!isNull player AND {!isNull (group player)}},
		{diag_log "player and group defined";}
	] call CBA_statemachine_fnc_addTransition;

	_check6 = [KISKA_respawnStateMachine,{},{diag_log "Proceeding from player is leader confirmation";},{},"playerIsLeader_state"] call CBA_statemachine_fnc_addState;
	_check11 = [KISKA_respawnStateMachine,{},{diag_log "Proceeding from player is NOT leader confirmation";},{},"playerIsNotLeader_state"] call CBA_statemachine_fnc_addState;
	_check9 = [KISKA_respawnStateMachine,{},{diag_log "Player given action";},{},"giveAction_state"] call CBA_statemachine_fnc_addState;
	_check14 = [KISKA_respawnStateMachine,{},{diag_log "Action deleted";},{},"deleteAction_state"] call CBA_statemachine_fnc_addState;

	// our first branch is whether or not the player is the leader
	_check4 = [
		KISKA_respawnStateMachine,
		"playerAndGroupReady_state",
		"playerIsLeader_state",
		{leader (group player) isEqualTo player},
		{diag_log "player is leader";}
	] call CBA_statemachine_fnc_addTransition;
	_check5 = [
		KISKA_respawnStateMachine,
		"playerAndGroupReady_state",
		"playerIsNotLeader_state",
		{!(leader (group player) isEqualTo player)},
		{diag_log "player is not leader";}
	] call CBA_statemachine_fnc_addTransition;


	//// branching off now between choices

	_check7 = [
		KISKA_respawnStateMachine,
		"playerIsLeader_state",
		"start_state",
		{!isNil "KISKA_respawnActionID"},
		{diag_log "player has the action already, going back to start";}
	] call CBA_statemachine_fnc_addTransition;
	_check8 = [
		KISKA_respawnStateMachine,
		"playerIsLeader_state",
		"giveAction_state",
		{isNil "KISKA_respawnActionID"},
		{diag_log "player does not have action, gotta give them the action";}
	] call CBA_statemachine_fnc_addTransition;
	_check10 = [
		KISKA_respawnStateMachine,
		"playerIsLeader_state",
		"start_state",
		{true},
		{diag_log "player has been given the action, going back to start";}
	] call CBA_statemachine_fnc_addTransition;



	_check12 = [
		KISKA_respawnStateMachine,
		"playerIsNotLeader_state",
		"deleteAction_state",
		{!isNil "KISKA_respawnActionID"},
		{diag_log "Player has action, it will be deleted";}
	] call CBA_statemachine_fnc_addTransition;
	_check13 = [
		KISKA_respawnStateMachine,
		"playerIsNotLeader_state",
		"start_state",
		{isNil "KISKA_respawnActionID"},
		{diag_log "Player does NOT have action, going back to start";}
	] call CBA_statemachine_fnc_addTransition;
	_check15 = [
		KISKA_respawnStateMachine,
		"deleteAction_state",
		"start_state",
		{true},
		{diag_log "player has had the action deleted, going back to start";}
	] call CBA_statemachine_fnc_addTransition;

	//diag_log [_check1,_check2,_check3,_check4,_check5,_check6,_check7,_check8,_check9,_check10,_check11,_check12,_check13,_check14,_check15];
};