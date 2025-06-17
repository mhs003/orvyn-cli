const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const allocator = std.heap.page_allocator;

    const raw_args = try std.process.argsAlloc(allocator);
    var args = try allocator.alloc([]u8, raw_args.len);

    for (raw_args, 0..) |arg, i| {
        args[i] = arg;
    }

    if (args.len < 2) {
        try stdout.print("Usage: orvyn <command> [options]\n", .{});
        return;
    }

    const command = args[1];

    const is_init = std.mem.eql(u8, command, "init");

    const orvynJsonFile = std.fs.cwd().openFile("orvyn.json", .{ .mode = .read_only });
    if (!is_init) {
        if (orvynJsonFile) |file| {
            file.close();
        } else |err| {
            if (err == error.FileNotFound) {
                try stdout.print("❌ Not an Orvyn project: `orvyn.json` not found in current directory.\n", .{});
                return;
            } else {
                return err;
            }
        }
    } else {
        if (orvynJsonFile) |file| {
            try stdout.print("❌ An Orvyn project is already initialized in this directory.\n", .{});
            file.close();
            return;
        } else |_| {}
    }

    if (std.mem.eql(u8, command, "init")) {
        try @import("commands/init.zig").run(allocator, args);
    } else if (std.mem.eql(u8, command, "make:controller")) {
        try @import("commands/make_controller.zig").run(allocator, args);
    } else if (std.mem.eql(u8, command, "make:middleware")) {
        try @import("commands/make_middleware.zig").run(allocator, args);
    } else if (std.mem.eql(u8, command, "make:model")) {
        try @import("commands/make_model.zig").run(allocator, args);
    } else if (std.mem.eql(u8, command, "make:migration")) {
        try @import("commands/make_migration.zig").run(allocator, args);
    } else if (std.mem.eql(u8, command, "migrate")) {
        try @import("commands/migrate.zig").run(allocator, args);
    } else if (std.mem.eql(u8, command, "migrate:rollback")) {
        try @import("commands/rollback.zig").run(allocator, args);
    } else {
        try stdout.print("Unknown command: {s}\n", .{command});
    }
}
