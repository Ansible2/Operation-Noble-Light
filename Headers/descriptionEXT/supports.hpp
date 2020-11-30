#define CALL_ICON "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa"
#define CAS_ICON "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\cas_ca.paa"
#define SUPPLY_DROP_ICON "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\supplydrop_ca.paa"
#define SUPPORT_CURSOR "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"

class ONL_supplyDrop
{
    text = "Supply Drop 1"; // text in support menu and Shop (DO NOT INCLUDE PRICE HERE, IT IS ADDED IN BLWK_fnc_populateSupportTree)
    subMenu = "";
    expression = "[1] call ONL_fnc_supplyDrop"; // code to compile upon call of menu item
    icon = SUPPLY_DROP_ICON; // icon in support menu
    curosr = SUPPORT_CURSOR;
    enable = "1";
    removeAfterExpressionCall = 1;
};