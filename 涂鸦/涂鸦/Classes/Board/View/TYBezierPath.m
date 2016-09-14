//
//  TYBezierPath.m
//  涂鸦
//
//  Created by Leo on 16/8/27.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import "TYBezierPath.h"


@implementation TYBezierPath

+ (instancetype)paintPathWithLineWidth:(CGFloat)width startPoint:(CGPoint)startP {
    
    TYBezierPath * path = [[self alloc] init];
    path.lineWidth = width;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    [path moveToPoint:startP];
    
    return path;
}

@end
