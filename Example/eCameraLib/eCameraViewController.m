//
//  eCameraViewController.m
//  eCameraLib
//
//  Created by 24290265@qq.com on 07/25/2019.
//  Copyright (c) 2019 24290265@qq.com. All rights reserved.
//

#import "eCameraViewController.h"
#import "testVCCameraViewController.h"
#import "eTakeImageNaVC.h"
#import <Photos/PHPhotoLibrary.h>
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

- (IBAction)takeImgList:(UIButton *)sender {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        
        return;
    } else if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            if (PHAuthorizationStatusAuthorized == status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    eTakeAlbumListVC *listVC =[[eTakeAlbumListVC alloc]initWithStyle:UITableViewStylePlain];
                    eTakeImageNaVC *nav =[[eTakeImageNaVC alloc]initWithRootViewController:listVC];
                    [nav setCallSelectImageBlock:^{
                        
                    }];
                    
                    [self showDetailViewController:nav sender:nil];
                });
            }
           
           
        }];
        

    }
    if (status == PHAuthorizationStatusAuthorized) {
        eTakeAlbumListVC *listVC =[[eTakeAlbumListVC alloc]initWithStyle:UITableViewStylePlain];
        eTakeImageNaVC *nav =[[eTakeImageNaVC alloc]initWithRootViewController:listVC];
        [nav setCallSelectImageBlock:^{

        }];
        [self showDetailViewController:nav sender:nil];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
