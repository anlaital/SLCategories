// SLLogger.h
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

#import <Foundation/Foundation.h>

#ifdef __OPTIMIZE__

#define SLLog(format, ...) (void)format
#define SLDie(format, ...) (void)format
#define SLMeasureTimeStart(identifier) (void)#identifier
#define SLMeasureTimeEnd(identifier) (void)#identifier

#else

#import <mach/mach_time.h>

extern BOOL SLDebugging();

#define SLLog(format, ...) [[SLLogger sharedInstance] log:(format) fileName:__FILE__ lineNumber:__LINE__ methodName:__FUNCTION__, ##__VA_ARGS__]

#define SLDie(format, ...) do { \
    [SLLogger sharedInstance] log:(format) fileName:__FILE__ lineNumber:__LINE__ methodName:__FUNCTION__, ##__VA_ARGS__]; \
    if (SLDebugging()) { __builtin_trap(); } \
} while (NO)

#define SLMeasureTimeStart(identifier) \
uint64_t SLMeasureStartTime##identifier = mach_absolute_time();

#define SLMeasureTimeEnd(identifier) \
mach_timebase_info_data_t SLMeasureInfo##identifier; \
mach_timebase_info(&SLMeasureInfo##identifier); \
CGFloat SLMeasureElapsed##identifier = (CGFloat)((mach_absolute_time() - SLMeasureStartTime##identifier)) * SLMeasureInfo##identifier.numer / SLMeasureInfo##identifier.denom / NSEC_PER_SEC; \
[[SLLogger sharedInstance] log:@"Measured %.0f ms for identifier `%@`" fileName:__FILE__ lineNumber:__LINE__ methodName:__FUNCTION__, SLMeasureElapsed##identifier * 1000, @#identifier]

typedef NS_OPTIONS(NSInteger, SLLoggerOptions) {
    SLLoggerOptionFileLoggingEnabled    = 1 << 0,
    SLLoggerOptionPrintFileName         = 1 << 1,
    SLLoggerOptionPrintLineNumber       = 1 << 2,
    SLLoggerOptionPrintMethodName       = 1 << 3
};

@interface SLLogger : NSObject

@property (nonatomic) SLLoggerOptions options;
@property (nonatomic) NSUInteger maxLogFileSize;

+ (instancetype)sharedInstance;

- (void)log:(NSString *)format fileName:(const char *)fileName lineNumber:(int)lineNumber methodName:(const char *)methodName, ...;

@end

#endif
