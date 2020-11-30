#define CALL_ICON "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa"
#define CAS_ICON "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\cas_ca.paa"
#define SUPPLY_DROP_ICON "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\supplydrop_ca.paa"
#define SUPPORT_CURSOR "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"

/*
// expression arguments

[caller, pos, target, is3D, id]
    caller: Object - unit which called the item, usually player
    pos: Array in format Position - cursor position
    target: Object - cursor target
    is3D: Boolean - true when in 3D scene, false when in map
    id: String - item ID as returned by BIS_fnc_addCommMenuItem function
*/

class ONL_supplyDrop_1
{
    text = "Supply Drop 1"; // text in the support menu
    subMenu = "";
    expression = "[1,_this select 1, _this select 0] call ONL_fnc_supplyDrop"; // code to compile upon call of menu item
    icon = SUPPLY_DROP_ICON; // icon in support menu
    curosr = SUPPORT_CURSOR;
    enable = "1";
    removeAfterExpressionCall = 1;
};
class ONL_supplyDrop_2 : ONL_supplyDrop_1
{
    text = "Supply Drop 2";
    expression = "[2,_this select 1, _this select 0] call ONL_fnc_supplyDrop";
};