// Artillery eventHandelers
[ONL_arty_1,ONL_arty_2] apply {
=	_x addEventHandler ["KILLED", {
		private _deadCount = missionNamespace getVariable ["ONL_deadArty",0];
		
		if (_deadCount isEqualTo 1) then {
			[DestroyArty_taskID,DestroyArty_taskInfo] call KISKA_fnc_setTaskComplete;
		} else {
			ONL_deadArty = 1;
		};
	}];
};