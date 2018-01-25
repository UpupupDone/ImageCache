//
//  TableViewCell.h
//  ImageCache
//
//  Created by nbcb on 2017/9/20.
//  Copyright © 2017年 ZQC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EditImageBlock)(NSInteger idx);

@interface TableViewCell : UITableViewCell

- (void)setTitle:(NSString *)title imageFlag:(NSInteger)flag editBlock:(EditImageBlock)block;

- (void)setImgBtnImage:(UIImage *)image;

+ (CGFloat)getCellHeight;

@end
