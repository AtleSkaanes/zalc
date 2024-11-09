const std = @import("std");
const g = @import("../global.zig");
const builtin = @import("builtin.zig");

const ArrayList = std.ArrayList;

const tok = @import("../prep/tokens.zig");

pub fn convert_to_postfix(tokens: []tok.Token) !std.ArrayList(tok.Token) {
    var queue = ArrayList(tok.Token).init(g.allocator);
    defer queue.deinit();

    var postfix = ArrayList(tok.Token).init(g.allocator);

    var depth: usize = 0;

    for (tokens) |token| {
        switch (token) {
            .num => {
                try postfix.append(token);
            },
            .op => |*o| {
                if (o.* == tok.Operator.lbracket) {
                    depth += 2;
                    continue;
                }

                if (o.* == tok.Operator.rbracket) {
                    depth -= 2;
                    continue;
                }

                const realDepth = depth + o.*.getPrecedense();
                if (queue.items.len > realDepth) {
                    try drain(&queue, &postfix, realDepth);
                }

                try queue.append(token);
            },
            // .ident => |*i| {
            //     if (builtin.is_builtin_func(i.name)) {}
            // },
        }
    }

    if (queue.items.len >= 1) {
        try drain(&queue, &postfix, 0);
    }

    return postfix;
}

fn add(source: *std.ArrayList(tok.Token), token: tok.Token, depth: usize) !void {
    try source.resize(depth);

    source.insert(depth, token);
}

fn drain(source: *std.ArrayList(tok.Token), target: *std.ArrayList(tok.Token), depth: usize) !void {
    const diff = source.items.len - depth;
    for (0..diff) |_| {
        const popped = source.popOrNull();
        if (popped) |p| {
            try target.append(p);
        }
    }
}

// 1 + 3 * 2
// 1 3 2 * +
// ------------------------
//             3 |
//             2 |
//             1 | *
//             0 | +
//
//
