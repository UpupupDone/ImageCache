//
//  ImageCache.m
//  NBBankEnt
//
//  Created by nbcb on 2017/9/19.
//
//

#import "ImageCache.h"

@interface ImageCache ()

{
    NSString       *_saveFilePath;
}

@end

@implementation ImageCache

+ (ImageCache *)sharedCache {
    
    static ImageCache *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[ImageCache alloc] init];
    });
    return instance;
}

- (void)saveImage:(UIImage *)image withImageName:(NSString *)imageName withImageScale:(CGFloat)scale {
    
    //1、尺寸压缩
    UIImage *img = [self imageWithImage:image scaledToSize:CGSizeMake(600, 600)];
    
    //2、质量压缩 再转成NSData
    NSData *data = UIImageJPEGRepresentation(img, scale);
    CGFloat length = [data length] / 1000;
    
    NSLog(@"jpeg = %.f kb", length);
    
    // data加密成Base64形式的NSData
    NSData *base64Data = [data base64EncodedDataWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //拼接存放文件夹
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *createPath = [NSString stringWithFormat:@"%@/OpenAccImage", pathDocuments];
    _saveFilePath = createPath;
    
    // 判断文件夹是否存在，如果不存在，则创建
    if (![fileManager fileExistsAtPath:createPath]) {
        
        //如果没有就创建这个 想创建的文件夹
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        //保存
        NSString *imgFileName = [NSString stringWithFormat:@"/%@.png", imageName];
        BOOL isSuccess = [fileManager createFileAtPath:[_saveFilePath stringByAppendingString:imgFileName] contents:base64Data attributes:nil];
        
        if (!isSuccess) {
            
            NSLog(@"写入文件失败");
        }
    }
    else {
        
        //文件夹存在   直接保存
        NSString *imgFileName = [NSString stringWithFormat:@"/%@.png", imageName];
        BOOL isSuccess = [fileManager createFileAtPath:[_saveFilePath stringByAppendingString:imgFileName]contents:base64Data attributes:nil];
        if (!isSuccess) {
            
            NSLog(@"写入文件失败");
        }
    }
}

- (UIImage *)readImageWithName:(NSString *)imageName {
    
    NSString *documentsPath =[NSString stringWithFormat:@"%@/Documents/OpenAccImage", NSHomeDirectory()];
    
    if (!_saveFilePath) {
        
        _saveFilePath = documentsPath;
    }
    
    NSString *filePath = [[NSString alloc] initWithFormat:@"%@/%@.png", documentsPath, imageName];
    
    //存储的是base64Data
    NSData *base64Data = [[NSData alloc] initWithContentsOfFile:filePath];
    
    UIImage *img = nil;
    
    if (base64Data) {
        
        //baseData 转为 Data
        NSData *imageData = [[NSData alloc] initWithBase64EncodedData:base64Data options:NSDataBase64DecodingIgnoreUnknownCharacters];
        img = [[UIImage alloc] initWithData:imageData];
    }
    else {
        
        img = [UIImage imageNamed:@"addimageshadow"];
    }
    
    return img;
}

- (void)removeImage:(NSString *)imageName {
    
    //    NSString *documentsPath = [NSHomeDirectory()stringByAppendingPathComponent:_saveFilePath];
    
    NSString *filePath = [[NSString alloc] initWithFormat:@"%@/%@.png", _saveFilePath, imageName];
    
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

- (void)removeAllImages {
    
    [[NSFileManager defaultManager] removeItemAtPath:_saveFilePath error:nil];
}

//压缩图片 尺寸压缩
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

@end
