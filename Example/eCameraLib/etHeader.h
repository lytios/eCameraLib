//
//  etHeader.m
//  eCameraLib_Example
//
//  Created by liuyutian on 2019/8/12.
//  Copyright © 2019年 24290265@qq.com. All rights reserved.
//

#define ViewWidth      [[UIScreen mainScreen] bounds].size.width
#define ViewHeight     [[UIScreen mainScreen] bounds].size.height


#ifndef et_weakify
#if DEBUG
#if __has_feature(objc_arc)
#define et_weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define et_weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define et_weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define et_weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef et_strongify
#if DEBUG
#if __has_feature(objc_arc)
#define et_strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define et_strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define et_strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define et_strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif
