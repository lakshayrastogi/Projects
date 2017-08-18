//
//  DetailViewController.m
//  Tonite
//
//
//  Copyright (c) Mangasaur Games. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
#import "ImageViewerController.h"
#import "ZoomAnimationController.h"
#import "QRTicketViewController.h"

@interface DetailViewController () <MGListViewDelegate, UIViewControllerTransitioningDelegate, MGMapViewDelegate> {
    
    MGHeaderView* _headerView;
    MGFooterView* _footerView;
 
    NSArray* _arrayPhotos;
    float _headerHeight;
    BOOL _isFave;
    BOOL _isLoadedView;
}

@property (nonatomic, strong) id<MGAnimationController> animationController;

@end

@implementation DetailViewController

@synthesize tableViewMain;
@synthesize event;
@synthesize venue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        venue = nil;
        _isFave = NO;
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tabBarController.navigationController setNavigationBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
}



-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    
    //***** No Navigation Bar just back buton//
    
   [self.navigationController setNavigationBarHidden:YES animated:NO];
   
    UIButton* itemMenu =[[UIButton alloc] initWithFrame:CGRectMake(20.0, 35.0, 30.0, 27.5)];
    [itemMenu addTarget:self action:@selector(didClickBackButton) forControlEvents:UIControlEventTouchUpInside  ];
    [itemMenu setBackgroundImage:[UIImage imageNamed: BUTTON_BACK] forState: UIControlStateNormal   ];
    [itemMenu setBackgroundImage:[UIImage imageNamed: BUTTON_BACK] forState:UIControlStateSelected];
    [self.view addSubview:itemMenu];
    
    venue = [CoreDataController getVenueByVenueId: event.venue_id];

    _headerView = [[MGHeaderView alloc] initWithNibName:@"HeaderView"];
    if(!venue){
        [_headerView.labelSubtitle setText: [event.event_address stringByDecodingHTMLEntities]];
    }
    else{
        [_headerView.labelSubtitle setText:[venue.venue_name stringByDecodingHTMLEntities]];
    }

    _headerView.imgViewPhoto.contentMode = UIViewContentModeScaleAspectFill;
    _headerView.imgViewPhoto.clipsToBounds = YES;
    _headerView.label1.backgroundColor = [BLACK_TEXT_COLOR colorWithAlphaComponent:0.66];
    _headerView.labelTitle.textColor = WHITE_TEXT_COLOR;
    _headerView.labelSubtitle.textColor = WHITE_TEXT_COLOR;
    _headerView.labelTitle.text = [event.event_name stringByDecodingHTMLEntities];
    
    _arrayPhotos = [CoreDataController getEventPhotosByEventId:event.event_id];
    [_headerView.buttonFave addTarget:self
                                 action:@selector(didClickButtonFave)
                forControlEvents:UIControlEventTouchUpInside];
    

    [_headerView.buttonPhotos addTarget:self
                                 action:@selector(didClickButtonPhotos:)
                       forControlEvents:UIControlEventTouchUpInside];
    
    [_headerView.labelPhotos setText:[NSString stringWithFormat:@"%d", (int)_arrayPhotos.count]];
    
    _headerHeight = _headerView.frame.size.height;
    
    Photo* p = _arrayPhotos == nil || _arrayPhotos.count == 0 ? nil : _arrayPhotos[0];
    
    if(p != nil)
        [self setImage:p.photo_url imageView:_headerView.imgViewPhoto];
    
    
    //******* Static "BUY" Button
    [self.view setBackgroundColor:[UIColor whiteColor]];
    CGFloat buttonHeight = self.view.frame.size.height - 60;
    CGRect rect = CGRectMake(0, buttonHeight, self.view.frame.size.width, 60);
    UIButton* buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyButton setFrame:rect];
    [buyButton setTitle:@"GET TICKETS" forState:UIControlStateNormal];
    [buyButton setTitle:@"GET TICKETS" forState:UIControlStateSelected];
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyButton setBackgroundColor:[UIColor grayColor]];
    [buyButton addTarget:self action:@selector(didClickBuyButton) forControlEvents:UIControlEventTouchUpInside];
    [buyButton setAlpha:0.85];
    [self.view addSubview: buyButton];
    
    
    
    //*** Twitter and Facebook buttons in Footer//
    _footerView = [[MGFooterView alloc] initWithNibName:@"FooterView"];
    [_footerView.buttonFacebook addTarget:self
                                   action:@selector(didClickButtonFacebook:)
                         forControlEvents:UIControlEventTouchUpInside];
    
    [_footerView.buttonTwitter addTarget:self
                                  action:@selector(didClickButtonTwitter:)
                        forControlEvents:UIControlEventTouchUpInside];
   
    tableViewMain.delegate = self;
    [tableViewMain registerNibName:@"DetailCell" cellIndentifier:@"DetailCell"];
    [tableViewMain baseInit];
    tableViewMain.tableView.tableHeaderView = _headerView;
    tableViewMain.tableView.tableFooterView = _footerView;
    tableViewMain.noOfItems = 1;
    tableViewMain.cellHeight = 0;
    [tableViewMain reloadData];
    [tableViewMain tableView].delaysContentTouches = NO;
    
    [self checkFave];

    _isLoadedView = NO;
}

