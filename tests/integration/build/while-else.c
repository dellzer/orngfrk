/* Code generated using the Orng compiler https://ornglang.org */
#ifndef ORNG_1685230955
#define ORNG_1685230955

#include <math.h>
#include <stdio.h>
#include <stdint.h>

/* Function Definitions */
int test_main();

int test_main() {
	int64_t _33_x;
	int64_t _31_t3;
	int64_t _31_t4;
	uint8_t _31_t2;
	int64_t _31_t5;
	int64_t _31_t6;
	int64_t _31_t7;
	int64_t _31_t0;
	int64_t _31_t9;
	int64_t _31_t10;
	int64_t _31_t11;
	int64_t _31_$retval;
BB0: // 1
// Versions: 8
	_33_x = 0;
	goto BB1;
BB1: // 2
// Versions: 1
	_31_t3 = _33_x;
// Versions: 1
	_31_t4 = 10;
// Versions: 5
	_31_t2 = _31_t3 < _31_t4;
	if (!_31_t2) {
		goto BB7;
	} else {
		goto BB2;
	}
BB2: // 1
// Versions: 5
	_31_t2 = 1;
	goto BB3;
BB3: // 2
	if (!_31_t2) {
		goto BB5;
	} else {
		goto BB4;
	}
BB4: // 1
// Versions: 1
	_31_t5 = _33_x;
// Versions: 1
	_31_t6 = 1;
// Versions: 1
	_31_t7 = _31_t5 + _31_t6;
// Versions: 2
	_31_t0 = 0;
// Versions: 1
	_31_t9 = _31_t7;
// Versions: 1
	_31_t10 = 1;
// Versions: 1
	_31_t11 = _31_t9 + _31_t10;
// Versions: 8
	_33_x = _31_t11;
	goto BB1;
BB5: // 1
// Versions: 2
	_31_t0 = _33_x;
// Versions: 1
	_31_$retval = _31_t0;
	goto end;
BB7: // 1
// Versions: 5
	_31_t2 = 0;
	goto BB3;
end:
	return _31_$retval;
}


int main()
{
  printf("%d", test_main());
  return 0;
}

#endif
