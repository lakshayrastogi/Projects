//
//  ViewController.m
//  Braintreetry
//
//  Created by Lakshay Rastogi on 3/3/15.
//  Copyright (c) 2015 Lakshay Rastogi. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <Braintree/Braintree.h>

@interface ViewController () <BTDropInViewControllerDelegate>
@property (nonatomic, strong) Braintree *braintree;
@property (nonatomic, strong) NSString *clientToken;
@property (nonatomic, strong) NSString *nonce;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.clientToken = @"eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiI0OThhZTRhZDNhNTBmYWE0ZTVkZGMyYjJhOWNmZDdhZDY5YjNlOWZiYTI3YWIzZWZkMDAyNDllYTEwZDU2NmZifGNyZWF0ZWRfYXQ9MjAxNS0wMy0wNFQwMDozMDozOS4yMTg3MzkwMjUrMDAwMFx1MDAyNm1lcmNoYW50X2lkPWRjcHNweTJicndkanIzcW5cdTAwMjZwdWJsaWNfa2V5PTl3d3J6cWszdnIzdDRuYzgiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvZGNwc3B5MmJyd2RqcjNxbi9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJjaGFsbGVuZ2VzIjpbXSwiY2xpZW50QXBpVXJsIjoiaHR0cHM6Ly9hcGkuc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbTo0NDMvbWVyY2hhbnRzL2RjcHNweTJicndkanIzcW4vY2xpZW50X2FwaSIsImFzc2V0c1VybCI6Imh0dHBzOi8vYXNzZXRzLmJyYWludHJlZWdhdGV3YXkuY29tIiwiYXV0aFVybCI6Imh0dHBzOi8vYXV0aC52ZW5tby5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIiwiYW5hbHl0aWNzIjp7InVybCI6Imh0dHBzOi8vY2xpZW50LWFuYWx5dGljcy5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIn0sInRocmVlRFNlY3VyZUVuYWJsZWQiOnRydWUsInRocmVlRFNlY3VyZSI6eyJsb29rdXBVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvZGNwc3B5MmJyd2RqcjNxbi90aHJlZV9kX3NlY3VyZS9sb29rdXAifSwicGF5cGFsRW5hYmxlZCI6dHJ1ZSwicGF5cGFsIjp7ImRpc3BsYXlOYW1lIjoiQWNtZSBXaWRnZXRzLCBMdGQuIChTYW5kYm94KSIsImNsaWVudElkIjpudWxsLCJwcml2YWN5VXJsIjoiaHR0cDovL2V4YW1wbGUuY29tL3BwIiwidXNlckFncmVlbWVudFVybCI6Imh0dHA6Ly9leGFtcGxlLmNvbS90b3MiLCJiYXNlVXJsIjoiaHR0cHM6Ly9hc3NldHMuYnJhaW50cmVlZ2F0ZXdheS5jb20iLCJhc3NldHNVcmwiOiJodHRwczovL2NoZWNrb3V0LnBheXBhbC5jb20iLCJkaXJlY3RCYXNlVXJsIjpudWxsLCJhbGxvd0h0dHAiOnRydWUsImVudmlyb25tZW50Tm9OZXR3b3JrIjp0cnVlLCJlbnZpcm9ubWVudCI6Im9mZmxpbmUiLCJ1bnZldHRlZE1lcmNoYW50IjpmYWxzZSwibWVyY2hhbnRBY2NvdW50SWQiOiJzdGNoMm5mZGZ3c3p5dHc1IiwiY3VycmVuY3lJc29Db2RlIjoiVVNEIn0sImNvaW5iYXNlRW5hYmxlZCI6dHJ1ZSwiY29pbmJhc2UiOnsiY2xpZW50SWQiOiJhZTBkMTk4MWI1MzcxNDgzZDZkODA2OTA5M2EwNjY5MjEyMGRiZTM0YWE0NTBlNzY0ZmY2NTI2ZWVmODhiMTlkIiwibWVyY2hhbnRBY2NvdW50IjoiZGV2cytzYW5kYm94LXNhbXBsZS1tZXJjaGFudEBicmFpbnRyZWVwYXltZW50cy5jb20iLCJzY29wZXMiOiJhdXRob3JpemF0aW9uczpicmFpbnRyZWUgdXNlciIsInJlZGlyZWN0VXJsIjoiaHR0cHM6Ly9hc3NldHMuYnJhaW50cmVlZ2F0ZXdheS5jb20vY29pbmJhc2Uvb2F1dGgvcmVkaXJlY3QtbGFuZGluZy5odG1sIn0sIm1lcmNoYW50SWQiOiJkY3BzcHkyYnJ3ZGpyM3FuIiwidmVubW8iOiJvZmZsaW5lIiwiYXBwbGVQYXkiOnsic3RhdHVzIjoibW9jayIsImNvdW50cnlDb2RlIjoiVVMiLCJjdXJyZW5jeUNvZGUiOiJVU0QiLCJtZXJjaGFudElkZW50aWZpZXIiOiJtZXJjaGFudC5jb20uYnJhaW50cmVlcGF5bWVudHMuZGV2LWRjb3BlbGFuZCIsInN1cHBvcnRlZE5ldHdvcmtzIjpbInZpc2EiLCJtYXN0ZXJjYXJkIiwiYW1leCJdfX0=";

