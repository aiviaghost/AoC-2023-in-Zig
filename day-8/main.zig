const std = @import("std");

const input = @embedFile("input.txt");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};

fn Pair(comptime t1: type, comptime t2: type) type {
    return struct { first: t1, second: t2 };
}

const String = []const u8;
const StringPair = Pair(String, String);

const map = std.StringHashMap(Pair(String, String));

fn solve_1() !void {
    var lines = std.mem.tokenizeSequence(u8, input, "\n");
    var seq = lines.next().?;
    var adj = map.init(gpa.allocator());
    defer adj.deinit();
    while (lines.next()) |line| {
        var nodes: [3]String = .{""} ** 3;
        var nexts = std.mem.splitAny(u8, line, "=, ()");
        var i: usize = 0;
        while (nexts.next()) |nx| {
            if (nx.len == 0) continue;
            nodes[i] = nx;
            i += 1;
        }
        try adj.put(nodes[0], StringPair{ .first = nodes[1], .second = nodes[2] });
    }

    var step_count: usize = 0;
    var curr: String = "AAA";
    while (!std.mem.eql(u8, curr, "ZZZ")) {
        var neighbours = adj.get(curr).?;
        if (seq[@mod(step_count, seq.len)] == 'L') {
            curr = neighbours.first;
        } else {
            curr = neighbours.second;
        }
        step_count += 1;
    }
    std.debug.print("Part 1: {}\n", .{step_count});
}

fn lcm(a: u64, b: u64) u64 {
    return (a / std.math.gcd(a, b)) * b;
}

fn solve_2() !void {
    var lines = std.mem.tokenizeSequence(u8, input, "\n");
    var seq = lines.next().?;
    var alloc = gpa.allocator();
    var adj = map.init(alloc);
    defer adj.deinit();
    var curr = std.ArrayList(String).init(alloc);
    defer curr.deinit();
    while (lines.next()) |line| {
        var nodes: [3]String = .{""} ** 3;
        var nexts = std.mem.splitAny(u8, line, "=, ()");
        var i: usize = 0;
        while (nexts.next()) |nx| {
            if (nx.len == 0) continue;
            nodes[i] = nx;
            i += 1;
        }
        try adj.put(nodes[0], StringPair{ .first = nodes[1], .second = nodes[2] });
        if (std.mem.endsWith(u8, nodes[0], "A")) {
            try curr.append(nodes[0]);
        }
    }

    var ans: u64 = 1;
    for (curr.items) |*c| {
        var step_count: u64 = 0;
        while (true) {
            var neighbours = adj.get(c.*).?;
            if (seq[@mod(step_count, seq.len)] == 'L') {
                c.* = neighbours.first;
            } else {
                c.* = neighbours.second;
            }
            step_count += 1;
            if (std.mem.endsWith(u8, c.*, "Z")) {
                ans = lcm(ans, step_count);
                break;
            }
        }
    }
    std.debug.print("Part 2: {}\n", .{ans});
}

pub fn main() !void {
    try solve_1();
    try solve_2();
}
