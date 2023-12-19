const std = @import("std");
const ast_ = @import("ast.zig");
const errs_ = @import("errors.zig");
const primitives_ = @import("primitives.zig");
const String = @import("zig-string/zig-string.zig").String;
const symbol_ = @import("symbol.zig");
const token_ = @import("token.zig");

const SymbolErrorEnum = error{ symbolError, OutOfMemory, NoSpaceLeft, InvalidRange };

pub fn symbolTableFromASTList(asts: std.ArrayList(*ast_.AST), scope: *symbol_.Scope, errors: *errs_.Errors, allocator: std.mem.Allocator) SymbolErrorEnum!void {
    for (asts.items) |ast| {
        try symbolTableFromAST(ast, scope, errors, allocator);
    }
}

// Takes in an ast, returns the scope constructed from that AST node
// Most AST nodes don't do anything, except blocks and decls, which can be buried deep in an AST
pub fn symbolTableFromAST(maybe_ast: ?*ast_.AST, scope: *symbol_.Scope, errors: *errs_.Errors, allocator: std.mem.Allocator) SymbolErrorEnum!void {
    if (maybe_ast == null) {
        return;
    }
    var ast = maybe_ast.?;
    switch (ast.*) {
        .unit_type,
        .unit_value,
        .int,
        .char,
        .float,
        .string,
        .field,
        .identifier,
        ._unreachable,
        ._true,
        ._false,
        .inferredMember,
        .poison,
        .symbol,
        .domainOf,
        .sizeOf,
        => {},

        ._break => {
            if (!scope.in_loop) {
                errors.addError(errs_.Error{ .basic = .{
                    .span = ast.getToken().span,
                    .msg = "`break` must be inside a loop",
                } });
                return error.symbolError;
            }
        },

        ._continue => {
            if (!scope.in_loop) {
                errors.addError(errs_.Error{ .basic = .{
                    .span = ast.getToken().span,
                    .msg = "`continue` must be inside a loop",
                } });
                return error.symbolError;
            }
        },

        ._typeOf => try symbolTableFromAST(ast._typeOf.expr, scope, errors, allocator),
        .default => try symbolTableFromAST(ast.default.expr, scope, errors, allocator),
        .not => try symbolTableFromAST(ast.not.expr, scope, errors, allocator),
        .negate => try symbolTableFromAST(ast.negate.expr, scope, errors, allocator),
        .dereference => try symbolTableFromAST(ast.dereference.expr, scope, errors, allocator),
        ._try => {
            if (scope.inner_function == null) {
                errors.addError(errs_.Error{ .basic = .{ .span = ast.getToken().span, .msg = "try operator is not within a function" } });
                return error.symbolError;
            }
            ast._try.function = scope.inner_function;
            try symbolTableFromAST(ast._try.expr, scope, errors, allocator);
        },
        .discard => try symbolTableFromAST(ast.discard.expr, scope, errors, allocator),
        ._comptime => {
            const symbol = try create_temp_comptime_symbol(ast, null, scope, errors, allocator);
            const res = scope.lookup(symbol.name, false);
            switch (res) {
                .found => {
                    const first = res.found;
                    errors.addError(errs_.Error{ .redefinition = .{
                        .first_defined_span = first.span,
                        .redefined_span = symbol.span,
                        .name = symbol.name,
                    } });
                    return error.symbolError;
                },
                else => try scope.symbols.put(symbol.name, symbol),
            }
            ast._comptime.symbol = symbol;
        },

        .assign => {
            try symbolTableFromAST(ast.assign.lhs, scope, errors, allocator);
            try symbolTableFromAST(ast.assign.rhs, scope, errors, allocator);
        },
        ._or => {
            try symbolTableFromAST(ast._or.lhs, scope, errors, allocator);
            try symbolTableFromAST(ast._or.rhs, scope, errors, allocator);
        },
        ._and => {
            try symbolTableFromAST(ast._and.lhs, scope, errors, allocator);
            try symbolTableFromAST(ast._and.rhs, scope, errors, allocator);
        },
        .add => {
            try symbolTableFromAST(ast.add.lhs, scope, errors, allocator);
            try symbolTableFromAST(ast.add.rhs, scope, errors, allocator);
        },
        .sub => {
            try symbolTableFromAST(ast.sub.lhs, scope, errors, allocator);
            try symbolTableFromAST(ast.sub.rhs, scope, errors, allocator);
        },
        .mult => {
            try symbolTableFromAST(ast.mult.lhs, scope, errors, allocator);
            try symbolTableFromAST(ast.mult.rhs, scope, errors, allocator);
        },
        .div => {
            try symbolTableFromAST(ast.div.lhs, scope, errors, allocator);
            try symbolTableFromAST(ast.div.rhs, scope, errors, allocator);
        },
        .mod => {
            try symbolTableFromAST(ast.mod.lhs, scope, errors, allocator);
            try symbolTableFromAST(ast.mod.rhs, scope, errors, allocator);
        },
        .equal => {
            try symbolTableFromAST(ast.equal.lhs, scope, errors, allocator);
            try symbolTableFromAST(ast.equal.rhs, scope, errors, allocator);
        },
        .not_equal => {
            try symbolTableFromAST(ast.not_equal.lhs, scope, errors, allocator);
            try symbolTableFromAST(ast.not_equal.rhs, scope, errors, allocator);
        },
        .greater => {
            try symbolTableFromAST(ast.greater.lhs, scope, errors, allocator);
            try symbolTableFromAST(ast.greater.rhs, scope, errors, allocator);
        },
        .lesser => {
            try symbolTableFromAST(ast.lesser.lhs, scope, errors, allocator);
            try symbolTableFromAST(ast.lesser.rhs, scope, errors, allocator);
        },
        .greater_equal => {
            try symbolTableFromAST(ast.greater_equal.lhs, scope, errors, allocator);
            try symbolTableFromAST(ast.greater_equal.rhs, scope, errors, allocator);
        },
        .lesser_equal => {
            try symbolTableFromAST(ast.lesser_equal.lhs, scope, errors, allocator);
            try symbolTableFromAST(ast.lesser_equal.rhs, scope, errors, allocator);
        },
        ._catch => {
            try symbolTableFromAST(ast._catch.lhs, scope, errors, allocator);
            try symbolTableFromAST(ast._catch.rhs, scope, errors, allocator);
        },
        ._orelse => {
            try symbolTableFromAST(ast._orelse.lhs, scope, errors, allocator);
            try symbolTableFromAST(ast._orelse.rhs, scope, errors, allocator);
        },
        .call => {
            try symbolTableFromAST(ast.call.lhs, scope, errors, allocator);
            try symbolTableFromASTList(ast.call.args, scope, errors, allocator);
        },
        .index => {
            try symbolTableFromAST(ast.index.lhs, scope, errors, allocator);
            try symbolTableFromAST(ast.index.rhs, scope, errors, allocator);
        },
        .select => {
            try symbolTableFromAST(ast.select.lhs, scope, errors, allocator);
            try symbolTableFromAST(ast.select.rhs, scope, errors, allocator);
        },
        .function => {
            try symbolTableFromAST(ast.function.lhs, scope, errors, allocator);
            try symbolTableFromAST(ast.function.rhs, scope, errors, allocator);
        },
        .invoke => {
            try symbolTableFromAST(ast.invoke.lhs, scope, errors, allocator);
            try symbolTableFromAST(ast.invoke.rhs, scope, errors, allocator);
        },
        .sum => {
            try symbolTableFromASTList(ast.sum.terms, scope, errors, allocator);
        },
        .inferred_error => {
            try symbolTableFromASTList(ast.inferred_error.terms, scope, errors, allocator);
        },
        .inject => {
            try symbolTableFromAST(ast.inject.lhs, scope, errors, allocator);
            try symbolTableFromAST(ast.inject.rhs, scope, errors, allocator);
        },
        ._union => {
            try symbolTableFromAST(ast._union.lhs, scope, errors, allocator);
            try symbolTableFromAST(ast._union.rhs, scope, errors, allocator);
        },

        .product => {
            try symbolTableFromASTList(ast.product.terms, scope, errors, allocator);
        },
        .addrOf => try symbolTableFromAST(ast.addrOf.expr, scope, errors, allocator),
        .sliceOf => {
            try symbolTableFromAST(ast.sliceOf.expr, scope, errors, allocator);
            try symbolTableFromAST(ast.sliceOf.len, scope, errors, allocator);
        },
        .subSlice => {
            try symbolTableFromAST(ast.subSlice.super, scope, errors, allocator);
            try symbolTableFromAST(ast.subSlice.lower, scope, errors, allocator);
            try symbolTableFromAST(ast.subSlice.upper, scope, errors, allocator);
        },
        .annotation => {
            try symbolTableFromAST(ast.annotation.type, scope, errors, allocator);
            try symbolTableFromAST(ast.annotation.predicate, scope, errors, allocator);
            try symbolTableFromAST(ast.annotation.init, scope, errors, allocator);
        },

        ._if => {
            const new_scope = try symbol_.Scope.init(scope, "", allocator);
            ast._if.scope = new_scope;
            try symbolTableFromAST(ast._if.let, scope, errors, allocator);
            try symbolTableFromAST(ast._if.condition, new_scope, errors, allocator);
            try symbolTableFromAST(ast._if.bodyBlock, new_scope, errors, allocator);
            try symbolTableFromAST(ast._if.elseBlock, new_scope, errors, allocator);
        },
        .match => {
            const new_scope = try symbol_.Scope.init(scope, "", allocator);
            ast.match.scope = new_scope;
            try symbolTableFromAST(ast.match.let, scope, errors, allocator);
            try symbolTableFromAST(ast.match.expr, new_scope, errors, allocator);
            try create_match_pattern_symbol(ast, new_scope, errors, allocator);
            try symbolTableFromASTList(ast.match.mappings, new_scope, errors, allocator);
        },
        .mapping => {
            try symbolTableFromAST(ast.mapping.lhs, scope, errors, allocator);
        },
        ._while => {
            const new_scope = try symbol_.Scope.init(scope, "", allocator);
            var loop_scope = try symbol_.Scope.init(new_scope, "", allocator); // let, cond, and post are NOT in loop scope, `break` and `continue` are not appropriate
            loop_scope.in_loop = true;
            ast._while.scope = new_scope;
            try symbolTableFromAST(ast._while.let, new_scope, errors, allocator);
            try symbolTableFromAST(ast._while.condition, new_scope, errors, allocator);
            try symbolTableFromAST(ast._while.post, new_scope, errors, allocator);
            try symbolTableFromAST(ast._while.bodyBlock, loop_scope, errors, allocator);
            try symbolTableFromAST(ast._while.elseBlock, loop_scope, errors, allocator);
        },
        ._for => {
            const new_scope = try symbol_.Scope.init(scope, "", allocator);
            ast._for.scope = new_scope;
            try symbolTableFromAST(ast._for.let, scope, errors, allocator);
            try symbolTableFromAST(ast._for.elem, scope, errors, allocator);
            try symbolTableFromAST(ast._for.iterable, scope, errors, allocator);
            try symbolTableFromAST(ast._for.bodyBlock, scope, errors, allocator);
            try symbolTableFromAST(ast._for.elseBlock, scope, errors, allocator);
        },
        .block => {
            const new_scope = try symbol_.Scope.init(scope, "", allocator);
            ast.block.scope = new_scope;
            try symbolTableFromASTList(ast.block.statements, new_scope, errors, allocator);
            if (ast.block.final) |final| {
                try symbolTableFromAST(final, new_scope, errors, allocator);
            }
        },

        ._return => {
            if (scope.in_function == 0 or scope.inner_function == null) {
                errors.addError(errs_.Error{ .basic = .{
                    .span = ast.getToken().span,
                    .msg = "`return` must be inside in a function",
                } });
                return error.symbolError;
            }
            ast._return.function = scope.inner_function;
            try symbolTableFromAST(ast._return.expr, scope, errors, allocator);
        },
        .decl => {
            // Both put a Symbol in the current scope, and recurse
            try create_symbol(&ast.decl.symbols, ast.decl.pattern, ast.decl.type, ast.decl.init, scope, errors, allocator);
            try put_all_symbols(&ast.decl.symbols, scope, errors);
            try symbolTableFromAST(ast.decl.type, scope, errors, allocator);
            try symbolTableFromAST(ast.decl.init, scope, errors, allocator);

            if (ast.decl.top_level) {
                for (ast.decl.symbols.items) |symbol| {
                    if (symbol.kind != ._const) {
                        errors.addError(errs_.Error{ .basic = .{ .span = symbol.span, .msg = "top level symbols must be marked `const`" } });
                        return error.symbolError;
                    }
                }
            }
        },
        .fnDecl => {
            if (ast.fnDecl.symbol != null) {
                // Do not re-do symbol if already declared
                return;
            }
            const symbol = try createFunctionSymbol(ast, scope, errors, allocator);
            const res = scope.lookup(symbol.name, false);
            switch (res) {
                .found => {
                    const first = res.found;
                    errors.addError(errs_.Error{ .redefinition = .{
                        .first_defined_span = first.span,
                        .redefined_span = symbol.span,
                        .name = symbol.name,
                    } });
                    return error.symbolError;
                },
                else => try scope.symbols.put(symbol.name, symbol),
            }
            ast.fnDecl.symbol = symbol;
        },
        ._defer => {
            try scope.defers.append(ast._defer.statement);
            try symbolTableFromAST(ast._defer.statement, scope, errors, allocator);
        },
        ._errdefer => {
            try scope.errdefers.append(ast._errdefer.statement);
            try symbolTableFromAST(ast._errdefer.statement, scope, errors, allocator);
        },
    }
}

