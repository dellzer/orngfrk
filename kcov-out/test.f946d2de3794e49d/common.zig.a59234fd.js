var data = {lines:[
{"lineNum":"    1","line":"const std = @import(\"std\");"},
{"lineNum":"    2","line":""},
{"lineNum":"    3","line":"/// A custom N-bit floating point type, representing `f * 2^e`."},
{"lineNum":"    4","line":"/// e is biased, so it be directly shifted into the exponent bits."},
{"lineNum":"    5","line":"/// Negative exponent indicates an invalid result."},
{"lineNum":"    6","line":"pub fn BiasedFp(comptime T: type) type {"},
{"lineNum":"    7","line":"    const MantissaT = mantissaType(T);"},
{"lineNum":"    8","line":""},
{"lineNum":"    9","line":"    return struct {"},
{"lineNum":"   10","line":"        const Self = @This();"},
{"lineNum":"   11","line":""},
{"lineNum":"   12","line":"        /// The significant digits."},
{"lineNum":"   13","line":"        f: MantissaT,"},
{"lineNum":"   14","line":"        /// The biased, binary exponent."},
{"lineNum":"   15","line":"        e: i32,"},
{"lineNum":"   16","line":""},
{"lineNum":"   17","line":"        pub fn zero() Self {","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   18","line":"            return .{ .f = 0, .e = 0 };","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   19","line":"        }"},
{"lineNum":"   20","line":""},
{"lineNum":"   21","line":"        pub fn zeroPow2(e: i32) Self {"},
{"lineNum":"   22","line":"            return .{ .f = 0, .e = e };"},
{"lineNum":"   23","line":"        }"},
{"lineNum":"   24","line":""},
{"lineNum":"   25","line":"        pub fn inf(comptime FloatT: type) Self {","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   26","line":"            return .{ .f = 0, .e = (1 << std.math.floatExponentBits(FloatT)) - 1 };","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   27","line":"        }"},
{"lineNum":"   28","line":""},
{"lineNum":"   29","line":"        pub fn eql(self: Self, other: Self) bool {","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   30","line":"            return self.f == other.f and self.e == other.e;","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   31","line":"        }"},
{"lineNum":"   32","line":""},
{"lineNum":"   33","line":"        pub fn toFloat(self: Self, comptime FloatT: type, negative: bool) FloatT {","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   34","line":"            var word = self.f;","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   35","line":"            word |= @intCast(MantissaT, self.e) << std.math.floatMantissaBits(FloatT);","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   36","line":"            var f = floatFromUnsigned(FloatT, MantissaT, word);","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   37","line":"            if (negative) f = -f;","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   38","line":"            return f;","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   39","line":"        }"},
{"lineNum":"   40","line":"    };"},
{"lineNum":"   41","line":"}"},
{"lineNum":"   42","line":""},
{"lineNum":"   43","line":"pub fn floatFromUnsigned(comptime T: type, comptime MantissaT: type, v: MantissaT) T {","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   44","line":"    return switch (T) {","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   45","line":"        f16 => @bitCast(f16, @truncate(u16, v)),"},
{"lineNum":"   46","line":"        f32 => @bitCast(f32, @truncate(u32, v)),"},
{"lineNum":"   47","line":"        f64 => @bitCast(f64, @truncate(u64, v)),","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   48","line":"        f128 => @bitCast(f128, v),"},
{"lineNum":"   49","line":"        else => unreachable,"},
{"lineNum":"   50","line":"    };"},
{"lineNum":"   51","line":"}"},
{"lineNum":"   52","line":""},
{"lineNum":"   53","line":"/// Represents a parsed floating point value as its components."},
{"lineNum":"   54","line":"pub fn Number(comptime T: type) type {"},
{"lineNum":"   55","line":"    return struct {"},
{"lineNum":"   56","line":"        exponent: i64,"},
{"lineNum":"   57","line":"        mantissa: mantissaType(T),"},
{"lineNum":"   58","line":"        negative: bool,"},
{"lineNum":"   59","line":"        /// More than max_mantissa digits were found during parse"},
{"lineNum":"   60","line":"        many_digits: bool,"},
{"lineNum":"   61","line":"        /// The number was a hex-float (e.g. 0x1.234p567)"},
{"lineNum":"   62","line":"        hex: bool,"},
{"lineNum":"   63","line":"    };"},
{"lineNum":"   64","line":"}"},
{"lineNum":"   65","line":""},
{"lineNum":"   66","line":"/// Determine if 8 bytes are all decimal digits."},
{"lineNum":"   67","line":"/// This does not care about the order in which the bytes were loaded."},
{"lineNum":"   68","line":"pub fn isEightDigits(v: u64) bool {","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   69","line":"    const a = v +% 0x4646_4646_4646_4646;","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   70","line":"    const b = v -% 0x3030_3030_3030_3030;","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   71","line":"    return ((a | b) & 0x8080_8080_8080_8080) == 0;","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   72","line":"}"},
{"lineNum":"   73","line":""},
{"lineNum":"   74","line":"pub fn isDigit(c: u8, comptime base: u8) bool {","class":"lineNoCov","hits":"0","possible_hits":"2",},
{"lineNum":"   75","line":"    std.debug.assert(base == 10 or base == 16);","class":"lineNoCov","hits":"0","possible_hits":"2",},
{"lineNum":"   76","line":""},
{"lineNum":"   77","line":"    return if (base == 10)","class":"lineNoCov","hits":"0","possible_hits":"2",},
{"lineNum":"   78","line":"        \'0\' <= c and c <= \'9\'"},
{"lineNum":"   79","line":"    else"},
{"lineNum":"   80","line":"        \'0\' <= c and c <= \'9\' or \'a\' <= c and c <= \'f\' or \'A\' <= c and c <= \'F\';"},
{"lineNum":"   81","line":"}"},
{"lineNum":"   82","line":""},
{"lineNum":"   83","line":"/// Returns the underlying storage type used for the mantissa of floating-point type."},
{"lineNum":"   84","line":"/// The output unsigned type must have at least as many bits as the input floating-point type."},
{"lineNum":"   85","line":"pub fn mantissaType(comptime T: type) type {"},
{"lineNum":"   86","line":"    return switch (T) {"},
{"lineNum":"   87","line":"        f16, f32, f64 => u64,"},
{"lineNum":"   88","line":"        f128 => u128,"},
{"lineNum":"   89","line":"        else => unreachable,"},
{"lineNum":"   90","line":"    };"},
{"lineNum":"   91","line":"}"},
]};
var percent_low = 25;var percent_high = 75;
var header = { "command" : "test", "date" : "2023-04-18 20:41:50", "instrumented" : 22, "covered" : 0,};
var merged_data = [];
