/* ----------------------------------------------------------------------------
Function: ONL_fnc_endMission

Description:
	Executes from the event "ONL_getToExtraction_Event" which is located in ONL_fnc_extractionEvents

Parameters:
	NONE

Returns:
	Nothing

Examples:
    (begin example)

		[] spawn ONL_fnc_endMission;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
if (hasInterface AND {call KISKA_fnc_isMusicPlaying}) then {
	10 fadeMusic 0;
};

[nil,nil,nil,false,true] call BIS_fnc_endMission;