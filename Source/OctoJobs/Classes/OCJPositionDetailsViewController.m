//
//  OCJPositionDetailsViewController.m
//  OctoJobs
//
//  Copyright (c) 2013-2015 Tyler Stromberg. All rights reserved.
//

#import "OCJPositionDetailsViewController.h"

#import "OCJPositionViewModel.h"

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

- (void)setViewModel:(OCJPositionViewModel *)viewModel
{
    _viewModel = viewModel;
    
    if ([self isViewLoaded])
    {
        [self updateUI];
    }
}

- (void)updateUI
{
    [self.webView loadHTMLString:self.viewModel.positionDetailsHTML baseURL:nil];
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
