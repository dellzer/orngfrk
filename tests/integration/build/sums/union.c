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
} struct1;

typedef struct {
    uint64_t tag;
    union {
        int64_t _0;
        struct1 _1;
        int64_t _2;
        struct1 _3;
    };
} struct0;

/* Interned Strings */
char* string_0 = "\x4C\x6D\x61\x6F\x21";
char* string_1 = "\x6C\x6F\x6C";

/* Function forward definitions */
int64_t _1454_main(void);

/* Function definitions */
int64_t _1454_main(void){
    int64_t _1454_t0;
    struct0 _1455_x;
    struct1 _1454_t2;
    struct1 _1454_t4;
    int64_t _1454_t6;
    uint64_t _1454_t8;
    int64_t _1454_$retval;
    _1454_t0 = 3;
    _1455_x = (struct0) {.tag=0, ._0=_1454_t0};
    _1454_t2 = (struct1) {(uint8_t*)string_0, 5};
    _1455_x = (struct0) {.tag=1, ._1=_1454_t2};
    _1454_t4 = (struct1) {(uint8_t*)string_1, 3};
    _1455_x = (struct0) {.tag=3, ._3=_1454_t4};
    _1454_t6 = 108;
    _1455_x = (struct0) {.tag=2, ._2=_1454_t6};
    _1454_t8 = 2;
    $tag_check(_1454_t8, 2, "tests/integration/sums/union.orng:6:3:\nfn main()->Int {\n ^");
    _1454_$retval = _1455_x._2;
    return _1454_$retval;
}

int main(void) {
  printf("%ld",_1454_main());
  return 0;
}
