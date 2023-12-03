const std = @import("std");

const input = @embedFile("input.txt");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};

fn solve_1() !void {
    var lines = std.mem.tokenizeSequence(u8, input, "\n");

    var ans: usize = 0;
    var id: usize = 1;
    while (lines.next()) |line| : (id += 1) {
        var skip: usize = 0;
        for (0.., line) |i, c| {
            if (c == ':') {
                skip = i + 2;
                break;
            }
        }

        var valid = true;

        var sets = std.mem.tokenizeSequence(u8, line[skip..], "; ");
        while (sets.next()) |set| {
            {
                var map = std.StringHashMap(u32).init(gpa.allocator());
                defer map.deinit();

                var cubes = std.mem.tokenizeSequence(u8, set, ", ");
                while (cubes.next()) |cube| {
                    var data = std.mem.tokenizeScalar(u8, cube, ' ');
                    var value = try std.fmt.parseInt(u32, data.next().?, 10);
                    var key = data.next().?;
                    try map.put(key, value);
                }
                valid = valid and (try map.getOrPutValue("red", 0)).value_ptr.* <= 12;
                valid = valid and (try map.getOrPutValue("green", 0)).value_ptr.* <= 13;
                valid = valid and (try map.getOrPutValue("blue", 0)).value_ptr.* <= 14;
            }
        }

        if (valid) {
            ans += id;
        }
    }

    std.debug.print("Part 1: {}\n", .{ans});
}

fn solve_2() !void {
    var lines = std.mem.tokenizeSequence(u8, input, "\n");

    var ans: u32 = 0;
    while (lines.next()) |line| {
        var skip: usize = 0;
        for (0.., line) |i, c| {
            if (c == ':') {
                skip = i + 2;
                break;
            }
        }

        {
            var counts = std.StringHashMap(u32).init(gpa.allocator());
            defer counts.deinit();

            var sets = std.mem.tokenizeSequence(u8, line[skip..], "; ");
            while (sets.next()) |set| {
                var cubes = std.mem.tokenizeSequence(u8, set, ", ");
                while (cubes.next()) |cube| {
                    var data = std.mem.tokenizeScalar(u8, cube, ' ');
                    var value = try std.fmt.parseInt(u32, data.next().?, 10);
                    var key = data.next().?;

                    var prev_val = (try counts.getOrPutValue(key, 0)).value_ptr.*;
                    try counts.put(key, @max(prev_val, value));
                }
            }

            ans += counts.get("red").? * counts.get("green").? * counts.get("blue").?;
        }
    }

    std.debug.print("Part 2: {}\n", .{ans});
}

pub fn main() !void {
    try solve_1();
    try solve_2();
}
