//
//  OCJPositionDetailsViewController.m
//  OctoJobs
//
//  Copyright (c) 2013 Tyler Stromberg. All rights reserved.
//

#import "OCJPositionDetailsViewController.h"

#import "OCJPosition.h"

@interface OCJPositionDetailsViewController () <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end


#pragma mark -

@implementation OCJPositionDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateUI];
}


#pragma mark -

- (void)setPosition:(OCJPosition *)position
{
    _position = position;
    
    if ([self isViewLoaded])
    {
        [self updateUI];
    }
}

- (void)updateUI
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
    
    [self.webView loadHTMLString:content baseURL:nil];
}


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        // Open in Mobile Safari instead
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    return YES;
}

@end
