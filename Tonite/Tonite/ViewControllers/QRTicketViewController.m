//
//  QRTicketViewController.m
//  Tonite
//
//  Created by Sean on 4/9/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import "QRTicketViewController.h"
#import "NSDate+Helper.h"

@interface QRTicketViewController ()

@end

@implementation QRTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor grayColor]];
    [self.navigationController setNavigationBarHidden:NO];
    
    //random string to translate to QR code
    NSString * inputString = self.event.event_name;
    
    //function which generates QR code
    self.imgView.image = [self generateQRCodeFromString:inputString];
    
    //do string stuff
    
    //NSDateFormatter * Dateformats = [[NSDateFormatter alloc]init];
    
    //[Dateformats setDateFormat:[NSDate dbFormatString]];
    //NSDate * myDate = [Dateformats dateFromString:self.event.event_date_starttime];
    
    //NSDate * myDate = [NSDate dateFromString:self.event.event_date_starttime];
    
    
    
    NSDate * myDate = [NSDate dateFromString:self.event.event_date_starttime withFormat:[NSDate dbFormatString]];
    
    self.dateString.text = [NSDate stringForDisplayFromDate:myDate];
    self.timeString.text = [NSDate stringForDisplayFromDate:myDate];
    self.eventNameString.text = self.event.event_name;
    self.venueString.text = self.event.event_address;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//Core Images will natively create a CIImage, given a string
- (CIImage *)createQRForString:(NSString *)qrString
{
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    // Send the image back
    return qrFilter.outputImage;
}

//Translate the CIImage returned by CoreImages, into a more usable UIImage
- (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image withScale:(CGFloat)scale
{
    // Render the CIImage into a CGImage
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:image fromRect:image.extent];
    
    // Now we'll rescale using CoreGraphics
    UIGraphicsBeginImageContext(CGSizeMake(image.extent.size.width * scale, image.extent.size.width * scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
    // We don't want to interpolate (since we've got a pixel-correct image)
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    // Get the image out
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // Tidy up
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    return scaledImage;
}

- (UIImage *)generateQRCodeFromString:(NSString *)inputString
{
    CIImage * qrCode = [self createQRForString:inputString];
    UIImage * qrCodeImg = [self createNonInterpolatedUIImageFromCIImage:qrCode withScale:2*[[UIScreen mainScreen] scale]];
    return qrCodeImg;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
