/* Code generated using the Orng compiler https://ornglang.org */
#ifndef ORNG_1688936009658965288
#define ORNG_1688936009658965288

#include <math.h>
#include <stdio.h>
#include <stdint.h>

/* Typedefs */

/* Interned Strings */

/* Function forward definitions */
int64_t _2_main();

/* Function definitions */
int64_t _2_main() {
	int64_t _3_x;
	int64_t* _2_t1;
	int64_t _2_t2;
	int64_t* _2_t3;
	int64_t _2_$retval;
BB0:
	_3_x = 5;
	_2_t1 = &_3_x;
	_2_t2 = 74;
	**&_2_t1 = _2_t2;
	_2_t3 = &_3_x;
	_2_$retval = *_2_t3;
	return _2_$retval;
}


int main()
{
  printf("%ld",_2_main());
  return 0;
}

#endif