fn put_all_symbols(symbols: *std.ArrayList(*symbol_.Symbol), scope: *symbol_.Scope, errors: *errs_.Errors) !void {
    for (symbols.items) |symbol| {
        const res = scope.lookup(symbol.name, false);
        switch (res) {
            .found => {
                const first = res.found;
                errors.addError(errs_.Error{ .redefinition = .{
                    .first_defined_span = first.span,
                    .redefined_span = symbol.span,
                    .name = symbol.name,
                } });
                return error.symbolError;
            },
            else => try scope.symbols.put(symbol.name, symbol),
        }
    }
}

fn create_symbol(symbols: *std.ArrayList(*symbol_.Symbol), pattern: *ast_.AST, _type: *ast_.AST, init: *ast_.AST, scope: *symbol_.Scope, errors: *errs_.Errors, allocator: std.mem.Allocator) SymbolErrorEnum!void {
    switch (pattern.*) {
        .symbol => {
            // TODO: Clean this up
            if (pattern.symbol.kind == ._const) {
                // `const` symbol, surround with comptime
                const ast = try ast_.AST.createComptime(init.getToken(), init, allocator);
                const comptime_symbol = try create_temp_comptime_symbol(ast, _type, scope, errors, allocator);
                const res = scope.lookup(comptime_symbol.name, false);
                switch (res) {
                    .found => {
                        const first = res.found;
                        errors.addError(errs_.Error{ .redefinition = .{
                            .first_defined_span = first.span,
                            .redefined_span = comptime_symbol.span,
                            .name = comptime_symbol.name,
                        } });
                        return error.symbolError;
                    },
                    else => try scope.symbols.put(comptime_symbol.name, comptime_symbol),
                }
                ast._comptime.symbol = comptime_symbol;

                const symbol = try symbol_.Symbol.create(
                    scope,
                    pattern.symbol.name,
                    pattern.getToken().span,
                    _type,
                    ast,
                    null,
                    pattern.symbol.kind,
                    allocator,
                );
                pattern.symbol.symbol = symbol;
                try symbols.append(symbol);
            } else if (!std.mem.eql(u8, pattern.symbol.name, "_")) {
                // Regular `let` or `mut` symbol, not `_`
                const symbol = try symbol_.Symbol.create(
                    scope,
                    pattern.symbol.name,
                    pattern.getToken().span,
                    _type,
                    init,
                    null,
                    pattern.symbol.kind,
                    allocator,
                );
                pattern.symbol.symbol = symbol;
                try symbols.append(symbol);
            } else if (pattern.symbol.kind != .let) {
                // It is an error for `_` to be marked as `const` or `mut`
                errors.addError(errs_.Error{ .discard_marked = .{
                    .span = pattern.getToken().span,
                    .kind = pattern.symbol.kind,
                } });
                return error.symbolError;
            } else {
                // Register the symbol of the symbol pattern as the blackhole symbol, but do not append
                pattern.symbol.symbol = primitives_.blackhole;
            }
        },
        .product => {
            for (pattern.product.terms.items, 0..) |term, i| {
                const index = try ast_.AST.createInt(pattern.getToken(), i, allocator);
                const new_type: *ast_.AST = try ast_.AST.createIndex(_type.getToken(), _type, index, allocator);
                const new_init: *ast_.AST = try ast_.AST.createIndex(init.getToken(), init, index, allocator);
                try create_symbol(symbols, term, new_type, new_init, scope, errors, allocator);
            }
        },
        .inject => {
            const lhs_type = try ast_.AST.createTypeOf(pattern.getToken(), init, allocator);
            const rhs_type = try ast_.AST.createDomainOf(pattern.getToken(), lhs_type, pattern, allocator);
            // All symbols need inits, this is just a phony init since these symbols are more like parameters.
            // We do the same for parameters, btw!
            const phony_init = try ast_.AST.createDefault(pattern.getToken(), rhs_type, allocator);

            try create_symbol(symbols, pattern.inject.lhs, lhs_type, phony_init, scope, errors, allocator);
            try create_symbol(symbols, pattern.inject.rhs, rhs_type, phony_init, scope, errors, allocator);
        },
        else => {},
    }
}

