//
//  OCJJobListViewController.m
//  OctoJobs
//
//  Copyright (c) 2013-2015 Tyler Stromberg. All rights reserved.
//

#import "OCJJobListViewController.h"

#import "OCJAPIClient.h"
#import "OCJPosition.h"
#import "OCJPositionCell.h"
#import "OCJPositionDetailsViewController.h"
#import "OCJPositionViewModel.h"

@implementation OCJJobListViewController
{
@private
    NSArray *_positions;
    OCJPositionCell *_offscreenCell;
}

#pragma mark Object Lifecycle

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

#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(reloadJobs:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_positions.count == 0)
    {
        [self.refreshControl beginRefreshing];
        [self.tableView setContentOffset:CGPointMake(0.0f, -CGRectGetHeight(self.refreshControl.bounds)) animated:animated];
        [self reloadJobs:self.refreshControl];
    }
}


#pragma mark -

- (void)preferredContentSizeChanged:(NSNotification *)notification
{
    // Reload the table AFTER the cells have a chance to update
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void)reloadJobs:(id)sender
{
    // TODO: Do we want Markdown instead of HTML?
    // If so, append "?markdown=1"
    [[OCJAPIClient sharedClient] getPath:@"positions.json"
                       completionHandler:^(NSData *data, NSError *error) {
                           if (!error)
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
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [self.tableView reloadData];
                                   [self.refreshControl endRefreshing];
                               });
                           }
                           else
                           {
                               // TODO: Show the error
                               NSLog(@"An error occurred while fetching postings: %@", error.localizedDescription);
                           }
                       }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"PositionDetailsSegue"])
    {
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        OCJPositionViewModel *viewModel = _positions[selectedIndexPath.row];
        OCJPosition *selectedPosition = viewModel.position;
        
        ((OCJPositionDetailsViewController *)segue.destinationViewController).position = selectedPosition;
    }
}


#pragma mark - UITableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _positions.count;
}

static NSString *CellIdentifier = @"JobCell";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OCJPositionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    OCJPositionViewModel *viewModel = _positions[indexPath.row];
    cell.position = viewModel.position;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_offscreenCell)
    {
        _offscreenCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    OCJPositionViewModel *viewModel = _positions[indexPath.row];
    _offscreenCell.position = viewModel.position;
    
    // Let Auto Layout figure out how tall the cell needs to be
    CGSize cellSize = [_offscreenCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return cellSize.height;
}

@end
