//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Lakshay Rastogi on 7/22/14.
//  Copyright (c) 2014 Lakshay Rastogi. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (id) init
{
    self = [super init];
    
    if (self)
    {
        for (NSString *color in [SetCard validColors])
        {
            for (NSString *symbol in [SetCard validSymbols])
            {
                for (NSString *shading in [SetCard validShadings])
                {
                    for (NSUInteger number = 1; number <= [SetCard maxNumber]; number++)
                    {
                        SetCard *card = [[SetCard alloc] init];
                        card.color = color;
                        card.symbol = symbol;
                        card.shading = shading;
                        card.number = number;
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    
    return self;
}

@end
