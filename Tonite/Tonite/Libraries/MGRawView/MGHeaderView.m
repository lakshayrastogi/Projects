//
//  MGHeaderView.m
//  StoreFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import "MGHeaderView.h"

@implementation MGHeaderView

@synthesize ratingView;
@synthesize buttonFave;
@synthesize imgViewFeatured;
@synthesize labelVenueName;
@synthesize labelEventName;
@synthesize labelPrice;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
