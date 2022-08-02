//
//  ZLAssetModel.h
//  ZLPhotos
//
//  Created by ZhangLiang on 2022/8/1.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kPhotoCellWH ([UIScreen mainScreen].bounds.size.width - 50) / 4.0
#define kPhotoCellScale [UIScreen mainScreen].scale
#define kSeePhotoDuration 0.25

@class PHAsset;

NS_ASSUME_NONNULL_BEGIN

@interface ZLAssetModel : NSObject

@property (nonatomic, assign, getter=isSelected) BOOL selected;
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, assign) CGSize assetSize;
@property (nonatomic, assign) CGRect originRect;

@end

NS_ASSUME_NONNULL_END
