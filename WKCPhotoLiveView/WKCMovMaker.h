//
//  WKCMovMake.h
//  WKCPhotoLiveView
//
//  Created by 魏昆超 on 2018/9/30.
//  Copyright © 2018年 魏昆超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface WKCMovMaker : NSObject

/**
 初始化MOV生成器

 @param fileURL video地址
 @return 返回当前对象
 */
- (instancetype)initWithFileURL:(NSURL *)fileURL;

/**
 获取Mov视频的标识

 @return 返回标识字符串
 */
- (NSString *)readAssetIdentify;

/**
 获取Mov视频对应的静图帧数

 @return 返回帧数
 */
- (NSNumber *)readStillImageTime;

@end

