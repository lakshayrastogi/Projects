//
//  Config.h
//  Tonite
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#ifndef Tonite_Config_h
#define Tonite_Config_h

// Change this on your own consumer key
#define TWITTER_CONSUMER_KEY @"15ooS5bXc3vSK3tmwEMC3Cbtv"

// Change this on your own consumer secret
#define TWITTER_CONSUMER_SECRET @"LGctMNKYCUHL1gw1PlSuhTCQvhrbhhJlt31PbQr2VZDy49SJKu"

// You AdMob Banner Unit ID
#define BANNER_UNIT_ID @"ca-app-pub-2715300260198944/9530294111"

// Your email that you wish that users on your app will contact you.
#define ABOUT_US_EMAIL @"admin@tableservicetonite.com"

// Change this url depending on the name of your web hosting.
#define BASE_URL @"http://www.tableservicetonite.com/tonite/"

// KILOMETER TO MILES CONVERSION
#define KM_TO_MILES 0.621371f


// DO NOT EDIT THIS
// WE USE THIS FOR DEBUGGING PURPOSES
#define WILL_DOWNLOAD_DATA YES

// DO NOT EDIT THIS
#define CATEGORY_JSON_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"rest/categories.php"]

// DO NOT EDIT THIS
#define VENUECATEGORY_JSON_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"rest/venue_categories.php"]

// DO NOT EDIT THIS
#define TICKET_JSON_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"rest/tickets.php"]

// DO NOT EDIT THIS
#define DATA_JSON_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"rest/data.php"]

// DO NOT EDIT THIS
#define REGISTER_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"rest/register.php"]

// DO NOT EDIT THISz
#define USER_PHOTO_UPLOAD_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"rest/file_uploader_user_photo.php"]

// DO NOT EDIT THIS
#define LOGIN_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"rest/login.php"]

// DO NOT EDIT THIS
#define UPDATE_USER_PROFILE_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"rest/update_user_profile.php"]

// DO NOT EDIT THIS
#define STATUS_SUCCESS @"-1"

// DO NOT EDIT THIS
#define STATUS_ERROR_LOGIN @"1"

// DO NOT EDIT THIS
#define STATUS_ERROR_CREDENTIALS @"2"

// DO NOT EDIT THIS
#define STATUS_ERROR_INVALID_ACCESS @"3"

// DO NOT EDIT THIS
#define STATUS_ERROR_USERNAME_EXIST @"4"

// DO NOT EDIT THIS
#define STATUS_ERROR_OUT_OF_SYNC @"5"

// DO NOT EDIT THIS
#define STATUS_CAN_RATE @"1"

// DO NOT EDIT THIS
#define ANCHOR_LEFT_PEEK 100

#endif
