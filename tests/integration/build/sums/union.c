/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "debug.inc"

/* Forward struct, union, and function declarations */
struct struct0;
struct struct1;

/* Struct, union, and function definitions */
struct struct1 {
    uint8_t* _0;
    int64_t _1;
};

struct struct0 {
    uint64_t tag;
    union {
        int64_t _0;
        struct struct1 _1;
        int64_t _2;
        struct struct1 _3;
    };
};

/* Interned Strings */
char* string_0 = "\x4C\x6D\x61\x6F\x21";
char* string_1 = "\x6C\x6F\x6C";

/* Function forward definitions */
int64_t _1624_main(void);


/* Function definitions */
int64_t _1624_main(void){
    int64_t _1624_t0;
    struct struct0 _1625_x;
    struct struct1 _1624_t3;
    struct struct1 _1624_t5;
    int64_t _1624_t7;
    uint64_t _1624_t9;
    int64_t _1624_$retval;
    _1624_t0 = 3;
    _1625_x = (struct struct0) {.tag=0, ._0=_1624_t0};
    _1624_t3 = (struct struct1) {(uint8_t*)string_0, 5};
    _1625_x = (struct struct0) {.tag=1, ._1=_1624_t3};
    _1624_t5 = (struct struct1) {(uint8_t*)string_1, 3};
    _1625_x = (struct struct0) {.tag=3, ._3=_1624_t5};
    _1624_t7 = 108;
    _1625_x = (struct struct0) {.tag=2, ._2=_1624_t7};
    _1624_t9 = 2;
    $tag_check(_1624_t9, 2, "tests/integration/sums/union.orng:6:8:\nfn main()->Int {\n      ^");
    _1624_$retval = _1625_x._2;
    return _1624_$retval;
}


int main(void) {
  printf("%ld",_1624_main());
  return 0;
}
