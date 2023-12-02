#!/usr/bin/fish

set day (math (count (ls -d day-*)) + 1)

mkdir day-$day
cd day-$day

curl --cookie session=(cat ../.secret-cookie) https://adventofcode.com/2023/day/$day/input > input.txt

cp ../template.zig ./main.zig
