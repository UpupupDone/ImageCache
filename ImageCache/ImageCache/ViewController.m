//
//  ViewController.m
//  ImageCache
//
//  Created by nbcb on 2017/9/20.
//  Copyright © 2017年 ZQC. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "ImagePicker.h"
#import "ImageCache.h"


#define IMGNAME_PREFIX @"OpenAccRow"

@interface ViewController ()

@end

@interface ViewController ()<UIActionSheetDelegate, ImagePickerDelegate>

@property (nonatomic, strong)  UIActionSheet *customSheetTypeOne;
@property (nonatomic, strong)  UIActionSheet *customSheetTypeTwo;

@property (nonatomic, assign) __block NSInteger indexRow;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStylePlain];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    [self initData];
}

- (void)initData {
    
    _titleArr = @[@"XXXXXX组织:", @"XXXXXX机构:", @"XXXXXX旅行社:", @"XXXXXX机场:", @"XXXXXX公司:", @"XXXXXX超市:", @"XXXXXX广场"];
    [[ImageCache sharedCache] removeAllImages];
}

#pragma mark TableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [TableViewCell getCellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    static NSString *identifier = @"cell";
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    __weak __typeof__ (self) weakSelf = self;
    
    NSString *imageName = [NSString stringWithFormat:@"%@_%ld", IMGNAME_PREFIX, row];
    [cell setImgBtnImage:[[ImageCache sharedCache] readImageWithName:imageName]];
    
    [cell setTitle:_titleArr[row] imageFlag:row editBlock:^(NSInteger idx) {
        
        NSString *imageName = [NSString stringWithFormat:@"%@_%ld", IMGNAME_PREFIX, idx];
        UIImage *image = [[ImageCache sharedCache] readImageWithName:imageName];
        
        weakSelf.indexRow = idx;
        
        if (image) {
            
            [weakSelf.customSheetTypeOne showInView:weakSelf.view];
        } else {
            [weakSelf.customSheetTypeTwo showInView:weakSelf.view];
        }
    }];
    
    return cell;
}

#pragma - Action

- (UIActionSheet *)customSheetTypeOne {
    
    if (!_customSheetTypeOne) {
        
        self.customSheetTypeOne = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机", @"相册", @"删除", nil];
    }
    return _customSheetTypeOne;
}

- (UIActionSheet *)customSheetTypeTwo {
    
    if (!_customSheetTypeTwo) {
        
        self.customSheetTypeTwo = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机", @"相册", nil];
    }
    return _customSheetTypeTwo;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        ImagePicker *imagePicker = [ImagePicker sharedInstance];
        imagePicker.delegate = self;
        [imagePicker showImagePickerWithType:ImagePickerCamera InViewController:self Scale:1];
    }
    else if (buttonIndex == 1) {
        
        ImagePicker *imagePicker = [ImagePicker sharedInstance];
        imagePicker.delegate = self;
        [imagePicker showOriginalImagePickerWithType:ImagePickerPhoto InViewController:self];
    }
    else if (buttonIndex == 2) {
        
        NSString *imageName = [NSString stringWithFormat:@"%@_%ld", IMGNAME_PREFIX, self.indexRow];
        [[ImageCache sharedCache] removeImage:imageName];
        [self.tableView reloadData];
    }
}

- (void)imagePickerDidCancel:(ImagePicker *)imagePicker {
    
}

- (void)imagePicker:(ImagePicker *)imagePicker didFinished:(UIImage *)editedImage {
    
    NSString *imageName = [NSString stringWithFormat:@"%@_%ld", IMGNAME_PREFIX, self.indexRow];
    
    [[ImageCache sharedCache] saveImage:editedImage withImageName:imageName withImageScale:0.5];
    
    [self.tableView reloadData];
}

- (void)dealloc {
    
}

@end
