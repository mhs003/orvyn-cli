const std = @import("std");
const utils = @import("../utils.zig");

pub fn run(allocator: std.mem.Allocator, args: [][]u8) !void {
    var name: []u8 = undefined;
    if (args.len == 2) {
        const input = try utils.prompt(allocator, "Controller name");
        if (input == null) return error.InvalidInput;
        name = input.?;
    } else {
        name = args[2];
    }

    // const path = try std.fs.path.join(allocator, &[_][]const u8{ "App", "Controllers", name ++ ".php" });

    const filename = try std.mem.concat(allocator, u8, &[_][]const u8{ name, ".php" });
    defer allocator.free(filename);

    const path = try std.fs.path.join(allocator, &[_][]const u8{ "App", "Controllers", filename });

    if (std.fs.cwd().statFile(path)) |_| {
        try utils.print_err("Controller already exists: {s}\n", .{path});
        return;
    } else |_| {}

    const content = try utils.sprintf(allocator,
        \\<?php
        \\
        \\namespace App\Controllers;
        \\
        \\use Core\Request\Request;
        \\
        \\class {s} {{
        \\    //
        \\}}
        \\
    , .{name});
    defer allocator.free(content);

    try utils.writeFile(path, content);

    try utils.print("✅ Controller created: {s}\n", .{path});
}
