
//
//  WKCMovMake.m
//  WKCPhotoLiveView
//
//  Created by 魏昆超 on 2018/9/30.
//  Copyright © 2018年 魏昆超. All rights reserved.
//

#import "WKCMovMaker.h"

static NSString * const kKeyContentIdentifier = @"com.apple.quicktime.content.identifier";
static NSString * const kKeyStillImageTime = @"com.apple.quicktime.still-image-time";
static NSString * const kKeySpaceWuickTimeMetadata = @"mdta";

static NSString * const kMediadataTypeInt8 = @"com.apple.metadata.datatype.int8";
static NSString * const kMediadataTypeUTF8 = @"com.apple.metadata.datatype.UTF-8";


static NSString * const kReaderKey = @"reader";
static NSString * const kOutputKey = @"output";

static inline NSArray<AVMetadataItem *> * metadata(AVURLAsset * asset)
{
    return [asset metadataForFormat:AVMetadataFormatQuickTimeMetadata];
}

static inline AVAssetTrack * track(AVMediaType mediaType, AVURLAsset * asset)
{
    return [asset tracksWithMediaType:mediaType].firstObject;
}

static inline NSDictionary <NSString *, id>* reader(AVURLAsset * asset, AVAssetTrack * track, NSDictionary <NSString *, id>* settings)
{
   AVAssetReaderTrackOutput * output = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:track outputSettings:settings];
    AVAssetReader * reader = [AVAssetReader assetReaderWithAsset:asset error:nil];
    [reader addOutput:output];
    return @{
             kReaderKey : reader,
             kOutputKey : output
             };
}


@interface WKCMovMaker()

@property (nonatomic, assign) CMTimeRange dummyTimeRange;
@property (nonatomic, strong) NSURL * fileURL;
@property (nonatomic, strong) AVURLAsset * asset;

@end

@implementation WKCMovMaker

- (instancetype)initWithFileURL:(NSURL *)fileURL
{
    if (self = [super init]) {
       _fileURL = fileURL;
       _dummyTimeRange = CMTimeRangeMake(CMTimeMake(0, 1000), CMTimeMake(200, 3000));
        _asset = [AVURLAsset assetWithURL:_fileURL];
    }
    return self;
}

- (NSString *)readAssetIdentify
{
    for (AVMetadataItem * metaItem in metadata(_asset)) {
        NSString * key = (NSString *)metaItem.key;
        if ([key isEqualToString:kKeyContentIdentifier] &&  [metaItem.keySpace isEqualToString:kKeySpaceWuickTimeMetadata]) {
            return (NSString *)metaItem.value;
        }
    }
    return nil;
}

- (NSNumber *)readStillImageTime
{
    AVAssetTrack * tr = track(AVMediaTypeVideo, _asset);
    NSDictionary <NSString * , id>* info = reader(_asset, tr, nil);
    AVAssetReaderTrackOutput * output = [info objectForKey:kOutputKey];
    AVAssetReader * reader = [info objectForKey:kReaderKey];
    [reader startReading];
    while (YES) {
       CMSampleBufferRef bufferRef = output.copyNextSampleBuffer;
        if (!bufferRef) return nil;
        if (CMSampleBufferGetNumSamples(bufferRef) != 0) {
            AVTimedMetadataGroup * group = [[AVTimedMetadataGroup alloc] initWithSampleBuffer:bufferRef];
            for (AVMetadataItem * obj in group.items) {
                NSString * key = (NSString *)obj.key;
                if ([key isEqualToString:kKeyStillImageTime] && ![obj.keySpace isEqualToString:kKeySpaceWuickTimeMetadata]) {
                    return obj.numberValue;
                }
            }
        }
    }
    return nil;
}

@end
