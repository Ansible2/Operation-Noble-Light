#define CONDITION_PLAYER_WITHIN_RADIUS_3D(position,radius) !(((call CBA_fnc_players) findIf {(_x distance position) <= radius}) isEqualTo -1)
#define CONDITION_PLAYER_WITHIN_RADIUS_2D(position,radius) !(((call CBA_fnc_players) findIf {(_x distance2d position) <= radius}) isEqualTo -1)
