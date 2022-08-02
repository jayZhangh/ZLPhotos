//
//  ZLPhotosBrowserCollectionViewCell.h
//  ZLPhotos
//
//  Created by ZhangLiang on 2022/8/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZLAssetModel, ZLPhotosBrowserCollectionViewCell;

@protocol ZLPhotosBrowserCollectionViewCellDelegate <NSObject>

- (void)photosBrowserCollectionViewCell:(ZLPhotosBrowserCollectionViewCell *)cell didSelected:(ZLAssetModel *)assetModel;

@end

@interface ZLPhotosBrowserCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) ZLAssetModel *assetModel;
@property (nonatomic, assign) id<ZLPhotosBrowserCollectionViewCellDelegate> delegate;
+ (NSString *)cellIdentifier;
@end

NS_ASSUME_NONNULL_END
