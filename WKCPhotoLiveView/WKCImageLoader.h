//
//  WKCImageLoader.h
//  WKCPhotoLiveView
//
//  Created by 魏昆超 on 2018/9/30.
//  Copyright © 2018年 魏昆超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SDWebImageManager.h>

@interface WKCImageLoader : NSObject

/**
 初始化 - remote图片

 @param URL 图片URL
 @return 返回当前loader对象
 */
- (instancetype)initWithURL:(NSURL *)URL;

/**
 初始化 - native图片

 @param name 图片name
 @return 返回当前loader对象
 */
- (instancetype)initWithName:(NSString *)name;


/**
 图片的fileURL
 */
@property (nonatomic, copy, readonly) NSURL * fileURL;

/**
 图片对象
 */
@property (nonatomic, strong, readonly) UIImage * image;

@end

