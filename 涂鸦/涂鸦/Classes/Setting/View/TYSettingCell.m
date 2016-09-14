//
//  TYSettingCell.m
//  涂鸦
//
//  Created by Leo on 16/8/31.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import "TYSettingCell.h"
#import "TYSettingItem.h"
#import "TYSettingArrowItem.h"
#import "TYSettingSwitchItem.h"

@interface TYSettingCell ()

@end

@implementation TYSettingCell

- (UISwitch *)switchBtn {
    if (_switchBtn == nil) {
        
        UISwitch *switchBtn = [[UISwitch alloc] init];
        
        // 保存switch的开关状态
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [switchBtn setOn:[defaults boolForKey:@"state"] animated:YES];
        self.isClick = [defaults boolForKey:@"state"];
        [switchBtn addTarget:self action:@selector(isClicked) forControlEvents:UIControlEventValueChanged];
        
        _switchBtn = switchBtn;
    }
    
    return _switchBtn;
}

- (void)isClicked {
    self.isClick = !self.isClick;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.isClick forKey:@"state"];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"cell";
    TYSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)setItem:(TYSettingItem *)item {
    _item = item;
    
    // 设置cell的数据
    [self setUpData];
    
    // 设置cell的辅助视图
    [self setUpAccessoryView];
}

- (void)setUpData {
    self.textLabel.text = _item.title;
    //    self.imageView.image = _item.image;
}

- (void)setUpAccessoryView {
    if ([_item isKindOfClass:[TYSettingArrowItem class]]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if([_item isKindOfClass:[TYSettingSwitchItem class]]) {
        self.accessoryView = self.switchBtn;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else {
        self.accessoryView = nil;
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
