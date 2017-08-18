//
//  QRTicketViewController.h
//  Tonite
//
//  Created by Sean on 4/9/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QRTicketViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *dateString;
@property (weak, nonatomic) IBOutlet UILabel *venueString;
@property (weak, nonatomic) IBOutlet UILabel *eventNameString;
@property (weak, nonatomic) IBOutlet UILabel *timeString;

@property Event * event;
@property Venue * venue;
@property Ticket * ticket;

@end
