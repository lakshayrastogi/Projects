//
//  ViewController.m
//  VideoLogin
//
//  Created by Lakshay Rastogi on 4/3/15.
//  Copyright (c) 2015 Lakshay Rastogi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.playerLayer setFrame:self.view.bounds];
    [self.view.layer addSublayer:self.playerLayer];
    
    // loop movie
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(replayMovie:)
                                                 name: AVPlayerItemDidPlayToEndTimeNotification
                                               object: self.playerLayer];
    
    UIView *filter = [[UIView alloc] initWithFrame:self.view.frame];
    filter.backgroundColor = [UIColor blackColor];
    filter.alpha = 0.05;
    [self.view addSubview:filter];
    
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 1*self.view.bounds.size.height/8, self.view.bounds.size.width, self.view.bounds.size.height/8)];
    welcomeLabel.text = @"tonite";
    welcomeLabel.textColor = [UIColor whiteColor];
    //welcomeLabel.font = [UIFont systemFontOfSize:60];
    welcomeLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:60];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:welcomeLabel];
    
    UITextField *emailText = [[UITextField alloc] initWithFrame:CGRectMake(3*self.view.bounds.size.width/24, 21*self.view.bounds.size.height/40, 18*self.view.bounds.size.width/24, 2*self.view.bounds.size.height/40)];
    emailText.layer.borderColor = [[UIColor whiteColor] CGColor];
    emailText.layer.borderWidth = 1.0;
    emailText.placeholder = @" Email";
    [emailText setTintColor:[UIColor whiteColor]];
    [self.view addSubview:emailText];
    
    UITextField *passwordText = [[UITextField alloc] initWithFrame:CGRectMake(3*self.view.bounds.size.width/24, 23.5*self.view.bounds.size.height/40, 18*self.view.bounds.size.width/24, 2*self.view.bounds.size.height/40)];
    passwordText.layer.borderColor = [[UIColor whiteColor] CGColor];
    passwordText.layer.borderWidth = 1.0;
    passwordText.placeholder = @" Password";
    [passwordText setTintColor:[UIColor whiteColor]];
    [self.view addSubview:passwordText];
    
    UIButton *signInButton = [[UIButton alloc] initWithFrame:CGRectMake(3*self.view.bounds.size.width/24, 26*self.view.bounds.size.height/40, 18*self.view.bounds.size.width/24, 2*self.view.bounds.size.height/40)];
    signInButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    signInButton.layer.borderWidth = 1.0;
    signInButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [signInButton setTintColor:[UIColor whiteColor]];
    [signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
    [signInButton.layer setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.6].CGColor];
    [self.view addSubview:signInButton];
    
    UIButton *fbButton = [[UIButton alloc] initWithFrame:CGRectMake(3*self.view.bounds.size.width/24, 32*self.view.bounds.size.height/40, 18*self.view.bounds.size.width/24, 2.5*self.view.bounds.size.height/40)];
    fbButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    fbButton.layer.borderWidth = 1.0;
    fbButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [fbButton setTintColor:[UIColor whiteColor]];
    [fbButton setTitle:@"Facebook" forState:UIControlStateNormal];
    [fbButton.layer setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.6].CGColor];
    [self.view addSubview:fbButton];
    
    UIButton *twitterButton = [[UIButton alloc] initWithFrame:CGRectMake(3*self.view.bounds.size.width/24, 35*self.view.bounds.size.height/40, 18*self.view.bounds.size.width/24, 2.5*self.view.bounds.size.height/40)];
    twitterButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    twitterButton.layer.borderWidth = 1.0f;
    twitterButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [twitterButton setTintColor:[UIColor whiteColor]];
    [twitterButton setTitle:@"Twitter" forState:UIControlStateNormal];
    [twitterButton.layer setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.6].CGColor];
    [self.view addSubview:twitterButton];
}

-(AVPlayerLayer*)playerLayer
{
    if(!_playerLayer)
    {
        
        // find movie file
        NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"Yo" ofType:@"mp4"];
        NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:[[AVPlayer alloc]initWithURL:movieURL]];
        _playerLayer.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
        _playerLayer.player.play;
    }
    return _playerLayer;
}

-(void)replayMovie:(NSNotification *)notification
{
    [self.playerLayer.player play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
