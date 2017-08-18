//
//  Deck.h
//  Matchismo
//
//  Created by Lakshay Rastogi on 7/10/14.
//  Copyright (c) 2014 Lakshay Rastogi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void) addCard: (Card *) card atTop: (BOOL) atTop;
- (void) addCard: (Card *) card;

- (Card *) drawRandomCard;

@end
