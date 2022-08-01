//
//  ZLAssetModel.h
//  ZLPhotos
//
//  Created by ZhangLiang on 2022/8/1.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PHAsset;

NS_ASSUME_NONNULL_BEGIN

@interface ZLAssetModel : NSObject

@property (nonatomic, assign, getter=isSelected) BOOL selected;
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, assign) CGSize assetSize;

@end

NS_ASSUME_NONNULL_END
