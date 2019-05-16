//
//  CommonView.h
//  JXL
//
//  Created by HUANGBO on 15-5-1.
//  Copyright (c) 2015年 YY.COM All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBCellStruct.h"

@class HBCellStruct;
@class CELL_STRUCT;

#undef AS_CELL_STRUCT_COMMON
#define AS_CELL_STRUCT_COMMON(OBJ) @property(nonatomic,retain) CELL_STRUCT * cell_struct_##OBJ;



#undef DEF_CELL_STRUCT_WITH

#define DEF_CELL_STRUCT_WITH(OBJ,TITLESTR) -(HBCellStruct *)cell_struct_##OBJ\
{\
    if (!_cell_struct_##OBJ) {\
        _cell_struct_##OBJ = [HBCellStruct cell_x_x_struct:TITLESTR detailvalue:nil target:self selectAction:@selector(selectAction:)];\
        [self otherConfigCellStruct:_cell_struct_##OBJ];\
    }\
    return _cell_struct_##OBJ;\
}



#undef DEFAULT_CELL_SELECT_ACTION
#define DEFAULT_CELL_SELECT_ACTION @selector(selectAction:)

#undef GET_CELL_SELECT_ACTION
#define GET_CELL_SELECT_ACTION(SENDER) -(IBAction)selectAction:(CELL_STRUCT *)SENDER

/** 
 * 颜色配置 0x1aaa,0.24 
 */
#define CELL_STRUCTS_COLOR(HEXCLR,ALPHA) [NSString stringWithFormat:@"%@,%.2f",@#HEXCLR,ALPHA]

@compatibility_alias CELL_STRUCT_Common HBCellStruct_Common;

@interface CELL_STRUCT_Common : HBCellStruct
@end

@interface HBCellStruct(Common)


+ (HBCellStruct *)cell_x_x_struct:(NSString *)title
                    detailvalue:(NSString *)detailvalue
                         target:(id)target
                   selectAction:(SEL)selectAction;

+ (HBCellStruct *)cell_x_x_struct:(NSString *)title
                    detailvalue:(NSString *)detailvalue
                   footerheight:(CGFloat)footerheight
                 selectionStyle:(BOOL)selectionStyle
                      accessory:(BOOL)accessory
                     cellheight:(CGFloat)cellheight
                     imageRight:(BOOL)imageRight
              imageCornerRadius:(BOOL)imageCornerRadius
                        picture:(NSString *)picture
                         target:(id)target
                   selectAction:(SEL)selectAction
                     background:(UIColor *)backgroundcolor
                     titlecolor:(NSString *)titlecolor
                  sectionheight:(CGFloat)sectionheight;


+ (HBCellStruct *)cell_x_x_structWithDictionary:(NSDictionary *)dictionary;

+ (UIColor *)colorWithStructKey:(NSString *)key;

@end

@interface NSDictionary(cellstruct)

- (HBCellStruct *)cellstructobjectForKey:(id)aKey;

- (HBCellStruct *)cellstructobjectForIndexPath:(NSIndexPath *)indexpath;

@end

@interface NSObject(KEYINDEXPATH)
- (NSString *)key_indexpath:(NSInteger)section row:(NSInteger)row;
- (NSString *)key_section:(NSInteger)section;
- (NSString *)key_section_mark:(NSInteger)section;
- (NSString *)key_indexpath_section_str:(NSString *)indexpathkey;
- (NSString *)key_indexpath_row_str:(NSString *)indexpathkey;

- (NSIndexPath *)key_indexPath_withStr:(NSString *)indexpathstr;

@end
