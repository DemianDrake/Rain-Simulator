shader_type particles;

const float PI = 3.141592653589793;

uniform float height;
uniform float gravity;
uniform float init_vel;
uniform float amount;

// angle in degrees
uniform float wind_direction_angle;
uniform float wind_power;

float deg_to_rad(float deg){
        return deg * PI / 180.0;
}

mat3 rotationMatrix(vec3 axis, float angle)
{
    axis = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 - c;

    return mat3(vec3(oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s),
                vec3(oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s),
                vec3(oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c));
}


float rand_from_seed(in uint seed) {
  int k;
  int s = int(seed);
  if (s == 0)
    s = 305420679;
  k = s / 127773;
  s = 16807 * (s - k * 127773) - 2836 * k;
  if (s < 0)
    s += 2147483647;
  seed = uint(s);
  return float(seed % uint(65536)) / 65535.0;
}

uint hash(uint x) {
  x = ((x >> uint(16)) ^ x) * uint(73244475);
  x = ((x >> uint(16)) ^ x) * uint(73244475);
  x = (x >> uint(16)) ^ x;
  return x;
}

void vertex() {
  if (RESTART) {
    //Initialization code goes here	
	
//	if (TIME < 500.0 && INDEX > int(TIME * amount / 500.0)) {
//		ACTIVE = false;
//	} else {
//		ACTIVE = true;
//	}
	
	uint alt_seed1 = hash(NUMBER + uint(1) + RANDOM_SEED);
	uint alt_seed2 = hash(NUMBER + uint(27) + RANDOM_SEED);
	uint alt_seed3 = hash(NUMBER + uint(43) + RANDOM_SEED);
	uint alt_seed4 = hash(NUMBER + uint(111) + RANDOM_SEED);
	
	CUSTOM.x = rand_from_seed(alt_seed1);
	vec2 position = vec2(rand_from_seed(alt_seed2) * 2.0 - 1.0,
	                     rand_from_seed(alt_seed3) * 2.0 - 1.0);
						
	// set rotation
	float inclination = atan(wind_power, -gravity);
	float rad = deg_to_rad(wind_direction_angle);

	mat3 scale = mat3(vec3(1.0, 0.0, 0.0),
                      vec3(0.0, 1.0, 0.0),
                      vec3(0.0, 0.0, 1.0));

	mat3 rotY = rotationMatrix(vec3(0.0,1.0,0.0),inclination);
	mat3 rotZ = rotationMatrix(vec3(0.0,0.0,1.0), -rad);

	mat3 model = rotZ*rotY*scale;
	
	TRANSFORM[0].xyz = model[0];
	TRANSFORM[1].xyz = model[1];
	TRANSFORM[2].xyz = model[2];

	
	TRANSFORM[3].xy = position.xy * 20.0;
	TRANSFORM[3].z = height * -1.0 + (rand_from_seed(alt_seed1) * 2.0 - 1.0);
	
	VELOCITY.z = init_vel;
  } else {
    //per-frame code goes here
	float prev_vel_z = VELOCITY.z;
	VELOCITY.z += DELTA * gravity;
	TRANSFORM[0].z = 1.0 + VELOCITY.z / 10.0;
	
	// windy stuff
	float rad = deg_to_rad(wind_direction_angle);
	vec2 wind_direction = vec2(cos(rad), sin(rad));
	VELOCITY.xy += DELTA * wind_power * wind_direction;


	vec3 rot_transform = TRANSFORM[2].xyz;
	if (prev_vel_z > 0.00001){
		rot_transform /= prev_vel_z;
	}

	// scaling by actual velocity
	TRANSFORM[2].xyz = rot_transform * VELOCITY.z / 1.01;

	origin/vg_rain
  }
}