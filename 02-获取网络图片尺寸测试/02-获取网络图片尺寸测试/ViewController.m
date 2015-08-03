//
//  ViewController.m
//  获取网络图片尺寸
//
//  Created by 郑亚恒 on 15/8/3.
//  Copyright © 2015年 zhengyaheng. All rights reserved.
//

#import "ViewController.h"
#import "YHGetNetPictureSize.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // 加载网络图片返回尺寸测试
    NSURL *url = [NSURL URLWithString:@"http://ww4.sinaimg.cn/thumbnail/0069XRS3gw1eup5nmy2ulj30tw326tob.jpg"];
    
    // 获取图片尺寸
    [self getSize:url];
    
    // 显示图片
    [self displayImage:url];
}

/// 获得图片大小
- (void)getSize:(NSURL *)url {
    
    CGSize size = [YHGetNetPictureSize getImageSizeWithURL:url];
    NSLog(@"从服务器获得图片的尺寸--->%@",NSStringFromCGSize(size));
}

/// 显示图片验证
- (void)displayImage:(NSURL*)url {

    [[[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSData *data = [NSData dataWithContentsOfURL:location];

        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage *image = [UIImage imageWithData:data];
            UIImageView *iv = [[UIImageView alloc]initWithImage:image];
            iv.center = self.view.center;
            [self.view addSubview:iv];
        });
        
    }] resume];
}

@end
