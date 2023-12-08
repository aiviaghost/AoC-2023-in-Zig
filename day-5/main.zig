const std = @import("std");

const input = @embedFile("input.txt");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};

const INF: u64 = std.math.maxInt(u64);

const String = []const u8;
const MapRange = struct { src: u64, dest: u64, len: u64 };
const Range = struct { start: u64, end: u64 };

fn is_digit(c: u8) bool {
    return switch (c) {
        '0'...'9' => true,
        else => false,
    };
}

fn line_to_MapRange(line: String) MapRange {
    var data = std.mem.splitScalar(u8, line, ' ');
    var dest = std.fmt.parseInt(u64, data.next().?, 10) catch 0;
    var src = std.fmt.parseInt(u64, data.next().?, 10) catch 0;
    var len = std.fmt.parseInt(u64, data.next().?, 10) catch 0;
    return MapRange{ .src = src, .dest = dest, .len = len - 1 };
}

fn solve_1() !void {
    var lines = std.mem.tokenizeSequence(u8, input, "\n");
    var alloc = gpa.allocator();

    var seeds = std.ArrayList(u64).init(alloc);
    defer seeds.deinit();
    var first_line = lines.next().?;
    var skip = std.mem.indexOfScalar(u8, first_line, ':').? + 2;
    var seed_data = std.mem.splitScalar(u8, first_line[skip..], ' ');
    while (seed_data.next()) |seed| {
        try seeds.append(try std.fmt.parseInt(u64, seed, 10));
    }

    var seed_to_soil = std.ArrayList(MapRange).init(alloc);
    defer seed_to_soil.deinit();
    var soil_to_fertilizer = std.ArrayList(MapRange).init(alloc);
    defer soil_to_fertilizer.deinit();
    var fetilizer_to_water = std.ArrayList(MapRange).init(alloc);
    defer fetilizer_to_water.deinit();
    var water_to_light = std.ArrayList(MapRange).init(alloc);
    defer water_to_light.deinit();
    var light_to_temperature = std.ArrayList(MapRange).init(alloc);
    defer light_to_temperature.deinit();
    var temperature_to_humidity = std.ArrayList(MapRange).init(alloc);
    defer temperature_to_humidity.deinit();
    var humidity_to_location = std.ArrayList(MapRange).init(alloc);
    defer humidity_to_location.deinit();

    _ = lines.next();

    while (lines.next()) |line| {
        if (!is_digit(line[0])) break;
        var mr = line_to_MapRange(line);
        try seed_to_soil.append(mr);
    }

    while (lines.next()) |line| {
        if (!is_digit(line[0])) break;
        var mr = line_to_MapRange(line);
        try soil_to_fertilizer.append(mr);
    }

    while (lines.next()) |line| {
        if (!is_digit(line[0])) break;
        var mr = line_to_MapRange(line);
        try fetilizer_to_water.append(mr);
    }

    while (lines.next()) |line| {
        if (!is_digit(line[0])) break;
        var mr = line_to_MapRange(line);
        try water_to_light.append(mr);
    }

    while (lines.next()) |line| {
        if (!is_digit(line[0])) break;
        var mr = line_to_MapRange(line);
        try light_to_temperature.append(mr);
    }

    while (lines.next()) |line| {
        if (!is_digit(line[0])) break;
        var mr = line_to_MapRange(line);
        try temperature_to_humidity.append(mr);
    }

    while (lines.next()) |line| {
        if (!is_digit(line[0])) break;
        var mr = line_to_MapRange(line);
        try humidity_to_location.append(mr);
    }

    var ans: u64 = INF;
    for (seeds.items) |seed| {
        var curr = seed;
        for (seed_to_soil.items) |mr| {
            if (mr.src <= curr and curr <= mr.src + mr.len) {
                curr = mr.dest + curr - mr.src;
                break;
            }
        }
        for (soil_to_fertilizer.items) |mr| {
            if (mr.src <= curr and curr <= mr.src + mr.len) {
                curr = mr.dest + curr - mr.src;
                break;
            }
        }
        for (fetilizer_to_water.items) |mr| {
            if (mr.src <= curr and curr <= mr.src + mr.len) {
                curr = mr.dest + curr - mr.src;
                break;
            }
        }
        for (water_to_light.items) |mr| {
            if (mr.src <= curr and curr <= mr.src + mr.len) {
                curr = mr.dest + curr - mr.src;
                break;
            }
        }
        for (light_to_temperature.items) |mr| {
            if (mr.src <= curr and curr <= mr.src + mr.len) {
                curr = mr.dest + curr - mr.src;
                break;
            }
        }
        for (temperature_to_humidity.items) |mr| {
            if (mr.src <= curr and curr <= mr.src + mr.len) {
                curr = mr.dest + curr - mr.src;
                break;
            }
        }
        for (humidity_to_location.items) |mr| {
            if (mr.src <= curr and curr <= mr.src + mr.len) {
                curr = mr.dest + curr - mr.src;
                break;
            }
        }
        ans = @min(ans, curr);
    }

    std.debug.print("Part 1: {}\n", .{ans});
}

