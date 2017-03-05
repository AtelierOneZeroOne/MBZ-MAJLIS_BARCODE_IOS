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

//Categories
#import "UIColor+More.h"

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
@property (strong, nonatomic) NSString                  *scannedBarcode;
@property (weak, nonatomic) IBOutlet UITableView        *tableView;
- (IBAction)selectZone:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel            *totalScannedText;

@property (weak, nonatomic) IBOutlet UIImageView        *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel            *inQueueText;
@property (nonatomic, assign) BOOL                      captureIsFrozen;
@property (nonatomic, assign) BOOL                      didShowCaptureWarning;
@property (nonatomic, assign) BOOL                      isStartScan;
@property int                      totalScannedCounter;
@property int                      inQueueCounter;

//Dynamic
@property (nonatomic, strong) NSMutableDictionary       *listItemPending;

@end

@implementation ViewController
@synthesize listItem    = _listItem;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setScannedItems];
    self.totalScannedCounter = 0;
    self.inQueueCounter = 0;
    self.isStartScan = true;
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

#pragma mark - Setters

- (void)setUniqueCodes:(NSMutableArray *)uniqueCodes {
    _uniqueCodes = uniqueCodes;
    [self.tableView reloadData];
}

#pragma mark - private method

- (void) setUpZoneView
{
    CGRect frame                            = self.view.frame;
    
    UIStoryboard *mainStoryboard             = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.workshopModal                       = [mainStoryboard instantiateViewControllerWithIdentifier:@"MBZFeedbackWorkshopListVC"];
    self.workshopModal.view.frame            = frame;
    self.workshopModal.tableItems            = _listItem;
    self.workshopModal.itemType              = @"";
    self.workshopModal.selected              = @"";
    self.workshopModal.tableView.delegate    = (id)self;
    
    self.workshopModal.preferredContentSize   = CGSizeMake(frame.size.width, frame.size.width);
}

- (void) setScannedItems
{
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray: [[MBZCache shared] getCachedObjectForKey:SCANNED_LIST]];
    
    if ([temp count] != 0) {
        self.uniqueCodes    = [[NSMutableArray alloc] initWithArray:temp];
    } else {
        self.uniqueCodes    = [[NSMutableArray alloc] init];
    }
    
    self.totalScannedCounter = (int)[self.uniqueCodes count];
    self.totalScannedText.text = [NSString stringWithFormat:@"%i",(int)[self.uniqueCodes count]];
}

- (void) setItems
{
    _listItem   = [[NSMutableArray alloc] init];
    _listItem   = [[MBZCache shared] getCachedObjectForKey:ZONE_LIST];
    
}

- (void)loadLoader
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)setupview
{
    [self.startScan addTarget:self action:@selector(startScanning) forControlEvents:UIControlEventTouchUpInside];
    [self.stopScan addTarget:self action:@selector(stopScanning) forControlEvents:UIControlEventTouchUpInside];
    
//    self.startScan.layer.cornerRadius = 10;
//    self.startScan.clipsToBounds = YES;
//    
//    self.stopScan.layer.cornerRadius = 10;
//    self.stopScan.clipsToBounds = YES;
    
//    self.selectZone.layer.cornerRadius = 10;
//    self.selectZone.clipsToBounds = YES;
    
    [[self.startScan layer] setBorderWidth:2.0f];
    [[self.startScan layer] setBorderColor:[UIColor colorWithHex:THEME_COLOR_ORANGE].CGColor];
    
    [[self.stopScan layer] setBorderWidth:2.0f];
    [[self.stopScan layer] setBorderColor:[UIColor colorWithHex:THEME_COLOR_ORANGE].CGColor];
    
    [[self.selectZone layer] setBorderWidth:2.0f];
    [[self.selectZone layer] setBorderColor:[UIColor colorWithHex:THEME_COLOR_ORANGE].CGColor];
    
    self.backgroundImage.image = [self.backgroundImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.backgroundImage setTintColor:[UIColor whiteColor]];
    [self setUpZoneView];
}

