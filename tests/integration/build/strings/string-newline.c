/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "debug.inc"

/* Forward struct, union, and function declarations */
struct struct0;

/* Struct, union, and function definitions */
struct struct0 {
    uint8_t* _0;
    int64_t _1;
};

/* Interned Strings */
char* string_0 = "\x0A\x0D\x09\x27\x22";

/* Function forward definitions */
uint8_t _1527_main(void);


/* Function definitions */
uint8_t _1527_main(void){
    struct struct0 _1528_x;
    int64_t _1527_t2;
    uint8_t _1527_$retval;
    _1528_x = (struct struct0) {(uint8_t*)string_0, 5};
    _1527_t2 = 0;
    $bounds_check(_1527_t2, _1528_x._1, "tests/integration/strings/string-newline.orng:2:8:\nfn main() -> Byte {\n      ^");
    _1527_$retval = *((uint8_t*)_1528_x._0 + _1527_t2);
    return _1527_$retval;
}


int main(void) {
  printf("%u",_1527_main());
  return 0;
}
