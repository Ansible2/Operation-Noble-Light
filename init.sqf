waitUntil {
    sleep 5;
    !isNil "ONL_extractHeli"
};

ONL_extractHeli addEventHandler ["Local", {
    params ["_helicopter", "_isLocal"];

    if (_isLocal) then {
        _helicopter allowDamage false;
        _helicopter setUnloadInCombat [false,false];
    };
}];
