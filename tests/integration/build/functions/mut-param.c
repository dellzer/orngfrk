/* Code generated using the Orng compiler https://ornglang.org */
#ifndef ORNG_1687129465
#define ORNG_1687129465

#include <math.h>
#include <stdio.h>
#include <stdint.h>

/* Typedefs */

/* Function forward definitions */
int64_t _219_main();
int64_t _220_sumDown(int64_t _220_x);

/* Function definitions */
int64_t _219_main() {
	int64_t _219_t1;
	int64_t _219_t0;
	int64_t _219_t2;
	int64_t _219_$retval;
BB0:
	_219_t1 = 8;
	_219_t0 = _220_sumDown(_219_t1);
	_219_t2 = 2;
	_219_$retval = _219_t0 + _219_t2;
	return _219_$retval;
}

int64_t _220_sumDown(int64_t _220_x) {
	int64_t _222_i;
	int64_t _220_t2;
	uint8_t _220_t1;
	int64_t _220_t4;
	int64_t _220_$retval;
BB0:
	_222_i = _220_x;
	goto BB1;
BB1:
	_220_t2 = 0;
	_220_t1 = _222_i >= _220_t2;
	if (!_220_t1) {
		goto BB10;
	} else {
		goto BB2;
	}
BB2:
	_220_x = _220_x + _222_i;
	_220_t4 = 1;
	_222_i = _222_i - _220_t4;
	goto BB1;
BB10:
	_220_$retval = _220_x;
	return _220_$retval;
}


int main()
{
  printf("%ld",_219_main());
  return 0;
}

#endif
