//
//  ZLPhotosBrowserCollectionViewCell.m
//  ZLPhotos
//
//  Created by ZhangLiang on 2022/8/1.
//

#import "ZLPhotosBrowserCollectionViewCell.h"
#import <Photos/Photos.h>
#import "ZLAssetModel.h"

@interface ZLPhotosBrowserCollectionViewCell ()

@property (nonatomic, weak) UIImageView *photoImv;
@property (nonatomic, weak) UIButton *selectedBtn;

@end

@implementation ZLPhotosBrowserCollectionViewCell

+ (NSString *)cellIdentifier {
    return @"ZLPhotosBrowserCollectionViewCellIdentifier";
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *photoImv = [[UIImageView alloc] init];
        [self.contentView addSubview:photoImv];
        self.photoImv = photoImv;
        
        CGFloat btnWH = 25;
        UIButton *selectedBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width - btnWH - 6, 6, btnWH, btnWH)];
        [selectedBtn setImage:[UIImage imageNamed:@"unselected@2x.png"] forState:UIControlStateNormal];
        [selectedBtn setImage:[UIImage imageNamed:@"selected@2x.png"] forState:UIControlStateSelected];
        [self.contentView addSubview:selectedBtn];
        self.selectedBtn = selectedBtn;
        
        [selectedBtn addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.photoImv.frame = self.bounds;
}

- (void)setAssetModel:(ZLAssetModel *)assetModel {
    _assetModel = assetModel;
    
    // 获取照片
    [[PHCachingImageManager defaultManager] requestImageForAsset:_assetModel.asset targetSize:CGSizeMake(self.bounds.size.width * kPhotoCellScale, self.bounds.size.height * kPhotoCellScale) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.photoImv.image = result;
    }];
    
    self.selectedBtn.selected = _assetModel.isSelected;
    self.selectedBtn.enabled = _assetModel.isEnabled;
}

- (void)selectedAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(photosBrowserCollectionViewCell:didSelected:)]) {
        [self.delegate photosBrowserCollectionViewCell:self didSelected:self.assetModel];
    }
}

@end
