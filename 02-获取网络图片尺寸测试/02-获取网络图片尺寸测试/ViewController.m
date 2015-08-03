//
//  ViewController.m
//  02-获取网络图片尺寸测试
//
//  Created by 郑亚恒 on 15/8/3.
//  Copyright © 2015年 zhengyaheng. All rights reserved.
//

#import "ViewController.h"
#import "YHGetNetPictureSize.h"
#import "SDWebImageManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // 加载网络图片返回尺寸测试
    NSURL *url = [NSURL URLWithString:@"http://ww4.sinaimg.cn/thumbnail/0069XRS3gw1eup5nmy2ulj30tw326tob.jpg"];
    
    // 显示大小
    [self getSize:url];
    
    // 显示图片
    [self displayImage:url];
}

/// 获得图片大小
- (void)getSize:(NSURL *)url {
    CGSize size = [YHGetNetPictureSize downloadImageSizeWithURL:url];
    NSLog(@"从服务器获得图片的尺寸--->%@",NSStringFromCGSize(size));
}

/// 显示图片验证
- (void)displayImage:(NSURL*)url {
    [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageRetryFailed | SDWebImageLowPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        // 主线程检测
        NSLog(@"%@",[NSThread currentThread]);
        // 显示
        UIImageView *iv = [[UIImageView alloc]initWithImage:image];
        iv.center = self.view.center;
        [self.view addSubview:iv];
    }];
}

@end
