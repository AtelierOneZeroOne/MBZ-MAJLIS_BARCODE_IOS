//
//  ViewController.m
//  MBZBarcode
//
//  Created by Michael Ugale on 2/23/17.
//  Copyright © 2017 Michael Ugale. All rights reserved.
//

#import "ViewController.h"
#import "MBZFeedbackWorkshopListViewController.h"

//Vendor
#import "MTBBarcodeScanner.h"
#import "TNRadioButtonGroup.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <WYPopoverController/WYPopoverController.h>
#import "SCLAlertView+Convenience.h"

//Managers
#import "APIClientManager.h"

//Resouces
#import "MBZConstants.h"

//Objects
#import "Zones.h"

//Utilities
#import "MBZCache.h"

@interface ViewController ()

//Vendor
@property (nonatomic, strong) MTBBarcodeScanner         *scanner;
@property (nonatomic, strong) TNRadioButtonGroup        *radioGroup;
@property (strong, nonatomic) MBProgressHUD             *hud;
@property WYPopoverController                           *popoverController;

//Controller
@property MBZFeedbackWorkshopListViewController         *workshopModal;

//Public
@property (nonatomic, weak) IBOutlet UIView             *previewView;
@property (nonatomic, weak) IBOutlet UIButton           *startScan;
@property (nonatomic, weak) IBOutlet UIButton           *stopScan;
@property (weak, nonatomic) IBOutlet UIView             *scannedResult;
@property (nonatomic, strong) NSMutableArray            *uniqueCodes;
@property (weak, nonatomic) IBOutlet UILabel            *barcodeValue;
@property (nonatomic, strong) NSMutableArray            *listItem;
@property (weak, nonatomic) IBOutlet UIButton           *selectZone;
@property (strong, nonatomic) NSString                  *selectedKeyZone;
@property (strong, nonatomic) NSString                  *selectedAction;
- (IBAction)selectZone:(id)sender;

@property (nonatomic, assign) BOOL                      captureIsFrozen;
@property (nonatomic, assign) BOOL                      didShowCaptureWarning;

@end

@implementation ViewController
@synthesize listItem    = _listItem;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanner stopScanning];
}

#pragma mark - private method

- (void)loadLoader
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)setupview
{
    [self.startScan addTarget:self action:@selector(startScanning) forControlEvents:UIControlEventTouchUpInside];
    [self.stopScan addTarget:self action:@selector(stopScanning) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUpRadioGroup
{
    self.selectedAction = @"checkin";
    TNCircularRadioButtonData *checkInData = [TNCircularRadioButtonData new];
    checkInData.labelText = @"Checkin";
    checkInData.identifier = @"checkin";
    checkInData.selected = YES;
    
    TNCircularRadioButtonData *checkOutData = [TNCircularRadioButtonData new];
    checkOutData.labelText = @"Checkout";
    checkOutData.identifier = @"checkout";
    checkOutData.selected = NO;
    checkOutData.borderRadius = 12;
    checkOutData.circleRadius = 5;
    
    self.radioGroup = [[TNRadioButtonGroup alloc] initWithRadioButtonData:@[checkInData, checkOutData]
                                                                   layout:TNRadioButtonGroupLayoutHorizontal];
    self.radioGroup.identifier = @"Sex group";
    [self.radioGroup create];
    self.radioGroup.position = CGPointMake(((self.view.frame.size.width - self.radioGroup.frame.size.width) / 2),
                                           self.selectZone.frame.origin.y + self.selectZone.frame.size.height + 60);
    [self.view addSubview:self.radioGroup];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(radioGroupUpdated:)
                                                 name:SELECTED_RADIO_BUTTON_CHANGED
                                               object:self.radioGroup];
    [self.radioGroup update];
}

#pragma mark - TNRadioButtonGroup

- (void)radioGroupUpdated:(NSNotification *)notification
{
    self.selectedAction = self.radioGroup.selectedRadioButton.data.identifier;
}

#pragma mark - Scanner

- (MTBBarcodeScanner *)scanner {
    if (!_scanner) {
        _scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:_previewView];
    }
    return _scanner;
}

#pragma mark - Scanning

