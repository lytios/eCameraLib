//
//  eCameraViewController.m
//  eCameraLib
//
//  Created by 24290265@qq.com on 07/25/2019.
//  Copyright (c) 2019 24290265@qq.com. All rights reserved.
//

#import "eCameraViewController.h"
#import "testVCCameraViewController.h"
@interface eCameraViewController ()

@end

@implementation eCameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)takePic:(UIButton *)sender {

    testVCCameraViewController *cameraVc= [[testVCCameraViewController alloc]initWithNibName:@"eTakeCameraViewController" bundle:eTakeCamerabundlePath];
    cameraVc.doneBlock = ^(UIImage * _Nonnull img) {
        
    };
   [self showDetailViewController:cameraVc sender:nil] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
