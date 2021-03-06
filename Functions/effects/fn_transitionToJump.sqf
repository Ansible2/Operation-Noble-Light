/* ----------------------------------------------------------------------------
Function: ONL_fnc_transitionToJump

Description:
	Fades player's screen while plane is teleported to drop zone, then fades back.
	Also reduces sound volume for the horrendous engine note of the USAF mod's c-17.

	Executed from cargo plane takeoff loop inside "ONL_fnc_startServerLoops"

Parameters:
	NONE

Returns:
	Nothing

Examples:
    (begin example)

		call ONL_fnc_transitionToJump;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
if (!hasInterface) exitWIth {};

titleText ["<t font='PuristaSemibold' align='center' size='5'>Some Time Later...</t>", "BLACK OUT", 3, true, true]; 

// for the c17's abismal engine noise
6 fadeSound 0.1;

player allowDamage false;

// get out interior action
ONL_getoutActionID = player addAction [
	"<t color='#039e00'>--Get Out Interior--</t>",  
	{
		params [
			["_player",player,[objNull]]
		];
		
		private _planePos = getPosATL objectParent _player;
		moveOut _player;
		_player setPosATL (_planePos vectorAdd [0,0,4]);

		[
			{
				player switchMove "";
			},
			[],
			1
		] call CBA_fnc_waitAndExecute;
	}, 
	nil, 
	1.5,  
	false,  
	false,  
	"", 
	"typeOf (objectParent player) == 'USAF_C17'", 
	5, 
	false 
];


[
	{
		titleText ["<t font='PuristaSemibold' align='center' size='5'>Some Time Later...</t>", "BLACK IN", 3, true, true];
		
		// start fading sound back in after player jumps
		[
			{(getPosATLVisual player select 2) < 4950},
			{
				30 fadeSound 1;

				player removeAction ONL_getoutActionID;
			}
		] call CBA_fnc_waitUntilAndExecute;

		// increase player speed so it looks like the plane is moving when they jump
		
		[
			{((velocity player) select 2) < -8},
			{
				player setVelocity ((velocity player) vectorDiff [0,120,0]);
			}
		] call CBA_fnc_waitUntilAndExecute;
		
		[
			0.5,
			{	// play music near ground
				if (ONL_CCMLoaded) then {
					["CCM_BS_SilenceEverAfter",0,true,1,6] spawn KISKA_fnc_playmusic;
				} else {
					if (ONL_KISKAMusicLoaded) then {
						["Kiska_GlassTravel",0,true,1,6] spawn KISKA_fnc_playmusic;
					};
				};

				[
					0.5,
					{
						[
							{	// make player vulnerable again
								player allowDamage true;
							},
							[],
							10
						] call CBA_fnc_waitAndExecute;
					},
					{(getPosATLVisual player select 2) < 1}
				] call KISKA_fnc_waitUntil;
			},
			{(getPosATLVisual player select 2) < 150}
		] call KISKA_fnc_waitUntil;			 
	},
	[],
	6
] call CBA_fnc_waitAndExecute;


["Be advised, high winds at the DZ",12,true] call KISKA_fnc_DatalinkMsg;
["Chute deployment height recommended at 700-900m AGL",18,true] call KISKA_fnc_DatalinkMsg;