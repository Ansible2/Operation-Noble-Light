#define ON 1
#define OFF 0

class KISKA_cfgTasks
{
/*
    class exampleTask_base // class name will become Task Id
    {
        title = "My Example Task";
        description = "This is an example";

        parentTask = ""; // Parent Task Id
        type = ""; // task type as defined in CfgTaskTypes

        // params for these are:
        // 0: task id (or class name) (STRING)
        // 1: config path (CONFIG)
        // 2: task state (STRING)
        onComplete = ""; // code that runs upon completion of task when using KISKA_fnc_endTask
        onCreate = ""; // code that runs on creation of task when using KISKA_fnc_createTaskFromConfig

        destination[] = {}; // position of task

        defaultState = ""; // "CREATED", "ASSIGNED", "AUTOASSIGNED" (default), "SUCCEEDED", "FAILED", or "CANCELED"
        priority = -1;
        notifyOnComplete = ON;
        notifyOnCreate = ON;

        visibleIn3D = OFF; // 3d marker creation
    };
    class exampleTask_parent : exampleTask_base
    {
        title = "My Example Task Parent";
        description = "This is an example task parent";

        parentTask = "";
        type = "default";

        onComplete = "hint 'Parent complete'";
        onCreate = "hint 'Parent created'";

        destination[] = {};

        defaultState = "";
        priority = -1;
        notifyOnComplete = ON;
        notifyOnCreate = ON;

        visibleIn3D = OFF;
    };
    class exampleTask_child : exampleTask_base
    {
        title = "My Example Task Child";
        description = "This is an example task child";

        parentTask = "exampleTask_parent";
        type = "Move";

        onComplete = "hint 'Child complete'";
        onCreate = "hint 'Child created'";

        destination[] = {};

        defaultState = "";
        priority = -1;
        notifyOnComplete = ON;
        notifyOnCreate = ON;

        visibleIn3D = OFF;
    };
*/
    class ONL_findHeadScientist_task
    {
        title		= "Find Head CSAT Scientist";
        description	= "Apollo positively identified the lead of an experimental weapons project, Gaius Baltar, it would be worth pursuing him.";

        type = TASK_TYPE_SEARCH;

        defaultState = "AUTOASSIGNED";
        priority = 5;

        notifyOnCreate = ON;
        notifyOnComplete = ON;

        visibleIn3D = OFF;
    };

    class ONL_extract_task
    {
        title		= "Extract From The AO";
    	description	= "There is a derelict military outpost located at GRID 063023. A helicopter will be inbound to the position for your extraction.";

        type = TASK_TYPE_TAKEOFF;

        defaultState = "AUTOASSIGNED";
        priority = 5;

        destination[] = {
            6388.54,
            9555.92,
            0
        };

        notifyOnCreate = ON;
        notifyOnComplete = ON;

        visibleIn3D = OFF;
    };

    class ONL_secureApollo_task
    {
        title		= "Meet Apollo";
    	description	= "We have an agent (Apollo) on the ground who has discovered a CSAT weapons project. Meet him at the border town and secure him and the intel.";

        type = TASK_TYPE_MEET;

        defaultState = "ASSIGNED";
        priority = 5;

        compiledDestination = "missionNamespace getVariable ['ONL_ApolloFiles',objNull]";

        notifyOnCreate = ON;
        notifyOnComplete = ON;

        visibleIn3D = OFF;
    };

    class ONL_SearchLodging_task
    {
        title		= "(OPTIONAL) Search CSAT Scientist Quarters";
    	description	= "We've found documents mentionening two locations, a research facility and a housing area for the project workers. Search the crew quarters at Snikesnoken Hyttetum near hill 1147 for possible locations of the facility.";

        type = TASK_TYPE_SEARCH;
        defaultState = "AUTOASSIGNED";
        priority = 5;

        notifyOnCreate = ON;
        notifyOnComplete = ON;
        visibleIn3D = OFF;
    };

    // BlackSite
    class ONL_investigateBlacksite_task
    {
        title		= "Investigate CSAT Black Site";
    	description	= "Apollo's notes spoke of a CSAT black site, some kind of digging/mining op located EAST of the village he was to meet us at.";

        type = TASK_TYPE_SEARCH;

        defaultState = "ASSIGNED";
        priority = 10;

        notifyOnCreate = ON;
        notifyOnComplete = ON;

        visibleIn3D = OFF;
    };
    class ONL_collectBlackSiteIntel_task : ONL_investigateBlacksite_task
    {
        title		= "(OPTIONAL) Search For Data Around The Site and Adjacent Base";
    	description	= "Check laptops, communiation equipment, and files in and around the site.";