fn lt_MapRange(context: void, lhs: MapRange, rhs: MapRange) bool {
    _ = context;
    return lhs.src < rhs.src;
}

fn overlap(r1: Range, r2: Range) Range {
    var s1 = r1.start;
    var e1 = r1.end;
    var s2 = r2.start;
    var e2 = r2.end;
    if (s1 <= s2 and e2 <= e1) {
        return Range{ .start = s2, .end = e2 };
    } else if (s2 <= e1 and s1 <= s2 and e1 <= e2) {
        return Range{ .start = s2, .end = e1 };
    } else if (s2 <= s1 and e1 <= e2) {
        return Range{ .start = s1, .end = e1 };
    } else if (s1 <= e2 and s2 <= s1 and e2 <= e1) {
        return Range{ .start = s1, .end = e2 };
    } else {
        return Range{ .start = INF, .end = INF };
    }
}

fn solve_2() !void {
    var lines = std.mem.tokenizeSequence(u8, input, "\n");
    var alloc = gpa.allocator();

    var seeds = std.ArrayList(Range).init(alloc);
    defer seeds.deinit();
    var first_line = lines.next().?;
    var skip = std.mem.indexOfScalar(u8, first_line, ':').? + 2;
    var seed_data = std.mem.splitScalar(u8, first_line[skip..], ' ');
    while (true) {
        if (seed_data.next()) |p1| {
            var src = try std.fmt.parseInt(u64, p1, 10);
            var len = try std.fmt.parseInt(u64, seed_data.next().?, 10);
            try seeds.append(Range{ .start = src, .end = src + len - 1 });
        } else {
            break;
        }
    }

    var seed_to_soil_list = std.ArrayList(MapRange).init(alloc);
    defer seed_to_soil_list.deinit();
    var soil_to_fertilizer_list = std.ArrayList(MapRange).init(alloc);
    defer soil_to_fertilizer_list.deinit();
    var fetilizer_to_water_list = std.ArrayList(MapRange).init(alloc);
    defer fetilizer_to_water_list.deinit();
    var water_to_light_list = std.ArrayList(MapRange).init(alloc);
    defer water_to_light_list.deinit();
    var light_to_temperature_list = std.ArrayList(MapRange).init(alloc);
    defer light_to_temperature_list.deinit();
    var temperature_to_humidity_list = std.ArrayList(MapRange).init(alloc);
    defer temperature_to_humidity_list.deinit();
    var humidity_to_location_list = std.ArrayList(MapRange).init(alloc);
    defer humidity_to_location_list.deinit();

    _ = lines.next();

    while (lines.next()) |line| {
        if (!is_digit(line[0])) break;
        var mr = line_to_MapRange(line);
        try seed_to_soil_list.append(mr);
    }
    var seed_to_soil = try alloc.alloc(MapRange, seed_to_soil_list.items.len);
    defer alloc.free(seed_to_soil);
    @memcpy(seed_to_soil, seed_to_soil_list.items);
    std.mem.sort(MapRange, seed_to_soil, {}, lt_MapRange);

    while (lines.next()) |line| {
        if (!is_digit(line[0])) break;
        var mr = line_to_MapRange(line);
        try soil_to_fertilizer_list.append(mr);
    }
    var soil_to_fertilizer = try alloc.alloc(MapRange, soil_to_fertilizer_list.items.len);
    defer alloc.free(soil_to_fertilizer);
    @memcpy(soil_to_fertilizer, soil_to_fertilizer_list.items);
    std.mem.sort(MapRange, soil_to_fertilizer, {}, lt_MapRange);

    while (lines.next()) |line| {
        if (!is_digit(line[0])) break;
        var mr = line_to_MapRange(line);
        try fetilizer_to_water_list.append(mr);
    }
    var fetilizer_to_water = try alloc.alloc(MapRange, fetilizer_to_water_list.items.len);
    defer alloc.free(fetilizer_to_water);
    @memcpy(fetilizer_to_water, fetilizer_to_water_list.items);
    std.mem.sort(MapRange, fetilizer_to_water, {}, lt_MapRange);

    while (lines.next()) |line| {
        if (!is_digit(line[0])) break;
        var mr = line_to_MapRange(line);
        try water_to_light_list.append(mr);
    }
    var water_to_light = try alloc.alloc(MapRange, water_to_light_list.items.len);
    defer alloc.free(water_to_light);
    @memcpy(water_to_light, water_to_light_list.items);
    std.mem.sort(MapRange, water_to_light, {}, lt_MapRange);

    while (lines.next()) |line| {
        if (!is_digit(line[0])) break;
        var mr = line_to_MapRange(line);
        try light_to_temperature_list.append(mr);
    }
    var light_to_temperature = try alloc.alloc(MapRange, light_to_temperature_list.items.len);
    defer alloc.free(light_to_temperature);
    @memcpy(light_to_temperature, light_to_temperature_list.items);
    std.mem.sort(MapRange, light_to_temperature, {}, lt_MapRange);

    while (lines.next()) |line| {
        if (!is_digit(line[0])) break;
        var mr = line_to_MapRange(line);
        try temperature_to_humidity_list.append(mr);
    }
    var temperature_to_humidity = try alloc.alloc(MapRange, temperature_to_humidity_list.items.len);
    defer alloc.free(temperature_to_humidity);
    @memcpy(temperature_to_humidity, temperature_to_humidity_list.items);
    std.mem.sort(MapRange, temperature_to_humidity, {}, lt_MapRange);

    while (lines.next()) |line| {
        if (!is_digit(line[0])) break;
        var mr = line_to_MapRange(line);
        try humidity_to_location_list.append(mr);
    }
    var humidity_to_location = try alloc.alloc(MapRange, humidity_to_location_list.items.len);
    defer alloc.free(humidity_to_location);
    @memcpy(humidity_to_location, humidity_to_location_list.items);
    std.mem.sort(MapRange, humidity_to_location, {}, lt_MapRange);

    var ans: u64 = INF;
    for (seeds.items) |seed| {
        var curr_layer = std.ArrayList(Range).init(alloc);
        try curr_layer.append(seed);
        var next_layer = std.ArrayList(Range).init(alloc);

        for (curr_layer.items) |curr| {
            var s1 = curr.start;
            var e1 = curr.end;
            for (seed_to_soil) |mr| {
                var s2 = mr.src;
                var e2 = mr.src + mr.len;
                if (s1 <= s2 and e2 <= e1) {
                    try next_layer.append(Range{ .start = mr.dest, .end = mr.dest + mr.len });
                } else if (s2 <= e1 and s2 <= e1 and s1 <= s2 and e1 <= e2) {
                    try next_layer.append(Range{ .start = mr.dest, .end = mr.dest + e1 - s2 });
                } else if (s2 <= s1 and e1 <= e2) {
                    try next_layer.append(Range{ .start = mr.dest + s1 - s2, .end = mr.dest + e1 - s2 });
                } else if (s1 <= e2 and s2 <= s1 and e2 <= e1) {
                    try next_layer.append(Range{ .start = mr.dest + s1 - s2, .end = mr.dest + mr.len });
                }
            }

            if (s1 < seed_to_soil[0].src) {
                try next_layer.append(Range{ .start = s1, .end = @min(e1, seed_to_soil[0].src - 1) });
            }
            var last_end = seed_to_soil[seed_to_soil.len - 1].src + seed_to_soil[seed_to_soil.len - 1].len;
            if (last_end < e1) {
                try next_layer.append(Range{ .start = @max(s1, last_end + 1), .end = e1 });
            }
            for (0..seed_to_soil.len - 1) |i| {
                var begin = seed_to_soil[i].src + seed_to_soil[i].len + 1;
                var end = seed_to_soil[i + 1].src;
                var r = overlap(curr, Range{ .start = begin, .end = end });
                if (r.start != INF and r.end != INF) {
                    try next_layer.append(r);
                }
            }
        }
        curr_layer.clearRetainingCapacity();
        while (next_layer.popOrNull()) |range| {
            try curr_layer.append(range);
        }

        for (curr_layer.items) |curr| {
            var s1 = curr.start;
            var e1 = curr.end;
            for (soil_to_fertilizer) |mr| {
                var s2 = mr.src;
                var e2 = mr.src + mr.len;
                if (s1 <= s2 and e2 <= e1) {
                    try next_layer.append(Range{ .start = mr.dest, .end = mr.dest + mr.len });
                } else if (s2 <= e1 and s1 <= s2 and e1 <= e2) {
                    try next_layer.append(Range{ .start = mr.dest, .end = mr.dest + e1 - s2 });
                } else if (s2 <= s1 and e1 <= e2) {
                    try next_layer.append(Range{ .start = mr.dest + s1 - s2, .end = mr.dest + e1 - s2 });
                } else if (s1 <= e2 and s2 <= s1 and e2 <= e1) {
                    try next_layer.append(Range{ .start = mr.dest + s1 - s2, .end = mr.dest + mr.len });
                }
            }

            if (s1 < soil_to_fertilizer[0].src) {
                try next_layer.append(Range{ .start = s1, .end = @min(e1, soil_to_fertilizer[0].src - 1) });
            }
            var last_end = soil_to_fertilizer[soil_to_fertilizer.len - 1].src + soil_to_fertilizer[soil_to_fertilizer.len - 1].len;
            if (last_end < e1) {
                try next_layer.append(Range{ .start = @max(s1, last_end + 1), .end = e1 });
            }
            for (0..soil_to_fertilizer.len - 1) |i| {
                var begin = soil_to_fertilizer[i].src + soil_to_fertilizer[i].len + 1;
                var end = soil_to_fertilizer[i + 1].src;
                var r = overlap(curr, Range{ .start = begin, .end = end });
                if (r.start != INF and r.end != INF) {
                    try next_layer.append(r);
                }
            }
        }
        curr_layer.clearRetainingCapacity();
        while (next_layer.popOrNull()) |range| {
            try curr_layer.append(range);
        }

        for (curr_layer.items) |curr| {
            var s1 = curr.start;
            var e1 = curr.end;
            for (fetilizer_to_water) |mr| {
                var s2 = mr.src;
                var e2 = mr.src + mr.len;
                if (s1 <= s2 and e2 <= e1) {
                    try next_layer.append(Range{ .start = mr.dest, .end = mr.dest + mr.len });
                } else if (s2 <= e1 and s1 <= s2 and e1 <= e2) {
                    try next_layer.append(Range{ .start = mr.dest, .end = mr.dest + e1 - s2 });
                } else if (s2 <= s1 and e1 <= e2) {
                    try next_layer.append(Range{ .start = mr.dest + s1 - s2, .end = mr.dest + e1 - s2 });
                } else if (s1 <= e2 and s2 <= s1 and e2 <= e1) {
                    try next_layer.append(Range{ .start = mr.dest + s1 - s2, .end = mr.dest + mr.len });
                }
            }

            if (s1 < fetilizer_to_water[0].src) {
                try next_layer.append(Range{ .start = s1, .end = @min(e1, fetilizer_to_water[0].src - 1) });
            }
            var last_end = fetilizer_to_water[fetilizer_to_water.len - 1].src + fetilizer_to_water[fetilizer_to_water.len - 1].len;
            if (last_end < e1) {
                try next_layer.append(Range{ .start = @max(s1, last_end + 1), .end = e1 });
            }
            for (0..fetilizer_to_water.len - 1) |i| {
                var begin = fetilizer_to_water[i].src + fetilizer_to_water[i].len + 1;
                var end = fetilizer_to_water[i + 1].src;
                var r = overlap(curr, Range{ .start = begin, .end = end });
                if (r.start != INF and r.end != INF) {
                    try next_layer.append(r);
                }
            }
        }
        curr_layer.clearRetainingCapacity();
        while (next_layer.popOrNull()) |range| {
            try curr_layer.append(range);
        }

        for (curr_layer.items) |curr| {
            var s1 = curr.start;
            var e1 = curr.end;
            for (water_to_light) |mr| {
                var s2 = mr.src;
                var e2 = mr.src + mr.len;
                if (s1 <= s2 and e2 <= e1) {
                    try next_layer.append(Range{ .start = mr.dest, .end = mr.dest + mr.len });
                } else if (s2 <= e1 and s1 <= s2 and e1 <= e2) {
                    try next_layer.append(Range{ .start = mr.dest, .end = mr.dest + e1 - s2 });
                } else if (s2 <= s1 and e1 <= e2) {
                    try next_layer.append(Range{ .start = mr.dest + s1 - s2, .end = mr.dest + e1 - s2 });
                } else if (s1 <= e2 and s2 <= s1 and e2 <= e1) {
                    try next_layer.append(Range{ .start = mr.dest + s1 - s2, .end = mr.dest + mr.len });
                }
            }

            if (s1 < water_to_light[0].src) {
                try next_layer.append(Range{ .start = s1, .end = @min(e1, water_to_light[0].src - 1) });
            }
            var last_end = water_to_light[water_to_light.len - 1].src + water_to_light[water_to_light.len - 1].len;
            if (last_end < e1) {
                try next_layer.append(Range{ .start = @max(s1, last_end + 1), .end = e1 });
            }
            for (0..water_to_light.len - 1) |i| {
                var begin = water_to_light[i].src + water_to_light[i].len + 1;
                var end = water_to_light[i + 1].src;
                var r = overlap(curr, Range{ .start = begin, .end = end });
                if (r.start != INF and r.end != INF) {
                    try next_layer.append(r);
                }
            }
        }
        curr_layer.clearRetainingCapacity();
        while (next_layer.popOrNull()) |range| {
            try curr_layer.append(range);
        }

        for (curr_layer.items) |curr| {
            var s1 = curr.start;
            var e1 = curr.end;
            for (light_to_temperature) |mr| {
                var s2 = mr.src;
                var e2 = mr.src + mr.len;
                if (s1 <= s2 and e2 <= e1) {
                    try next_layer.append(Range{ .start = mr.dest, .end = mr.dest + mr.len });
                } else if (s2 <= e1 and s1 <= s2 and e1 <= e2) {
                    try next_layer.append(Range{ .start = mr.dest, .end = mr.dest + e1 - s2 });
                } else if (s2 <= s1 and e1 <= e2) {
                    try next_layer.append(Range{ .start = mr.dest + s1 - s2, .end = mr.dest + e1 - s2 });
                } else if (s1 <= e2 and s2 <= s1 and e2 <= e1) {
                    try next_layer.append(Range{ .start = mr.dest + s1 - s2, .end = mr.dest + mr.len });
                }
            }

            if (s1 < light_to_temperature[0].src) {
                try next_layer.append(Range{ .start = s1, .end = @min(e1, light_to_temperature[0].src - 1) });
            }
            var last_end = light_to_temperature[light_to_temperature.len - 1].src + light_to_temperature[light_to_temperature.len - 1].len;
            if (last_end < e1) {
                try next_layer.append(Range{ .start = @max(s1, last_end + 1), .end = e1 });
            }
            for (0..light_to_temperature.len - 1) |i| {
                var begin = light_to_temperature[i].src + light_to_temperature[i].len + 1;
                var end = light_to_temperature[i + 1].src;
                var r = overlap(curr, Range{ .start = begin, .end = end });
                if (r.start != INF and r.end != INF) {
                    try next_layer.append(r);
                }
            }
        }
        curr_layer.clearRetainingCapacity();
        while (next_layer.popOrNull()) |range| {
            try curr_layer.append(range);
        }

        for (curr_layer.items) |curr| {
            var s1 = curr.start;
            var e1 = curr.end;
            for (temperature_to_humidity) |mr| {
                var s2 = mr.src;
                var e2 = mr.src + mr.len;
                if (s1 <= s2 and e2 <= e1) {
                    try next_layer.append(Range{ .start = mr.dest, .end = mr.dest + mr.len });
                } else if (s2 <= e1 and s1 <= s2 and e1 <= e2) {
                    try next_layer.append(Range{ .start = mr.dest, .end = mr.dest + e1 - s2 });
                } else if (s2 <= s1 and e1 <= e2) {
                    try next_layer.append(Range{ .start = mr.dest + s1 - s2, .end = mr.dest + e1 - s2 });
                } else if (s1 <= e2 and s2 <= s1 and e2 <= e1) {
                    try next_layer.append(Range{ .start = mr.dest + s1 - s2, .end = mr.dest + mr.len });
                }
            }

            if (s1 < temperature_to_humidity[0].src) {
                try next_layer.append(Range{ .start = s1, .end = @min(e1, temperature_to_humidity[0].src - 1) });
            }
            var last_end = temperature_to_humidity[temperature_to_humidity.len - 1].src + temperature_to_humidity[temperature_to_humidity.len - 1].len;
            if (last_end < e1) {
                try next_layer.append(Range{ .start = @max(s1, last_end + 1), .end = e1 });
            }
            for (0..temperature_to_humidity.len - 1) |i| {
                var begin = temperature_to_humidity[i].src + temperature_to_humidity[i].len + 1;
                var end = temperature_to_humidity[i + 1].src;
                var r = overlap(curr, Range{ .start = begin, .end = end });
                if (r.start != INF and r.end != INF) {
                    try next_layer.append(r);
                }
            }
        }
        curr_layer.clearRetainingCapacity();
        while (next_layer.popOrNull()) |range| {
            try curr_layer.append(range);
        }

        for (curr_layer.items) |curr| {
            var s1 = curr.start;
            var e1 = curr.end;
            for (humidity_to_location) |mr| {
                var s2 = mr.src;
                var e2 = mr.src + mr.len;
                var start: u64 = 0;
                if (s1 <= s2 and e2 <= e1) {
                    start = mr.dest;
                } else if (s2 <= e1 and s1 <= s2 and e1 <= e2) {
                    start = mr.dest;
                } else if (s2 <= s1 and e1 <= e2) {
                    start = mr.dest + s1 - s2;
                } else if (s1 <= e2 and s2 <= s1 and e2 <= e1) {
                    start = mr.dest + s1 - s2;
                } else {
                    continue;
                }
                ans = @min(ans, start);
            }

            if (s1 < humidity_to_location[0].src) {
                ans = @min(ans, s1);
            }
            var last_end = humidity_to_location[humidity_to_location.len - 1].src + humidity_to_location[humidity_to_location.len - 1].len;
            if (last_end < e1) {
                ans = @min(ans, @max(s1, last_end + 1));
            }
            for (0..humidity_to_location.len - 1) |i| {
                var begin = humidity_to_location[i].src + humidity_to_location[i].len + 1;
                var end = humidity_to_location[i + 1].src;
                var r = overlap(curr, Range{ .start = begin, .end = end });
                if (r.start != INF and r.end != INF) {
                    ans = @min(ans, r.start);
                }
            }
        }

        curr_layer.deinit();
        next_layer.deinit();
    }
    std.debug.print("Part 2: {}\n", .{ans});
}

pub fn main() !void {
    try solve_1();
    try solve_2();
}
