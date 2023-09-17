/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

/* Debug information */
static const char* $lines[1024];
static uint16_t $line_idx = 0;

inline static void $panic(const char *restrict msg) {
    fprintf(stderr, "panic: %s\n", msg);
    for(uint16_t $i = 0; $i < $line_idx; $i++) {
        fprintf(stderr, "%s\n", $lines[$line_idx - $i - 1]);
    }
    exit(1);
}

inline static void $bounds_check(const int64_t idx, const int64_t length, const char *restrict line) {
    if (0 > idx || idx >= length) {
        $lines[$line_idx++] = line;
        $panic("bounds check failed");
    }
}

inline static void $tag_check(const int64_t tag, const int64_t sel, const char *restrict line) {
    if (tag != sel) {
        $lines[$line_idx++] = line;
        $panic("inactive field");
    }
}
/* Typedefs */
typedef struct {
    int64_t _0;
    int64_t _1;
    int64_t _2;
    int64_t _3;
} struct0;

typedef struct {
    int64_t* _0;
    int64_t _1;
} struct1;

/* Function forward definitions */
int64_t _2_main();
int64_t _4_f(struct1 _4_x);

/* Function definitions */
int64_t _2_main() {
    struct0 _3_x;
    int64_t* _2_t9;
    struct1 _3_y;
    int64_t _2_t11;
    int64_t _2_$retval;
    _3_x = (struct0) {1, 2, 3, 4};
    _2_t9 = (int64_t*)&_3_x;
    _3_y = (struct1) {_2_t9, 4};
    $lines[$line_idx++] = "tests/integration/slices/fn-pass.orng:5:7:\n    f(y)\n     ^";
    _2_t11 = _4_f(_3_y);
    $line_idx--;
    _2_$retval = _2_t11;
    return _2_$retval;
}

int64_t _4_f(struct1 _4_x) {
    int64_t _4_$retval;
    $bounds_check(1, _4_x._1, "tests/integration/slices/fn-pass.orng:8:24:\nfn f(x: []Int)->Int {x[1] + 80}\n                      ^");
    _4_$retval = *((int64_t*)_4_x._0 + 1) + 80;
    return _4_$retval;
}

int main()
{
  printf("%ld",_2_main());
  return 0;
}
