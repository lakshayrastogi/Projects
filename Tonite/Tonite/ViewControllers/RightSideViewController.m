//
//  RightSideViewController.m
//  StoreFinder
//
//  Created by Julie Murakami on 3/2/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import "RightSideViewController.h"
#import "AppDelegate.h"

@interface RightSideViewController ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, retain) UserSession* user;
@property (nonatomic, retain) NSArray* titles;

@end

@implementation RightSideViewController

@synthesize userProfilePicture;
@synthesize tableSideView;

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadInputViews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = SIDE_VIEW_BG_COLOR;
    [self setImage:self.user.thumbPhotoUrl imageView:userProfilePicture withBorder:YES isThumb:YES];
    [userProfilePicture.layer setCornerRadius:40.0];
    [userProfilePicture setClipsToBounds:YES];
    [userProfilePicture setCenter:CGPointMake((self.view.frame.size.width+ ANCHOR_LEFT_PEEK)/2, 125)];

    
    tableSideView.delegate = self;
    tableSideView.dataSource = self;
    [tableSideView setFrame:CGRectMake(ANCHOR_LEFT_PEEK , 200, self.view.frame.size.width - ANCHOR_LEFT_PEEK, self.view.frame.size.height)];
    
    [tableSideView setBackgroundColor:[UIColor lightGrayColor]];
    /*DARKEN OUTSIDE MENU SCREEN
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    int x = self.view.frame.size.width -ANCHOR_RIGHT_PEEK-1;
    gradientLayer.frame = CGRectMake(0, 0, x, self.view.frame.size.height);
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)THEME_BLACK_TINT_COLOR.CGColor,
                            (id)[UIColor clearColor].CGColor,
                            nil];
   
    gradientLayer.startPoint = CGPointMake(-2,0.5);
    gradientLayer.endPoint = CGPointMake(1,0.5);
    [self.view.layer addSublayer:gradientLayer];
    */
 
    self.titles =@[
                  @"Settings",
                  @"About Tonite",
                  @"Friends",
                  @"My Wallet"
                  ];
    /*
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.cancelsTouchesInView = NO; //So the user can still interact with controls in the modal view
    
    [self.slidingViewController.view addGestureRecognizer:tapGesture];
    */
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    swipeGesture.cancelsTouchesInView = YES; //So the user can still interact with controls in the modal view
    
    [self.view addGestureRecognizer:swipeGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.slidingViewController resetTopViewAnimated:YES];
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MGListCell* cell =  [tableView dequeueReusableCellWithIdentifier:@"RightSideViewCell"];
    [cell setUserInteractionEnabled:YES];
   
    [cell setBackgroundColor:[UIColor lightGrayColor]];
    [cell.labelTitle setTextColor:[UIColor blackColor]];
    cell.labelTitle.text = self.titles[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // This undoes the Zoom Transition's scale because it affects the other transitions.
    // You normally wouldn't need to do anything like this, but we're changing transitions
    // dynamically so everything needs to start in a consistent state.
    //self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
    
    if (indexPath.row == 0) {
        // SETTINGS
        
        //OTHER SETTINGS??
        [self.slidingViewController resetTopViewAnimated:YES];
    }
    if(indexPath.row == 1){
        //ABOUT TONITE
     //   [self.slidingViewController resetTopViewAnimated:YES];
        UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardAboutUs"];
        [self.slidingViewController presentViewController:vc animated:YES completion:nil];
  }
   
    if(indexPath.row == 2){
        //FRIENDS
        [self.slidingViewController resetTopViewAnimated:YES];
//        vc.modalPresentationStyle = UIModalPresentationFullScreen;
//        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        
//        AppDelegate* delegate = [AppDelegate instance];
//        [[delegate.window rootViewController] presentViewController:vc animated:YES completion:nil];
//        [self.slidingViewController resetTopViewAnimated:YES];
        
    }

    if(indexPath.row == 3){
        if(self.user ==nil){
            //REGISTER PAGE
            UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier: @"storyboardRegister"];
            [self.slidingViewController presentViewController:vc animated:YES completion:nil];
        }
        else{
           //GO TO MY WALLET
            
//            SIGN OUT
//            [UserAccessSession clearAllSession];
//            [[FHSTwitterEngine sharedEngine] clearAccessToken];
//            [FBSession.activeSession closeAndClearTokenInformation];
//            [FBSession.activeSession close];
//            [FBSession setActiveSession:nil];
//            [self.slidingViewController resetTopViewAnimated:YES];
        }
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)setImage:(NSString*)imageUrl imageView:(UIImageView*)imgView withBorder:(BOOL)border isThumb:(BOOL)isThumb{
    
    NSURL* url = [NSURL URLWithString:imageUrl];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    __weak typeof(imgView ) weakImgRef = imgView;
    
    NSString* thumbPlaceholder = isThumb ? PROFILE_THUMB_PLACEHOLDER_IMAGE : PROFILE_PLACEHOLDER_IMAGE;
    UIImage* imgPlaceholder = [UIImage imageNamed:thumbPlaceholder];
    
    [imgView setImageWithURLRequest:urlRequest
                   placeholderImage:imgPlaceholder
                            success:^(NSURLRequest* request, NSHTTPURLResponse* response, UIImage* image) {
                                
                                CGSize size = weakImgRef.frame.size;
                                
                                if([MGUtilities isRetinaDisplay]) {
                                    size.height *= 2;
                                    size.width *= 2;
                                }
                                
                                UIImage* croppedImage = [image imageByScalingAndCroppingForSize:size];
                                weakImgRef.image = croppedImage;
                                
                                if(border) {
                                    [MGUtilities createBorders:weakImgRef
                                                   borderColor:THEME_MAIN_COLOR
                                                   shadowColor:[UIColor clearColor]
                                                   borderWidth:CELL_BORDER_WIDTH];
                                }
                                
                                
                                
                            } failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {
                                
    }];
}

-(void) reloadInputViews{
    
    self.user = [UserAccessSession getUserSession];
    
    [self setImage:self.user.thumbPhotoUrl imageView:userProfilePicture withBorder:YES isThumb:YES];
 
    [tableSideView reloadData];

}
 
@end

