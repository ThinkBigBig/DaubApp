//
//  TYBoardController.m
//  涂鸦
//
//  Created by Leo on 16/8/26.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import "TYBoardController.h"
#import "TYColorSelect.h"
#import "TYDrawer.h"

#import "UIImage+FixOrientation.h"

#define SELF_WIDTH self.view.frame.size.width
#define SELF_HEIGHT self.view.frame.size.height
#define TOOLBAR_HEIGHT 40
#define TOOLBAR_WIDTH self.toolBar.frame.size.width

@interface TYBoardController ()<TYColorSelectDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

{
    
    UIBarButtonItem *_colorItem;
    UIBarButtonItem *_saveItem;
    UIBarButtonItem *_albumItem;
    UIBarButtonItem *_cameraItem;
    UIBarButtonItem *_deleteItem;
    UIBarButtonItem *_rubberItem;
    UIBarButtonItem *_undoItem;
    UIBarButtonItem *_redoItem;
    UIBarButtonItem *_paletteItem;
    
    UIColor *_paintColor;
}

@property (nonatomic, strong) TYColorSelect *colorSelect;
@property (nonatomic, strong) TYDrawer *drawer;
@property (nonatomic, strong) UIToolbar *toolBar;

@property (nonatomic, strong) UIActionSheet *deleteSheet;

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *imageDataArray;
@property (nonatomic, assign) NSInteger i;
@property (nonatomic, assign) BOOL isTouch;

@end

@implementation TYBoardController

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self.view addSubview:self.drawer];
        [self.view addSubview:self.toolBar];
        [self.view addSubview:self.colorSelect];
    }
    
    return self;
}

- (TYColorSelect *)colorSelect {
    if (!_colorSelect) {
        _colorSelect = [[TYColorSelect alloc] initWithFrame:CGRectMake(TOOLBAR_WIDTH - SELECT_WIDTH - 20, SELF_HEIGHT - TOOLBAR_HEIGHT - SELECT_HEIGHT - 10, SELECT_WIDTH, SELECT_HEIGHT)];
        _colorSelect.backgroundColor = [UIColor lightGrayColor];
        _colorSelect.delegate = self;
        _colorSelect.hidden = YES;
    }
    return _colorSelect;
}

- (TYDrawer *)drawer {
    if (!_drawer) {
        _drawer = [[TYDrawer alloc] initWithFrame:self.view.frame];
        _drawer.width = 3;
    }
    return _drawer;
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

- (UIToolbar *)toolBar {
    if (!_toolBar) {
        
        _toolBar = [[UIToolbar alloc] init];
        _toolBar.backgroundColor = [UIColor clearColor];
        _toolBar.frame = CGRectMake(0, SELF_HEIGHT - TOOLBAR_HEIGHT, SELF_WIDTH, TOOLBAR_HEIGHT);
        
        //保存
        _saveItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"save"] style:UIBarButtonItemStylePlain target:self action:@selector(save)];
        
        //相册
        _albumItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"album"] style:UIBarButtonItemStylePlain target:self action:@selector(album)];
        
        //照相机
        _cameraItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera"] style:UIBarButtonItemStylePlain target:self action:@selector(camera)];
        
        //全部删除
        _deleteItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"trash"] style:UIBarButtonItemStylePlain target:self action:@selector(delete)];
        
        //回撤
        _undoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reply"] style:UIBarButtonItemStylePlain target:self action:@selector(undo)];
        
        //恢复
        _redoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"forward"] style:UIBarButtonItemStylePlain target:self action:@selector(redo)];
        
        //调色板
        _paletteItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"palette"] style:UIBarButtonItemStylePlain target:self action:@selector(palette)];
        
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        
        _toolBar.items = @[_saveItem,space,_albumItem,space,_cameraItem,space,_deleteItem,space,_undoItem,space,_redoItem,space,_paletteItem];
    }
    return _toolBar;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.i = 0;
    
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideNavBar)];
    [self.drawer addGestureRecognizer:tap];
}

