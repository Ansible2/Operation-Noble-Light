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
		class addResearchFacilityActions
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
		class waitToAddBlackSiteTasks
		{};
	};
	class serverStart
	{
		file = "Functions\serverStart";
		class startServerLoops
		{};
		class prepareGlobals
		{};
	};
	class serverEvents
	{
		file = "Functions\serverEvents";
		class baseEvents
		{};
		class blackSiteEvents
		{};
		class caveEvents
		{};
		class extractionEvents
		{};
		class miscEvents
		{};
		class villageEvents
		{};
	};
	class spawn
	{
		file = "Functions\spawn";
		class createDrone
		{};
		class createExtractionHeli
		{};
		class placeVehicles
		{};
		class spawnUnitsBase
		{};
		class spawnUnitsBlacksite
		{};
		class spawnUnitsCave
		{};
		class spawnUnitsFacility
		{};
		class spawnUnitsLodging
		{};
		class spawnUnitsMaster
		{};
		class spawnUnitsVillage
		{};
		class startingVehiclesInit
		{};
	};

};