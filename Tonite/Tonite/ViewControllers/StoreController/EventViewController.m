

#import "EventViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "MGSlider.h"
#import "LBHamburgerButton.h"

@interface EventViewController () <MGSliderDelegate, MGListViewDelegate>

@end

@implementation EventViewController
@synthesize listViewMain;
@synthesize mainCategoryId;

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
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (UIBarButtonItem *)backButton
{
    LBHamburgerButton* button = [[LBHamburgerButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)
                                   
                                                                 lineWidth:22
                                                                lineHeight:10/6
                                                               lineSpacing:5
                                                                lineCenter:CGPointMake(10, 0)
                                                                     color:[UIColor grayColor]];
    [button setCenter:CGPointMake(120, 120)];
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(didClickButtonGo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item= [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return item;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setTitle: [CoreDataController getCategoryByCategoryId:mainCategoryId].category];
    
    [self.navigationItem setLeftBarButtonItem: [self backButton]    ];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view setBackgroundColor:[UIColor grayColor]];
    BOOL screen = IS_IPHONE_6_PLUS_AND_ABOVE;
    if(screen) {
        CGRect frame = listViewMain.frame;
        frame.origin.y =64;
        frame.size.height = self.view.frame.size.height-64;
        listViewMain.frame = frame;
    }
    listViewMain.delegate = self;
    listViewMain.cellHeight = (self.view.frame.size.height-64)/2;
    
    [listViewMain registerNibName:@"SliderCell" cellIndentifier:@"SliderCell"];
    [listViewMain baseInit];
    
    [self beginParsing];
//
//    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
//    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
//    swipeGesture.cancelsTouchesInView = YES; //So the user can still interact with controls in the modal view
//    
//    [self.slidingViewController.view addGestureRecognizer:swipeGesture];
//    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
//    tapGesture.numberOfTapsRequired = 1;
//    tapGesture.cancelsTouchesInView = NO; //So the user can still interact with controls in the modal view
//    
//    [self.view addGestureRecognizer:tapGesture];
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

- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)sender{
    
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
        [listViewMain reloadData];
        
        if(listViewMain.arrayData == nil || listViewMain.arrayData.count == 0) {
            
            UIColor* color = [[UIColor blackColor] colorWithAlphaComponent:0.70];
            [MGUtilities showStatusNotifier:LOCALIZED(@"NO_RESULTS")
                                  textColor:[UIColor whiteColor]
                             viewController:self
                                   duration:0.5f
                                    bgColor:color
                                        atY:64];

    }
    }];
}

-(void) performParsing {
    [DataParser fetchServerData];
}


-(void) setData {
    listViewMain.arrayData = [NSMutableArray arrayWithArray:[CoreDataController getEventsByCategoryId:mainCategoryId    ]];
    
}

-(void)didClickButtonGo:(id)sender {
    LBHamburgerButton* btn = (LBHamburgerButton*)sender;
    [btn switchState];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    
    Event* event= [listViewMain.arrayData objectAtIndex:indexPath.row];
    DetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardDetail"];
    vc.event = event;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(UITableViewCell*)MGListView:(MGListView *)listView1 didCreateCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    if(cell !=nil){

    for(UIView* view in cell.subviews)
        [view removeFromSuperview];
    Event* event = [listViewMain.arrayData objectAtIndex:indexPath.row];
    Venue* venue = [CoreDataController getVenueByVenueId:event.venue_id];
    [cell.slideShow setImageArray:[CoreDataController getEventPhotosByEventId:event.event_id] ];
    [cell.slideShow setNumberOfItems:[cell.slideShow.imageArray count]];
    
    
    if([cell.slideShow.imageArray count] != 0){
        CGRect frame = cell.frame;
        frame.size.width = self.view.frame.size.width;
        frame.size.height = listViewMain.cellHeight-2 ;
        cell.slideShow.event  = event;
        [cell.slideShow setNeedsReLayoutWithViewSize:frame.size];
        
        //*** Timing of the sliding photos **********//
        // NSInteger randomNumber = arc4random() % 9;
        //float x = (float) (randomNumber/ 9) + 2;
        
        [cell.slideShow startAnimationWithDuration:2.5];
        [cell addSubview:cell.slideShow.scrollView];
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
        [self.navigationController setNavigationBarHidden:YES];
    }
    else if([scrollView.panGestureRecognizer translationInView:self.view].y > 0)
    {
        [self.navigationController setNavigationBarHidden:NO];
    }


}

@end