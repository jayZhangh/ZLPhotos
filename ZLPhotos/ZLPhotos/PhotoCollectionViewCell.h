//
//  PhotoCollectionViewCell.h
//  ZLPhotos
//
//  Created by ZhangLiang on 2022/8/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PhotoCollectionViewCell, ZLAssetModel;

@protocol PhotoCollectionViewCellDelegate <NSObject>

- (void)photoCollectionViewCell:(PhotoCollectionViewCell *)cell didSelected:(ZLAssetModel *)assetModel;

@end

@interface PhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) ZLAssetModel *assetModel;
@property (nonatomic, assign) id<PhotoCollectionViewCellDelegate> delegate;

+ (NSString *)cellIdentifier;

@end

NS_ASSUME_NONNULL_END
