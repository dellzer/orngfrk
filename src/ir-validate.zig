// This file validates a CFG of IR. It checks for things like unused symbols, symbols marked `mut` that are never mutated, etc.

const std = @import("std");
const cfg_ = @import("cfg.zig");
const errs_ = @import("errors.zig");
const ir_ = @import("ir.zig");
const primitives_ = @import("primitives.zig");
const symbol_ = @import("symbol.zig");

pub fn validate_cfg(cfg: *cfg_.CFG, errors: *errs_.Errors) error{IRError}!void {
    cfg.calculate_usage();
    cfg.calculate_versions();
    if (cfg.symbol.decl.?.* == .fn_decl) {
        for (cfg.symbol.decl.?.fn_decl.param_symbols.items) |param_symbol| {
            try err_if_unused(param_symbol, errors);
            try err_if_var_not_mutated(param_symbol, errors);
        }
    }

    for (cfg.basic_blocks.items) |bb| {
        var maybe_ir: ?*ir_.IR = bb.ir_head;
        while (maybe_ir) |ir| : (maybe_ir = ir.next) {
            if (ir.dest != null and // has a dest symbol to test
                !ir.removed and // isn't removed
                ir.dest.?.* == .symbver and // dest is symbver
                !ir.dest.?.symbver.symbol.is_temp and // dest symbver's symbol isn't temporary
                ir.dest.?.symbver.symbol != cfg.return_symbol // dest symbver's symbol isn't the function's return value
            ) {
                try err_if_unused(ir.dest.?.symbver.symbol, errors);
                try err_if_var_not_mutated(ir.dest.?.symbver.symbol, errors);
            }
        }
    }
}

/// Throws `error.IRError` if a symbol is not used
fn err_if_unused(symbol: *symbol_.Symbol, errors: *errs_.Errors) error{IRError}!void {
    if (symbol.kind != .@"const" and
        symbol.uses == 0)
    {
        errors.add_error(errs_.Error{ .symbol_error = .{
            .span = symbol.span,
            .context_span = null,
            .name = symbol.name,
            .problem = "is never used",
            .context_message = "",
        } });
        return error.IRError;
    }
}

fn err_if_var_not_mutated(symbol: *symbol_.Symbol, errors: *errs_.Errors) error{IRError}!void {
    const unmutated_versions: usize = if (symbol.param) 0 else 1;
    if (symbol.kind == .mut and
        symbol.versions <= unmutated_versions and
        symbol.aliases == 0 and
        symbol.roots == 0)
    {
        errors.add_error(errs_.Error{ .symbol_error = .{
            .span = symbol.span,
            .context_span = null,
            .name = symbol.name,
            .problem = "is marked `mut` but is never mutated",
            .context_message = "",
        } });
        return error.IRError;
    }
}
