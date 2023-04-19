var data = {lines:[
{"lineNum":"    1","line":"const std = @import(\"std\");"},
{"lineNum":"    2","line":"const assert = std.debug.assert;"},
{"lineNum":"    3","line":""},
{"lineNum":"    4","line":"/// A variable length collection of characters"},
{"lineNum":"    5","line":"pub const String = struct {"},
{"lineNum":"    6","line":"    /// The internal character buffer"},
{"lineNum":"    7","line":"    buffer: ?[]u8,"},
{"lineNum":"    8","line":"    /// The allocator used for managing the buffer"},
{"lineNum":"    9","line":"    allocator: std.mem.Allocator,"},
{"lineNum":"   10","line":"    /// The total size of the String"},
{"lineNum":"   11","line":"    size: usize,"},
{"lineNum":"   12","line":""},
{"lineNum":"   13","line":"    /// Errors that may occur when using String"},
{"lineNum":"   14","line":"    pub const Error = error{"},
{"lineNum":"   15","line":"        OutOfMemory,"},
{"lineNum":"   16","line":"        InvalidRange,"},
{"lineNum":"   17","line":"    };"},
{"lineNum":"   18","line":""},
{"lineNum":"   19","line":"    /// Creates a String with an Allocator"},
{"lineNum":"   20","line":"    /// User is responsible for managing the new String"},
{"lineNum":"   21","line":"    pub fn init(allocator: std.mem.Allocator) String {","class":"lineCov","hits":"1","order":"1487","possible_hits":"1",},
{"lineNum":"   22","line":"        return .{","class":"lineCov","hits":"1","order":"1488","possible_hits":"1",},
{"lineNum":"   23","line":"            .buffer = null,"},
{"lineNum":"   24","line":"            .allocator = allocator,"},
{"lineNum":"   25","line":"            .size = 0,"},
{"lineNum":"   26","line":"        };"},
{"lineNum":"   27","line":"    }"},
{"lineNum":"   28","line":""},
{"lineNum":"   29","line":"    pub fn init_with_contents(allocator: std.mem.Allocator, contents: []const u8) Error!String {"},
{"lineNum":"   30","line":"        var string = init(allocator);"},
{"lineNum":"   31","line":""},
{"lineNum":"   32","line":"        try string.concat(contents);"},
{"lineNum":"   33","line":""},
{"lineNum":"   34","line":"        return string;"},
{"lineNum":"   35","line":"    }"},
{"lineNum":"   36","line":""},
{"lineNum":"   37","line":"    /// Deallocates the internal buffer"},
{"lineNum":"   38","line":"    pub fn deinit(self: *String) void {","class":"lineCov","hits":"1","order":"1592","possible_hits":"1",},
{"lineNum":"   39","line":"        if (self.buffer) |buffer| self.allocator.free(buffer);","class":"lineCov","hits":"1","order":"1593","possible_hits":"1",},
{"lineNum":"   40","line":"    }"},
{"lineNum":"   41","line":""},
{"lineNum":"   42","line":"    /// Returns the size of the internal buffer"},
{"lineNum":"   43","line":"    pub fn capacity(self: String) usize {"},
{"lineNum":"   44","line":"        if (self.buffer) |buffer| return buffer.len;"},
{"lineNum":"   45","line":"        return 0;"},
{"lineNum":"   46","line":"    }"},
{"lineNum":"   47","line":""},
{"lineNum":"   48","line":"    /// Allocates space for the internal buffer"},
{"lineNum":"   49","line":"    pub fn allocate(self: *String, bytes: usize) Error!void {","class":"lineCov","hits":"1","order":"1499","possible_hits":"1",},
{"lineNum":"   50","line":"        if (self.buffer) |buffer| {","class":"lineCov","hits":"1","order":"1500","possible_hits":"1",},
{"lineNum":"   51","line":"            if (bytes < self.size) self.size = bytes; // Clamp size to capacity","class":"linePartCov","hits":"1","order":"1525","possible_hits":"2",},
{"lineNum":"   52","line":"            self.buffer = self.allocator.realloc(buffer, bytes) catch {","class":"lineCov","hits":"1","order":"1526","possible_hits":"1",},
{"lineNum":"   53","line":"                return Error.OutOfMemory;","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   54","line":"            };"},
{"lineNum":"   55","line":"        } else {"},
{"lineNum":"   56","line":"            self.buffer = self.allocator.alloc(u8, bytes) catch {","class":"lineCov","hits":"2","order":"1501","possible_hits":"2",},
{"lineNum":"   57","line":"                return Error.OutOfMemory;","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   58","line":"            };"},
{"lineNum":"   59","line":"        }"},
{"lineNum":"   60","line":"    }"},
{"lineNum":"   61","line":""},
{"lineNum":"   62","line":"    /// Reallocates the the internal buffer to size"},
{"lineNum":"   63","line":"    pub fn truncate(self: *String) Error!void {"},
{"lineNum":"   64","line":"        try self.allocate(self.size);"},
{"lineNum":"   65","line":"    }"},
{"lineNum":"   66","line":""},
{"lineNum":"   67","line":"    /// Appends a character onto the end of the String"},
{"lineNum":"   68","line":"    pub fn concat(self: *String, char: []const u8) Error!void {","class":"lineCov","hits":"1","order":"1571","possible_hits":"1",},
{"lineNum":"   69","line":"        try self.insert(char, self.len());","class":"lineCov","hits":"1","order":"1572","possible_hits":"1",},
{"lineNum":"   70","line":"    }"},
{"lineNum":"   71","line":""},
{"lineNum":"   72","line":"    /// Inserts a string literal into the String at an index"},
{"lineNum":"   73","line":"    pub fn insert(self: *String, literal: []const u8, index: usize) Error!void {","class":"lineCov","hits":"1","order":"1496","possible_hits":"1",},
{"lineNum":"   74","line":"        // Make sure buffer has enough space"},
{"lineNum":"   75","line":"        if (self.buffer) |buffer| {","class":"lineCov","hits":"1","order":"1497","possible_hits":"1",},
{"lineNum":"   76","line":"            if (self.size + literal.len > buffer.len) {","class":"lineCov","hits":"2","order":"1522","possible_hits":"2",},
{"lineNum":"   77","line":"                try self.allocate((self.size + literal.len) * 2);","class":"lineCov","hits":"1","order":"1524","possible_hits":"1",},
{"lineNum":"   78","line":"            }"},
{"lineNum":"   79","line":"        } else {"},
{"lineNum":"   80","line":"            try self.allocate((literal.len) * 2);","class":"lineCov","hits":"2","order":"1498","possible_hits":"2",},
{"lineNum":"   81","line":"        }"},
{"lineNum":"   82","line":""},
{"lineNum":"   83","line":"        const buffer = self.buffer.?;","class":"lineCov","hits":"1","order":"1504","possible_hits":"1",},
{"lineNum":"   84","line":""},
{"lineNum":"   85","line":"        // If the index is >= len, then simply push to the end."},
{"lineNum":"   86","line":"        // If not, then copy contents over and insert literal."},
{"lineNum":"   87","line":"        if (index == self.len()) {","class":"lineCov","hits":"1","order":"1505","possible_hits":"1",},
{"lineNum":"   88","line":"            var i: usize = 0;","class":"lineCov","hits":"1","order":"1511","possible_hits":"1",},
{"lineNum":"   89","line":"            while (i < literal.len) : (i += 1) {","class":"lineCov","hits":"3","order":"1512","possible_hits":"3",},
{"lineNum":"   90","line":"                buffer[self.size + i] = literal[i];","class":"lineCov","hits":"2","order":"1513","possible_hits":"2",},
{"lineNum":"   91","line":"            }"},
{"lineNum":"   92","line":"        } else {"},
{"lineNum":"   93","line":"            if (String.getIndex(buffer, index, true)) |k| {","class":"lineNoCov","hits":"0","possible_hits":"2",},
{"lineNum":"   94","line":"                // Move existing contents over"},
{"lineNum":"   95","line":"                var i: usize = buffer.len - 1;","class":"lineNoCov","hits":"0","possible_hits":"2",},
{"lineNum":"   96","line":"                while (i >= k) : (i -= 1) {","class":"lineNoCov","hits":"0","possible_hits":"3",},
{"lineNum":"   97","line":"                    if (i + literal.len < buffer.len) {","class":"lineNoCov","hits":"0","possible_hits":"2",},
{"lineNum":"   98","line":"                        buffer[i + literal.len] = buffer[i];","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"   99","line":"                    }"},
{"lineNum":"  100","line":""},
{"lineNum":"  101","line":"                    if (i == 0) break;","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"  102","line":"                }"},
{"lineNum":"  103","line":""},
{"lineNum":"  104","line":"                i = 0;","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"  105","line":"                while (i < literal.len) : (i += 1) {","class":"lineNoCov","hits":"0","possible_hits":"4",},
{"lineNum":"  106","line":"                    buffer[index + i] = literal[i];","class":"lineNoCov","hits":"0","possible_hits":"2",},
{"lineNum":"  107","line":"                }"},
{"lineNum":"  108","line":"            }"},
{"lineNum":"  109","line":"        }"},
{"lineNum":"  110","line":""},
{"lineNum":"  111","line":"        self.size += literal.len;","class":"lineCov","hits":"1","order":"1514","possible_hits":"1",},
{"lineNum":"  112","line":"    }"},
{"lineNum":"  113","line":""},
{"lineNum":"  114","line":"    /// Removes the last character from the String"},
{"lineNum":"  115","line":"    pub fn pop(self: *String) ?[]const u8 {"},
{"lineNum":"  116","line":"        if (self.size == 0) return null;"},
{"lineNum":"  117","line":""},
{"lineNum":"  118","line":"        if (self.buffer) |buffer| {"},
{"lineNum":"  119","line":"            var i: usize = 0;"},
{"lineNum":"  120","line":"            while (i < self.size) {"},
{"lineNum":"  121","line":"                const size = String.getUTF8Size(buffer[i]);"},
{"lineNum":"  122","line":"                if (i + size >= self.size) break;"},
{"lineNum":"  123","line":"                i += size;"},
{"lineNum":"  124","line":"            }"},
{"lineNum":"  125","line":""},
{"lineNum":"  126","line":"            const ret = buffer[i..self.size];"},
{"lineNum":"  127","line":"            self.size -= (self.size - i);"},
{"lineNum":"  128","line":"            return ret;"},
{"lineNum":"  129","line":"        }"},
{"lineNum":"  130","line":""},
{"lineNum":"  131","line":"        return null;"},
{"lineNum":"  132","line":"    }"},
{"lineNum":"  133","line":""},
{"lineNum":"  134","line":"    /// Compares this String with a string literal"},
{"lineNum":"  135","line":"    pub fn cmp(self: String, literal: []const u8) bool {"},
{"lineNum":"  136","line":"        if (self.buffer) |buffer| {"},
{"lineNum":"  137","line":"            return std.mem.eql(u8, buffer[0..self.size], literal);"},
{"lineNum":"  138","line":"        }"},
{"lineNum":"  139","line":"        return false;"},
{"lineNum":"  140","line":"    }"},
{"lineNum":"  141","line":""},
{"lineNum":"  142","line":"    /// Returns the String as a string literal"},
{"lineNum":"  143","line":"    pub fn str(self: String) []const u8 {","class":"lineCov","hits":"1","order":"1577","possible_hits":"1",},
{"lineNum":"  144","line":"        if (self.buffer) |buffer| return buffer[0..self.size];","class":"lineCov","hits":"1","order":"1578","possible_hits":"1",},
{"lineNum":"  145","line":"        return \"\";","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"  146","line":"    }"},
{"lineNum":"  147","line":""},
{"lineNum":"  148","line":"    /// Returns an owned slice of this string"},
{"lineNum":"  149","line":"    pub fn toOwned(self: String) Error!?[]u8 {"},
{"lineNum":"  150","line":"        if (self.buffer != null) {"},
{"lineNum":"  151","line":"            const string = self.str();"},
{"lineNum":"  152","line":"            if (self.allocator.alloc(u8, string.len)) |newStr| {"},
{"lineNum":"  153","line":"                std.mem.copy(u8, newStr, string);"},
{"lineNum":"  154","line":"                return newStr;"},
{"lineNum":"  155","line":"            } else |_| {"},
{"lineNum":"  156","line":"                return Error.OutOfMemory;"},
{"lineNum":"  157","line":"            }"},
{"lineNum":"  158","line":"        }"},
{"lineNum":"  159","line":""},
{"lineNum":"  160","line":"        return null;"},
{"lineNum":"  161","line":"    }"},
{"lineNum":"  162","line":""},
{"lineNum":"  163","line":"    /// Returns a character at the specified index"},
{"lineNum":"  164","line":"    pub fn charAt(self: String, index: usize) ?[]const u8 {"},
{"lineNum":"  165","line":"        if (self.buffer) |buffer| {"},
{"lineNum":"  166","line":"            if (String.getIndex(buffer, index, true)) |i| {"},
{"lineNum":"  167","line":"                const size = String.getUTF8Size(buffer[i]);"},
{"lineNum":"  168","line":"                return buffer[i..(i + size)];"},
{"lineNum":"  169","line":"            }"},
{"lineNum":"  170","line":"        }"},
{"lineNum":"  171","line":"        return null;"},
{"lineNum":"  172","line":"    }"},
{"lineNum":"  173","line":""},
{"lineNum":"  174","line":"    /// Returns amount of characters in the String"},
{"lineNum":"  175","line":"    pub fn len(self: String) usize {","class":"lineCov","hits":"1","order":"1493","possible_hits":"1",},
{"lineNum":"  176","line":"        if (self.buffer) |buffer| {","class":"lineCov","hits":"1","order":"1494","possible_hits":"1",},
{"lineNum":"  177","line":"            var length: usize = 0;","class":"lineCov","hits":"1","order":"1506","possible_hits":"1",},
{"lineNum":"  178","line":"            var i: usize = 0;","class":"lineCov","hits":"1","order":"1507","possible_hits":"1",},
{"lineNum":"  179","line":""},
{"lineNum":"  180","line":"            while (i < self.size) {","class":"lineCov","hits":"1","order":"1508","possible_hits":"1",},
{"lineNum":"  181","line":"                i += String.getUTF8Size(buffer[i]);","class":"lineCov","hits":"3","order":"1518","possible_hits":"3",},
{"lineNum":"  182","line":"                length += 1;","class":"lineCov","hits":"2","order":"1509","possible_hits":"2",},
{"lineNum":"  183","line":"            }"},
{"lineNum":"  184","line":""},
{"lineNum":"  185","line":"            return length;","class":"lineCov","hits":"1","order":"1510","possible_hits":"1",},
{"lineNum":"  186","line":"        } else {"},
{"lineNum":"  187","line":"            return 0;","class":"lineCov","hits":"1","order":"1495","possible_hits":"1",},
{"lineNum":"  188","line":"        }"},
{"lineNum":"  189","line":"    }"},
{"lineNum":"  190","line":""},
{"lineNum":"  191","line":"    /// Finds the first occurrence of the string literal"},
{"lineNum":"  192","line":"    pub fn find(self: String, literal: []const u8) ?usize {"},
{"lineNum":"  193","line":"        if (self.buffer) |buffer| {"},
{"lineNum":"  194","line":"            const index = std.mem.indexOf(u8, buffer[0..self.size], literal);"},
{"lineNum":"  195","line":"            if (index) |i| {"},
{"lineNum":"  196","line":"                return String.getIndex(buffer, i, false);"},
{"lineNum":"  197","line":"            }"},
{"lineNum":"  198","line":"        }"},
{"lineNum":"  199","line":""},
{"lineNum":"  200","line":"        return null;"},
{"lineNum":"  201","line":"    }"},
{"lineNum":"  202","line":""},
{"lineNum":"  203","line":"    /// Removes a character at the specified index"},
{"lineNum":"  204","line":"    pub fn remove(self: *String, index: usize) Error!void {"},
{"lineNum":"  205","line":"        try self.removeRange(index, index + 1);"},
{"lineNum":"  206","line":"    }"},
{"lineNum":"  207","line":""},
{"lineNum":"  208","line":"    /// Removes a range of character from the String"},
{"lineNum":"  209","line":"    /// Start (inclusive) - End (Exclusive)"},
{"lineNum":"  210","line":"    pub fn removeRange(self: *String, start: usize, end: usize) Error!void {"},
{"lineNum":"  211","line":"        const length = self.len();"},
{"lineNum":"  212","line":"        if (end < start or end > length) return Error.InvalidRange;"},
{"lineNum":"  213","line":""},
{"lineNum":"  214","line":"        if (self.buffer) |buffer| {"},
{"lineNum":"  215","line":"            const rStart = String.getIndex(buffer, start, true).?;"},
{"lineNum":"  216","line":"            const rEnd = String.getIndex(buffer, end, true).?;"},
{"lineNum":"  217","line":"            const difference = rEnd - rStart;"},
{"lineNum":"  218","line":""},
{"lineNum":"  219","line":"            var i: usize = rEnd;"},
{"lineNum":"  220","line":"            while (i < self.size) : (i += 1) {"},
{"lineNum":"  221","line":"                buffer[i - difference] = buffer[i];"},
{"lineNum":"  222","line":"            }"},
{"lineNum":"  223","line":""},
{"lineNum":"  224","line":"            self.size -= difference;"},
{"lineNum":"  225","line":"        }"},
{"lineNum":"  226","line":"    }"},
{"lineNum":"  227","line":""},
{"lineNum":"  228","line":"    /// Trims all whitelist characters at the start of the String."},
{"lineNum":"  229","line":"    pub fn trimStart(self: *String, whitelist: []const u8) void {"},
{"lineNum":"  230","line":"        if (self.buffer) |buffer| {"},
{"lineNum":"  231","line":"            var i: usize = 0;"},
{"lineNum":"  232","line":"            while (i < self.size) : (i += 1) {"},
{"lineNum":"  233","line":"                const size = String.getUTF8Size(buffer[i]);"},
{"lineNum":"  234","line":"                if (size > 1 or !inWhitelist(buffer[i], whitelist)) break;"},
{"lineNum":"  235","line":"            }"},
{"lineNum":"  236","line":""},
{"lineNum":"  237","line":"            if (String.getIndex(buffer, i, false)) |k| {"},
{"lineNum":"  238","line":"                self.removeRange(0, k) catch {};"},
{"lineNum":"  239","line":"            }"},
{"lineNum":"  240","line":"        }"},
{"lineNum":"  241","line":"    }"},
{"lineNum":"  242","line":""},
{"lineNum":"  243","line":"    /// Trims all whitelist characters at the end of the String."},
{"lineNum":"  244","line":"    pub fn trimEnd(self: *String, whitelist: []const u8) void {"},
{"lineNum":"  245","line":"        self.reverse();"},
{"lineNum":"  246","line":"        self.trimStart(whitelist);"},
{"lineNum":"  247","line":"        self.reverse();"},
{"lineNum":"  248","line":"    }"},
{"lineNum":"  249","line":""},
{"lineNum":"  250","line":"    /// Trims all whitelist characters from both ends of the String"},
{"lineNum":"  251","line":"    pub fn trim(self: *String, whitelist: []const u8) void {"},
{"lineNum":"  252","line":"        self.trimStart(whitelist);"},
{"lineNum":"  253","line":"        self.trimEnd(whitelist);"},
{"lineNum":"  254","line":"    }"},
{"lineNum":"  255","line":""},
{"lineNum":"  256","line":"    /// Copies this String into a new one"},
{"lineNum":"  257","line":"    /// User is responsible for managing the new String"},
{"lineNum":"  258","line":"    pub fn clone(self: String) Error!String {"},
{"lineNum":"  259","line":"        var newString = String.init(self.allocator);"},
{"lineNum":"  260","line":"        try newString.concat(self.str());"},
{"lineNum":"  261","line":"        return newString;"},
{"lineNum":"  262","line":"    }"},
{"lineNum":"  263","line":""},
{"lineNum":"  264","line":"    /// Reverses the characters in this String"},
{"lineNum":"  265","line":"    pub fn reverse(self: *String) void {"},
{"lineNum":"  266","line":"        if (self.buffer) |buffer| {"},
{"lineNum":"  267","line":"            var i: usize = 0;"},
{"lineNum":"  268","line":"            while (i < self.size) {"},
{"lineNum":"  269","line":"                const size = String.getUTF8Size(buffer[i]);"},
{"lineNum":"  270","line":"                if (size > 1) std.mem.reverse(u8, buffer[i..(i + size)]);"},
{"lineNum":"  271","line":"                i += size;"},
{"lineNum":"  272","line":"            }"},
{"lineNum":"  273","line":""},
{"lineNum":"  274","line":"            std.mem.reverse(u8, buffer[0..self.size]);"},
{"lineNum":"  275","line":"        }"},
{"lineNum":"  276","line":"    }"},
{"lineNum":"  277","line":""},
{"lineNum":"  278","line":"    /// Repeats this String n times"},
{"lineNum":"  279","line":"    pub fn repeat(self: *String, n: usize) Error!void {"},
{"lineNum":"  280","line":"        try self.allocate(self.size * (n + 1));"},
{"lineNum":"  281","line":"        if (self.buffer) |buffer| {"},
{"lineNum":"  282","line":"            var i: usize = 1;"},
{"lineNum":"  283","line":"            while (i <= n) : (i += 1) {"},
{"lineNum":"  284","line":"                var j: usize = 0;"},
{"lineNum":"  285","line":"                while (j < self.size) : (j += 1) {"},
{"lineNum":"  286","line":"                    buffer[((i * self.size) + j)] = buffer[j];"},
{"lineNum":"  287","line":"                }"},
{"lineNum":"  288","line":"            }"},
{"lineNum":"  289","line":""},
{"lineNum":"  290","line":"            self.size *= (n + 1);"},
{"lineNum":"  291","line":"        }"},
{"lineNum":"  292","line":"    }"},
{"lineNum":"  293","line":""},
{"lineNum":"  294","line":"    /// Checks the String is empty"},
{"lineNum":"  295","line":"    pub inline fn isEmpty(self: String) bool {"},
{"lineNum":"  296","line":"        return self.size == 0;"},
{"lineNum":"  297","line":"    }"},
{"lineNum":"  298","line":""},
{"lineNum":"  299","line":"    /// Splits the String into a slice, based on a delimiter and an index"},
{"lineNum":"  300","line":"    pub fn split(self: *const String, delimiters: []const u8, index: usize) ?[]const u8 {"},
{"lineNum":"  301","line":"        if (self.buffer) |buffer| {"},
{"lineNum":"  302","line":"            var i: usize = 0;"},
{"lineNum":"  303","line":"            var block: usize = 0;"},
{"lineNum":"  304","line":"            var start: usize = 0;"},
{"lineNum":"  305","line":""},
{"lineNum":"  306","line":"            while (i < self.size) {"},
{"lineNum":"  307","line":"                const size = String.getUTF8Size(buffer[i]);"},
{"lineNum":"  308","line":"                if (size == delimiters.len) {"},
{"lineNum":"  309","line":"                    if (std.mem.eql(u8, delimiters, buffer[i..(i + size)])) {"},
{"lineNum":"  310","line":"                        if (block == index) return buffer[start..i];"},
{"lineNum":"  311","line":"                        start = i + size;"},
{"lineNum":"  312","line":"                        block += 1;"},
{"lineNum":"  313","line":"                    }"},
{"lineNum":"  314","line":"                }"},
{"lineNum":"  315","line":""},
{"lineNum":"  316","line":"                i += size;"},
{"lineNum":"  317","line":"            }"},
{"lineNum":"  318","line":""},
{"lineNum":"  319","line":"            if (i >= self.size - 1 and block == index) {"},
{"lineNum":"  320","line":"                return buffer[start..self.size];"},
{"lineNum":"  321","line":"            }"},
{"lineNum":"  322","line":"        }"},
{"lineNum":"  323","line":""},
{"lineNum":"  324","line":"        return null;"},
{"lineNum":"  325","line":"    }"},
{"lineNum":"  326","line":""},
{"lineNum":"  327","line":"    /// Splits the String into a new string, based on delimiters and an index"},
{"lineNum":"  328","line":"    /// The user of this function is in charge of the memory of the new String."},
{"lineNum":"  329","line":"    pub fn splitToString(self: *const String, delimiters: []const u8, index: usize) Error!?String {"},
{"lineNum":"  330","line":"        if (self.split(delimiters, index)) |block| {"},
{"lineNum":"  331","line":"            var string = String.init(self.allocator);"},
{"lineNum":"  332","line":"            try string.concat(block);"},
{"lineNum":"  333","line":"            return string;"},
{"lineNum":"  334","line":"        }"},
{"lineNum":"  335","line":""},
{"lineNum":"  336","line":"        return null;"},
{"lineNum":"  337","line":"    }"},
{"lineNum":"  338","line":""},
{"lineNum":"  339","line":"    /// Clears the contents of the String but leaves the capacity"},
{"lineNum":"  340","line":"    pub fn clear(self: *String) void {"},
{"lineNum":"  341","line":"        if (self.buffer) |buffer| {"},
{"lineNum":"  342","line":"            for (buffer) |*ch| ch.* = 0;"},
{"lineNum":"  343","line":"            self.size = 0;"},
{"lineNum":"  344","line":"        }"},
{"lineNum":"  345","line":"    }"},
{"lineNum":"  346","line":""},
{"lineNum":"  347","line":"    /// Converts all (ASCII) uppercase letters to lowercase"},
{"lineNum":"  348","line":"    pub fn toLowercase(self: *String) void {"},
{"lineNum":"  349","line":"        if (self.buffer) |buffer| {"},
{"lineNum":"  350","line":"            var i: usize = 0;"},
{"lineNum":"  351","line":"            while (i < self.size) {"},
{"lineNum":"  352","line":"                const size = String.getUTF8Size(buffer[i]);"},
{"lineNum":"  353","line":"                if (size == 1) buffer[i] = std.ascii.toLower(buffer[i]);"},
{"lineNum":"  354","line":"                i += size;"},
{"lineNum":"  355","line":"            }"},
{"lineNum":"  356","line":"        }"},
{"lineNum":"  357","line":"    }"},
{"lineNum":"  358","line":""},
{"lineNum":"  359","line":"    /// Converts all (ASCII) uppercase letters to lowercase"},
{"lineNum":"  360","line":"    pub fn toUppercase(self: *String) void {"},
{"lineNum":"  361","line":"        if (self.buffer) |buffer| {"},
{"lineNum":"  362","line":"            var i: usize = 0;"},
{"lineNum":"  363","line":"            while (i < self.size) {"},
{"lineNum":"  364","line":"                const size = String.getUTF8Size(buffer[i]);"},
{"lineNum":"  365","line":"                if (size == 1) buffer[i] = std.ascii.toUpper(buffer[i]);"},
{"lineNum":"  366","line":"                i += size;"},
{"lineNum":"  367","line":"            }"},
{"lineNum":"  368","line":"        }"},
{"lineNum":"  369","line":"    }"},
{"lineNum":"  370","line":""},
{"lineNum":"  371","line":"    /// Creates a String from a given range"},
{"lineNum":"  372","line":"    /// User is responsible for managing the new String"},
{"lineNum":"  373","line":"    pub fn substr(self: String, start: usize, end: usize) Error!String {"},
{"lineNum":"  374","line":"        var result = String.init(self.allocator);"},
{"lineNum":"  375","line":""},
{"lineNum":"  376","line":"        if (self.buffer) |buffer| {"},
{"lineNum":"  377","line":"            if (String.getIndex(buffer, start, true)) |rStart| {"},
{"lineNum":"  378","line":"                if (String.getIndex(buffer, end, true)) |rEnd| {"},
{"lineNum":"  379","line":"                    if (rEnd < rStart or rEnd > self.size)"},
{"lineNum":"  380","line":"                        return Error.InvalidRange;"},
{"lineNum":"  381","line":"                    try result.concat(buffer[rStart..rEnd]);"},
{"lineNum":"  382","line":"                }"},
{"lineNum":"  383","line":"            }"},
{"lineNum":"  384","line":"        }"},
{"lineNum":"  385","line":""},
{"lineNum":"  386","line":"        return result;"},
{"lineNum":"  387","line":"    }"},
{"lineNum":"  388","line":""},
{"lineNum":"  389","line":"    // Writer functionality for the String."},
{"lineNum":"  390","line":"    pub usingnamespace struct {"},
{"lineNum":"  391","line":"        pub const Writer = std.io.Writer(*String, Error, appendWrite);"},
{"lineNum":"  392","line":""},
{"lineNum":"  393","line":"        pub fn writer(self: *String) Writer {","class":"lineCov","hits":"1","order":"1563","possible_hits":"1",},
{"lineNum":"  394","line":"            return .{ .context = self };","class":"lineCov","hits":"1","order":"1564","possible_hits":"1",},
{"lineNum":"  395","line":"        }"},
{"lineNum":"  396","line":""},
{"lineNum":"  397","line":"        fn appendWrite(self: *String, m: []const u8) !usize {","class":"lineCov","hits":"1","order":"1569","possible_hits":"1",},
{"lineNum":"  398","line":"            try self.concat(m);","class":"lineCov","hits":"1","order":"1570","possible_hits":"1",},
{"lineNum":"  399","line":"            return m.len;","class":"lineCov","hits":"1","order":"1573","possible_hits":"1",},
{"lineNum":"  400","line":"        }"},
{"lineNum":"  401","line":"    };"},
{"lineNum":"  402","line":""},
{"lineNum":"  403","line":"    // Iterator support"},
{"lineNum":"  404","line":"    pub usingnamespace struct {"},
{"lineNum":"  405","line":"        pub const StringIterator = struct {"},
{"lineNum":"  406","line":"            string: *const String,"},
{"lineNum":"  407","line":"            index: usize,"},
{"lineNum":"  408","line":""},
{"lineNum":"  409","line":"            pub fn next(it: *StringIterator) ?[]const u8 {"},
{"lineNum":"  410","line":"                if (it.string.buffer) |buffer| {"},
{"lineNum":"  411","line":"                    if (it.index == it.string.size) return null;"},
{"lineNum":"  412","line":"                    var i = it.index;"},
{"lineNum":"  413","line":"                    it.index += String.getUTF8Size(buffer[i]);"},
{"lineNum":"  414","line":"                    return buffer[i..it.index];"},
{"lineNum":"  415","line":"                } else {"},
{"lineNum":"  416","line":"                    return null;"},
{"lineNum":"  417","line":"                }"},
{"lineNum":"  418","line":"            }"},
{"lineNum":"  419","line":"        };"},
{"lineNum":"  420","line":""},
{"lineNum":"  421","line":"        pub fn iterator(self: *const String) StringIterator {"},
{"lineNum":"  422","line":"            return StringIterator{"},
{"lineNum":"  423","line":"                .string = self,"},
{"lineNum":"  424","line":"                .index = 0,"},
{"lineNum":"  425","line":"            };"},
{"lineNum":"  426","line":"        }"},
{"lineNum":"  427","line":"    };"},
{"lineNum":"  428","line":""},
{"lineNum":"  429","line":"    /// Returns whether or not a character is whitelisted"},
{"lineNum":"  430","line":"    fn inWhitelist(char: u8, whitelist: []const u8) bool {"},
{"lineNum":"  431","line":"        var i: usize = 0;"},
{"lineNum":"  432","line":"        while (i < whitelist.len) : (i += 1) {"},
{"lineNum":"  433","line":"            if (whitelist[i] == char) return true;"},
{"lineNum":"  434","line":"        }"},
{"lineNum":"  435","line":""},
{"lineNum":"  436","line":"        return false;"},
{"lineNum":"  437","line":"    }"},
{"lineNum":"  438","line":""},
{"lineNum":"  439","line":"    /// Checks if byte is part of UTF-8 character"},
{"lineNum":"  440","line":"    inline fn isUTF8Byte(byte: u8) bool {"},
{"lineNum":"  441","line":"        return ((byte & 0x80) > 0) and (((byte << 1) & 0x80) == 0);"},
{"lineNum":"  442","line":"    }"},
{"lineNum":"  443","line":""},
{"lineNum":"  444","line":"    /// Returns the real index of a unicode string literal"},
{"lineNum":"  445","line":"    fn getIndex(unicode: []const u8, index: usize, real: bool) ?usize {","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"  446","line":"        var i: usize = 0;","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"  447","line":"        var j: usize = 0;","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"  448","line":"        while (i < unicode.len) {","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"  449","line":"            if (real) {","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"  450","line":"                if (j == index) return i;","class":"lineNoCov","hits":"0","possible_hits":"2",},
{"lineNum":"  451","line":"            } else {"},
{"lineNum":"  452","line":"                if (i == index) return j;","class":"lineNoCov","hits":"0","possible_hits":"2",},
{"lineNum":"  453","line":"            }"},
{"lineNum":"  454","line":"            i += String.getUTF8Size(unicode[i]);","class":"lineNoCov","hits":"0","possible_hits":"2",},
{"lineNum":"  455","line":"            j += 1;","class":"lineNoCov","hits":"0","possible_hits":"2",},
{"lineNum":"  456","line":"        }"},
{"lineNum":"  457","line":""},
{"lineNum":"  458","line":"        return null;","class":"lineNoCov","hits":"0","possible_hits":"1",},
{"lineNum":"  459","line":"    }"},
{"lineNum":"  460","line":""},
{"lineNum":"  461","line":"    /// Returns the UTF-8 character\'s size"},
{"lineNum":"  462","line":"    inline fn getUTF8Size(char: u8) u3 {"},
{"lineNum":"  463","line":"        return std.unicode.utf8ByteSequenceLength(char) catch {","class":"linePartCov","hits":"2","order":"1519","possible_hits":"4",},
{"lineNum":"  464","line":"            return 1;","class":"lineNoCov","hits":"0","possible_hits":"2",},
{"lineNum":"  465","line":"        };"},
{"lineNum":"  466","line":"    }"},
{"lineNum":"  467","line":"};"},
]};
var percent_low = 25;var percent_high = 75;
var header = { "command" : "test", "date" : "2023-04-18 20:41:50", "instrumented" : 62, "covered" : 39,};
var merged_data = [];
