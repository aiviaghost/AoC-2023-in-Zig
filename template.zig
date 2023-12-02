const std = @import("std");

const input = @embedFile("input.txt");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};

fn solve_1() !void {
    var lines = std.mem.tokenizeSequence(u8, input, "\n");
    _ = lines;
}

fn solve_2() !void {
    var lines = std.mem.tokenizeSequence(u8, input, "\n");
    _ = lines;
}

pub fn main() !void {
    try solve_1();
    try solve_2();
}
