const std = @import("std");
const span_ = @import("span.zig");
const String = @import("zig-string/zig-string.zig").String;

pub const Token_Kind = enum(u32) {
    // Literals
    identifier,
    dec_int,
    hex_int,
    oct_int,
    bin_int,
    float,
    char,
    string,
    true,
    false,
    multi_line_string,

    // Keywords
    @"and",
    @"break",
    @"catch",
    @"comptime",
    @"const",
    @"continue",
    @"defer",
    dyn,
    @"else",
    @"errdefer",
    @"fn",
    @"for",
    @"if",
    impl,
    in,
    let,
    match,
    mut,
    not,
    @"or",
    @"orelse",
    @"return",
    trait,
    @"try",
    @"unreachable",
    where,
    @"while",
    typeof,
    default,
    self,
    sizeof,
    virtual,

    // Equals
    double_equals,
    single_equals,
    minus_equals,
    e_mark_equals,
    percent_equals,
    plus_equals,
    slash_equals,
    star_equals,

    // Math
    bar,
    caret,
    double_bar,
    fat_arrow,
    greater,
    greater_equal,
    lesser,
    lesser_equal,
    minus,
    percent,
    plus,
    skinny_arrow,
    slash,
    star,

    // Punctuation
    ampersand,
    single_colon,
    double_colon,
    comma,
    double_period,
    exclamation_mark,
    period,
    question_mark,
    semicolon,
    at_symbol,

    // Open/Close
    left_brace,
    left_parenthesis,
    left_square,
    right_brace,
    right_parenthesis,
    right_square,

    // Trait stuff
    invoke,

    // Whitespace
    comment,
    newline,
    EOF,

    // HACK: Used to count how many constructors are in the enum
    // (yes, this is needed in Zig)
    len,

    pub fn is_end_token(self: Token_Kind) bool {
        for (end_tokens) |kind| {
            if (self == kind) {
                return true;
            }
        }
        return false;
    }

    pub fn repr(kind: Token_Kind) ?[]const u8 {
        return switch (kind) {
            .bin_int,
            .char,
            .dec_int,
            .hex_int,
            .identifier,
            .oct_int,
            .float,
            .string,
            .len,
            => null,

            .comment => "<a comment>",
            .newline => "<a newline>",

            .@"and" => "and",
            .@"break" => "break",
            .@"catch" => "catch",
            .@"comptime" => "comptime",
            .@"const" => "const",
            .@"continue" => "continue",
            .@"defer" => "defer",
            .dyn => "dyn",
            .@"else" => "else",
            .@"errdefer" => "errdefer",
            .false => "false",
            .@"fn" => "fn",
            .@"for" => "for",
            .@"if" => "if",
            .impl => "impl",
            .in => "in",
            .let => "let",
            .match => "match",
            .mut => "mut",
            .not => "not",
            .@"or" => "or",
            .@"orelse" => "orelse",
            .@"return" => "return",
            .true => "true",
            .@"try" => "try",
            .@"unreachable" => "unreachable",
            .where => "where",
            .@"while" => "while",
            .trait => "trait",
            .typeof => "typeof",
            .default => "default",
            .self => "self",
            .sizeof => "sizeof",
            .virtual => "virtual",

            // Equals
            .double_equals => "==",
            .single_equals => "=",
            .minus_equals => "-=",
            .e_mark_equals => "!=",
            .percent_equals => "%=",
            .plus_equals => "+=",
            .slash_equals => "/=",
            .star_equals => "*=",

            // Math
            .bar => "|",
            .caret => "^",
            .double_bar => "||",
            .fat_arrow => "=>",
            .greater => ">",
            .greater_equal => ">=",
            .lesser => "<",
            .lesser_equal => "<=",
            .minus => "-",
            .percent => "%",
            .plus => "+",
            .skinny_arrow => "->",
            .slash => "/",
            .star => "*",

            // Punctuation
            .ampersand => "&",
            .single_colon => ":",
            .double_colon => "::",
            .comma => ",",
            .double_period => "..",
            .exclamation_mark => "!",
            .period => ".",
            .question_mark => "?",
            .semicolon => ";",
            .multi_line_string => "<multi-line>",
            .at_symbol => "@",

            // Open/Close
            .left_brace => "{",
            .left_parenthesis => "(",
            .left_square => "[",
            .right_brace => "}",
            .right_parenthesis => ")",
            .right_square => "]",

            // Functional
            .invoke => ".>",

            // EOF
            .EOF => "(EOF)",
        };
    }

    pub fn from_string(data: []const u8) Token_Kind {
        var ix: usize = 0;
        const num_ctors = @intFromEnum(Token_Kind.len);

        while (ix < num_ctors) : (ix += 1) {
            const kind: Token_Kind = @enumFromInt(ix);
            const repr_kind: ?[]const u8 = kind.repr();
            if (repr_kind) |_repr| {
                if (std.mem.eql(u8, data, _repr)) {
                    // Found the kind!
                    return kind;
                }
            }
        }
        return Token_Kind.identifier;
    }

    const end_tokens = [_]Token_Kind{
        .identifier,
        .self,
        .dec_int,
        .hex_int,
        .oct_int,
        .bin_int,
        .float,
        .char,
        .string,
        .@"unreachable",
        .@"break",
        .@"continue",
        .@"return",
        .right_parenthesis,
        .right_square,
        .right_brace,
        .true,
        .false,
        .caret,
    };
};

pub const Token = struct {
    // What kind of token this is
    kind: Token_Kind,
    // Non-owning slice into the contents of the source file the text data for this token comes from
    data: []const u8,
    span: span_.Span,

    pub fn init(data: []const u8, kind: ?Token_Kind, filename: []const u8, line_text: []const u8, line_number: usize, col: usize) Token {
        return .{ .data = data, .kind = kind orelse Token_Kind.from_string(data), .span = span_.Span{
            .filename = filename,
            .line_text = line_text,
            .line_number = line_number,
            .col = col,
        } };
    }

    // Used to create a simple, anonymous identifier token
    pub fn init_simple(data: []const u8) Token {
        return Token.init(data, .identifier, "", "", 0, 0);
    }

    pub fn pprint(self: *Token) void {
        std.debug.print("Token {{line: {:03}, kind: {s}, data: {s}}}\n", .{ self.span.line_number, self.repr(), self.data });
    }
};
