//
//  PlayingCard.h
//  Matchismo
//
//  Created by Lakshay Rastogi on 7/10/14.
//  Copyright (c) 2014 Lakshay Rastogi. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *) validSuits;
+ (NSUInteger) maxRank;

@end