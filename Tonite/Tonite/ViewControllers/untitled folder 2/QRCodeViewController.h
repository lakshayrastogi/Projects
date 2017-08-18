//
//  QRCodeViewController.h
//  StoreFinder
//
//  Created by Julie Murakami on 2/20/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRCodeViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *QRTicket;
@property (nonatomic, retain) NSString* ticketID;

@end
