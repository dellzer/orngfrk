/* Code generated using the Orng compiler https://ornglang.org */
#ifndef ORNG_1684812568
#define ORNG_1684812568

#include <math.h>
#include <stdio.h>
#include <stdint.h>

/* Function Definitions */
int test_main();

int test_main() {
	int retval;
	uint8_t _0;
	uint8_t _1;
	uint8_t _2;
	uint8_t _4;
	uint8_t _3;
BB0:;
	_2 = 0;
	if (!_2) {
		goto BB6;
	} else {
		goto BB1;
	}
BB1:;
	_1 = 1;
	goto BB2;
BB2:;
	if (!_1) {
		goto BB5;
	} else {
		goto BB3;
	}
BB3:;
	_0 = 1;
	goto BB4;
BB4:;
	retval = _0;
	goto end;
BB5:;
	_4 = 1;
	_0 = _4;
	goto BB4;
BB6:;
	_3 = 0;
	_1 = _3;
	goto BB2;
end:
	return retval;
}


int main()
{
  printf("%d", test_main());
  return 0;
}

#endif
