/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "debug.inc"

/* Typedefs */
typedef struct {
        uint8_t* _0;
        int64_t _1;
} struct0;

/* Interned Strings */
char* string_0 = "\x5C";

/* Function forward definitions */
uint8_t _1364_main(void);

/* Function definitions */
uint8_t _1364_main(void){
    struct0 _1365_x;
    int64_t _1364_t1;
    uint8_t _1364_$retval;
    _1365_x = (struct0) {(uint8_t*)string_0, 1};
    _1364_t1 = 0;
    $bounds_check(_1364_t1, _1365_x._1, "tests/integration/strings/string-slash.orng:2:3:\nfn main() -> Byte {\n ^");
    _1364_$retval = *((uint8_t*)_1365_x._0 + _1364_t1);
    return _1364_$retval;
}

int main(void) {
  printf("%u",_1364_main());
  return 0;
}
