//
//  TYSettingItem.m
//  涂鸦
//
//  Created by Leo on 16/8/31.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import "TYSettingItem.h"

@implementation TYSettingItem

+ (instancetype)itemWithTitle:(NSString *)title {
    TYSettingItem *item = [[self alloc] init];
    item.title = title;
    
    return item;
}


@end
