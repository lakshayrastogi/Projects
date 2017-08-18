//
//  RightSideViewController.h
//  StoreFinder
//
//  Created by Julie Murakami on 3/2/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightSideViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableSideView;
@property (strong, nonatomic) IBOutlet UIImageView *userProfilePicture;

-(void) reloadInputViews ;
@end
