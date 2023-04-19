var data = {lines:[
{"lineNum":"    1","line":"const std = @import(\"std.zig\");"},
{"lineNum":"    2","line":"const builtin = @import(\"builtin\");"},
{"lineNum":"    3","line":"const root = @import(\"root\");"},
{"lineNum":"    4","line":"const c = std.c;"},
{"lineNum":"    5","line":""},
{"lineNum":"    6","line":"const math = std.math;"},
{"lineNum":"    7","line":"const assert = std.debug.assert;"},
{"lineNum":"    8","line":"const os = std.os;"},
{"lineNum":"    9","line":"const fs = std.fs;"},
{"lineNum":"   10","line":"const mem = std.mem;"},
{"lineNum":"   11","line":"const meta = std.meta;"},
{"lineNum":"   12","line":"const File = std.fs.File;"},
{"lineNum":"   13","line":""},
{"lineNum":"   14","line":"pub const Mode = enum {"},
{"lineNum":"   15","line":"    /// I/O operates normally, waiting for the operating system syscalls to complete."},
{"lineNum":"   16","line":"    blocking,"},
{"lineNum":"   17","line":""},
{"lineNum":"   18","line":"    /// I/O functions are generated async and rely on a global event loop. Event-based I/O."},
{"lineNum":"   19","line":"    evented,"},
{"lineNum":"   20","line":"};"},
{"lineNum":"   21","line":""},
{"lineNum":"   22","line":"const mode = std.options.io_mode;"},
{"lineNum":"   23","line":"pub const is_async = mode != .blocking;"},
{"lineNum":"   24","line":""},
{"lineNum":"   25","line":"/// This is an enum value to use for I/O mode at runtime, since it takes up zero bytes at runtime,"},
{"lineNum":"   26","line":"/// and makes expressions comptime-known when `is_async` is `false`."},
{"lineNum":"   27","line":"pub const ModeOverride = if (is_async) Mode else enum { blocking };"},
{"lineNum":"   28","line":"pub const default_mode: ModeOverride = if (is_async) Mode.evented else .blocking;"},
{"lineNum":"   29","line":""},
{"lineNum":"   30","line":"fn getStdOutHandle() os.fd_t {","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   31","line":"    if (builtin.os.tag == .windows) {"},
{"lineNum":"   32","line":"        if (builtin.zig_backend == .stage2_aarch64) {"},
{"lineNum":"   33","line":"            // TODO: this is just a temporary workaround until we advance aarch64 backend further along."},
{"lineNum":"   34","line":"            return os.windows.GetStdHandle(os.windows.STD_OUTPUT_HANDLE) catch os.windows.INVALID_HANDLE_VALUE;"},
{"lineNum":"   35","line":"        }"},
{"lineNum":"   36","line":"        return os.windows.peb().ProcessParameters.hStdOutput;"},
{"lineNum":"   37","line":"    }"},
{"lineNum":"   38","line":""},
{"lineNum":"   39","line":"    if (@hasDecl(root, \"os\") and @hasDecl(root.os, \"io\") and @hasDecl(root.os.io, \"getStdOutHandle\")) {"},
{"lineNum":"   40","line":"        return root.os.io.getStdOutHandle();"},
{"lineNum":"   41","line":"    }"},
{"lineNum":"   42","line":""},
{"lineNum":"   43","line":"    return os.STDOUT_FILENO;","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   44","line":"}"},
{"lineNum":"   45","line":""},
{"lineNum":"   46","line":"/// TODO: async stdout on windows without a dedicated thread."},
{"lineNum":"   47","line":"/// https://github.com/ziglang/zig/pull/4816#issuecomment-604521023"},
{"lineNum":"   48","line":"pub fn getStdOut() File {","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   49","line":"    return File{","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   50","line":"        .handle = getStdOutHandle(),","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   51","line":"        .capable_io_mode = .blocking,"},
{"lineNum":"   52","line":"        .intended_io_mode = default_mode,"},
{"lineNum":"   53","line":"    };"},
{"lineNum":"   54","line":"}"},
{"lineNum":"   55","line":""},
{"lineNum":"   56","line":"fn getStdErrHandle() os.fd_t {","class":"lineCov","hits":"1","order":"348","possible_hits":"1",},
{"lineNum":"   57","line":"    if (builtin.os.tag == .windows) {"},
{"lineNum":"   58","line":"        if (builtin.zig_backend == .stage2_aarch64) {"},
{"lineNum":"   59","line":"            // TODO: this is just a temporary workaround until we advance aarch64 backend further along."},
{"lineNum":"   60","line":"            return os.windows.GetStdHandle(os.windows.STD_ERROR_HANDLE) catch os.windows.INVALID_HANDLE_VALUE;"},
{"lineNum":"   61","line":"        }"},
{"lineNum":"   62","line":"        return os.windows.peb().ProcessParameters.hStdError;"},
{"lineNum":"   63","line":"    }"},
{"lineNum":"   64","line":""},
{"lineNum":"   65","line":"    if (@hasDecl(root, \"os\") and @hasDecl(root.os, \"io\") and @hasDecl(root.os.io, \"getStdErrHandle\")) {"},
{"lineNum":"   66","line":"        return root.os.io.getStdErrHandle();"},
{"lineNum":"   67","line":"    }"},
{"lineNum":"   68","line":""},
{"lineNum":"   69","line":"    return os.STDERR_FILENO;","class":"lineCov","hits":"1","order":"349","possible_hits":"1",},
{"lineNum":"   70","line":"}"},
{"lineNum":"   71","line":""},
{"lineNum":"   72","line":"/// This returns a `File` that is configured to block with every write, in order"},
{"lineNum":"   73","line":"/// to facilitate better debugging. This can be changed by modifying the `intended_io_mode` field."},
{"lineNum":"   74","line":"pub fn getStdErr() File {","class":"lineCov","hits":"1","order":"346","possible_hits":"1",},
{"lineNum":"   75","line":"    return File{","class":"lineCov","hits":"1","order":"350","possible_hits":"1",},
{"lineNum":"   76","line":"        .handle = getStdErrHandle(),","class":"lineCov","hits":"1","order":"347","possible_hits":"1",},
{"lineNum":"   77","line":"        .capable_io_mode = .blocking,"},
{"lineNum":"   78","line":"        .intended_io_mode = .blocking,"},
{"lineNum":"   79","line":"    };"},
{"lineNum":"   80","line":"}"},
{"lineNum":"   81","line":""},
{"lineNum":"   82","line":"fn getStdInHandle() os.fd_t {","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   83","line":"    if (builtin.os.tag == .windows) {"},
{"lineNum":"   84","line":"        if (builtin.zig_backend == .stage2_aarch64) {"},
{"lineNum":"   85","line":"            // TODO: this is just a temporary workaround until we advance aarch64 backend further along."},
{"lineNum":"   86","line":"            return os.windows.GetStdHandle(os.windows.STD_INPUT_HANDLE) catch os.windows.INVALID_HANDLE_VALUE;"},
{"lineNum":"   87","line":"        }"},
{"lineNum":"   88","line":"        return os.windows.peb().ProcessParameters.hStdInput;"},
{"lineNum":"   89","line":"    }"},
{"lineNum":"   90","line":""},
{"lineNum":"   91","line":"    if (@hasDecl(root, \"os\") and @hasDecl(root.os, \"io\") and @hasDecl(root.os.io, \"getStdInHandle\")) {"},
{"lineNum":"   92","line":"        return root.os.io.getStdInHandle();"},
{"lineNum":"   93","line":"    }"},
{"lineNum":"   94","line":""},
{"lineNum":"   95","line":"    return os.STDIN_FILENO;","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   96","line":"}"},
{"lineNum":"   97","line":""},
{"lineNum":"   98","line":"/// TODO: async stdin on windows without a dedicated thread."},
{"lineNum":"   99","line":"/// https://github.com/ziglang/zig/pull/4816#issuecomment-604521023"},
{"lineNum":"  100","line":"pub fn getStdIn() File {","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"  101","line":"    return File{","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"  102","line":"        .handle = getStdInHandle(),","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"  103","line":"        .capable_io_mode = .blocking,"},
{"lineNum":"  104","line":"        .intended_io_mode = default_mode,"},
{"lineNum":"  105","line":"    };"},
{"lineNum":"  106","line":"}"},
{"lineNum":"  107","line":""},
{"lineNum":"  108","line":"pub const Reader = @import(\"io/reader.zig\").Reader;"},
{"lineNum":"  109","line":"pub const Writer = @import(\"io/writer.zig\").Writer;"},
{"lineNum":"  110","line":"pub const SeekableStream = @import(\"io/seekable_stream.zig\").SeekableStream;"},
{"lineNum":"  111","line":""},
{"lineNum":"  112","line":"pub const BufferedWriter = @import(\"io/buffered_writer.zig\").BufferedWriter;"},
{"lineNum":"  113","line":"pub const bufferedWriter = @import(\"io/buffered_writer.zig\").bufferedWriter;"},
{"lineNum":"  114","line":""},
{"lineNum":"  115","line":"pub const BufferedReader = @import(\"io/buffered_reader.zig\").BufferedReader;"},
{"lineNum":"  116","line":"pub const bufferedReader = @import(\"io/buffered_reader.zig\").bufferedReader;"},
{"lineNum":"  117","line":"pub const bufferedReaderSize = @import(\"io/buffered_reader.zig\").bufferedReaderSize;"},
{"lineNum":"  118","line":""},
{"lineNum":"  119","line":"pub const PeekStream = @import(\"io/peek_stream.zig\").PeekStream;"},
{"lineNum":"  120","line":"pub const peekStream = @import(\"io/peek_stream.zig\").peekStream;"},
{"lineNum":"  121","line":""},
{"lineNum":"  122","line":"pub const FixedBufferStream = @import(\"io/fixed_buffer_stream.zig\").FixedBufferStream;"},
{"lineNum":"  123","line":"pub const fixedBufferStream = @import(\"io/fixed_buffer_stream.zig\").fixedBufferStream;"},
{"lineNum":"  124","line":""},
{"lineNum":"  125","line":"pub const CWriter = @import(\"io/c_writer.zig\").CWriter;"},
{"lineNum":"  126","line":"pub const cWriter = @import(\"io/c_writer.zig\").cWriter;"},
{"lineNum":"  127","line":""},
{"lineNum":"  128","line":"pub const LimitedReader = @import(\"io/limited_reader.zig\").LimitedReader;"},
{"lineNum":"  129","line":"pub const limitedReader = @import(\"io/limited_reader.zig\").limitedReader;"},
{"lineNum":"  130","line":""},
{"lineNum":"  131","line":"pub const CountingWriter = @import(\"io/counting_writer.zig\").CountingWriter;"},
{"lineNum":"  132","line":"pub const countingWriter = @import(\"io/counting_writer.zig\").countingWriter;"},
{"lineNum":"  133","line":"pub const CountingReader = @import(\"io/counting_reader.zig\").CountingReader;"},
{"lineNum":"  134","line":"pub const countingReader = @import(\"io/counting_reader.zig\").countingReader;"},
{"lineNum":"  135","line":""},
{"lineNum":"  136","line":"pub const MultiWriter = @import(\"io/multi_writer.zig\").MultiWriter;"},
{"lineNum":"  137","line":"pub const multiWriter = @import(\"io/multi_writer.zig\").multiWriter;"},
{"lineNum":"  138","line":""},
{"lineNum":"  139","line":"pub const BitReader = @import(\"io/bit_reader.zig\").BitReader;"},
{"lineNum":"  140","line":"pub const bitReader = @import(\"io/bit_reader.zig\").bitReader;"},
{"lineNum":"  141","line":""},
{"lineNum":"  142","line":"pub const BitWriter = @import(\"io/bit_writer.zig\").BitWriter;"},
{"lineNum":"  143","line":"pub const bitWriter = @import(\"io/bit_writer.zig\").bitWriter;"},
{"lineNum":"  144","line":""},
{"lineNum":"  145","line":"pub const ChangeDetectionStream = @import(\"io/change_detection_stream.zig\").ChangeDetectionStream;"},
{"lineNum":"  146","line":"pub const changeDetectionStream = @import(\"io/change_detection_stream.zig\").changeDetectionStream;"},
{"lineNum":"  147","line":""},
{"lineNum":"  148","line":"pub const FindByteWriter = @import(\"io/find_byte_writer.zig\").FindByteWriter;"},
{"lineNum":"  149","line":"pub const findByteWriter = @import(\"io/find_byte_writer.zig\").findByteWriter;"},
{"lineNum":"  150","line":""},
{"lineNum":"  151","line":"pub const FindByteOutStream = @compileError(\"deprecated; use `FindByteWriter`\");"},
{"lineNum":"  152","line":"pub const findByteOutStream = @compileError(\"deprecated; use `findByteWriter`\");"},
{"lineNum":"  153","line":""},
{"lineNum":"  154","line":"pub const BufferedAtomicFile = @import(\"io/buffered_atomic_file.zig\").BufferedAtomicFile;"},
{"lineNum":"  155","line":""},
{"lineNum":"  156","line":"pub const StreamSource = @import(\"io/stream_source.zig\").StreamSource;"},
{"lineNum":"  157","line":""},
{"lineNum":"  158","line":"/// A Writer that doesn\'t write to anything."},
{"lineNum":"  159","line":"pub const null_writer = @as(NullWriter, .{ .context = {} });"},
{"lineNum":"  160","line":""},
{"lineNum":"  161","line":"const NullWriter = Writer(void, error{}, dummyWrite);"},
{"lineNum":"  162","line":"fn dummyWrite(context: void, data: []const u8) error{}!usize {"},
{"lineNum":"  163","line":"    _ = context;"},
{"lineNum":"  164","line":"    return data.len;"},
{"lineNum":"  165","line":"}"},
{"lineNum":"  166","line":""},
{"lineNum":"  167","line":"test \"null_writer\" {"},
{"lineNum":"  168","line":"    null_writer.writeAll(\"yay\" ** 10) catch |err| switch (err) {};"},
{"lineNum":"  169","line":"}"},
{"lineNum":"  170","line":""},
{"lineNum":"  171","line":"pub fn poll("},
{"lineNum":"  172","line":"    allocator: std.mem.Allocator,"},
{"lineNum":"  173","line":"    comptime StreamEnum: type,"},
{"lineNum":"  174","line":"    files: PollFiles(StreamEnum),"},
{"lineNum":"  175","line":") Poller(StreamEnum) {"},
{"lineNum":"  176","line":"    const enum_fields = @typeInfo(StreamEnum).Enum.fields;"},
{"lineNum":"  177","line":"    var result: Poller(StreamEnum) = undefined;"},
{"lineNum":"  178","line":""},
{"lineNum":"  179","line":"    if (builtin.os.tag == .windows) result.windows = .{"},
{"lineNum":"  180","line":"        .first_read_done = false,"},
{"lineNum":"  181","line":"        .overlapped = [1]os.windows.OVERLAPPED{"},
{"lineNum":"  182","line":"            mem.zeroes(os.windows.OVERLAPPED),"},
{"lineNum":"  183","line":"        } ** enum_fields.len,"},
{"lineNum":"  184","line":"        .active = .{"},
{"lineNum":"  185","line":"            .count = 0,"},
{"lineNum":"  186","line":"            .handles_buf = undefined,"},
{"lineNum":"  187","line":"            .stream_map = undefined,"},
{"lineNum":"  188","line":"        },"},
{"lineNum":"  189","line":"    };"},
{"lineNum":"  190","line":""},
{"lineNum":"  191","line":"    inline for (0..enum_fields.len) |i| {"},
{"lineNum":"  192","line":"        result.fifos[i] = .{"},
{"lineNum":"  193","line":"            .allocator = allocator,"},
{"lineNum":"  194","line":"            .buf = &.{},"},
{"lineNum":"  195","line":"            .head = 0,"},
{"lineNum":"  196","line":"            .count = 0,"},
{"lineNum":"  197","line":"        };"},
{"lineNum":"  198","line":"        if (builtin.os.tag == .windows) {"},
{"lineNum":"  199","line":"            result.windows.active.handles_buf[i] = @field(files, enum_fields[i].name).handle;"},
{"lineNum":"  200","line":"        } else {"},
{"lineNum":"  201","line":"            result.poll_fds[i] = .{"},
{"lineNum":"  202","line":"                .fd = @field(files, enum_fields[i].name).handle,"},
{"lineNum":"  203","line":"                .events = os.POLL.IN,"},
{"lineNum":"  204","line":"                .revents = undefined,"},
{"lineNum":"  205","line":"            };"},
{"lineNum":"  206","line":"        }"},
{"lineNum":"  207","line":"    }"},
{"lineNum":"  208","line":"    return result;"},
{"lineNum":"  209","line":"}"},
{"lineNum":"  210","line":""},
{"lineNum":"  211","line":"pub const PollFifo = std.fifo.LinearFifo(u8, .Dynamic);"},
{"lineNum":"  212","line":""},
{"lineNum":"  213","line":"pub fn Poller(comptime StreamEnum: type) type {"},
{"lineNum":"  214","line":"    return struct {"},
{"lineNum":"  215","line":"        const enum_fields = @typeInfo(StreamEnum).Enum.fields;"},
{"lineNum":"  216","line":"        const PollFd = if (builtin.os.tag == .windows) void else std.os.pollfd;"},
{"lineNum":"  217","line":""},
{"lineNum":"  218","line":"        fifos: [enum_fields.len]PollFifo,"},
{"lineNum":"  219","line":"        poll_fds: [enum_fields.len]PollFd,"},
{"lineNum":"  220","line":"        windows: if (builtin.os.tag == .windows) struct {"},
{"lineNum":"  221","line":"            first_read_done: bool,"},
{"lineNum":"  222","line":"            overlapped: [enum_fields.len]os.windows.OVERLAPPED,"},
{"lineNum":"  223","line":"            active: struct {"},
{"lineNum":"  224","line":"                count: math.IntFittingRange(0, enum_fields.len),"},
{"lineNum":"  225","line":"                handles_buf: [enum_fields.len]os.windows.HANDLE,"},
{"lineNum":"  226","line":"                stream_map: [enum_fields.len]StreamEnum,"},
{"lineNum":"  227","line":""},
{"lineNum":"  228","line":"                pub fn removeAt(self: *@This(), index: u32) void {"},
{"lineNum":"  229","line":"                    std.debug.assert(index < self.count);"},
{"lineNum":"  230","line":"                    for (index + 1..self.count) |i| {"},
{"lineNum":"  231","line":"                        self.handles_buf[i - 1] = self.handles_buf[i];"},
{"lineNum":"  232","line":"                        self.stream_map[i - 1] = self.stream_map[i];"},
{"lineNum":"  233","line":"                    }"},
{"lineNum":"  234","line":"                    self.count -= 1;"},
{"lineNum":"  235","line":"                }"},
{"lineNum":"  236","line":"            },"},
{"lineNum":"  237","line":"        } else void,"},
{"lineNum":"  238","line":""},
{"lineNum":"  239","line":"        const Self = @This();"},
{"lineNum":"  240","line":""},
{"lineNum":"  241","line":"        pub fn deinit(self: *Self) void {"},
{"lineNum":"  242","line":"            if (builtin.os.tag == .windows) {"},
{"lineNum":"  243","line":"                // cancel any pending IO to prevent clobbering OVERLAPPED value"},
{"lineNum":"  244","line":"                for (self.windows.active.handles_buf[0..self.windows.active.count]) |h| {"},
{"lineNum":"  245","line":"                    _ = os.windows.kernel32.CancelIo(h);"},
{"lineNum":"  246","line":"                }"},
{"lineNum":"  247","line":"            }"},
{"lineNum":"  248","line":"            inline for (&self.fifos) |*q| q.deinit();"},
{"lineNum":"  249","line":"            self.* = undefined;"},
{"lineNum":"  250","line":"        }"},
{"lineNum":"  251","line":""},
{"lineNum":"  252","line":"        pub fn poll(self: *Self) !bool {"},
{"lineNum":"  253","line":"            if (builtin.os.tag == .windows) {"},
{"lineNum":"  254","line":"                return pollWindows(self);"},
{"lineNum":"  255","line":"            } else {"},
{"lineNum":"  256","line":"                return pollPosix(self);"},
{"lineNum":"  257","line":"            }"},
{"lineNum":"  258","line":"        }"},
{"lineNum":"  259","line":""},
{"lineNum":"  260","line":"        pub inline fn fifo(self: *Self, comptime which: StreamEnum) *PollFifo {"},
{"lineNum":"  261","line":"            return &self.fifos[@enumToInt(which)];"},
{"lineNum":"  262","line":"        }"},
{"lineNum":"  263","line":""},
{"lineNum":"  264","line":"        fn pollWindows(self: *Self) !bool {"},
{"lineNum":"  265","line":"            const bump_amt = 512;"},
{"lineNum":"  266","line":""},
{"lineNum":"  267","line":"            if (!self.windows.first_read_done) {"},
{"lineNum":"  268","line":"                // Windows Async IO requires an initial call to ReadFile before waiting on the handle"},
{"lineNum":"  269","line":"                for (0..enum_fields.len) |i| {"},
{"lineNum":"  270","line":"                    const handle = self.windows.active.handles_buf[i];"},
{"lineNum":"  271","line":"                    switch (try windowsAsyncRead("},
{"lineNum":"  272","line":"                        handle,"},
{"lineNum":"  273","line":"                        &self.windows.overlapped[i],"},
{"lineNum":"  274","line":"                        &self.fifos[i],"},
{"lineNum":"  275","line":"                        bump_amt,"},
{"lineNum":"  276","line":"                    )) {"},
{"lineNum":"  277","line":"                        .pending => {"},
{"lineNum":"  278","line":"                            self.windows.active.handles_buf[self.windows.active.count] = handle;"},
{"lineNum":"  279","line":"                            self.windows.active.stream_map[self.windows.active.count] = @intToEnum(StreamEnum, i);"},
{"lineNum":"  280","line":"                            self.windows.active.count += 1;"},
{"lineNum":"  281","line":"                        },"},
{"lineNum":"  282","line":"                        .closed => {}, // don\'t add to the wait_objects list"},
{"lineNum":"  283","line":"                    }"},
{"lineNum":"  284","line":"                }"},
{"lineNum":"  285","line":"                self.windows.first_read_done = true;"},
{"lineNum":"  286","line":"            }"},
{"lineNum":"  287","line":""},
{"lineNum":"  288","line":"            while (true) {"},
{"lineNum":"  289","line":"                if (self.windows.active.count == 0) return false;"},
{"lineNum":"  290","line":""},
{"lineNum":"  291","line":"                const status = os.windows.kernel32.WaitForMultipleObjects("},
{"lineNum":"  292","line":"                    self.windows.active.count,"},
{"lineNum":"  293","line":"                    &self.windows.active.handles_buf,"},
{"lineNum":"  294","line":"                    0,"},
{"lineNum":"  295","line":"                    os.windows.INFINITE,"},
{"lineNum":"  296","line":"                );"},
{"lineNum":"  297","line":"                if (status == os.windows.WAIT_FAILED)"},
{"lineNum":"  298","line":"                    return os.windows.unexpectedError(os.windows.kernel32.GetLastError());"},
{"lineNum":"  299","line":""},
{"lineNum":"  300","line":"                if (status < os.windows.WAIT_OBJECT_0 or status > os.windows.WAIT_OBJECT_0 + enum_fields.len - 1)"},
{"lineNum":"  301","line":"                    unreachable;"},
{"lineNum":"  302","line":""},
{"lineNum":"  303","line":"                const active_idx = status - os.windows.WAIT_OBJECT_0;"},
{"lineNum":"  304","line":""},
{"lineNum":"  305","line":"                const handle = self.windows.active.handles_buf[active_idx];"},
{"lineNum":"  306","line":"                const stream_idx = @enumToInt(self.windows.active.stream_map[active_idx]);"},
{"lineNum":"  307","line":"                var read_bytes: u32 = undefined;"},
{"lineNum":"  308","line":"                if (0 == os.windows.kernel32.GetOverlappedResult("},
{"lineNum":"  309","line":"                    handle,"},
{"lineNum":"  310","line":"                    &self.windows.overlapped[stream_idx],"},
{"lineNum":"  311","line":"                    &read_bytes,"},
{"lineNum":"  312","line":"                    0,"},
{"lineNum":"  313","line":"                )) switch (os.windows.kernel32.GetLastError()) {"},
{"lineNum":"  314","line":"                    .BROKEN_PIPE => {"},
{"lineNum":"  315","line":"                        self.windows.active.removeAt(active_idx);"},
{"lineNum":"  316","line":"                        continue;"},
{"lineNum":"  317","line":"                    },"},
{"lineNum":"  318","line":"                    else => |err| return os.windows.unexpectedError(err),"},
{"lineNum":"  319","line":"                };"},
{"lineNum":"  320","line":""},
{"lineNum":"  321","line":"                self.fifos[stream_idx].update(read_bytes);"},
{"lineNum":"  322","line":""},
{"lineNum":"  323","line":"                switch (try windowsAsyncRead("},
{"lineNum":"  324","line":"                    handle,"},
{"lineNum":"  325","line":"                    &self.windows.overlapped[stream_idx],"},
{"lineNum":"  326","line":"                    &self.fifos[stream_idx],"},
{"lineNum":"  327","line":"                    bump_amt,"},
{"lineNum":"  328","line":"                )) {"},
{"lineNum":"  329","line":"                    .pending => {},"},
{"lineNum":"  330","line":"                    .closed => self.windows.active.removeAt(active_idx),"},
{"lineNum":"  331","line":"                }"},
{"lineNum":"  332","line":"                return true;"},
{"lineNum":"  333","line":"            }"},
{"lineNum":"  334","line":"        }"},
{"lineNum":"  335","line":""},
{"lineNum":"  336","line":"        fn pollPosix(self: *Self) !bool {"},
{"lineNum":"  337","line":"            // We ask for ensureUnusedCapacity with this much extra space. This"},
{"lineNum":"  338","line":"            // has more of an effect on small reads because once the reads"},
{"lineNum":"  339","line":"            // start to get larger the amount of space an ArrayList will"},
{"lineNum":"  340","line":"            // allocate grows exponentially."},
{"lineNum":"  341","line":"            const bump_amt = 512;"},
{"lineNum":"  342","line":""},
{"lineNum":"  343","line":"            const err_mask = os.POLL.ERR | os.POLL.NVAL | os.POLL.HUP;"},
{"lineNum":"  344","line":""},
{"lineNum":"  345","line":"            const events_len = try os.poll(&self.poll_fds, std.math.maxInt(i32));"},
{"lineNum":"  346","line":"            if (events_len == 0) {"},
{"lineNum":"  347","line":"                for (self.poll_fds) |poll_fd| {"},
{"lineNum":"  348","line":"                    if (poll_fd.fd != -1) return true;"},
{"lineNum":"  349","line":"                } else return false;"},
{"lineNum":"  350","line":"            }"},
{"lineNum":"  351","line":""},
{"lineNum":"  352","line":"            var keep_polling = false;"},
{"lineNum":"  353","line":"            inline for (&self.poll_fds, &self.fifos) |*poll_fd, *q| {"},
{"lineNum":"  354","line":"                // Try reading whatever is available before checking the error"},
{"lineNum":"  355","line":"                // conditions."},
{"lineNum":"  356","line":"                // It\'s still possible to read after a POLL.HUP is received,"},
{"lineNum":"  357","line":"                // always check if there\'s some data waiting to be read first."},
{"lineNum":"  358","line":"                if (poll_fd.revents & os.POLL.IN != 0) {"},
{"lineNum":"  359","line":"                    const buf = try q.writableWithSize(bump_amt);"},
{"lineNum":"  360","line":"                    const amt = try os.read(poll_fd.fd, buf);"},
{"lineNum":"  361","line":"                    q.update(amt);"},
{"lineNum":"  362","line":"                    if (amt == 0) {"},
{"lineNum":"  363","line":"                        // Remove the fd when the EOF condition is met."},
{"lineNum":"  364","line":"                        poll_fd.fd = -1;"},
{"lineNum":"  365","line":"                    } else {"},
{"lineNum":"  366","line":"                        keep_polling = true;"},
{"lineNum":"  367","line":"                    }"},
{"lineNum":"  368","line":"                } else if (poll_fd.revents & err_mask != 0) {"},
{"lineNum":"  369","line":"                    // Exclude the fds that signaled an error."},
{"lineNum":"  370","line":"                    poll_fd.fd = -1;"},
{"lineNum":"  371","line":"                } else if (poll_fd.fd != -1) {"},
{"lineNum":"  372","line":"                    keep_polling = true;"},
{"lineNum":"  373","line":"                }"},
{"lineNum":"  374","line":"            }"},
{"lineNum":"  375","line":"            return keep_polling;"},
{"lineNum":"  376","line":"        }"},
{"lineNum":"  377","line":"    };"},
{"lineNum":"  378","line":"}"},
{"lineNum":"  379","line":""},
{"lineNum":"  380","line":"fn windowsAsyncRead("},
{"lineNum":"  381","line":"    handle: os.windows.HANDLE,"},
{"lineNum":"  382","line":"    overlapped: *os.windows.OVERLAPPED,"},
{"lineNum":"  383","line":"    fifo: *PollFifo,"},
{"lineNum":"  384","line":"    bump_amt: usize,"},
{"lineNum":"  385","line":") !enum { pending, closed } {"},
{"lineNum":"  386","line":"    while (true) {"},
{"lineNum":"  387","line":"        const buf = try fifo.writableWithSize(bump_amt);"},
{"lineNum":"  388","line":"        var read_bytes: u32 = undefined;"},
{"lineNum":"  389","line":"        const read_result = os.windows.kernel32.ReadFile(handle, buf.ptr, math.cast(u32, buf.len) orelse math.maxInt(u32), &read_bytes, overlapped);"},
{"lineNum":"  390","line":"        if (read_result == 0) return switch (os.windows.kernel32.GetLastError()) {"},
{"lineNum":"  391","line":"            .IO_PENDING => .pending,"},
{"lineNum":"  392","line":"            .BROKEN_PIPE => .closed,"},
{"lineNum":"  393","line":"            else => |err| os.windows.unexpectedError(err),"},
{"lineNum":"  394","line":"        };"},
{"lineNum":"  395","line":"        fifo.update(read_bytes);"},
{"lineNum":"  396","line":"    }"},
{"lineNum":"  397","line":"}"},
{"lineNum":"  398","line":""},
{"lineNum":"  399","line":"/// Given an enum, returns a struct with fields of that enum, each field"},
{"lineNum":"  400","line":"/// representing an I/O stream for polling."},
{"lineNum":"  401","line":"pub fn PollFiles(comptime StreamEnum: type) type {"},
{"lineNum":"  402","line":"    const enum_fields = @typeInfo(StreamEnum).Enum.fields;"},
{"lineNum":"  403","line":"    var struct_fields: [enum_fields.len]std.builtin.Type.StructField = undefined;"},
{"lineNum":"  404","line":"    for (&struct_fields, enum_fields) |*struct_field, enum_field| {"},
{"lineNum":"  405","line":"        struct_field.* = .{"},
{"lineNum":"  406","line":"            .name = enum_field.name,"},
{"lineNum":"  407","line":"            .type = fs.File,"},
{"lineNum":"  408","line":"            .default_value = null,"},
{"lineNum":"  409","line":"            .is_comptime = false,"},
{"lineNum":"  410","line":"            .alignment = @alignOf(fs.File),"},
{"lineNum":"  411","line":"        };"},
{"lineNum":"  412","line":"    }"},
{"lineNum":"  413","line":"    return @Type(.{ .Struct = .{"},
{"lineNum":"  414","line":"        .layout = .Auto,"},
{"lineNum":"  415","line":"        .fields = &struct_fields,"},
{"lineNum":"  416","line":"        .decls = &.{},"},
{"lineNum":"  417","line":"        .is_tuple = false,"},
{"lineNum":"  418","line":"    } });"},
{"lineNum":"  419","line":"}"},
{"lineNum":"  420","line":""},
{"lineNum":"  421","line":"test {"},
{"lineNum":"  422","line":"    _ = @import(\"io/bit_reader.zig\");"},
{"lineNum":"  423","line":"    _ = @import(\"io/bit_writer.zig\");"},
{"lineNum":"  424","line":"    _ = @import(\"io/buffered_atomic_file.zig\");"},
{"lineNum":"  425","line":"    _ = @import(\"io/buffered_reader.zig\");"},
{"lineNum":"  426","line":"    _ = @import(\"io/buffered_writer.zig\");"},
{"lineNum":"  427","line":"    _ = @import(\"io/c_writer.zig\");"},
{"lineNum":"  428","line":"    _ = @import(\"io/counting_writer.zig\");"},
{"lineNum":"  429","line":"    _ = @import(\"io/counting_reader.zig\");"},
{"lineNum":"  430","line":"    _ = @import(\"io/fixed_buffer_stream.zig\");"},
{"lineNum":"  431","line":"    _ = @import(\"io/reader.zig\");"},
{"lineNum":"  432","line":"    _ = @import(\"io/writer.zig\");"},
{"lineNum":"  433","line":"    _ = @import(\"io/peek_stream.zig\");"},
{"lineNum":"  434","line":"    _ = @import(\"io/seekable_stream.zig\");"},
{"lineNum":"  435","line":"    _ = @import(\"io/stream_source.zig\");"},
{"lineNum":"  436","line":"    _ = @import(\"io/test.zig\");"},
{"lineNum":"  437","line":"}"},
]};
var percent_low = 25;var percent_high = 75;
var header = { "command" : "test", "date" : "2023-04-18 20:41:50", "instrumented" : 15, "covered" : 5,};
var merged_data = [];
