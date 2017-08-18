

#import <UIKit/UIKit.h>

@interface EventViewController : UIViewController <MGSliderDelegate, MGListViewDelegate>


@property (retain, nonatomic) IBOutlet MGListView *listViewMain;

@property (nonatomic,retain) NSString* mainCategoryId;

@end