fn create_match_pattern_symbol(match: *ast_.AST, scope: *symbol_.Scope, errors: *errs_.Errors, allocator: std.mem.Allocator) !void {
    for (match.match.mappings.items) |mapping| {
        if (mapping.mapping.lhs != null) {
            const new_scope = try symbol_.Scope.init(scope, "", allocator);
            mapping.mapping.scope = new_scope;
            var symbols = std.ArrayList(*symbol_.Symbol).init(allocator);
            defer symbols.deinit();
            const _type = try ast_.AST.createTypeOf(match.match.expr.getToken(), match.match.expr, allocator);
            try create_symbol(&symbols, mapping.mapping.lhs.?, _type, match.match.expr, new_scope, errors, allocator);
            for (symbols.items) |symbol| {
                symbol.defined = true;
            }
            try put_all_symbols(&symbols, new_scope, errors);
            try symbolTableFromAST(mapping.mapping.rhs, new_scope, errors, allocator);
        } else {
            try symbolTableFromAST(mapping.mapping.rhs, scope, errors, allocator);
        }
    }
}

fn createFunctionSymbol(ast: *ast_.AST, scope: *symbol_.Scope, errors: *errs_.Errors, allocator: std.mem.Allocator) SymbolErrorEnum!*symbol_.Symbol {
    // Calculate the domain type from the function paramter types
    const domain = try extractDomain(
        ast.fnDecl.params,
        ast.fnDecl.retType.getToken(),
        allocator,
    );

    // Create the function type
    const _type = try ast_.AST.createFunction(
        ast.fnDecl.retType.getToken(),
        domain,
        ast.fnDecl.retType,
        allocator,
    );

    // Create the function scope
    var fnScope = try symbol_.Scope.init(scope, "", allocator);
    fnScope.in_function = scope.in_function + 1;

    // Recurse parameters and init
    try symbolTableFromASTList(ast.fnDecl.params, fnScope, errors, allocator);
    try symbolTableFromAST(ast.fnDecl.retType, fnScope, errors, allocator);

    // Put the param symbols in the param symbols list
    for (ast.fnDecl.params.items) |param| {
        const symbol = param.decl.symbols.items[0];
        try ast.fnDecl.param_symbols.append(symbol);
    }

    const keySet = fnScope.symbols.keys();
    var i: usize = 0;
    while (i < keySet.len) : (i += 1) {
        const key = keySet[i];
        var symbol = fnScope.symbols.get(key).?;
        symbol.defined = true;
        symbol.decld = true;
        symbol.param = true;
    }

    // Choose name (maybe anon)
    var buf: []const u8 = undefined;
    if (ast.fnDecl.name) |name| {
        buf = name.getToken().data;
    } else {
        buf = try nextAnonFunctionName(allocator);
    }
    const retval = try symbol_.Symbol.create(
        fnScope,
        buf,
        ast.getToken().span,
        _type,
        ast.fnDecl.init,
        ast,
        ._fn,
        allocator,
    );
    fnScope.inner_function = retval;

    try symbolTableFromAST(ast.fnDecl.init, fnScope, errors, allocator);
    return retval;
}

