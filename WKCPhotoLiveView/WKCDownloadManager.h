//
//  WKCDownloadManager.h
//  WKCLivePhotoView
//
//  Created by 魏昆超 on 2018/9/29.
//  Copyright © 2018年 魏昆超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AFNetworking.h>

@interface WKCDownloadManager : NSObject

/**
 下载

 @param url url
 @param sfPath 保存地址
 @param progress 进度回调
 @param handle 结果回调
 */
+ (void)downloadFileWithURL:(NSURL *)url
               saveFilePath:(NSString *)sfPath
             progressHandle:(void(^)(CGFloat progress))progress
           completionHandle:(void(^)(BOOL isSuccess))handle;

@end

