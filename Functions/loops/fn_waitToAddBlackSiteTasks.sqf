[
    3,
    {		
        [true,CollectRockSample_TaskID,"CollectRockSample_TaskInfo",ONL_glowingRock,"AUTOASSIGNED",5,true,"INTERACT",false] call BIS_fnc_taskCreate;            
		[true,DestroyBlackSiteServers_TaskID,"DestroyBlackSiteServers_TaskInfo",ONL_blackSiteServer_2,"AUTOASSIGNED",5,true,"DESTROY",false] call BIS_fnc_taskCreate;

        call ONL_fnc_blackSiteArty;
    },
    {!(((call CBA_fnc_players) findIf {(_x distance2D ONL_glowingRock) < 10}) isEqualTo -1)}
] call KISKA_fnc_waitUntil;