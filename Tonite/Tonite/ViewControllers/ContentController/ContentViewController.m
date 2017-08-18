

#import "ContentViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "TabBarViewController.h"
#import "LBHamburgerButton.h"

@interface ContentViewController () <MGSliderDelegate, MGListViewDelegate>

@end

@implementation ContentViewController
@synthesize listViewEvents;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.navigationController setNavigationBarHidden:NO];
}

-(void) viewDidAppear:(BOOL)animated   {
    [super viewDidAppear:animated];
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
   // self.automaticallyAdjustsScrollViewInsets = NO;
//    BOOL screen = IS_IPHONE_6_PLUS_AND_ABOVE;
//    if(screen) {
//        CGRect frame = listViewEvents.frame;
//        frame.origin.y =65;
//        frame.size.height = self.view.frame.size.height-65;
//        listViewEvents.frame = frame;
//    }
    listViewEvents.delegate = self;
    listViewEvents.cellHeight = (self.view.frame.size.height-65)/2;
    
    [listViewEvents registerNibName:@"SliderCell" cellIndentifier:@"SliderCell"];
    [listViewEvents baseInit];
    
    [self beginParsing];
    
//    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipeGesture:)];
//    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
//    swipeGesture.cancelsTouchesInView = NO; //So the user can still interact with controls in the modal view
//    
//    [self.slidingViewController.view addGestureRecognizer:swipeGesture];
//    
//    UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipeGesture:)];
//    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
//    swipeRightGesture.cancelsTouchesInView = NO; //So the user can still interact with controls in the modal view
//    
//    [self.slidingViewController.view addGestureRecognizer:swipeRightGesture];
//    
//  
}


- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
  
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

- (void)handleRightSwipeGesture:(UISwipeGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded) {
//        if(self.slidingViewController.currentTopViewPosition == ECSlidingViewControllerTopViewPositionAnchoredLeft){
//        [self.slidingViewController resetTopViewAnimated:YES    ];
//        }
//        else{
//            
//            [self.tabBarController setSelectedIndex:1];
//          
//        }
    }

}

