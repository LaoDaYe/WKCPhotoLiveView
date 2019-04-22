//
//  WKCImageLoader.m
//  WKCPhotoLiveView
//
//  Created by 魏昆超 on 2018/9/30.
//  Copyright © 2018年 魏昆超. All rights reserved.
//

#import "WKCImageLoader.h"

@interface WKCImageLoader()

@property (nonatomic, copy, readwrite) NSURL * fileURL;
@property (nonatomic, strong, readwrite) UIImage * image;

@end

@implementation WKCImageLoader

- (instancetype)initWithURL:(NSURL *)URL
{
    if (self = [super init]) {
        self.fileURL = [self getFileURLWithURL:URL];
        self.image = [self loadImageWithURL:URL];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name
{
    if (self = [super init]) {
        self.fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:name ofType:nil]];
        self.image = [UIImage imageNamed:name];
    }
    return self;
}

- (UIImage *)loadImageWithURL:(NSURL *)URL
{
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:URL];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:key];
    return image;
}

- (NSURL *)getFileURLWithURL:(NSURL *)URL
{
    NSString *cacheImageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:URL];
    if (!cacheImageKey.length) return nil;
    NSString *cacheImagePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:cacheImageKey];
    if (!cacheImagePath.length) return nil;
    return [NSURL fileURLWithPath:cacheImagePath];
}

@end
