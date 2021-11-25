//import KISKA_basicSupport_baseClass from CfgCommunicationMenu;
//import KISKA_artillery_baseClass from CfgCommunicationMenu;
//import KISKA_CAS_baseClass from CfgCommunicationMenu;
//import KISKA_attackHelicopterCAS_baseClass from CfgCommunicationMenu;
//import KISKA_helicopterCAS_baseClass from CfgCommunicationMenu;
//import KISKA_arsenalSupplyDrop_baseClass from CfgCommunicationMenu;
import KISKA_supplyDrop_aircraft_baseClass from CfgCommunicationMenu;
import KISKA_CAS_gunsRockets_templateClass from CfgCommunicationMenu;
import KISKA_ARTY_155_templateClass from CfgCommunicationMenu;
import KISKA_CAS_bombs_templateClass from CfgCommunicationMenu;

//#include "\KISKA_Functions\Supports\Support Framework\Headers\Support Type IDs.hpp";
//#include "\KISKA_Functions\Supports\Support Framework\Headers\Support Icons.hpp";
//#include "\KISKA_Functions\Supports\Support Framework\Headers\CAS Type IDs.hpp";
//#include "\KISKA_Functions\Supports\Support Framework\Headers\Arty Ammo Type IDs.hpp";

/*
    This master function for supports is used as go between for error cases such as when
     a player provides an invalid position (looking at the sky). It will then refund the
     support back to the player.
*/
#define CALL_SUPPORT_MASTER(CLASS) "["#CLASS",_this,%1] call KISKA_fnc_callingForSupportMaster"
#define EXPRESSION_CALL_MASTER(CLASS) expression = CALL_SUPPORT_MASTER(CLASS);

/*
// expression arguments

[caller, pos, target, is3D, id]
    caller: Object - unit which called the item, usually player
    pos: Array in format Position - cursor position
    target: Object - cursor target
    is3D: Boolean - true when in 3D scene, false when in map
    id: String - item ID as returned by BIS_fnc_addCommMenuItem function
*/

/*
	if a class is to be solely a base one, you need to include _baseClass (EXACTLY AS IT IS CASE SENSITIVE)
	 somewhere in the class name so that it can be excluded from being added to the shop
*/
/*
class KISKA_basicSupport_baseClass
{
    text = "I'm a support!"; // text in support menu
    expression = ""; // code to compile upon call of menu item
    icon = CALL_ICON; // icon in support menu
    removeAfterExpressionCall = 1;

    supportTypeId = SUPPORT_TYPE_CUSTOM;

    // used for support selection menu
    // _this select 0 is the classname
    managerCondition = "";
};
*/

class ONL_supplyDrop : KISKA_supplyDrop_aircraft_baseClass
{
    text = "Crate Supply Drop";
    tooltip = "Drop off of a fuel, repair, and vehicle ammo crates. These all come with arsenals.";
    EXPRESSION_CALL_MASTER(ONL_supplyDrop)

    addArsenals = 1;
    deleteCargo = 1;
    crateList[] = {
        "B_Slingload_01_Fuel_F",
        "B_Slingload_01_Repair_F",
        "B_Slingload_01_Ammo_F"
    };

    flyinHeights[] = {
        500
    };
    vehicleTypes[] = {
        "B_T_VTOL_01_infantry_F"
    };
};

class ONL_CAS_gunsRockets : KISKA_CAS_gunsRockets_templateClass
{
    text = "CAS - Gun & Rockets";

    vehicleTypes[] = {
        "B_Plane_CAS_01_dynamicLoadout_F"
    };
    EXPRESSION_CALL_MASTER(ONL_CAS_gunsRockets)

};

class ONL_CAS_bombs : KISKA_CAS_bombs_templateClass
{
    text = "CAS - Bombs";

    vehicleTypes[] = {
        "B_Plane_CAS_01_dynamicLoadout_F"
    };
    EXPRESSION_CALL_MASTER(ONL_CAS_bombs)

};

class ONL_155_arty : KISKA_ARTY_155_templateClass
{
    text = "155mm Artillery - 6 Rounds";
    roundCount = 6;

    EXPRESSION_CALL_MASTER(ONL_155_arty)
};
