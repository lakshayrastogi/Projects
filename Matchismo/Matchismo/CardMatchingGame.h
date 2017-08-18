//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Lakshay Rastogi on 7/11/14.
//  Copyright (c) 2014 Lakshay Rastogi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (instancetype) initWithCardCount: (NSUInteger) count
                         usingDeck: (Deck *) deck;

- (void) chooseCardAtIndex: (NSUInteger) index;
- (Card *) cardAtIndex: (NSUInteger) index;

@property (nonatomic, readonly) NSUInteger score;
@property (nonatomic) NSUInteger maxMatchingCards;
@property (nonatomic, readonly) NSArray *lastChosenCards;
@property (nonatomic, readonly) NSInteger lastScore;

@end
