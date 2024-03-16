/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "debug.inc"

/* Forward struct, union, and function declarations */
struct struct1;
struct struct2;
struct struct4;

/* Struct, union, and function definitions */
struct struct1 {
    void* _0;
    int64_t _1;
};

typedef int64_t(*function0)(void*, int64_t);

struct struct2 {
    int64_t _0;
    int64_t _1;
};

struct struct4 {
    struct struct2* _0;
    int64_t _1;
};

typedef int64_t(*function3)(struct struct2*, int64_t);

/* Trait vtable type definitions */
/* Function forward definitions */
int64_t _17_main(void);
int64_t _15_a(void* _15_$self_ptr, int64_t _15_x);

/* Trait vtable implementations */

/* Function definitions */
int64_t _17_main(void){
    int64_t _17_t1;
    int64_t _17_t2;
    struct struct2 _18_my_val;
    struct struct2* _18_my_val_ptr;
    int64_t _17_t7;
    function3 _17_t8;
    int64_t _17_t6;
    int64_t _17_t9;
    int64_t _17_$retval;
    _17_t1 = 200;
    _17_t2 = 45;
    _18_my_val = (struct struct2) {_17_t1, _17_t2};
    _18_my_val_ptr = &_18_my_val;
    _17_t7 = 2;
    _17_t8 = (function3) _15_a;
    $lines[$line_idx++] = "tests/integration/traits/addr-receiver-basic.orng:15:17:\n    my_val_ptr.>a(2) + 3\n               ^";
    _17_t6 = _17_t8(_18_my_val_ptr, _17_t7);
    $line_idx--;
    _17_t9 = 3;
    _17_$retval = $add_int64_t(_17_t6, _17_t9, "tests/integration/traits/addr-receiver-basic.orng:15:23:\n    my_val_ptr.>a(2) + 3\n                     ^");
    return _17_$retval;
}

int64_t _15_a(void* _15_$self_ptr, int64_t _15_x){
    struct struct2 _16_self;
    int64_t _15_t1;
    int64_t _15_$retval;
    _16_self = *(struct struct2*)_15_$self_ptr;
    _15_t1 = $mult_int64_t(_16_self._1, _15_x, "tests/integration/traits/addr-receiver-basic.orng:9:50:\n    fn a(self, x: Int) -> Int { self.x + self.y * x }\n                                                ^");
    _15_$retval = $add_int64_t(_16_self._0, _15_t1, "tests/integration/traits/addr-receiver-basic.orng:9:41:\n    fn a(self, x: Int) -> Int { self.x + self.y * x }\n                                       ^");
    return _15_$retval;
}


int main(void) {
  printf("%ld",_17_main());
  return 0;
}
