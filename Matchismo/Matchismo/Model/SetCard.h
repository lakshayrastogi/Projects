//
//  SetCard.h
//  Matchismo
//
//  Created by Lakshay Rastogi on 7/22/14.
//  Copyright (c) 2014 Lakshay Rastogi. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *shading;
@property (nonatomic) NSUInteger number;

+ (NSArray *) validColors;
+ (NSArray *) validSymbols;
+ (NSArray *) validShadings;
+ (NSUInteger) maxNumber;
+ (NSArray *) cardsFromText:(NSString *) text;

@end
