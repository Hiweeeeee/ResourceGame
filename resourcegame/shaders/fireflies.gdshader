shader_type particles;

const vec4[4] colors = vec4[4](vec4(0.73, 1.0, 0.0, 0.0), vec4(0.73, 1.0, 0.0, 1.0), vec4(0.73, 1.0, 0.0, 1.0), vec4(0.73, 1.0, 0.0, 0.0));
const float[4] ts = float[4](0.0, 0.12, 0.88, 1.0);
const float maxAngleChange = 0.6;

uniform vec2 playerPosition;
uniform vec2 spawnSize;
uniform float minSpeed;
uniform float maxSpeed;
uniform float fleeMaxSpeed;
uniform float lifetimeVariability;
uniform sampler2D glowCurve;

float random(inout uint state){
  state = state * uint(747796405) + uint(2891336453);
  uint result = ((state >> ((state >> uint(28)) + uint(4))) ^ state) * uint(277803737);
  result = (result >> uint(22)) ^ result;
  return float(result) / 4294967295.0;
}

float randomNonInout(uint state){
  state = state * uint(747796405) + uint(2891336453);
  uint result = ((state >> ((state >> uint(28)) + uint(4))) ^ state) * uint(277803737);
  result = (result >> uint(22)) ^ result;
  return float(result) / 4294967295.0;
}

void start() {
	// Called when a particle is spawned.
	uint seed = RANDOM_SEED + NUMBER;
	float speed = random(seed) * minSpeed + maxSpeed - minSpeed;
	float angle = random(seed) * TAU;
	
	vec2 vel = vec2(speed * cos(angle), speed * sin(angle));
	TRANSFORM = mat4(0.1);
	float x = random(seed) * spawnSize.x - spawnSize.x/2.0 + EMISSION_TRANSFORM[3].x;
	float y = random(seed) * spawnSize.y - spawnSize.y/2.0 + EMISSION_TRANSFORM[3].y;
	TRANSFORM[3] = vec4(x, y, 0.0, 1.0);
	
	VELOCITY = vec3(vel, 0.0); 
	CUSTOM = vec4(0.0, LIFETIME + lifetimeVariability * -randomNonInout(RANDOM_SEED + NUMBER), vel);
}

void process() {
	
	// Called every frame on existing particles (according to the Fixed FPS property).
	VELOCITY = vec3(CUSTOM.zw, 0.0);
	CUSTOM.z += randomNonInout(RANDOM_SEED + NUMBER + uint(TIME * 100.0)) * maxAngleChange - maxAngleChange/2.0;
	CUSTOM.w += randomNonInout(RANDOM_SEED + NUMBER + uint(TIME * 100.0)) * maxAngleChange - maxAngleChange/2.0;
	vec2 currPos = TRANSFORM[3].xy;
	vec2 delta = currPos - playerPosition;
	
	CUSTOM.x += DELTA;
	float percent = CUSTOM.x/CUSTOM.y;
	int minI = 0;
	for(int i = 0; i < 4; i++){
		if(percent > ts[i]){
			minI = i;
		}
	}
	if(minI == 3){
		COLOR = vec4(0.0);
	}else{
		vec4 prevColor = colors[minI];
		vec4 deltaColor = colors[minI + 1] - prevColor;
		float prevt = ts[minI];
		float deltat = ts[minI + 1] - prevt;
		
		float lerpT = (percent - prevt)/deltat;
		COLOR = prevColor + deltaColor * lerpT;
	}
	
	if(CUSTOM.x > CUSTOM.y){
		ACTIVE = false;
	}
	
	bool fleeing = false;
	
	if(COLLIDED){
		CUSTOM.zw += COLLISION_NORMAL.xy * COLLISION_DEPTH * 0.1;
		fleeing = true;
	}
	
	float currMaxSpeed;
	if(fleeing){
		currMaxSpeed = fleeMaxSpeed;
	}else{
		currMaxSpeed = maxSpeed;
	}
	if(length(CUSTOM.zw) > currMaxSpeed){
		CUSTOM.zw = normalize(CUSTOM.zw) * currMaxSpeed;
	}
}
