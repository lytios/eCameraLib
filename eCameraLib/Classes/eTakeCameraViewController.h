//
//  eTakeCameraViewController.h
//  eCameraLib_Example
//
//  Created by liuyutian on 2019/7/25.
//  Copyright © 2019年 24290265@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

#define eTakeCamerabundlePath   [NSBundle bundleWithPath:[[NSBundle bundleForClass:[eTakeCameraViewController class]] pathForResource:@"eCameraLib" ofType:@"bundle"]]
#define eTakeCamera_ViewWidth      [[UIScreen mainScreen] bounds].size.width
#define eTakeCamera_ViewHeight     [[UIScreen mainScreen] bounds].size.height

@interface eTakeCameraViewController : UIViewController

@property (nonatomic, strong ,readonly) UIImage *takedImage;

@property (nonatomic,copy) void (^doneBlock)(UIImage *img);

@property (nonatomic, strong ,readonly) UIImageView *takedImageView;

- (void)takPicture;

- (void)PhotographsCompleted;

@end

NS_ASSUME_NONNULL_END
