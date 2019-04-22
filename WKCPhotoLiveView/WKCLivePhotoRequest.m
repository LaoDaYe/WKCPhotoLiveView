//
//  WKCLivePhotoRequest.m
//  WKCPhotoLiveView
//
//  Created by 魏昆超 on 2018/10/1.
//  Copyright © 2018年 魏昆超. All rights reserved.
//

#import "WKCLivePhotoRequest.h"

@implementation WKCLivePhotoRequest

+ (void)requestWithImageFile:(NSString *)imageFile
                        videoFile:(NSString *)videoFile
                     resultHandle:(void(^)(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nonnull info))result
{
    NSURL * imageFileURL = [NSURL fileURLWithPath:imageFile ?: @"blank"];
    NSURL * videoFileURL = [NSURL fileURLWithPath:videoFile ?: @"blank"];
    [PHLivePhoto requestLivePhotoWithResourceFileURLs:@[imageFileURL,videoFileURL] placeholderImage:[UIImage imageWithContentsOfFile:imageFileURL.path] targetSize:CGSizeZero contentMode:PHImageContentModeAspectFill resultHandler:result];
}

@end
