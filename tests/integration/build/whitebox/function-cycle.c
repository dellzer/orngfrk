/* Code generated using the Orng compiler https://ornglang.org */
#ifndef ORNG_1688935250382866111
#define ORNG_1688935250382866111

#include <math.h>
#include <stdio.h>
#include <stdint.h>

/* Typedefs */

/* Interned Strings */

/* Function forward definitions */
int64_t _2_main();
int64_t _4_a(int64_t _4_n);
int64_t _6_b(int64_t _6_n);
int64_t _8_c(int64_t _8_n);

/* Function definitions */
int64_t _2_main() {
	int64_t _2_t1;
	int64_t _2_t0;
	int64_t _2_$retval;
BB0:
	_2_t1 = 47;
	_2_t0 = _4_a(_2_t1);
	_2_$retval = _2_t0;
	return _2_$retval;
}

int64_t _4_a(int64_t _4_n) {
	int64_t _4_t0;
	int64_t _4_$retval;
BB0:
	_4_t0 = _6_b(_4_n);
	_4_$retval = _4_t0;
	return _4_$retval;
}

int64_t _6_b(int64_t _6_n) {
	int64_t _6_t0;
	int64_t _6_$retval;
BB0:
	_6_t0 = _8_c(_6_n);
	_6_$retval = _6_t0;
	return _6_$retval;
}

int64_t _8_c(int64_t _8_n) {
	int64_t _8_t2;
	uint8_t _8_t1;
	int64_t _8_t0;
	int64_t _8_$retval;
	int64_t _8_t4;
BB0:
	_8_t2 = 47;
	_8_t1 = _8_n == _8_t2;
	if (!_8_t1) {
		goto BB9;
	} else {
		goto BB1;
	}
BB1:
	_8_t0 = 47;
	goto BB6;
BB6:
	_8_$retval = _8_t0;
	return _8_$retval;
BB9:
	_8_t4 = _4_a(_8_n);
	_8_t0 = _8_t4;
	goto BB6;
}


int main()
{
  printf("%ld",_2_main());
  return 0;
}

#endif