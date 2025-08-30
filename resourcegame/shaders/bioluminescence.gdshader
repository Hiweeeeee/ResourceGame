shader_type particles;

const vec4[4] colors = vec4[4](vec4(0.73, 1.0, 0.0, 0.0), vec4(0.73, 1.0, 0.0, 0.9), vec4(0.73, 1.0, 0.0, 0.9), vec4(0.73, 1.0, 0.0, 0.0));
const float[4] ts = float[4](0.0, 0.12, 0.88, 1.0);

uniform float width;
uniform float height;

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
	uint state = RANDOM_SEED + NUMBER * uint(343);
	mat4 justScale = mat4(EMISSION_TRANSFORM[0], EMISSION_TRANSFORM[1], EMISSION_TRANSFORM[2], vec4(0.0, 0.0, 0.0, 1.0));
	TRANSFORM = mat4(2);
	vec4 pos = vec4(random(state)*width-width/2.0, random(state)*height-height/2.0, 0.0, 1.0) * justScale;
	pos.xy += EMISSION_TRANSFORM[3].xy;
	TRANSFORM[3] = pos;
	CUSTOM = vec4(0.0, LIFETIME, 0.0, 0.0);
	VELOCITY = vec3(0.0);
}

void process() {
	if(RESTART && COLLIDED){
		CUSTOM.w = 1.0;
	}
	if(COLLIDED && CUSTOM.w != 1.0){
		CUSTOM.z = 1.0;
		CUSTOM.w = 1.0;
	}else{
		CUSTOM.z -= 0.002;
	}
	if(!COLLIDED){
		CUSTOM.w = 0.0;
	}
	CUSTOM.z = clamp(CUSTOM.z, 0.0, 1.0);
	// Called every frame on existing particles (according to the Fixed FPS property).
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
	COLOR.a *= CUSTOM.z;
}
