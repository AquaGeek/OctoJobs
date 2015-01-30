//
//  OCJPositionCell.m
//  OctoJobs
//
//  Copyright (c) 2013-2015 Tyler Stromberg. All rights reserved.
//

#import "OCJPositionCell.h"

#import "OCJPosition.h"

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

- (void)setPosition:(OCJPosition *)position
{
    _position = position;
    
    // Update the labels, etc
    self.titleLabel.text = position.title;
    self.detailLabel.text = [NSString stringWithFormat:@"%@ — %@", position.company, position.type];
    self.locationLabel.text = position.location;
}

@end
