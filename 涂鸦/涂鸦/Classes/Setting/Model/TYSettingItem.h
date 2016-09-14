//
//  TYSettingItem.h
//  涂鸦
//
//  Created by Leo on 16/8/31.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYSettingItem : NSObject

@property (nonatomic, strong) NSString *title;

+ (instancetype)itemWithTitle:(NSString *)title;

@end
