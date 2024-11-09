const std = @import("std");
const g = @import("../global.zig");

pub const Token = union(enum) {
    num: f64,
    op: Operator,
    // ident: struct {
    //     value_type: ?enum { variable, function },
    //     name: []u8,
    // },

    pub fn toString(self: Token) !std.ArrayList(u8) {
        switch (self) {
            .num => |*n| {
                var list = std.ArrayList(u8).init(g.allocator);

                var buf: [256]u8 = undefined;
                const message = try std.fmt.bufPrint(&buf, "{d}", .{n.*});

                try list.appendSlice(message);

                return list;
            },
            .op => |*o| {
                var list = std.ArrayList(u8).init(g.allocator);
                try list.append(o.getChar());
                return list;
            },
            // .ident => |*s| {
            //     var list = std.ArrayList(u8).init(g.allocator);
            //
            //     try list.appendSlice(s.*.name);
            //
            //     return list;
            // },
        }
    }
};

pub const Operator = enum(u8) {
    plus = '+',
    minus = '-',

    times = '*',
    divide = '/',
    mod = '%',
    pow = '^',

    lbracket = '(',
    rbracket = ')',

    pub fn getPrecedense(self: Operator) u8 {
        return switch (self) {
            Operator.plus, Operator.minus => 0,
            Operator.times, Operator.divide, Operator.mod => 1,
            Operator.lbracket, Operator.rbracket, Operator.pow => 2,
        };
    }

    pub fn getChar(self: Operator) u8 {
        return switch (self) {
            .plus => '+',
            .minus => '-',

            .times => '*',
            .divide => '/',
            .mod => '%',
            .pow => '^',

            .lbracket => '(',
            .rbracket => ')',
        };
    }

    pub fn fromChar(char: u8) ?Operator {
        return switch (char) {
            '+' => .plus,
            '-' => .minus,

            '*' => .times,
            '/' => .divide,
            '%' => .mod,
            '^' => .pow,

            '(' => .lbracket,
            ')' => .rbracket,
            else => null,
        };
    }
};

pub fn printTokens(tokens: std.ArrayList(Token)) !void {
    for (tokens.items) |token| {
        const str = try token.toString();
        std.debug.print("{s} ", .{str.items});
        // defer str.deinit();
    }
    std.debug.print("\n", .{});
}
