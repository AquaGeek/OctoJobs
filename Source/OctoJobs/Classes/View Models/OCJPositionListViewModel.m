//
//  OCJPositionListViewModel.m
//  OctoJobs
//
//  Created by Tyler Stromberg on 1/29/15.
//  Copyright (c) 2015 Tyler Stromberg. All rights reserved.
//

#import "OCJPositionListViewModel.h"

#import "OCJAPIClient.h"
#import "OCJPosition.h"
#import "OCJPositionViewModel.h"

@interface OCJPositionListViewModel()

@property (nonatomic) BOOL positionsLoaded;

@end


#pragma mark -

@implementation OCJPositionListViewModel
{
    NSArray *_positions;
}

- (void)reloadPositionsWithCompletionHandler:(void (^)(NSError *))handler
{
    // TODO: Do we want Markdown instead of HTML?
    //       - If so, append "?markdown=1"
    [[OCJAPIClient sharedClient] getPath:@"positions.json"
                       completionHandler:^(NSData *data, NSError *error) {
                           if (data)
                           {
                               NSArray *rawPositions = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                               
                               NSMutableArray *newPositions = [NSMutableArray arrayWithCapacity:rawPositions.count];
                               
                               for (NSDictionary *positionInfo in rawPositions)
                               {
                                   OCJPosition *position = [OCJPosition positionWithDictionary:positionInfo];
                                   OCJPositionViewModel *viewModel = [OCJPositionViewModel viewModelWithPosition:position];
                                   
                                   if (viewModel)
                                   {
                                       [newPositions addObject:viewModel];
                                   }
                               }
                               
                               _positions = [newPositions copy];
                               self.positionsLoaded = YES;
                           }
                           
                           if (handler)
                           {
                               handler(error);
                           }
                       }];
}

@end