var numAnonFunctions: usize = 0;
fn nextAnonFunctionName(allocator: std.mem.Allocator) SymbolErrorEnum![]const u8 {
    defer numAnonFunctions += 1;
    var out = String.init(allocator);
    defer out.deinit();
    try out.writer().print("$anon{}", .{numAnonFunctions});
    return (try out.toOwned()).?;
}

fn extractDomain(params: std.ArrayList(*ast_.AST), token: token_.Token, allocator: std.mem.Allocator) SymbolErrorEnum!*ast_.AST {
    if (params.items.len == 0) {
        return try ast_.AST.createUnitType(token, allocator);
    } else if (params.items.len <= 1) {
        return ast_.AST.createAnnotation(params.items[0].getToken(), params.items[0].decl.pattern, params.items[0].decl.type, null, params.items[0].decl.init, allocator);
    } else {
        std.debug.assert(params.items.len >= 2);
        var param_types = std.ArrayList(*ast_.AST).init(allocator);
        var i: usize = 0;
        while (i < params.items.len) : (i += 1) {
            try param_types.append(try ast_.AST.createAnnotation(params.items[i].getToken(), params.items[i].decl.pattern, params.items[i].decl.type, null, params.items[i].decl.init, allocator));
        }
        const retval = try ast_.AST.createProduct(params.items[0].getToken(), param_types, allocator);
        return retval;
    }
}

