//
//  PhotoView.m
//  MyCampus
//
//  Created by zhangming on 2017/11/3.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "PhotoView.h"

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define PHOTOVIEWHEIGHT 120

@interface PhotoView ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerControllerSourceType sourceType;
}
@property (strong, nonatomic) UIScrollView *sView;
@property (weak, nonatomic) UIButton *currentBtn;
@property (strong, nonatomic) UIButton *firstBtn;
@property (strong, nonatomic) NSMutableArray *photoArr;
@end

@implementation PhotoView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setUI];
    }
    
    return self;
}

- (NSMutableArray *)photoArr{
    
    if (!_photoArr) {
        
        _photoArr = [NSMutableArray array];
        
        [_photoArr addObject:[UIImage imageNamed:@"image_add"]];
    }
    
    return _photoArr;
}


- (UIScrollView *)sView{
    
    if (!_sView) {
        
        _sView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _sView.showsHorizontalScrollIndicator = NO;
        _sView.contentSize = CGSizeMake(ScreenWidth * 2, 0);
        [_sView addSubview:self.firstBtn];
    }
    
    return _sView;
}

- (UIButton *)firstBtn{
    
    if (!_firstBtn) {
        
        _firstBtn = [[UIButton alloc] initWithFrame:CGRectMake(16, 10, (PHOTOVIEWHEIGHT - 20), (PHOTOVIEWHEIGHT - 20))];
        [_firstBtn setImage:[UIImage imageNamed:@"image_add"] forState:UIControlStateNormal];
        self.currentBtn = _firstBtn;
        [_firstBtn addTarget:self action:@selector(onPhotoBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _firstBtn;
}

- (void)setUI{
    
    [self addSubview:self.sView];
    
}

- (void)onPhotoBtn:(UIButton *)btn{
    
    NSData *data1 = UIImageJPEGRepresentation(self.photoArr.lastObject, 1);
    NSData *data2 = UIImageJPEGRepresentation(btn.currentImage, 1);
    if (![data1 isEqual:data2]) {

        return;
    }
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        
        picker.delegate = self;
        
        picker.sourceType=sourceType;
        
        [[self getCurrentVC] presentViewController:picker animated:YES completion:nil];
        
    }else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            sourceType = UIImagePickerControllerSourceTypeCamera;
            UIImagePickerController * picker = [[UIImagePickerController alloc]init];
            
            picker.delegate = self;
            
            picker.sourceType=sourceType;
            
            [[self getCurrentVC] presentViewController:picker animated:YES completion:nil];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            UIImagePickerController * picker = [[UIImagePickerController alloc]init];
            
            picker.delegate = self;
            
            picker.sourceType=sourceType;
            
            [[self getCurrentVC] presentViewController:picker animated:YES completion:nil];
        }]];
        [[self getCurrentVC] presentViewController:alert animated:YES completion:^{
            
        }];
    }
    
}

#pragma mark - 相册选择完成
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        
        UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
        
        [self.photoArr insertObject:image atIndex:self.photoArr.count - 1];
        
        if (self.photoBlock !=nil) {
            
            self.photoBlock(self.photoArr);
        }
        
        [self refreshUI];
        
    }];
    
}

- (void)refreshUI{
    
    for (UIView *btn in self.sView.subviews) {
        
        [btn removeFromSuperview];
    }
    
    for (int i = 0; i < self.photoArr.count; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(((PHOTOVIEWHEIGHT - 20) + 16) * i + 16 , 8, (PHOTOVIEWHEIGHT - 20), (PHOTOVIEWHEIGHT - 20))];
        [btn setImage:self.photoArr[i] forState:UIControlStateNormal];
        [self.sView addSubview:btn];
        [btn addTarget:self action:@selector(onPhotoBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == self.photoArr.count - 1) {
            
            self.currentBtn = btn;
        }else{
            
            UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame) - 15, 8 - 5, 20, 20)];
            [deleteBtn setImage:[UIImage imageNamed:@"image_close"] forState:UIControlStateNormal];
            deleteBtn.tag = i + 100;
            [deleteBtn addTarget:self action:@selector(onDeletebtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.sView addSubview:deleteBtn];
        }
        
        
        
    }
    self.sView.contentSize = CGSizeMake(((PHOTOVIEWHEIGHT - 20) + 20) * self.photoArr.count, 0);
   // self.sView.constant = (100 + 20) * self.photoArr.count;
    
}
- (void)onDeletebtn:(UIButton *)btn{
    
    
    [self.photoArr removeObject:self.photoArr[btn.tag - 100]];
    
    if (self.photoBlock !=nil) {
        
        self.photoBlock(self.photoArr);
    }
    
    [self refreshUI];
    
    
}


//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        
        // 根视图为非导航类
        currentVC = rootVC;
    }
    
    return currentVC;
}


- (void)returnText:(photoBlock)block{
    
    self.photoBlock = block;
}

@end
