//
//  JobListViewController.swift
//  OctoJobs
//
//  Created by Tyler Stromberg on 10/7/14.
//  Copyright (c) 2014 Tyler Stromberg. All rights reserved.
//

import UIKit

class JobListViewController: UITableViewController {
    private var positions: [Position]
    
    // MARK: Object Lifecycle
    required init(coder aDecoder: NSCoder) {
        self.positions = []
        
        super.init(coder: aDecoder)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "preferredContentSizeChanged:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "reloadJobs:", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (self.positions.isEmpty) {
            self.refreshControl?.beginRefreshing()
            self.tableView.setContentOffset(CGPointMake(0.0, -CGRectGetHeight(self.refreshControl!.bounds)), animated:animated);
            self.reloadJobs(self.refreshControl)
        }
    }
    
    
    // MARK: -
    
    func preferredContentSizeChanged(notification: NSNotification!) {
        dispatch_async(dispatch_get_main_queue()) {
            // Reload the table AFTER the cells have a chance to update
            self.tableView.reloadData()
        }
    }
    
    func reloadJobs(sender: UIRefreshControl!) {
        // TODO: Do we want Markdown instead of HTML?
        // If so, append "?markdown=1"
        OCJAPIClient.sharedClient().getPath("positions.json", completionHandler: { (data, error) -> Void in
            // FIXME: Error handling
            if true {
                let rawPositions = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil) as [NSDictionary]
                
                var newPositions = [Position]()
                
                for positionInfo in rawPositions {
                    var position = Position(dictionary: positionInfo)
                    newPositions.append(position)
                }
                
                self.positions = newPositions
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            } else {
                // TODO: Show the error
                print("An error occurred while fetching postings: \(error.localizedDescription)")
            }
        })
    }
    
    
    // MARK: -
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "PositionDetailsSegue" {
            var selectedIndexPath = self.tableView.indexPathForSelectedRow()!
            var selectedPosition = self.positions[selectedIndexPath.row]
            
            var detailsVC: OCJPositionDetailsViewController = segue.destinationViewController as OCJPositionDetailsViewController
            detailsVC.position = selectedPosition
        }
    }
    
    
    // MARK: - UITableView DataSource Methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.positions.count;
    }
    
    private let kCellIdentifier = "JobCell"
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier, forIndexPath: indexPath) as OCJPositionCell
        cell.position = self.positions[indexPath.row]
        
        return cell;
    }
    
    private var offscreenCell: OCJPositionCell?
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (self.offscreenCell == nil) {
            self.offscreenCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? OCJPositionCell
        }
        
        offscreenCell!.position = self.positions[indexPath.row]
        
        // Let Auto Layout figure out how tall the cell needs to be
        var cellSize = offscreenCell?.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        
        return cellSize!.height
    }
}
