/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "debug.inc"

/* Forward struct, union, and function declarations */
struct struct1;
struct struct3;
struct dyn4;

/* Struct, union, and function definitions */
struct struct1 {
    void* _0;
    int64_t _1;
};

typedef int64_t(*function0)(void*, int64_t);

typedef void(*function2)(void*, int64_t);

struct struct3 {
    int64_t _0;
    int64_t _1;
};

struct dyn4 {
    void* data_ptr;
    struct vtable_My_Trait* vtable;
};

/* Trait vtable type definitions */
struct vtable_My_Trait {
    int64_t(*b)(void*, int64_t);
    void(*c)(void*, int64_t);
};

/* Function forward definitions */
int64_t _1765_main(void);
int64_t _1761_b(void* _1761_self, int64_t _1761_x);
void _1763_c(void* _1763_self, int64_t _1763_x);

/* Trait vtable implementations */
struct vtable_My_Trait _1760_$vtable = {
    .b = _1761_b,
    .c = _1763_c,
};


/* Function definitions */
int64_t _1765_main(void){
    int64_t _1765_t1;
    int64_t _1765_t2;
    struct struct3 _1766_my_val;
    struct dyn4 _1765_t4;
    struct dyn4 _1766_my_dyn;
    int64_t _1765_t7;
    int64_t _1765_t9;
    int64_t _1765_t8;
    int64_t _1765_$retval;
    _1765_t1 = 100;
    _1765_t2 = 45;
    _1766_my_val = (struct struct3) {_1765_t1, _1765_t2};
    _1765_t4 = (struct dyn4) {&_1766_my_val, &_1760_$vtable};
    _1766_my_dyn = _1765_t4;
    _1765_t7 = 2;
    $lines[$line_idx++] = "tests/integration/traits/receiver-addr-object.orng:19:13:\n    my_dyn.>c(2)\n           ^";
    (void) _1766_my_dyn.vtable->c(_1766_my_dyn.data_ptr, _1765_t7);
    $line_idx--;
    _1765_t9 = 2;
    $lines[$line_idx++] = "tests/integration/traits/receiver-addr-object.orng:20:13:\n    my_dyn.>b(2)\n           ^";
    _1765_t8 = _1766_my_dyn.vtable->b(_1766_my_dyn.data_ptr, _1765_t9);
    $line_idx--;
    _1765_$retval = _1765_t8;
    return _1765_$retval;
}

int64_t _1761_b(void* _1761_self, int64_t _1761_x){
    int64_t _1761_t0;
    int64_t _1761_$retval;
    _1761_t0 = $mult_int64_t((*(struct struct3*)_1761_self)._1, _1761_x, "tests/integration/traits/receiver-addr-object.orng:11:59:\n    virtual fn b(&self, x: Int) -> Int { self.x + self.y * x }\n                                                         ^");
    _1761_$retval = $add_int64_t((*(struct struct3*)_1761_self)._0, _1761_t0, "tests/integration/traits/receiver-addr-object.orng:11:50:\n    virtual fn b(&self, x: Int) -> Int { self.x + self.y * x }\n                                                ^");
    return _1761_$retval;
}

void _1763_c(void* _1763_self, int64_t _1763_x){
    (*(struct struct3*)_1763_self)._0 = $mult_int64_t((*(struct struct3*)_1763_self)._0, _1763_x, "tests/integration/traits/receiver-addr-object.orng:13:54:\n    virtual fn c(&mut self, x: Int) -> () { self.x *= x }\n                                                    ^");
    return;
}


int main(void) {
  printf("%ld",_1765_main());
  return 0;
}
