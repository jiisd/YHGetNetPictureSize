//
//  YHGetNetPictureSize.m
//  Swift
//
//  Created by 郑亚恒 on 15/8/3.
//  Copyright © 2015年 zhengyaheng. All rights reserved.
//


#import "YHGetNetPictureSize.h"

@implementation YHGetNetPictureSize

+(CGSize)getImageSizeWithURL:(id)imageURL {
    
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil) {
        return CGSizeZero;
    }

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];

    NSString *imageType = [self typeForImageUrl:URL];
    
    CGSize size = CGSizeZero;
    
    if([imageType isEqualToString:@"png"]){
        
        size =  [self downloadPNGImageSizeWithRequest:request];
        
    } else if([imageType isEqual:@"gif"]) {
        
        size =  [self downloadGIFImageSizeWithRequest:request];
        
    } else if([imageType isEqual:@"jpg"]) {
        
        size = [self downloadJPGImageSizeWithRequest:request];
    }
    
    if(CGSizeEqualToSize(CGSizeZero, size)) {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
#pragma clang diagnostic pop
        
        UIImage* image = [UIImage imageWithData:data];
        
        if(image)
        {
            size = image.size;
        }
    }
    return size;
}

+ (NSString *)typeForImageUrl:(NSURL *)url {
    
    uint8_t c;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setValue:@"bytes=-1" forHTTPHeaderField:@"range"];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
#pragma clang diagnostic pop
   
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"jpg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
    }
    return nil;
}

+ (CGSize)downloadPNGImageSizeWithRequest:(NSMutableURLRequest*)request {
    
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"range"];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
#pragma clang diagnostic pop
    
    if(data.length == 8) {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
+ (CGSize)downloadGIFImageSizeWithRequest:(NSMutableURLRequest*)request {
    
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"range"];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
#pragma clang diagnostic pop
    
    if(data.length == 4) {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}

+ (CGSize)downloadJPGImageSizeWithRequest:(NSMutableURLRequest*)request {
    
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"range"];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
#pragma clang diagnostic pop
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}

@end
