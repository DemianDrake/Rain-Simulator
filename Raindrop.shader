shader_type particles;

uniform float height;
uniform float gravity;
uniform float init_vel;
uniform float amount;

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
	
	TRANSFORM[3].xy = position.xy * 20.0;
	TRANSFORM[3].z = height * -1.0 + (rand_from_seed(alt_seed1) * 2.0 - 1.0);
	
	VELOCITY.z = init_vel;
  } else {
    //per-frame code goes here
	VELOCITY.z += DELTA * gravity;
	TRANSFORM[0].z = 1.0 + VELOCITY.z / 10.0;
  }
}