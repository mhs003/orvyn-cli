const std = @import("std");
const utils = @import("../utils.zig");

pub fn run(allocator: std.mem.Allocator, args: [][]u8) !void {
    const stdout = std.io.getStdOut().writer();
    var target_dir: []u8 = undefined;

    if (args.len == 2) {
        const input = try utils.prompt(allocator, "Project name (or . for current)");
        if (input == null) return error.InvalidInput;
        target_dir = input.?;
    } else {
        target_dir = args[2];
    }

    if (!std.mem.eql(u8, target_dir, ".")) {
        try std.fs.cwd().makeDir(target_dir);
        try std.process.changeCurDir(target_dir);
    }

    const repo = "https://github.com/mhs003/orvyn-mvc";
    const cmd = &[_][]const u8{ "git", "clone", repo, "." };

    var proc = std.process.Child.init(cmd, allocator);
    _ = try proc.spawnAndWait();

    try stdout.print("✅ Project initialized in {s}\n", .{target_dir});
}
