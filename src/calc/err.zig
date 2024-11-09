const std = @import("std");

pub const FunctionError = error{
    UnknownFunction,
    TooFewArgs,
    TooManyArgs,
    BadArg,
};
