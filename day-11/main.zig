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

const Galaxy = struct { x: usize, y: usize };

fn free_string_array(rows: []String) void {
    for (rows) |row| {
        gpa.free(row);
    }
    gpa.free(rows);
}

fn manhattan_dist(x1: i64, y1: i64, x2: i64, y2: i64) u64 {
    return std.math.absCast(x1 - x2) + std.math.absCast(y1 - y2);
}

// caller is responsible for freeing memory
fn transpose(comptime T: type, grid: ArrayList(T)) ![]T {
    var n: usize = grid.getLast().len;
    var m: usize = grid.items.len;
    var transposed_grid = try gpa.alloc([]u8, n);
    for (0..n) |i| {
        transposed_grid[i] = try gpa.alloc(u8, m);
    }
    for (0..n) |i| {
        for (0..m) |j| {
            transposed_grid[i][j] = grid.items[j][i];
        }
    }
    return transposed_grid;
}

fn solve_1() !void {
    var lines = std.mem.tokenizeSequence(u8, input, "\n");
    var new_rows = ArrayList(String).init(gpa);
    defer new_rows.deinit();
    while (lines.next()) |line| {
        if (indexOfScalar(u8, line, '#')) |_| {
            try new_rows.append(line);
        } else {
            try new_rows.append(line);
            try new_rows.append(line);
        }
    }

    var transposed_grid = try transpose([]const u8, new_rows);
    defer free_string_array(transposed_grid);

    var grid = ArrayList(String).init(gpa);
    defer grid.deinit();
    for (transposed_grid) |line| {
        if (indexOfScalar(u8, line, '#')) |_| {
            try grid.append(line);
        } else {
            try grid.append(line);
            try grid.append(line);
        }
    }

    var n = grid.items.len;
    var m = grid.getLast().len;
    var galaxies = ArrayList(Galaxy).init(gpa);
    defer galaxies.deinit();
    for (0..n) |i| {
        for (0..m) |j| {
            if (grid.items[i][j] == '#') {
                try galaxies.append(Galaxy{ .x = j, .y = i });
            }
        }
    }

    var ans: u64 = 0;
    for (galaxies.items) |g1| {
        for (galaxies.items) |g2| {
            ans += manhattan_dist(@intCast(g1.x), @intCast(g1.y), @intCast(g2.x), @intCast(g2.y));
        }
    }
    print("Part 1: {}\n", .{ans / 2});
}

fn solve_2() !void {
    var lines = std.mem.tokenizeSequence(u8, input, "\n");
    var new_rows = ArrayList(String).init(gpa);
    defer new_rows.deinit();
    var row_data = ArrayList(u64).init(gpa);
    defer row_data.deinit();
    while (lines.next()) |line| {
        try new_rows.append(line);
        if (indexOfScalar(u8, line, '#')) |_| {
            try row_data.append(0);
        } else {
            try row_data.append(1);
        }
    }

    var transposed_grid = try transpose([]const u8, new_rows);
    defer free_string_array(transposed_grid);

    var grid = ArrayList(String).init(gpa);
    defer grid.deinit();
    var column_data = ArrayList(u64).init(gpa);
    defer column_data.deinit();
    for (transposed_grid) |line| {
        try grid.append(line);
        if (indexOfScalar(u8, line, '#')) |_| {
            try column_data.append(0);
        } else {
            try column_data.append(1);
        }
    }

    var n = grid.items.len;
    var m = grid.getLast().len;
    var galaxies = ArrayList(Galaxy).init(gpa);
    defer galaxies.deinit();
    for (0..n) |i| {
        for (0..m) |j| {
            if (grid.items[i][j] == '#') {
                try galaxies.append(Galaxy{ .x = i, .y = j });
            }
        }
    }

    const bonus: u64 = 999999;

    var ans: u64 = 0;
    for (galaxies.items) |g1| {
        for (galaxies.items) |g2| {
            var row_expands: u64 = 0;
            for (@min(g1.x, g2.x)..@max(g1.x, g2.x)) |i| {
                row_expands += column_data.items[i];
            }
            var column_expands: u64 = 0;
            for (@min(g1.y, g2.y)..@max(g1.y, g2.y)) |i| {
                column_expands += row_data.items[i];
            }
            ans += (row_expands + column_expands) * bonus;
            ans += manhattan_dist(@intCast(g1.x), @intCast(g1.y), @intCast(g2.x), @intCast(g2.y));
        }
    }
    print("Part 2: {}\n", .{ans / 2});
}

pub fn main() !void {
    try solve_1();
    try solve_2();
}
