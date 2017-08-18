//
//  TabBarViewController.m
//  Tonite
//
//  Created by Julie Murakami on 3/30/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import "TabBarViewController.h"
#import "LBHamburgerButton.h"


@interface TabBarViewController ()

@end

@implementation TabBarViewController

-(void) viewWillAppear:(BOOL)animated   {
    [super viewWillAppear:animated];
    [self reloadInputViews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    // Do any additional setup after loading the view.
    [self.tabBar setHidden:YES];

    [self setSelectedIndex:0];
    [self.navigationItem setTitleView:[MGUIAppearance createLogo:@"TONITELOGO_new.png"]];
    
    // Do any additional setup after loading the view.
    LBHamburgerButton* itemMenu = [[LBHamburgerButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)
                                   
                                                lineWidth:22
                                                                lineHeight:10/6
                                                               lineSpacing:5
                                                                lineCenter:CGPointMake(10, 0)
                                                                     color:[UIColor grayColor]];
    [itemMenu setCenter:CGPointMake(120, 120)];
    [itemMenu setBackgroundColor:[UIColor clearColor]];
    [itemMenu addTarget:self action:@selector(didClickBarButtonMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBtn=[[UIBarButtonItem alloc] initWithCustomView:itemMenu];
    self.navigationItem.leftBarButtonItem = customBtn;
    
    UIBarButtonItem* itemLoginMenu = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed: ICON_USER]style:UIBarButtonItemStylePlain target:self action:@selector(didClickProfileMenuButton)];
    [itemLoginMenu setTintColor:[UIColor grayColor]];
   
    itemLoginMenu.imageInsets = UIEdgeInsetsMake(22, 38, 18, 3);
    self.navigationItem.rightBarButtonItem = itemLoginMenu;
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) didClickBarButtonMenu:(id) sender{
  
    LBHamburgerButton* btn = (LBHamburgerButton*)sender;
        [btn switchState];
    if(self.selectedIndex ==1){
//        UIView * fromView = self.selectedViewController.view;
//        UIView * toView = [[self.viewControllers objectAtIndex:0] view];
//        
//        // Transition using a page curl.
//        [UIView transitionFromView:fromView
//                            toView:toView
//                          duration:0.5
//                           options:UIViewAnimationOptionCurveEaseOut
//                        completion:^(BOOL finished) {
//                            if (finished) {
//                                self.selectedIndex = 0;
//                            }
//                        }];
       [self setSelectedIndex:0];
    }
    else{
        //[self.tabBarController.viewControllers[1] popToRootViewControllerAnimated:YES];
//        UIView * fromView = self.selectedViewController.view;
//        UIView * toView = [[self.viewControllers objectAtIndex:1] view];
//        
//        // Transition using a page curl.
//        [UIView transitionFromView:fromView
//                            toView:toView
//                          duration:0.5
//                           options:UIViewAnimationOptionCurveLinear
//                                    completion:^(BOOL finished) {
//                            if (finished) {
//                                self.selectedIndex = 1;
//                            }
//                        }];
        [self setSelectedIndex:1];
}
}

-(void) didClickProfileMenuButton{
    
    if(self.slidingViewController.currentTopViewPosition == ECSlidingViewControllerTopViewPositionAnchoredLeft){
        [self.slidingViewController resetTopViewAnimated:YES];
    }
    else{
    [self.slidingViewController anchorTopViewToLeftAnimated:YES];
    }
    
   
}

-(void) reloadInputViews  {
//
//    LBHamburgerButton* btn = (LBHamburgerButton*)self.navigationItem.leftBarButtonItem;
//   if(self.selectedIndex == 0){
//       [btn setState:LBHamburgerButtonStateHamburger];
//   }
//    else{
//        [btn setState:LBHamburgerButtonStateNotHamburger];
//    }
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
