/* ----------------------------------------------------------------------------
Function: ONL_fnc_caveMusic

Description:
	Executes from the event "ONL_getToExtraction_Event" which is located in ONL_fnc_extractionEvents

Parameters:
	NONE

Returns:
	Nothing

Examples:
    (begin example)

		null = [] spawn ONL_fnc_endMission;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
if (hasInterface AND {call KISKA_fnc_isMusicPlaying}) then {
	10 fadeMusic 0;
};

[nil,nil,nil,false,true] call bis_fnc_endMission;