/* Code generated using the Orng compiler https://ornglang.org */
#ifndef ORNG_1688939292250461862
#define ORNG_1688939292250461862

#include <math.h>
#include <stdio.h>
#include <stdint.h>

/* Typedefs */
typedef int64_t(*function0)(int64_t);

/* Interned Strings */

/* Function forward definitions */
int64_t _2_main();
int64_t _4_$anon0(int64_t _4_x);
int64_t _6_apply(function0 _6_f,int64_t _6_x);

/* Function definitions */
int64_t _2_main() {
	function0 _2_t0;
	int64_t _2_t2;
	int64_t _2_t1;
	int64_t _2_$retval;
BB0:
	_2_t0 = _4_$anon0;
	_2_t2 = 43;
	_2_t1 = _6_apply(_2_t0, _2_t2);
	_2_$retval = _2_t1;
	return _2_$retval;
}

int64_t _4_$anon0(int64_t _4_x) {
	int64_t _4_$retval;
BB1:
	_4_$retval = _4_x;
	return _4_$retval;
}

int64_t _6_apply(function0 _6_f,int64_t _6_x) {
	int64_t _6_t0;
	int64_t _6_$retval;
BB0:
	_6_t0 = _6_f(_6_x);
	_6_$retval = _6_t0;
	return _6_$retval;
}


int main()
{
  printf("%ld",_2_main());
  return 0;
}

#endif