//
//  TYBoardController.h
//  涂鸦
//
//  Created by Leo on 16/8/26.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TYBoardControllerDelegate <NSObject>

- (void)imageDataArray:(NSMutableArray *)imageDataArray andImageArray:(NSMutableArray *)imageArray;

@end

@interface TYBoardController : UIViewController

@property (nonatomic, strong) NSString *imagePath;


@property (nonatomic, assign) id<TYBoardControllerDelegate> delegate;

- (void)WriteToBox:(NSData *)imageData;

@end