-(void) didClickButtonFave{
    _isFave = YES;
    [self checkFave];
}

-(void)checkFave {
    
   // Favorite* fave = [CoreDataController getFavoriteByStoreId:store.store_id];
    if(_isFave != NO)
        [_headerView.buttonFave setBackgroundImage:[UIImage imageNamed:STARRED_IMG] forState:UIControlStateNormal];
    else
        [_headerView.buttonFave setBackgroundImage:[UIImage imageNamed:LIKE_IMG] forState:UIControlStateNormal];
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

-(void)setImage:(NSString*)imageUrl imageView:(UIImageView*)imgView {
    
    NSURL* url = [NSURL URLWithString:imageUrl];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    __weak typeof(imgView ) weakImgRef = imgView;
    UIImage* imgPlaceholder = [UIImage imageNamed:DETAIL_IMAGE_PLACEHOLDER];
    
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
                                
                            } failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {
                                
                            }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void) didClickBuyButton{
    //*********** GO TO PURCHASING ******************//

    QRTicketViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardQRTicket"];
    
 //   DetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardQRTicket"];
    //vc.event = listViewMain.arrayData[indexPath.row];
    
    vc.event = self.event;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void) didClickBackButton{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)didClickButtonPhotos:(id)sender {
    
    if(_arrayPhotos == nil || _arrayPhotos.count == 0)
        return;
    ImageViewerController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"segueImageViewer"];
    vc.imageArray = _arrayPhotos;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
    
}

-(void) MGListView:(MGListView *)_listView didSelectCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
}

-(UITableViewCell*)MGListView:(MGListView *)listView1 didCreateCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    if(cell != nil) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.labelDescription.textColor = THEME_BLACK_TINT_COLOR ;
        [cell.labelDescription setText:[event.event_desc stringByDecodingHTMLEntities]];
        
        [cell.labelVenueDescription setTextColor: THEME_BLACK_TINT_COLOR];
        [cell.labelVenue setTextColor:THEME_BLACK_TINT_COLOR];
        if(venue){
        [cell.labelVenue setText:[venue.venue_name stringByDecodingHTMLEntities ]];
        [cell.labelVenueDescription setText:venue.venue_desc ];
        }
        else{
        [cell.labelVenue setText:[event.event_address stringByDecodingHTMLEntities ]];
        [cell.labelVenueDescription setText:@"Description about the Venue" ];
        }
        
        
        CGSize size = [cell.labelDescription sizeOfMultiLineLabel];
        CGRect frame = cell.labelDescription.frame;
        cell.labelDescription.frame = frame;
       
        float totalHeightLabel = size.height + frame.origin.y + (18);
        
        if(totalHeightLabel > cell.frame.size.height) {
            frame.size = size;
            cell.labelDescription.frame = frame;
            
            CGRect cellFrame = cell.frame;
            cellFrame.size.height = totalHeightLabel + cell.frame.size.height;
            cell.frame = cellFrame;
        }
        else {
            
            frame.size = size;
            cell.labelDescription.frame = frame;
        }
        
        
        cell.mapViewCell.delegate = self;
        [cell.mapViewCell baseInit];
        cell.mapViewCell.mapView.zoomEnabled = NO;
        cell.mapViewCell.mapView.scrollEnabled = NO;
        
        
       [cell.routeButton addTarget:self
                      action:@selector(didClickButtonRoute:)
                    forControlEvents:UIControlEventTouchUpInside];
    
        

        
        CLLocationCoordinate2D coords = CLLocationCoordinate2DMake([event.lat doubleValue], [event.lon doubleValue]);
        
        if(CLLocationCoordinate2DIsValid(coords)) {
            MGMapAnnotation* ann = [[MGMapAnnotation alloc] initWithCoordinate:coords
                                                                          name:venue.venue_name                                                                   description:event.event_address];
            ann.object = event;
            
            [cell.mapViewCell setMapData:[NSMutableArray arrayWithObjects:ann, nil] ];
            [cell.mapViewCell setSelectedAnnotation:coords];
            [cell.mapViewCell moveCenterByOffset:CGPointMake(0, -40) from:coords];
        }
        
    }
    
    return cell;
}

