//
//  OCJPositionListViewModel.h
//  OctoJobs
//
//  Created by Tyler Stromberg on 1/29/15.
//  Copyright (c) 2015 Tyler Stromberg. All rights reserved.
//

@import Foundation;

@class OCJPositionViewModel;

@interface OCJPositionListViewModel : NSObject

@property (nonatomic, readonly) BOOL positionsLoaded;
- (void)reloadPositionsWithCompletionHandler:(void (^)(NSError *))handler;

@property (nonatomic, readonly) NSArray *positions;

@end
