const std = @import("std");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};

pub const allocator = gpa.allocator();

// pub fn allocator() std.mem.Allocator {
//     return alloc;
// }
