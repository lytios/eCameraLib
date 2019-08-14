//
//  eCameraThumbnailVC.h
//  eCameraLib_Example
//
//  Created by liuyutian on 2019/8/12.
//  Copyright © 2019年 24290265@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@class eTakeAVListModel;
NS_ASSUME_NONNULL_BEGIN

@interface eTakeThumbnailVC : UIViewController

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bline;
@property (nonatomic, strong) UIButton *btnEdit;
@property (nonatomic, strong) UIButton *btnPreView;
@property (nonatomic, strong) UIButton *btnOriginalPhoto;
@property (nonatomic, strong) UILabel *labPhotosBytes;
@property (nonatomic, strong) UIButton *btnDone;


//相册model
@property (nonatomic, strong) eTakeAVListModel *albumListModel;
@end

NS_ASSUME_NONNULL_END
