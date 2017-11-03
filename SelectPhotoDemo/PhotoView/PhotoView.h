//
//  PhotoView.h
//  MyCampus
//
//  Created by zhangming on 2017/11/3.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^photoBlock)(NSArray *photoArr);

@interface PhotoView : UIView

@property (strong , nonatomic) photoBlock photoBlock;

- (void)returnText:(photoBlock)block;

@end
