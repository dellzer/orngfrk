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
char* string_0 = "\x48\x65\x6C\x6C\x6F\x2C\x20\x57\x6F\x72\x6C\x64\x21\x0A\x20\x54\x68\x69\x73\x0A\x20\x20\x49\x73\x0A\x20\x20\x20\x41\x0A\x20\x20\x20\x20\x5C\x5C\x6D\x75\x6C\x74\x69\x2D\x6C\x69\x6E\x65\x0A\x20\x20\x20\x20\x20\x73\x74\x72\x69\x6E\x67\x21\x0A";

/* Function forward definitions */
int64_t _1500_main(void);

/* Function definitions */
int64_t _1500_main(void){
    struct0 _1501_x;
    int64_t _1500_$retval;
    _1501_x = (struct0) {(uint8_t*)string_0, 60};
    _1500_$retval = _1501_x._1;
    return _1500_$retval;
}

int main(void) {
  printf("%ld",_1500_main());
  return 0;
}
