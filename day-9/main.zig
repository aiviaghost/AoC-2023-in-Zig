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
    var ans: i64 = 0;
    while (lines.next()) |line| {
        var seq = ArrayList(i64).init(gpa);
        var nums = splitScalar(u8, line, ' ');
        while (nums.next()) |num| {
            try seq.append(try parseInt(i64, num, 10));
        }

        var last_nums = ArrayList(i64).init(gpa);

        while (true) {
            try last_nums.append(seq.getLast());

            var next_seq = ArrayList(i64).init(gpa);

            var diffs = std.mem.window(i64, seq.items, 2, 1);
            while (diffs.next()) |w| {
                try next_seq.append(w[1] - w[0]);
            }

            var stop = true;
            for (next_seq.items) |i| {
                stop = stop and i == 0;
            }
            if (stop) {
                break;
            }

            seq.clearRetainingCapacity();
            for (next_seq.items) |i| {
                try seq.append(i);
            }

            next_seq.deinit();
        }

        var curr: i64 = 0;
        var i: usize = last_nums.items.len - 1;
        while (true) {
            curr = last_nums.items[i] + curr;

            if (i == 0) {
                break;
            }
            i -= 1;
        }

        ans += curr;

        seq.deinit();
        last_nums.deinit();
    }
    print("Part 1: {}\n", .{ans});
}

fn solve_2() !void {
    var lines = std.mem.tokenizeSequence(u8, input, "\n");
    var ans: i64 = 0;
    while (lines.next()) |line| {
        var seq = ArrayList(i64).init(gpa);
        var nums = splitScalar(u8, line, ' ');
        while (nums.next()) |num| {
            try seq.append(try parseInt(i64, num, 10));
        }

        var first_nums = ArrayList(i64).init(gpa);

        while (true) {
            var next_seq = ArrayList(i64).init(gpa);

            var push = true;
            var diffs = std.mem.window(i64, seq.items, 2, 1);
            while (diffs.next()) |w| {
                if (push) {
                    try first_nums.append(w[0]);
                    push = false;
                }
                try next_seq.append(w[1] - w[0]);
            }

            var stop = true;
            for (next_seq.items) |i| {
                stop = stop and i == 0;
            }
            if (stop) {
                break;
            }

            seq.clearRetainingCapacity();
            for (next_seq.items) |i| {
                try seq.append(i);
            }

            next_seq.deinit();
        }

        var curr: i64 = 0;
        var i: usize = first_nums.items.len - 1;
        while (true) {
            curr = first_nums.items[i] - curr;

            if (i == 0) {
                break;
            }
            i -= 1;
        }

        ans += curr;

        seq.deinit();
        first_nums.deinit();
    }
    print("Part 2: {}\n", .{ans});
}

pub fn main() !void {
    try solve_1();
    try solve_2();
}
