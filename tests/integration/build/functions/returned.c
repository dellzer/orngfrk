/* Code generated using the Orng compiler https://ornglang.org */
#ifndef ORNG_1686794864
#define ORNG_1686794864

#include <math.h>
#include <stdio.h>
#include <stdint.h>

/* Typedefs */
typedef int64_t(*function0)();
typedef int64_t(*function3)(int64_t);
typedef function3(*function4)();

/* Function forward definitions */
int64_t _234_main();
function3 _236_f();
int64_t _237_addFour(int64_t x);

/* Function definitions */
int64_t _234_main() {
	function3 _234_t0;
	int64_t _234_t2;
	int64_t _234_t1;
	int64_t _234_$retval;
BB0:
	_234_t0 = _236_f();
	_234_t2 = 45;
	_234_t1 = _234_t0(_234_t2);
	_234_$retval = _234_t1;
	return _234_$retval;
}

function3 _236_f() {
	function3 _236_$retval;
BB0:
	_236_$retval = _237_addFour;
	return _236_$retval;
}

int64_t _237_addFour(int64_t x) {
	int64_t _237_t0;
	int64_t _237_$retval;
BB0:
	_237_t0 = 4;
	_237_$retval = x + _237_t0;
	return _237_$retval;
}


int main()
{
  printf("%ld",_234_main());
  return 0;
}

#endif