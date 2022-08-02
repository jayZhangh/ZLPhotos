//
//  ZLPhotos.m
//  ZLPhotos
//
//  Created by ZhangLiang on 2022/8/1.
//

#import "ZLPhotos.h"
#import <Photos/Photos.h>
#import "ZLPhotoCollectionViewCell.h"
#import "ZLAssetModel.h"
#import "ZLPhotosBrowser.h"

@interface ZLPhotos () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ZLPhotoCollectionViewCellDelegate, ZLPhotosBrowserDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UILabel *selectedCountLab;
// 相册中所有的照片
@property (nonatomic, strong) NSArray *assetModelArr;

@end

@implementation ZLPhotos

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedMaxCount = 3;
    
    CGFloat toolbarH = 44;
    CGFloat toolbarW = self.view.bounds.size.width;
    CGFloat toolbarX = 0;
    CGFloat toolbarY = self.view.bounds.size.height - toolbarH - [UIApplication sharedApplication].statusBarFrame.size.height - 20;
    UIView *toolbar = [[UIView alloc] initWithFrame:CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH)];
    toolbar.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:toolbar];
    
    CGFloat confimBtnW = 90;
    CGFloat confimBtnH = toolbarH;
    UIButton *confimBtn = [[UIButton alloc] initWithFrame:CGRectMake(toolbarW - confimBtnW, 0, confimBtnW, confimBtnH)];
    [confimBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confimBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    confimBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [confimBtn addTarget:self action:@selector(confimAction) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:confimBtn];
    
    CGFloat cancelBtnW = confimBtnW;
    CGFloat cancelBtnH = toolbarH;
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, cancelBtnW, cancelBtnH)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:cancelBtn];
    
    CGFloat selectedCountLabX = 10;
    CGFloat selectedCountLabW = toolbarW - confimBtnW * 2 - selectedCountLabX * 2;
    CGFloat selectedCountLabH = toolbarH;
    UILabel *selectedCountLab = [[UILabel alloc] initWithFrame:CGRectMake(cancelBtnW + selectedCountLabX, 0, selectedCountLabW, selectedCountLabH)];
    selectedCountLab.text = [NSString stringWithFormat:@"已选: 0/%d", self.selectedMaxCount];
    selectedCountLab.font = [UIFont systemFontOfSize:15];
    selectedCountLab.textColor = [UIColor whiteColor];
    selectedCountLab.textAlignment = NSTextAlignmentCenter;
    [toolbar addSubview:selectedCountLab];
    self.selectedCountLab = selectedCountLab;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(kPhotoCellWH, kPhotoCellWH);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, toolbarY) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [collectionView registerClass:[ZLPhotoCollectionViewCell class] forCellWithReuseIdentifier:[ZLPhotoCollectionViewCell cellIdentifier]];
    
    __weak typeof(self) wekself = self;
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
                assetModel.assetSize = CGSizeMake(kPhotoCellWH * kPhotoCellScale, kPhotoCellWH * kPhotoCellScale);
                assetModel.selected = NO;
                assetModel.enabled = YES;
                [assetModelMArr addObject:assetModel];
            }
            
            wekself.assetModelArr = [assetModelMArr copy];
            
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

- (void)setSelectedMaxCount:(int)selectedMaxCount {
    _selectedMaxCount = selectedMaxCount;
    
    self.selectedCountLab.text = [NSString stringWithFormat:@"已选: 0/%d", self.selectedMaxCount];
}

- (void)cancelAction {
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)confimAction {
    if (self.selectedPhotosBlock) {
        NSMutableArray<NSData *> *imagesData = [[NSMutableArray alloc] init];
        for (ZLAssetModel *assetModel in self.assetModelArr) {
            if (assetModel.isSelected) {
                // 获取照片
                [[PHCachingImageManager defaultManager] requestImageForAsset:assetModel.asset targetSize:CGSizeMake(self.view.bounds.size.width * kPhotoCellScale, self.view.bounds.size.height * kPhotoCellScale) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    [imagesData addObject:UIImageJPEGRepresentation(result, 0.6)];
                }];
            }
        }
        
        self.selectedPhotosBlock(imagesData);
    }
    
    [self cancelAction];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.assetModelArr count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZLPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ZLPhotoCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    cell.delegate = self;
    ZLAssetModel *assetModel = self.assetModelArr[indexPath.row];
    assetModel.originRect = [collectionView convertRect:cell.frame toView:self.view];
    cell.assetModel = assetModel;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect rect = [collectionView convertRect:[collectionView cellForItemAtIndexPath:indexPath].frame toView:self.view];
    ZLPhotosBrowser *photosBrowser = [[ZLPhotosBrowser alloc] initWithFrame:rect];
    [photosBrowser setBackgroundColor:[UIColor lightGrayColor]];
    photosBrowser.assetModelArr = self.assetModelArr;
    photosBrowser.delegate = self;
    [self.view addSubview:photosBrowser];
    photosBrowser.selectedIndex = indexPath.row;
    [UIView animateWithDuration:kSeePhotoDuration animations:^{
        photosBrowser.frame = self.collectionView.bounds;
    }];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kPhotoCellWH, kPhotoCellWH);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(2, 10, 2, 10);
}

#pragma mark - ZLPhotoCollectionViewCellDelegate
- (void)photoCollectionViewCell:(ZLPhotoCollectionViewCell *)cell didSelected:(ZLAssetModel *)assetModel {
    assetModel.selected = !assetModel.selected;
    int index = 0;
    for (ZLAssetModel *assetModel in self.assetModelArr) {
        if (assetModel.isSelected) {
            index += 1;
        }
    }
    
    if (index < self.selectedMaxCount) {
        for (ZLAssetModel *assetModel in self.assetModelArr) {
            assetModel.enabled = YES;
        }
        
    } else {
        for (ZLAssetModel *assetModel in self.assetModelArr) {
            assetModel.enabled = assetModel.isSelected;
        }
    }
    
    self.selectedCountLab.text = [NSString stringWithFormat:@"已选: %d/%d", index, self.selectedMaxCount];
    [self.collectionView reloadData];
}

#pragma mark - ZLPhotosBrowserDelegate
- (void)photosBrowser:(ZLPhotosBrowser *)photosBrowser didSelected:(ZLAssetModel *)assetModel {
    [self photoCollectionViewCell:nil didSelected:assetModel];
}

@end
