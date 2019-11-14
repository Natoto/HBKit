//
//  UIButton+HBKit.h
//  PENG
//
//  Created by HUANGBO on 15/6/8.
//  Copyright (c) 2015年 YY.COM All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, HBBaseUIButtonLayoutStyle) {
    HBBaseImageLeftTitleRightStyle = 0, //默认的方式 image左 title右
    HBBaseTitleLeftImageRightStyle = 1, // image右,title左
    HBBaseImageTopTitleBootomStyle = 2, //image上，title下
    HBBaseTitleTopImageBootomStyle = 3, // image下,title上
};

@interface UIButton(PENG)
-(void)cs_setTitle:(NSString *)title;
-(void)cs_setSelectedTitle:(NSString *)title;
-(void)cs_setTitleColor:(UIColor *)color;
-(void)cs_setTitleSelectedColor:(UIColor *)color;
-(void)cs_setFont:(UIFont *)font;
-(void)cs_setlayercolor:(UIColor *)color;
-(void)cs_setBackgroundImage:(UIColor *)backgroundColor;
-(void)cs_setSelectBackgroundImage:(UIColor *)backgroundColor;
-(void)cs_setDisableBackgroundImage:(UIColor *)backgroundColor;

+ (UIButton *)cs_CreateButtonWithFrame:(CGRect)frame;

+ (UIButton *)cs_CreateButtonWithFrame:(CGRect)frame
                           andImage:(UIImage *)image;

+ (UIButton *)cs_CreateButtonWithFrame:(CGRect)frame
                           andimage:(NSString *)imagename;

+ (UIButton *)cs_CreateButtonWithFrame:(CGRect)frame
                             andTxt:(NSString *)TXT;

+ (UIButton *)cs_CreateButtonWithFrame:(CGRect)frame
                             andTxt:(NSString *)TXT
                           txtcolor:(UIColor *)color;


+ (UIButton *)cs_CreateButtonWithFrame:(CGRect)frame
                             andTxt:(NSString *)TXT
                           andImage:(UIImage *)image;


+ (UIButton *)cs_CreateButtonWithFrame:(CGRect)frame
                           andimage:(NSString *)imagename
                        selectImage:(NSString *)selectimage;


+ (UIButton *)cs_CreateButtonWithFrame:(CGRect)frame
                             andTxt:(NSString *)TXT
                           txtcolor:(UIColor *)color
                                tag:(NSInteger)tag
                             target:(id)target
                             action:(SEL)action;


+ (UIButton *)cs_CreateButtonWithFrame:(CGRect)frame
                             andTxt:(NSString *)txt
                         andTxtSize:(NSInteger)txtsize
                           andImage:(UIImage *)image
                        andTXTColor:(UIColor *)txtcolor
                             target:(id)target
                           selector:(SEL)selector
                          superview:(UIView *)superview
                                tag:(NSInteger)tag;
//加下划线
-(void)cs_setUnderlineStyleSingle:(NSString *)text;


/**
 *	功能:设置UIButton的布局，图片和文字按照指定方向显示
 *
 *	@param aLayoutStyle:参见HBBaseUIButtonLayoutStyle
 *	@param aSpacing:图片和文字之间的间隔
 */
- (void)hbbase_setLayout:(HBBaseUIButtonLayoutStyle )aLayoutStyle
          spacing:(CGFloat)aSpacing;

@end
