//
//  ZLPhotoCollectionViewCell.m
//  ZLPhotos
//
//  Created by ZhangLiang on 2022/8/1.
//

#import "ZLPhotoCollectionViewCell.h"
#import <Photos/Photos.h>
#import "ZLAssetModel.h"

@interface ZLPhotoCollectionViewCell()
@property (nonatomic, weak) UIImageView *photoImv;
@property (nonatomic, weak) UIButton *selectedBtn;
@end

@implementation ZLPhotoCollectionViewCell

+ (NSString *)cellIdentifier {
    return @"ZLPhotoCollectionViewCellIdentifier";
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *photoImv = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:photoImv];
        self.photoImv = photoImv;
        
        CGFloat btnWH = 25;
        UIButton *selectedBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width - btnWH - 3, 3, btnWH, btnWH)];
        [selectedBtn setImage:[UIImage imageNamed:@"unselected@2x.png"] forState:UIControlStateNormal];
        [selectedBtn setImage:[UIImage imageNamed:@"selected@2x.png"] forState:UIControlStateSelected];
        [self.contentView addSubview:selectedBtn];
        self.selectedBtn = selectedBtn;
        
        [selectedBtn addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)setAssetModel:(ZLAssetModel *)assetModel {
    _assetModel = assetModel;
    
    // 获取照片
    [[PHCachingImageManager defaultManager] requestImageForAsset:_assetModel.asset targetSize:_assetModel.assetSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.photoImv.image = result;
    }];
    
    self.selectedBtn.selected = _assetModel.isSelected;
    self.selectedBtn.enabled = _assetModel.isEnabled;
}

- (void)selectedAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(photoCollectionViewCell:didSelected:)]) {
        [self.delegate photoCollectionViewCell:self didSelected:self.assetModel];
    }
}

@end
