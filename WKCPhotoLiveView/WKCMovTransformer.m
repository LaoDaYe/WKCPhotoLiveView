//
//  WLCMovTransformer.m
//  www
//
//  Created by 魏昆超 on 2018/10/12.
//  Copyright © 2018年 魏昆超. All rights reserved.
//

#import "WKCMovTransformer.h"

static NSString * const kKeyContentIdentifier = @"com.apple.quicktime.content.identifier";
static NSString * const kKeyStillImageTime = @"com.apple.quicktime.still-image-time";
static NSString * const kKeySpaceQuickTimeMetadata = @"mdta";

static NSString * const kKeyInt8 = @"com.apple.metadata.datatype.int8";
static NSString * const kKeyUTF8 = @"com.apple.metadata.datatype.UTF-8";

@implementation WKCMovTransformer

+ (void)transformerWithVideoURL:(NSURL *)URL
                       savePath:(NSString *)sPath
               completionHandle:(void(^)(WKCMovTransformerState state))handle
{
    NSFileManager * fileManager = NSFileManager.defaultManager;
    if ([fileManager fileExistsAtPath:sPath]) {
        [fileManager removeItemAtPath:sPath error:nil];
    }
    
    AVURLAsset * asset = [AVURLAsset assetWithURL:URL];
    
    AVAssetReader * audioReader = nil;
    AVAssetWriterInput * audioWriterInput = nil;
    AVAssetReaderOutput * audioReaderOutput = nil;
    
    AVAssetTrack * track = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
    if (!track) {
        NSLog(@"没有找到视频路径");
        if (handle) {
            handle(WKCMovTransformerStateErrorNotFindTrack);
        }
        return;
    }
    
    AVAssetReaderTrackOutput * output = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:track outputSettings:@{(__bridge NSString *)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA)}];
    AVAssetReader * reader = [AVAssetReader assetReaderWithAsset:asset error:nil];
    [reader addOutput:output];
    
    // --------------------------------------------------
    // writer for mov
    // --------------------------------------------------
    AVAssetWriter * writer = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:sPath] fileType:AVFileTypeQuickTimeMovie error:nil];
    writer.metadata = @[[self metadataForAssetIdentifier]];
    
    // video track
    AVAssetWriterInput * input = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:[self videoSettingWithSize:track.naturalSize]];
    input.expectsMediaDataInRealTime = YES;
    input.transform = track.preferredTransform;
    [writer addInput:input];
    
    AVAsset * aAudioAsset = [AVAsset assetWithURL:URL];
    if (aAudioAsset.tracks.count > 1) {
        NSLog(@"视频资源有音频");
        //writer
        audioWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:nil];
        audioWriterInput.expectsMediaDataInRealTime = NO;
        if ([writer canAddInput:audioWriterInput]) {
            [writer addInput:audioWriterInput];
        }
        //reader
        AVAssetTrack * audioTrack = [aAudioAsset tracksWithMediaType:AVMediaTypeAudio].firstObject;
        audioReaderOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:audioTrack outputSettings:nil];
        audioReader = [AVAssetReader assetReaderWithAsset:aAudioAsset error:nil];
        if ([audioReader canAddOutput:audioReaderOutput]) {
            [audioReader addOutput:audioReaderOutput];
        }else {
            NSLog(@"无法读取音频");
            if (handle) {
                handle(WKCMovTransformerStateErrorCanNotRead);
            }
        }
    }
    
    // metadata track
    AVAssetWriterInputMetadataAdaptor * adapter = [self metadataAdapter];
    [writer addInput:adapter.assetWriterInput];
    
    // --------------------------------------------------
    // creating video
    // --------------------------------------------------
    [writer startWriting];
    [reader startReading];
    [writer startSessionAtSourceTime:kCMTimeZero];
    
    // write metadata track
    CMTimeRange dummyTimeRange = CMTimeRangeMake(CMTimeMake(0, 1000), CMTimeMake(200, 3000));
    [adapter appendTimedMetadataGroup:[[AVTimedMetadataGroup alloc] initWithItems:@[[self metadataForStillImage]] timeRange:dummyTimeRange]];
    
    // write video track
    dispatch_queue_t videoQueue = dispatch_queue_create("assetVideoWriterQueue", nil);
    [input requestMediaDataWhenReadyOnQueue:videoQueue usingBlock:^{
        while (input.isReadyForMoreMediaData) {
            if (reader.status == AVAssetReaderStatusReading) {
               CMSampleBufferRef buffer = [output copyNextSampleBuffer];
                if (buffer) {
                    if (![input appendSampleBuffer:buffer]) {
                        NSLog(@"无法写入,错误是:%@",writer.error);
                        [reader cancelReading];
                        if (handle) {
                            handle(WKCMovTransformerStateErrorCanNotWrite);
                        }
                    }
                }
            }else {
                [input markAsFinished];
                if (reader.status == AVAssetReaderStatusCompleted && aAudioAsset.tracks.count > 1) {
                    [audioReader startReading];
                    [writer startSessionAtSourceTime:kCMTimeZero];
                    dispatch_queue_t audioQueue = dispatch_queue_create("assetAudioWriterQueue", nil);
                    [audioWriterInput requestMediaDataWhenReadyOnQueue:audioQueue usingBlock:^{
                        while (audioWriterInput.isReadyForMoreMediaData) {
                            CMSampleBufferRef sampleBuffer = [audioReaderOutput copyNextSampleBuffer];
                            if (audioReader.status == AVAssetReaderStatusReading && sampleBuffer != nil) {
                                if (![audioWriterInput appendSampleBuffer:sampleBuffer]) {
                                    [audioReader cancelReading];
                                }
                            }else {
                                [audioWriterInput markAsFinished];
                                
                                NSLog(@"音频写入结束");
                                if (handle) {
                                    handle(WKCMovTransformerStateAudioCompleted);
                                }
                                [writer finishWritingWithCompletionHandler:^{
                                    if (writer.error) {
                                        NSLog(@"无法写入,错误是:%@",writer.error);
                                        if (handle) {
                                        handle(WKCMovTransformerStateError);
                                        }
                                    }else {
                                        NSLog(@"写入结束");
                                        if (handle) {
                                            handle(WKCMovTransformerStateAllCompleted);
                                        }
                                    }
                                }];
                            }
                        }
                    }];
                }else {
                    NSLog(@"视频读取未完成");
                    if (handle) {
                        handle(WKCMovTransformerStateErrorCanNotRead);
                    }
                    [writer finishWritingWithCompletionHandler:^{
                        if (writer.error) {
                            NSLog(@"无法写入,错误是:%@",writer.error);
                            if (handle) {
                                handle(WKCMovTransformerStateError);
                            }
                        }else {
                            NSLog(@"写入结束");
                            if (handle) {
                                handle(WKCMovTransformerStateAllCompleted);
                            }
                        }
                    }];
                }
            }
        }
    }];

    while (writer.status == AVAssetWriterStatusWriting) {
        [NSRunLoop.currentRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    }
    if (writer.error) {
        NSLog(@"无法写入,错误:%@",writer.error);
        if (handle) {
            handle(WKCMovTransformerStateError);
        }
    }
    
}

