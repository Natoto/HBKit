//
//  cell_struct_kvo.h
//  PENG
//
//  Created by HUANGBO on 15/6/15.
//  Copyright (c) 2015年 YY.COM All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cell_struct.h"
#import "HBBaseTableViewController.h"

@class HBBaseTableViewController;

#define ADD_CELLSTRUCT_KVO(CELLSTRUCTARRAY) [self beginObservingValuesForKeyPaths:[self  cellstruct_observedKeyPaths] options:[self cellstruct_observationOptions] cellstructs:CELLSTRUCTARRAY];

#define REMOVE_CELLSTRUCT_KVO(CELLSTRUCTARRAY) [self endObservingValuesForKeysPaths:[self cellstruct_observedKeyPaths] cellstructs:CELLSTRUCTARRAY];

#define ON_CELLSTRUCT_HANDEL_KVO(KEYPATH) -(void)handle_cell_struct_datachange:(NSString *)KEYPATH

#define ON_CELLSTRUCT_HANDEL_KVO_CELLSTRUCT_KEYPATH(CELLSTRUCT,KEYPATH) -(void)handle_cell_struct_datachange:(cell_struct *)CELLSTRUCT  keypath:(NSString *)KEYPATH

#define AS_HBBASETABLEVIEWCTRKVO @interface HBBaseTableViewController(cell_struct_kvo)
AS_HBBASETABLEVIEWCTRKVO

- (NSSet *)cellstruct_observedKeyPaths;
- (NSKeyValueObservingOptions)cellstruct_observationOptions;

- (void) beginObservingValuesForKeyPaths:(id<NSFastEnumeration>)keyPaths options:(NSKeyValueObservingOptions)options cellstructs:(NSArray *)array;
- (void) endObservingValuesForKeysPaths:(id<NSFastEnumeration>)keyPaths cellstructs:(NSArray *)array;

/**
 * 可能执行多次
 */
- (void)handle_cell_struct_datachange:(NSString *) keyPath;
- (void)handle_cell_struct_datachange:(cell_struct *)cellstruct keypath:(NSString *) keyPath;
@end
