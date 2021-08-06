/* ----------------------------------------------------------------------------
Function: ONL_fnc_cave_genShutoff

Description:
    Acts as a server event when shutting down the cave generators

Parameters:
	0: _gen <OBJECT> - The shutoff generator

Returns:
	NOTHING

Examples:
    (begin example)
		[_gen] remoteExec ["ONL_fnc_cave_genShutoff",2];
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "ONL_fnc_cave_genShutoff";

if (!isServer) exitWith {
    ["Needs to be executed on the server, remoting on server now...",true] call KISKA_fnc_log;
    _this remoteExec ["ONL_fnc_cave_genShutoff",2];
    nil
};


params [
    ["_generator",objNull,[objNull]]
];

["OMLightSwitch",_generator,50,2] call KISKA_fnc_playSound3D;
_generator setVariable ["ONL_genOff",true,true];

if (missionNamespace getVariable ["ONL_cave_GeneratorDeadCount",0] isEqualTo 0) then {
    ONL_cave_GeneratorDeadCount = 1;

} else {
    [] spawn ONL_fnc_shutOffLights;

};
