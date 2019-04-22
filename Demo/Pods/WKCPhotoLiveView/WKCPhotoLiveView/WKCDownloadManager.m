//
//  WKCDownloadManager.m
//  WKCLivePhotoView
//
//  Created by 魏昆超 on 2018/9/29.
//  Copyright © 2018年 魏昆超. All rights reserved.
//

#import "WKCDownloadManager.h"

@implementation WKCDownloadManager


+ (void)downloadFileWithURL:(NSURL *)url
               saveFilePath:(NSString *)sfPath
             progressHandle:(void(^)(CGFloat progress))progress
           completionHandle:(void(^)(BOOL isSuccess))handle
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                            timeoutInterval:10];
    AFHTTPSessionManager *manager = AFHTTPSessionManager.manager;
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {//进度
        CGFloat compeleted = downloadProgress.completedUnitCount;
        CGFloat total = downloadProgress.totalUnitCount;
        if (progress) {
            progress(compeleted / total);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *filePathUrl = [NSURL fileURLWithPath:sfPath];
        return filePathUrl;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
        if (error) {
            if (handle) handle(NO);
        }else {
            if (handle) handle(YES);
        }
        
    }];
    //3.启动任务
    [downloadTask resume];
}


@end
