//
//  ImagePicker.h
//  NBBankEnt
//
//  Created by nbcb on 2017/9/18.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ImagePickerType) {
    
    ImagePickerCamera = 0,
    ImagePickerPhoto = 1
};

@class ImagePicker;

@protocol ImagePickerDelegate <NSObject>

- (void)imagePicker:(ImagePicker *)imagePicker didFinished:(UIImage *)editedImage;
- (void)imagePickerDidCancel:(ImagePicker *)imagePicker;

@end

@interface ImagePicker : NSObject

+ (instancetype) sharedInstance;

//delegate
@property (nonatomic, assign) id<ImagePickerDelegate> delegate;

//choose original image
- (void)showOriginalImagePickerWithType:(ImagePickerType)type InViewController:(UIViewController *)viewController;

//Custom cut. Cutting box's scale(height/Width) 0~1.5 default is 1
- (void)showImagePickerWithType:(ImagePickerType)type InViewController:(UIViewController *)viewController Scale:(double)scale;

@end
