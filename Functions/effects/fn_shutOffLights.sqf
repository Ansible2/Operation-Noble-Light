((getMissionLayerEntities "GeneratorLamps") select 0) apply {
	_x setDamage 0.95;
};

((getMissionLayerEntities "Emergency Lighting") select 0) apply {
	sleep (random [0.3,0.5,0.7]);
	_x enableSimulationGlobal true;
};