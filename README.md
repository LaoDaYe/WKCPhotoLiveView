# WKCPhotoLiveView

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application) [![CocoaPods compatible](https://img.shields.io/cocoapods/v/WKCPhotoLiveView.svg?style=flat)](https://cocoapods.org/pods/WKCPhotoLiveView) [![License: MIT](https://img.shields.io/cocoapods/l/WKCPhotoLiveView.svg?style=flat)](http://opensource.org/licenses/MIT)

livePhoto...

`pod WKCPhotoLiveView`

`#import <WKCPhotoLiveView.h>`

## 四个初始化接口
图片代表占位显示图片,可以为空.
1. 远程图片和视频
```
/**
初始化

@param rpImageURL 远程图片
@param rMovURL 远程视频
@return 返回liveView
*/
- (instancetype)initWithRemotePlaceholdImageURL:(NSURL * _Nullable)rpImageURL
remoteMovURL:(NSURL * _Nonnull)rMovURL;
```

2. 本地图片和远程视频
```
/**
初始化

@param fpImageName 本地图片
@param rMovURL 远程视频
@return 返回liveView
*/
- (instancetype)initWithFilePlaceholdImageName:(NSString * _Nullable)fpImageName
remoteMovURL:(NSURL * _Nonnull)rMovURL;
```
3. 远程图片和本地视频
```
/**
初始化

@param rpImageURL 远程图片
@param fMovURL 本地视频
@return 返回liveView
*/
- (instancetype)initWithRemotePlaceholdImageURL:(NSURL * _Nullable)rpImageURL
fileMovURL:(NSURL * _Nonnull)fMovURL;
```
4. 本地图片和本地视频
```
/**
初始化

@param fpImageName 本地图片
@param fMovURL 本地视频
@return 返回liveView
*/
- (instancetype)initWithFilePlaceholdImageName:(NSString * _Nullable)fpImageName
fileMovURL:(NSURL * _Nonnull)fMovURL;
```
## 使用
```
NSURL * remoteImageURL = [NSURL URLWithString:@"https://d36660josyxojl.cloudfront.net/wallpapers/Timelapse/0013743-0a00d065c565b66cf2e9145b6c0f2329.jpg"];
NSURL * remoteMovURL = [NSURL URLWithString:@"https://d36660josyxojl.cloudfront.net/wallpapers/Timelapse/0013743-63d6f6265b571219089102b98c850e12.mov"];

WKCPhotoLiveView * liveView = [[WKCPhotoLiveView alloc] initWithRemotePlaceholdImageURL:remoteImageURL remoteMovURL:remoteMovURL];

[self.view addSubview:liveView];
[liveView mas_makeConstraints:^(MASConstraintMaker *make) {
make.edges.equalTo(self.view);
}];
```

![Alt text](https://github.com/WKCLoveYang/WKCPhotoLiveView/raw/master/screenShort/1.gif).