        defaultState = "AUTOASSIGNED";

        parentTask = "ONL_investigateBlacksite_task";
    };
    class ONL_CollectRockSample_task : ONL_collectBlackSiteIntel_task
    {
        title		= "Collect A Sample of The Glowing Rock";
    	description	= "";

        defaultState = "AUTOASSIGNED";
        type = TASK_TYPE_INTERACT;
        compiledDestination = "missionNamespace getVariable ['ONL_glowingRock',objNull]";
    };
    class ONL_DestroyBlackSiteServers_task : ONL_collectBlackSiteIntel_task
    {
        title		= "(OPTIONAL) Destroy The Servers Near The Glowing Rock";

        defaultState = "AUTOASSIGNED";
        type = TASK_TYPE_DESTROY;
        compiledDestination = "missionNamespace getVariable ['ONL_blackSiteServer_2',objNull]";
    };


    // base
    class ONL_CollectBaseIntel_task
    {
        title		= "Search The Base For Intel";
    	description	= "High powered imaging has located a bunker at the SOUTHWEST edge of the base. Search it for intel.";

        type = TASK_TYPE_SEARCH;
        defaultState = "AUTOASSIGNED";
        priority = 5;

        compiledDestination = "missionNamespace getVariable ['ONL_BaseFile',objNull]";

        notifyOnCreate = ON;
        notifyOnComplete = ON;
        visibleIn3D = OFF;
    };
    class ONL_DestroyBaseComs_task
    {
        title		= "(OPTIONAL) Destroy CSAT Communications";
    	description	= "Imaging has revealed CSAT have a highpowered communications relay located at their WESTERN base. Cripple it before moving on the black site to delay the homeland's response. One of our flanks is gonna be putting pressure on them when we appoach to pull away some assets from the base.";

        type = TASK_TYPE_DESTROY;
        defaultState = "AUTOASSIGNED";
        priority = 5;

        compiledDestination = "missionNamespace getVariable ['ONL_comRelay',objNull]";

        notifyOnCreate = ON;
        notifyOnComplete = ON;
        visibleIn3D = OFF;
    };
    class ONL_DestroyBaseArty_task
    {
        title		= "(OPTIONAL) Destroy CSAT artillery positions";
    	description = "There are artillery postions located at the WESTERN CSAT base. They are firing on friendly forces and should be destoryed.";

        type = TASK_TYPE_DESTROY;
        defaultState = "AUTOASSIGNED";
        priority = 5;

        notifyOnCreate = ON;
        notifyOnComplete = ON;
        visibleIn3D = OFF;
    };

    // cave
    class ONL_InvestigateFacility_task
    {
        title		= "Search For The Facility";
    	description	= "It should be in a mountainous area. SOUTHWEST of the lodging area but directly SOUTH of the border crossing at Vardefjell. We're looking for a bunker.";

        type = TASK_TYPE_SEARCH;

        defaultState = "AUTOASSIGNED";
        priority = 5;

        notifyOnCreate = ON;
        notifyOnComplete = ON;

        visibleIn3D = OFF;
    };
    class ONL_DestroyTheDevices_task
    {
        title		= "(OPTIONAL) Destroy The Devices";
    	description	= "We can't leave anything behind here.";

        type = TASK_TYPE_DESTROY;
        parentTask = "ONL_InvestigateFacility_task";
        defaultState = "AUTOASSIGNED";
        priority = 5;

        notifyOnCreate = ON;
        notifyOnComplete = ON;

        visibleIn3D = OFF;
    };

    class ONL_DestroyCaveServers_Task : ONL_DestroyTheDevices_task
    {
        title		= "(OPTIONAL) Destroy The Project Servers";
    	description	= "We can't leave anything behind here.";

        compiledDestination = "missionNamespace getVariable ['ONL_caveServer_1',objNull]";

        visibleIn3D = ON;
    };

    class ONL_CollectDeviceLogs_Task : ONL_DestroyTheDevices_task
    {
        title		= "(OPTIONAL) Collect Device Logs";
    	description	= "Go to the two devices and collect their logs.";

        type = TASK_TYPE_INTERACT;
    };
    class ONL_CollectDeviceLogs_Task : ONL_CollectDeviceLogs_Task
    {
        title		= "(OPTIONAL) Collect Drives and Computers";
    	description	= "Any laptops, tablets, and drives need to be secured to bring back. Search the disassembled device for a data drive.";

        type = TASK_TYPE_SEARCH;
    };
};
