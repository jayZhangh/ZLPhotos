//
//  ZLPhotos.h
//  ZLPhotos
//
//  Created by ZhangLiang on 2022/8/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLPhotos : UIViewController

@property (nonatomic, copy) void (^selectedPhotosBlock)(NSArray<NSData *> *imagesData);

@end

NS_ASSUME_NONNULL_END
