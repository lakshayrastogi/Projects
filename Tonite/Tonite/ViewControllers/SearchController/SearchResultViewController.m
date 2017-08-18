//
//  SearchResultViewController.m
//  Tonite
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import "SearchResultViewController.h"
#import "DetailViewController.h"

@interface SearchResultViewController () <MGListViewDelegate>

@end

@implementation SearchResultViewController

@synthesize listViewMain;
@synthesize arrayResults;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    [self.navigationController setDelegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [MGUIAppearance createLogo:HEADER_LOGO];
    self.view.backgroundColor = BG_VIEW_COLOR;
    
    [MGUIAppearance enhanceNavBarController:self.navigationController
                               barTintColor:WHITE_TEXT_COLOR
                                  tintColor:WHITE_TEXT_COLOR
                             titleTextColor:WHITE_TEXT_COLOR];
    
    listViewMain.delegate = self;
    
    BOOL screen = IS_IPHONE_6_PLUS_AND_ABOVE;
    listViewMain.cellHeight = screen ? 300 : 250;
    
    [listViewMain registerNibName:@"SearchResultCell" cellIndentifier:@"SearchResultCell"];
    [listViewMain baseInit];
    
    
    /*NSArray *sortedArray = [arrayResults sortedArrayUsingComparator: ^(Event* obj1, Event* obj2) {
        
        if ([obj1.distance floatValue] == 0 && [obj2.distance floatValue] == 0) {
            return (NSComparisonResult)NSOrderedSame;
        }
        
        if ([obj1.distance floatValue] < [obj2.distance floatValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        return (NSComparisonResult)NSOrderedDescending;
    }];
    
    listViewMain.arrayData = [NSMutableArray arrayWithArray:sortedArray];*/
    [listViewMain reloadData];
    
}

-(void)didClickBarButtonMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
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

-(void) MGListView:(MGListView *)_listView didSelectCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    DetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardDetail"];
    vc.event = listViewMain.arrayData[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(UITableViewCell*)MGListView:(MGListView *)listView1 didCreateCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    if(cell != nil) {
        Event* event = [listViewMain.arrayData objectAtIndex:indexPath.row];
        Photo* p = [CoreDataController getEventPhotoByEventId:event.event_id];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.labelTitle setText:event.event_name];
        [cell.labelSubtitle setText:event.event_address];
        [cell.labelDescription setText:event.phone_no];
        
        /*if([event.distance containsString:LOCALIZED(@"NOT_AVAILABLE")]) {
            [cell.labelDetails setText:LOCALIZED(@"NO_DISTANCE_SEARCH")];
        }
        else {
            double km = [event.distance doubleValue];
            NSString* strKm = [NSString stringWithFormat:@"%.2f %@", km, LOCALIZED(@"KILOMETERS")];
            [cell.labelDetails setText:strKm];
        }*/
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        [cell.labelDescription setText:event.phone_no];
        
        if(p != nil)
            [self setImage:p.thumb_url imageView:cell.imgViewThumb];
        else
            [self setImage:nil imageView:cell.imgViewThumb];
        
        
        cell.labelHeader1.backgroundColor = [BLACK_TEXT_COLOR colorWithAlphaComponent:0.66];
        cell.labelDetails.backgroundColor = [BLACK_TEXT_COLOR colorWithAlphaComponent:0.66];
        
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

-(void)setImage:(NSString*)imageUrl imageView:(UIImageView*)imgView {
    
    NSURL* url = [NSURL URLWithString:imageUrl];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    __weak typeof(imgView ) weakImgRef = imgView;
    UIImage* imgPlaceholder = [UIImage imageNamed:SLIDER_PLACEHOLDER];
    
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
