//
//  SampleDataProvider.h
//  AudioVisualization
//
//  Created by Gpf 郭 on 2023/4/14.
//

#import <AVFoundation/AVFoundation.h>

typedef void(^SampleDataCompletionBlock)(NSData *);

NS_ASSUME_NONNULL_BEGIN

@interface SampleDataProvider : NSObject

+ (void)loadAudioSamplesFromAsset:(AVAsset *)asset
                  completionBlock:(SampleDataCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
