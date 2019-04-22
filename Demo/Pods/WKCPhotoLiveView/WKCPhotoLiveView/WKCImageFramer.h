//
//  WKCImageFramer.h
//  WKCPhotoLiveView
//
//  Created by 魏昆超 on 2018/9/30.
//  Copyright © 2018年 魏昆超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WKCImageFramer : NSObject


/**
 获取帧视频

 @param filePath 本地视频地址
 @param handle 结果回调
 */
+ (void)imageFramerWithMovFilePath:(NSURL *)filePath
                  completionHandle:(void(^)(BOOL isSuccess, NSString * imagePath))handle;

@end
