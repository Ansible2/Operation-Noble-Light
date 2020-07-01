/* ----------------------------------------------------------------------------
Function: ONL_fnc_shutOffLights

Description:
	Damages lights inside the cave just enough to have them appear to shut off.

	Executed from either the generator "Killed" eventhandlers OR the "ONL_cave_generatorShutOff_Event".
	Both of which are loacted inside "ONL_fnc_addServerEvents".

Parameters:
	NONE

Returns:
	Nothing

Examples:
    (begin example)

		null = [] spawn ONL_fnc_shutOffLights;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
if (!isServer) exitWith {};

((getMissionLayerEntities "GeneratorLamps") select 0) apply {
	_x setDamage 0.95;
};

((getMissionLayerEntities "Emergency Lighting") select 0) apply {
	sleep (random [0.3,0.5,0.7]);
	_x enableSimulationGlobal true;
};