//
//  TYSettingCell.h
//  涂鸦
//
//  Created by Leo on 16/8/31.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TYSettingItem;
@interface TYSettingCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) TYSettingItem *item;
@property (nonatomic, strong) UISwitch *switchBtn;
@property (nonatomic, assign) BOOL isClick;

@end
