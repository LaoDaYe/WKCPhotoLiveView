//
//  WKCPhotoLiveView.h
//  WKCPhotoLiveView
//
//  Created by 魏昆超 on 2018/10/10.
//  Copyright © 2018年 魏昆超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import "WKCDownloadManager.h"
#import "WKCLivePhotoRequest.h"
#import "WKCImageLoader.h"
#import "WKCLivePhotoSaver.h"
#import "WKCImageFramer.h"
#import "WKCMovTransformer.h"

/**
 下载状态
 */
typedef NS_ENUM(NSInteger, WKCPhotoLiveDownloadedState) {
    /**下载成功*/
    WKCPhotoLiveDownloadedStateSuccess = 0,
    /**下载错误*/
    WKCPhotoLiveDownloadedStateError
};

@class WKCPhotoLiveView;

@protocol WKCPhotoLiveViewDelegate <NSObject>

@optional

/**
 远程视频下载中...

 @param liveView 当前视图
 @param progress 下载进度
 */
- (void)wkcPhotoLiveView:(WKCPhotoLiveView *)liveView
     downloadingProgress:(CGFloat)progress;
/**
 远程视频结束...

 @param liveView 当前视图
 @param state 结束状态
 */
- (void)wkcPhotoLiveView:(WKCPhotoLiveView *)liveView
         downloadedState:(WKCPhotoLiveDownloadedState)state;

/**
 格式转换 - 非mov格式调用

 @param liveView 当前视图
 @param state 转换z状态
 */
- (void)wkcPhotoLiveView:(WKCPhotoLiveView *)liveView
          transformState:(WKCMovTransformerState)state;

/**
 点击当前视图

 @param liveView 当前视图
 */
- (void)wkcPhotoLiveViewDidTouch:(WKCPhotoLiveView *)liveView;
/**
 livePhoto将要播放

 @param liveView 当前视图
 */
- (void)wkcPhotoLiveViewWillBeginPlay:(WKCPhotoLiveView *)liveView;
/**
 livePhoto播放完毕

 @param liveView 当前视图
 */
- (void)wkcPhotoLiveViewDidEndPlay:(WKCPhotoLiveView *)liveView;


/**
 保存到图库

 @param liveView 当前视图
 @param state 保存状态
 */
- (void)wkcPhotoLiveView:(WKCPhotoLiveView *)liveView
  saveToLibraryWithState:(WKCLivePhotoSaverState)state;

@end



@interface WKCPhotoLiveView : UIView

/**
 代理
 */
@property (nonatomic, weak) id<WKCPhotoLiveViewDelegate> delegate;

/**
 展示模式 - 默认平铺
 */
@property (nonatomic, assign) UIViewContentMode liveMode;

/**
 是否消音 - 默认NO
 */
@property (nonatomic, assign) BOOL muted;

/**
 图片的存储位置 - 只读
 */
@property (nonatomic, copy, readonly) NSString * imageFile;

/**
 video的存储位置 - 只读
 */
@property (nonatomic, copy, readonly) NSString * videoFile;


/**
 初始化

 @param rpImageURL 远程图片
 @param rMovURL 远程视频
 @return 返回liveView
 */
- (instancetype)initWithRemotePlaceholdImageURL:(NSURL * _Nullable)rpImageURL
                        remoteMovURL:(NSURL * _Nonnull)rMovURL;

/**
 初始化

 @param fpImageName 本地图片
 @param rMovURL 远程视频
 @return 返回liveView
 */
- (instancetype)initWithFilePlaceholdImageName:(NSString * _Nullable)fpImageName
                       remoteMovURL:(NSURL * _Nonnull)rMovURL;

/**
 初始化

 @param rpImageURL 远程图片
 @param fMovURL 本地视频
 @return 返回liveView
 */
- (instancetype)initWithRemotePlaceholdImageURL:(NSURL * _Nullable)rpImageURL
                          fileMovURL:(NSURL * _Nonnull)fMovURL;

/**
 初始化

 @param fpImageName 本地图片
 @param fMovURL 本地视频
 @return 返回liveView
 */
- (instancetype)initWithFilePlaceholdImageName:(NSString * _Nullable)fpImageName
                         fileMovURL:(NSURL * _Nonnull)fMovURL;



/**
 重放
 */
- (void)replay;

/**
 停止播放
 */
- (void)stopPlay;

/**
 保存到图库
 */
- (void)saveToLibrary;


@end

