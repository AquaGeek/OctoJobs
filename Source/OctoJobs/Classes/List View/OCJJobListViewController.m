//
//  OCJJobListViewController.m
//  OctoJobs
//
//  Copyright (c) 2013-2015 Tyler Stromberg. All rights reserved.
//

#import "OCJJobListViewController.h"

#import "OCJPositionCell.h"
#import "OCJPositionDetailsViewController.h"
#import "OCJPositionListViewModel.h"
#import "OCJPositionViewModel.h"

@implementation OCJJobListViewController
{
    OCJPositionListViewModel *_listViewModel;
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
        
        _listViewModel = [[OCJPositionListViewModel alloc] init];
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
    
    if (!_listViewModel.positionsLoaded)
    {
        [self.refreshControl beginRefreshing];
        [self.tableView setContentOffset:CGPointMake(0.0f, -CGRectGetHeight(self.refreshControl.bounds)) animated:animated];
        [self.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
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
    [_listViewModel reloadPositionsWithCompletionHandler:^(NSError *error) {
        if (error)
        {
            // TODO: Show the error
            NSLog(@"An error occurred while fetching postings: %@", error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        });
    }];
}

- (OCJPositionViewModel *)viewModelAtIndexPath:(NSIndexPath *)indexPath
{
    return _listViewModel.positions[indexPath.row];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"PositionDetailsSegue"])
    {
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        OCJPositionViewModel *selectedPosition = [self viewModelAtIndexPath:selectedIndexPath];
        
        ((OCJPositionDetailsViewController *)segue.destinationViewController).viewModel = selectedPosition;
    }
}


#pragma mark - UITableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listViewModel.positions.count;
}

static NSString *CellIdentifier = @"JobCell";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OCJPositionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    OCJPositionViewModel *viewModel = [self viewModelAtIndexPath:indexPath];
    cell.viewModel = viewModel;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_offscreenCell)
    {
        _offscreenCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    OCJPositionViewModel *viewModel = [self viewModelAtIndexPath:indexPath];
    _offscreenCell.viewModel = viewModel;
    
    // Let Auto Layout figure out how tall the cell needs to be
    CGSize cellSize = [_offscreenCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return cellSize.height;
}

@end
