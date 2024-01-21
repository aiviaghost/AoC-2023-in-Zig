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
const indexOfScalarPos = std.mem.indexOfScalarPos;
const indexOfAny = std.mem.indexOfAny;

const parseInt = std.fmt.parseInt;

const print = std.debug.print;

fn produces_valid_sequence(fixed: String, target_lens: []u8) !bool {
    var lens = ArrayList(u8).init(gpa);
    defer lens.deinit();

    var i: usize = 0;
    while (i < fixed.len) : (i += 1) {
        if (fixed[i] == '#') {
            var end = indexOfScalarPos(u8, fixed, i, '.') orelse fixed.len;
            try lens.append(@intCast(end - i));
            i = end;
        }
    }

    if (lens.items.len != target_lens.len) {
        return false;
    }
    for (lens.items, target_lens) |l1, l2| {
        if (l1 != l2) {
            return false;
        }
    }

    return true;
}

fn solve_1() !void {
    var lines = std.mem.tokenizeSequence(u8, input, "\n");
    var ans: u64 = 0;
    while (lines.next()) |line| {
        var temp = splitScalar(u8, line, ' ');
        var seq = temp.next().?;
        temp = splitScalar(u8, temp.next().?, ',');
        var seq_lens = ArrayList(u8).init(gpa);
        while (temp.next()) |i| {
            try seq_lens.append(try parseInt(u8, i, 10));
        }

        var qs = ArrayList(usize).init(gpa);
        for (0.., seq) |i, c| {
            if (c == '?') {
                try qs.append(i);
            }
        }

        var n = qs.items.len;
        var fixed = try gpa.alloc(u8, seq.len);
        @memcpy(fixed, seq);
        for (0..std.math.pow(u64, 2, n)) |mask| {
            for (0.., qs.items) |i, j| {
                var shift_amount: u6 = @intCast(i);
                var one: u64 = 1;
                fixed[j] = if ((mask & (one << shift_amount)) > 0) '#' else '.';
            }
            if (try produces_valid_sequence(fixed, seq_lens.items)) {
                ans += 1;
            }
        }

        seq_lens.deinit();
        qs.deinit();
        gpa.free(fixed);
    }
    print("Part 1: {}\n", .{ans});
}

fn solve_2() !void {}

pub fn main() !void {
    try solve_1();
    try solve_2();
}
