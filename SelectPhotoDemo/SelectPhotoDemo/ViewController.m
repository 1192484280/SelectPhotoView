//
//  ViewController.m
//  SelectPhotoDemo
//
//  Created by zhangming on 2017/11/3.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import "ViewController.h"
#import "PhotoView.h"

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define PHOTOVIEWHEIGHT 120
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PhotoView *view = [[PhotoView alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, PHOTOVIEWHEIGHT)];
    [self.view addSubview:view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
