//
//  ZLPhotos.m
//  ZLPhotos
//
//  Created by ZhangLiang on 2022/8/1.
//

#import "ZLPhotos.h"
#import <Photos/Photos.h>
#import "PhotoCollectionViewCell.h"
#import "ZLAssetModel.h"

#define kCellWH ([UIScreen mainScreen].bounds.size.width - 50) / 4.0
#define kCellScale [UIScreen mainScreen].scale

@interface ZLPhotos () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PhotoCollectionViewCellDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UIButton *confimBtn;
// 相册中所有的照片
@property (nonatomic, strong) NSArray *assetModelArr;

@end

@implementation ZLPhotos

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) wekself = self;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(kCellWH, kCellWH);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:[PhotoCollectionViewCell cellIdentifier]];
    
    CGFloat btnW = 90;
    CGFloat btnH = 30;
    UIButton *confimBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - btnW, self.view.bounds.size.height - btnH - 60, btnW, btnH)];
    [confimBtn setTitle:@"0/确定" forState:UIControlStateNormal];
    [confimBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    confimBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [confimBtn addTarget:self action:@selector(confimAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confimBtn];
    self.confimBtn = confimBtn;
    
    // 请求访问相册的权限
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
            // 获取相册中所有的图片
            NSMutableArray *assetModelMArr = [[NSMutableArray alloc] init];
            for (PHAsset *asset in [PHAsset fetchAssetsWithOptions:options]) {
                ZLAssetModel *assetModel = [[ZLAssetModel alloc] init];
                assetModel.asset = asset;
                assetModel.selected = NO;
                assetModel.assetSize = CGSizeMake(kCellWH * kCellScale, kCellWH * kCellScale);
                [assetModelMArr addObject:assetModel];
            }
            
            self.assetModelArr = [assetModelMArr copy];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [wekself.collectionView reloadData];
            });
            
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请授予访问相册的权限!" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alertController animated:YES completion:nil];
            });
            
        }
    }];
}

- (void)confimAction {
    if (self.selectedPhotosBlock) {
        NSMutableArray<NSData *> *imagesData = [[NSMutableArray alloc] init];
        for (ZLAssetModel *assetModel in self.assetModelArr) {
            if (assetModel.isSelected) {
                // 获取照片
                [[PHCachingImageManager defaultManager] requestImageForAsset:assetModel.asset targetSize:assetModel.assetSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    [imagesData addObject:UIImageJPEGRepresentation(result, 0.6)];
                }];
            }
        }
        self.selectedPhotosBlock(imagesData);
    }
    
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.assetModelArr count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PhotoCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    cell.delegate = self;
    ZLAssetModel *assetModel = self.assetModelArr[indexPath.row];
    cell.assetModel = assetModel;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kCellWH, kCellWH);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(2, 10, 2, 10);
}

#pragma mark - PhotoCollectionViewCellDelegate
- (void)photoCollectionViewCell:(PhotoCollectionViewCell *)cell didSelected:(ZLAssetModel *)assetModel {
    [self.collectionView reloadData];
    int index = 0;
    for (ZLAssetModel *assetModel in self.assetModelArr) {
        if (assetModel.isSelected) {
            index += 1;
        }
    }
    
    [self.confimBtn setTitle:[NSString stringWithFormat:@"%d/确定", index] forState:UIControlStateNormal];
}

@end
