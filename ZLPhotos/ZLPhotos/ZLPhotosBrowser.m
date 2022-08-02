//
//  ZLPhotosBrowser.m
//  ZLPhotos
//
//  Created by ZhangLiang on 2022/8/1.
//

#import "ZLPhotosBrowser.h"
#import "ZLPhotosBrowserCollectionViewCell.h"
#import "ZLAssetModel.h"

@interface ZLPhotosBrowser () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ZLPhotosBrowserCollectionViewCellDelegate>
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, assign) CGRect rect;
@end

@implementation ZLPhotosBrowser

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.rect = frame;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.pagingEnabled = YES;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.bounces = YES;
        collectionView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self addSubview:collectionView];
        self.collectionView = collectionView;
        
        [collectionView registerClass:[ZLPhotosBrowserCollectionViewCell class] forCellWithReuseIdentifier:[ZLPhotosBrowserCollectionViewCell cellIdentifier]];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [UIView animateWithDuration:kSeePhotoDuration animations:^{
        self.collectionView.frame = CGRectMake(0, 0, self.bounds.size.width+10, self.bounds.size.height);
    }];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    __weak typeof(self) wekself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wekself.collectionView setContentOffset:CGPointMake(wekself.selectedIndex * wekself.collectionView.bounds.size.width, 0) animated:NO];
    });
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.assetModelArr count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZLPhotosBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ZLPhotosBrowserCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    cell.assetModel = self.assetModelArr[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZLAssetModel *assetModel = self.assetModelArr[indexPath.row];
    [UIView animateWithDuration:kSeePhotoDuration animations:^{
        self.frame = assetModel.originRect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.bounds.size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 10);
}

#pragma mark - ZLPhotosBrowserCollectionViewCellDelegate
- (void)photosBrowserCollectionViewCell:(ZLPhotosBrowserCollectionViewCell *)cell didSelected:(ZLAssetModel *)assetModel {
    if ([self.delegate respondsToSelector:@selector(photosBrowser:didSelected:)]) {
        [self.delegate photosBrowser:self didSelected:assetModel];
        [self.collectionView reloadData];
    }
}

@end
