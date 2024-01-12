/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "debug.inc"

/* Forward typedefs */
struct struct1;

/* Typedefs */
struct struct1 {
    uint64_t tag;
    union {
        int64_t _0;
    };
};

typedef struct struct1(*function0)(void);

/* Function forward definitions */
int64_t _1419_main(void);
struct struct1 _1421_get_the_sum(void);

/* Function definitions */
int64_t _1419_main(void){
    function0 _1419_t0;
    struct struct1 _1419_t1;
    struct struct1 _1420_a;
    uint64_t _1419_t2;
    int64_t _1419_$retval;
    _1419_t0 = _1421_get_the_sum;
    $lines[$line_idx++] = "tests/integration/sums/1-sum.orng:5:25:\n    let a = get_the_sum()\n                       ^";
    _1419_t1 = _1419_t0();
    $line_idx--;
    _1420_a = _1419_t1;
    _1419_t2 = _1419_t1.tag;
    $tag_check(_1419_t2, 0, "tests/integration/sums/1-sum.orng:4:3:\nfn main() -> Int {\n ^");
    _1419_$retval = _1420_a._0;
    return _1419_$retval;
}

struct struct1 _1421_get_the_sum(void){
    int64_t _1421_t0;
    struct struct1 _1421_$retval;
    _1421_t0 = 235;
    _1421_$retval = (struct struct1) {.tag=0, ._0=_1421_t0};
    return _1421_$retval;
}

int main(void) {
  printf("%ld",_1419_main());
  return 0;
}
