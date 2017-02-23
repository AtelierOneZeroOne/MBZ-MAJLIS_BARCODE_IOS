//
//  ViewController.m
//  MBZBarcode
//
//  Created by Michael Ugale on 2/23/17.
//  Copyright © 2017 Michael Ugale. All rights reserved.
//

#import "ViewController.h"

//Vendor
#import "MTBBarcodeScanner.h"
#import "TNRadioButtonGroup.h"

@interface ViewController ()

//Vendor
@property (nonatomic, strong) MTBBarcodeScanner         *scanner;
@property (nonatomic, strong) TNRadioButtonGroup        *radioGroup;

//Public
@property (nonatomic, weak) IBOutlet UIView             *previewView;
@property (nonatomic, weak) IBOutlet UIButton           *startScan;
@property (nonatomic, weak) IBOutlet UIButton           *stopScan;
@property (weak, nonatomic) IBOutlet UIView             *scannedResult;
@property (nonatomic, strong) NSMutableArray            *uniqueCodes;
@property (weak, nonatomic) IBOutlet UILabel            *barcodeValue;
@property (weak, nonatomic) IBOutlet UIPickerView       *pickerView;

@property (nonatomic, assign) BOOL                      captureIsFrozen;
@property (nonatomic, assign) BOOL                      didShowCaptureWarning;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupview];
    [self setUpRadioGroup];
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

- (void)setupview
{
    [self.startScan addTarget:self action:@selector(startScanning) forControlEvents:UIControlEventTouchUpInside];
    [self.stopScan addTarget:self action:@selector(stopScanning) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUpRadioGroup
{
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
                                           self.pickerView.frame.origin.y + self.pickerView.frame.size.height + 60);
    [self.view addSubview:self.radioGroup];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(radioGroupUpdated:)
                                                 name:SELECTED_RADIO_BUTTON_CHANGED
                                               object:self.radioGroup];
    [self.radioGroup update];
}

#pragma mark - TNRadioButtonGroup

- (void)radioGroupUpdated:(NSNotification *)notification
{
    NSLog(@"[MainView] Sex group updated to %@", self.radioGroup.selectedRadioButton.data.identifier);
}

#pragma mark - Scanner

- (MTBBarcodeScanner *)scanner {
    if (!_scanner) {
        _scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:_previewView];
    }
    return _scanner;
}

#pragma mark - Scanning

- (void)startScanning {
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

#pragma mark - PickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString * title = nil;
    switch(row) {
        case 0:
            title = @"a";
            break;
        case 1:
            title = @"b";
            break;
        case 2:
            title = @"c";
            break;
    }
    return title;
}


@end
