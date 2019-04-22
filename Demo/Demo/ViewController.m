//
//  ViewController.m
//  Demo
//
//  Created by 魏昆超 on 2018/10/15.
//  Copyright © 2018年 魏昆超. All rights reserved.
//

#import "ViewController.h"
#import <WKCPhotoLiveView.h>
#import <Masonry.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"launch_guide_2" ofType:@"mov"];
    NSURL * fileMovURL = [NSURL fileURLWithPath:path];
    NSURL * fileImageURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"launch_guide_2" ofType:@"jpg"]];
    
    NSURL * remoteImageURL = [NSURL URLWithString:@"https://d36660josyxojl.cloudfront.net/wallpapers/Timelapse/0013743-0a00d065c565b66cf2e9145b6c0f2329.jpg"];
    NSURL * remoteMovURL = [NSURL URLWithString:@"https://d36660josyxojl.cloudfront.net/wallpapers/Timelapse/0013743-63d6f6265b571219089102b98c850e12.mov"];
    
    NSLog(@"%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject);
    
    WKCPhotoLiveView * liveView = [[WKCPhotoLiveView alloc] initWithRemotePlaceholdImageURL:remoteImageURL remoteMovURL:remoteMovURL];
    
    [self.view addSubview:liveView];
    [liveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


@end
