/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

/* Debug information */
static const char* $lines[1024];
static uint16_t $line_idx = 0;

/* Function forward definitions */
int64_t _2_main();

/* Function definitions */
int64_t _2_main() {
    int64_t _3_x;
    int64_t* _3_y;
    int64_t _5_z;
    int64_t* _2_t8;
    int64_t _2_t2;
    int64_t _2_$retval;
    _3_x = 0;
    _3_y = &_3_x;
    if (*_3_y == 0) {
        goto BB1;
    } else {
        goto BB9;
    }
BB9:
    _2_t2 = 1000;
    goto BB6;
BB6:
    _2_$retval = _2_t2;
    return _2_$retval;
BB1:
    _5_z = *_3_y;
    _2_t8 = _3_y;
    **&_2_t8 = _5_z + _5_z;
    _5_z = _5_z - _5_z;
    _5_z = _5_z * _5_z;
    _5_z = _5_z / (_5_z + 1);
    _5_z = _5_z % (_5_z + 1);
    _5_z = powf(_5_z, (_5_z + 1));
    _5_z = _5_z * -1.0e+00;
    _2_t2 = _5_z;
    goto BB6;
}

int main()
{
  printf("%ld",_2_main());
  return 0;
}