// ast is a `comptime` ast
fn create_temp_comptime_symbol(ast: *ast_.AST, rhs_type_hint: ?*ast_.AST, scope: *symbol_.Scope, errors: *errs_.Errors, allocator: std.mem.Allocator) SymbolErrorEnum!*symbol_.Symbol {
    // Create the function type. The rhs is a typeof node, since type expansion is done in a later time
    const lhs = try ast_.AST.createUnitType(ast._comptime.expr.getToken(), allocator);
    const rhs = try ast_.AST.createTypeOf(ast._comptime.expr.getToken(), ast._comptime.expr, allocator);
    const _type = try ast_.AST.createFunction(ast._comptime.expr.getToken(), lhs, rhs_type_hint orelse rhs, allocator);

    // Create the comptime scope
    // This is to prevent `comptime` expressions from using runtime variables
    var comptime_scope = try symbol_.Scope.init(scope, "", allocator);
    comptime_scope.in_function = scope.in_function;

    // Choose name
    var buf: []const u8 = undefined;
    buf = try next_comptime_name(allocator);

    // Create the symbol
    const retval = try symbol_.Symbol.create(
        comptime_scope,
        buf,
        ast.getToken().span,
        _type,
        ast._comptime.expr,
        ast,
        ._comptime,
        allocator,
    );
    comptime_scope.inner_function = retval;

    try symbolTableFromAST(ast._comptime.expr, comptime_scope, errors, allocator);
    return retval;
}

var num_comptime: usize = 0;
fn next_comptime_name(allocator: std.mem.Allocator) SymbolErrorEnum![]const u8 {
    // TODO: Idk maybe generalize this with the anon function name
    defer numAnonFunctions += 1;
    var out = String.init(allocator);
    defer out.deinit();
    try out.writer().print("$comptime{}", .{numAnonFunctions});
    return (try out.toOwned()).?;
}
