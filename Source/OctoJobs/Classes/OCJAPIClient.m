//
//  OCJAPIClient.m
//  OctoJobs
//
//  Copyright (c) 2013-2015 Tyler Stromberg. All rights reserved.
//

#import "OCJAPIClient.h"

@implementation OCJAPIClient
{
@private
    NSURL *_baseURL;
    NSURLSession *_session;
}

+ (instancetype)sharedClient
{
    static OCJAPIClient *sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [self new];
    });
    
    return sharedClient;
}

- (id)init
{
    if ((self = [super init]))
    {
        _baseURL = [NSURL URLWithString:@"https://jobs.github.com/"];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.HTTPAdditionalHeaders = @{};  // TODO: Any headers to add?
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    
    return self;
}


#pragma mark -

- (void)getPath:(NSString *)path completionHandler:(void (^)(NSData *, NSError *))completionHandler;
{
    NSURL *fullURL = [NSURL URLWithString:path relativeToURL:_baseURL];
    NSURLSessionDataTask *task = [_session dataTaskWithURL:fullURL
                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                             if (completionHandler)
                                             {
                                                 completionHandler(data, error);
                                             }
                                         }];
    [task resume];
}

@end
