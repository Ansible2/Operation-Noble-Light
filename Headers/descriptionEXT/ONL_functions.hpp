class ONL
{
	class actions 
	{
		file = "Functions\actions";
		class addBaseActions
		{};
		class addBlackSiteActions
		{};
		class addCargoActions
		{};
		class addCaveActions
		{};
		class addDefusalActions
		{};
		class addLodgingActions
		{};
		class addPlayerActions
		{};
		class addVillageActions
		{};
		
	};
	class effects 
	{
		file = "Functions\effects";
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
		class newsRadio
		{};
		class shutOffLights
		{};
		class startingBaseAudio
		{};
		class testingAreaDoors
		{};
		class transitionToJump
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
		class extractionEvents
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
	};

};