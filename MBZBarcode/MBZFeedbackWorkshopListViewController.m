//
//  MBZFeedbackWorkshopListViewController.m
//  MBZ
//
//  Created by Michael Ugale on 2/7/17.
//  Copyright © 2017 Michael Ugale. All rights reserved.
//

#import "MBZFeedbackWorkshopListViewController.h"

//Custom Cell
#import "BOWCountryCodeTableViewCell.h"

//Objects
#import "Zones.h"

@interface MBZFeedbackWorkshopListViewController ()

@end

@implementation MBZFeedbackWorkshopListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [BOWCountryCodeTableViewCell estimatedCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"titleTableViewCell";
    
    BOWCountryCodeTableViewCell *cell = (BOWCountryCodeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BOWCountryCodeTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.backgroundColor = [UIColor clearColor];
    Zones *zone = [self.tableItems objectAtIndex:indexPath.row];
    SPLOG_DEBUG(@"VALUE: %@",zone.value);
    SPLOG_DEBUG(@"KEY: %@",zone.key);
    cell.cellText.text = zone.value;
    [cell.cellImage setHidden:YES];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - Functions

-(void) setUpView
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
@end
