//
//  QRCodeViewController.m
//  StoreFinder
//
//  Created by Julie Murakami on 2/20/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import "QRCodeViewController.h"
#import "AppDelegate.h"


@interface QRCodeViewController()

@end

@implementation QRCodeViewController

@synthesize QRTicket;
@synthesize ticketID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.navigationItem.title = self.ticketID;
    self.view.backgroundColor = THEME_BLACK_TINT_COLOR;
    
    [MGUIAppearance enhanceNavBarController:self.navigationController
                               barTintColor:WHITE_TEXT_COLOR
                                  tintColor:WHITE_TEXT_COLOR
                             titleTextColor:WHITE_TEXT_COLOR];

    self.QRTicket.text =@"QR CODE";
}


@end
