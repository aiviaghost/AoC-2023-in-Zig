const std = @import("std");

const input = @embedFile("input.txt");
const width = 140;
const height = 140;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};

fn is_digit(c: u8) bool {
    return switch (c) {
        '0'...'9' => true,
        else => false,
    };
}

fn is_symbol(c: u8) bool {
    return !is_digit(c) and c != '.';
}

fn solve_1() !void {
    var lines = std.mem.tokenizeSequence(u8, input, "\n");
    var grid: [height][width]u8 = .{.{0} ** width} ** height;
    var y: usize = 0;
    while (lines.next()) |line| : (y += 1) {
        for (0.., line) |x, c| {
            grid[y][x] = c;
        }
    }

    var ans: u32 = 0;

    for (0..height) |row| {
        var prev_pos: usize = 0;
        while (std.mem.indexOfAnyPos(u8, &grid[row], prev_pos, "0123456789")) |number_start| {
            var number_end: usize = (std.mem.indexOfNonePos(u8, &grid[row], number_start, "0123456789") orelse width) - 1;

            var valid = false;

            var col = if (number_start > 0) number_start - 1 else number_start;
            var end = if (number_end < width - 1) number_end + 1 else number_end;

            while (col <= end) : (col += 1) {
                valid = valid or is_symbol(grid[row][col]);
                if (row > 0) {
                    valid = valid or is_symbol(grid[row - 1][col]);
                }
                if (row < height - 1) {
                    valid = valid or is_symbol(grid[row + 1][col]);
                }
            }

            if (valid) {
                ans += std.fmt.parseInt(u32, grid[row][number_start .. number_end + 1], 10) catch 0;
            }

            prev_pos = number_end + 1;
        }
    }

    @compileLog(std.fmt.comptimePrint("Part 1: {}\n", .{ans}));
}

fn solve_2() !void {
    var lines = std.mem.tokenizeSequence(u8, input, "\n");
    var grid: [height][width]u8 = .{.{0} ** width} ** height;
    var y: usize = 0;
    while (lines.next()) |line| : (y += 1) {
        for (0.., line) |x, c| {
            grid[y][x] = c;
        }
    }

    var counts: [height][width]u8 = .{.{0} ** width} ** height;
    var ratios: [height][width]u32 = .{.{1} ** width} ** height;

    for (0..height) |row| {
        var prev_pos: usize = 0;
        while (std.mem.indexOfAnyPos(u8, &grid[row], prev_pos, "0123456789")) |number_start| {
            var number_end: usize = (std.mem.indexOfNonePos(u8, &grid[row], number_start, "0123456789") orelse width) - 1;

            var num: u32 = std.fmt.parseInt(u32, grid[row][number_start .. number_end + 1], 10) catch 0;

            var col = if (number_start > 0) number_start - 1 else number_start;
            var end = if (number_end < width - 1) number_end + 1 else number_end;

            while (col <= end) : (col += 1) {
                if (grid[row][col] == '*') {
                    counts[row][col] += 1;
                    ratios[row][col] *= num;
                }
                if (row > 0 and grid[row - 1][col] == '*') {
                    counts[row - 1][col] += 1;
                    ratios[row - 1][col] *= num;
                }
                if (row < height - 1 and grid[row + 1][col] == '*') {
                    counts[row + 1][col] += 1;
                    ratios[row + 1][col] *= num;
                }
            }

            prev_pos = number_end + 1;
        }
    }

    var ans: u32 = 0;
    for (counts, ratios) |r1, r2| {
        for (r1, r2) |count, ratio| {
            if (count == 2) {
                ans += ratio;
            }
        }
    }

    @compileLog(std.fmt.comptimePrint("Part 2: {}\n", .{ans}));
}

pub fn main() !void {
    comptime {
        @setEvalBranchQuota(1000000);
        try solve_1();
    }
    comptime {
        @setEvalBranchQuota(1000000);
        try solve_2();
    }
}
