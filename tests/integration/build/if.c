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
	int64_t _0;
	int64_t _1;
	int64_t _113_x;
	uint8_t _2;
	int64_t _3;
	int64_t _4;
BB0:;
	_1 = 4;
	_113_x = _1;
	_2 = 1;
	if (!_2) {
		goto BB2;
	} else {
		goto BB1;
	}
BB1:;
	_3 = 7;
	_4 = _113_x + _3;
	_0 = _4;
	goto BB2;
BB2:;
	retval = _0;
	goto end;
end:
	return retval;
}


int main()
{
  printf("%d", test_main());
  return 0;
}

#endif
