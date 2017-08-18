//
//  SideViewController.h
//  StoreFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property(nonatomic, retain) IBOutlet UITableView* tableViewSide;

-(void) reloadInputViews;
@end
