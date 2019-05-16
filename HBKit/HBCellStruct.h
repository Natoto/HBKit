//
//  HBCellStruct.h
//  JXL
//
//  Created by BooB on 15-4-15.
//  Copyright (c) 2015年 BooB. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "HBCellStruct_KEY.h"
#import "NSObject+HBObjectMap.h"

@class HBCellStruct;
@compatibility_alias CELL_STRUCT HBCellStruct;

@interface HBCellStruct : NSObject<NSCopying>

@property (nonatomic, assign) BOOL       showTopLine;        //显示顶部分割线
@property (nonatomic, assign) BOOL       showBottomLine;     //显示底部分割线
@property (nonatomic, assign) BOOL       accessory;          //是否显示右边小箭头
@property (nonatomic, assign) BOOL       selectionStyle;     //是否显示按下效果
@property (nonatomic, assign) BOOL       imageCornerRadius;
@property (nonatomic, assign) int        cellStyleValue;     //修改cell默认的样式 0 1 2
@property (nonatomic, assign) int        titleLabelNumberOfLines;//title的换行
@property (nonatomic, assign) NSInteger  columncount;        //collectionview 一行几个 只在row0生效
@property (nonatomic, assign) CGFloat    cellheight;         //cell的高度
@property (nonatomic, assign) CGFloat    sectionfont;        //section header的字体 只在row为0的时候生效
@property (nonatomic, assign) CGFloat    sectionheight;      //section header的高度 只在row为0的时候生效
@property (nonatomic, assign) CGFloat    sectionfooterheight; //section footer的高度
@property (nonatomic, assign) CGFloat    sectionfooterfont;   //section footer的字体大小
@property (nonatomic, assign) BOOL       isXib;              //是否为xib
@property (nonatomic, retain) NSString *title;              //文字标题
@property (nonatomic, retain) NSNumber *titlefontsize;      //字体
@property (nonatomic, retain) NSString *detailtitle;
@property (nonatomic, retain) NSString *picture;            //图片
@property (nonatomic, retain) NSString *cellclass;          //这个cell/view的类名
@property (nonatomic, retain) NSString *sel_selector_str;
@property (nonatomic, retain) NSString *sectiontitle;
@property (nonatomic, retain) NSString *sectionfooter;
@property (nonatomic, retain) NSString *sectioncolor;      //header文字颜色 类似 0x134124,0.5  用分号隔开透明度，也可以不加
@property (nonatomic, retain) NSString *sectionbgcolor;    //section header背景颜色
@property (nonatomic, retain) NSString *sectionfootercolor; //footer文字颜色 类似 0x134124,0.5  用分号隔开透明度，也可以不加
@property (nonatomic, retain) NSString *placeHolder;
@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) NSString *subvalue2;
@property (nonatomic, retain) NSString *titlecolor;    //title 颜色   类似 0x134124,0.5  用分号隔开透明度，也可以不加
@property (nonatomic, retain) NSString *key_indexpath; 

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray *uploadobjcts;
@property (nonatomic, strong) NSMutableDictionary *dictionary;

//------------ 注意：以下变量不可放入plist中赋值
@property (nonatomic, retain) UIFont *titleFont;
@property (nonatomic, assign) SEL    sel_selector;
@property (nonatomic, assign) id     delegate;
@property (nonatomic, retain) id     object;
@property (nonatomic, retain) id     object2;
@property (nonatomic, assign) id     sectionHeaderView;
@property (nonatomic, retain) NSAttributedString *attributeTitle;

- (id)initWithtitle:(NSString *)title cellclass:(NSString *)cellclass placeholder:(NSString *)placehoder accessory:(BOOL)accessory sel_selctor:(SEL)selector delegate:(id)delegate;

/**
 * 已废弃
 */
- (id)initWithDictionary:(NSDictionary *)dictionary;


/**
 *  根据plist的键值对字典得到CELLSTRUCT对象
 */
- (id)initWithPlistDictionary:(NSDictionary *)plistdic;

/**
 *  把json转换成对象
 *
 *
 *  @return CELLSTRUCT
 */
- (id)initWithJsonString:(NSString *)jsonstring;
+ (instancetype)initWithTitle:(NSString *)title;
@end


@interface CELL_STRUCT_ARRAY : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *backgroundcolor;
@property (nonatomic, strong) NSString *backgroundimage;

@property (nonatomic, strong) NSMutableArray<HBCellStruct *> *array;
@end
