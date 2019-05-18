//
//  NOZLaboratoryService.m
//  SODA
//
//  Created by peng jun on 2017/12/5.
//Copyright © 2017年 YY.Inc. All rights reserved.
//
#import "NOZLaboratoryService.h" 
#import <objc/runtime.h>
//#import "SODAAsyncSocket.h"

@implementation NOZLabCallBackObject

+ (instancetype)notifyWithType:(NSString *)type from:(UIViewController *)from cs:(HBCellStruct *)cs param:(id)param
{
    NOZLabCallBackObject *obj = [NOZLabCallBackObject new];
    obj.notifyType = type;
    obj.notifyFrom = from;
    obj.notifycs = cs;
    obj.notifyParam = param;
    return obj;
    
}
+ (instancetype)notifyWithType:(NSString *)type
{
    NOZLabCallBackObject *obj = [NOZLabCallBackObject new];
    obj.notifyType = type;
    return obj;
}

@end


@interface NOZLaboratoryService()

@property (nonatomic, strong) NSMutableArray * obsKeys;

//@property (nonatomic,strong) SODAAsyncSocket *ofDesignerServer;

@end

static NSString *key_soda_laboratory_extentDic = @"soda_laboratory_config_extentDic";
static NSString *key_soda_laboratory = @"soda_laboratory_config";

@implementation NOZLaboratoryService
@synthesize e = _e;
//@synthesize extentDic = _extentDic;

+ (instancetype)sharedInstance
{
    static NOZLaboratoryService *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [NOZLaboratoryService new];
    });
    return shared;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addEntityObserver];
    }
    return self;
}

- (void)dealloc
{
    [self removeEntityObserver];
    
}

- (void)removeEntityObserver
{
    
    [self.obsKeys enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @try {
            [self.e removeObserver:self forKeyPath:obj];
        } @catch (NSException *exception) {
        } @finally {
        }
        
    }];
    
}
- (void)addEntityObserver
{
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList([SODALaboratoryEntity class], &outCount);
    for (int i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
        NSString *key=[[NSString alloc] initWithCString:property_getName(property)
                                               encoding:NSUTF8StringEncoding];
        [self.obsKeys addObject:key];
    }
    free(properties);
    properties = NULL;
    [self.obsKeys enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.e addObserver:self forKeyPath:obj options:
         NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    }];
    
}

/* 2.只要object的keyPath属性发生变化，就会调用此回调方法，进行相应的处理：UI更新：*/
- (void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    
    NSLog(@"[%@] 更新数据 %@",NSStringFromClass([self class]),change[@"new"]);
    if (change[@"new"]) {
        [self synchronize];
    }
 }
 

- (void)synchronize
{
    NSData *archiveCarPriceData = [NSKeyedArchiver archivedDataWithRootObject:self.e];
    [[NSUserDefaults standardUserDefaults] setObject:archiveCarPriceData forKey:key_soda_laboratory];
    
//    [[NSUserDefaults standardUserDefaults] setObject:self.extentDic forKey:key_soda_laboratory_extentDic];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (SODALaboratoryEntity *)e
{
    if (!_e) {
        NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] dataForKey:key_soda_laboratory];
        id object = [NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
        if (object) {
            _e = [object mutableCopy];
        }
        else {
            _e = [[SODALaboratoryEntity alloc] init];
        }
    }
    return _e;
}

- (NSMutableArray *)obsKeys
{
    if (!_obsKeys) {
        _obsKeys = [[NSMutableArray alloc] init];
    }
    return _obsKeys;
}


- (BOOL)boolValueForKey:(NSString *)key
{
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

- (void)setBoolValue:(BOOL)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
}
@end 
