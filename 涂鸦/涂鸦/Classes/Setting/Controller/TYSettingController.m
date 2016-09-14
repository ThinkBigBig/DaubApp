//
//  TYSettingController.m
//  涂鸦
//
//  Created by Leo on 16/8/31.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import "TYSettingController.h"
#import "TYGroupItem.h"
#import "TYSettingArrowItem.h"
#import "TYSettingSwitchItem.h"
#import "TYSettingCell.h"

@interface TYSettingController ()

// 保存当前tableview有多少组，元素也是一个数组，记录这一组有多少行
@property (nonatomic, strong) NSMutableArray *groups;

@end

@implementation TYSettingController

- (NSMutableArray *)groups {
    if (_groups == nil) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

- (instancetype)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpGroup0];
    [self setUpGroup1];
    
}

- (void)setUpGroup0 {
    // 创建组模型
    TYGroupItem *group = [[TYGroupItem alloc] init];
    // 创建模型
    TYSettingSwitchItem *item = [TYSettingSwitchItem itemWithTitle:@"推送通知"];
    // 创建一个数组，描述第0组有多少行
    group.items = @[item];
    [self.groups addObject:group];
}

- (void)setUpGroup1 {
    // 创建组模型
    TYGroupItem *group = [[TYGroupItem alloc] init];
    // 创建模型
    TYSettingArrowItem *item = [TYSettingArrowItem itemWithTitle:@"在这吐槽吧！"];
    TYSettingArrowItem *item1 = [TYSettingArrowItem itemWithTitle:@"给个好评吧！"];
    
    // 创建一个数组，描述第0组有多少行
    group.items = @[item, item1];
    [self.groups addObject:group];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TYGroupItem *group = self.groups[section];
    
    return group.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 创建cell
    TYSettingCell *cell = [TYSettingCell cellWithTableView:tableView];
    
    // 获取对应的小数组
    TYGroupItem *group = self.groups[indexPath.section];
    
    // 获取模型
    TYSettingItem *item = group.items[indexPath.row];
    
    // 给cell传递一个模型
    cell.item = item;
    
    return cell;
}

@end
