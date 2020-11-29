#include "headers\entityGroups.hpp";

if (!hasInterface) exitWith {};

params [
	["_player",player]
];

/*
*
*
*
*			YOU NEEED TO CHANGE THIS BACK TO :
*			ONL_CCMLoaded = ["CCM_MUSIC"] call KISKA_fnc_isPatchLoaded;
*			After release as the pack in the mod PBO has this one
*
*
*
*/
ONL_CCMLoaded = ["CCM_PM"] call KISKA_fnc_isPatchLoaded;
ONL_KISKAMusicLoaded = ["KISKA_music"] call KISKA_fnc_isPatchLoaded;

// filthy casuals reducing weapon sway
_player setCustomAimCoef 0.15;

call ONL_fnc_addActionsMaster;

if (viewDistance > 1700) then {
	setViewDistance 1700;
};
if ((getObjectViewDistance select 0) > 1500) then {
	setObjectViewDistance 1500;
};

//// diary records
// Situation
_player createDiaryRecord ["Diary",["Situation","In a bid to garner more influence among Europe and its talks with the Russian Federation, CSAT's soft expansion has brought it to Scandinavia.
<br></br>
<br></br>
Welcome to Vidda.
<br></br>
<br></br>
Civil war amongst several of its territories has enabled CSAT to obtain land within its borders, being handed over by the provincial governments under the guise of aid relief.
<br></br>
<br></br>
NATO in response and at the request of the federal body has deployed troops to the same AO. This has developed into the tense standoff between our forces.
<br></br>
<br></br>
However, after CSAT’s attacks in Takistan several hours ago, we are severing this peace at 0500 tomorrow morning.
<br></br>
<br></br>
Prior to this, you will insert to extract an asset, code named Apollo.
<br></br>
<br></br>
He claims to possess groundbreaking intelligence on a CSAT weapons project. The catch is that he demands we extract him first from the border town of <marker name='marker_170'>Valstoff</marker>
<br></br>
<br></br>
Visibility is quickly deteriorating. We're expecting heavy fog within the next 6 hours. Should you need to stay out, ensure that you are using your time wisely.
<br></br>
<br></br>
We will have a limited opportunity to insert you via HALO jump before CSAT’s air defence network is fully operational in the area."],taskNull,"",true];

// Mission
_player createDiaryRecord ["Diary",["Mission","Secure the informant, callsign Apollo, and his information.
<br></br><br></br>
Follow any leads where possible."],taskNull,"",true];

// Execution
_player createDiaryRecord ["Diary",["Execution","1. Load your equipment into the aircraft and <marker name='marker_55'>jump</marker> into the east tundra.
<br></br><br></br>
2. Move North to <marker name='marker_170'>Valstoff</marker>.
<br></br><br></br>
3. Secure Apollo and move to the extration site."],taskNull,"",true];

// Loading Vehicles
_player createDiaryRecord ["Diary",["Loading Vehicles","Simply drive the corresponding vehicle (carefully) into the aircraft.  
<br></br>
<br></br>
Make sure to use '--Strap Cargo' action once in place.
<br></br>
You can unmount the vehicle using its '--Unstrap Cargo' action.
<br></br>
DO NOT use any other methods of loading the vehicles.
<br></br>
<br></br>
If the aircraft decides to launch, simply use the action on the switch box near all the computers in the hangar.
<br></br>
<br></br>
The aircraft will take off once all PLAYERS are in seats.
<br></br>
<br></br>
Once over the DZ, use the '--Get Out Interior' action to leave your seat (you'll skydive for a bit but settle).
<br></br>
<br></br>
Lower the ramp and then go to the vehicles. Use their '--Release Vehicle' action to eject them from the aircraft.
<br></br>
<br></br>
Then just follow them out the door."],taskNull,"",true];

// support
_player createDiaryRecord ["Diary",["Support",
"2x supply drop. (available inside radio support menu: BACKSPACE -> Reply -> Radio)
<br></br>
<br></br>
1x Predator UAV armed with guided munitions."],taskNull,"",true];

// wait to add save game button (only admins or hosts will be able to save because of checks in ONL_fnc_saveProgress)
[
	5,
	{
		(_this select 0) createDiaryRecord ["Diary", ["SAVE GAME", 
			"(Only hosts and admins can save)
			<br></br>
			<br></br>
			<execute expression='call ONL_fnc_saveQuery'>SAVE GAME</execute>
			<br></br>
			<br></br>
			<execute expression='call ONL_fnc_deleteSaveQuery'>DELETE SAVE (clear profileNamespace)</execute>"
		]];
	},
	{!(isNil "ONL_unitsSpawned")},
	[_player]
] call KISKA_fnc_waitUntil;

null = [] spawn KISKA_fnc_rallyPointActionLoop;

waitUntil {
	if !(isNil "ONL_startingVehicles") exitWith {[_player] call ONL_fnc_addCargoActions; true};
	
	uiSleep 1;
	false
};


null = [] spawn {
	
	sleep 10;
  
	"About Loading Vehicles" hintC [
		
		"Simply drive the corresponding vehicle (carefully) into the aircraft.", 

		"Make sure to use '--Strap Cargo' action once in place.", 

		"You can unmount the vehicle using its '--Unstrap Cargo' action.",

		"DO NOT use any other methods of loading the vehicles.",

		"If the aircraft decides to launch up in the air, simply use the action on the switch box near all the computers in the hangar.",

		"The aircraft will take off once all PLAYERS are in seats.",

		"Once over the DZ, use the '--Get Out Interior' action to leave your seat (you'll skydive for a bit but settle).",

		"Lower the ramp and then go to the vehicles. Use their '--Release Vehicle' action to eject them from the aircraft.",

		"Then just follow them out the door."
	];

};