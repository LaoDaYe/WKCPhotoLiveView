//
//  WKCLivePhotoRequest.h
//  WKCPhotoLiveView
//
//  Created by 魏昆超 on 2018/10/1.
//  Copyright © 2018年 魏昆超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>

@interface WKCLivePhotoRequest : NSObject

/**
 转化livePhoto

 @param imageFile 图片本地地址
 @param videoFile video本地地址
 @param result 结果回调
 */
+ (void)requestWithImageFile:(NSString *)imageFile
                   videoFile:(NSString *)videoFile
                resultHandle:(void(^)(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nonnull info))result;

@end
