//
//  SideViewController.m
//  StoreFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import "SideViewController.h"
#import "AppDelegate.h"
#import "EventViewController.h"
#import "MenuTableViewCell.h"

@interface SideViewController ()

@property (nonatomic, retain) NSArray* categories;
@property (nonatomic,retain) NSArray* backgroundImages;
@end

@implementation SideViewController

@synthesize tableViewSide;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void) viewWillAppear:(BOOL)animated {
    [self reloadInputViews];
    [self.tabBarController.navigationController setNavigationBarHidden:NO];

}

-(void) viewWillDisappear:(BOOL)animated{
    [self.slidingViewController resetTopViewAnimated:NO];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
  // Do any additional setup after loading the view.
    tableViewSide.delegate = self;
    tableViewSide.dataSource = self;
    
    self.categories =
    @[
        @"UCLA",
        @"NIGHTLIFE",
        @"SPORTS",
        @"FOOD",
        @"CULTURE",
        @"MOVIES & FILM",
        @"THE 411",
        @"theGiveBack"
      ];
    
    self.backgroundImages =
    @[
      @"ucla2.jpg",
      @"nightlife.png",
      @"sports.png",
      @"dine.png",
      @"artsCulture.png",
      @"elReyTheatre.png",
      @"the411.png",
      @"thegiveback.png"];

  
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeGesture.cancelsTouchesInView = YES; //So the user can still interact with controls in the modal view
    
    [self.view addGestureRecognizer:swipeGesture];
}

- (void)didReceiveMemoryWarning
{
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
//        [self.tabBarController reloadInputViews];
//        [self.tabBarController setSelectedIndex:0];
    }
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   return (tableViewSide.frame.size.height-65)/3;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return [self.categories count];
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuTableViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    [cell setContentMode:UIViewContentModeScaleToFill];
    [cell.imgBackground setImage: [UIImage imageNamed: self.backgroundImages[indexPath.row]]];
    [cell setBackgroundColor:[UIColor blackColor]];
    [cell.imgBackground setAlpha:.65];
    [cell.labelTitle setText: self.categories[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    // This undoes the Zoom Transition's scale because it affects the other transitions.
    // You normally wouldn't need to do anything like this, but we're changing transitions
    // dynamically so everything needs to start in a consistent state.
    //self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);

  
    if(indexPath.row < 8){
         EventViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardEvent"];
        vc.mainCategoryId= [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        [self.tabBarController.navigationController pushViewController:vc animated:YES];
    }
}


-(void)reloadInputViews     {

    [tableViewSide reloadData];
}

-(void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView  {
    if([scrollView.panGestureRecognizer translationInView:self.view].y < 0)
    {
        [self.tabBarController.navigationController setNavigationBarHidden:YES];
      //  [self.navigationController setNavigationBarHidden:YES];
    }
    else if([scrollView.panGestureRecognizer translationInView:self.view].y > 0)
    {
        [self.tabBarController.navigationController setNavigationBarHidden:NO];
       // [self.navigationController setNavigationBarHidden:NO];
    }

}

-(void) scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y == 0.0){
        [self.tabBarController.navigationController setNavigationBarHidden:NO];
        //[self.navigationController setNavigationBarHidden:NO];
    }
    else{
        [self.tabBarController.navigationController setNavigationBarHidden:YES];
       // [self.navigationController.navigationBar setHidden:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
