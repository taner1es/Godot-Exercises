shader_type particles;

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
		uint alt_seed1 = hash(NUMBER + uint(1) + RANDOM_SEED);
		uint alt_seed2 = hash(NUMBER + uint(27) + RANDOM_SEED);
		uint alt_seed3 = hash(NUMBER + uint(43) + RANDOM_SEED);
		uint alt_seed4 = hash(NUMBER + uint(111) + RANDOM_SEED);
		
		CUSTOM.x = rand_from_seed(alt_seed1);
		vec3 position = vec3(rand_from_seed(alt_seed2) * 2.0 - 1.0,
                     		 rand_from_seed(alt_seed3) * 2.0 - 1.0,
                     		 rand_from_seed(alt_seed4) * 2.0 - 1.0);
		TRANSFORM[3].xyz = position * 20.0;
		
		VELOCITY.z = 20.0;
		COLOR.xyz = vec3(.5,.5,.5);
		CUSTOM.y = VELOCITY.z * 0.1;
	} else {
		//per-frame code goes here
	}
}