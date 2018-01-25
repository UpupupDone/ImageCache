//
//  ImagePicker.m
//  NBBankEnt
//
//  Created by nbcb on 2017/9/18.
//
//

#import "ImagePicker.h"
#import "ImageCropperVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#define ScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)
#define ScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)

@interface ImagePicker()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate> {
    
//    BOOL isScale;
//    double _scale;
}

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) ImageCropperVC *imageCropperController;

@end

@implementation ImagePicker

#pragma  mark -- 单例 --
+ (instancetype)sharedInstance {
    
    static dispatch_once_t ETToken;
    static ImagePicker *sharedInstance = nil;
    
    dispatch_once(&ETToken, ^{
        
        sharedInstance = [[ImagePicker alloc] init];
    });
    return sharedInstance;
}

- (void)showOriginalImagePickerWithType:(ImagePickerType)type InViewController:(UIViewController *)viewController {
    
    if (![self isJurisdictionWithType:type]) {
        
        return ;
    }
    
    if (type == ImagePickerCamera) {
        
        self.imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
    }
    else {
        
        self.imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
//    isScale = NO;
//    self.imagePickerController.allowsEditing = YES;
    [viewController presentViewController:_imagePickerController animated:YES completion:nil];
}

- (void)showImagePickerWithType:(ImagePickerType)type InViewController:(UIViewController *)viewController Scale:(double)scale {
    
    if (![self isJurisdictionWithType:type]) {
        
        return ;
    }
    
    if (type == ImagePickerCamera) {
        
        self.imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
    }
    else {
        
        self.imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
//    self.imagePickerController.allowsEditing = NO;
//    isScale = YES;
//
//    if(scale > 0 && scale <= 1.5) {
//
//        _scale = scale;
//    }
//    else {
//
//        _scale = 1;
//    }
    
    [viewController presentViewController:_imagePickerController animated:YES completion:nil];
}

- (BOOL)isJurisdictionWithType:(ImagePickerType)type {
    
    if (type == ImagePickerCamera) {
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
            
            UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的相机\n设置>隐私>相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alart show];
            return NO;
        }
    }
    else {
        
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        
        if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied) {
            
            UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的相册\n设置>隐私>照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alart show];
            return NO;
        }
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [alertView dismissWithClickedButtonIndex:-1 animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageOrientation imageOrientation=image.imageOrientation;
    
    if (imageOrientation != UIImageOrientationUp) {
        
        // Adjust picture Angle
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
//    if (isScale) {
//
//        self.imageCropperController = [[ImageCropperVC alloc] initWithImage:image cropFrame:CGRectMake(0, (ScreenHeight - ScreenWidth * _scale) / 2, ScreenWidth, ScreenWidth * _scale) limitScaleRatio:5];
//        __weak __typeof__ (self) weakself = self;
//
//        [_imageCropperController setSubmitblock:^(UIViewController *viewController , UIImage *image) {
//
//            [viewController dismissViewControllerAnimated:YES completion:nil];
//
//            if (weakself.delegate) {
//
//                [weakself.delegate imagePicker:weakself didFinished:image];
//            }
//        }];
//
//        [_imageCropperController setCancelblock:^(UIViewController *viewController) {
//
//            UIImagePickerController *picker = (UIImagePickerController *)viewController.navigationController;
//
//            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
//
//                [viewController.navigationController dismissViewControllerAnimated:YES completion:nil];
//            }
//            else {
//
//                [viewController.navigationController popViewControllerAnimated:YES];
//            }
//        }];
//        [picker pushViewController:self.imageCropperController animated:YES];
//    }
//    else {
    
        [picker dismissViewControllerAnimated:YES completion:^{}];
        [self.delegate imagePicker:self didFinished:image];
//    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    if (self.delegate) {
        
        [self.delegate imagePickerDidCancel:self];
    }
}

#pragma mark - Getters
- (UIImagePickerController *)imagePickerController {
    
    if (!_imagePickerController) {
        
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
//        _imagePickerController.allowsEditing = NO;
    }
    return _imagePickerController;
}

@end
