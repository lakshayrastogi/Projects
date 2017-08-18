

#import "MGListCell.h"

@implementation MGListCell

@synthesize slideShow;

@synthesize labelTitle;
@synthesize labelSubtitle;
@synthesize topLeftLabelSubtitle;


@synthesize labelDescription;
@synthesize labelInfo;
@synthesize labelDetails;
@synthesize labelExtraInfo;
@synthesize imgViewThumb;
@synthesize imgViewBg;
@synthesize imgViewPic;


@synthesize selectedImage;
@synthesize unselectedImage;
@synthesize imgViewSelectionBackground;

@synthesize selectedColor;
@synthesize unSelectedColor;
@synthesize imgViewArrow;

@synthesize selectedImageArrow;
@synthesize unselectedImageArrow;

@synthesize selectedImageIcon;
@synthesize unselectedImageIcon;

@synthesize imgViewIcon;

@synthesize object;


@synthesize labelStatus;
@synthesize labelDateAdded;
@synthesize labelAddress;
@synthesize labelVenue;

@synthesize labelDateAddedVal;
@synthesize topLeftLabelAddressVal;
@synthesize topLeftLabelAddress2Val;
@synthesize topLeftLabelDescVal;
@synthesize mapViewCell;

@synthesize labelHeader1;
@synthesize labelHeader2;
@synthesize labelHeader3;
@synthesize labelHeader4;
@synthesize imgViewFave;
@synthesize labelVenueDescription;

@synthesize ratingView;

@synthesize buttonDirections;

@synthesize lblNonSelectorTitle;




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // Configure the view for the selected state
    [super setSelected:selected animated:animated];
    
    if(selected) {
        imgViewSelectionBackground.image = selectedImage;
        imgViewArrow.image = selectedImageArrow;
        imgViewIcon.image = selectedImageIcon;
    }
    else {
        imgViewSelectionBackground.image = unselectedImage;
        imgViewArrow.image = unselectedImageArrow;
        imgViewIcon.image = unselectedImageIcon;
    }
}

- (IBAction)routeButton:(UIButton *)sender {
}
@end
