//
//  NOZLaboratoryService.h
//  SODA
//
//  Created by peng jun on 2017/12/5.
//Copyright © 2017年 YY.Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "NOZLaboratoryArchiveObject.h"

static NSString *klab_notify_name = @"klab_notify_name";

//显示实验室
static NSString *klab_notifytype_showlab = @"klab_notifytype_showlab";
//打开webview url
static NSString *klab_notifytype_openweburl = @"klab_notifytype_openweburl";

@class HBCellStruct;
@class HBBaseTableViewController;

@interface NOZLabCallBackObject:NSObject

+ (instancetype)notifyWithType:(NSString *)type from:(UIViewController *)from cs:(HBCellStruct *)cs param:(id)param;
+ (instancetype)notifyWithType:(NSString *)type;
@property (nonatomic, strong) NSString *notifyType;
@property (nonatomic, strong) id notifyParam;
@property (nonatomic, weak) UIViewController *notifyFrom;
@property (nonatomic, weak) HBCellStruct *notifycs;
@end


@protocol NOZLaboratoryDataSource

@required

- (BOOL)lab_shakeToShow;

- (NSDictionary<NSString *, NSString *> *)lab_userConfigDictionary;

@optional

- (NSMutableDictionary<NSString *, HBCellStruct *> *)lab_dictionary:(NSMutableDictionary<NSString *, HBCellStruct *> *)dic;


@end

@protocol NOZLaboratoryDelegate

@required

- (void)lab_configSelectedWithNotifyObject:(NOZLabCallBackObject *)notifyobj;

@end


@interface NOZLaboratoryService : NSObject

+ (instancetype)sharedInstance;

/**
 * 设置或取系统配置
 * 直接设置或读取就好，会自动监听属性保存
 */
@property (nonatomic, strong, readonly) SODALaboratoryEntity *e; 
@property (nonatomic, weak) NSObject<NOZLaboratoryDataSource> *dataSource;
@property (nonatomic, weak) NSObject<NOZLaboratoryDelegate> *delegate;
- (void)synchronize;

- (BOOL)boolValueForKey:(NSString *)key;  // BOOL二值数据保存读取方法,KEY为中文字符串的title
- (void)setBoolValue:(BOOL)value forKey:(NSString *)key;

@end

 
