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

const W = 140;
const H = 140;

const Pos = struct { x: usize, y: usize };

fn solve_1() !void {
    var lines = std.mem.tokenizeSequence(u8, input, "\n");
    var grid: [H][W]u8 = .{.{0} ** W} ** H;
    var line_nbr: usize = 0;
    var sx: usize = 0;
    var sy: usize = 0;

    while (lines.next()) |line| : (line_nbr += 1) {
        for (0.., line) |col, c| {
            grid[line_nbr][col] = c;
            if (c == 'S') {
                sx = col;
                sy = line_nbr;
            }
        }
    }

    var dist: [H][W]i32 = .{.{-1} ** W} ** H;
    dist[sy][sx] = 0;

    var q: [20000]Pos = .{Pos{ .x = INF, .y = INF }} ** 20000;
    var q_start: usize = 0;
    var q_end: usize = 0;

    if (grid[sy][sx - 1] == '-' or grid[sy][sx - 1] == 'L' or grid[sy][sx - 1] == 'F') {
        dist[sy][sx - 1] = 1;
        q[q_end] = Pos{ .x = sx - 1, .y = sy };
        q_end += 1;
    }
    if (grid[sy][sx + 1] == '-' or grid[sy][sx + 1] == 'J' or grid[sy][sx + 1] == '7') {
        dist[sy][sx + 1] = 1;
        q[q_end] = Pos{ .x = sx + 1, .y = sy };
        q_end += 1;
    }
    if (grid[sy - 1][sx] == '|' or grid[sy - 1][sx] == '7' or grid[sy - 1][sx] == 'F') {
        dist[sy - 1][sx] = 1;
        q[q_end] = Pos{ .x = sx, .y = sy - 1 };
        q_end += 1;
    }
    if (grid[sy + 1][sx] == '|' or grid[sy + 1][sx] == 'L' or grid[sy + 1][sx] == 'J') {
        dist[sy + 1][sx] = 1;
        q[q_end] = Pos{ .x = sx, .y = sy + 1 };
        q_end += 1;
    }

    while (q_start < q_end) {
        var curr = q[q_start];
        q_start += 1;
        var x = curr.x;
        var y = curr.y;
        if (grid[y][x] == '-') {
            if (x > 0 and dist[y][x - 1] == -1 and grid[y][x - 1] != '.') {
                dist[y][x - 1] = dist[y][x] + 1;
                q[q_end] = Pos{ .x = x - 1, .y = y };
                q_end += 1;
            }
            if (x < W - 1 and dist[y][x + 1] == -1 and grid[y][x + 1] != '.') {
                dist[y][x + 1] = dist[y][x] + 1;
                q[q_end] = Pos{ .x = x + 1, .y = y };
                q_end += 1;
            }
        } else if (grid[y][x] == '|') {
            if (y > 0 and dist[y - 1][x] == -1 and grid[y - 1][x] != '.') {
                dist[y - 1][x] = dist[y][x] + 1;
                q[q_end] = Pos{ .x = x, .y = y - 1 };
                q_end += 1;
            }
            if (y < H - 1 and dist[y + 1][x] == -1 and grid[y + 1][x] != '.') {
                dist[y + 1][x] = dist[y][x] + 1;
                q[q_end] = Pos{ .x = x, .y = y + 1 };
                q_end += 1;
            }
        } else if (grid[y][x] == 'L') {
            if (x < W - 1 and dist[y][x + 1] == -1 and grid[y][x + 1] != '.') {
                dist[y][x + 1] = dist[y][x] + 1;
                q[q_end] = Pos{ .x = x + 1, .y = y };
                q_end += 1;
            }
            if (y > 0 and dist[y - 1][x] == -1 and grid[y - 1][x] != '.') {
                dist[y - 1][x] = dist[y][x] + 1;
                q[q_end] = Pos{ .x = x, .y = y - 1 };
                q_end += 1;
            }
        } else if (grid[y][x] == 'J') {
            if (x > 0 and dist[y][x - 1] == -1 and grid[y][x - 1] != '.') {
                dist[y][x - 1] = dist[y][x] + 1;
                q[q_end] = Pos{ .x = x - 1, .y = y };
                q_end += 1;
            }
            if (y > 0 and dist[y - 1][x] == -1 and grid[y - 1][x] != '.') {
                dist[y - 1][x] = dist[y][x] + 1;
                q[q_end] = Pos{ .x = x, .y = y - 1 };
                q_end += 1;
            }
        } else if (grid[y][x] == '7') {
            if (x > 0 and dist[y][x - 1] == -1 and grid[y][x - 1] != '.') {
                dist[y][x - 1] = dist[y][x] + 1;
                q[q_end] = Pos{ .x = x - 1, .y = y };
                q_end += 1;
            }
            if (y < H - 1 and dist[y + 1][x] == -1 and grid[y + 1][x] != '.') {
                dist[y + 1][x] = dist[y][x] + 1;
                q[q_end] = Pos{ .x = x, .y = y + 1 };
                q_end += 1;
            }
        } else if (grid[y][x] == 'F') {
            if (y < H - 1 and dist[y + 1][x] == -1 and grid[y + 1][x] != '.') {
                dist[y + 1][x] = dist[y][x] + 1;
                q[q_end] = Pos{ .x = x, .y = y + 1 };
                q_end += 1;
            }
            if (x < W - 1 and dist[y][x + 1] == -1 and grid[y][x + 1] != '.') {
                dist[y][x + 1] = dist[y][x] + 1;
                q[q_end] = Pos{ .x = x + 1, .y = y };
                q_end += 1;
            }
        }
    }

    var ans: i32 = 0;
    for (0..H) |i| {
        for (0..W) |j| {
            ans = @max(ans, dist[i][j]);
        }
    }
    print("Part 1: {}\n", .{ans});
}

