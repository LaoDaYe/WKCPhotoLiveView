//
//  WLCMovTransformer.h
//  www
//
//  Created by 魏昆超 on 2018/10/12.
//  Copyright © 2018年 魏昆超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger,WKCMovTransformerState) {
    WKCMovTransformerStateError = 0,
    WKCMovTransformerStateErrorCanNotRead,
    WKCMovTransformerStateErrorCanNotWrite,
    WKCMovTransformerStateErrorNotFindTrack,
    WKCMovTransformerStateVideoCompeted,
    WKCMovTransformerStateAudioCompleted,
    WKCMovTransformerStateAllCompleted
};

@interface WKCMovTransformer : NSObject

/**
 视频格式转换

 @param URL 视频地址
 @param sPath 转换后保存地址
 @param handle 结果回调
 */
+ (void)transformerWithVideoURL:(NSURL *)URL
                       savePath:(NSString *)sPath
               completionHandle:(void(^)(WKCMovTransformerState state))handle;

@end

