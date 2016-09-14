//
//  TYShowImageViewCell.m
//  涂鸦
//
//  Created by Leo on 16/8/27.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import "TYShowImageViewCell.h"

@implementation TYShowImageViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.imageV];
    }
    
    return self;
}

- (UIImageView *)imageV{
    if (!_imageV) {
        self.imageV = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageV.userInteractionEnabled = YES;
    }
    return _imageV;
}

- (UIButton *)deleteButten{
    if (!_deleteButten) {
        self.deleteButten = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButten.frame = CGRectMake(60, -6, 25, 25);
        [_deleteButten setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    }
    return _deleteButten;
}

@end
