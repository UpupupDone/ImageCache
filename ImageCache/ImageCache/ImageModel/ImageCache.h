//
//  ImageCache.h
//  NBBankEnt
//
//  Created by nbcb on 2017/9/19.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageCache : NSObject

+ (ImageCache *)sharedCache;

/** 保存图片 */
- (void)saveImage:(UIImage *)image withImageName:(NSString *)imageName withImageScale:(CGFloat )scale;

/** 读取图片 */
- (UIImage *)readImageWithName:(NSString *)imageName;

/** 删除单张图片 */
- (void)removeImage:(NSString *)imageName;

/** 删除所有图片 */
- (void)removeAllImages;

@end
