//
//  WKCLIvePhotoSaver.h
//  WKCPhotoLiveView
//
//  Created by 魏昆超 on 2018/10/3.
//  Copyright © 2018年 魏昆超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>

typedef NS_ENUM(NSInteger,WKCLivePhotoSaverState) {
    /**保存成功*/
    WKCLivePhotoSaverStateSuccess = 0,
    /**保存失败*/
    WKCLivePhotoSaverStateError ,
    /**图库权限没开*/
    WKCLivePhotoSaverStateNotAccessOpen
};

@interface WKCLivePhotoSaver : NSObject

/**
 保存LivePhoto到图库

 @param imageF 图片本地地址
 @param videoF video本地地址
 @param result 状态结果回调
 */
+ (void)saveWithImageFile:(NSString *)imageF
                videoFile:(NSString *)videoF
             resultHandle:(void(^)(WKCLivePhotoSaverState state))result;

@end
