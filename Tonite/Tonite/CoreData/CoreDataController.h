//
//  CoreDataController.h
//  EventFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataController : NSObject

+(void)deleteAllObjects:(NSString *)entityDescription;
+(Photo*)getEventPhotoByEventId:(NSString*)eventId;
+(NSArray*)getEventPhotosByEventId:(NSString*)eventId;
+(Video*)getEventVideoByEventId:(NSString*)eventId;
+(NSArray*)getEventVideosByEventId:(NSString*)eventId;

+(NSArray*)getCategories;
+(NSArray*)getVenueCategories;
+(NSArray*)getTicketTypes;

+(NSArray*) getAllEvents;
+(NSArray*) getAllTickets;
+(NSArray*) getAllEventsUncompleted;
+(NSArray*) getAllVenues;

+(NSArray*) getEventsByCategoryId:(NSString*)categoryId;
+(Event*) getEventByEventId:(NSString*)eventId;
+(TicketType*) getTicketTypeByEventId:(NSString*)eventId;
+(Ticket*) getTicketByTicketTypeId:(NSString*)ticketTypeId;
+(Ticket*) getTicketByUserId:(NSString*)userId;
+(MainCategory*) getCategoryByCategory:(NSString*)category;
+(VenueCategory*) getVenueCategoryByVenueCategory:(NSString*)venueCategory;
+(Venue*) getVenueByVenueId:(NSString*)venue;
+(NSArray*) getCategoryNames;
+(MainCategory*) getCategoryByCategoryId:(NSString*)categoryId;
+(NSArray*) getVenueCategoryNames;
+(VenueCategory*) getVenueCategoryByVenueCategoryId:(NSString*)venueCategoryId;

@end
