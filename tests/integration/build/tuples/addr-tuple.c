/* Code generated using the Orng compiler https://ornglang.org */
#ifndef ORNG_1688935524738096727
#define ORNG_1688935524738096727

#include <math.h>
#include <stdio.h>
#include <stdint.h>

/* Typedefs */
typedef struct {
	int64_t _0;
	int64_t _1;
} struct0;

/* Interned Strings */

/* Function forward definitions */
int64_t _2_main();

/* Function definitions */
int64_t _2_main() {
	int64_t _2_t1;
	int64_t _2_t4;
	struct0 _3_x;
	struct0* _2_t5;
	int64_t _2_t7;
	int64_t _2_t9;
	int64_t _2_$retval;
BB0:
	_2_t1 = 19;
	_2_t4 = 39;
	_3_x = (struct0) {_2_t1, _2_t4};
	_2_t5 = &_3_x;
	_2_t7 = *&((_2_t5)->_0);
	_2_t9 = *&((_2_t5)->_1);
	_2_$retval = _2_t7 + _2_t9;
	return _2_$retval;
}


int main()
{
  printf("%ld",_2_main());
  return 0;
}

#endif
