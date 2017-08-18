//
//  CoreDataController.m
//  Tonite
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <objc/runtime.h>
#import "CoreDataController.h"
#import "AppDelegate.h"

@implementation CoreDataController

+(void) deleteAllObjects:(NSString *) entityDescription {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
    	[context deleteObject:managedObject];
    }
    
    NSLog(@"Deleted %d %@ item(s)", (int)items.count, entityDescription);
    
    if (![context save:&error]) {
    	NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
}

+(NSArray*) getEventsByCategoryId:(NSString*)categoryId {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category_id = %@", categoryId];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"event_name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

+(NSArray*) getAllTickets {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Ticket" inManagedObjectContext:context];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ticket_id" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

+(NSArray*) getAllEventsUncompleted {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:context];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"event_name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

+(NSArray*) getAllEvents {
    NSArray* completedEvents = [self getAllEventsUncompleted];
    
    for (Event* event in completedEvents) {
        
        unsigned int count=0;
        objc_property_t *props = class_copyPropertyList([Event class],&count);
        for ( int i=0;i<count;i++ )
        {
            NSString *name = [NSString stringWithUTF8String:property_getName(props[i])];
            NSString *venueName = [name stringByReplacingOccurrencesOfString:@"event_" withString:@"venue_"];
            venueName = [venueName stringByReplacingOccurrencesOfString:@"category_" withString:@"venue_category_"];
            if ([[event valueForKey:name] isEqualToString:@"-"] || [[event valueForKey:name] isEqualToString:@"-1"]) {
                [event setValue:[[self getVenueByVenueId:[event venue_id]] valueForKey:venueName] forKey:name];
            }
        }
    }
    
    return completedEvents;
}

+(NSArray*) getAllVenues {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Venue" inManagedObjectContext:context];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"venue_name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

+(NSArray*) getEventPhotosByEventId:(NSString*)eventId {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"event_id = %@", eventId];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"photo_id" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

+(NSArray*) getEventVideosByEventId:(NSString*)eventId {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Video" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"event_id = %@", eventId];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"video_id" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

+(Photo*) getEventPhotoByEventId:(NSString*)eventId {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"event_id = %@", eventId];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"photo_id" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects.count > 0 ? fetchedObjects[0] : nil;
}

+(Video*) getEventVideoByEventId:(NSString*)eventId {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Video" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"event_id = %@", eventId];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"video_id" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects.count > 0 ? fetchedObjects[0] : nil;
}

+(NSArray*) getCategories {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MainCategory" inManagedObjectContext:context];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

+(NSArray*) getTicketTypes {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TicketType" inManagedObjectContext:context];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ticket_type_id" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

+(NSArray*) getVenueCategories {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"VenueCategory" inManagedObjectContext:context];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"venue_category" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

+(Event*) getEventByEventId:(NSString*)eventId {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"event_id = %@", eventId];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects.count > 0 ? fetchedObjects[0] : nil;
}


+(TicketType*) getTicketTypeByEventId:(NSString*)eventId {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TicketType" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"event_id = %@", eventId];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects.count > 0 ? fetchedObjects[0] : nil;
}

+(Ticket*) getTicketByTicketTypeId:(NSString*)ticketTypeId {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Ticket" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ticket_type_id = %@", ticketTypeId];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects.count > 0 ? fetchedObjects[0] : nil;
}

+(Ticket*) getTicketByUserId:(NSString*)userId {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Ticket" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_id = %@", userId];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects.count > 0 ? fetchedObjects[0] : nil;
}

+(MainCategory*) getCategoryByCategory:(NSString*)category {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MainCategory" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category = %@", category];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects.count > 0 ? fetchedObjects[0] : nil;
}

+(VenueCategory*) getVenueCategoryByVenueCategory:(NSString*)venueCategory {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"VenueCategory" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"venue_category = %@", venueCategory];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects.count > 0 ? fetchedObjects[0] : nil;
}

+(MainCategory*) getCategoryByCategoryId:(NSString*)categoryId {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MainCategory" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category_id = %@", categoryId];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects.count > 0 ? fetchedObjects[0] : nil;
}

+(VenueCategory*) getVenueCategoryByVenueCategoryId:(NSString*)venueCategoryId {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"VenueCategory" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"venue_category_id = %@", venueCategoryId];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects.count > 0 ? fetchedObjects[0] : nil;
}

+(Venue*) getVenueByVenueId:(NSString*)venueId {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Venue" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"venue_id = %@", venueId];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects.count > 0 ? fetchedObjects[0] : nil;
}

+(NSArray*) getCategoryNames {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MainCategory" inManagedObjectContext:context];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSMutableArray* array = [NSMutableArray new];
    
    for(MainCategory* cat in fetchedObjects)
        [array addObject:cat.category];
    
    return array;
}

+(NSArray*) getVenueCategoryNames {
    
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = delegate.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"VenueCategory" inManagedObjectContext:context];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"venue_category" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSMutableArray* array = [NSMutableArray new];
    
    for(MainCategory* cat in fetchedObjects)
        [array addObject:cat.category];
    
    return array;
}


@end
