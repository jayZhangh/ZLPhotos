//
//  ZLPhotosBrowser.h
//  ZLPhotos
//
//  Created by ZhangLiang on 2022/8/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZLPhotosBrowser, ZLAssetModel;

@protocol ZLPhotosBrowserDelegate <NSObject>

- (void)photosBrowser:(ZLPhotosBrowser *)photosBrowser didSelected:(ZLAssetModel *)assetModel;

@end

@interface ZLPhotosBrowser : UIView
@property (nonatomic, copy) NSArray *assetModelArr;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) id<ZLPhotosBrowserDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
