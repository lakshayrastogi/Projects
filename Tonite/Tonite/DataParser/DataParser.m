//
//  DataParser.m
//  Tonite
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import "DataParser.h"
#import "AppDelegate.h"

@implementation DataParser

+(NSMutableArray*)parseEventFromURLFormatJSON:(NSString*)urlStr {
    
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSDictionary* dict = [self getJSONAtURL:urlStr];
    NSMutableArray* array = [NSMutableArray new];
    if(dict != nil) {
        
        NSDictionary* dictEntry = [dict objectForKey:@"categories"];
        for(NSDictionary* dictCat in dictEntry) {
            
            NSString* className = NSStringFromClass([MainCategory class]);
            NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
            MainCategory* cat = (MainCategory*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
            
            [cat safeSetValuesForKeysWithDictionary:dictCat];
            
            [array addObject:cat];
        }
        
        dictEntry = [dict objectForKey:@"venue_categories"];
        for(NSDictionary* dictCat in dictEntry) {
            
            NSString* className = NSStringFromClass([VenueCategory class]);
            NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
            VenueCategory* venueCat = (VenueCategory*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
            
            [venueCat safeSetValuesForKeysWithDictionary:dictCat];
            
            [array addObject:venueCat];
        }
        
        dictEntry = [dict objectForKey:@"photos"];
        for(NSDictionary* dictCat in dictEntry) {
            
            NSString* className = NSStringFromClass([Photo class]);
            NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
            Photo* photo = (Photo*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
            
            [photo safeSetValuesForKeysWithDictionary:dictCat];
            
            [array addObject:photo];
        }
        
        dictEntry = [dict objectForKey:@"videos"];
        for(NSDictionary* dictCat in dictEntry) {
            
            NSString* className = NSStringFromClass([Video class]);
            NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
            Video* video = (Video*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
            
            [video safeSetValuesForKeysWithDictionary:dictCat];
            
            [array addObject:video];
        }
        
        dictEntry = [dict objectForKey:@"events"];
        for(NSDictionary* dictCat in dictEntry) {
            
            NSString* className = NSStringFromClass([Event class]);
            NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
            Event* event = (Event*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
            
            [event safeSetValuesForKeysWithDictionary:dictCat];
            
            [array addObject:event];
        }
        
        dictEntry = [dict objectForKey:@"venues"];
        for(NSDictionary* dictCat in dictEntry) {
            
            NSString* className = NSStringFromClass([Venue class]);
            NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
            Venue* venue = (Venue*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
            
            [venue safeSetValuesForKeysWithDictionary:dictCat];
            
            [array addObject:venue];
        }
    }
    
    return array;
}

/*+(NSMutableArray*)parseReviewsFromURLFormatJSON:(NSString*)urlStr
                                      loginHash:(NSString*)loginHash
                                        storeId:(NSString*)storeId {
    
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSDictionary* dict = [self getJSONAtURL:urlStr];
    NSMutableArray* array = [NSMutableArray new];
    if(dict != nil) {
        
        NSDictionary* dictEntry = [dict objectForKey:@"reviews"];
        for(NSDictionary* dictCat in dictEntry) {
            
            NSString* className = NSStringFromClass([Review class]);
            NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
            Review* rev = (Review*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
            
            [rev safeSetValuesForKeysWithDictionary:dictCat];
            
            [array addObject:rev];
        }
    }
    
    return array;
}
*/

+(NSMutableArray*)parseTicketFromURLFormatJSON:(NSString*)urlStr {
    
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSDictionary* dict = [self getJSONAtURL:urlStr];
    NSMutableArray* array = [NSMutableArray new];
    if(dict != nil) {
        
        NSDictionary* dictEntry = [dict objectForKey:@"tickets"];
        for(NSDictionary* dictCat in dictEntry) {
            
            NSString* className = NSStringFromClass([Ticket class]);
            NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
            Ticket* ticket = (Ticket*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
            
            [ticket safeSetValuesForKeysWithDictionary:dictCat];
            
            [array addObject:ticket];
        }
        
        dictEntry = [dict objectForKey:@"ticket_types"];
        for(NSDictionary* dictCat in dictEntry) {
            
            NSString* className = NSStringFromClass([TicketType class]);
            NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
            TicketType* ticketType = (TicketType*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
            
            [ticketType safeSetValuesForKeysWithDictionary:dictCat];
            
            [array addObject:ticketType];
        }
    }
    
    return array;
}

+(void)fetchServerData {
    
    if(WILL_DOWNLOAD_DATA && [MGUtilities hasInternetConnection]) {
        
        AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSManagedObjectContext* context = delegate.managedObjectContext;
        
        @try {
            NSMutableArray* arrayData;
            [CoreDataController deleteAllObjects:@"Event"];
            [CoreDataController deleteAllObjects:@"MainCategory"];
            [CoreDataController deleteAllObjects:@"VenueCategory"];
            [CoreDataController deleteAllObjects:@"Photo"];
            [CoreDataController deleteAllObjects:@"Venue"];
            [CoreDataController deleteAllObjects:@"Ticket"];
            [CoreDataController deleteAllObjects:@"TicketType"];
            [CoreDataController deleteAllObjects:@"Video"];
            
            arrayData = [DataParser parseEventFromURLFormatJSON:DATA_JSON_URL];
            if(arrayData != nil && arrayData.count > 0) {
                
                NSError *error;
                if ([context hasChanges] && ![context save:&error]) {
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }
            }
            
            NSArray* arrayTickets = [DataParser parseTicketFromURLFormatJSON:TICKET_JSON_URL];
            if(arrayTickets != nil && arrayTickets.count > 0) {
                
                NSError *error;
                if ([context hasChanges] && ![context save:&error]) {
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"exception = %@", exception.debugDescription);
        }
    }
}

+(void)fetchTicketData {
    
    if(WILL_DOWNLOAD_DATA && [MGUtilities hasInternetConnection]) {
        
        AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSManagedObjectContext* context = delegate.managedObjectContext;
        
        @try {
            
            NSDictionary* dict = [self getJSONAtURL:TICKET_JSON_URL];
            if(dict != nil) {
                
                [CoreDataController deleteAllObjects:@"Ticket"];
                
                NSMutableArray* array = [NSMutableArray new];
                NSDictionary* dictEntry = [dict objectForKey:@"tickets"];
                for(NSDictionary* dictCat in dictEntry) {
                    
                    NSString* className = NSStringFromClass([Ticket class]);
                    NSEntityDescription *entity = [NSEntityDescription entityForName:className
                                                              inManagedObjectContext:context];
                    
                    Ticket* ticket = (Ticket*)[[NSManagedObject alloc] initWithEntity:entity
                                                                  insertIntoManagedObjectContext:context];
                    
                    [ticket safeSetValuesForKeysWithDictionary:dictCat];
                    
                    [array addObject:ticket];
                }
                NSError *error;
                if ([context hasChanges] && ![context save:&error]) {
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"exception = %@", exception.debugDescription);
        }
        
    }
}

+(void)fetchCategoryData {
    
    if(WILL_DOWNLOAD_DATA && [MGUtilities hasInternetConnection]) {
        
        AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSManagedObjectContext* context = delegate.managedObjectContext;
        
        @try {
            
            NSDictionary* dict = [self getJSONAtURL:CATEGORY_JSON_URL];
            if(dict != nil) {
                
                [CoreDataController deleteAllObjects:@"Category"];
                
                NSMutableArray* array = [NSMutableArray new];
                NSDictionary* dictEntry = [dict objectForKey:@"categories"];
                for(NSDictionary* dictCat in dictEntry) {
                    
                    NSString* className = NSStringFromClass([MainCategory class]);
                    NSEntityDescription *entity = [NSEntityDescription entityForName:className
                                                              inManagedObjectContext:context];
                    
                    MainCategory* cat = (MainCategory*)[[NSManagedObject alloc] initWithEntity:entity
                                                       insertIntoManagedObjectContext:context];
                    
                    [cat safeSetValuesForKeysWithDictionary:dictCat];
                    
                    [array addObject:cat];
                }
                NSError *error;
                if ([context hasChanges] && ![context save:&error]) {
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"exception = %@", exception.debugDescription);
        }
        
    }
}

+(void)fetchVenueCategoryData {
    
    if(WILL_DOWNLOAD_DATA && [MGUtilities hasInternetConnection]) {
        
        AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSManagedObjectContext* context = delegate.managedObjectContext;
        
        @try {
            
            NSDictionary* dict = [self getJSONAtURL:VENUECATEGORY_JSON_URL];
            if(dict != nil) {
                
                [CoreDataController deleteAllObjects:@"VenueCategory"];
                
                NSMutableArray* array = [NSMutableArray new];
                NSDictionary* dictEntry = [dict objectForKey:@"categories"];
                for(NSDictionary* dictCat in dictEntry) {
                    
                    NSString* className = NSStringFromClass([VenueCategory class]);
                    NSEntityDescription *entity = [NSEntityDescription entityForName:className
                                                              inManagedObjectContext:context];
                    
                    VenueCategory* cat = (VenueCategory*)[[NSManagedObject alloc] initWithEntity:entity
                                                                insertIntoManagedObjectContext:context];
                    
                    [cat safeSetValuesForKeysWithDictionary:dictCat];
                    
                    [array addObject:cat];
                }
                NSError *error;
                if ([context hasChanges] && ![context save:&error]) {
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"exception = %@", exception.debugDescription);
        }
        
    }
}



@end
