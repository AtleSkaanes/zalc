const std = @import("std");
const tok = @import("prep/tokens.zig");
const pf = @import("calc/postfix.zig");
const g = @import("global.zig");
const eval = @import("calc/evaluate.zig");
const parse = @import("prep/parse.zig");

pub fn main() !void {
    const args = try parse.get_args();
    defer args.deinit();

    // std.debug.print("Args:\n{s}\n", .{args.items});

    var tokens = try parse.parse_expression(args.items);
    defer tokens.deinit();

    // var tokens = std.ArrayList(tok.Token).init(g.allocator);
    //
    // var token_items = [_]tok.Token{ tok.Token{ .num = 2.0 }, tok.Token{ .op = tok.Operator.plus }, tok.Token{ .num = 4.0 } };
    // try tokens.appendSlice(&token_items);

    // std.debug.print("Infix:\n", .{});
    // try tok.printTokens(tokens);

    const postfix = try pf.convert_to_postfix(tokens.items);
    defer postfix.deinit();

    // std.debug.print("Postfix:\n", .{});
    // try tok.printTokens(postfix);

    const result = try eval.evaluate_tokens(postfix);
    std.debug.print("Result:\n", .{});
    try tok.printTokens(result);
}
