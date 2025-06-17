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
