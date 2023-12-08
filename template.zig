const std = @import("std");

const input = @embedFile("input.txt");

const INF: u64 = std.math.maxInt(u64);

var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = gpa_impl.allocator();

const ArrayList = std.ArrayList;
const Map = std.AutoHashMap;
const StringMap = std.StringHashMap;
const String = []const u8;

const eql = std.mem.eql;

const tokenizeAny = std.mem.tokenizeAny;
const tokenizeSequence = std.mem.tokenizeSequence;
const tokenizeScalar = std.mem.tokenizeScalar;

const splitAny = std.mem.splitAny;
const splitScalar = std.mem.splitScalar;
const splitSequence = std.mem.splitSequence;

const indexOfScalar = std.mem.indexOfScalar;
const indexOfAny = std.mem.indexOfAny;

const parseInt = std.fmt.parseInt;

const print = std.debug.print;



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
