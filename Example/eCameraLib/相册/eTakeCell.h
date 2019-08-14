//
//  eTakeCell.h
//  eCameraLib_Example
//
//  Created by liuyutian on 2019/8/13.
//  Copyright © 2019年 24290265@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class eTakeAVModel;
@interface eTakeCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *videoBottomView;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UIImageView *liveImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *topView;

@property (nonatomic, assign) BOOL allSelectGif;
@property (nonatomic, assign) BOOL allSelectLivePhoto;
@property (nonatomic, assign) BOOL showSelectBtn;
@property (nonatomic, assign) CGFloat cornerRadio;
@property (nonatomic, strong) eTakeAVModel *model;
@property (nonatomic, strong) UIColor *maskColor;
@property (nonatomic, assign) BOOL showMask;

@end

NS_ASSUME_NONNULL_END
