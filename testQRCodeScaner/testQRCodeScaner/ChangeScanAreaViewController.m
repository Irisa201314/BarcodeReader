//
//  ChangeScanAreaViewController.m
//  testQRCodeScaner
//
//  Created by admin on 2017/2/23.
//  Copyright © 2017年 YiChen,Lin. All rights reserved.
//

#import "ChangeScanAreaViewController.h"

@interface ChangeScanAreaViewController ()
@property (strong, nonatomic) IBOutlet UITextField *scanRect1TextField;
@property (strong, nonatomic) IBOutlet UITextField *scanRect2TextField;
@property (strong, nonatomic) IBOutlet UITextField *scanRect3TextField;
@property (strong, nonatomic) IBOutlet UITextField *scanRect4TextField;
@property (strong, nonatomic) IBOutlet UIButton *OKBtn;

@end

@implementation ChangeScanAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)OKBtn:(UIButton *)sender {
}

- (IBAction)TextField_DidEndOnExit:(id)sender {
    // 隐藏键盘.
    [sender resignFirstResponder];
}

@end
