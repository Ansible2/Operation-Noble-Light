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
//ONL_CCMLoaded = ["CCM_MUSIC"] call KISKA_fnc_isPatchLoaded;
ONL_CCMLoaded = ["CCM_SB"] call KISKA_fnc_isPatchLoaded;
ONL_KISKAMusicLoaded = ["KISKA_music"] call KISKA_fnc_isPatchLoaded;

[_player] call ONL_fnc_addPlayerKilledEHs;
// filthy casuals reducing weapon sway
_player setCustomAimCoef 0.15;


// adjust player view distance for the airfield as it is very intensive
setViewDistance 500;
setObjectViewDistance 300;

// adjust to longer ranges once out of sight of the airfield
[
	1,
	{
		setViewDistance 1700;
		setObjectViewDistance 1500;
	},
	{(player distance2D ONL_airfieldRespawn_Logic) > 500}
] spawn KISKA_fnc_waitUntil;


call ONL_fnc_addActionsMaster;

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
_player createDiaryRecord ["Diary",["READ ME","
	The following explains how to load vehicles:
	<br></br>
	<br></br>
	Simply drive the corresponding vehicle (carefully) into the aircraft.
	<br></br>
	<br></br>
	Make sure to use <t color='#3fbfd9'>--Strap Vehicle--</t> action once in place.
	<br></br>
	<br></br>
	You can unmount the vehicle using its <t color='#039e00'>--Unstrap Vehicle--</t> action.
	<br></br>
	<br></br>
	<t color='#de0000'>DO NOT use any other methods of loading the vehicles.</t>
	<br></br>
	<br></br>
	If the aircraft decides to launch up in the air, simply use the action on the switch box near all the computers in the hangar.
	<br></br>
	<br></br>
	The aircraft will take off once all PLAYERS are in seats.
	<br></br>
	<br></br>
	Once over the DZ, use the '--Get Out Interior' action to leave your seat (you'll skydive for a bit but settle).
	<br></br>
	<br></br>
	Lower the ramp and then go to the vehicles. Use their <t color='#de0000'>--Release Vehicle--</t> action to eject them from the aircraft.
	<br></br>
	<br></br>
	Then just follow them out the door."],taskNull,"",true];


// support
_player createDiaryRecord ["Diary",["Support",
"2x supply drop. (available inside radio support menu: BACKSPACE -> Reply -> Radio)
<br></br>
<br></br>
1x Predator UAV armed with guided munitions."],taskNull,"",true];

// reassign zeus
_player createDiarySubject ["ReassignZeus_entry","Reassign Zeus",""];

_player createDiaryRecord ["ReassignZeus_entry", ["Reassign Zeus Curator",
	"<execute expression= '[true,ONL_zeusLogic] call KISKA_fnc_reassignCurator;'>If You've Lost Zeus, Click Here</execute>"
]];

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



waitUntil {
	if !(isNil "ONL_startingVehicles") exitWith {
		[_player] call ONL_fnc_addCargoActions;
		true
	};

	uiSleep 1;
	false
};


[] spawn {

	sleep 10;

	"READ ME" hintC [
		"The following explains how to load vehicles:",

		parseText "Simply drive the corresponding vehicle (carefully) into the aircraft.",

		parseText "Make sure to use <t color='#3fbfd9'>--Strap Vehicle--</t> action once in place.",

		parseText "You can unmount the vehicle using its <t color='#039e00'>--Unstrap Vehicle--</t> action.",

		parseText "<t color='#de0000'>DO NOT use any other methods of loading the vehicles.</t>",

		"If the aircraft decides to launch up in the air, simply use the action on the switch box near all the computers in the hangar.",

		"The aircraft will take off once all PLAYERS are in seats.",

		parseText "Once over the DZ, use the <t color='#039e00'>--Get Out Interior--</t> action to leave your seat (you'll skydive for a bit but settle).",

		parseText "Lower the ramp and then go to the vehicles. Use their <t color='#de0000'>--Release Vehicle--</t> action to eject them from the aircraft.",

		"Then just follow them out the door."
	];

};
