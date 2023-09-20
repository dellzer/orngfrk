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
/* Function forward definitions */
int64_t _2_main();
int64_t _4_f(int64_t _4_x);

/* Function definitions */
int64_t _2_main() {
    int64_t _2_t0;
    int64_t _2_$retval;
    $lines[$line_idx++] = "tests/integration/expressions/neq-0-lhs.orng:3:7:\n    f(1)\n     ^";
    _2_t0 = _4_f(1);
    $line_idx--;
    _2_$retval = _2_t0;
    return _2_$retval;
}

int64_t _4_f(int64_t _4_x) {
    int64_t _4_t0;
    int64_t _4_$retval;
    if (_4_x) {
        goto BB3;
    } else {
        goto BB7;
    }
BB3:
    _4_t0 = 174;
    goto BB6;
BB7:
    _4_t0 = 3;
BB6:
    _4_$retval = _4_t0;
    return _4_$retval;
}

int main()
{
  printf("%ld",_2_main());
  return 0;
}