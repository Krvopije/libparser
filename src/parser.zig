const std = @import("std");
const testing = std.testing;

pub fn readInputByCLI(allocator: std.mem.Allocator) ![]const u8 {
    var buffer: [100]u8 = undefined;
    const stdin = std.fs.File.stdin();
    var reader = stdin.reader(&buffer);
    const input = try reader.readStreaming(&buffer);
    const return_value = try allocator.dupe(u8, buffer[0..input]);
    return return_value;
}

pub fn splitStringByDelimiter(data: []const u8, delimiters: []const u8, split_content: *std.ArrayList([]const u8)) !void {
    var it = std.mem.tokenize(u8, data, delimiters);
    while (it.next()) |part| {
        try split_content.append(part);
    }
}

pub fn parseToInt(comptime T: type, data: []const u8) !T {
    return std.fmt.parseInt(T, data, 10);
}

test "reading any user input" {
    var allocator = std.testing.allocator;
    const cli_input = try readInputByCLI(allocator);
    std.debug.print("{s}\n", .{cli_input});
    defer allocator.free(cli_input);
}

test "spliting any user input by different delimiters" {
    var allocator = std.testing.allocator;
    var split_content = std.ArrayList([]const u8).init(allocator);
    defer split_content.deinit();
    std.debug.print("\nPlease enter some Input: ", .{});
    const cli_input = try readInputByCLI(allocator);
    std.debug.print("{s}\n", .{cli_input.?});
    defer allocator.free(cli_input.?);
    std.debug.print("\nPlease enter the seperators/delimiters: ", .{});
    const delimiters = try readInputByCLI(allocator);
    defer allocator.free(delimiters.?);
    try splitStringByDelimiter(cli_input.?, delimiters.?, &split_content);
    for (split_content.items) |part| {
        std.debug.print("{s}\n", .{part});
    }
}