- (void)setUpRadioGroup
{
    self.selectedAction = @"checkin";
    TNCircularRadioButtonData *checkInData = [TNCircularRadioButtonData new];
    checkInData.labelText = @"CHECK IN";
    checkInData.identifier = @"checkin";
    checkInData.selected = YES;
    checkInData.borderColor = [UIColor colorWithHex:THEME_COLOR_ORANGE];
    checkInData.circleColor = [UIColor colorWithHex:THEME_COLOR_ORANGE];
    checkInData.labelFont   = FONT_UI_Text_Light(FONT_SIZE_TEXTFIELD);
    
    TNCircularRadioButtonData *checkOutData = [TNCircularRadioButtonData new];
    checkOutData.labelText = @"CHECK OUT";
    checkOutData.identifier = @"checkout";
    checkOutData.selected = NO;
    checkOutData.borderRadius = 12;
    checkOutData.circleRadius = 5;
    checkOutData.borderColor = [UIColor colorWithHex:THEME_COLOR_ORANGE];
    checkOutData.circleColor = [UIColor colorWithHex:THEME_COLOR_ORANGE];
    checkOutData.labelFont   = FONT_UI_Text_Light(FONT_SIZE_TEXTFIELD);
    
    self.radioGroup = [[TNRadioButtonGroup alloc] initWithRadioButtonData:@[checkInData, checkOutData]
                                                                   layout:TNRadioButtonGroupLayoutHorizontal];
    self.radioGroup.identifier = @"Sex group";
    [self.radioGroup create];
    self.radioGroup.position = CGPointMake(((self.view.frame.size.width - self.radioGroup.frame.size.width) / 2),
                                           self.previewView.frame.origin.y + self.previewView.frame.size.height + self.selectZone.frame.size.height + 60);
    [self.view addSubview:self.radioGroup];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(radioGroupUpdated:)
                                                 name:SELECTED_RADIO_BUTTON_CHANGED
                                               object:self.radioGroup];
    [self.radioGroup update];
}

- (void)scrollToLastTableViewCell
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.uniqueCodes.count - 1
                                                inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
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
    
    if (self.isStartScan) {
        
        if (self.selectedKeyZone.length == 0) {
            
            [SCLAlertView showInfoWithTitle:nil
                                    message:@"Please select zone."
                               buttonTitles:@[@"OK"]
                                   tapBlock:nil];
            return;
        }
        
        [self.startScan setTitle:@"STOP SCAN" forState:UIControlStateNormal];
        self.isStartScan        = false;
        self.barcodeValue.text  = @"";
        [self.scannedResult setHidden:YES];
        
        NSError *error = nil;
        [self.scanner startScanningWithResultBlock:^(NSArray *codes) {
            for (AVMetadataMachineReadableCodeObject *code in codes) {
                
                if (![code.stringValue isEqualToString: [self.uniqueCodes valueForKey: @"@lastObject"]]) {
                    [self.uniqueCodes addObject:code.stringValue];
                    SPLOG_DEBUG(@"Found unique code: %@", code.stringValue);
                    //                self.barcodeValue.text = code.stringValue;
                    self.scannedBarcode = code.stringValue;
                    //                [self.scannedResult setHidden:NO];
                    
                    self.totalScannedCounter = self.totalScannedCounter + 1;
                    self.totalScannedText.text = [NSString stringWithFormat:@"%i",(int)[self.uniqueCodes count]];
                    [self.tableView reloadData];
                    [self scrollToLastTableViewCell];
                    [self sendScannedCode];
                    
                    [[MBZCache shared] setCachedObject:self.uniqueCodes forKey:SCANNED_LIST];
                    
#if DEBUG
                    AudioServicesPlaySystemSound(1103);
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

#else
                    SystemSoundID soundID = 0;
                    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"wav"];
                    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
                    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &soundID);
                    AudioServicesPlaySystemSound(soundID);
#endif
                    
                }
            }
        } error:&error];
        
        if (error) {
            NSLog(@"An error occurred: %@", error.localizedDescription);
        }

    } else {
        [self.startScan setTitle:@"START SCAN" forState:UIControlStateNormal];
        self.isStartScan = true;
        [self stopScanning];
    }
        
    
}

- (void)stopScanning {
    [self.scanner stopScanning];
    
    self.captureIsFrozen = NO;
}


