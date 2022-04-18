/* ----------------------------------------------------------------------------
Function: ONL_fnc_playMusicForScene

Description:
    Determines what (if any) music to play for a given scene id and then executes it

Parameters:
	0: _scene : <STRING> - The class corresponding to the missionConfigFile >> "Music_Tracks" >> "tracksForScenes" class
    1: _volume : <NUMBER> - The volume to play the music at

Returns:
	NOTHING

Examples:
    (begin example)
        // plays music for searchingLodging scene
        ["searchingLodging"] call ONL_fnc_playMusicForScene;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "ONL_fnc_playMusicForScene";

params [
    ["_scene","",[""]],
    ["_volume",1,[123]]
];

private _sceneMusic = "";
if (ONL_CCMLoaded) then {
    _sceneMusic = getText(ONL_musicSceneConfig >> _scene >> "ccm");

} else {
    if (ONL_KISKAMusicLoaded) then {
        _sceneMusic = getText(ONL_musicSceneConfig >> _scene >> "kiska");
    };

};


if (_sceneMusic isNotEqualTo "") then {
    [_sceneMusic,0,true,_volume] remoteExec ["KISKA_fnc_playMusic",ONL_allClientsTargetID];
};


nil
