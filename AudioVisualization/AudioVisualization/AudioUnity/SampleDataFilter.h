//
//  SampleDataFilter.h
//  AudioVisualization
//
//  Created by Gpf 郭 on 2023/4/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SampleDataFilter : NSObject

- (id)initWithData:(NSData *)sampleData;

- (NSArray *)filteredSamplesForSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
