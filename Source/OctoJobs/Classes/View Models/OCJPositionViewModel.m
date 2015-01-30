//
//  OCJPositionViewModel.m
//  OctoJobs
//
//  Created by Tyler Stromberg on 1/29/15.
//  Copyright (c) 2015 Tyler Stromberg. All rights reserved.
//

#import "OCJPositionViewModel.h"

@implementation OCJPositionViewModel

+ (instancetype)viewModelWithPosition:(OCJPosition *)position
{
    return [[self alloc] initWithPosition:position];
}

- (instancetype)initWithPosition:(OCJPosition *)position
{
    if ((self = [super init]))
    {
        _position = position;
    }
    
    return self;
}

@end
