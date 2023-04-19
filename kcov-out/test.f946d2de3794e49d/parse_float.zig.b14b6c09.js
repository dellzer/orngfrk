var data = {lines:[
{"lineNum":"    1","line":"const std = @import(\"std\");"},
{"lineNum":"    2","line":"const parse = @import(\"parse.zig\");"},
{"lineNum":"    3","line":"const convertFast = @import(\"convert_fast.zig\").convertFast;"},
{"lineNum":"    4","line":"const convertEiselLemire = @import(\"convert_eisel_lemire.zig\").convertEiselLemire;"},
{"lineNum":"    5","line":"const convertSlow = @import(\"convert_slow.zig\").convertSlow;"},
{"lineNum":"    6","line":"const convertHex = @import(\"convert_hex.zig\").convertHex;"},
{"lineNum":"    7","line":""},
{"lineNum":"    8","line":"const optimize = true;"},
{"lineNum":"    9","line":""},
{"lineNum":"   10","line":"pub const ParseFloatError = error{"},
{"lineNum":"   11","line":"    InvalidCharacter,"},
{"lineNum":"   12","line":"};"},
{"lineNum":"   13","line":""},
{"lineNum":"   14","line":"pub fn parseFloat(comptime T: type, s: []const u8) ParseFloatError!T {","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   15","line":"    if (s.len == 0) {","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   16","line":"        return error.InvalidCharacter;","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   17","line":"    }"},
{"lineNum":"   18","line":""},
{"lineNum":"   19","line":"    var i: usize = 0;","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   20","line":"    const negative = s[i] == \'-\';","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   21","line":"    if (s[i] == \'-\' or s[i] == \'+\') {","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   22","line":"        i += 1;","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   23","line":"    }"},
{"lineNum":"   24","line":"    if (s.len == i) {","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   25","line":"        return error.InvalidCharacter;","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   26","line":"    }"},
{"lineNum":"   27","line":""},
{"lineNum":"   28","line":"    const n = parse.parseNumber(T, s[i..], negative) orelse {","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   29","line":"        return parse.parseInfOrNan(T, s[i..], negative) orelse error.InvalidCharacter;","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   30","line":"    };"},
{"lineNum":"   31","line":""},
{"lineNum":"   32","line":"    if (n.hex) {","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   33","line":"        return convertHex(T, n);","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   34","line":"    }"},
{"lineNum":"   35","line":""},
{"lineNum":"   36","line":"    if (optimize) {"},
{"lineNum":"   37","line":"        if (convertFast(T, n)) |f| {","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   38","line":"            return f;","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   39","line":"        }"},
{"lineNum":"   40","line":""},
{"lineNum":"   41","line":"        if (T == f16 or T == f32 or T == f64) {"},
{"lineNum":"   42","line":"            // If significant digits were truncated, then we can have rounding error"},
{"lineNum":"   43","line":"            // only if `mantissa + 1` produces a different result. We also avoid"},
{"lineNum":"   44","line":"            // redundantly using the Eisel-Lemire algorithm if it was unable to"},
{"lineNum":"   45","line":"            // correctly round on the first pass."},
{"lineNum":"   46","line":"            if (convertEiselLemire(T, n.exponent, n.mantissa)) |bf| {","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   47","line":"                if (!n.many_digits) {","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   48","line":"                    return bf.toFloat(T, n.negative);","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   49","line":"                }"},
{"lineNum":"   50","line":"                if (convertEiselLemire(T, n.exponent, n.mantissa + 1)) |bf2| {","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   51","line":"                    if (bf.eql(bf2)) {","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   52","line":"                        return bf.toFloat(T, n.negative);","class":"lineNoCov","hits":"0","possible_hits":"2",},
{"lineNum":"   53","line":"                    }"},
{"lineNum":"   54","line":"                }"},
{"lineNum":"   55","line":"            }"},
{"lineNum":"   56","line":"        }"},
{"lineNum":"   57","line":"    }"},
{"lineNum":"   58","line":""},
{"lineNum":"   59","line":"    // Unable to correctly round the float using the Eisel-Lemire algorithm."},
{"lineNum":"   60","line":"    // Fallback to a slower, but always correct algorithm."},
{"lineNum":"   61","line":"    return convertSlow(T, s[i..]).toFloat(T, negative);","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   62","line":"}"},
]};
var percent_low = 25;var percent_high = 75;
var header = { "command" : "test", "date" : "2023-04-18 20:41:50", "instrumented" : 22, "covered" : 0,};
var merged_data = [];
