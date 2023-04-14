//
//  SampleDataFilter.m
//  AudioVisualization
//
//  Created by Gpf 郭 on 2023/4/14.
//

#import "SampleDataFilter.h"

@interface SampleDataFilter ()
@property (nonatomic, strong) NSData *sampleData;
@end

@implementation SampleDataFilter
- (id)initWithData:(NSData *)sampleData {
    self = [super init];
    if (self) {
        _sampleData = sampleData;
    }
    return self;
}

- (NSArray *)filteredSamplesForSize:(CGSize)size {

    NSMutableArray *filteredSamples = [[NSMutableArray alloc] init];        // 1
    // 根据数据的大小计算出数据取样数
    NSUInteger sampleCount = self.sampleData.length / sizeof(SInt16);
    // 由于数据过多，需要根据界面宽度获取可展示的数据量，然后根据步幅来获取对应数据
    NSUInteger binSize = sampleCount / size.width;

    SInt16 *bytes = (SInt16 *) self.sampleData.bytes;
    
    SInt16 maxSample = 0;
    
    for (NSUInteger i = 0; i < sampleCount; i += binSize) {

        SInt16 sampleBin[binSize];

        for (NSUInteger j = 0; j < binSize; j++) {                          // 2
            // 通过偏移获取相应数据的大小
            sampleBin[j] = CFSwapInt16LittleToHost(bytes[i + j]);
        }
        
        // 获取样本数据中的最大值
        SInt16 value = [self maxValueInArray:sampleBin ofSize:binSize];     // 3
        [filteredSamples addObject:@(value)];

        if (value > maxSample) {                                            // 4
            maxSample = value;
        }
    }

    CGFloat scaleFactor = (size.height / 2) / maxSample;                    // 5

    for (NSUInteger i = 0; i < filteredSamples.count; i++) {                // 6
        filteredSamples[i] = @([filteredSamples[i] integerValue] * scaleFactor);
    }

    return filteredSamples;
}

- (SInt16)maxValueInArray:(SInt16[])values ofSize:(NSUInteger)size {
    SInt16 maxValue = 0;
    for (int i = 0; i < size; i++) {
        if (abs(values[i]) > maxValue) {
            maxValue = abs(values[i]);
        }
    }
    return maxValue;
}

@end
