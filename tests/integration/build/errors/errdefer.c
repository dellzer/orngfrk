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
    uint64_t tag;
} struct0;

/* Function forward definitions */
int64_t _2_main();
struct0 _4_f(int64_t* _4_x,uint8_t _4_fail);

/* Function definitions */
int64_t _2_main() {
    int64_t _3_x;
    int64_t _3_y;
    int64_t* _2_t3;
    struct0 _2_t2;
    int64_t* _2_t6;
    struct0 _2_t5;
    int64_t _2_$retval;
    _3_x = 10;
    _3_y = 10;
    _2_t3 = &_3_x;
    $lines[$line_idx++] = "tests/integration/errors/errdefer.orng:5:7:\n    f(&mut x, true)\n     ^";
    _2_t2 = _4_f(_2_t3, 1);
    $line_idx--;
    _2_t6 = &_3_y;
    $lines[$line_idx++] = "tests/integration/errors/errdefer.orng:6:7:\n    f(&mut y, false)\n     ^";
    _2_t5 = _4_f(_2_t6, 0);
    $line_idx--;
    _2_$retval = _3_x + _3_y;
    return _2_$retval;
}

struct0 _4_f(int64_t* _4_x,uint8_t _4_fail) {
    struct0 _4_$retval;
    **&_4_x = 4;
    if (_4_fail) {
        goto BB1;
    } else {
        goto BB4;
    }
BB1:
    _4_$retval = (struct0) {.tag=0};
    **&_4_x = 115;
    return _4_$retval;
BB4:
    _4_$retval = (struct0) {.tag=1};
    return _4_$retval;
}

int main()
{
  printf("%ld",_2_main());
  return 0;
}
