//
//  VenueCategory.h
//  Tonite
//
//  Created by Gabriel Pawlowsky on 3/23/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface VenueCategory : NSManagedObject

@property (nonatomic, retain) NSString * venue_category_id;
@property (nonatomic, retain) NSString * updated_at;
@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSString * category_icon;
@property (nonatomic, retain) NSString * category;

@end

