//
//  QRScanView.m
//  QRCodeDemo
//
//  Created by c0ming on 10/30/15.
//  Copyright © 2015 c0ming. All rights reserved.
//

#import "QRScanView.h"

@interface QRScanView ()

@property (nonatomic, assign) CGRect scanRect1;
@property (nonatomic, assign) CGRect scanRect2;
@property (nonatomic, assign) CGRect scanRect3;
@property (nonatomic, assign) CGRect scanRect4;
@property (nonatomic, assign) CGRect scanRect5;

@end

@implementation QRScanView

-(instancetype)initWithScanRect1:(CGRect)rect1
                        andRect2:(CGRect)rect2
                        andRect3:(CGRect)rect3
                        andRect4:(CGRect)rect4
                        andRect5:(CGRect)rect5{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _scanRect1 = rect1;
        _scanRect2 = rect2;
        _scanRect3 = rect3;
        _scanRect4 = rect4;
        _scanRect5 = rect5;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // 獲取當前 CGContextRef
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 設定背景顏色
	[[[UIColor blackColor] colorWithAlphaComponent:0.5] setFill];

	CGMutablePathRef screenPath = CGPathCreateMutable();
	CGPathAddRect(screenPath, NULL, self.bounds);

	CGMutablePathRef scanPath1 = CGPathCreateMutable();
	CGPathAddRect(scanPath1, NULL, self.scanRect1);
    
    CGMutablePathRef scanPath2 = CGPathCreateMutable();
    CGPathAddRect(scanPath2, NULL, self.scanRect2);
    
    CGMutablePathRef scanPath3 = CGPathCreateMutable();
    CGPathAddRect(scanPath3, NULL, self.scanRect3);
    
    CGMutablePathRef scanPath4 = CGPathCreateMutable();
    CGPathAddRect(scanPath4, NULL, self.scanRect4);
    
    CGMutablePathRef scanPath5 = CGPathCreateMutable();
    CGPathAddRect(scanPath5, NULL, self.scanRect5);
    
    // 創建CGMutablePathRef
	CGMutablePathRef path = CGPathCreateMutable();
    // 將CGMutablePathRef添加到當前Context內
	CGPathAddPath(path, NULL, screenPath);
	CGPathAddPath(path, NULL, scanPath1);
    CGPathAddPath(path, NULL, scanPath2);
    CGPathAddPath(path, NULL, scanPath3);
    CGPathAddPath(path, NULL, scanPath4);
    CGPathAddPath(path, NULL, scanPath5);

    // 設置繪圖屬性
	CGContextAddPath(ctx, path);
    // 執行繪畫
	CGContextDrawPath(ctx, kCGPathEOFill);

	CGPathRelease(screenPath);
	CGPathRelease(scanPath1);
    CGPathRelease(scanPath2);
    CGPathRelease(scanPath3);
    CGPathRelease(scanPath4);
    CGPathRelease(scanPath5);
	CGPathRelease(path);
}

@end
