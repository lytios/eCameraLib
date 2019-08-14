//
//  eTakeAVModel.h
//  eCameraLib_Example
//
//  Created by liuyutian on 2019/8/12.
//  Copyright © 2019年 24290265@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, eTakeAssetMediaType) {
    ZLAssetMediaTypeImage,
    ZLAssetMediaTypeVideo,
};


@interface eTakeAVModel : NSObject

//图片url
@property (nonatomic, strong) NSURL *url;

//asset对象
@property (nonatomic, strong) PHAsset *asset;

//视频时长
@property (nonatomic, copy) NSString *duration;

//asset类型
@property (nonatomic, assign) eTakeAssetMediaType type;

/**初始化model对象*/
+ (instancetype)modelWithAsset:(PHAsset *)asset type:(eTakeAssetMediaType)type duration:(NSString *)duration;

//是否被选择
@property (nonatomic, assign, getter=isSelected) BOOL selected;
@end


@interface eTakeAVListModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) BOOL isCameraRoll;

@property (nonatomic, strong) PHFetchResult *result;
//相册第一张图asset对象
@property (nonatomic, strong) PHAsset *headImageAsset;

@property (nonatomic, strong) NSArray<eTakeAVModel *> *models;

@property (nonatomic, strong) NSArray *selectedModels;
//待用
@property (nonatomic, assign) NSUInteger selectedCount;

@end

NS_ASSUME_NONNULL_END
