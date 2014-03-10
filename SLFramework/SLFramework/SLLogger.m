//
//  SLLogger.m
//  SLFramework
//
//  Created by Antti Laitala on 07/03/14.
//
//

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
                    [[NSData data] writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
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
