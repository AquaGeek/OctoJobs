//
//  OCJPosition.h
//  OctoJobs
//
//  Copyright (c) 2013-2015 Tyler Stromberg. All rights reserved.
//

@import Foundation;

@interface OCJPosition : NSObject

@property (nonatomic, copy, readonly) NSString *id;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *location;
@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, copy, readonly) NSString *HTMLDescription;
@property (nonatomic, copy, readonly) NSString *howToApply;
@property (nonatomic, copy, readonly) NSString *company;
@property (nonatomic, copy, readonly) NSString *companyURL;
@property (nonatomic, copy, readonly) NSString *companyLogoURL;
@property (nonatomic, readonly) NSDate *createdAt;

+ (instancetype)positionWithDictionary:(NSDictionary *)dictionary;

@end
