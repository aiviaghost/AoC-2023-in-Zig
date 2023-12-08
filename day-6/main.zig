const std = @import("std");

const input = @embedFile("input.txt");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};

const num_races = 4;

fn solve_1() !void {
    var lines = std.mem.tokenizeSequence(u8, input, "\n");
    var line_number: usize = 0;
    var table: [num_races][2]u32 = .{.{0} ** 2} ** num_races;
    while (lines.next()) |line| : (line_number += 1) {
        var skip = std.mem.indexOfScalar(u8, line, ':').? + 1;
        var rest = std.mem.splitScalar(u8, line[skip..], ' ');
        var t: usize = 0;
        while (rest.next()) |num| {
            if (num.len == 0) continue;
            var x = std.fmt.parseInt(u32, num, 10) catch 0;
            table[t][line_number] = x;
            t += 1;
        }
    }

    var ans: u32 = 1;
    for (0..num_races) |i| {
        var num_ways: u32 = 0;
        for (1..table[i][0]) |t| {
            if (t * (table[i][0] - t) > table[i][1]) {
                num_ways += 1;
            }
        }
        ans *= num_ways;
    }
    std.debug.print("Part 1: {}\n", .{ans});
}

fn solve_2() !void {
    var lines = std.mem.tokenizeSequence(u8, input, "\n");
    var line_number: usize = 0;
    var total_time: u64 = 0;
    var best_distance: u64 = 0;
    var allocator = gpa.allocator();
    while (lines.next()) |line| : (line_number += 1) {
        var skip = std.mem.indexOfScalar(u8, line, ':').? + 1;
        var x = try std.mem.replaceOwned(u8, allocator, line[skip..], " ", "_");
        x[0] = '0';
        var num = try std.fmt.parseInt(u64, x, 10);
        allocator.free(x);
        if (line_number == 0) {
            total_time = num;
        } else {
            best_distance = num;
        }
    }

    var num_ways: u32 = 0;
    for (1..total_time) |t| {
        if (t * (total_time - t) > best_distance) {
            num_ways += 1;
        }
    }
    std.debug.print("Part 2: {}\n", .{num_ways});
}

pub fn main() !void {
    try solve_1();
    try solve_2();
}
