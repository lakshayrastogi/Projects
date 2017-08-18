//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Lakshay Rastogi on 7/10/14.
//  Copyright (c) 2014 Lakshay Rastogi. All rights reserved.
//
//  Abstract class

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController

// protected
// for subclasses
- (Deck *) createDeck; // abstract
- (NSAttributedString *) titleForCard: (Card *) card;
- (UIImage *) backgroundImageForCard: (Card *) card;
- (void) updateUI;

@property (weak, nonatomic) IBOutlet UILabel *flipDescription;
@property (strong, nonatomic) NSMutableArray *flipHistory; // of NSStrings

@end
