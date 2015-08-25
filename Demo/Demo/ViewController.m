//
//  ViewController.m
//  Demo
//
//  Created by 郑亚恒 on 15/8/25.
//  Copyright © 2015年 郑亚恒. All rights reserved.
//

#import "ViewController.h"
#import "YHGetNetPictureSize.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // 加载网络图片返回尺寸测试（图片网址可能失效，更换即可）
    NSURL *url = [NSURL URLWithString:@"http://cdn.t04.pic.sogou.com/ac75323d6b6de243-503c0c74be6ae02f-fd60a6f0fbf944e3a2c80b2b3d36ae98.jpg"];
    
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
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:0 timeoutInterval:10];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage *image = [UIImage imageWithData:data];
            UIImageView *iv = [[UIImageView alloc]initWithImage:image];
            iv.center = self.view.center;
            [self.view addSubview:iv];
        });
        
    }] resume];
}


@end
