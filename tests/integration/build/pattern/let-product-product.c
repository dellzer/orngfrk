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
} struct0;

typedef struct {
    struct0 _0;
    struct0 _1;
} struct1;

/* Function forward definitions */
int64_t _1_main();

/* Function definitions */
int64_t _1_main() {
    struct0 _1_t1;
    struct0 _1_t4;
    struct1 _1_t0;
    int64_t _2_x;
    int64_t _2_y;
    int64_t _2_a;
    int64_t _2_b;
    int64_t _1_$retval;
    _1_t1 = (struct0) {100, 20};
    _1_t4 = (struct0) {20, 2};
    _1_t0 = (struct1) {_1_t1, _1_t4};
    _2_x = _1_t0._0._0;
    _2_y = _1_t0._0._1;
    _2_a = _1_t0._1._0;
    _2_b = _1_t0._1._1;
    _1_$retval = _2_x + _2_y + _2_a + _2_b;
    return _1_$retval;
}

int main()
{
  printf("%ld",_1_main());
  return 0;
}
