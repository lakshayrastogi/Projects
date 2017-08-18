//
//  PlayingCard.m
//  Matchismo
//
//  Created by Lakshay Rastogi on 7/10/14.
//  Copyright (c) 2014 Lakshay Rastogi. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int) match:(NSArray *)otherCards
{
    int score = 0;
    int numOtherCards = [otherCards count];
    
    if (numOtherCards)
    {
        for (Card *card in otherCards)
        {
            if ([card isKindOfClass:[PlayingCard class]])
            {
                PlayingCard *otherCard = (PlayingCard *) card;
                if ([self.suit isEqualToString:otherCard.suit])
                    score += 1;
                else if (self.rank == otherCard.rank)
                    score += 4;
            }
        }
    }
    
    if (numOtherCards > 1)
        score += [[otherCards firstObject] match:[otherCards subarrayWithRange:NSMakeRange(1, numOtherCards - 1)]];
    
    return score;
}

- (NSString *) contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+ (NSArray *) validSuits
{
    return @[@"♠️", @"♣️", @"♥️", @"♦️"];
}

- (void) setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit])
        _suit = suit;
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J",@"Q", @"K"];
}

+ (NSUInteger) maxRank
{
    return [[self rankStrings] count] - 1;
}

- (void) setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank])
        _rank = rank;
}

@end
