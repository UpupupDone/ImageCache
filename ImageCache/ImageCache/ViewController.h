//
//  ViewController.h
//  ImageCache
//
//  Created by nbcb on 2017/9/20.
//  Copyright © 2017年 ZQC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

{
    NSArray         *_titleArr;
}

@property (nonatomic, strong) UITableView *tableView;

@end

