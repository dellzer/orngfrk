const std = @import("std");
const ast = @import("ast.zig");
// const codegen = @import("codegen.zig");
const Context = @import("interpreter.zig").Context;
const errs = @import("errors.zig");
const ir = @import("ir.zig");
const layout = @import("layout.zig");
const lexer = @import("lexer.zig");
const Parser = @import("parser.zig").Parser;
const primitives = @import("primitives.zig");
const module_ = @import("module.zig");
const Module = module_.Module;
const Span = @import("span.zig");
const symbol = @import("symbol.zig");
const Token = @import("token.zig").Token;
const validate = @import("validate.zig");
const optimizations = @import("optimizations.zig");

// Accepts a file as an argument. That file should contain orng constant/type/function declarations, and an entry-point
// Files may also call some built-in compiletime functions which may import other Orng files, C headers, etc...
// Afterwards, the program is collated to a CFG and written to a .c file. A C compiler may be called, and a
pub fn main() !void {
    const allocator = std.heap.page_allocator;

    // Get second command line argument
    var args = try std.process.ArgIterator.initWithAllocator(allocator);
    _ = args.next() orelse unreachable;
    const arg = args.next() orelse {
        std.debug.print("{s}\n", .{"Usage: zig build run -- <orng-filename>"});
        return;
    };

    // Get the path
    var path_buffer: [std.fs.MAX_PATH_BYTES]u8 = undefined;
    const path: []u8 = try std.fs.realpath(arg, &path_buffer);

    // Parse further args
    var fuzz_tokens = false;
    if (args.next()) |_arg| {
        if (std.mem.eql(u8, "--fuzz", _arg)) {
            fuzz_tokens = true;
        } else {
            std.debug.print("invalid command-line argument: {s}\nusage: orng-test (integration | coverage | fuzz)\n", .{_arg});
            return error.InvalidCliArgument;
        }
    }

    var errors = errs.Errors.init(allocator);
    defer errors.deinit();

    const prelude = try primitives.init();

    if (fuzz_tokens) {
        compile(&errors, path, "examples/out.c", prelude, fuzz_tokens, allocator) catch {};
    } else {
        try compile(&errors, path, "examples/out.c", prelude, fuzz_tokens, allocator);
    }
}

/// Compiles and outputs a file
pub fn compile(
    errors: *errs.Errors,
    in_name: []const u8,
    out_name: []const u8,
    prelude: *symbol.Scope,
    fuzz_tokens: bool,
    allocator: std.mem.Allocator,
) !ir.IRData {
    // Open the file
    var file = try std.fs.cwd().openFile(in_name, .{});
    defer file.close();

    const stat = try file.stat();
    const uid = stat.mtime;

    // Read in the contents of the file
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var contents_arraylist = std.ArrayList(u8).init(allocator);
    defer contents_arraylist.deinit();
    try in_stream.readAllArrayList(&contents_arraylist, 0xFFFF_FFFF);
    const contents = try contents_arraylist.toOwnedSlice();

    var lines = std.ArrayList([]const u8).init(allocator);
    defer lines.deinit();

    const module = compileContents(errors, &lines, in_name, contents, uid, prelude, fuzz_tokens, allocator) catch |err| {
        switch (err) {
            error.lexerError,
            error.parserError,
            => {
                try errors.printErrors();
                return err;
            },
            error.symbolError,
            error.typeError,
            => if (!fuzz_tokens) {
                try errors.printErrors();
                return err;
            } else {
                return err;
            },
            else => return err,
        }
    };
    return try output(errors, module, out_name, allocator);
    // catch |err| {
    //     switch (err) {
    //         error.symbolError,
    //         error.typeError,
    //         => if (!fuzz_tokens) {
    //             try errors.printErrors();
    //             return err;
    //         },
    //         else => return err,
    //     }
    // };
}

