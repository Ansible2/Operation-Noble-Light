/* ----------------------------------------------------------------------------
Function: ONL_fnc_deleteSave

Description:
	Clears out the profileNamespace of ONL save data
	
Parameters:
	NONE

Returns:
	Nothing

Examples:
    (begin example)

		call ONL_fnc_deleteSave;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
profileNamespace setVariable ["ONL_saveData",nil];
saveProfileNamespace;