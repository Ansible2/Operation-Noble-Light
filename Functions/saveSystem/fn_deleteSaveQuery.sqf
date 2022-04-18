/* ----------------------------------------------------------------------------
Function: ONL_fnc_deleteSaveQuery

Description:
	This function simply sends a message to the server to try and save the mission.
	
	It is executed from a briefing record in game that was added in the "initPlayerLocal.sqf".

	This method was used due to the limited ability to include strings inside a briefing <expression> execussion.
	Therefore, the required function/command string within a remoteExec was not able to be placed in the expression.
	
Parameters:
	NONE

Returns:
	Nothing

Examples:
    (begin example)

		call ONL_fnc_deleteSaveQuery;

    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
remoteExecCall ["ONL_fnc_deleteSave",2];