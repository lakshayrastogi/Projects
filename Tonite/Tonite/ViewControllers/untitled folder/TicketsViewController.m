//
//  TicketsViewController.m
//  StoreFinder
//
//  Created by Julie Murakami on 2/19/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import "TicketsViewController.h"
#import "AppDelegate.h"


@interface TicketsViewController() 

@property (nonatomic, retain) NSArray* myTickets;
@end

@implementation TicketsViewController

@synthesize ticketTableView;

- (IBAction)didClickCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [MGUIAppearance createLogo:HEADER_LOGO];
    
   /* self.title = LOCALIZED(@"MY_TICKETS");
    self.view.backgroundColor = BG_VIEW_COLOR;
    
    [MGUIAppearance enhanceNavBarController:self.navigationController
                               barTintColor:WHITE_TEXT_COLOR
                                  tintColor:WHITE_TEXT_COLOR
                             titleTextColor:WHITE_TEXT_COLOR];
    */
    ticketTableView.delegate = self;
    ticketTableView.dataSource  = self;
    
    //Get User's Tickets
    _myTickets  = @[@"Spring Sing", @"Lunar New Year Bash", @"Bruin Bash"];
    
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ticketCell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ticketCell"];
        }
        cell.textLabel.text =[_myTickets objectAtIndex:indexPath.row];
        return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_myTickets count];
}
/*
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    QRCodeViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardQRcode"];
    vc.ticketID = [_myTickets objectAtIndex:indexPath.row] ;
    [self.navigationController pushViewController:vc animated:YES];
}
*/

@end
