//
//  TextEntry.h
//  Tonite
//
//  Created by Gabriel Pawlowsky on 3/23/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TextEntry : NSManagedObject

@property (nonatomic, retain) NSString * text_entry_id;
@property (nonatomic, retain) NSString * text_entry_title;
@property (nonatomic, retain) NSString * text_entry_content;
@property (nonatomic, retain) NSString * category_id;
@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSString * updated_at;

@end
