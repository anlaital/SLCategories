//
//  SLLogger.h
//  SLFramework
//
//  Created by Antti Laitala on 07/03/14.
//
//

#import <Foundation/Foundation.h>

#ifdef __OPTIMIZE__

#define SLLog(format, ...) (void)format
#define SLMeasureTimeStart(identifier) (void)#identifier
#define SLMeasureTimeEnd(identifier) (void)#identifier

#else

#import <mach/mach_time.h>

#define SLLog(format, ...) [[SLLogger sharedInstance] log:(format) fileName:__FILE__ lineNumber:__LINE__ methodName:__FUNCTION__, ##__VA_ARGS__]

#define SLMeasureTimeStart(identifier) \
uint64_t SLMeasureStartTime##identifier = mach_absolute_time();

#define SLMeasureTimeEnd(identifier) \
mach_timebase_info_data_t SLMeasureInfo##identifier; \
mach_timebase_info(&SLMeasureInfo##identifier); \
CGFloat SLMeasureElapsed##identifier = (CGFloat)((mach_absolute_time() - SLMeasureStartTime##identifier)) * SLMeasureInfo##identifier.numer / SLMeasureInfo##identifier.denom / NSEC_PER_SEC; \
[[SLLogger sharedInstance] log:@"Measured [%.0f ms] for identifier [%@]" fileName:__FILE__ lineNumber:__LINE__ methodName:__FUNCTION__, SLMeasureElapsed##identifier * 1000, @#identifier]

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
