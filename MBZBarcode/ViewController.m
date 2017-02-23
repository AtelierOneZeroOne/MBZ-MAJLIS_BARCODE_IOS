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

@interface ViewController ()

//Vendor
@property (nonatomic, strong) MTBBarcodeScanner         *scanner;

//Public
@property (nonatomic, weak) IBOutlet UIView             *previewView;
@property (nonatomic, weak) IBOutlet UIButton           *startScan;
@property (nonatomic, weak) IBOutlet UIButton           *stopScan;
@property (weak, nonatomic) IBOutlet UIView             *scannedResult;
@property (nonatomic, strong) NSMutableArray            *uniqueCodes;
@property (weak, nonatomic) IBOutlet UILabel            *barcodeValue;

@property (nonatomic, assign) BOOL                      captureIsFrozen;
@property (nonatomic, assign) BOOL                      didShowCaptureWarning;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupview];
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


@end
