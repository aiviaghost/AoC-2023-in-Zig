const std = @import("std");

const input = @embedFile("input.txt");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};

fn is_digit(c: u8) bool {
    return switch (c) {
        '0'...'9' => true,
        else => false,
    };
}

fn solve_1() !void {
    var lines = std.mem.tokenizeSequence(u8, input, "\n");
    var ans: i32 = 0;
    while (lines.next()) |line| {
        var digits: [2]u8 = .{0} ** 2;
        var i: usize = 0;
        var c = false;
        while (i < line.len) : (i += 1) {
            if (!c and is_digit(line[i])) {
                digits[0] = line[i];
                c = !c;
            }
        }
        i -= 1;
        while (i >= 0) : (i -= 1) {
            if (c and is_digit(line[i])) {
                digits[1] = line[i];
                c = !c;
                break;
            }
        }
        ans += try std.fmt.parseInt(i32, &digits, 10);
    }
    std.debug.print("Part 1: {}\n", .{ans});
}

fn solve_2() !void {
    var patterns = [_][]const u8{ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };
    var replacements = [_][]const u8{ "one1one", "two2two", "three3three", "four4four", "five5five", "six6six", "seven7seven", "eight8eight", "nine9nine" };

    const allocator = gpa.allocator();

    var data = try allocator.alloc(u8, input.len);
    defer allocator.free(data);

    std.mem.copy(u8, data, input);
    for (patterns, replacements) |pattern, replacement| {
        var new_size = std.mem.replacementSize(u8, data, pattern, replacement);
        var new_data = try allocator.alloc(u8, new_size);
        _ = std.mem.replace(u8, data, pattern, replacement, new_data);
        data = try allocator.alloc(u8, new_size);
        std.mem.copy(u8, data, new_data);
        allocator.free(new_data);
    }

    var lines = std.mem.tokenizeSequence(u8, data, "\n");
    var ans: i32 = 0;
    while (lines.next()) |line| {
        var digits: [2]u8 = .{0} ** 2;
        var i: usize = 0;
        var c = false;
        while (i < line.len) : (i += 1) {
            if (!c and is_digit(line[i])) {
                digits[0] = line[i];
                c = !c;
            }
        }
        i -= 1;
        while (i >= 0) : (i -= 1) {
            if (c and is_digit(line[i])) {
                digits[1] = line[i];
                c = !c;
                break;
            }
        }
        ans += try std.fmt.parseInt(i32, &digits, 10);
    }
    std.debug.print("Part 2: {}\n", .{ans});
}

pub fn main() !void {
    try solve_1();
    try solve_2();
}