-(void)MGListView:(MGListView *)_listView scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat yPos = -scrollView.contentOffset.y;
    
    if (yPos > 0) {
        CGRect imgRect = _headerView.imgViewPhoto.frame;
        imgRect.origin.y = scrollView.contentOffset.y;
        imgRect.size.height = _headerHeight + yPos;
        _headerView.imgViewPhoto.frame = imgRect;
    }
}

-(CGFloat)MGListView:(MGListView *)listView cell:(MGListCell*)cell heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 4) {
        [cell.labelDescription setText:event.event_desc];
        CGSize size = [cell.labelDescription sizeOfMultiLineLabel];
        
        return size.height + (CELL_CONTENT_MARGIN * 2);
    }
    
    [cell.labelDescription setText:event.event_desc];
    CGSize size = [cell.labelDescription sizeOfMultiLineLabel];
    CGRect frame = cell.labelDescription.frame;
    CGRect cellFrame = cell.frame;
    
    float totalHeightLabel = size.height + frame.origin.y + (18);
    
    if(totalHeightLabel > cell.frame.size.height) {
        frame.size = size;
        cell.labelDescription.frame = frame;
        
        float heightDiff = totalHeightLabel - cell.frame.size.height;
        
        cellFrame.size.height += heightDiff;
        cell.frame = cellFrame;
    }
    
    
    return cell.frame.size.height;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    self.animationController.isPresenting = YES;
    
    return self.animationController;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.animationController.isPresenting = NO;
    
    return self.animationController;
}

-(void)didClickButtonRoute:(id)sender {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([event.lat doubleValue], [event.lon doubleValue]);
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = event.event_name;
    
    if ([mapItem respondsToSelector:@selector(openInMapsWithLaunchOptions:)]) {
        [mapItem openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving}];
    }
    else {
        NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%f,%f&saddr=Current+Location", coordinate.latitude, coordinate.longitude];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}



-(void)didClickButtonFacebook:(id)sender {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *shareSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [shareSheet setInitialText:LOCALIZED(@"FACEBOOK_STATUS_SHARE")];
        [shareSheet addImage:_headerView.imgViewPhoto.image];
        
        [shareSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                    
                default:
                    break;
            }
        }];
        
        if(!(shareSheet == nil))
            [self presentViewController:shareSheet animated:YES completion:nil];
    }
    else {
        [MGUtilities showAlertTitle:LOCALIZED(@"FACEBOOK_AUTHENTICATION_FAILED")
                            message:LOCALIZED(@"FACEBOOK_AUTHENTICATION_FAILED_MSG")];
    }
}

-(void)didClickButtonTwitter:(id)sender {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [tweetSheet setInitialText:LOCALIZED(@"TWITTER_STATUS_SHARE")];
        [tweetSheet addImage:_headerView.imgViewPhoto.image];
        
        //        [shareSheet addURL:[NSURL URLWithString:_website]];
        
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else {
        [MGUtilities showAlertTitle:LOCALIZED(@"TWITTER_AUTHENTICATION_FAILED")
                            message:LOCALIZED(@"TWITTER_AUTHENTICATION_FAILED_MSG")];
    }
    
}



#pragma mark - MAP Delegate

-(void) MGMapView:(MGMapView*)mapView didSelectMapAnnotation:(MGMapAnnotation*)mapAnnotation {

}
-(void) MGMapView:(MGMapView *)mapView didAccessoryTapped:(MGMapAnnotation *)mapAnnotation    {
    
}

-(void) MGMapView:(MGMapView*)mapView didCreateMKPinAnnotationView:(MKPinAnnotationView*)mKPinAnnotationView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    mKPinAnnotationView.image = [UIImage imageNamed:MAP_PIN];
    mKPinAnnotationView.frame = CGRectMake(0, 0, 20.0, 22.0);
    
}


@end
