//
//  TYDrawer.h
//  涂鸦
//
//  Created by Leo on 16/8/27.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYDrawer : UIView

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) UIColor *lineColor;

@property (nonatomic, strong) UIImage *image;

//@property (nonatomic, assign) DrawRectType rectType;

/**
 *  撤销的线条数组
 */
@property (nonatomic, strong)NSMutableArray * canceledLines;
/**
 *  线条数组
 */
@property (nonatomic, strong)NSMutableArray * lines;

/**
 *  清屏
 */
- (void)clearScreen;

/**
 *  撤销
 */
- (void)undo;

/**
 *  恢复
 */
- (void)redo;

@end
