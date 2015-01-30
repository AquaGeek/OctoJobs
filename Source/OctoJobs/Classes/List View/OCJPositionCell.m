//
//  OCJPositionCell.m
//  OctoJobs
//
//  Copyright (c) 2013-2015 Tyler Stromberg. All rights reserved.
//

#import "OCJPositionCell.h"

#import "OCJPosition.h"
#import "OCJPositionViewModel.h"

static void *OCJPositionCellKVOContext = &OCJPositionCellKVOContext;

@interface OCJPositionCell()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;

@end


#pragma mark -

@implementation OCJPositionCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(preferredContentSizeChanged:)
                                                     name:UIContentSizeCategoryDidChangeNotification
                                                   object:nil];
        
        [self addObserver:self forKeyPath:@"viewModel.position.title" options:0 context:OCJPositionCellKVOContext];
        [self addObserver:self forKeyPath:@"viewModel.subtitle" options:0 context:OCJPositionCellKVOContext];
        [self addObserver:self forKeyPath:@"viewModel.position.location" options:0 context:OCJPositionCellKVOContext];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setFonts];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == OCJPositionCellKVOContext)
    {
        // Update the labels, etc
        if ([keyPath isEqualToString:@"viewModel.position.title"])
        {
            self.titleLabel.text = self.viewModel.position.title;
        }
        else if ([keyPath isEqualToString:@"viewModel.subtitle"])
        {
            self.detailLabel.text = self.viewModel.subtitle;
        }
        else if ([keyPath isEqualToString:@"viewModel.position.location"])
        {
            self.locationLabel.text = self.viewModel.position.location;
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark -

- (void)preferredContentSizeChanged:(NSNotification *)notification
{
    [self setFonts];
}

- (void)setFonts
{
    UIFontDescriptor *headerDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline];
    headerDescriptor = [headerDescriptor fontDescriptorWithSize:lrint(headerDescriptor.pointSize * 0.9f)];
    self.titleLabel.font = [UIFont fontWithDescriptor:headerDescriptor size:0.0f];
    
    UIFontDescriptor *subheadDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleSubheadline];
    subheadDescriptor = [subheadDescriptor fontDescriptorWithSize:lrint(subheadDescriptor.pointSize * 0.9f)];
    self.detailLabel.font = [UIFont fontWithDescriptor:subheadDescriptor size:0.0f];
    self.locationLabel.font = [UIFont fontWithDescriptor:subheadDescriptor size:0.0f];
}

@end
