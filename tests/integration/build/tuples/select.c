/* Code generated using the Orng compiler https://ornglang.org */
#ifndef ORNG_1686794864
#define ORNG_1686794864

#include <math.h>
#include <stdio.h>
#include <stdint.h>

/* Typedefs */
typedef int64_t(*function0)();
typedef struct {
	int64_t _0;
	int64_t _1;
} struct3;

/* Function forward definitions */
int64_t _303_main();

/* Function definitions */
int64_t _303_main() {
	int64_t _303_t1;
	int64_t _303_t2;
	struct3 _304_x;
	int64_t _303_t3;
	int64_t _303_t4;
	int64_t _303_$retval;
BB0:
	_303_t1 = 50;
	_303_t2 = 5;
	_304_x = (struct3) {_303_t1, _303_t2};
	_303_t3 = _304_x._0;
	_303_t4 = _304_x._1;
	_303_$retval = _303_t3 + _303_t4;
	return _303_$retval;
}


int main()
{
  printf("%ld",_303_main());
  return 0;
}

#endif