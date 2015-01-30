//
//  OCJAPIClient.h
//  OctoJobs
//
//  Copyright (c) 2013-2015 Tyler Stromberg. All rights reserved.
//

@import Foundation;

@interface OCJAPIClient : NSObject

+ (instancetype)sharedClient;

// Note: The completion handler may be called on a thread other than the one originally used to invoke this method.
- (void)getPath:(NSString *)path completionHandler:(void (^)(NSData *, NSError *))completionHandler;

@end
