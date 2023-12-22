const std = @import("std");
const errs_ = @import("errors.zig");
const offset_ = @import("offsets.zig");
const primitives_ = @import("primitives.zig");
const span_ = @import("span.zig");
const String = @import("zig-string/zig-string.zig").String;
const symbol_ = @import("symbol.zig");
const tokens_ = @import("token.zig");
const validation_state_ = @import("validation_state.zig");

pub const AST_Validation_State = validation_state_.Validation_State(*AST);

pub var poisoned: *AST = undefined;
var inited: bool = false;

/// Initializes internal structures if they are not already initialized.
pub fn init_structures() void {
    if (!inited) {
        poisoned = AST.createPoison(tokens_.Token{ .kind = .L_PAREN, .data = "LMAO GET POISONED", .span = span_.Span{ .filename = "", .line_text = "", .line = 0, .col = 0 } }, std.heap.page_allocator);
        poisoned.getCommon().validation_state = .invalid;
        inited = true;
    }
}

/// Represents the kind of a slice.
pub const SliceKind = union(enum) {
    SLICE, // data ptr and len
    MUT, // mutable data ptr and len
    MULTIPTR, // c-style `*` pointer, no len
    ARRAY, // static homogenous tuple, compile-time len
};

/// Contains common properties of all AST nodes
const ASTCommon = struct {
    /// Token that defined the AST node in text.
    token: tokens_.Token,

    /// The AST's type.
    /// Memoized, use `typeof()`.
    /// TODO: Postfix with _ to signify private
    _type: ?*AST,

    /// The result of expanding the `_type` field.
    /// Memoized, use `expanded_type()`.
    /// TODO: Postfix with _ to signify private
    expanded_type: ?*AST = null,

    /// The number of bytes a value in an AST type takes up.
    /// Memoized, use `sizeof()`.
    /// TODO: Postfix with _ to signify private
    size: ?i64 = null,

    /// The alignment for values of this type.
    /// In general it is *NOT* true that size == alignof, especially for products and sums.
    alignof: ?i64 = null,

    /// The AST's validation status.
    validation_state: AST_Validation_State = .unvalidated,
};

