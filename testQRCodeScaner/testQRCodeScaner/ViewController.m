//
//  ViewController.m
//  testQRCodeScaner
//
//  Created by admin on 2017/2/18.
//  Copyright © 2017年 YiChen,Lin. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QRScanView.h"

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>

// 捕獲會話
@property (nonatomic, strong) AVCaptureSession *sessionFirst;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
// Scream
@property (strong, nonatomic) IBOutlet UILabel *showLabelFirst;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *changeScanAreaBtn;
// Flash Light
@property (nonatomic, assign) BOOL flashOpen;
// Set information
@property (nonatomic, assign) CGRect scanRectMain;
@property (nonatomic, assign) CGRect scanRect1;
@property (nonatomic, assign) CGRect scanRect2;
@property (nonatomic, assign) CGRect scanRect3;
@property (nonatomic, assign) CGRect scanRect4;
@property (nonatomic, assign) CGRect scanRect5;
@property (nonatomic, assign) int scanAreaSwitch;
@property (nonatomic, assign) int testCountNum;

@end

@implementation ViewController

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.testCountNum = 0;
    self.scanRect1 = CGRectMake(120.0f, 70.0f, 50.0f, 50.0f);
    self.scanRect2 = CGRectMake(190.0f, 285.0f, 50.0f, 50.0f);
    self.scanRect3 = CGRectMake(120.0f, 460.0f, 50.0f, 50.0f);
    self.scanRect4 = CGRectMake(70.0f, 560.0f, 250.0f, 70.0f);
    self.scanRect5 = CGRectMake(190.0f, 675.0f, 50.0f, 50.0f);
    
    QRScanView *scanView = [[QRScanView alloc] initWithScanRect1:self.scanRect1
                                                        andRect2:self.scanRect2
                                                        andRect3:self.scanRect3
                                                        andRect4:self.scanRect4
                                                        andRect5:self.scanRect5];
    self.scanRectMain = self.scanRect1;
    _scanAreaSwitch = 1;
    [self setup];
    
    [self.view addSubview:scanView];
    
    // Set Flash Light Butten
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"FlashOpen"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(rightBarButtonDidClick:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup

- (void)setup {
    /*
    CGRect fullScreenRectBounds = [[UIScreen mainScreen] bounds];
    CGRect fullScreenRect = [[UIScreen mainScreen] applicationFrame];
    NSLog(@"%@,%@",fullScreenRectBounds,fullScreenRect);
     */
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authorizationStatus) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                     completionHandler: ^(BOOL granted) {
                                         if (granted) {
                                             [self setupCapture];
                                         }
                                         else {
                                             NSLog(@"%@", @"访问受限");
                                         }
                                     }];
            break;
        }
            
        case AVAuthorizationStatusAuthorized: {
            [self setupCapture];
            break;
        }
            
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied: {
            NSLog(@"%@", @"访问受限");
            break;
        }
            
        default: {
            break;
        }
    }
    
}

- (void)setupCapture {
    dispatch_async(dispatch_get_main_queue(), ^{

        _sessionFirst = [[AVCaptureSession alloc] init];
        AVCaptureDevice     *device     = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error;
        AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (deviceInput) {
            [_sessionFirst addInput:deviceInput];
            
            AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
            [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            /** Notice : 这行代码要在设置 metadataObjectTypes 前 **/
            [_sessionFirst addOutput:metadataOutput];
            metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                                   AVMetadataObjectTypeEAN13Code,
                                                   AVMetadataObjectTypeEAN8Code,
                                                   AVMetadataObjectTypeCode128Code,
                                                   AVMetadataObjectTypeDataMatrixCode];
            
            _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_sessionFirst];
            _previewLayer.videoGravity   = AVLayerVideoGravityResizeAspectFill;
            _previewLayer.frame          = self.view.frame;
            [self.view.layer insertSublayer:_previewLayer atIndex:0];
            
            __weak typeof(self) weakSelf = self;
            [[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification
                                                              object:nil
                                                               queue:[NSOperationQueue currentQueue]
                                                          usingBlock: ^(NSNotification *_Nonnull note) {
                                                              metadataOutput.rectOfInterest = [_previewLayer metadataOutputRectOfInterestForRect:weakSelf.scanRectMain];
                                                              // 如果不设置，整个屏幕都可以扫
                                                          }];
            
            
            
            [_sessionFirst startRunning];
        }
        else {
            NSLog(@"%@", error);
        }
        
    });
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    // Show Result
    if (metadataObjects.count > 0) {
        
        AVMetadataMachineReadableCodeObject *metadataObjectFirst = metadataObjects.firstObject;
        self.showLabelFirst.text = [NSString stringWithFormat:@"1. Corner : %d \n2. get : \n%@\n3. Test Count Number : %d",self.scanAreaSwitch,metadataObjectFirst.stringValue,self.testCountNum];
        NSLog(@"%d,%d,%@",self.testCountNum,self.scanAreaSwitch,metadataObjectFirst.stringValue);
        
        [_sessionFirst stopRunning];
        // New Scan Action
        [self.previewLayer  removeFromSuperlayer];
        
        // set Scan Area
        switch (_scanAreaSwitch) {
            case 1:
                self.scanRectMain = self.scanRect1;
                _scanAreaSwitch = 2;
                break;
            case 2:
                self.scanRectMain = self.scanRect3;
                _scanAreaSwitch = 3;
                break;
            case 3:
                self.scanRectMain = self.scanRect4;
                _scanAreaSwitch = 4;
                break;
            case 4:
                self.scanRectMain = self.scanRect5;
                _scanAreaSwitch = 5;
                break;
            case 5:
                self.scanRectMain = self.scanRect1;
                _scanAreaSwitch = 1;
                break;
            default:
                self.scanRectMain = self.scanRect1;
                _scanAreaSwitch = 1;
                break;
        }
        // set new scan
        [self setup];
        self.testCountNum++;
    }
}

#pragma mark - Process Data
-(void)processData:(NSString *)processStr{
    
}

#pragma mark - Flash Light Open

-(void)rightBarButtonDidClick:(UIBarButtonItem *)item{
    self.flashOpen = !self.flashOpen;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if([device hasTorch] && [device hasFlash]){
        [device lockForConfiguration:nil];
        if(self.flashOpen){
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"FlashClose"
                                                                                      style:UIBarButtonItemStylePlain
                                                                                     target:self
                                                                                     action:@selector(rightBarButtonDidClick:)];
            
            device.torchMode = AVCaptureTorchModeOn;
            device.flashMode = AVCaptureFlashModeOn;
            
        }
        else{
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"FlashOpen"
                                                                                      style:UIBarButtonItemStylePlain
                                                                                     target:self
                                                                                     action:@selector(rightBarButtonDidClick:)];
            
            device.torchMode = AVCaptureTorchModeOff;
            device.flashMode = AVCaptureFlashModeOff;
        }
        
        [device unlockForConfiguration];
    }
}

#pragma mark - Button Action

- (IBAction)changeScanAreaBtn:(UIBarButtonItem *)sender {

}


@end