#pragma mark - UITableViewDataSource / UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.uniqueCodes.count;
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
    static NSString *reuseIdentifier = @"BarcodeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier
                                                            forIndexPath:indexPath];
    cell.textLabel.text = self.uniqueCodes[indexPath.row];
    
    if (indexPath.row % 2) {
        cell.contentView.backgroundColor = [UIColor colorWithHex:@"f8f8f8"];
    } else {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Zones *zone             = [_listItem objectAtIndex:indexPath.row];
    self.selectedKeyZone    = zone.key;
    
    [self.selectZone setTitle:zone.value forState:UIControlStateNormal];
    [self.workshopModal.view removeFromSuperview];
//    [self done:nil];
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
    
    if ([_listItem count] != 0) {
        [self.view addSubview:self.workshopModal.view];
    }
    
//    if (self.popoverController == nil) {
//
//        UIView *btn             = (UIView *)sender;
//        CGRect frame            = self.view.frame;
////        frame.size.width        = self.view.frame.size.width;
////        frame.size.height       = 200;
//        
//        
//        UIStoryboard *mainStoryboard             = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        self.workshopModal                       = [mainStoryboard instantiateViewControllerWithIdentifier:@"MBZFeedbackWorkshopListVC"];
//        self.workshopModal.view.frame            = frame;
////        self.workshopModal.view.backgroundColor  = [[UIColor blackColor] colorWithAlphaComponent:7.0f];
//        self.workshopModal.tableItems            = _listItem;
//        self.workshopModal.itemType              = @"";
//        self.workshopModal.selected              = @"";
//        self.workshopModal.tableView.delegate    = (id)self;
//        
//        self.workshopModal.preferredContentSize   = CGSizeMake(frame.size.width, frame.size.width);
//        [self.workshopModal.tableView reloadData];
        
//        [self.view addSubview:self.workshopModal.view];
        
//        UINavigationController* contentViewController = [[UINavigationController alloc] initWithRootViewController:self.workshopModal];
//        
//        self.popoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
//        
//        
//        [self.popoverController beginThemeUpdates];
//        self.popoverController.theme.arrowHeight        = 13;
//        self.popoverController.theme.arrowBase          = 25;
//        self.popoverController.theme.fillTopColor       = [[UIColor blackColor]colorWithAlphaComponent:0.8f];
//        self.popoverController.theme.fillBottomColor    = [[UIColor blackColor]colorWithAlphaComponent:0.8f];
//        [self.popoverController endThemeUpdates];
//        
//        self.popoverController.delegate                         = (id)self;
//        self.popoverController.passthroughViews                 = @[btn];
//        self.popoverController.popoverLayoutMargins             = UIEdgeInsetsMake(10, 10, 10, 10);
//        self.popoverController.wantsDefaultContentAppearance    = NO;
//        [self.popoverController presentPopoverFromRect:btn.bounds
//                                                inView:btn
//                              permittedArrowDirections:WYPopoverArrowDirectionUp | WYPopoverArrowDirectionDown
//                                              animated:YES
//                                               options:WYPopoverAnimationOptionFadeWithScale];
//    } else {
//        [self done:nil];
//    }
}

#pragma mark - Client API Call

- (void) getItems
{
    [self loadLoader];
    
    [[APIClientManager sharedManager] getZone:^(NSDictionary *responseObject) {
        SPLOG_DEBUG(@"Response for /GET Zone : %@", responseObject);
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
        SPLOG_DEBUG(@"Response for /GET Zone : %@", error);
        [self.hud hideAnimated:YES afterDelay:0.25f];
        
        [self setItems];
        [self setupview];
        [self setUpRadioGroup];
    }];
    
}

- (void)sendScannedCode
{
    [[APIClientManager sharedManager] sendScanned:self.scannedBarcode
                                             zone:self.selectedKeyZone
                                           action:self.selectedAction
                                          success:^(NSDictionary *responseObject) {
                                              SPLOG_DEBUG(@"Response for /Sent Scanned: %@", responseObject);
                                              [self.hud hideAnimated:YES afterDelay:0.25f];
                                              self.scannedBarcode = @"";
                                          } failure:^(NSError *error) {
                                              SPLOG_DEBUG(@"Response for /Failed Scanned : %@", error);
                                              [self.hud hideAnimated:YES afterDelay:0.25f];
                                          }];
}

@end
