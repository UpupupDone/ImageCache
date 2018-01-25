//
//  TableViewCell.m
//  ImageCache
//
//  Created by nbcb on 2017/9/20.
//  Copyright © 2017年 ZQC. All rights reserved.
//

#import "TableViewCell.h"
#import "Masonry.h"

#define ScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)
#define ScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)

@interface TableViewCell ()

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIButton *imgBtn;

@property (nonatomic, copy) EditImageBlock editImageBlock;

@end

@implementation TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self layoutViews];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}

- (void)layoutViews {
    
    __weak __typeof__ (self) weakSelf = self;
    
    [self.contentView addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.centerY.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth / 2.0, 40));
    }];
    
    [self.contentView addSubview:self.imgBtn];
    [self.imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.centerY.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
}

- (UILabel *)label {
    
    if (!_label) {
        
        self.label = [[UILabel alloc] init];
        _label.backgroundColor = [UIColor clearColor];
        _label.numberOfLines = 0;
        //        _label.adjustsFontSizeToFitWidth = YES;
    }
    return _label;
}

- (UIButton *)imgBtn {
    
    if (!_imgBtn) {
        
        self.imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imgBtn setBackgroundImage:[UIImage imageNamed:@"addimageshadow"] forState:UIControlStateNormal];
        _imgBtn.adjustsImageWhenHighlighted = NO;
        [_imgBtn addTarget:self action:@selector(editImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imgBtn;
}

- (void)setTitle:(NSString *)title imageFlag:(NSInteger)flag editBlock:(EditImageBlock)block {
    
    self.label.text = title;
    self.imgBtn.tag = flag;
    
    if (block) {
        
        self.editImageBlock = block;
    }
}

- (void)setImgBtnImage:(UIImage *)image {
    
    if (image) {
        
        [self.imgBtn setBackgroundImage:image forState:UIControlStateNormal];
    }
    else {
        
        [self.imgBtn setBackgroundImage:[UIImage imageNamed:@"addimageshadow"] forState:UIControlStateNormal];
    }
}

#pragma - Action
- (void)editImage:(UIButton *)sender {
    
    if (self.editImageBlock) {
        
        self.editImageBlock(sender.tag);
    }
}

+ (CGFloat)getCellHeight {
    
    return 100;
}

- (void)dealloc {
    
}

@end
