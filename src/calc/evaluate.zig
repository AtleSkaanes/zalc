const std = @import("std");
const tok = @import("../prep/tokens.zig");
const g = @import("../global.zig");

pub fn evaluate_tokens(tokens: std.ArrayList(tok.Token)) !std.ArrayList(tok.Token) {
    // var result_list = std.ArrayList(tok.Token).init(g.allocator);

    var stack = std.ArrayList(tok.Token).init(g.allocator);
    // defer stack.deinit();

    for (tokens.items) |token| {
        switch (token) {
            .num => |*n| {
                try stack.append(tok.Token{ .num = n.* });
            },
            .op => |*o| {
                // const rhs = if (stack.pop().num) |n| n else std.math.nan(f32);
                // const lhs = if (stack.pop().num) |n| n else std.math.nan(f32);

                const rhs = stack.pop().num;
                const lhs = stack.pop().num;

                const res = switch (o.*) {
                    .plus => lhs + rhs,
                    .minus => lhs - rhs,
                    .times => lhs * rhs,
                    .divide => lhs / rhs,
                    .mod => @mod(lhs, rhs),
                    .pow => std.math.pow(f64, lhs, rhs),
                    else => std.math.nan(f64),
                };
                try stack.append(tok.Token{ .num = res });
            },
        }
    }

    return stack;
}

//  2 + sin(5 * 4)
//
//  2 5 4 * sin +
//  --------------------
//              |
//              |
//              |
//              |

//  sin(5 * 4) + 2
//
//  5 4 * sin 2 +
//  --------------------
//              |
//              |
//              |
//              |
