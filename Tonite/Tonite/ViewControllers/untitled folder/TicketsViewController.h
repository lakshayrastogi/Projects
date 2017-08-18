//
//  TicketsViewController.h
//  StoreFinder
//
//  Created by Julie Murakami on 2/19/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketsViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource>


- (IBAction)didClickCloseButton:(id)sender;
@property (nonatomic, retain) IBOutlet UITableView *ticketTableView;

@end
