//
//  User.m
//  Proxi
//
//  Created by Lakshay Rastogi on 1/31/15.
//  Copyright (c) 2015 Lakshay Rastogi. All rights reserved.
//

#import "User.h"

@implementation User

-(instancetype) init
{
    self = [super init];
    
    if (self)
    {
        self.username = @"Lakshay";
    }
    
    return self;
}

@end
