//
//  eTakePhotoManager.h
//  eCameraLib_Example
//
//  Created by liuyutian on 2019/8/12.
//  Copyright © 2019年 24290265@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eTakeAVModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface eTakePhotoManager : NSObject

/**
 * @brief 获取用户所有相册列表
 */
+ (void)getPhotoAblumList:(BOOL)allowSelectVideo allowSelectImage:(BOOL)allowSelectImage complete:(void (^)(NSArray<eTakeAVListModel *> *))complete;

/**
 * @brief 将result中对象转换成eTakeAVModel
 */
+ (NSArray<eTakeAVModel *> *)getPhotoInResult:(PHFetchResult<PHAsset *> *)result allowSelectVideo:(BOOL)allowSelectVideo allowSelectImage:(BOOL)allowSelectImage allowSelectGif:(BOOL)allowSelectGif allowSelectLivePhoto:(BOOL)allowSelectLivePhoto;

/**
 * @brief 转换视频时长
 */
+ (NSString *)getDuration:(PHAsset *)asset;

/**
 * @brief 根据传入size获取图片
 */
+ (PHImageRequestID)requestImageForAsset:(PHAsset *)asset size:(CGSize)size progressHandler:(void (^ _Nullable)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler completion:(void (^)(UIImage *, NSDictionary *))completion;

/**
 * @brief 获取视频
 */
+ (void)requestVideoForAsset:(PHAsset *)asset progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler completion:(void (^)(AVPlayerItem *item, NSDictionary *info))completion;


+ (void)getCameraRollAlbumList:(BOOL)allowSelectVideo allowSelectImage:(BOOL)allowSelectImage complete:(void (^)(eTakeAVListModel *))complete;
@end

NS_ASSUME_NONNULL_END
