//
//  eTakeImageNavigationController.h
//  eCameraLib_Example
//
//  Created by liuyutian on 2019/8/12.
//  Copyright © 2019年 24290265@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "etHeader.h"

@class eTakeAVModel;
NS_ASSUME_NONNULL_BEGIN

@interface eTakeImageNaVC : UINavigationController

@property (nonatomic, copy) NSMutableArray<eTakeAVModel *> *arrSelectedModels;

@property (nonatomic, strong) UIColor *navColor;

@property (nonatomic, strong) UIImage *navImg;


/**
 点击确定选择照片回调
 */
@property (nonatomic, copy) void (^callSelectImageBlock)(void);

@end



@interface eTakeAlbumListVC : UITableViewController

@end
NS_ASSUME_NONNULL_END
