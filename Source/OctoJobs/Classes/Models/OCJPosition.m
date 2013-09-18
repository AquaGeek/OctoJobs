//
//  OCJPosition.m
//  OctoJobs
//
//  Copyright (c) 2013 Tyler Stromberg. All rights reserved.
//

#import "OCJPosition.h"

@interface OCJPosition()

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *HTMLDescription;
@property (nonatomic, copy) NSString *howToApply;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *companyURL;
@property (nonatomic, copy) NSString *companyLogoURL;
@property (nonatomic, strong) NSDate *createdAt;

@end


#pragma mark -

@implementation OCJPosition

+ (instancetype)positionWithDictionary:(NSDictionary *)dictionary
{
    OCJPosition *newPosition = [self new];
    
    newPosition.id = dictionary[@"id"];
    newPosition.title = dictionary[@"title"];
    newPosition.location = dictionary[@"location"];
    newPosition.type = dictionary[@"type"];
    newPosition.HTMLDescription = dictionary[@"description"];
    newPosition.howToApply = dictionary[@"how_to_apply"];
    newPosition.company = dictionary[@"company"];
    newPosition.companyURL = dictionary[@"company_url"];
    newPosition.companyLogoURL = dictionary[@"company_logo"];
    newPosition.createdAt = [[self dateFormatter] dateFromString:dictionary[@"created_at"]];
    
    return newPosition;
}

+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *formatter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [NSDateFormatter new];
        formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.dateFormat = @"EEE MMM dd HH:mm:ss 'UTC' yyyy";
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    });
    
    return formatter;
}

@end
