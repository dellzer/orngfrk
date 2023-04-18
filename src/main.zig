const std = @import("std");
const errs = @import("errors.zig");
const layout = @import("layout.zig");
const lexer = @import("lexer.zig");
const Parser = @import("parser.zig").Parser;
const symbol = @import("symbol.zig");
const Token = @import("token.zig").Token;

pub const PRINT_TOKENS = true;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    var errors = errs.Errors.init(allocator);
    defer errors.deinit();

    // Get second command line argument
    var args = try std.process.ArgIterator.initWithAllocator(allocator);
    _ = args.next() orelse unreachable;
    var arg = args.next() orelse {
        std.debug.print("{s}\n", .{"Usage: zig build run -- <markdown-filename>"});
        return;
    };

    // Get the path
    var path_buffer: [std.fs.MAX_PATH_BYTES]u8 = undefined;
    const path: []u8 = try std.fs.realpath(arg, &path_buffer);

    // Open the file
    var file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    // Read in the contents of the file
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var contents_arraylist = std.ArrayList(u8).init(allocator);
    try in_stream.readAllArrayList(&contents_arraylist, 0xFFFF_FFFF);
    var contents = try contents_arraylist.toOwnedSlice();

    // Tokenize
    var tokenAllocator = std.heap.ArenaAllocator.init(allocator);
    defer tokenAllocator.deinit();
    var tokens = lexer.getTokens(contents, &errors, tokenAllocator.allocator()) catch {
        errors.printErrors();
        return;
    };
    defer tokens.deinit();

    // Layout
    layout.preemptBinaryOperator(&tokens);
    try layout.insertIndentDedents(&tokens);
    layout.condenseNewLines(&tokens);
    if (PRINT_TOKENS) {
        for (tokens.items) |*token| {
            token.pprint();
        }
    }

    // Parse
    var astAllocator = std.heap.ArenaAllocator.init(allocator);
    defer astAllocator.deinit();
    var parser = try Parser.create(tokens, &errors, astAllocator.allocator());
    var program_ast = parser.parse() catch {
        errors.printErrors();
        return;
    };

    // Symbol tree construction
    var symbolAllocator = std.heap.ArenaAllocator.init(allocator);
    defer symbolAllocator.deinit();
    var fileRoot = try symbol.Scope.init(null, symbolAllocator.allocator());
    var symbol_table = symbol.createScope(program_ast, fileRoot, &errors, symbolAllocator.allocator()) catch {
        errors.printErrors();
        return;
    };
    symbol_table.pprint();
}
