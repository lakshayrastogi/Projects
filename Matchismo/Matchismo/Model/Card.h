//
//  Card.h
//  Matchismo
//
//  Created by Lakshay Rastogi on 7/10/14.
//  Copyright (c) 2014 Lakshay Rastogi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;
@property (nonatomic) NSUInteger numberOfMatchingCards;

@property (nonatomic, getter = isChosen) BOOL chosen;
@property (nonatomic, getter = isMatched) BOOL matched;

- (int)match:(NSArray *)otherCards;

@end
