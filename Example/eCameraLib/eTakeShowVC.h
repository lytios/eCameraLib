//
//  eTakeShowVC.h
//  eCameraLib_Example
//
//  Created by liuyutian on 2019/8/14.
//  Copyright © 2019年 24290265@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@class eTakeAVModel;
@interface eTakeShowVC : UIViewController

@property (nonatomic, strong) NSArray<eTakeAVModel *> *models;

@property (nonatomic, assign) NSInteger selectIndex; //选中的图片下标

@property (nonatomic, copy) void (^btnBackBlock)(NSArray<eTakeAVModel *> *selectedModels, BOOL isOriginal);

@property (nonatomic, strong) NSMutableArray *arrSelPhotos;

@property (nonatomic, copy) void (^previewSelectedImageBlock)(NSArray<UIImage *> *arrP, NSArray<PHAsset *> *arrA);

@end

NS_ASSUME_NONNULL_END