/// Represents an Abstract Syntax Tree.
pub const AST = union(enum) {
    /// Not generated for correct programs, used to represent incorrect ASTs
    poison: struct { common: ASTCommon },
    /// Unit type
    unit_type: struct { common: ASTCommon },
    /// Unit value
    unit_value: struct { common: ASTCommon },
    /// Integer constant
    int: struct {
        common: ASTCommon,
        data: i128,
        represents: *AST, //< Type that this constant represents. Set on validation.
    },
    /// Floating-point constant
    float: struct {
        common: ASTCommon,
        data: f64,
        represents: *AST, //< Type that this constant represents. Set on validation.
    },
    /// Character constant
    char: struct { common: ASTCommon },
    /// String constant
    string: struct {
        common: ASTCommon,
        data: []const u8,
    },
    /// True constant
    _true: struct { common: ASTCommon },
    /// False constant
    _false: struct { common: ASTCommon },
    /// Field
    /// This tag is used for the right-hand-side of selects. They do not refer to symbols.
    field: struct { common: ASTCommon },
    /// Identifier
    identifier: struct { common: ASTCommon, symbol: ?*symbol_.Symbol = null },

    not: struct { common: ASTCommon, expr: *AST },
    negate: struct { common: ASTCommon, expr: *AST },
    dereference: struct { common: ASTCommon, expr: *AST },
    _try: struct {
        common: ASTCommon,
        expr: *AST,
        function: ?*symbol_.Symbol, // `try`'s must be in functions. This is the function's symbol.
    },
    discard: struct { common: ASTCommon, expr: *AST },
    _comptime: struct {
        common: ASTCommon,
        expr: *AST,
        name: ?*AST = null,
        symbol: ?*symbol_.Symbol = null,
    },

    // Binary operators
    assign: struct { common: ASTCommon, lhs: *AST, rhs: *AST },
    _or: struct { common: ASTCommon, lhs: *AST, rhs: *AST },
    _and: struct { common: ASTCommon, lhs: *AST, rhs: *AST },
    add: struct { common: ASTCommon, lhs: *AST, rhs: *AST },
    sub: struct { common: ASTCommon, lhs: *AST, rhs: *AST },
    mult: struct { common: ASTCommon, lhs: *AST, rhs: *AST },
    div: struct { common: ASTCommon, lhs: *AST, rhs: *AST },
    mod: struct { common: ASTCommon, lhs: *AST, rhs: *AST },
    equal: struct { common: ASTCommon, lhs: *AST, rhs: *AST },
    not_equal: struct { common: ASTCommon, lhs: *AST, rhs: *AST },
    greater: struct { common: ASTCommon, lhs: *AST, rhs: *AST },
    lesser: struct { common: ASTCommon, lhs: *AST, rhs: *AST },
    greater_equal: struct { common: ASTCommon, lhs: *AST, rhs: *AST },
    lesser_equal: struct { common: ASTCommon, lhs: *AST, rhs: *AST },
    _catch: struct { common: ASTCommon, lhs: *AST, rhs: *AST },
    _orelse: struct { common: ASTCommon, lhs: *AST, rhs: *AST },
    call: struct { common: ASTCommon, lhs: *AST, args: std.ArrayList(*AST) },
    index: struct { common: ASTCommon, lhs: *AST, rhs: *AST },
    select: struct {
        common: ASTCommon,
        lhs: *AST,
        rhs: *AST,
        pos: ?usize,

        pub fn offset_at(self: *@This(), allocator: std.mem.Allocator) i64 {
            var lhs_expanded_type = self.lhs.typeof(allocator).expand_type(allocator);
            if (lhs_expanded_type.* == .product) {
                return lhs_expanded_type.product.get_offset(self.pos.?, allocator);
            } else if (lhs_expanded_type.* == .sum) {
                return lhs_expanded_type.sum.get_offset(self.pos.?, allocator);
            } else {
                std.debug.print("{s}\n", .{@tagName(lhs_expanded_type.*)});
                unreachable;
            }
        }
    },
    function: struct { common: ASTCommon, lhs: *AST, rhs: *AST },
    invoke: struct { common: ASTCommon, lhs: *AST, rhs: *AST },
    sum: struct {
        common: ASTCommon,
        terms: std.ArrayList(*AST),
        was_optional: bool = false,
        was_error: bool = false,
        all_unit: ?bool = null,
        pub fn is_all_unit(self: *@This()) bool {
            if (self.all_unit) |all_unit| {
                return all_unit;
            }
            var res = true;
            for (self.terms.items) |term| {
                res = res and term.c_typesMatch(primitives_.unit_type);
            }
            self.all_unit = res;
            return res;
        }

        pub fn get_pos(self: *@This(), field_name: []const u8) ?i128 {
            for (self.terms.items, 0..) |term, i| {
                if (std.mem.eql(u8, term.annotation.pattern.getToken().data, field_name)) {
                    return i;
                }
            }
            return null;
        }

        // TODO: Duck type this with product/sum
        pub fn get_offset(self: *@This(), field: usize, allocator: std.mem.Allocator) i64 {
            var offset: i64 = 0;
            for (0..field + 1) |i| {
                var item = self.terms.items[i];
                offset += item.expand_type(allocator).sizeof();
            }
            return offset;
        }
    },
    inferred_error: struct {
        common: ASTCommon,
        terms: std.ArrayList(*AST),

        pub fn get_pos(self: *@This(), field_name: []const u8) ?i128 {
            for (self.terms.items, 0..) |term, i| {
                if (std.mem.eql(u8, term.annotation.pattern.getToken().data, field_name)) {
                    return i;
                }
            }
            return null;
        }
    },
    inject: struct { common: ASTCommon, lhs: *AST, rhs: *AST },
    product: struct {
        common: ASTCommon,
        terms: std.ArrayList(*AST),
        homotypical: ?bool = null,
        was_slice: bool = false,

        pub fn is_homotypical(self: *@This()) bool {
            if (self.homotypical) |homotypical| {
                return homotypical;
            }
            var first_type = self.terms.items[0];
            for (self.terms.items, 0..) |term, i| {
                if (i == 0) {
                    continue;
                }
                if (!first_type.typesMatch(term)) {
                    self.homotypical = false;
                    return false;
                }
            }
            self.homotypical = true;
            return true;
        }

        pub fn get_offset(self: *@This(), field: usize, allocator: std.mem.Allocator) i64 {
            var offset: i64 = 0;
            for (0..field) |i| {
                var item = self.terms.items[i].expand_type(allocator);
                offset += item.sizeof();
                offset = offset_.next_alignment(offset, self.terms.items[i + 1].alignof());
            }
            return offset;
        }
    },
    _union: struct { common: ASTCommon, lhs: *AST, rhs: *AST },

    // Fancy operators
    addrOf: struct { common: ASTCommon, expr: *AST, mut: bool },
    sliceOf: struct { common: ASTCommon, expr: *AST, kind: SliceKind },
    arrayOf: struct { common: ASTCommon, expr: *AST, len: *AST },
    subSlice: struct { common: ASTCommon, super: *AST, lower: ?*AST, upper: ?*AST },
    annotation: struct { common: ASTCommon, pattern: *AST, type: *AST, predicate: ?*AST, init: ?*AST },
    inferredMember: struct {
        common: ASTCommon,
        ident: *AST,
        init: ?*AST = null,
        base: ?*AST = null, // This should ideally be kept in unexpanded form. typeof(inferredMember) returns inferredMember.base.?.expand_type()
        pos: ?i128 = null,
    },
    _typeOf: struct {
        common: ASTCommon,
        expr: *AST,
    },
    default: struct {
        common: ASTCommon,
        expr: *AST,
    },
    sizeOf: struct {
        common: ASTCommon,
        expr: *AST,
    },
    domainOf: struct {
        common: ASTCommon,
        sum_expr: *AST,
        expr: *AST,
    },

    // Control-flow expressions
    _if: struct {
        common: ASTCommon,
        scope: ?*symbol_.Scope,
        let: ?*AST,
        condition: *AST,
        bodyBlock: *AST,
        elseBlock: ?*AST,
    },
    match: struct {
        common: ASTCommon,
        scope: ?*symbol_.Scope,
        let: ?*AST,
        expr: *AST,
        mappings: std.ArrayList(*AST),
        has_else: bool,
    },
    mapping: struct {
        common: ASTCommon,
        lhs: ?*AST,
        rhs: ?*AST,
        scope: ?*symbol_.Scope, // Scope used for `match` mappings. Captures live in this scope, rhs of mapping lives in this scope. Lives in `match`'s scope
    },
    _while: struct {
        common: ASTCommon,
        scope: ?*symbol_.Scope,
        let: ?*AST,
        condition: *AST,
        post: ?*AST,
        bodyBlock: *AST,
        elseBlock: ?*AST,
    },
    _for: struct {
        common: ASTCommon,
        scope: ?*symbol_.Scope,
        let: ?*AST,
        elem: *AST,
        iterable: *AST,
        bodyBlock: *AST,
        elseBlock: ?*AST,
    },
    block: struct {
        common: ASTCommon,
        scope: ?*symbol_.Scope,
        statements: std.ArrayList(*AST),
        final: ?*AST, // either `return`, `continue`, or `break`
    },

    // Control-flow statements
    _break: struct { common: ASTCommon },
    _continue: struct { common: ASTCommon },
    _unreachable: struct { common: ASTCommon },
    _return: struct {
        common: ASTCommon,
        expr: ?*AST,
        function: ?*symbol_.Symbol, // `retrun`'s must be in functions. This is the function's symbol.
    },
    /// This type is a special version of an identifier. It is needed to encapsulate information about a
    /// symbol declaration that is needed before the symbol is even constructed. An identifier AST cannot be
    /// used for this purpose, because it refers to a symbol _after_ symbol decoration.
    symbol: struct {
        common: ASTCommon,
        name: []const u8,
        kind: symbol_.SymbolKind,
        symbol: *symbol_.Symbol = undefined,
    },
    decl: struct {
        common: ASTCommon,
        symbols: std.ArrayList(*symbol_.Symbol), // List of symbols that are defined with this statement
        pattern: *AST, // Structure of ASTs. Has to be structured to allow tree patterns like `let ((a, b), (c, d)) = blah`
        type: *AST,
        init: *AST,
        top_level: bool,
    },
    fnDecl: struct {
        common: ASTCommon,
        name: ?*AST,
        params: std.ArrayList(*AST), // Parameters' decl ASTs
        param_symbols: std.ArrayList(*symbol_.Symbol), // Parameters' symbols
        retType: *AST,
        refinement: ?*AST,
        init: *AST,
        symbol: ?*symbol_.Symbol = null,
        infer_error: bool,
    },
    _defer: struct { common: ASTCommon, statement: *AST },
    _errdefer: struct { common: ASTCommon, statement: *AST },

    /// Boxes an AST value into an allocator.
    fn box(ast: AST, alloc: std.mem.Allocator) *AST {
        const retval = alloc.create(AST) catch unreachable;
        retval.* = ast;
        return retval;
    }

    /// Retrieve the common field of an AST node
    pub fn getCommon(self: *AST) *ASTCommon {
        switch (self.*) {
            .poison => return &self.poison.common,
            .unit_type => return &self.unit_type.common,
            .unit_value => return &self.unit_value.common,
            .int => return &self.int.common,
            .char => return &self.char.common,
            .float => return &self.float.common,
            .string => return &self.string.common,
            .field => return &self.field.common,
            .identifier => return &self.identifier.common,
            ._unreachable => return &self._unreachable.common,
            ._true => return &self._true.common,
            ._false => return &self._false.common,

            .not => return &self.not.common,
            .negate => return &self.negate.common,
            .dereference => return &self.dereference.common,
            ._try => return &self._try.common,
            .discard => return &self.discard.common,
            ._typeOf => return &self._typeOf.common,
            .default => return &self.default.common,
            .sizeOf => return &self.sizeOf.common,
            .domainOf => return &self.domainOf.common,
            ._comptime => return &self._comptime.common,

            .assign => return &self.assign.common,
            ._or => return &self._or.common,
            ._and => return &self._and.common,
            .add => return &self.add.common,
            .sub => return &self.sub.common,
            .mult => return &self.mult.common,
            .div => return &self.div.common,
            .mod => return &self.mod.common,
            .equal => return &self.equal.common,
            .not_equal => return &self.not_equal.common,
            .greater => return &self.greater.common,
            .lesser => return &self.lesser.common,
            .greater_equal => return &self.greater_equal.common,
            .lesser_equal => return &self.lesser_equal.common,
            ._catch => return &self._catch.common,
            ._orelse => return &self._orelse.common,
            .call => return &self.call.common,
            .index => return &self.index.common,
            .select => return &self.select.common,
            .function => return &self.function.common,
            .invoke => return &self.invoke.common,
            .sum => return &self.sum.common,
            .inferred_error => return &self.inferred_error.common,
            .inject => return &self.inject.common,
            .product => return &self.product.common,
            ._union => return &self._union.common,

            .addrOf => return &self.addrOf.common,
            .sliceOf => return &self.sliceOf.common,
            .arrayOf => return &self.arrayOf.common,
            .subSlice => return &self.subSlice.common,
            .annotation => return &self.annotation.common,
            .inferredMember => return &self.inferredMember.common,

            ._if => return &self._if.common,
            .match => return &self.match.common,
            .mapping => return &self.mapping.common,
            ._while => return &self._while.common,
            ._for => return &self._for.common,
            .block => return &self.block.common,
            ._break => return &self._break.common,
            ._continue => return &self._continue.common,
            ._return => return &self._return.common,
            .symbol => return &self.symbol.common,
            .decl => return &self.decl.common,
            .fnDecl => return &self.fnDecl.common,
            ._defer => return &self._defer.common,
            ._errdefer => return &self._errdefer.common,
        }
    }

    /// Retrieves the token of an AST node
    pub fn getToken(self: *AST) tokens_.Token {
        return self.getCommon().token;
    }

    /// Retrieves the size in bytes of an AST node.
    pub fn sizeof(self: *AST) i64 {
        if (self.getCommon().size == null) {
            self.getCommon().size = self.sizeof_internal(); // memoize call
        }

        return self.getCommon().size.?;
    }

    fn sizeof_internal(self: *AST) i64 {
        switch (self.*) {
            .identifier => {
                const info = primitives_.get(self.getToken().data);
                return info.size;
            },

            .product => {
                var total_size: i64 = 0;
                for (self.product.terms.items) |child| {
                    total_size = offset_.next_alignment(total_size, child.alignof());
                    total_size += child.sizeof();
                }
                return total_size;
            },

            .sum => {
                var max_size: i64 = 0;
                for (self.sum.terms.items) |child| {
                    max_size = @max(max_size, child.sizeof());
                }
                return offset_.next_alignment(max_size, 8) + 8;
            },

            .function, .addrOf => return 8,

            .unit_type => return 0,

            .annotation => return self.annotation.type.sizeof(),

            else => {
                std.debug.print("Unimplemented sizeof for {}\n", .{self});
                unreachable;
            },
        }
    }

    pub fn alignof(self: *AST) i64 {
        if (self.getCommon().alignof == null) {
            self.getCommon().alignof = self.alignof_internal(); // memoize call
        }

        return self.getCommon().alignof.?;
    }

    fn alignof_internal(self: *AST) i64 {
        switch (self.*) {
            .identifier => {
                const info = primitives_.get(self.getToken().data);
                return info.size;
            },

            .product => {
                var max_align: i64 = 0;
                for (self.product.terms.items) |child| {
                    max_align = @max(max_align, child.alignof());
                }
                return max_align;
            },

            .sum, // this pains me :-( but has to be this way for the tag
            .function,
            .addrOf,
            => return 8,

            .unit_type => return 1, // fogedda bout it

            .annotation => return self.annotation.type.alignof(),

            else => {
                std.debug.print("Unimplemented alignof for {}\n", .{self});
                unreachable;
            },
        }
    }

    pub fn createPoison(token: tokens_.Token, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .poison = .{ .common = ASTCommon{ .token = token, ._type = null } } }, allocator);
    }

    pub fn createUnitType(token: tokens_.Token, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .unit_type = .{ .common = ASTCommon{ .token = token, ._type = null } } }, allocator);
    }

    pub fn createUnitValue(token: tokens_.Token, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .unit_value = .{ .common = ASTCommon{ .token = token, ._type = null } } }, allocator);
    }

    pub fn createInt(token: tokens_.Token, data: i128, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .int = .{ .common = ASTCommon{ .token = token, ._type = null }, .data = data, .represents = primitives_.int_type } }, allocator);
    }

    pub fn createChar(
        token: tokens_.Token, // `token.data` should of course encompass the `'` used for character delimination. This is unlike strings. TODO: Maybe make it like strings?
        allocator: std.mem.Allocator,
    ) *AST {
        return AST.box(AST{ .char = .{ .common = ASTCommon{ .token = token, ._type = null } } }, allocator);
    }

    pub fn createFloat(token: tokens_.Token, data: f64, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .float = .{ .common = ASTCommon{ .token = token, ._type = null }, .data = data, .represents = primitives_.float_type } }, allocator);
    }

    pub fn createString(
        token: tokens_.Token,
        data: []const u8, // The string's raw utf8 bytes, not containing `"`'s, with escapes escaped
        allocator: std.mem.Allocator,
    ) *AST {
        return AST.box(AST{ .string = .{ .common = ASTCommon{ .token = token, ._type = null }, .data = data } }, allocator);
    }

    pub fn createField(token: tokens_.Token, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .field = .{ .common = ASTCommon{ .token = token, ._type = null } } }, allocator);
    }

    pub fn createIdentifier(token: tokens_.Token, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .identifier = .{ .common = ASTCommon{ .token = token, ._type = null } } }, allocator);
    }

    pub fn createUnreachable(token: tokens_.Token, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ ._unreachable = .{ .common = ASTCommon{ .token = token, ._type = null } } }, allocator);
    }

    pub fn createTrue(token: tokens_.Token, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ ._true = .{ .common = ASTCommon{ .token = token, ._type = null } } }, allocator);
    }

    pub fn createFalse(token: tokens_.Token, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ ._false = .{ .common = ASTCommon{ .token = token, ._type = null } } }, allocator);
    }

    pub fn createNot(token: tokens_.Token, expr: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .not = .{ .common = ASTCommon{ .token = token, ._type = null }, .expr = expr } }, allocator);
    }

    pub fn createNegate(token: tokens_.Token, expr: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .negate = .{ .common = ASTCommon{ .token = token, ._type = null }, .expr = expr } }, allocator);
    }

    pub fn createDereference(token: tokens_.Token, expr: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .dereference = .{ .common = ASTCommon{ .token = token, ._type = null }, .expr = expr } }, allocator);
    }

    pub fn createTry(token: tokens_.Token, expr: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ ._try = .{ .common = ASTCommon{ .token = token, ._type = null }, .expr = expr, .function = null } }, allocator);
    }

    pub fn createDiscard(token: tokens_.Token, expr: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .discard = .{ .common = ASTCommon{ .token = token, ._type = null }, .expr = expr } }, allocator);
    }

    pub fn createComptime(token: tokens_.Token, expr: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ ._comptime = .{ .common = ASTCommon{ .token = token, ._type = null }, .expr = expr, .name = null, .symbol = null } }, allocator);
    }

    pub fn createTypeOf(token: tokens_.Token, expr: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ ._typeOf = .{ .common = ASTCommon{ .token = token, ._type = null }, .expr = expr } }, allocator);
    }

    pub fn createDefault(token: tokens_.Token, expr: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .default = .{ .common = ASTCommon{ .token = token, ._type = null }, .expr = expr } }, allocator);
    }

    pub fn createSizeOf(token: tokens_.Token, expr: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .sizeOf = .{ .common = ASTCommon{ .token = token, ._type = null }, .expr = expr } }, allocator);
    }

    pub fn createDomainOf(token: tokens_.Token, sum_expr: *AST, expr: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .domainOf = .{ .common = ASTCommon{ .token = token, ._type = null }, .sum_expr = sum_expr, .expr = expr } }, allocator);
    }

    pub fn createAssign(token: tokens_.Token, lhs: *AST, rhs: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .assign = .{ .common = ASTCommon{ .token = token, ._type = null }, .lhs = lhs, .rhs = rhs } }, allocator);
    }

    pub fn createOr(token: tokens_.Token, lhs: *AST, rhs: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ ._or = .{ .common = ASTCommon{ .token = token, ._type = null }, .lhs = lhs, .rhs = rhs } }, allocator);
    }

    pub fn createAnd(token: tokens_.Token, lhs: *AST, rhs: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ ._and = .{ .common = ASTCommon{ .token = token, ._type = null }, .lhs = lhs, .rhs = rhs } }, allocator);
    }

    pub fn createEqual(token: tokens_.Token, lhs: *AST, rhs: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .equal = .{ .common = ASTCommon{ .token = token, ._type = null }, .lhs = lhs, .rhs = rhs } }, allocator);
    }

    pub fn createNotEqual(token: tokens_.Token, lhs: *AST, rhs: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .not_equal = .{ .common = ASTCommon{ .token = token, ._type = null }, .lhs = lhs, .rhs = rhs } }, allocator);
    }

    pub fn createGreater(token: tokens_.Token, lhs: *AST, rhs: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .greater = .{ .common = ASTCommon{ .token = token, ._type = null }, .lhs = lhs, .rhs = rhs } }, allocator);
    }

    pub fn createLesser(token: tokens_.Token, lhs: *AST, rhs: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .lesser = .{ .common = ASTCommon{ .token = token, ._type = null }, .lhs = lhs, .rhs = rhs } }, allocator);
    }

    pub fn createGreaterEqual(token: tokens_.Token, lhs: *AST, rhs: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .greater_equal = .{ .common = ASTCommon{ .token = token, ._type = null }, .lhs = lhs, .rhs = rhs } }, allocator);
    }

    pub fn createLesserEqual(token: tokens_.Token, lhs: *AST, rhs: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .lesser_equal = .{ .common = ASTCommon{ .token = token, ._type = null }, .lhs = lhs, .rhs = rhs } }, allocator);
    }

    pub fn createAdd(token: tokens_.Token, lhs: *AST, rhs: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .add = .{ .common = ASTCommon{ .token = token, ._type = null }, .lhs = lhs, .rhs = rhs } }, allocator);
    }

    pub fn createSub(token: tokens_.Token, lhs: *AST, rhs: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .sub = .{ .common = ASTCommon{ .token = token, ._type = null }, .lhs = lhs, .rhs = rhs } }, allocator);
    }

    pub fn createMult(token: tokens_.Token, lhs: *AST, rhs: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .mult = .{ .common = ASTCommon{ .token = token, ._type = null }, .lhs = lhs, .rhs = rhs } }, allocator);
    }

    pub fn createDiv(token: tokens_.Token, lhs: *AST, rhs: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .div = .{ .common = ASTCommon{ .token = token, ._type = null }, .lhs = lhs, .rhs = rhs } }, allocator);
    }

    pub fn createMod(token: tokens_.Token, lhs: *AST, rhs: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .mod = .{ .common = ASTCommon{ .token = token, ._type = null }, .lhs = lhs, .rhs = rhs } }, allocator);
    }

    pub fn createCatch(token: tokens_.Token, lhs: *AST, rhs: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ ._catch = .{ .common = ASTCommon{ .token = token, ._type = null }, .lhs = lhs, .rhs = rhs } }, allocator);
    }

    pub fn createOrelse(token: tokens_.Token, lhs: *AST, rhs: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ ._orelse = .{ .common = ASTCommon{ .token = token, ._type = null }, .lhs = lhs, .rhs = rhs } }, allocator);
    }

    pub fn createCall(token: tokens_.Token, lhs: *AST, args: std.ArrayList(*AST), allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .call = .{ .common = ASTCommon{ .token = token, ._type = null }, .lhs = lhs, .args = args } }, allocator);
    }

    pub fn createIndex(token: tokens_.Token, lhs: *AST, rhs: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .index = .{ .common = ASTCommon{ .token = token, ._type = null }, .lhs = lhs, .rhs = rhs } }, allocator);
    }

    pub fn createSelect(token: tokens_.Token, lhs: *AST, rhs: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .select = .{ .common = ASTCommon{ .token = token, ._type = null }, .lhs = lhs, .rhs = rhs, .pos = null } }, allocator);
    }

    pub fn createSum(token: tokens_.Token, terms: std.ArrayList(*AST), allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .sum = .{ .common = ASTCommon{ .token = token, ._type = null }, .terms = terms } }, allocator);
    }

    pub fn createInferredError(token: tokens_.Token, ok: *AST, allocator: std.mem.Allocator) *AST {
        var retval: AST = AST{ .inferred_error = .{ .common = ASTCommon{ .token = token, ._type = null }, .terms = std.ArrayList(*AST).init(allocator) } };
        const ok_annot = createAnnotation(token, AST.createIdentifier(tokens_.Token{ .kind = .IDENTIFIER, .data = "ok", .span = span_.Span{ .filename = "", .line_text = "", .line = 0, .col = 0 } }, allocator), ok, null, null, allocator);
        retval.inferred_error.terms.append(ok_annot) catch unreachable;

        return AST.box(retval, allocator);
    }

    pub fn createInject(token: tokens_.Token, lhs: *AST, rhs: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .inject = .{ .common = ASTCommon{ .token = token, ._type = null }, .lhs = lhs, .rhs = rhs } }, allocator);
    }

    pub fn createFunction(token: tokens_.Token, lhs: *AST, rhs: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .function = .{ .common = ASTCommon{ .token = token, ._type = null }, .lhs = lhs, .rhs = rhs } }, allocator);
    }

    pub fn createInvoke(token: tokens_.Token, lhs: *AST, rhs: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .invoke = .{ .common = ASTCommon{ .token = token, ._type = null }, .lhs = lhs, .rhs = rhs } }, allocator);
    }

    pub fn createProduct(token: tokens_.Token, terms: std.ArrayList(*AST), allocator: std.mem.Allocator) *AST {
        // std.debug.assert(terms.items.len >= 2);
        return AST.box(AST{ .product = .{ .common = ASTCommon{ .token = token, ._type = null }, .terms = terms } }, allocator);
    }

    pub fn createUnion(token: tokens_.Token, lhs: *AST, rhs: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ ._union = .{ .common = ASTCommon{ .token = token, ._type = null }, .lhs = lhs, .rhs = rhs } }, allocator);
    }

    pub fn createAddrOf(token: tokens_.Token, expr: *AST, mut: bool, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .addrOf = .{ .common = ASTCommon{ .token = token, ._type = null }, .expr = expr, .mut = mut } }, allocator);
    }

    pub fn createSliceOf(token: tokens_.Token, expr: *AST, kind: SliceKind, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .sliceOf = .{ .common = ASTCommon{ .token = token, ._type = null }, .expr = expr, .kind = kind } }, allocator);
    }

    pub fn createArrayOf(token: tokens_.Token, expr: *AST, len: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .arrayOf = .{ .common = ASTCommon{ .token = token, ._type = null }, .expr = expr, .len = len } }, allocator);
    }

    pub fn createSubSlice(token: tokens_.Token, super: *AST, lower: ?*AST, upper: ?*AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .subSlice = .{ .common = ASTCommon{ .token = token, ._type = null }, .super = super, .lower = lower, .upper = upper } }, allocator);
    }

    pub fn createAnnotation(token: tokens_.Token, pattern: *AST, _type: *AST, predicate: ?*AST, init: ?*AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .annotation = .{ .common = ASTCommon{ .token = token, ._type = null }, .pattern = pattern, .type = _type, .predicate = predicate, .init = init } }, allocator);
    }

    pub fn createInferredMember(token: tokens_.Token, ident: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .inferredMember = .{ .common = ASTCommon{ .token = token, ._type = null }, .ident = ident } }, allocator);
    }

    pub fn createIf(token: tokens_.Token, let: ?*AST, condition: *AST, bodyBlock: *AST, elseBlock: ?*AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ ._if = .{ .common = ASTCommon{ .token = token, ._type = null }, .scope = null, .let = let, .condition = condition, .bodyBlock = bodyBlock, .elseBlock = elseBlock } }, allocator);
    }

    pub fn createMatch(token: tokens_.Token, let: ?*AST, expr: *AST, mappings: std.ArrayList(*AST), has_else: bool, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .match = .{ .common = ASTCommon{ .token = token, ._type = null }, .scope = null, .let = let, .expr = expr, .mappings = mappings, .has_else = has_else } }, allocator);
    }

    pub fn createMapping(token: tokens_.Token, lhs: ?*AST, rhs: ?*AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .mapping = .{ .common = ASTCommon{ .token = token, ._type = null }, .lhs = lhs, .rhs = rhs, .scope = null } }, allocator);
    }

    pub fn createWhile(token: tokens_.Token, let: ?*AST, condition: *AST, post: ?*AST, bodyBlock: *AST, elseBlock: ?*AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ ._while = .{ .common = ASTCommon{ .token = token, ._type = null }, .scope = null, .let = let, .condition = condition, .post = post, .bodyBlock = bodyBlock, .elseBlock = elseBlock } }, allocator);
    }

    pub fn createFor(token: tokens_.Token, let: ?*AST, elem: *AST, iterable: *AST, bodyBlock: *AST, elseBlock: ?*AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ ._for = .{ .common = ASTCommon{ .token = token, ._type = null }, .scope = null, .let = let, .elem = elem, .iterable = iterable, .bodyBlock = bodyBlock, .elseBlock = elseBlock } }, allocator);
    }

    pub fn createBlock(token: tokens_.Token, statements: std.ArrayList(*AST), final: ?*AST, allocator: std.mem.Allocator) *AST {
        if (final) |_final| {
            std.debug.assert(_final.* == ._return or _final.* == ._continue or _final.* == ._break);
        }
        return AST.box(AST{ .block = .{ .common = ASTCommon{ .token = token, ._type = null }, .scope = null, .statements = statements, .final = final } }, allocator);
    }

    pub fn createBreak(token: tokens_.Token, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ ._break = .{ .common = ASTCommon{ .token = token, ._type = null } } }, allocator);
    }

    pub fn createContinue(token: tokens_.Token, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ ._continue = .{ .common = ASTCommon{ .token = token, ._type = null } } }, allocator);
    }

    pub fn createReturn(token: tokens_.Token, expr: ?*AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ ._return = .{ .common = ASTCommon{ .token = token, ._type = null }, .expr = expr, .function = null } }, allocator);
    }

    pub fn createSymbol(token: tokens_.Token, kind: symbol_.SymbolKind, name: []const u8, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .symbol = .{ .common = ASTCommon{ .token = token, ._type = null }, .kind = kind, .name = name } }, allocator);
    }

    pub fn createDecl(token: tokens_.Token, pattern: *AST, _type: *AST, init: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .decl = .{ .common = ASTCommon{ .token = token, ._type = null }, .symbols = std.ArrayList(*symbol_.Symbol).init(allocator), .pattern = pattern, .type = _type, .init = init, .top_level = false } }, allocator);
    }

    pub fn createFnDecl(token: tokens_.Token, name: ?*AST, params: std.ArrayList(*AST), retType: *AST, refinement: ?*AST, init: *AST, infer_error: bool, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ .fnDecl = .{
            .common = ASTCommon{ .token = token, ._type = null },
            .name = name,
            .params = params,
            .param_symbols = std.ArrayList(*symbol_.Symbol).init(allocator),
            .retType = retType,
            .refinement = refinement,
            .init = init,
            .infer_error = infer_error,
        } }, allocator);
    }

    pub fn createDefer(token: tokens_.Token, statement: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ ._defer = .{ .common = ASTCommon{ .token = token, ._type = null }, .statement = statement } }, allocator);
    }

    pub fn createErrDefer(token: tokens_.Token, statement: *AST, allocator: std.mem.Allocator) *AST {
        return AST.box(AST{ ._errdefer = .{ .common = ASTCommon{ .token = token, ._type = null }, .statement = statement } }, allocator);
    }

    pub fn create_array_type(len: *AST, of: *AST, allocator: std.mem.Allocator) *AST {
        // Inflate an array-of to a product with `len` `of`'s
        var new_terms = std.ArrayList(*AST).init(allocator);
        std.debug.assert(len.int.data >= 0);
        for (0..@as(usize, @intCast(len.int.data))) |_| {
            new_terms.append(of) catch unreachable;
        }
        return AST.createProduct(of.getToken(), new_terms, allocator);
    }

    pub fn create_slice_type(of: *AST, mut: bool, allocator: std.mem.Allocator) *AST {
        var term_types = std.ArrayList(*AST).init(allocator);
        const data_type = AST.createAddrOf(
            of.getToken(),
            of,
            mut,
            allocator,
        ).assert_valid();
        const annot_type = AST.createAnnotation(of.getToken(), AST.createIdentifier(tokens_.Token.init("data", null, "", "", 0, 0), allocator), data_type, null, null, allocator).assert_valid();
        term_types.append(annot_type) catch unreachable;
        term_types.append(AST.createAnnotation(
            of.getToken(),
            AST.createIdentifier(tokens_.Token.init("length", null, "", "", 0, 0), allocator),
            primitives_.int_type,
            null,
            null,
            allocator,
        )) catch unreachable;
        var retval = AST.createProduct(of.getToken(), term_types, allocator).assert_valid();
        retval.product.was_slice = true;
        return retval;
    }

    // Expr must be a product value of length `l`. Slice value is `(&expr[0], l)`.
    pub fn create_slice_value(expr: *AST, mut: bool, expr_type: *AST, allocator: std.mem.Allocator) *AST {
        var new_terms = std.ArrayList(*AST).init(allocator);
        const zero = (AST.createInt(expr.getToken(), 0, allocator)).assert_valid();
        const index = (AST.createIndex(
            expr.getToken(),
            expr,
            zero,
            allocator,
        )).assert_valid();
        const addr = (AST.createAddrOf(
            expr.getToken(),
            index,
            mut,
            allocator,
        )).assert_valid();
        new_terms.append(addr) catch unreachable;

        const length = (AST.createInt(expr.getToken(), expr_type.product.terms.items.len, allocator)).assert_valid();
        new_terms.append(length) catch unreachable;

        var retval = AST.createProduct(expr.getToken(), new_terms, allocator);
        retval.product.was_slice = true;
        return retval;
    }

    pub fn create_optional_type(of_type: *AST, allocator: std.mem.Allocator) *AST {
        var term_types = std.ArrayList(*AST).init(allocator);

        const none_type = AST.createAnnotation(
            of_type.getToken(),
            AST.createIdentifier(tokens_.Token.init_simple("none"), allocator),
            primitives_.unit_type,
            null,
            AST.createUnitValue(tokens_.Token.init_simple("none init"), allocator),
            allocator,
        );
        term_types.append(none_type) catch unreachable;

        const some_type = AST.createAnnotation(
            of_type.getToken(),
            AST.createIdentifier(tokens_.Token.init("some", null, "", "", 0, 0), allocator),
            of_type,
            null,
            null,
            allocator,
        );
        term_types.append(some_type) catch unreachable;

        var retval = AST.createSum(of_type.getToken(), term_types, allocator);
        retval.sum.was_optional = true;
        return retval;
    }

    pub fn create_some_value(opt_type: *AST, value: *AST, allocator: std.mem.Allocator) *AST {
        const member = createInferredMember(value.getToken(), AST.createIdentifier(tokens_.Token.init_simple("some"), allocator), allocator);
        member.inferredMember.base = opt_type;
        member.inferredMember.init = value;
        member.inferredMember.pos = opt_type.sum.get_pos("some");
        return member.assert_valid();
    }

    pub fn create_none_value(opt_type: *AST, allocator: std.mem.Allocator) *AST {
        const member = createInferredMember(tokens_.Token.init_simple("none"), AST.createIdentifier(tokens_.Token.init_simple("none"), allocator), allocator);
        member.inferredMember.base = opt_type;
        member.inferredMember.pos = opt_type.sum.get_pos("none");
        return member.assert_valid();
    }

    pub fn create_error_type(err_type: *AST, ok_type: *AST, allocator: std.mem.Allocator) *AST {
        const ok_annot = AST.createAnnotation(ok_type.getToken(), AST.createIdentifier(tokens_.Token.init("ok", null, "", "", 0, 0), allocator), ok_type, null, null, allocator);
        var ok_sum_terms = std.ArrayList(*AST).init(allocator);
        ok_sum_terms.append(ok_annot) catch unreachable;
        var ok_sum = AST.createSum(ok_type.getToken(), ok_sum_terms, allocator);
        ok_sum.sum.was_error = true;

        // Err!Ok => (ok:Ok|) || Err
        // This is done so that `ok` has an invariant tag of `0`, and errors have a non-zero tag.
        const retval = AST.createUnion(err_type.getToken(), ok_sum, err_type, allocator);
        return retval;
    }

    pub fn get_none_type(opt_sum: *AST) *AST {
        std.debug.assert(opt_sum.sum.was_optional);
        return opt_sum.sum.terms.items[0];
    }

    pub fn get_some_type(opt_sum: *AST) *AST {
        std.debug.assert(opt_sum.sum.was_optional);
        return opt_sum.sum.terms.items[1];
    }

    pub fn get_ok_type(err_union: *AST) *AST {
        std.debug.assert(err_union.sum.was_error);
        return err_union.sum.terms.items[0];
    }

    pub fn expand_type(self: *AST, allocator: std.mem.Allocator) *AST {
        if (self.getCommon().expanded_type) |expaned_type| {
            return expaned_type;
        }
        const retval = expand_type_internal(self, allocator).assert_valid();
        self.getCommon().expanded_type = retval;
        return retval;
    }

    fn expand_type_internal(self: *AST, allocator: std.mem.Allocator) *AST {
        switch (self.*) {
            .identifier => {
                const symbol = self.identifier.symbol.?;
                if (symbol.init == self) {
                    return self;
                } else {
                    return symbol.init.expand_type(allocator);
                }
            },
            .product => {
                var terms = std.ArrayList(*AST).init(allocator);
                var change = false;
                for (self.product.terms.items) |term| {
                    const new_term = term.expand_type(allocator);
                    terms.append(new_term) catch unreachable;
                    change = new_term != term or change;
                }
                if (change) {
                    var retval = AST.createProduct(self.getToken(), terms, allocator);
                    retval.product.was_slice = self.product.was_slice;
                    return retval;
                } else {
                    terms.deinit();
                    return self;
                }
            },
            .sum => {
                var terms = std.ArrayList(*AST).init(allocator);
                var change = false;
                for (self.sum.terms.items) |term| {
                    const new_term = term.expand_type(allocator);
                    terms.append(new_term) catch unreachable;
                    change = new_term != term or change;
                }
                if (change) {
                    var retval = AST.createSum(self.getToken(), terms, allocator);
                    retval.sum.was_error = self.sum.was_error;
                    retval.sum.was_optional = self.sum.was_optional;
                    return retval;
                } else {
                    terms.deinit();
                    return self;
                }
            },
            .addrOf => {
                const expr = self.addrOf.expr.expand_type(allocator);
                return AST.createAddrOf(self.getToken(), expr, self.addrOf.mut, allocator);
            },
            .function => {
                const lhs = self.function.lhs.expand_type(allocator);
                const rhs = self.function.rhs.expand_type(allocator);
                return AST.createFunction(self.getToken(), lhs, rhs, allocator);
            },
            .annotation => {
                const expr = self.annotation.type.expand_type(allocator);
                return AST.createAnnotation(self.getToken(), self.annotation.pattern, expr, self.annotation.predicate, self.annotation.init, allocator);
            },
            .index => {
                const expr = self.index.lhs.expand_type(allocator);
                return expr.product.terms.items[@as(usize, @intCast(self.index.rhs.int.data))];
            },
            .poison, .unit_type => return self,

            else => return self,
        }
    }

    pub fn createBinop(token: tokens_.Token, lhs: *AST, rhs: *AST, allocator: std.mem.Allocator) *AST {
        switch (token.kind) {
            .PLUS_EQUALS => return createAdd(token, lhs, rhs, allocator),
            .MINUS_EQUALS => return createSub(token, lhs, rhs, allocator),
            .STAR_EQUALS => return createMult(token, lhs, rhs, allocator),
            .SLASH_EQUALS => return createDiv(token, lhs, rhs, allocator),
            .PERCENT_EQUALS => return createMod(token, lhs, rhs, allocator),
            else => {
                std.debug.print("not a operator-assign token\n", .{});
                unreachable;
            },
        }
    }

    pub fn printType(self: *AST, out: anytype) !void {
        switch (self.*) {
            .unit_type => {
                try out.print("()", .{});
            },
            .identifier => {
                try out.print("{s}", .{self.getToken().data});
            },
            .addrOf => {
                try out.print("&", .{});
                if (self.addrOf.mut) {
                    try out.print("mut ", .{});
                }
                try self.addrOf.expr.printType(out);
            },
            .sliceOf => {
                try out.print("[", .{});
                switch (self.sliceOf.kind) {
                    .MUT => try out.print("mut", .{}),
                    .MULTIPTR => try out.print("*", .{}),
                    .SLICE => {},
                    .ARRAY => unreachable,
                }
                try out.print("]", .{});
                try self.sliceOf.expr.printType(out);
            },
            .arrayOf => {
                try out.print("[", .{});
                try self.arrayOf.len.printType(out);
                try out.print("]", .{});
                try self.arrayOf.expr.printType(out);
            },
            .function => {
                try out.print("(", .{});
                try self.function.lhs.printType(out);
                try out.print(")->", .{});
                try self.function.rhs.printType(out);
            },
            .product => if (self.product.homotypical != null and self.product.homotypical.?) {
                try out.print("[{}]", .{self.product.terms.items.len});
                try self.product.terms.items[0].printType(out);
            } else if (self.product.was_slice) {
                try out.print("[]", .{});
                try self.product.terms.items[0].printType(out);
            } else if (self.product.terms.items.len == 0) {
                try out.print("()", .{});
            } else {
                try out.print("(", .{});
                for (self.product.terms.items, 0..self.product.terms.items.len) |term, _| {
                    try term.printType(out);
                    try out.print(", ", .{});
                }
                try self.product.terms.items[self.product.terms.items.len - 1].printType(out);
                try out.print(")", .{});
            },
            .sum => if (self.sum.was_optional) {
                try out.print("?", .{});
                try self.get_some_type().annotation.type.printType(out);
            } else {
                try out.print("(", .{});
                for (self.sum.terms.items, 0..) |term, i| {
                    try term.printType(out);
                    if (self.sum.terms.items.len == 1 or i + 1 != self.sum.terms.items.len) {
                        try out.print(" | ", .{});
                    }
                }
                try out.print(")", .{});
            },
            .inferred_error => {
                try out.print("!", .{});
                try self.inferred_error.terms.items[0].annotation.type.printType(out);
            },
            ._union => {
                try self._union.lhs.printType(out);
                try out.print("||", .{});
                try self._union.rhs.printType(out);
            },
            .annotation => {
                try out.print("{s}: ", .{self.annotation.pattern.getToken().data});
                try self.annotation.type.printType(out);
            },

            // Not necessarily types, but may appear in a type definition
            .int => try out.print("{}", .{self.int.data}),
            .block => {
                try out.print("{{", .{});
                for (self.block.statements.items, 0..) |statement, i| {
                    try statement.printType(out);
                    if (self.block.final != null or i > self.block.statements.items.len - 1) {
                        try out.print("; ", .{});
                    }
                }
                if (self.block.final) |final| {
                    try final.printType(out);
                }
                try out.print("}}", .{});
            },
            .index => {
                try self.index.lhs.printType(out);
                try out.print("[", .{});
                try self.index.rhs.printType(out);
                try out.print("]", .{});
            },
            ._unreachable => {
                try out.print("unreachable", .{});
            },
            .poison => try out.print("<error>", .{}),
            else => {
                try out.print("\nprintTypes(): Unimplemented or not a type: {s}\n", .{@tagName(self.*)});
                unreachable;
            },
        }
    }

    // Must always return a valid type!
    pub fn typeof(self: *AST, allocator: std.mem.Allocator) *AST {
        // std.debug.assert(self.getCommon().validation_state != .unvalidated);
        if (self.getCommon()._type) |_type| {
            return _type;
        }
        const retval: *AST = self.typeof_internal(allocator).assert_valid();
        self.getCommon()._type = retval;
        return retval;
    }

    fn typeof_internal(self: *AST, allocator: std.mem.Allocator) *AST {
        switch (self.*) {
            // Poisoned type
            .poison => return poisoned,

            // Bool type
            ._true,
            ._false,
            .not,
            ._or,
            ._and,
            .equal,
            .not_equal,
            .greater,
            .lesser,
            .greater_equal,
            .lesser_equal,
            => return primitives_.bool_type,

            // Char type
            .char => return primitives_.char_type,

            // Float constant type
            .float => return self.float.represents,

            // Int constant type
            .int => return self.int.represents,

            // String type
            .string => return primitives_.string_type,

            // Type type
            .unit_type,
            .annotation,
            .sum,
            .inferred_error,
            ._union,
            .function,
            ._typeOf,
            => return primitives_.type_type,

            // Unit type
            .unit_value,
            .decl,
            .assign,
            ._defer,
            ._errdefer,
            .discard,
            => return primitives_.unit_type,

            // Void type
            ._continue,
            ._break,
            ._return,
            ._unreachable,
            => return primitives_.void_type,

            // Binary operators
            .add => return self.add.lhs.typeof(allocator),
            .sub => return self.sub.lhs.typeof(allocator),
            .mult => return self.mult.lhs.typeof(allocator),
            .div => return self.div.lhs.typeof(allocator),
            .mod => return self.mod.lhs.typeof(allocator),
            ._catch => return self._catch.rhs.typeof(allocator),
            ._orelse => return self._orelse.rhs.typeof(allocator),

            .product => {
                var first_type = self.product.terms.items[0].typeof(allocator);
                if (first_type.typesMatch(primitives_.type_type)) {
                    // typeof product type is Type
                    return primitives_.type_type;
                } else if (self.product.was_slice) {
                    var addr: *AST = self.product.terms.items[0];
                    var retval = create_slice_type(addr.addrOf.expr.typeof(allocator), addr.addrOf.mut, allocator);
                    retval.product.was_slice = true;
                    return retval;
                } else {
                    var terms = std.ArrayList(*AST).init(allocator);
                    for (self.product.terms.items) |term| {
                        const term_type = term.typeof(allocator);
                        terms.append(term_type) catch unreachable;
                    }
                    var retval = AST.createProduct(self.getToken(), terms, allocator);
                    retval.product.was_slice = self.product.was_slice;
                    return retval;
                }
            },

            .index => {
                var lhs_type = self.index.lhs.typeof(allocator).expand_type(allocator);
                if (lhs_type.typesMatch(primitives_.type_type) and self.index.lhs.* == .product) {
                    return self.index.lhs.product.terms.items[0];
                } else if (lhs_type.* == .product) { // TODO: Replace with if the type implements Indexable or something
                    if (lhs_type.product.was_slice) {
                        return lhs_type.product.terms.items[0].annotation.type.addrOf.expr;
                    } else {
                        return lhs_type.product.terms.items[0];
                    }
                } else if (lhs_type.* == .identifier and std.mem.eql(u8, lhs_type.getToken().data, "String")) {
                    return primitives_.byte_type;
                } else if (lhs_type.* == .poison) {
                    return poisoned;
                } else {
                    std.debug.print("{s} is not indexable\n", .{@tagName(lhs_type.*)});
                    unreachable;
                }
            },

            .select => {
                var select_lhs_type = self.select.lhs.typeof(allocator).expand_identifier();
                var annot_list: *std.ArrayList(*AST) = undefined;
                if (select_lhs_type.* == .product) {
                    annot_list = &select_lhs_type.product.terms;
                } else if (select_lhs_type.* == .sum) {
                    annot_list = &select_lhs_type.sum.terms;
                } else {
                    unreachable;
                }
                var retval = annot_list.items[self.select.pos.?];
                while (retval.* == .annotation) {
                    retval = retval.annotation.type;
                }
                return retval;
            },

            // Identifier
            .identifier => if (std.mem.eql(u8, self.getToken().data, "_")) {
                return primitives_.unit_type;
            } else {
                return self.identifier.symbol.?._type;
            },

            // Unary Operators
            .negate => return self.negate.expr.typeof(allocator),
            .dereference => {
                const _type = self.dereference.expr.typeof(allocator).expand_type(allocator);
                return _type.addrOf.expr;
            },
            .addrOf => {
                var child_type = self.addrOf.expr.typeof(allocator);
                if (child_type.typesMatch(primitives_.type_type)) {
                    return primitives_.type_type;
                } else {
                    return createAddrOf(self.getToken(), child_type, self.addrOf.mut, std.heap.page_allocator);
                }
            },
            .sliceOf => {
                var expr_type = self.sliceOf.expr.typeof(allocator);
                if (expr_type.* != .product or !expr_type.product.is_homotypical()) {
                    return poisoned;
                } else {
                    var child_type = expr_type.product.terms.items[0];
                    if (child_type.typesMatch(primitives_.type_type)) {
                        return primitives_.type_type;
                    } else {
                        return create_slice_type(expr_type.product.terms.items[0], self.sliceOf.kind == .MUT, allocator);
                    }
                }
            },
            .subSlice => return self.subSlice.super.typeof(allocator),
            .inferredMember => return self.inferredMember.base.?.expand_type(allocator),
            ._try => return (self._try.expr.typeof(allocator)).get_ok_type(),
            ._comptime => return self._comptime.expr.typeof(allocator),
            .default => return self.default.expr,

            // Control-flow expressions
            ._if => {
                const body_type = self._if.bodyBlock.typeof(allocator);
                if (self._if.elseBlock) |_| {
                    return body_type;
                } else {
                    return create_optional_type(body_type, allocator);
                }
            },
            .match => return self.match.mappings.items[0].typeof(allocator),
            .mapping => if (self.mapping.rhs) |rhs| {
                return rhs.typeof(allocator);
            } else {
                return primitives_.unit_type;
            },
            ._while => {
                const body_type = self._while.bodyBlock.typeof(allocator);
                if (self._while.elseBlock) |_| {
                    return body_type;
                } else {
                    return create_optional_type(body_type, allocator);
                }
            },
            .block => if (self.block.final) |_| {
                return primitives_.void_type;
            } else if (self.block.statements.items.len == 0) {
                return primitives_.unit_type;
            } else {
                return self.block.statements.items[self.block.statements.items.len - 1].typeof(allocator);
            },
            .call => {
                const fn_type: *AST = self.call.lhs.typeof(allocator).expand_identifier();
                return fn_type.function.rhs;
            },
            .fnDecl => {
                return self.fnDecl.symbol.?._type;
            },
            .symbol => return self.symbol.symbol._type,
            .inject => return self.inject.lhs.typeof(allocator),

            else => {
                std.debug.print("Unimplemented typeof() for: AST.{s}\n", .{@tagName(self.*)});
                unreachable;
            },
        }
    }

    // Expands an ast one level if it is an identifier
    pub fn expand_identifier(self: *AST) *AST {
        if (self.* == .identifier) {
            return self.identifier.symbol.?.init;
        } else {
            return self;
        }
    }

    /// For two types `A` and `B`, we say `A <: B` iff for every value `a` belonging to the type `A`, then
    /// `a` belongs to the type `B`.
    ///
    /// Another way to view this is if `(a: A) <: (b: B)`, then the assignment `b = a` is permissible, since
    /// `a: B`.
    ///
    /// Since the type `Void` has no values, it is vacuously true that `Void <: X` where `X` is any type.
    /// Thus, `let x: Void = y` is never type-sound, since there is no value `y` can be, and
    /// `let x: T = void_typed_expression` is always type-sound.
    ///
    /// The unit type (`()`) acts like the top type. This means `X <: ()` where `X` is any type. Thus,
    /// `let x: T = unit_typed_expression` is type-sound only if `T == ()`, and `let x: () = y` is always
    /// type-sound.
    ///
    /// Thus, we have the following type map:
    ///                        ( )
    ///       /     /     /     |    \      \     \
    ///     Bool  Byte  Char  Float  Int  String  ...
    ///       \     \     \     |    /      /     /
    ///                       Void
    ///
    /// Also, `&mut T <: &T`, because for every `t: &mut T`, `t: &T`. Thus, `let x: &T = mut_expression` is
    /// always type-sound.
    ///
    /// Also, (x: T,) == T == (x: T,)
    pub fn typesMatch(A: *AST, B: *AST) bool {
        // std.debug.print("{} == {}\n", .{ A, B });
        if (A.* == .annotation) {
            return typesMatch(A.annotation.type, B);
        } else if (B.* == .annotation) {
            return typesMatch(A, B.annotation.type);
        }
        if (A.* == .identifier and B.* != .identifier and A != A.expand_identifier()) {
            // If only A is an identifier, and A isn't an atom type, dive
            return typesMatch(A.expand_identifier(), B);
        } else if (A.* != .identifier and B.* == .identifier and B != B.expand_identifier()) {
            // If only B is an identifier, and B isn't an atom type, dive
            return typesMatch(A, B.expand_identifier());
        }
        if (A.* == .poison or B.* == .poison) {
            return true; // Whatever
        }
        if (B.* == .unit_type) {
            return true; // Top type - vacuously true
        }
        if (A.* == .identifier and std.mem.eql(u8, "Void", A.getToken().data)) {
            return true; // Bottom type - vacuously true
        }
        std.debug.assert(A.getCommon().validation_state == .valid);
        std.debug.assert(B.getCommon().validation_state == .valid);

        if (@intFromEnum(A.*) != @intFromEnum(B.*)) {
            return false;
        }

        switch (A.*) {
            .identifier => return std.mem.eql(u8, A.getToken().data, B.getToken().data),
            .addrOf => return (B.addrOf.mut == false or B.addrOf.mut == A.addrOf.mut) and typesMatch(A.addrOf.expr, B.addrOf.expr),
            .sliceOf => return (B.sliceOf.kind != .MUT or @intFromEnum(B.sliceOf.kind) == @intFromEnum(A.sliceOf.kind)) and typesMatch(A.sliceOf.expr, B.sliceOf.expr),
            .unit_type => return true,
            .product => {
                if (B.product.terms.items.len != A.product.terms.items.len) {
                    return false;
                }
                var retval = true;
                for (A.product.terms.items, B.product.terms.items) |term, B_term| {
                    retval = retval and term.typesMatch(B_term);
                }
                return retval;
            },
            .sum => {
                if (B.sum.terms.items.len != A.sum.terms.items.len) {
                    return false;
                }
                var retval = true;
                for (A.sum.terms.items, B.sum.terms.items) |term, B_term| {
                    const this_name = term.annotation.pattern.getToken().data;
                    const B_name = B_term.annotation.pattern.getToken().data;
                    retval = retval and std.mem.eql(u8, this_name, B_name) and term.typesMatch(B_term);
                }
                return retval;
            },
            .function => return A.function.lhs.typesMatch(B.function.lhs) and A.function.rhs.typesMatch(B.function.rhs),
            .inferred_error => return A == B,
            else => {
                // TODO: May need to evaluate types, possibly done somewhere else though
                std.debug.print("typesMatch(): Unimplemented for {s}\n", .{@tagName(A.*)});
                unreachable;
            },
        }
    }

    pub fn generate_default(_type: *AST, errors: *errs_.Errors, allocator: std.mem.Allocator) !*AST {
        return (try generate_default_unvalidated(_type, errors, allocator)).assert_valid();
    }

    fn generate_default_unvalidated(_type: *AST, errors: *errs_.Errors, allocator: std.mem.Allocator) error{typeError}!*AST {
        switch (_type.*) {
            .identifier => {
                const expanded_type = _type.expand_type(allocator);
                if (expanded_type == _type) {
                    const primitive_info = primitives_.get(_type.getToken().data);
                    if (primitive_info.default_value != null) {
                        return primitive_info.default_value.?;
                    } else {
                        errors.addError(errs_.Error{ .no_default = .{ .span = _type.getToken().span, ._type = _type } });
                        return error.typeError;
                    }
                } else {
                    return try generate_default(expanded_type, errors, allocator);
                }
            },
            .addrOf, .function => return AST.createInt(_type.getToken(), 0, allocator),
            .unit_type => return AST.createUnitValue(_type.getToken(), allocator),
            .sum => {
                var retval = AST.createInferredMember(_type.getToken(), AST.createIdentifier(tokens_.Token.init("default lmao", .IDENTIFIER, "", "", 0, 0), allocator), allocator);
                retval.inferredMember.pos = 0;
                retval.inferredMember.base = _type;
                const proper_term: *AST = _type.sum.terms.items[0];
                retval.inferredMember.init = try proper_term.generate_default(errors, allocator);
                return retval;
            },
            .product => {
                var value_terms = std.ArrayList(*AST).init(allocator);
                errdefer value_terms.deinit();
                for (_type.product.terms.items) |term| {
                    const default_term = try term.generate_default(errors, allocator);
                    value_terms.append(default_term) catch unreachable;
                }
                return AST.createProduct(_type.getToken(), value_terms, allocator);
            },
            .annotation => if (_type.annotation.init != null) {
                return _type.annotation.init.?;
            } else {
                return _type.annotation.type.generate_default(errors, allocator);
            },
            else => {
                std.debug.print("Unimplemented generate_default() for: AST.{s}\n", .{@tagName(_type.*)});
                unreachable;
            },
        }
    }

    /// Determines if a given integer type can represent a given integer value.
    pub fn can_represent_integer(self: *AST, value: i128) bool {
        var expanded = self.expand_identifier();
        while (expanded.* == .annotation) {
            expanded = expanded.annotation.type;
        }
        if (expanded.* == .unit_type) {
            // Top type
            return true;
        } else if (expanded.* != .identifier) {
            // Clearly not an integer type
            return false;
        }
        for (primitives_.keys()) |key| {
            const info = primitives_.get(key);
            if (std.mem.eql(u8, info.name, expanded.getToken().data) and
                info.bounds != null and
                value >= info.bounds.?.lower and
                value <= info.bounds.?.upper)
            {
                return true;
            }
        }
        return false;
    }

    pub fn can_represent_float(self: *AST) bool {
        return can_expanded_represent_float(self.expand_identifier());
    }

    pub fn can_expanded_represent_float(self: *AST) bool {
        var expanded = self;
        while (expanded.* == .annotation) {
            expanded = expanded.annotation.type;
        }
        if (expanded.* == .unit_type) {
            // Top type
            return true;
        } else if (expanded.* != .identifier) {
            // Clearly not a float type
            return false;
        }
        const info = primitives_.get(expanded.getToken().data);
        return info.type_kind == .floating_point;
    }

    pub fn is_eq_type(self: *AST) bool {
        var expanded = self.expand_identifier();
        while (expanded.* == .annotation) {
            expanded = expanded.annotation.type;
        }
        if (expanded.* == .addrOf) {
            return true;
        } else if (expanded.* == .product) {
            for (expanded.product.terms.items) |term| {
                if (!term.is_eq_type()) {
                    return false;
                }
            }
            return true;
        } else if (expanded.* == .sum) {
            return true;
        } else if (expanded.* != .identifier) {
            return false;
        }
        return primitives_.from_ast(expanded).is_eq();
    }

    /// Ord <: Eq
    pub fn is_ord_type(self: *AST) bool {
        var expanded = self.expand_identifier();
        while (expanded.* == .annotation) {
            expanded = expanded.annotation.type;
        }
        if (expanded.* != .identifier) {
            return false;
        }
        return primitives_.from_ast(expanded).is_ord();
    }

    /// Num <: Ord
    pub fn is_num_type(self: *AST) bool {
        var expanded = self.expand_identifier();
        while (expanded.* == .annotation) {
            expanded = expanded.annotation.type;
        }
        if (expanded.* != .identifier) {
            return false;
        }
        return primitives_.from_ast(expanded).is_num();
    }

    /// Int <: Num
    pub fn is_int_type(self: *AST) bool {
        var expanded = self.expand_identifier();
        while (expanded.* == .annotation) {
            expanded = expanded.annotation.type;
        }
        if (expanded.* != .identifier) {
            return false;
        }
        return primitives_.from_ast(expanded).is_int();
    }

    pub fn is_comptime_expr(self: *AST) bool {
        // It's easier to list all the ASTs that AREN'T comptime! :-)
        return !(self.* == ._try or
            self.* == .block or
            self.* == .call);
        // AST kinds like `and` and `or` are technically control-flow, but conceptually, they terminate and
        // are pure.
        // `try` breaks normal control-flow. `block` allows for unpure statements like `continue`, `break`,
        // `return`, and `try`. `call` is non-comptime because functions are not pure in Orng.
        // Kinds like `and`, `or`, `orelse`, `catch`, `if`, `match`, and `while` are in a way "purer", and it
        // would be annoying to have to wrap these in comptime.
    }

    // Used to poison an AST node. Marks as valid, so any attempt to validate is memoized to return poison.
    pub fn enpoison(self: *AST) *AST {
        self.getCommon().validation_state = .invalid;
        return poisoned;
    }

    pub fn assert_valid(self: *AST) *AST {
        self.getCommon().validation_state = AST_Validation_State{ .valid = .{ .valid_form = self } };
        return self;
    }

    pub fn set_representation(self: *AST, _type: *AST) *AST {
        switch (self.*) {
            .int => self.int.represents = _type,
            .float => self.float.represents = _type,
            else => {
                std.debug.print("cannot set representation for {}\n", .{self});
                unreachable;
            },
        }
        return self;
    }

    pub fn c_typesMatch(self: *AST, other: *AST) bool {
        if (self.* == .annotation) {
            return c_typesMatch(self.annotation.type, other);
        } else if (other.* == .annotation) {
            return c_typesMatch(self, other.annotation.type);
        }
        std.debug.assert(self.getCommon().validation_state == .valid);
        std.debug.assert(other.getCommon().validation_state == .valid);

        if (@intFromEnum(self.*) != @intFromEnum(other.*)) {
            return false;
        }

        switch (self.*) {
            .identifier => return std.mem.eql(u8, self.getToken().data, other.getToken().data),
            .addrOf => return c_typesMatch(self.addrOf.expr, other.addrOf.expr),

            .unit_type => return other.* == .unit_type,
            .product => {
                if (other.product.terms.items.len != self.product.terms.items.len) {
                    return false;
                }
                var retval = true;
                for (self.product.terms.items, other.product.terms.items) |term, other_term| {
                    retval = retval and term.c_typesMatch(other_term);
                }
                return retval;
            },
            .sum => {
                if (other.sum.terms.items.len != self.sum.terms.items.len) {
                    return false;
                }
                var retval = true;
                for (self.sum.terms.items, other.sum.terms.items) |term, other_term| {
                    retval = retval and term.c_typesMatch(other_term);
                }
                return retval;
            },
            .function => return self.function.lhs.c_typesMatch(other.function.lhs) and self.function.rhs.c_typesMatch(other.function.rhs),
            else => {
                std.debug.print("typesMatch(): Unimplemented for {s}\n", .{@tagName(self.*)});
                unreachable;
            },
        }
    }

    pub fn pprint(self: AST, allocator: std.mem.Allocator) ![]const u8 {
        var out = String.init(allocator);
        defer out.deinit();

        switch (self) {
            .poison => try out.writer().print("poison", .{}),
            .unit_type => try out.writer().print("unit_type", .{}),
            .unit_value => try out.writer().print("unit_value", .{}),
            .int => try out.writer().print("int({})", .{self.int.data}),
            .char => try out.writer().print("char()", .{}),
            .float => try out.writer().print("float()", .{}),
            .string => try out.writer().print("string()", .{}),
            .field => try out.writer().print("field(\"{s}\")", .{self.field.common.token.data}),
            .identifier => try out.writer().print("identifier(\"{s}\")", .{self.identifier.common.token.data}),
            ._unreachable => try out.writer().print("unreachable", .{}),
            ._true => try out.writer().print("true", .{}),
            ._false => try out.writer().print("false", .{}),

            .not => try out.writer().print("not()", .{}),
            .negate => try out.writer().print("negate({})", .{self.negate.expr}),
            .dereference => try out.writer().print("dereference()", .{}),
            ._try => try out.writer().print("try()", .{}),
            .discard => try out.writer().print("discard()", .{}),
            ._typeOf => try out.writer().print("typeof({})", .{self._typeOf.expr}),
            .default => try out.writer().print("default({})", .{self.default.expr}),
            .sizeOf => try out.writer().print("sizeOf({})", .{self.sizeOf.expr}),
            .domainOf => try out.writer().print("domainof()", .{}),
            ._comptime => {
                try out.writer().print("comptime({})", .{self._comptime.expr});
            },

            .assign => try out.writer().print("assign()", .{}),
            ._or => try out.writer().print("or()", .{}),
            ._and => try out.writer().print("and()", .{}),
            .add => try out.writer().print("add()", .{}),
            .sub => try out.writer().print("sub()", .{}),
            .mult => try out.writer().print("mult()", .{}),
            .div => try out.writer().print("div()", .{}),
            .mod => try out.writer().print("mod()", .{}),
            .equal => try out.writer().print("equal()", .{}),
            .not_equal => try out.writer().print("not_equal()", .{}),
            .greater => try out.writer().print("greater()", .{}),
            .lesser => try out.writer().print("lesser()", .{}),
            .greater_equal => try out.writer().print("greater_equal()", .{}),
            .lesser_equal => try out.writer().print("lesser_equal()", .{}),
            ._catch => try out.writer().print("catch()", .{}),
            ._orelse => try out.writer().print("orelse()", .{}),
            .call => try out.writer().print("call()", .{}),
            .index => try out.writer().print("index()", .{}),
            .select => try out.writer().print("select()", .{}),
            .function => try out.writer().print("function({},{})", .{ self.function.lhs, self.function.rhs }),
            .invoke => try out.writer().print("invoke()", .{}),
            .sum => {
                try out.writer().print("sum(", .{});
                for (self.sum.terms.items, 0..) |item, i| {
                    try out.writer().print("{}", .{item});
                    if (i < self.sum.terms.items.len - 1) {
                        try out.writer().print(",", .{});
                    }
                }
                try out.writer().print(")", .{});
            },
            .inferred_error => try out.writer().print("inferred_error()", .{}),
            .inject => try out.writer().print("inject()", .{}),
            .product => {
                try out.writer().print("product(", .{});
                for (self.product.terms.items, 0..) |item, i| {
                    try out.writer().print("{}", .{item});
                    if (i < self.product.terms.items.len - 1) {
                        try out.writer().print(",", .{});
                    }
                }
                try out.writer().print(")", .{});
            },
            ._union => try out.writer().print("union()", .{}),

            .addrOf => try out.writer().print("addrOf({})", .{self.addrOf.expr}),
            .sliceOf => try out.writer().print("sliceOf()", .{}),
            .arrayOf => try out.writer().print("arrayOf()", .{}),
            .subSlice => try out.writer().print("subSlice()", .{}),
            .annotation => try out.writer().print("annotation(.field={}, .type={},.init={?})", .{ self.annotation.pattern, self.annotation.type, self.annotation.init }),
            .inferredMember => try out.writer().print("inferredMember(.ident={s})", .{self.inferredMember.ident.getToken().data}),

            ._if => try out.writer().print("if()", .{}),
            .match => try out.writer().print("match()", .{}),
            .mapping => try out.writer().print("mapping()", .{}),
            ._while => try out.writer().print("while()", .{}),
            ._for => try out.writer().print("for()", .{}),
            .block => try out.writer().print("block()", .{}),
            ._break => try out.writer().print("break", .{}),
            ._continue => try out.writer().print("continue", .{}),
            ._return => try out.writer().print("return()", .{}),
            .symbol => try out.writer().print("symbol({s})", .{self.symbol.name}),
            .decl => {
                try out.writer().print("decl(\n", .{});
                try out.writer().print("    .pattern = {},\n", .{self.decl.pattern});
                try out.writer().print("    .type = {?},\n", .{self.decl.type});
                try out.writer().print("    .init = {?},\n", .{self.decl.init});
                try out.writer().print(")", .{});
            },
            .fnDecl => try out.writer().print("fnDecl()", .{}),
            ._defer => try out.writer().print("defer()", .{}),
            ._errdefer => try out.writer().print("errdefer()", .{}),
        }

        return (try out.toOwned()).?;
    }

    pub fn format(self: AST, comptime fmt: []const u8, options: std.fmt.FormatOptions, writer: anytype) !void {
        _ = options;
        _ = fmt;
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();

        const out = self.pprint(arena.allocator()) catch unreachable;

        try writer.print("{s}", .{out});
    }
};
