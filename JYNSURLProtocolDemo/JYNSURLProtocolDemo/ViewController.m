//
//  ViewController.m
//  JYNSURLProtocolDemo
//
//  Created by James Yu on 15/8/25.
//  Copyright (c) 2015年 James. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

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
    
}

- (IBAction)pressedButtonLoadWebView:(id)sender
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"local" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}
@end
