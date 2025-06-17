const std = @import("std");

pub fn run(allocator: std.mem.Allocator, args: [][]u8) !void {
    _ = allocator;
    _ = args;
    try std.io.getStdOut().writer().print("make:model command (TODO)\n", .{});
}
