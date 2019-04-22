//
//  WKCImageMaker.m
//  WKCPhotoLiveView
//
//  Created by 魏昆超 on 2018/10/1.
//  Copyright © 2018年 魏昆超. All rights reserved.
//

#import "WKCImageMaker.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <ImageIO/ImageIO.h>

@implementation WKCImageMaker

+ (void)writeTOSavePath:(NSString *)sPath assetIdentifier:(NSString *)identify
{
    NSData * data = [NSData dataWithContentsOfFile:sPath];

    CGImageSourceRef imageSourceRef =  CGImageSourceCreateWithData((__bridge CFDataRef)data, nil);
    NSMutableDictionary * metadata = ((__bridge NSMutableDictionary *)CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, nil)).mutableCopy;
    NSMutableDictionary * makerNote = [[NSMutableDictionary alloc] init];
    [makerNote setObject:identify forKey:@"17"];
    [metadata setObject:makerNote forKey:@"{MakerApple}"];
    
    CGImageDestinationRef sPathRef =  CGImageDestinationCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:sPath], kUTTypeJPEG, 1, nil);
    
    CGImageDestinationAddImageFromSource(sPathRef, imageSourceRef, 0, (__bridge CFDictionaryRef)metadata);
    
    CGImageDestinationFinalize(sPathRef);
    
}

@end
