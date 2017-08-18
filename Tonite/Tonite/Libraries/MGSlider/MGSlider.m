

#import "MGSlider.h"

@implementation MGSlider

@synthesize numberOfItems = _numberOfItems;
@synthesize scrollView;
@synthesize nibName;
@synthesize event;
@synthesize willAnimate = _willAnimate;
@synthesize scrollWidth;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect rectScrollView = self.frame;
        rectScrollView.origin.y = 0;
        scrollView = [[UIScrollView alloc] initWithFrame:rectScrollView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

-(void) setNeedsReLayoutWithViewSize:(CGSize)viewSize {
    _willAnimate = YES;
    for(UIView* view in self.subviews)
        [view removeFromSuperview];
    
    if(_scrollingTimer != nil)
        [_scrollingTimer invalidate];
    
    CGRect rectScrollView = self.frame;
    rectScrollView.origin.y = 0;
    if(scrollView == nil) {
        scrollView = [[UIScrollView alloc] initWithFrame:rectScrollView];
    }
    scrollView.delegate = self;
    
    int posX = 0;
    for(int x = 0; x < _numberOfItems; x++) {
        UIImageView* sliderView = [[UIImageView alloc] initWithFrame:CGRectMake(posX, 0.0, viewSize.width, viewSize.height)];
        Photo*p = self.imageArray[x];
        [self setImage:p.photo_url imageView: sliderView];
        [scrollView addSubview:sliderView];
        posX += viewSize.width;
    }
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.frame = CGRectMake(0.0, 0.0, viewSize.width, viewSize.height);
    scrollView.contentSize = CGSizeMake(posX, scrollView.frame.size.height);
    scrollWidth = viewSize.width;
    [scrollView setUserInteractionEnabled:NO];
//    UISwipeGestureRecognizer* swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft:)];
//    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
//    [scrollView addGestureRecognizer:swipeLeft];
//    
//    UISwipeGestureRecognizer* swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight:)];
//    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
//    [scrollView addGestureRecognizer:swipeRight];
//
//    
    }

//-(void) swipeRight:(UISwipeGestureRecognizer*) sender{
//    [self scrollingTimer ];
//}
//
//-(void) swipeLeft:(UISwipeGestureRecognizer*) sender{
//    int nextPage = (int)(scrollView.contentOffset.x/scrollWidth) - 1;
//    CGRect rect = CGRectZero;
//    if( nextPage == 0 ) {
//        rect = CGRectMake(scrollView.frame.size.width -scrollWidth, 0, scrollWidth, scrollView.frame.size.height);
//        [scrollView scrollRectToVisible:rect animated:YES];
//    }
//    else{
//        rect = CGRectMake(nextPage*scrollWidth, 0, scrollWidth, scrollView.frame.size.height);
//        [scrollView scrollRectToVisible:rect animated:YES];
//    }
//}

-(void) startAnimationWithDuration:(float)duration {
    if(!_willAnimate)
        return;
    _scrollingTimer = [NSTimer scheduledTimerWithTimeInterval:duration
                                                       target:self
                                                     selector:@selector(scrollingTimer)
                                                     userInfo:nil
                                                      repeats:YES];
    
}


-(void)didCreateSliderViewAtIndex:(int)index {
    Photo*p = self.imageArray[index];
    UIImageView* view = scrollView.subviews[index];
    [self setImage:p.photo_url imageView:view];
    
}


- (void)scrollingTimer {
    
    int nextPage = (int)(scrollView.contentOffset.x/scrollWidth) + 1;
    CGRect rect = CGRectZero;
    
    if( nextPage == _numberOfItems ) {
        rect = CGRectMake(0, 0, scrollWidth, scrollView.frame.size.height);
        [scrollView scrollRectToVisible:rect animated:YES];
    }
    else{
        rect = CGRectMake(nextPage*scrollWidth, 0, scrollWidth, scrollView.frame.size.height);
        [scrollView scrollRectToVisible:rect animated:YES];
    }
}

-(void)stopAnimation {
    _willAnimate = NO;
}

-(void)resumeAnimation {
    _willAnimate = YES;
}


-(void)setImage:(NSString*)imageUrl imageView:(UIImageView*)imgView {
    
    NSURL* url = [NSURL URLWithString:imageUrl];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    __weak typeof(imgView ) weakImgRef = imgView;
    UIImage* imgPlaceholder = [UIImage imageNamed:LIST_EVENT_PLACEHOLDER];
    
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


@end

