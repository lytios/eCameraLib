//
//  eTakeCameraViewController.h
//  eCameraLib_Example
//
//  Created by liuyutian on 2019/7/25.
//  Copyright © 2019年 24290265@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface eTakeCameraViewController : UIViewController


@property (nonatomic,copy) void (^doneBlock)(UIImage *img);


- (void)takPicture;

- (void)PhotographsCompleted;

@end

NS_ASSUME_NONNULL_END
