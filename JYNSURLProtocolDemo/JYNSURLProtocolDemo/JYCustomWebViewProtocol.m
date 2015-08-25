//
//  JYCustomWebViewProtocol.m
//  JYNSURLProtocolDemo
//
//  Created by James Yu on 15/8/25.
//  Copyright (c) 2015年 James. All rights reserved.
//

#import "JYCustomWebViewProtocol.h"
#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"
#import "UIImage+MultiFormat.h"

static NSString * const hasInitKey = @"JYCustomWebViewProtocolKey";

@interface JYCustomWebViewProtocol ()

@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSURLConnection *connection;

@end

@implementation JYCustomWebViewProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    NSString *str = request.URL.path;
    //NSLog(@"-----%@----", str);
    if (([str hasSuffix:@".png"] || [str hasSuffix:@".jpg"] || [str hasSuffix:@".gif"]) && ![NSURLProtocol propertyForKey:hasInitKey inRequest:request]) {
        NSLog(@"will handle");
        return YES;
    }
    //NSLog(@"=====%@", str);
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    //mutableReqeust.timeoutInterval = 40;
    //这边可用干你想干的事情。。更改地址，或者设置里面的请求头。。
    return mutableReqeust;
}

- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    //做下标记，防止递归调用
    [NSURLProtocol setProperty:@YES forKey:hasInitKey inRequest:mutableReqeust];
    
    //这边就随便你玩了。。可以直接返回本地的模拟数据，进行测试
    
    UIImage *img = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[mutableReqeust.URL absoluteString]];
    
    if (img) {
        
        NSData *data = UIImageJPEGRepresentation(img, 1);
        
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:mutableReqeust.URL
                                                            MIMEType:@""
                                               expectedContentLength:data.length
                                                    textEncodingName:nil];
        [self.client URLProtocol:self
              didReceiveResponse:response
              cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        
        [self.client URLProtocol:self didLoadData:data];
        [self.client URLProtocolDidFinishLoading:self];
    }
    else {
        
//        [[SDWebImageManager sharedManager] downloadImageWithURL:mutableReqeust.URL
//                                                        options:0
//                                                       progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                                                           
//                                                           if (error) {
//                                                               NSLog(@"fail to load image: %@", error.description);
//                                                           }
//                                                           else {
//                                                               [[SDImageCache sharedImageCache] storeImage:img forKey:[self.request.URL absoluteString]];
//                                                               
//                                                               NSLog(@"download success");
//                                                               NSData *data = UIImageJPEGRepresentation(img, 1);
//                                                               
//                                                               NSURLResponse *response = [[NSURLResponse alloc] initWithURL:mutableReqeust.URL
//                                                                                                                   MIMEType:@""
//                                                                                                      expectedContentLength:data.length
//                                                                                                           textEncodingName:nil];
//                                                               [self.client URLProtocol:self
//                                                                     didReceiveResponse:response
//                                                                     cacheStoragePolicy:NSURLCacheStorageNotAllowed];
//                                                               
//                                                               [self.client URLProtocol:self didLoadData:data];
//                                                               [self.client URLProtocolDidFinishLoading:self];
//                                                           }
//                                                           
//                                                           
//                                                       }];
    
        self.connection = [NSURLConnection connectionWithRequest:mutableReqeust delegate:self];
    }
}

- (void)stopLoading
{
    [self.connection cancel];
}

#pragma mark- NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [self.client URLProtocol:self didFailWithError:error];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [[NSMutableData alloc] init];
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIImage *cacheImage = [UIImage sd_imageWithData:self.responseData];
    
    [[SDImageCache sharedImageCache] storeImage:cacheImage forKey:[self.request.URL absoluteString]];
    
    [self.client URLProtocolDidFinishLoading:self];
}

@end
