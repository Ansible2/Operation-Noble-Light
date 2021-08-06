/* ----------------------------------------------------------------------------
Function: ONL_fnc_resetPlane

Description:
    Resets the position of the cargo plane on the runway.

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)
		call ONL_fnc_resetPlane;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "ONL_fnc_resetPlane";

private _position = getPosATL ONL_cargoPlane_resetLogic;
private _vectorDir = vectorDir ONL_cargoPlane_resetLogic;
private _vectorUp = vectorUp ONL_cargoPlane_resetLogic;

ONL_cargoPlane setPosATL _position;

[ONL_cargoPlane,[_vectorDir,_vectorUp]] remoteExec ["setVectorDirAndUp",ONL_cargoPlane];

["Alarm",ONL_logic_startingBaseSpeaker_1,200,3] call KISKA_fnc_playSound3D;


nil
