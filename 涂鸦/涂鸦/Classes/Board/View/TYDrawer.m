//
//  TYDrawer.m
//  涂鸦
//
//  Created by Leo on 16/8/27.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import "TYDrawer.h"
#import "TYBezierPath.h"

@interface TYDrawer ()

@property (nonatomic, strong) TYBezierPath *path;
@property (nonatomic, strong) CAShapeLayer * slayer;

@end

@implementation TYDrawer

#pragma mark - 重写方法

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lineColor = [UIColor blackColor];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - Privat Methods

- (CGPoint)pointWithTouches:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    
    return [touch locationInView:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint startP = [self pointWithTouches:touches];
    
    if ([event allTouches].count == 1) {
        
        TYBezierPath *path = [TYBezierPath paintPathWithLineWidth:_width
                                                       startPoint:startP];
        _path = path;
        
        CAShapeLayer * slayer = [CAShapeLayer layer];
        slayer.path = path.CGPath;
        slayer.backgroundColor = [UIColor clearColor].CGColor;
        slayer.fillColor = [UIColor clearColor].CGColor;
        slayer.lineCap = kCALineCapRound;
        slayer.lineJoin = kCALineJoinRound;
        slayer.strokeColor = self.lineColor.CGColor;
        slayer.lineWidth = path.lineWidth;
        [self.layer addSublayer:slayer];
        _slayer = slayer;
        [[self mutableArrayValueForKey:@"canceledLines"] removeAllObjects];
        [[self mutableArrayValueForKey:@"lines"] addObject:_slayer];
        
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 获取移动点
    CGPoint moveP = [self pointWithTouches:touches];
    
    if ([event allTouches].count > 1){
        
        [self.superview touchesMoved:touches withEvent:event];
        
    }else if ([event allTouches].count == 1) {
        
        [_path addLineToPoint:moveP];
        
        _slayer.path = _path.CGPath;
        
    }
    
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([event allTouches].count > 1){
        [self.superview touchesMoved:touches withEvent:event];
    }
}

-(void)setImage:(UIImage *)image{
    _image = image;
    
    [self.lines addObject:image];
    
    [self setNeedsDisplay];
    
}

/**
 *  清屏
 */
- (void)clearScreen
{
    
    if (!self.lines.count) return ;
    
    [self.lines makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [[self mutableArrayValueForKey:@"lines"] removeAllObjects];
    [[self mutableArrayValueForKey:@"canceledLines"] removeAllObjects];
    
}

/**
 *  撤销
 */
- (void)undo
{
    //当前屏幕已经清空，就不能撤销了
    if (!self.lines.count) return;
    [[self mutableArrayValueForKey:@"canceledLines"] addObject:self.lines.lastObject];
    [self.lines.lastObject removeFromSuperlayer];
    [[self mutableArrayValueForKey:@"lines"] removeLastObject];
    
}

/**
 *  恢复
 */
- (void)redo
{
    //当没有做过撤销操作，就不能恢复了
    if (!self.canceledLines.count) return;
    [[self mutableArrayValueForKey:@"lines"] addObject:self.canceledLines.lastObject];
    [[self mutableArrayValueForKey:@"canceledLines"] removeLastObject];
    [self drawLine];
    
}
//
/**
 *  画线
 */
- (void)drawLine {
    
    [self.layer addSublayer:self.lines.lastObject];
}

#pragma mark - Getters

- (NSMutableArray *)lines {
    if (!_lines) {
        _lines = [NSMutableArray array];
    }
    return _lines;
}

- (NSMutableArray *)canceledLines {
    if (!_canceledLines) {
        _canceledLines = [NSMutableArray array];
    }
    return _canceledLines;
}

@end
