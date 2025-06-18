const std = @import("std");

pub fn prompt(allocator: std.mem.Allocator, label: []const u8) !?[]u8 {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("{s}: ", .{label});

    var reader = std.io.getStdIn().reader();
    return reader.readUntilDelimiterOrEofAlloc(allocator, '\n', 1024);
}

pub fn writeFile(path: []const u8, content: []const u8) !void {
    const file = try std.fs.cwd().createFile(path, .{ .exclusive = true });
    defer file.close();
    try file.writeAll(content);
}

pub fn print(comptime fmt: []const u8, args: anytype) !void {
    try std.io.getStdOut().writer().print(fmt, args);
}

pub fn print_err(comptime fmt: []const u8, args: anytype) !void {
    try std.io.getStdErr().writer().print(fmt, args);
}

pub fn print_panic(comptime fmt: []const u8, args: anytype) void {
    std.io.getStdErr().writer().print(fmt, args) catch @panic("print_panic failed");
}

pub fn print_debug(comptime fmt: []const u8, args: anytype) void {
    std.debug().print(fmt, args);
}

pub fn sprintf(allocator: std.mem.Allocator, comptime fmt: []const u8, args: anytype) ![]u8 {
    return std.fmt.allocPrint(allocator, fmt, args);
}
