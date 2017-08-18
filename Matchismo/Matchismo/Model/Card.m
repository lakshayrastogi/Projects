//
//  Card.m
//  Matchismo
//
//  Created by Lakshay Rastogi on 7/10/14.
//  Copyright (c) 2014 Lakshay Rastogi. All rights reserved.
//

#import "Card.h"

@implementation Card

- (NSUInteger) numberOfMatchingCards
{
    if (!_numberOfMatchingCards)
        _numberOfMatchingCards = 2;
    return _numberOfMatchingCards;
}

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (Card *card in otherCards)
    {
        if ([card.contents isEqualToString:self.contents])
            score = 1;
    }
    
    return score;
}

@end
