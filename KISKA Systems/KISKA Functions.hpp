class KISKA
{
	class KISKA_AI
	{
		file = "KISKA Systems\KISKA AI Functions";
		class arty
		{};
		class driveTo
		{};
		class heliPatrol
		{};
		class patrolSpecific
		{};
		class setCrew
		{};
		class spawn
		{};
		class spawnGroup
		{};
	};
	class KISKA_cargoDrop
	{
		file = "KISKA Systems\KISKA Cargo Drop Functions";
		class addCargoActions
		{};
		class addCargoEvents
		{
			postInit = 1;
		};
		class cargoDrop
		{};
		class strapCargo
		{};
	};
	class KISKA_loadouts
	{
		file = "KISKA Systems\KISKA Loadout Functions";
		class assignUnitLoadout
		{};
		class randomGear
		{};
	};
	class KISKA_music
	{
		file = "KISKA Systems\KISKA Music Functions";
		class getCurrentRandomMusicTrack
		{};
		class getMusicDuration
		{};
		class getMusicFromClass
		{};
		class getMusicPlaying
		{};
		class isMusicPlaying
		{};
		class musicEventHandlers
		{
			preInit = 1;
		};
		class musicStartEvent
		{};
		class musicStopEvent
		{};
		class playMusic
		{};
		class randomMusic
		{};
		class setCurrentRandomMusicTrack
		{};
		class stopRandomMusicServer
		{};
		class stopRandomMusicClient
		{};
		class stopMusic
		{};
	};
	class KISKA_sounds
	{
		file = "KISKA Systems\KISKA Sound Functions";
		class ambientRadio
		{};
		class battleSound
		{};
		class playSound2D
		{};
		class playSound3D
		{};
		class radioChatter
		{};
		class supportRadioGlobal
		{};
	};
	class KISKA_utilities
	{
		file = "KISKA Systems\KISKA Utility Functions";
		class addArsenal
		{};
		class addMagRepack
		{};
		class alivePlayers
		{};
		class balanceHeadless
		{};
		class copyContainerCargo
		{};
		class datalinkMsg
		{};
		class doMagRepack
		{};
		class findConfigAny
		{};
		class getPlayerObject
		{};
		class hintDiary
		{};
		class isAdminOrHost
		{};
		class isPatchLoaded
		{};
		class pasteContainerCargo
		{};
		class rallyPointActionLoop
		{};
		class reassignCurator
		{};
		class setTaskComplete
		{};
		class showHide
		{};
		class supplyDrop
		{};
		class triggerWait
		{};
		class updateRespawnMarker
		{};
		class waitUntil
		{};
	};
};