- (void)startScanning
{
    if (self.selectedKeyZone.length == 0) {
        
        [SCLAlertView showInfoWithTitle:nil
                                message:@"Please select zone."
                           buttonTitles:@[@"OK"]
                               tapBlock:nil];
        return;
    }
    
    self.barcodeValue.text = @"";
    [self.scannedResult setHidden:YES];
    self.uniqueCodes = [[NSMutableArray alloc] init];
    
    NSError *error = nil;
    [self.scanner startScanningWithResultBlock:^(NSArray *codes) {
        for (AVMetadataMachineReadableCodeObject *code in codes) {
            if (code.stringValue && [self.uniqueCodes indexOfObject:code.stringValue] == NSNotFound) {
                [self.uniqueCodes addObject:code.stringValue];
                NSLog(@"Found unique code: %@", code.stringValue);
                self.barcodeValue.text = code.stringValue;
                [self.scannedResult setHidden:NO];
            }
        }
    } error:&error];
    
    if (error) {
        NSLog(@"An error occurred: %@", error.localizedDescription);
    }
}

- (void)stopScanning {
    [self.scanner stopScanning];
    
    self.captureIsFrozen = NO;
}


#pragma mark - Client API Call

- (void) setItems
{
    _listItem   = [[NSMutableArray alloc] init];
    _listItem   = [[MBZCache shared] getCachedObjectForKey:ZONE_LIST];
    
}

- (void) getItems
{
    [self loadLoader];
    
    [[APIClientManager sharedManager] getZone:^(NSDictionary *responseObject) {
        SPLOG_DEBUG(@"Response for /Agenda : %@", responseObject);
        [self.hud hideAnimated:YES afterDelay:0.25f];
        
        NSMutableArray *list        = [[NSMutableArray alloc] init];
        
        for (NSDictionary *data in responseObject) {
            SPLOG_DEBUG(@"%@",data);
            Zones *zone     = [[Zones alloc] init];
            zone.key        = data[@"key"];
            zone.value      = data[@"value"];
            [list addObject:zone];
        }
        
        [[MBZCache shared] setCachedObject:list forKey:ZONE_LIST];
        
        [self setItems];
        [self setupview];
        [self setUpRadioGroup];
        
    } failure:^(NSError *error) {
        SPLOG_DEBUG(@"Response for /Agenda : %@", error);
        [self.hud hideAnimated:YES afterDelay:0.25f];
        
        [self setItems];
        [self setupview];
        [self setUpRadioGroup];
    }];
    
}

#pragma mark - UITableViewDataSource / UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listItem count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Zones *zone             = [_listItem objectAtIndex:indexPath.row];
    self.selectedKeyZone    = zone.key;
    
    [self.selectZone setTitle:zone.value forState:UIControlStateNormal];
    [self done:nil];
}

#pragma mark - UIButton Action

- (void)done:(id)sender
{
    [self.popoverController dismissPopoverAnimated:YES];
    self.popoverController.delegate = nil;
    self.popoverController = nil;
}

- (IBAction)selectZone:(id)sender
{
    if (self.popoverController == nil) {
        
        UIView *btn             = (UIView *)sender;
        CGRect frame            = self.view.frame;
        frame.size.width        = self.navigationController.view.frame.size.width;
        frame.size.height       = 200;
        
        
        UIStoryboard *mainStoryboard             = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.workshopModal                       = [mainStoryboard instantiateViewControllerWithIdentifier:@"MBZFeedbackWorkshopListVC"];
        self.workshopModal.view.frame            = frame;
        self.workshopModal.view.backgroundColor  = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
        self.workshopModal.tableItems            = _listItem;
        self.workshopModal.itemType              = @"";
        self.workshopModal.selected              = @"";
        self.workshopModal.tableView.delegate    = (id)self;
        
        self.workshopModal.preferredContentSize   = CGSizeMake(frame.size.width, frame.size.width);
        [self.workshopModal.tableView reloadData];
        
        
        UINavigationController* contentViewController = [[UINavigationController alloc] initWithRootViewController:self.workshopModal];
        
        self.popoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
        
        
        [self.popoverController beginThemeUpdates];
        self.popoverController.theme.arrowHeight        = 13;
        self.popoverController.theme.arrowBase          = 25;
        self.popoverController.theme.fillTopColor       = [[UIColor blackColor]colorWithAlphaComponent:0.8f];
        self.popoverController.theme.fillBottomColor    = [[UIColor blackColor]colorWithAlphaComponent:0.8f];
        [self.popoverController endThemeUpdates];
        
        self.popoverController.delegate                         = (id)self;
        self.popoverController.passthroughViews                 = @[btn];
        self.popoverController.popoverLayoutMargins             = UIEdgeInsetsMake(10, 10, 10, 10);
        self.popoverController.wantsDefaultContentAppearance    = NO;
        [self.popoverController presentPopoverFromRect:btn.bounds
                                                inView:btn
                              permittedArrowDirections:WYPopoverArrowDirectionUp | WYPopoverArrowDirectionDown
                                              animated:YES
                                               options:WYPopoverAnimationOptionFadeWithScale];
    } else {
        [self done:nil];
    }
}
@end
