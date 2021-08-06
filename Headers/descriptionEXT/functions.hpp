class ONL
{
	class actions
	{
		file = "Functions\actions";
		class addActionsMaster
		{};
		class addCargoActions
		{};
		class addDefusalActions
		{};
		class addPlayerActions
		{};
		class addSupplyDropSupports
		{};
		class removeDefusalAction
		{};
		class removeSupplyDropSupport
		{};
		class resetPlane
		{};
		class studyObject
		{};
	};
	class effects
	{
		file = "Functions\effects";
		class addPlayerKilledEHs
		{};
		class baseBunkerRadio
		{};
		class blackSiteArty
		{};
		class caveMusic
		{};
		class endMission
		{};
		class enterCave
		{};
		class exitCave
		{};
		class extractionMusic
		{};
		class handleExtractionHeliAI
		{};
		class newsRadio
		{};
		class playMusicForScene
		{};
		class shutOffLights
		{};
		class supplyDrop
		{};
		class startingBaseAudio
		{};
		class testingAreaDoors
		{};
		class transitionToJump
		{};
	};
	class events
	{
		file = "Functions\events";
		class base_readFile
		{};

		class blacksite_collectedIntel
		{};

		class cave_collectedIntel
		{};
		class cave_entered
		{};
		class cave_genShutOff
		{};

		class village_collectedIntel
		{};
		class village_spawnHeliPatrol
		{};
		class village_spawnReinforcements
		{};

	};
	class loops
	{
		file = "Functions\loops";
		class waitToDeletePlane
		{};
		class waitToAddCaveTasks
		{};
	};
	class saveSystem
	{
		file = "Functions\saveSystem";
		class deleteSave
		{};
		class deleteSaveQuery
		{};
		class loadProgress
		{};
		class saveProgress
		{};
		class saveQuery
		{};
	};
	class serverStart
	{
		file = "Functions\serverStart";
		class addServerEvents
		{};
		class placeVehicles
		{};
		class prepareGlobals
		{};
		class startServerLoops
		{};
		class startingVehiclesInit
		{};
	};
	class spawn
	{
		file = "Functions\spawn";
		class createBaseHeliPatrol
		{};
		class createBlackSiteHeliPatrol
		{};
		class createDrone
		{};
		class createExtractionHeli
		{};
		class spawnUnitsMaster
		{};
		class spawnUnitsNewGame
		{};
	};

};
