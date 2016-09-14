//
//  TYColorSelect.h
//  涂鸦
//
//  Created by Leo on 16/8/27.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CUB_WIDTH 30

#define SELECT_WIDTH CUB_WIDTH * 7 + 8
#define SELECT_HEIGHT CUB_WIDTH * 2 + 3

@class TYColorSelect;
@protocol TYColorSelectDelegate <NSObject>

- (void)selectView:(TYColorSelect *)selectView tipedColor:(UIColor *)color;

@end

@interface TYColorSelect : UIView


@property (nonatomic, strong) NSMutableArray *colorArray;
@property (nonatomic, weak) id<TYColorSelectDelegate>delegate;


@end
