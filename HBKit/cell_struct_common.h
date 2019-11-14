//
//  CommonView.h
//  JXL
//
//  Created by HUANGBO on 15-5-1.
//  Copyright (c) 2015年 YY.COM All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cell_struct.h"

@class HBCellStruct;
@class cell_struct;
 
#undef AS_cell_struct_COMMON
#define AS_cell_struct_COMMON(OBJ) @property(nonatomic,retain) cell_struct * cell_struct_##OBJ;

#undef GET_cell_struct_WITH
#define GET_cell_struct_WITH(OBJ,TITLE) -(cell_struct *)cell_struct_##OBJ\
{\
if (!_cell_struct_##OBJ) {\
_cell_struct_##OBJ = [cell_struct cell_x_x_struct:@#TITLE detailvalue:nil target:self selectAction:@selector(selectAction:)];\
}\
return _cell_struct_##OBJ;\
}


#undef DEFAULT_CELL_SELECT_ACTION
#define DEFAULT_CELL_SELECT_ACTION @selector(selectAction:)

#undef GET_CELL_SELECT_ACTION
#define GET_CELL_SELECT_ACTION(SENDER) -(IBAction)selectAction:(cell_struct *)SENDER

@interface cell_struct_common : HBCellStruct
@end

@interface HBCellStruct(Common)


+ (HBCellStruct *)cell_x_x_struct:(NSString *)title
                    detailvalue:(NSString *)detailvalue
                         target:(id)target
                   selectAction:(SEL)selectAction;

#define  CREATECELLXXXXSTRUCTLONG + (HBCellStruct *)cell_x_x_struct:(NSString *)title \
                    detailvalue:(NSString *)detailvalue\
                   footerheight:(CGFloat)footerheight\
                 selectionStyle:(BOOL)selectionStyle\
                      accessory:(BOOL)accessory\
                     cellheight:(CGFloat)cellheight\
                     imageRight:(BOOL)imageRight\
              imageCornerRadius:(BOOL)imageCornerRadius\
                        picture:(NSString *)picture\
                         target:(id)target\
                   selectAction:(SEL)selectAction\
                     background:(UIColor *)backgroundcolor\
                     titlecolor:(NSString *)titlecolor\
                  sectionheight:(CGFloat)sectionheight;

CREATECELLXXXXSTRUCTLONG

+ (HBCellStruct *)cell_x_x_structWithDictionary:(NSDictionary *)dictionary;

+ (UIColor *)cell_colorWithStructKey:(NSString *)key;

@end

@interface NSDictionary(cellstruct)
- (HBCellStruct *)cell_cellstructobjectForKey:(id)aKey;
@end

@interface NSObject(KEYINDEXPATH)
- (NSString *)key_indexpath:(NSInteger)section row:(NSInteger)row;
- (NSString *)key_section:(NSInteger)section;
- (NSString *)key_section_mark:(NSInteger)section;
//-(NSString *)key_section_index_str:(NSString *)indexpathkey;
- (NSString *)key_indexpath_section_str:(NSString *)indexpathkey;
- (NSString *)key_indexpath_row_str:(NSString *)indexpathkey;
@end
