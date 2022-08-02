//
//  ZLPhotoCollectionViewCell.h
//  ZLPhotos
//
//  Created by ZhangLiang on 2022/8/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZLPhotoCollectionViewCell, ZLAssetModel;

@protocol ZLPhotoCollectionViewCellDelegate <NSObject>

- (void)photoCollectionViewCell:(ZLPhotoCollectionViewCell * __nullable)cell didSelected:(ZLAssetModel *)assetModel;

@end

@interface ZLPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) ZLAssetModel *assetModel;
@property (nonatomic, assign) id<ZLPhotoCollectionViewCellDelegate> delegate;

+ (NSString *)cellIdentifier;

@end

NS_ASSUME_NONNULL_END
