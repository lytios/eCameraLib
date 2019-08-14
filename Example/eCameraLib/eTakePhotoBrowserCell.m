//
//  ZLPhotoBrowserCell.m
//  多选相册照片
//
//  Created by long on 15/11/30.
//  Copyright © 2015年 long. All rights reserved.
//

#import "eTakePhotoBrowserCell.h"
#import "eTakeAVModel.h"
#import "eTakePhotoManager.h"
#import "etHeader.h"

@interface eTakePhotoBrowserCell ()

@property (nonatomic, copy) NSString *identifier;

@end

@implementation eTakePhotoBrowserCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setModel:(eTakeAVListModel *)model
{
    _model = model;
    
    if (self.cornerRadio > .0) {
        self.headImageView.layer.masksToBounds = YES;
        self.headImageView.layer.cornerRadius = self.cornerRadio;
    }
    
    @et_weakify(self);
    
    self.identifier = model.headImageAsset.localIdentifier;
    [eTakePhotoManager requestImageForAsset:model.headImageAsset size:CGSizeMake(self.frame.size.width*2.5, self.frame.size.height*2.5) progressHandler:nil completion:^(UIImage *image, NSDictionary *info) {
        @et_strongify(self);
        
        if ([self.identifier isEqualToString:model.headImageAsset.localIdentifier]) {
            self.headImageView.image = image?:[UIImage imageNamed:@"zl_defaultphoto"];
        }
    }];
    
    self.labTitle.text = model.title;
    self.labCount.text = [NSString stringWithFormat:@"(%ld)", model.count];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