- (void)viewDidDisappear:(BOOL)animated {
    // 退出页面时清空页面内容
    [self.drawer clearScreen];
    self.drawer.layer.contents = nil;
}

#pragma mark - 隐藏NavBar和ToolBar
- (void)hideNavBar {
    self.isTouch = !self.isTouch;
    [super.navigationController setNavigationBarHidden:self.isTouch animated:YES];
    self.toolBar.hidden = self.isTouch;
}

#pragma mark - 保存
- (void)save {
    
    UIGraphicsBeginImageContext(_drawer.bounds.size);
    
    [_drawer.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(viewImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    // 图片缓存到本地
    dispatch_async(dispatch_get_main_queue(), ^{
        
    //压缩图片，这个压缩的图片就是做为你传入服务器的图片
    NSData *imageData = UIImagePNGRepresentation(viewImage);
    [self.imageDataArray addObject:imageData];
    [self WriteToBox:imageData];
        
    //添加到显示图片的数组中
    UIImage *image = [self OriginImage:viewImage scaleToSize:CGSizeMake(80, 80)];
    [self.imageArray addObject:image];

    });
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(imageDataArray:andImageArray:)]) {
        [self.delegate imageDataArray:self.imageDataArray andImageArray:self.imageArray];
    }
    
}
// 保存成功后调用

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"保存成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
}

#pragma mark - 打开相册和相机
- (void)album {
    
    UIImagePickerController *albumVC = [[UIImagePickerController alloc] init];
    
    albumVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    albumVC.delegate = self;
    
    [self presentViewController:albumVC animated:YES completion:nil];
}

- (void)camera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *cameraVC = [[UIImagePickerController alloc] init];
        cameraVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraVC.delegate = self;
        
        [self presentViewController:cameraVC animated:YES completion:nil];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"此设备未检测到照相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self.drawer clearScreen];
    
    UIImage *image = [[UIImage alloc] init];
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    image = [image fixOrientation]; // 纠正图片旋转90°的问题
    
    self.drawer.layer.contents = (__bridge id _Nullable)(image.CGImage);
    self.drawer.contentMode = UIViewContentModeScaleAspectFit;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 清屏
- (void)delete {
    
    self.deleteSheet = [[UIActionSheet alloc] initWithTitle:@"要删除当前绘画板么？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [self.deleteSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet == self.deleteSheet) {
        if (buttonIndex == 0) {
            // 先执行动画，然后执行删除操作
            [self changeUIView];
            [self.drawer clearScreen];
            self.drawer.layer.contents = nil;
        }
    }
}

/** 转场动画 */
-(void) changeUIView{
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.drawer cache:YES];
    [self.drawer exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
    [UIView commitAnimations];
}

//#pragma mark - 橡皮擦
//- (void)rubber {
//    self.drawer.lineColor = [UIColor whiteColor];
//}

#pragma mark - 撤销
- (void)undo {
    [self.drawer undo];
}

#pragma mark - 重做
- (void)redo {
    [self.drawer redo];
}

#pragma mark - 打开调色板
- (void)palette {
    _colorSelect.hidden = !_colorSelect.hidden;
}

#pragma mark - 隐藏系统状态栏
- (BOOL)prefersStatusBarHidden {
    return self.isTouch;
}

#pragma mark -----改变显示图片的尺寸----------
-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

#pragma mark --------存入沙盒------------
- (void)WriteToBox:(NSData *)imageData {
    
    _i ++;
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取Document文件的路径
    NSString *collectPath = filePath.lastObject;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:collectPath]) {
        
        [fileManager createDirectoryAtPath:collectPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    // 拼接新路径
    NSString *newPath = [collectPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Picture_%ld.png",(long)_i]];
    NSLog(@"++%@",newPath);
    [imageData writeToFile:newPath atomically:YES];
}

#pragma mark - 代理方法
- (void)selectView:(TYColorSelect *)selectView tipedColor:(UIColor *)color {
    self.drawer.lineColor = color;
    self.colorSelect.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
