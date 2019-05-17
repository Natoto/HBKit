//
//  NOZLabHelper.m
//  TestLab
//
//  Created by boob on 2019/5/16.
//  Copyright © 2019年 boob. All rights reserved.
//

#import "NOZLabHelper.h"
#import <HBLaboratory/HBLaboratory.h>

@interface NOZLabHelper()<NOZLaboratoryDataSource,NOZLaboratoryDelegate>

@end

@implementation NOZLabHelper

+ (void)load
{
    [NOZLabHelper sharedInstance];
}

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [NOZLaboratoryService sharedInstance].dataSource = self;
        [NOZLaboratoryService sharedInstance].delegate = self;
    }
    return self;
}


#pragma mark - datasource
- (NSDictionary<NSString *,NSString *> *)lab_userConfigDictionary
{
    
    return @{
             @"当前区域":@"中东",
             @"UID":@"12341242",
             @"HDID":@"666666",
             };
}
- (BOOL)lab_shakeToShow
{
    return YES;
}

- (void)showRootLab
{
    NozUserConfigViewController *ctr = [NozUserConfigViewController configWithPlistName:@"TesterRooterViewController" bundle:@""];
    ctr.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [[[[UIApplication sharedApplication] keyWindow] noz_currentViewController] presentViewController:ctr animated:YES completion:nil];
    
}

#pragma mark - delegate

- (void)lab_configSelectedWithNotifyObject:(NOZLabCallBackObject *)notifyobj
{
    NOZLabCallBackObject *labobj = notifyobj;
    HBCellStruct *cs = labobj.notifycs;
    NSLog(@"收到实验室通知 %@ type: %@ param: %@",cs.title,labobj.notifyType,labobj.notifyParam);
    if ([labobj.class isSubclassOfClass:NOZLabCallBackObject.class]) {
        NSString *obj = labobj.notifyType;
        if ([obj.class isSubclassOfClass:NSString.class]) {
            
            NSString *str = labobj.notifyType;
            if ([str isEqualToString:klab_notifytype_showlab]) {
                [self showRootLab];
            }
            return;
        }
        
        if ([obj.class isSubclassOfClass:NSDictionary.class]) {
            //            NSDictionary *dic = labobj.notifyParam;
            
        }
        
    }
}


#pragma mark -------------------------------------  以下添加业务代码

@end
