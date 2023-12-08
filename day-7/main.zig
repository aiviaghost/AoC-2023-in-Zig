const std = @import("std");

const input = @embedFile("input.txt");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};

const smap = std.StringHashMap(u32);

const num_hands = 1000;

fn is_digit(c: u8) bool {
    return switch (c) {
        '0'...'9' => true,
        else => false,
    };
}

fn get_hand_type(hand: []const u8) u8 {
    var counts: [36]u8 = .{0} ** 36;
    for (hand) |c| {
        if (!is_digit(c)) {
            counts[c - 'A'] += 1;
        } else {
            counts[26 + c - '0'] += 1;
        }
    }
    var one: u8 = 0;
    var two: u8 = 0;
    var three: u8 = 0;
    var four: u8 = 0;
    var five: u8 = 0;
    for (counts) |i| {
        switch (i) {
            1 => one += 1,
            2 => two += 1,
            3 => three += 1,
            4 => four += 1,
            5 => five += 1,
            else => {},
        }
    }
    if (five == 1) {
        return 7;
    } else if (four == 1) {
        return 6;
    } else if (three == 1 and two == 1) {
        return 5;
    } else if (three == 1) {
        return 4;
    } else if (two == 2) {
        return 3;
    } else if (two == 1) {
        return 2;
    } else {
        return 1;
    }
}

fn lt_hand_pt1(context: void, lhs: []const u8, rhs: []const u8) bool {
    _ = context;

    const card_values = std.ComptimeStringMap(u8, .{
        .{ "A", 13 },
        .{ "K", 12 },
        .{ "Q", 11 },
        .{ "J", 10 },
        .{ "T", 9 },
        .{ "9", 8 },
        .{ "8", 7 },
        .{ "7", 6 },
        .{ "6", 5 },
        .{ "5", 4 },
        .{ "4", 3 },
        .{ "3", 2 },
        .{ "2", 1 },
    });

    var type_1 = get_hand_type(lhs);
    var type_2 = get_hand_type(rhs);

    if (type_1 != type_2) {
        return type_1 < type_2;
    }

    for (lhs, rhs) |c1, c2| {
        if (c1 != c2) {
            return card_values.get(&[_]u8{c1}).? < card_values.get(&[_]u8{c2}).?;
        }
    }

    return false;
}

fn solve_1() !void {
    var lines = std.mem.tokenizeSequence(u8, input, "\n");
    var hands: [num_hands][]const u8 = .{""} ** num_hands;
    var allocator = gpa.allocator();
    var lookup = smap.init(allocator);
    defer lookup.deinit();
    var line_number: usize = 0;
    while (lines.next()) |line| : (line_number += 1) {
        var temp = std.mem.splitScalar(u8, line, ' ');
        var hand = temp.next().?;
        var bid = temp.next().?;
        try lookup.put(hand, try std.fmt.parseInt(u32, bid, 10));
        hands[line_number] = hand;
    }

    std.mem.sort([]const u8, &hands, {}, lt_hand_pt1);

    var ans: u64 = 0;
    for (1.., hands) |rank, hand| {
        ans += rank * lookup.get(hand).?;
    }
    std.debug.print("Part 1: {}\n", .{ans});
}

fn lt_hand_pt2(context: void, lhs: []const u8, rhs: []const u8) bool {
    _ = context;

    const card_types = [_]u8{ 'A', 'K', 'Q', 'T', '9', '8', '7', '6', '5', '4', '3', '2', 'J' };
    const card_values = std.ComptimeStringMap(u8, .{
        .{ "A", 13 },
        .{ "K", 12 },
        .{ "Q", 11 },
        .{ "T", 9 },
        .{ "9", 8 },
        .{ "8", 7 },
        .{ "7", 6 },
        .{ "6", 5 },
        .{ "5", 4 },
        .{ "4", 3 },
        .{ "3", 2 },
        .{ "2", 1 },
        .{ "J", 0 },
    });

    var type_1: u8 = 0;
    for (card_types) |card_type| {
        var lhs_cp: [5]u8 = .{0} ** 5;
        @memcpy(&lhs_cp, lhs);
        std.mem.replaceScalar(u8, &lhs_cp, 'J', card_type);
        type_1 = @max(type_1, get_hand_type(&lhs_cp));
    }

    var type_2: u8 = 0;
    for (card_types) |card_type| {
        var rhs_cp: [5]u8 = .{0} ** 5;
        @memcpy(&rhs_cp, rhs);
        std.mem.replaceScalar(u8, &rhs_cp, 'J', card_type);
        type_2 = @max(type_2, get_hand_type(&rhs_cp));
    }

    if (type_1 != type_2) {
        return type_1 < type_2;
    }

    for (lhs, rhs) |c1, c2| {
        if (c1 != c2) {
            return card_values.get(&[_]u8{c1}).? < card_values.get(&[_]u8{c2}).?;
        }
    }

    return false;
}

fn solve_2() !void {
    var lines = std.mem.tokenizeSequence(u8, input, "\n");
    var hands: [num_hands][]const u8 = .{""} ** num_hands;
    var allocator = gpa.allocator();
    var lookup = smap.init(allocator);
    defer lookup.deinit();
    var line_number: usize = 0;
    while (lines.next()) |line| : (line_number += 1) {
        var temp = std.mem.splitScalar(u8, line, ' ');
        var hand = temp.next().?;
        var bid = temp.next().?;
        try lookup.put(hand, try std.fmt.parseInt(u32, bid, 10));
        hands[line_number] = hand;
    }

    std.mem.sort([]const u8, &hands, {}, lt_hand_pt2);

    var ans: u64 = 0;
    for (1.., hands) |rank, hand| {
        ans += rank * lookup.get(hand).?;
    }
    std.debug.print("Part 2: {}\n", .{ans});
}

pub fn main() !void {
    try solve_1();
    try solve_2();
}
