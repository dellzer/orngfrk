/* Code generated using the Orng compiler https://ornglang.org */
#ifndef ORNG_1685159969
#define ORNG_1685159969

#include <math.h>
#include <stdio.h>
#include <stdint.h>

/* Function Definitions */
int test_main();

int test_main() {
	int retval;
	int64_t _136_t0;
	int64_t _137_x;
	int64_t _136_t2;
	int64_t _138_i;
	int64_t _136_t4;
	uint8_t _136_t5;
	uint8_t _136_t3;
	int64_t _136_t6;
	int64_t _136_t7;
	int64_t _136_t8;
	int64_t _0;
BB0: // 1
	_136_t0 = 0;
	_137_x = 0;
	_136_t2 = 0;
	_138_i = 0;
	goto BB1;
BB1: // 2
	_136_t4 = 10;
	_136_t5 = _138_i <= _136_t4;
	if (!_136_t5) {
		goto BB7;
	} else {
		goto BB2;
	}
BB2: // 1
	_136_t3 = 1;
	goto BB3;
BB3: // 2
	if (!_136_t3) {
		goto BB6;
	} else {
		goto BB4;
	}
BB4: // 1
	_136_t6 = _137_x + _138_i;
	_137_x = _136_t6;
	_136_t7 = 1;
	_136_t8 = _138_i + _136_t7;
	_138_i = _136_t8;
	goto BB1;
BB6: // 1
	retval = _137_x;
	goto end;
BB7: // 1
	_136_t3 = 0;
	goto BB3;
end:
	return retval;
}


int main()
{
  printf("%d", test_main());
  return 0;
}

#endif
