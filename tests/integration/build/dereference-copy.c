/* Code generated using the Orng compiler https://ornglang.org */
#ifndef ORNG_1685778818
#define ORNG_1685778818

#include <math.h>
#include <stdio.h>
#include <stdint.h>

/* Function Definitions */
int test_main();

int test_main() {
	int64_t _106_t1;
	int64_t* _107_y;
	int64_t _106_t4;
	int64_t _106_$retval;
BB0:
	_106_t1 = 4;
	_107_y = &_106_t1;
	_106_t4 = 28;
	*_107_y = _106_t4;
	_106_$retval = *_107_y;
	return _106_$retval;
}

int main()
{
  printf("%d", test_main());
  return 0;
}

#endif
