// SLLogger.m
//
// Copyright (c) 2014 Antti Laitala (https://github.com/anlaital)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "SLLogger.h"

#ifndef __OPTIMIZE__

@implementation SLLogger

+ (instancetype)sharedInstance
{
    static SLLogger *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [SLLogger new];
    });
    return instance;
}

- (id)init
{
    if (self = [super init]) {
        _options = SLLoggerOptionPrintMethodName | SLLoggerOptionFileLoggingEnabled;
    }
    return self;
}

- (void)log:(NSString *)format fileName:(const char *)fileName lineNumber:(int)lineNumber methodName:(const char *)methodName, ...
{
    va_list ap;
    va_start(ap, methodName);
    NSString *resultingFormat = [[NSString alloc] initWithFormat:format arguments:ap];
    va_end(ap);
    
    NSMutableString *print = [NSMutableString new];
    if (_options & SLLoggerOptionPrintFileName)
        [print appendFormat:@"%s", fileName];
    if (_options & SLLoggerOptionPrintLineNumber)
        [print appendFormat:@":%d", lineNumber];
    if (_options & SLLoggerOptionPrintMethodName)
        [print appendFormat:print.length ? @" > %s:" : @"%s:", methodName];
    [print appendString:resultingFormat];
    
    NSLog(@"%@", print);
    
    if (_options & SLLoggerOptionFileLoggingEnabled) {
        static dispatch_once_t onceToken;
        static NSFileHandle *debugFileHandle = nil;
        dispatch_once(&onceToken, ^{
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            if (paths.count) {
                NSString *documentsDirectory = paths[0];
                NSString *path = [documentsDirectory stringByAppendingPathComponent:@"SLLog.txt"];
                if (![[NSFileManager defaultManager] isWritableFileAtPath:path])
                    [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
                debugFileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
                unsigned long long offset = [debugFileHandle seekToEndOfFile];
                if (offset >= _maxLogFileSize)
                    offset = 0; // Log file size has exceeded the maximum allowed and must be truncated from head.
                [debugFileHandle truncateFileAtOffset:offset];
                [debugFileHandle writeData:[[NSString stringWithFormat:@"\n\n\n-- START OF SESSION -- %@ --\n\n\n", [NSDate date]] dataUsingEncoding:NSUTF8StringEncoding]];
                [debugFileHandle synchronizeFile];
            }
        });
        
        [print appendString:@"\n"];
        
        [debugFileHandle truncateFileAtOffset:[debugFileHandle seekToEndOfFile]];
        [debugFileHandle writeData:[print dataUsingEncoding:NSUTF8StringEncoding]];
        [debugFileHandle synchronizeFile];
    }
}

@end

#endif
