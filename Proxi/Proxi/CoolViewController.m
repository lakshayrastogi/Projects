//
//  CoolViewController.m
//  Proxi
//
//  Created by Lakshay Rastogi on 1/31/15.
//  Copyright (c) 2015 Lakshay Rastogi. All rights reserved.
//

#import "CoolViewController.h"

@interface CoolViewController ()

@end

@implementation CoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"railway" ofType:@"gif"];
    NSData *gif = [NSData dataWithContentsOfFile:filePath];
    
    UIWebView *webViewBG = [[UIWebView alloc] initWithFrame:self.view.frame];
    [webViewBG loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    webViewBG.userInteractionEnabled = NO;
    [self.view addSubview:webViewBG];
    
    UIView *filter = [[UIView alloc] initWithFrame:self.view.frame];
    filter.backgroundColor = [UIColor blackColor];
    filter.alpha = 0.05;
    filter.userInteractionEnabled = NO;
    [self.view addSubview:filter];
    
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 200)];
    welcomeLabel.text = @"PROXI";
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.font = [UIFont systemFontOfSize:50];
    welcomeLabel.userInteractionEnabled = NO;
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:welcomeLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
