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
	uint8_t _1;
	int64_t _2;
BB0:;
	goto BB1;
BB1:;
	_1 = 0;
	if (!_1) {
		goto BB4;
	} else {
		goto BB1;
	}
BB4:;
	_2 = 25;
	retval = _2;
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
