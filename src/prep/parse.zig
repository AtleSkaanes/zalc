const std = @import("std");
const tok = @import("../prep/tokens.zig");
const g = @import("../global.zig");

pub fn get_args() !std.ArrayList(u8) {
    var args = try std.process.argsWithAllocator(g.allocator);
    defer args.deinit();

    var str = std.ArrayList(u8).init(g.allocator);

    _ = args.skip();
    while (args.next()) |arg| {
        try str.appendSlice(arg);
        try str.append(' ');
    }

    return str;
}

pub fn parse_expression(expr: []u8) !std.ArrayList(tok.Token) {
    var numberBuf = std.ArrayList(u8).init(g.allocator);

    var tokens = std.ArrayList(tok.Token).init(g.allocator);

    for (expr) |char| {
        // Number
        if (char >= '0' and char <= '9' or char == '.') {
            try numberBuf.append(char);
            continue;
        }

        // Operator
        if (tok.Operator.fromChar(char)) |op| {
            if (numberBuf.items.len > 0) {
                const num = std.fmt.parseFloat(f64, numberBuf.items) catch std.math.nan(f64);
                try tokens.append(tok.Token{ .num = num });
                numberBuf.clearAndFree();
            } else if (op == tok.Operator.minus) {
                try numberBuf.append('-');
                continue;
            }

            try tokens.append(tok.Token{ .op = op });
        }
    }

    if (numberBuf.items.len > 0) {
        const num = std.fmt.parseFloat(f64, numberBuf.items) catch std.math.nan(f64);
        try tokens.append(tok.Token{ .num = num });
        numberBuf.clearAndFree();
    }

    return tokens;
}