-(void) handleLeftSwipeGesture:(UISwipeGestureRecognizer*) sender{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.slidingViewController anchorTopViewToLeftAnimated:YES onComplete:nil];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)beginParsing {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = LOCALIZED(@"LOADING");
    
    [self.view addSubview:hud];
    [self.view setUserInteractionEnabled:NO];
    [hud showAnimated:YES whileExecutingBlock:^{
        
        [self performParsing];
        
    } completionBlock:^{
        
        [hud removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        
        [self setData];
        [listViewEvents reloadData];
    }];
    
}

-(void) performParsing {
    [DataParser fetchServerData];
}


-(void) setData {
    listViewEvents.arrayData = [NSMutableArray arrayWithArray:[CoreDataController getAllEvents]];
    
}

-(void)didClickButtonGo:(id)sender {
    MGButton* button = (MGButton*)sender;
    DetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardDetail"];
    vc.event = button.object;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setImage:(NSString*)imageUrl imageView:(UIImageView*)imgView {
    NSURL* url = [NSURL URLWithString:imageUrl];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    __weak typeof(imgView ) weakImgRef = imgView;
    UIImage* imgPlaceholder = [UIImage imageNamed:SLIDER_PLACEHOLDER];
    
    [imgView setImageWithURLRequest:urlRequest
                   placeholderImage:imgPlaceholder
                            success:^(NSURLRequest* request, NSHTTPURLResponse* response, UIImage* image) {
                                
                                CGSize size = weakImgRef.frame.size;
                                
                                if([MGUtilities isRetinaDisplay]) {
                                    size.height *= 2;
                                    size.width *= 2;
                                }
                                
                                if(IS_IPHONE_6_PLUS_AND_ABOVE) {
                                    size.height *= 3;
                                    size.width *= 3;
                                }
                                
                                UIImage* croppedImage = [image imageByScalingAndCroppingForSize:size];
                                weakImgRef.image = croppedImage;
                                
                            } failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {
                                
                            }];
}

-(void) MGListView:(MGListView *)_listView didSelectCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    Event* event= [listViewEvents.arrayData objectAtIndex:indexPath.row];
    DetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardDetail"];
    vc.event = event;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(UITableViewCell*)MGListView:(MGListView *)listView1 didCreateCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {

    if(cell!= nil){
    for(UIView* view in cell.subviews)
        [view removeFromSuperview];
    Event* event = [listViewEvents.arrayData objectAtIndex:indexPath.row];
    Venue* venue = [CoreDataController getVenueByVenueId:event.venue_id];
    [cell.slideShow setImageArray:[CoreDataController getEventPhotosByEventId:event.event_id] ];
    [cell.slideShow setNumberOfItems:[cell.slideShow.imageArray count]];
    
    
    if([cell.slideShow.imageArray count] != 0){
    CGRect frame = cell.frame;
    frame.size.width = self.view.frame.size.width;
    frame.size.height = listViewEvents.cellHeight-2 ;
    cell.slideShow.event  = event;
    [cell.slideShow setNeedsReLayoutWithViewSize:frame.size];
    
    //*** Timing of the sliding photos **********//
        // NSInteger randomNumber = arc4random() % 9;
        //float x = (float) (randomNumber/ 9) + 2;
    
    [cell.slideShow startAnimationWithDuration:2.5];
    [cell addSubview:cell.slideShow.scrollView];
    //[cell.contentView addSubview: cell.slideShow.scrollView];
 }
    
    [cell.buttonFave addTarget:self action:@selector(didSelectFave:) forControlEvents:UIControlEventTouchUpInside];
    [cell.buttonFave setBackgroundImage:[UIImage imageNamed:LIKE_IMG] forState:UIControlStateNormal];
    
    
   // [cell.labelExtraInfo setText: event_price????];
        cell.labelTitle.text =event.event_name;
        cell.labelSubtitle.text=  venue.venue_name;
    if(event.event_name == venue.venue_name){
        [cell.labelSubtitle setText:event.event_address];
    }
    NSString* date = [self formatDateWithStart:event.event_date_starttime withEndTime:event.event_endtime];
        [cell.labelDetails setText:date];
        [cell.labelSubtitle setClipsToBounds:YES];
        [cell addSubview: cell.fade ];
        [cell addSubview:cell.labelTitle];
        [cell addSubview:cell.labelSubtitle];
        [cell addSubview:cell.labelExtraInfo];
        [cell addSubview: cell.buttonFave];
        [cell addSubview: cell.divider];
        [cell addSubview: cell.labelDetails];
        [cell addSubview: cell.locationIcon];
        [cell setUserInteractionEnabled:YES];
    }
    return cell;
}

-(void) didSelectFave:(id)sender{
    UIButton* btn = (UIButton* ) sender;
    if(btn.state == UIControlStateSelected){
         [btn setBackgroundImage:[UIImage imageNamed:LIKE_IMG] forState:UIControlStateNormal];
    }
    else{
    [btn setBackgroundImage:[UIImage imageNamed:STARRED_IMG] forState:UIControlStateNormal];
       
    }
}

-(NSString*)formatDateWithStart:(NSString*)dateAndStart withEndTime:(NSString*)endTime{
    NSCharacterSet *charc=[NSCharacterSet characterSetWithCharactersInString:@" "];

    NSString* date = [dateAndStart stringByTrimmingCharactersInSet: charc];
    NSString*start = [dateAndStart substringFromIndex:11];
    NSString* entireDate= @"9PM to Midnight";
    
    return entireDate;
}


-(void)MGListView:(MGListView *)listView scrollViewDidScroll:(UIScrollView *)scrollView {
    if([scrollView.panGestureRecognizer translationInView:self.view].y < 0)
    {
        
        [self.tabBarController.navigationController setNavigationBarHidden:YES];
    }
    else if([scrollView.panGestureRecognizer translationInView:self.view].y > 0)
    {
        [self.tabBarController.navigationController setNavigationBarHidden:NO];
    }

}

@end