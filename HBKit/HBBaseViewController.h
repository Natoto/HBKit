//
//  BaseViewController.h
//  JXL
//
//  Created by BOOB on 15/4/14.
//  Copyright (c) 2015年 YY.COM All rights reserved.
//
 
#import <UIKit/UIKit.h>
#import "HBCellStruct.h"
#import "HBKitDataModel.h"
#import "HBBaseViewControllerDelegate.h"
#define ALPHA_NAVIGATIONBAR 0.7

@class HBCellStruct;

@interface BackGroundView : UIImageView

@end


@interface HBBaseViewController : UIViewController<HBBaseViewControllerDelegate> {
    BOOL statusbarhidden;
} 
@property(nonatomic, strong) NSMutableDictionary *dataDictionary;

@property(nonatomic, assign) BOOL useStatusBar;  //本界面配置statusbar 本界面消失后回归正常

@property(nonatomic, assign) BOOL showBackItem;

@property(nonatomic, strong) BackGroundView *backgroundview;

@property(nonatomic, assign) BOOL statusBarStyleDefault;

////是否需要用到MJRefresh
////上下拉要用到的
@property (nonatomic, assign) BOOL                       noFooterView;
@property (nonatomic, assign) BOOL                       noHeaderFreshView;

@end


