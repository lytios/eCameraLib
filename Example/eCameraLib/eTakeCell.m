//
//  eTakeCell.m
//  eCameraLib_Example
//
//  Created by liuyutian on 2019/8/13.
//  Copyright © 2019年 24290265@qq.com. All rights reserved.
//

#import "eTakeCell.h"
#import "eTakeAVModel.h"
#import "eTakePhotoManager.h"
#import "etHeader.h"

@interface eTakeCell ()

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) PHImageRequestID imageRequestID;

@end


@implementation eTakeCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    if (self.showMask) {
        self.topView.frame = self.bounds;
    }
    self.videoBottomView.frame = CGRectMake(0, self.frame.size.height-15, self.frame.size.width, 15);
    self.videoImageView.frame = CGRectMake(5, 1, 16, 12);
    self.liveImageView.frame = CGRectMake(5, -1, 15, 15);
    self.timeLabel.frame = CGRectMake(30, 1,  self.frame.size.width-35, 12);
    [self.contentView sendSubviewToBack:self.imageView];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = self.bounds;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
        
        [self.contentView bringSubviewToFront:_topView];
        [self.contentView bringSubviewToFront:self.videoBottomView];
    }
    return _imageView;
}

- (UIImageView *)videoBottomView
{
    if (!_videoBottomView) {
        _videoBottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zl_videoView"]];
        _videoBottomView.frame = CGRectMake(0, self.frame.size.height-15,self.frame.size.width, 15);
        [self.contentView addSubview:_videoBottomView];
    }
    return _videoBottomView;
}

- (UIImageView *)videoImageView
{
    if (!_videoImageView) {
        _videoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 1, 16, 12)];
        _videoImageView.image = [UIImage imageNamed:@"zl_video"];
        [self.videoBottomView addSubview:_videoImageView];
    }
    return _videoImageView;
}

- (UIImageView *)liveImageView
{
    if (!_liveImageView) {
        _liveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, -1, 15, 15)];
        _liveImageView.image = [UIImage imageNamed:@"zl_livePhoto"];
        [self.videoBottomView addSubview:_liveImageView];
    }
    return _liveImageView;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 1, self.frame.size.width-35, 12)];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [UIColor whiteColor];
        [self.videoBottomView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.userInteractionEnabled = NO;
        _topView.hidden = YES;
        [self.contentView addSubview:_topView];
    }
    return _topView;
}

- (void)setModel:(eTakeAVModel *)model
{
    _model = model;
    
    if (self.cornerRadio > .0) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.cornerRadio;
    }
    
    if (model.type == ZLAssetMediaTypeVideo) {
        self.videoBottomView.hidden = NO;
        self.videoImageView.hidden = NO;
        self.liveImageView.hidden = YES;
        self.timeLabel.text = model.duration;
    }  else {
        self.videoBottomView.hidden = YES;
    }
    
    if (self.showMask) {
        self.topView.backgroundColor = [self.maskColor colorWithAlphaComponent:.2];
        self.topView.hidden = !model.isSelected;
    }
    
    CGSize size;
    size.width = self.frame.size.width * 1.7;
    size.height = self.frame.size.height * 1.7;
    
    @et_weakify(self);
    if (model.asset && self.imageRequestID >= PHInvalidImageRequestID) {
        [[PHCachingImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    self.identifier = model.asset.localIdentifier;
    self.imageView.image = nil;
    self.imageRequestID = [eTakePhotoManager requestImageForAsset:model.asset size:size progressHandler:nil completion:^(UIImage *image, NSDictionary *info) {
        @et_strongify(self);
        
        if ([self.identifier isEqualToString:model.asset.localIdentifier]) {
            self.imageView.image = image;
        }
        
        if (![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) {
            self.imageRequestID = -1;
        }
    }];
}


@end
