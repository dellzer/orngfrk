/* Code generated using the Orng compiler https://ornglang.org */
#ifndef ORNG_1688935563724879166
#define ORNG_1688935563724879166

#include <math.h>
#include <stdio.h>
#include <stdint.h>

/* Typedefs */
typedef struct {
	int64_t _0;
	int64_t _1;
} struct0;
typedef struct {
	struct0 _0;
	struct0 _1;
} struct1;

/* Interned Strings */

/* Function forward definitions */
int64_t _2_main();

/* Function definitions */
int64_t _2_main() {
	int64_t _2_t2;
	int64_t _2_t3;
	struct0 _2_t1;
	int64_t _2_t5;
	int64_t _2_t6;
	struct0 _2_t4;
	struct1 _3_x;
	int64_t _2_t8;
	int64_t _2_$retval;
BB0:
	_2_t2 = 1;
	_2_t3 = 2;
	_2_t1 = (struct0) {_2_t2, _2_t3};
	_2_t5 = 3;
	_2_t6 = 4;
	_2_t4 = (struct0) {_2_t5, _2_t6};
	_3_x = (struct1) {_2_t1, _2_t4};
	_2_t8 = 77;
	(&((&_3_x)->_0))->_0 = _2_t8;
	_2_$retval = (&((&_3_x)->_0))->_0;
	return _2_$retval;
}


int main()
{
  printf("%ld",_2_main());
  return 0;
}

#endif