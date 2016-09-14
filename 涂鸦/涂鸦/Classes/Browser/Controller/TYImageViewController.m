//
//  TYImageViewController.m
//  涂鸦
//
//  Created by Leo on 16/8/26.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import "TYImageViewController.h"

@interface TYImageViewController ()

@end

@implementation TYImageViewController

- (void)viewWillAppear:(BOOL)animated {
    [self prefersStatusBarHidden];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTap)];
    [self.view addGestureRecognizer:tap];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    imageV.center = self.view.center;
    imageV.image = [UIImage imageWithData:self.imageData];
    [self.view addSubview:imageV];
}

- (void)dismissTap {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