fn compute_total_area(n: u32, points: []Pos) u32 {
    var area: i32 = 0;
    for (0..n) |i| {
        var a: i32 = @intCast(points[i].y + points[@mod(i + 1, n)].y);
        var t1: i32 = @intCast(points[i].x);
        var t2: i32 = @intCast(points[@mod(i + 1, n)].x);
        var b: i32 = t1 - t2;
        area += a * b;
    }
    return std.math.absCast(area) / 2;
}

fn solve_2() !void {
    var lines = std.mem.tokenizeSequence(u8, input, "\n");
    var grid: [H][W]u8 = .{.{0} ** W} ** H;
    var line_nbr: usize = 0;
    var sx: usize = 0;
    var sy: usize = 0;

    while (lines.next()) |line| : (line_nbr += 1) {
        for (0.., line) |col, c| {
            grid[line_nbr][col] = c;
            if (c == 'S') {
                sx = col;
                sy = line_nbr;
            }
        }
    }

    var dist: [H][W]i32 = .{.{-1} ** W} ** H;
    dist[sy][sx] = 0;

    var q: [20000]Pos = .{Pos{ .x = INF, .y = INF }} ** 20000;
    var q_start: usize = 0;
    var q_end: usize = 0;

    var found_start = false;
    if (grid[sy][sx - 1] == '-' or grid[sy][sx - 1] == 'L' or grid[sy][sx - 1] == 'F') {
        dist[sy][sx - 1] = 1;
        q[q_end] = Pos{ .x = sx - 1, .y = sy };
        q_end += 1;
        found_start = true;
    }
    if (!found_start and (grid[sy][sx + 1] == '-' or grid[sy][sx + 1] == 'J' or grid[sy][sx + 1] == '7')) {
        dist[sy][sx + 1] = 1;
        q[q_end] = Pos{ .x = sx + 1, .y = sy };
        q_end += 1;
        found_start = true;
    }
    if (!found_start and (grid[sy - 1][sx] == '|' or grid[sy - 1][sx] == '7' or grid[sy - 1][sx] == 'F')) {
        dist[sy - 1][sx] = 1;
        q[q_end] = Pos{ .x = sx, .y = sy - 1 };
        q_end += 1;
        found_start = true;
    }
    if (!found_start and (grid[sy + 1][sx] == '|' or grid[sy + 1][sx] == 'L' or grid[sy + 1][sx] == 'J')) {
        dist[sy + 1][sx] = 1;
        q[q_end] = Pos{ .x = sx, .y = sy + 1 };
        q_end += 1;
    }

    var path = ArrayList(Pos).init(gpa);
    defer path.deinit();
    var n: u32 = 1;
    try path.append(Pos{ .x = sx, .y = sy });
    while (q_start < q_end) {
        var curr = q[q_start];
        try path.append(curr);
        n += 1;
        q_start += 1;
        var x = curr.x;
        var y = curr.y;
        if (grid[y][x] == '-') {
            if (x > 0 and dist[y][x - 1] == -1 and grid[y][x - 1] != '.') {
                dist[y][x - 1] = dist[y][x] + 1;
                q[q_end] = Pos{ .x = x - 1, .y = y };
                q_end += 1;
            }
            if (x < W - 1 and dist[y][x + 1] == -1 and grid[y][x + 1] != '.') {
                dist[y][x + 1] = dist[y][x] + 1;
                q[q_end] = Pos{ .x = x + 1, .y = y };
                q_end += 1;
            }
        } else if (grid[y][x] == '|') {
            if (y > 0 and dist[y - 1][x] == -1 and grid[y - 1][x] != '.') {
                dist[y - 1][x] = dist[y][x] + 1;
                q[q_end] = Pos{ .x = x, .y = y - 1 };
                q_end += 1;
            }
            if (y < H - 1 and dist[y + 1][x] == -1 and grid[y + 1][x] != '.') {
                dist[y + 1][x] = dist[y][x] + 1;
                q[q_end] = Pos{ .x = x, .y = y + 1 };
                q_end += 1;
            }
        } else if (grid[y][x] == 'L') {
            if (x < W - 1 and dist[y][x + 1] == -1 and grid[y][x + 1] != '.') {
                dist[y][x + 1] = dist[y][x] + 1;
                q[q_end] = Pos{ .x = x + 1, .y = y };
                q_end += 1;
            }
            if (y > 0 and dist[y - 1][x] == -1 and grid[y - 1][x] != '.') {
                dist[y - 1][x] = dist[y][x] + 1;
                q[q_end] = Pos{ .x = x, .y = y - 1 };
                q_end += 1;
            }
        } else if (grid[y][x] == 'J') {
            if (x > 0 and dist[y][x - 1] == -1 and grid[y][x - 1] != '.') {
                dist[y][x - 1] = dist[y][x] + 1;
                q[q_end] = Pos{ .x = x - 1, .y = y };
                q_end += 1;
            }
            if (y > 0 and dist[y - 1][x] == -1 and grid[y - 1][x] != '.') {
                dist[y - 1][x] = dist[y][x] + 1;
                q[q_end] = Pos{ .x = x, .y = y - 1 };
                q_end += 1;
            }
        } else if (grid[y][x] == '7') {
            if (x > 0 and dist[y][x - 1] == -1 and grid[y][x - 1] != '.') {
                dist[y][x - 1] = dist[y][x] + 1;
                q[q_end] = Pos{ .x = x - 1, .y = y };
                q_end += 1;
            }
            if (y < H - 1 and dist[y + 1][x] == -1 and grid[y + 1][x] != '.') {
                dist[y + 1][x] = dist[y][x] + 1;
                q[q_end] = Pos{ .x = x, .y = y + 1 };
                q_end += 1;
            }
        } else if (grid[y][x] == 'F') {
            if (y < H - 1 and dist[y + 1][x] == -1 and grid[y + 1][x] != '.') {
                dist[y + 1][x] = dist[y][x] + 1;
                q[q_end] = Pos{ .x = x, .y = y + 1 };
                q_end += 1;
            }
            if (x < W - 1 and dist[y][x + 1] == -1 and grid[y][x + 1] != '.') {
                dist[y][x + 1] = dist[y][x] + 1;
                q[q_end] = Pos{ .x = x + 1, .y = y };
                q_end += 1;
            }
        }
    }

    var total_area = compute_total_area(n, path.items);
    var ans = total_area - n / 2 + 1;

    print("Part 2: {}\n", .{ans});
}

pub fn main() !void {
    try solve_1();
    try solve_2();
}
