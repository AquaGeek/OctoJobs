//
//  OCJPositionViewModel.h
//  OctoJobs
//
//  Created by Tyler Stromberg on 1/29/15.
//  Copyright (c) 2015 Tyler Stromberg. All rights reserved.
//

@import Foundation;

@class OCJPosition;

@interface OCJPositionViewModel : NSObject

+ (instancetype)viewModelWithPosition:(OCJPosition *)position;
- (instancetype)initWithPosition:(OCJPosition *)position NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) OCJPosition *position;

@property (nonatomic, readonly) NSString *subtitle;

@end
