/* Code generated using the Orng compiler https://ornglang.org */
#ifndef ORNG_1686794864
#define ORNG_1686794864

#include <math.h>
#include <stdio.h>
#include <stdint.h>

/* Typedefs */
typedef int64_t(*function0)();
typedef int64_t(*function3)(int64_t);

/* Function forward definitions */
int64_t _197_main();
int64_t _198_return53(int64_t x);

/* Function definitions */
int64_t _197_main() {
	int64_t _197_t1;
	int64_t _197_t0;
	int64_t _197_$retval;
BB0:
	_197_t1 = 53;
	_197_t0 = _198_return53(_197_t1);
	_197_$retval = _197_t0;
	return _197_$retval;
}

int64_t _198_return53(int64_t x) {
	int64_t _198_$retval;
BB0:
	_198_$retval = x;
	return _198_$retval;
}


int main()
{
  printf("%ld",_197_main());
  return 0;
}

#endif
