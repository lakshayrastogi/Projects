//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Lakshay Rastogi on 7/22/14.
//  Copyright (c) 2014 Lakshay Rastogi. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (Deck *) createDeck
{
    return [[PlayingCardDeck alloc] init];
}

@end
