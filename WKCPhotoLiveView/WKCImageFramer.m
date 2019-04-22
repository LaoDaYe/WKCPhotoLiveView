//
//  WKCImageFramer.m
//  WKCPhotoLiveView
//
//  Created by 魏昆超 on 2018/9/30.
//  Copyright © 2018年 魏昆超. All rights reserved.
//

#import "WKCImageFramer.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>
#import "WKCImageMaker.h"
#import "WKCMovMaker.h"

@implementation WKCImageFramer

+ (void)imageFramerWithMovFilePath:(NSURL *)filePath
                  completionHandle:(void(^)(BOOL isSuccess, NSString * imagePath))handle
{
    dispatch_queue_t imageQueue = dispatch_queue_create("imageQueue", nil);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();

    dispatch_async(imageQueue, ^{
        WKCMovMaker * movMaker = [[WKCMovMaker alloc] initWithFileURL:filePath];
        AVURLAsset * asset = [[AVURLAsset alloc] initWithURL:filePath options:nil];
        AVAssetImageGenerator *imageGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        [imageGen setAppliesPreferredTrackTransform:YES];
        imageGen.requestedTimeToleranceAfter = kCMTimeZero;
        imageGen.requestedTimeToleranceBefore = kCMTimeZero;
        NSValue * time = [NSValue valueWithCMTime:CMTimeMakeWithSeconds([movMaker readStillImageTime] ? [movMaker readStillImageTime].intValue : CMTimeGetSeconds(asset.duration) / 2, asset.duration.timescale)];
        [imageGen generateCGImagesAsynchronouslyForTimes:@[time] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
            
            UIImage * theImage = [UIImage imageWithCGImage:image];
            NSData * data = UIImageJPEGRepresentation(theImage, 1.f);
            
            NSString * name = [filePath.path.lastPathComponent stringByDeletingPathExtension];
            
            NSString * imagePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",name]];
            
            [data writeToFile:imagePath atomically:YES];
            
            [WKCImageMaker writeTOSavePath:imagePath assetIdentifier:[movMaker readAssetIdentify] ?: [[NSUUID UUID] UUIDString]];
            
            dispatch_async(mainQueue, ^{
                if (handle) {
                    handle(YES, imagePath);
                }
            });
        }];
    });
    
}

@end
