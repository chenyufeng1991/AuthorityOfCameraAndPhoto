//
//  ViewController.m
//  AuthorityOfCameraAndPhoto
//
//  Created by chenyufeng on 6/20/16.
//  Copyright © 2016 chenyufengweb. All rights reserved.
//

#import "MainViewController.h"
#import "Masonry.h"
#import "YFKit.h"
#import "DeniedAuthViewController.h"
@import AVFoundation;
@import Photos;

@interface MainViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"相机照片授权";

    [self configUI];
}

- (void)configUI
{
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [cameraBtn setTitle:@"原始的摄像头授权" forState:UIControlStateNormal];
    [cameraBtn addTarget:self action:@selector(cameraBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraBtn];
    [cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@30);
    }];

    UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [photoBtn setTitle:@"原始的相册授权" forState:UIControlStateNormal];
    [photoBtn addTarget:self action:@selector(photoBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoBtn];
    [photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cameraBtn).offset(50);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@30);
    }];

    UIButton *optimalCameraBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [optimalCameraBtn setTitle:@"优化的摄像头授权" forState:UIControlStateNormal];
    [optimalCameraBtn addTarget:self action:@selector(optimalCameraBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:optimalCameraBtn];
    [optimalCameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(photoBtn).offset(50);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@30);
    }];

    UIButton *optimalPhotoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [optimalPhotoBtn setTitle:@"优化的相册授权" forState:UIControlStateNormal];
    [optimalPhotoBtn addTarget:self action:@selector(optimalPhotoBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:optimalPhotoBtn];
    [optimalPhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(optimalCameraBtn).offset(50);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@30);
    }];
}

- (void)cameraBtnPressed:(id)sender
{
    // 首先查看当前设备是否支持拍照
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [self presentToImagePickerController:UIImagePickerControllerSourceTypeCamera];
    }
    else
    {
        [self showAlertController:@"提示" message:@"当前设备不支持拍照"];
    }
}

- (void)photoBtnPressed:(id)sender
{
    // 首先查看当前设备是否支持相册
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        [self presentToImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    else
    {
        [self showAlertController:@"提示" message:@"当前设备不支持相册"];
    }
}

- (void)optimalCameraBtnPressed:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        if ([YFKit isCameraNotDetermined])
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted)
                    {
                        [self presentToImagePickerController:UIImagePickerControllerSourceTypeCamera];
                    }
                    else
                    {
                        // 跳转到空态
                        DeniedAuthViewController *vc = [[DeniedAuthViewController alloc] init];
                        [self presentViewController:vc animated:YES completion:nil];
                    }
                });
            }];
        }
        else if ([YFKit isCameraDenied])
        {
            [self showAlertController:@"提示" message:@"拒绝访问摄像头，可去设置隐私里开启"];
        }
        else
        {
            [self presentToImagePickerController:UIImagePickerControllerSourceTypeCamera];
        }
    }
    else
    {
        [self showAlertController:@"提示" message:@"当前设备不支持拍照"];
    }
}

- (void)optimalPhotoBtnPressed:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        if ([YFKit isPhotoAlbumNotDetermined])
        {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            {
                // 该API从iOS8.0开始支持
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
                        {
                            DeniedAuthViewController *vc = [[DeniedAuthViewController alloc] init];
                            [self presentViewController:vc animated:YES completion:nil];
                        }
                        else if (status == PHAuthorizationStatusAuthorized)
                        {
                            [self presentToImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
                        }
                    });
                }];
            }
            else
            {
                [self presentToImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
            }
        }
        else if ([YFKit isPhotoAlbumDenied])
        {
            [self showAlertController:@"提示" message:@"拒绝访问相册，可去设置隐私里开启"];
        }
        else
        {
            [self presentToImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    }
    else
    {
        [self showAlertController:@"提示" message:@"当前设备不支持相册"];
    }
}

- (void)presentToImagePickerController:(UIImagePickerControllerSourceType)type
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = type;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)showAlertController:(NSString *)title message:(NSString *)message
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }]];
    [self presentViewController:ac animated:YES completion:nil];
}

@end
