//
//  WKCImageMaker.h
//  WKCPhotoLiveView
//
//  Created by 魏昆超 on 2018/10/1.
//  Copyright © 2018年 魏昆超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WKCImageMaker : NSObject

/**
 转化图片

 @param sPath 转化地址
 */
+ (void)writeTOSavePath:(NSString *)sPath assetIdentifier:(NSString *)identify;

@end

