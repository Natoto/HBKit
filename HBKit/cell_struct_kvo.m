//
//  cell_struct_kvo.m
//  PENG
//
//  Created by HUANGBO on 15/6/15.
//  Copyright (c) 2015年 YY.COM All rights reserved.
//

#import "cell_struct_kvo.h"
#import "cell_struct.h"
#import <objc/runtime.h>

#define DEF_HBBASETABLEVIEWCTRKVO @implementation HBBaseTableViewController (cell_struct_kvo)
DEF_HBBASETABLEVIEWCTRKVO

static char cellstruct_OperationKey;

- (void)setObservedKeyPaths:(id)paths
{
    objc_setAssociatedObject(self, &cellstruct_OperationKey, paths, OBJC_ASSOCIATION_RETAIN);
}

- (id)getObservedKeyPaths
{
    return objc_getAssociatedObject(self, &cellstruct_OperationKey);
}

- (NSSet *)cellstruct_observedKeyPaths
{
    unsigned int outCount = 0;
    NSMutableArray *propertlist = [self getObservedKeyPaths];
    if (!propertlist) {
        propertlist = [NSMutableArray new];
        objc_property_t *properties = class_copyPropertyList([cell_struct class], &outCount);
        for (int i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            NSString *key = [[NSString alloc] initWithCString:property_getName(property)
                                                     encoding:NSUTF8StringEncoding];
            [propertlist addObject:key];
        }
        [self setObservedKeyPaths:propertlist];
    }
    return [NSSet setWithArray:propertlist];
}

- (NSKeyValueObservingOptions)cellstruct_observationOptions
{
    return (NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld);
}

- (void)beginObservingValuesForKeyPaths:(id<NSFastEnumeration>)keyPaths options:(NSKeyValueObservingOptions)options cellstructs:(NSArray *)array
{
    for (NSString *keyPath in keyPaths) {
        for (cell_struct *cellstruct in array) {
            [cellstruct addObserver:self forKeyPath:keyPath options:options context:(void *)self];
        }
    }
}

- (void)endObservingValuesForKeysPaths:(id<NSFastEnumeration>)keyPaths cellstructs:(NSArray *)array
{
    for (NSString *keyPath in keyPaths) {
        for (cell_struct *cellstruct in array) {
            [cellstruct removeObserver:self forKeyPath:keyPath context:(void *)self];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == (__bridge void *)self) {
        if ([[self cellstruct_observedKeyPaths] containsObject:keyPath]) {
            [self handle_cell_struct_datachange:keyPath];
            [self handle_cell_struct_datachange:(cell_struct *)object keypath:keyPath];
            //TODO:相应的变化
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)handle_cell_struct_datachange:(NSString *)keyPath
{
}

- (void)handle_cell_struct_datachange:(cell_struct *)cellstruct keypath:(NSString *)keyPath
{
}

@end
