/* Code generated using the Orng compiler https://ornglang.org */
#ifndef ORNG_1688935720197335580
#define ORNG_1688935720197335580

#include <math.h>
#include <stdio.h>
#include <stdint.h>

/* Typedefs */
typedef struct {
	uint8_t* _0;
	int64_t _1;
} struct0;

/* Interned Strings */
char* string_0 = "\x48\x65\x6C\x6C\x6F\x2C\x20\x4F\x72\x6E\x67\x21\x20\xF0\x9F\x8D\x8A";

/* Function forward definitions */
struct0 _2_main();

/* Function definitions */
struct0 _2_main() {
	struct0 _2_$retval;
BB0:
	_2_$retval = (struct0) {string_0, 18};
	return _2_$retval;
}


int main()
{
  printf("%s",_2_main()._0);
  return 0;
}

#endif