/// Takes in a string of contents, compiles it to a statically correct module
pub fn compileContents(
    errors: *errs.Errors,
    lines: *std.ArrayList([]const u8),
    in_name: []const u8,
    contents: []const u8,
    uid: i128,
    prelude: *symbol.Scope,
    fuzz_tokens: bool,
    allocator: std.mem.Allocator,
) !*Module {
    // Construct the name
    var i: usize = 0;
    while (i < in_name.len and in_name[i] != '.') : (i += 1) {}
    const name: []const u8 = in_name[0..i];

    // Tokenize, and also append lines to the list of lines
    try lexer.getLines(contents, lines, errors);
    var tokens = try lexer.getTokens(lines, in_name, errors, fuzz_tokens, allocator);
    defer tokens.deinit(); // Make copies of tokens, never take their address

    if (false and fuzz_tokens) { // print tokens before layout
        for (tokens.items) |token| {
            std.debug.print("{s} ", .{token.data});
        }
        std.debug.print("\n", .{});
    }

    // Layout
    if (!fuzz_tokens) {
        try layout.doLayout(&tokens);
    }

    if (false) { // Print out tokens after layout
        var indent: usize = 0;
        for (0..tokens.items.len - 1) |j| {
            var token = tokens.items[j];
            const next_token = tokens.items[j + 1];
            if (next_token.kind == .INDENT) {
                indent += 1;
            }
            if (next_token.kind == .DEDENT) {
                indent -= 1;
            }
            std.debug.print("{s} ", .{token.repr()});
            if (token.kind == .NEWLINE or token.kind == .INDENT or token.kind == .DEDENT) {
                std.debug.print("\n", .{});
                for (0..indent) |_| {
                    std.debug.print("    ", .{});
                }
            }
        }
        std.debug.print("\n", .{});
    }

    // Parse
    try ast.init_structures();
    var parser = try Parser.create(&tokens, errors, allocator);
    const module_ast = try parser.parse();

    // Module/Symbol-Tree construction
    var file_root = try symbol.Scope.init(prelude, name, allocator);
    const module = try Module.init(uid, file_root, errors, allocator);
    file_root.module = module;
    try symbol.symbolTableFromASTList(module_ast, file_root, errors, allocator);

    // Typecheck
    try validate.validate_module(module, errors, allocator);
    if (errors.errors_list.items.len > 0) {
        return error.typeError;
    }

    return module;
}

/// Takes in a statically correct symbol tree, writes it out to a file
pub fn output(
    errors: *errs.Errors,
    module: *Module,
    out_name: []const u8,
    allocator: std.mem.Allocator,
) !ir.IRData {
    // try module.scope.pprint();
    if (module.scope.symbols.get("main")) |msymb| {
        if (msymb._type.?.* != .function or msymb.kind != ._fn) {
            errors.addError(errs.Error{ .basic = .{ .span = Span.Span{ .filename = "", .line_text = "", .line = 0, .col = 0 }, .msg = "entry point `main` is not a function" } });
            return error.symbolError;
        }
        // IR translation
        var irAllocator = std.heap.ArenaAllocator.init(allocator);
        defer irAllocator.deinit();
        const cfg = try msymb.get_cfg(null, &module.interned_strings, errors, allocator);
        try module.append_instructions(cfg);

        const interpret = true;
        if (interpret) {
            // Create a new allocator for interpretation
            var interpreter_allocator = std.heap.ArenaAllocator.init(allocator);
            defer interpreter_allocator.deinit();

            // Wrap main CFG in interpreter context
            // module.print_instructions();
            var context = try Context.init(cfg, &module.instructions, msymb._type.?.function.rhs.get_slots(), cfg.offset.?);
            return try context.interpret();
        } else {
            // Wrap main CFG in module
            try module_.collectTypes(cfg, &module.types, module.scope, errors, allocator);

            // Create the output file
            var outputFile = std.fs.cwd().createFile(
                out_name,
                .{ .read = false },
            ) catch |e| switch (e) {
                error.FileNotFound => {
                    std.debug.print("Cannot create file: {s}\n", .{out_name});
                    return e;
                },
                else => return e,
            };
            defer outputFile.close();

            // Generate the output code
            // try codegen.generate(module, &outputFile);
        }

        symbol.scopeUID = 0; // Reset scope UID. Doesn't affect one-off compilations really, but does for tests. Helps with version control.
    } else {
        errors.addError(errs.Error{ .basic = .{ .span = Span.Span{ .filename = "", .line_text = "", .line = 0, .col = 0 }, .msg = "no `main` function specified" } });
        return error.symbolError;
    }
}
