const std = @import("std");
const tok = @import("../prep/tokens.zig");
const e = @import("err.zig");

const FuncDecl = struct {
    name: []u8,
    min_argc: u8,
    max_argc: u8,
    func: fn (params: []tok.Token) tok.Token,
};

const builtin_funcs: []FuncDecl = []FuncDecl{FuncDecl{ "sin", 1, 1, sin }};

fn get_func_decl(name: []u8) ?FuncDecl {
    for (builtin_funcs) |func| {
        if (func.name == name) {
            return func;
        }
    }
    return null;
}

pub fn is_builtin_func(name: []u8) bool {
    return get_func_decl(name) != null;
}

pub fn exec_builtin_func(name: []u8, args: []tok.Token) e.FunctionError!?tok.Token {
    const func = get_func_decl(name);

    if (func) |f| {
        if (f.min_argc > args.len) return e.FunctionError.TooFewArgs;
        if (f.max_argc < args.len) return e.FunctionError.TooFewArgs;

        return f.func(args);
    } else {
        return e.FunctionError.UnknownFunction;
    }
}

fn sin(params: []tok.Token) ?tok.Token {
    tok.printTokens(params);
    return null;
}
