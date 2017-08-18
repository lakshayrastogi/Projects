//
//  AppRun.m
//  Proxi
//
//  Created by Lakshay Rastogi on 1/31/15.
//  Copyright (c) 2015 Lakshay Rastogi. All rights reserved.
//

#import "AppRun.h"

@implementation AppRun

-(User *)myUser
{
    if(!_myUser)
        _myUser = [[User alloc] init];
    return _myUser;
}

@end
