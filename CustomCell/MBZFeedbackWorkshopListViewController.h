//
//  MBZFeedbackWorkshopListViewController.h
//  MBZ
//
//  Created by Michael Ugale on 2/7/17.
//  Copyright © 2017 Michael Ugale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBZFeedbackWorkshopListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView      *tableView;
@property (strong, nonatomic) NSMutableArray            *tableItems;
@property (strong, nonatomic) NSString                  *itemType;
@property (strong, nonatomic) NSString                  *selected;

@end
