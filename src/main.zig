const std = @import("std");
const wcl = @cImport(@cInclude("../lib/WjCryptLib_Sha256.h"));

fn print_hash(hash: *wcl.SHA256_HASH) void {
    std.debug.print("Hash: ", .{});
    for (0..hash.bytes.len) |n| {
        std.debug.print("{X:0>2}", .{hash.bytes[n]});
    }
    std.debug.print("\n", .{});
}

pub fn main() !void {
    var hash: wcl.SHA256_HASH = undefined;
    var args = std.process.args();
    _ = args.skip();
    const string = args.next() orelse unreachable;
    std.debug.print("Processing {s} ...\n", .{string});
    var ctx = wcl.Sha256Context{};

    // The long way (ok for incremental calculations)
    wcl.Sha256Initialise(&ctx);
    wcl.Sha256Update(&ctx, string.ptr, @intCast(string.len));
    wcl.Sha256Finalise(&ctx, &hash);
    print_hash(&hash);

    // The short way (ok for a single shot like in this example)
    wcl.Sha256Calculate(string.ptr, @intCast(string.len), &hash);
    print_hash(&hash);
}
