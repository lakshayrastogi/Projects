//
//  MyEventsController.m
//  Tonite
//
//  Created by Julie Murakami on 2/19/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import "MyEventsController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "LBHamburgerButton.h"

@interface MyEventsController() <MGListViewDelegate >


@end

@implementation MyEventsController

@synthesize listViewMain;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated   {
    [self.navigationController setNavigationBarHidden:YES];
    [self.tabBarController.navigationController setNavigationBarHidden:NO];
    [self beginParsing];
    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    listViewMain.delegate = self;
    BOOL screen = IS_IPHONE_6_PLUS_AND_ABOVE;
    listViewMain.cellHeight = screen ? 300 : 250;
    
    [listViewMain registerNibName:@"FeaturedCell" cellIndentifier:@"FeaturedCell"];
    [listViewMain baseInit];

}



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
        [listViewMain reloadData];
        
        if(listViewMain.arrayData == nil || listViewMain.arrayData.count == 0) {
            
            UIColor* color = [THEME_ORANGE_COLOR colorWithAlphaComponent:0.70];
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
    
    listViewMain.arrayData = [NSMutableArray arrayWithArray:[CoreDataController getAllEvents]];
  //  NSArray* x = [CoreDataController getAllVenues];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) MGListView:(MGListView *)_listView didSelectCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    [cell.imgViewThumb stopAnimating];
    DetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardDetail"];
    vc.event = listViewMain.arrayData[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(UITableViewCell*)MGListView:(MGListView *)listView1 didCreateCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    if(cell != nil) {
        Event* event = [listViewMain.arrayData objectAtIndex:indexPath.row];
        NSArray* arrayPhotos = [CoreDataController getEventPhotosByEventId:event.event_id];
     
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        [cell.labelDescription setText:event.phone_no];
        NSInteger numOfEventPhotos = arrayPhotos.count;
        if(numOfEventPhotos == 0 ||
           arrayPhotos == nil){
            [self setImage:nil imageView:cell.imgViewThumb];
        }
        else{
            Photo* p = arrayPhotos[0];
            [self setImage:p.photo_url imageView:cell.imgViewThumb];
     
        }
        
        cell.labelHeader1.backgroundColor = [BLACK_TEXT_COLOR colorWithAlphaComponent:0.66];
        
        cell.lblNonSelectorTitle.textColor = THEME_ORANGE_COLOR;
        cell.labelSubtitle.textColor = WHITE_TEXT_COLOR;
        
        cell.lblNonSelectorTitle.text = event.event_name;
        cell.labelSubtitle.text = event.event_address;
        
        cell.ratingView.notSelectedImage = [UIImage imageNamed:STAR_EMPTY];
        cell.ratingView.halfSelectedImage = [UIImage imageNamed:STAR_HALF];
        cell.ratingView.fullSelectedImage = [UIImage imageNamed:STAR_FILL];
        cell.ratingView.editable = YES;
        cell.ratingView.maxRating = 5;
        cell.ratingView.midMargin = 0;
        cell.ratingView.userInteractionEnabled = NO;
    }
    
    return cell;
}


-(void)MGListView:(MGListView *)listView scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

-(UIImageView*)setImage:(NSString*)imageUrl imageView:(UIImageView*)imgView {
    
    NSURL* url = [NSURL URLWithString:imageUrl];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    __weak typeof(imgView ) weakImgRef = imgView;
    UIImage* imgPlaceholder = [UIImage imageNamed:LIST_EVENT_PLACEHOLDER];
    
    [MGUtilities createBorders:weakImgRef
                   borderColor:THEME_MAIN_COLOR
                   shadowColor:[UIColor clearColor]
                   borderWidth:CELL_BORDER_WIDTH];
    
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
    return imgView;
}



@end