//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:@"https://your-server/client_token.json"
//      parameters:@{ @"your-server-authentication": @"token", @"your-customer-session": @"session"}
//         success:^(AFHTTPRequestOperation *operation, id responseObject) {
//             // Setup braintree with responseObject[@"client_token"]
//             self.braintree = [Braintree braintreeWithClientToken:responseObject[self.clientToken]];
//         }
//         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//             // Handle failure communicating with your server
//         }];
}

- (void)postNonceToServer:(NSString *)paymentMethodNonce {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"https://your-server/payment-method-nonce"
       parameters:@{ @"your-server-authentication": @"token",
                     @"your-customer-session": @"session",
                     @"payment-method-nonce": paymentMethodNonce}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              // Handle success
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              // Handle failure communicating with your server
          }];
}
- (IBAction)tapPayButton:(id)sender {
    // Create and retain a `Braintree` instance with the client token
    self.braintree = [Braintree braintreeWithClientToken:self.clientToken];
    // Create a BTDropInViewController
    BTDropInViewController *dropInViewController = [self.braintree dropInViewControllerWithDelegate:self];
    // This is where you might want to customize your Drop in. (See below.)
    
    // In your app delegate
    //self.window.tintColor = [UIColor colorWithRed:255/255.0f green:136/255.0f blue:51/255.0f alpha:1.0f];
    // Or, upon initialization
    dropInViewController.view.tintColor = [UIColor colorWithRed:255/255.0f green:136/255.0f blue:51/255.0f alpha:1.0f];
    dropInViewController.summaryTitle = @"1 Ticket";
    dropInViewController.summaryDescription = @"Wiz Khalifa concert at Nokia Theatre";
    dropInViewController.displayAmount = @"$10";
    dropInViewController.callToActionText = @"Book Now";
    
    
    // The way you present your BTDropInViewController instance is up to you.
    // In this example, we wrap it in a new, modally presented navigation controller:
    dropInViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                                          target:self
                                                                                                          action:@selector(userDidCancelPayment)];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:dropInViewController];
    [self presentViewController:navigationController
                       animated:YES
                     completion:nil];
}

- (void)userDidCancelPayment {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dropInViewController:(__unused BTDropInViewController *)viewController didSucceedWithPaymentMethod:(BTPaymentMethod *)paymentMethod {
    self.nonce = paymentMethod.nonce;
    [self postNonceToServer:self.nonce]; // Send payment method nonce to your server
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dropInViewControllerDidCancel:(__unused BTDropInViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


