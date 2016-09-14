//
//  TYAddViewCell.m
//  涂鸦
//
//  Created by Leo on 16/8/27.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import "TYAddViewCell.h"

@implementation TYAddViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.addImageV];
        
        
    }
    return self;
}

- (UIImageView *)addImageV{
    if (!_addImageV) {
        self.addImageV = [[UIImageView alloc] initWithFrame:self.bounds];
        _addImageV.image = [UIImage imageNamed:@"addImage"];
        
    }
    return _addImageV;
}

@end
