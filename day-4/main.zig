const std = @import("std");

const input = @embedFile("input.txt");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};

const Set = std.StaticBitSet(100);

const num_lines = 201;

fn solve_1() !void {
    var lines = std.mem.tokenizeSequence(u8, input, "\n");
    var ans: u32 = 0;
    while (lines.next()) |line| {
        var skip = std.mem.indexOfScalar(u8, line, ':').? + 2;
        var rest = std.mem.splitSequence(u8, line[skip..], " | ");
        var cards = std.mem.splitScalar(u8, rest.next().?, ' ');
        var winning_cards = Set.initEmpty();
        while (cards.next()) |card| {
            if (card.len == 0) continue;
            var idx = std.fmt.parseInt(usize, card, 10) catch 0;
            winning_cards.set(idx);
        }
        cards = std.mem.splitScalar(u8, rest.next().?, ' ');
        var score: u32 = 1;
        while (cards.next()) |card| {
            if (card.len == 0) continue;
            var idx = std.fmt.parseInt(usize, card, 10) catch 0;
            if (winning_cards.isSet(idx)) {
                score <<= 1;
            }
        }
        ans += score >> 1;
    }
    @compileLog(std.fmt.comptimePrint("Part 1: {}\n", .{ans}));
}

fn solve_2() !void {
    var lines = std.mem.tokenizeSequence(u8, input, "\n");
    var ans: u32 = 0;
    var counts: [num_lines]u32 = .{1} ** num_lines;
    var line_number = 0;
    while (lines.next()) |line| : (line_number += 1) {
        var skip = std.mem.indexOfScalar(u8, line, ':').? + 2;
        var rest = std.mem.splitSequence(u8, line[skip..], " | ");
        var cards = std.mem.splitScalar(u8, rest.next().?, ' ');
        var winning_cards = Set.initEmpty();
        while (cards.next()) |card| {
            if (card.len == 0) continue;
            var idx = std.fmt.parseInt(usize, card, 10) catch 0;
            winning_cards.set(idx);
        }
        cards = std.mem.splitScalar(u8, rest.next().?, ' ');
        var num_matching = 0;
        while (cards.next()) |card| {
            if (card.len == 0) continue;
            var idx = std.fmt.parseInt(usize, card, 10) catch 0;
            if (winning_cards.isSet(idx)) {
                num_matching += 1;
            }
        }
        ans += counts[line_number];
        for (1..num_matching + 1) |i| {
            if (line_number + i < num_lines) {
                counts[line_number + i] += counts[line_number];
            }
        }
    }
    @compileLog(std.fmt.comptimePrint("Part 2: {}\n", .{ans}));
}

pub fn main() !void {
    @setEvalBranchQuota(1000000);
    comptime try solve_1();
    comptime try solve_2();
}
