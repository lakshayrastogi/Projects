//
//  MeViewController.h
//  Proxi
//
//  Created by Lakshay Rastogi on 1/30/15.
//  Copyright (c) 2015 Lakshay Rastogi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppRun.h"

@interface MeViewController : UIViewController

- (IBAction)touchChangeButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *usernameText;

@end
