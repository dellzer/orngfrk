/* Code generated using the Orng compiler https://ornglang.org */
#ifndef ORNG_1688936368988572749
#define ORNG_1688936368988572749

#include <math.h>
#include <stdio.h>
#include <stdint.h>

/* Typedefs */

/* Interned Strings */

/* Function forward definitions */
int64_t _2_main();
int64_t _4_id(int64_t _4_x);

/* Function definitions */
int64_t _2_main() {
	int64_t _2_t1;
	int64_t _2_t0;
	int64_t _2_$retval;
BB0:
	_2_t1 = 52;
	_2_t0 = _4_id(_2_t1);
	_2_$retval = _2_t0;
	return _2_$retval;
}

int64_t _4_id(int64_t _4_x) {
	int64_t _4_$retval;
BB1:
	_4_$retval = _4_x;
	return _4_$retval;
}


int main()
{
  printf("%ld",_2_main());
  return 0;
}

#endif