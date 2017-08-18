//
//  Venue.h
//  Tonite
//
//  Created by Gabriel Pawlowsky on 3/23/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Venue : NSManagedObject

@property (nonatomic, retain) NSString * venue_id;
@property (nonatomic, retain) NSString * icon_id;
@property (nonatomic, retain) NSString * category_id;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * phone_no;
@property (nonatomic, retain) NSString * capacity;
@property (nonatomic, retain) NSString * hours;
@property (nonatomic, retain) NSString * lon;
@property (nonatomic, retain) NSString * lat;
@property (nonatomic, retain) NSString * venue_desc;
@property (nonatomic, retain) NSString * venue_address;
@property (nonatomic, retain) NSString * venue_name;
@property (nonatomic, retain) NSString * updated_at;
@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSString * website;

@end
