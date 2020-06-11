if (!hasInterface) exitWith {};

params [
	["_player",player]
];

#include "headers\entityGroups.hpp";

ONL_CCMLoaded = ["CCM_music"] call KISKA_fnc_isPatchLoaded;
ONL_KISKAMusicLoaded = ["KISKA_music"] call KISKA_fnc_isPatchLoaded;

_player setCustomAimCoef 0.15;

call ONL_fnc_addBaseActions;
call ONL_fnc_addBlackSiteActions;

call ONL_fnc_addCaveActions;
call ONL_fnc_addLodgingActions;
call ONL_fnc_addVillageActions;

call ONL_fnc_addPlayerActions;

if (viewDistance > 1700) then {
	setViewDistance 1700;
};

if ((getObjectViewDistance select 0) > 1500) then {
	setObjectViewDistance 1500;
};

// Situation
_player createDiaryRecord ["Diary",["Situation","In a bid to garner more influence among Europe and talks with the Russian Federation, CSAT's soft expansion has brought it to Northern European nations.
<br></br>
<br></br>
Welcome to Vidda.
<br></br>
<br></br>
Civil war amongst several of its territories has enabled CSAT to obtain terrioties within its borders, being handed over by the provincial governments under the guize of aid relief. 
<br></br>
<br></br>
NATO in response and at the request of the federal body has deployed troops to the same AO. This has developed into the tense standoff between our forces.
<br></br>
<br></br>
However, we're risking the current peace in an effort to secure key intel on CSAT weapons projects being developed in the area.
<br></br>
<br></br>
One of our informants operating across the enemy lines has discovered what he claims to be groundbreaking intellegence. The catch is that he demands we extract him first from the border town of <marker name='marker_170'>Valstoff</marker>
<br></br>
<br></br>
Visibility is quickly deteriorating. We're expecting heavy fog within the next 6 hours. Should you need to stay out, ensure that you are using your time wisely."
],taskNull,"",true];

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
Make sure to use '--Strap Cargo' and '--Untstrap Cargo' actions once in place. 
<br></br>
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


waitUntil {
	if !(isNil "ONL_startingVehicles") exitWith {[_player] call ONL_fnc_addCargoActions; true};
	
	uiSleep 1;
	false
};


[] spawn {
	
	sleep 10;
  
	"About Loading Vehicles" hintC [
		
		"Simply drive the corresponding vehicle (carefully) into the aircraft.", 

		"Make sure to use '--Strap Cargo' & '--Untstrap Cargo' actions once in place.", 

		"DO NOT use any other methods of loading the vehicles.",

		"If the aircraft decides to launch, simply use the action on the switch box near all the computers in the hangar.",

		"The aircraft will take off once all PLAYERS are in seats.",

		"Once over the DZ, use the '--Get Out Interior' action to leave your seat (you'll skydive for a bit but settle).",

		"Lower the ramp and then go to the vehicles. Use their '--Release Vehicle' action to eject them from the aircraft.",

		"Then just follow them out the door."
	];

};