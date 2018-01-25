//
//  ImageCropperVC.h
//  NBBankEnt
//
//  Created by nbcb on 2017/9/18.
//
//

#import <UIKit/UIKit.h>

typedef void(^SubmitBlock)(UIViewController *viewController , UIImage *image);
typedef void(^CancelBlock)(UIViewController *viewController);

@interface ImageCropperVC : UIViewController

@property (nonatomic, copy) SubmitBlock submitblock;
@property (nonatomic, copy) CancelBlock cancelblock;
@property (nonatomic, assign) CGRect cropFrame;

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@end
