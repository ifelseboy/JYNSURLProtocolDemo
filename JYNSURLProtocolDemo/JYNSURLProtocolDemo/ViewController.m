//
//  ViewController.m
//  JYNSURLProtocolDemo
//
//  Created by James Yu on 15/8/25.
//  Copyright (c) 2015年 James. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"

@interface ViewController () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) NSMutableData *responseData;

@property (nonatomic, strong) NSURLConnection *connection;


- (IBAction)pressedButtonLoadRequest:(id)sender;

- (IBAction)pressedButtonLoadWebView:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressedButtonLoadRequest:(id)sender
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://m.weather.com.cn/atad/101210101.html"]];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [_connection start];
}

- (IBAction)pressedButtonLoadWebView:(id)sender
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"local" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error:%@", error.description);
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"response:%@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
}

@end
