//
//  eTakeAVModel.m
//  eCameraLib_Example
//
//  Created by liuyutian on 2019/8/12.
//  Copyright © 2019年 24290265@qq.com. All rights reserved.
//

#import "eTakeAVModel.h"

@implementation eTakeAVModel

+ (instancetype)modelWithAsset:(PHAsset *)asset type:(eTakeAssetMediaType)type duration:(NSString *)duration
{
    eTakeAVModel *model = [[eTakeAVModel alloc] init];
    model.asset = asset;
    model.type = type;
    model.duration = duration;
    model.selected = NO;
    return model;
}


@end


@implementation eTakeAVListModel


@end