+ (NSDictionary *)videoSettingWithSize:(CGSize)size
{
    return @{
             AVVideoCodecKey:AVVideoCodecTypeH264,
             AVVideoWidthKey:@(size.width),
             AVVideoHeightKey:@(size.height)
             };
}

+ (AVAssetWriterInputMetadataAdaptor *)metadataAdapter
{
    NSDictionary * spec = @{
                            (__bridge NSString *)kCMMetadataFormatDescriptionMetadataSpecificationKey_Identifier:[NSString stringWithFormat:@"%@/%@",kKeySpaceQuickTimeMetadata,kKeyStillImageTime],
                            (__bridge NSString *)kCMMetadataFormatDescriptionMetadataSpecificationKey_DataType:kKeyInt8
                            };
    CMFormatDescriptionRef desc = nil;
    CMMetadataFormatDescriptionCreateWithMetadataSpecifications(kCFAllocatorDefault, kCMMetadataFormatType_Boxed, (__bridge CFArrayRef)@[spec], &desc);
    AVAssetWriterInput * input = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeMetadata outputSettings:nil sourceFormatHint:desc];
    return [AVAssetWriterInputMetadataAdaptor assetWriterInputMetadataAdaptorWithAssetWriterInput:input];
}

+ (AVMetadataItem *)metadataForAssetIdentifier
{
    return [self metadataForKey:kKeyContentIdentifier
                       keySpace:kKeySpaceQuickTimeMetadata
                          value:[[NSUUID UUID] UUIDString]
                       dataType:kKeyUTF8];
}

+ (AVMetadataItem *)metadataForStillImage
{
    return [self metadataForKey:kKeyStillImageTime
                       keySpace:kKeySpaceQuickTimeMetadata
                          value:@0
                       dataType:kKeyInt8];
}

+ (AVMetadataItem *)metadataForKey:(NSString *)key
                          keySpace:(id)keySpace
                             value:(id)value
                          dataType:(NSString *)dataType
{
    AVMutableMetadataItem * item = [[AVMutableMetadataItem alloc] init];
    item.key = key;
    item.keySpace = keySpace;
    item.value = value;
    item.dataType = dataType;
    return item;
}

@end
