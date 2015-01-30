//
//  OCJPositionViewModel.m
//  OctoJobs
//
//  Created by Tyler Stromberg on 1/29/15.
//  Copyright (c) 2015 Tyler Stromberg. All rights reserved.
//

#import "OCJPositionViewModel.h"

#import "OCJPosition.h"

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


#pragma mark - Data Formatting

- (NSString *)subtitle
{
    return [NSString stringWithFormat:@"%@ — %@", self.position.company, self.position.type];
}

- (NSString *)positionDetailsHTML
{
    // Show the position details in our formatted template
    NSString *templatePath = [[NSBundle mainBundle] pathForResource:@"PositionTemplate" ofType:@"html"];
    NSString *template = [NSString stringWithContentsOfFile:templatePath encoding:NSUTF8StringEncoding error:NULL];
    
    NSMutableString *content = [NSMutableString stringWithString:template];
    [content replaceOccurrencesOfString:@"<%= position_title %>"
                             withString:self.position.title
                                options:0
                                  range:NSMakeRange(0, content.length)];
    
    // Logo needs to be injected instead of populated (in case posting doesn't have a logo)
    NSString *logoContents;
    if (![self.position.companyLogoURL isKindOfClass:[NSNull class]])
    {
        logoContents = [NSString stringWithFormat:@"<div class=\"logo\"><img src=\"%@\"></div>",
                        self.position.companyLogoURL];
    }
    else
    {
        logoContents = [NSString string];
    }
    [content replaceOccurrencesOfString:@"<%= company_logo %>"
                             withString:logoContents
                                options:0
                                  range:NSMakeRange(0, content.length)];
    
    // Fill in the rest of the placeholders
    [content replaceOccurrencesOfString:@"<%= position_description %>"
                             withString:self.position.HTMLDescription
                                options:0
                                  range:NSMakeRange(0, content.length)];
    [content replaceOccurrencesOfString:@"<%= how_to_apply %>"
                             withString:self.position.howToApply
                                options:0
                                  range:NSMakeRange(0, content.length)];
    [content replaceOccurrencesOfString:@"<%= position_type %>"
                             withString:self.position.type
                                options:0
                                  range:NSMakeRange(0, content.length)];
    [content replaceOccurrencesOfString:@"<%= position_location %>"
                             withString:self.position.location
                                options:0
                                  range:NSMakeRange(0, content.length)];
    
    return content.copy;
}

@end
