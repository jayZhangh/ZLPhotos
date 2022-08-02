//
//  ViewController.m
//  ZLPhotos
//
//  Created by ZhangLiang on 2022/8/1.
//

#import "ViewController.h"
#import "ZLPhotos.h"

@interface ViewController ()
- (IBAction)photoAction:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (IBAction)photoAction:(id)sender {
    ZLPhotos *photos = [[ZLPhotos alloc] init];
    photos.selectedPhotosBlock = ^(NSArray<NSData *> * _Nonnull imagesData) {
        NSLog(@"%ld", [imagesData count]);
    };
    
    [self presentViewController:photos animated:YES completion:nil];
}

@end
