//
//  TYBrowserController.m
//  涂鸦
//
//  Created by Leo on 16/8/26.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import "TYBrowserController.h"
#import "TYBoardController.h"
#import "TYImageViewController.h"
#import "TYSettingController.h"

#import "TYShowImageViewCell.h"
#import "TYAddViewCell.h"

#define Kwidth  [UIScreen mainScreen].bounds.size.width
#define Kheight [UIScreen mainScreen].bounds.size.height

@interface TYBrowserController ()<UICollectionViewDelegate, UICollectionViewDataSource, TYBoardControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray   *imageArray;
@property (nonatomic, strong) NSMutableArray   *imageDataArray;

@property (nonatomic, strong) TYBoardController *boardVC;

@property (nonatomic, assign) NSInteger i;


@end

@implementation TYBrowserController

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(80, 80);
        flowLayout.sectionInset = UIEdgeInsetsMake(11, 11, 0, 11);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 25, Kwidth, Kheight - 32) collectionViewLayout:flowLayout];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.scrollEnabled = YES;
    }
    return _collectionView;
}

- (NSMutableArray *)imageDataArray{
    if (!_imageDataArray) {
        self.imageDataArray = [NSMutableArray array];
    }
    return _imageDataArray;
}

- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        self.imageArray = [NSMutableArray array];
        
    }
    return _imageArray;
}

- (TYBoardController *)boardVC {
    if (_boardVC == nil) {
        TYBoardController *vc = [[TYBoardController alloc] init];
        _boardVC = vc;
    }
    return _boardVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"列表";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"set"] style:UIBarButtonItemStyleDone target:self action:@selector(setting)];
    
    self.i = 0;
    
    self.boardVC.delegate = self;
    
    [self.collectionView registerClass:[TYShowImageViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[TYAddViewCell class] forCellWithReuseIdentifier:@"identifier"];
    [self.view addSubview:self.collectionView];
}

#pragma mark ---------collectionView代理方法--------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.imageArray.count + 1 ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TYAddViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
    
    if (self.imageArray.count == 0) {
        return cell1;
        
    }else{
        
        TYShowImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        
        if (indexPath.item + 1 > self.imageArray.count ) {
            
            return cell1;
        }else{
            
            cell.imageV.image = self.imageArray[indexPath.item];
            [cell.imageV addSubview:cell.deleteButten];
            
            cell.deleteButten.tag = indexPath.item + 100;
            [cell.deleteButten addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item + 1 > self.imageArray.count ) {
        
        [self paletteVC];
    }else{
        TYImageViewController *imageViewC =[[TYImageViewController alloc] init];
        //取出存储的高清图片
        imageViewC.imageData = self.imageDataArray[indexPath.item];
        [self.navigationController presentViewController:imageViewC animated:YES completion:nil];
    }
}

// 删除图片
- (void)deleteImage:(UIButton *)sender {
    NSInteger index = sender.tag - 100;
    
    //移除显示图片数组imageArray中的数据
    [self.imageArray removeObjectAtIndex:index];
    //移除沙盒数组中imageDataArray的数据
    [self.imageDataArray removeObjectAtIndex:index];
    
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取Document文件的路径
    NSString *collectPath = filePath.lastObject;
    NSFileManager * fileManager = [NSFileManager defaultManager];
    //移除所有文件
    [fileManager removeItemAtPath:collectPath error:nil];
    //重新写入
    for (int i = 0; i < self.imageDataArray.count; i++) {
        NSData *imgData = self.imageDataArray[i];
        [self.boardVC WriteToBox:imgData];
    }
    
    [self.collectionView reloadData];
}

// 打开画板
- (void)paletteVC {

    [self.navigationController pushViewController:self.boardVC animated:YES];
}

// 打开设置界面
- (void)setting {
    TYSettingController *settingVC = [[TYSettingController alloc] initWithStyle:UITableViewStyleGrouped];
    
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark - 代理方法
- (void)imageDataArray:(NSMutableArray *)imageDataArray andImageArray:(NSMutableArray *)imageArray
{
    self.imageArray = imageArray;
    self.imageDataArray = imageDataArray;
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
