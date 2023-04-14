//
//  SampleDataProvider.m
//  AudioVisualization
//
//  Created by Gpf 郭 on 2023/4/14.
//

#import "SampleDataProvider.h"

@implementation SampleDataProvider
+ (void)loadAudioSamplesFromAsset:(AVAsset *)asset
                  completionBlock:(SampleDataCompletionBlock)completionBlock {
    
    NSString *tracks = @"tracks";
    // 对资源所需的键执行标准的异步载入操作，这样在访问资源的tracks属性时就不会遇到阻碍
    [asset loadValuesAsynchronouslyForKeys:@[tracks] completionHandler:^{   // 1
        
        AVKeyValueStatus status = [asset statusOfValueForKey:tracks error:nil];
        
        NSData *sampleData = nil;
        
        if (status == AVKeyValueStatusLoaded) {                             // 2
            // 当tracks键成功载入，则调用readAudioSamplesFromAsset方法从资源音轨中读取样本
            sampleData = [self readAudioSamplesFromAsset:asset];
        }
        
        // 由于载入操作可能发生在任意后台队列上，所以要返回主队列，并携带检索到的音频样本
        dispatch_async(dispatch_get_main_queue(), ^{                        // 3
            completionBlock(sampleData);
        });
    }];
    
}

+ (NSData *)readAudioSamplesFromAsset:(AVAsset *)asset {
    
    NSError *error = nil;
    
    // 创建一个新的AVAssetReader实例，并赋给它一个资源来读取。，初始化失败时则报错返回
    AVAssetReader *assetReader =                                            // 1
        [[AVAssetReader alloc] initWithAsset:asset error:&error];
    
    if (!assetReader) {
        NSLog(@"Error creating asset reader: %@", [error localizedDescription]);
        return nil;
    }
    
    // 获取资源中找到的第一个音频轨道，包含在实例项目中的音频文件中只包函有一个轨道，不过最好总是根据期望的媒体类型获取轨道
    AVAssetTrack *track =                                                   // 2
        [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    
    // 创建一个Dic来保存从资源轨道读取音频样本时使用的解压设置。样本需要以未压缩的格式被读取，所以需要制定kAudioFormatLinearPCM作为格式键。
    // 我们还希望以16位、little-endian字节顺序的有符号整形方式读取。其余设置可以在AVAudioSetting中查找
    NSDictionary *outputSettings = @{                                       // 3
        AVFormatIDKey               : @(kAudioFormatLinearPCM),
        AVLinearPCMIsBigEndianKey   : @NO,
        AVLinearPCMIsFloatKey        : @NO,
        AVLinearPCMBitDepthKey        : @(16)
    };
    
    // 创建一个新的AVAssetRenderTrackOutput实例，并将上一步创建的输出设置传递给它，将其作为AVAssetRender的输出并调用startRending来允许资源读取器开始预收取样本数据
    AVAssetReaderTrackOutput *trackOutput =                                 // 4
        [[AVAssetReaderTrackOutput alloc] initWithTrack:track
                                         outputSettings:outputSettings];
    
    [assetReader addOutput:trackOutput];
    
    [assetReader startReading];
    
    NSMutableData *sampleData = [NSMutableData data];
    
    while (assetReader.status == AVAssetReaderStatusReading) {
        // 调用跟踪输出的copyNextSampleBuffer方法开始每个迭代，每次都返回一个包含音频样本的下一个可用样本buffer
        CMSampleBufferRef sampleBuffer = [trackOutput copyNextSampleBuffer];// 5
        
        if (sampleBuffer) {
            // CMSampleBufferRef中的音频样本被包含在一个CMBlockBufferRef类型中，通过CMSampleBufferGetDataBuffer函数访问block buffer。
            CMBlockBufferRef blockBufferRef =                               // 6
                CMSampleBufferGetDataBuffer(sampleBuffer);
            
            size_t length = CMBlockBufferGetDataLength(blockBufferRef);
            SInt16 sampleBytes[length];
            CMBlockBufferCopyDataBytes(blockBufferRef,                      // 7
                                       0,
                                       length,
                                       sampleBytes);
            
            [sampleData appendBytes:sampleBytes length:length];
            
            CMSampleBufferInvalidate(sampleBuffer);                         // 8
            CFRelease(sampleBuffer);
        }
    }
    
    if (assetReader.status == AVAssetReaderStatusCompleted) {               // 9
        return sampleData;
    } else {
        NSLog(@"Failed to read audio samples from asset");
        return nil;
    }
}

@end
