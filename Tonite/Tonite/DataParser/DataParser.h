//
//  DataParser.h
//  StoreFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataParser : MGParser

+(NSMutableArray*)parseEventFromURLFormatJSON:(NSString*)urlStr;

/*+(NSMutableArray*)parseReviewsFromURLFormatJSON:(NSString*)urlStr
                                      loginHash:(NSString*)loginHash
                                        storeId:(NSString*)storeId;

+(NSMutableArray*)parseNewsFromURLFormatJSON:(NSString*)urlStr;
*/
+(void)fetchServerData;
//+(void)fetchNewsData;
+(void)fetchTicketData;
+(void)fetchCategoryData;

@end
