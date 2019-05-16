//
//  HBBaseViewControllerDelegate.h
//  HBKit
//
//  Created by boob on 2018/9/21.
//

#ifndef HBBaseViewControllerDelegate_h
#define HBBaseViewControllerDelegate_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HBBaseViewController;
@class HBCellStruct;

@protocol HBBaseViewControllerDelegate

@property (nonatomic, strong) NSMutableDictionary * dataDictionary;

@optional
/** 
 * 需要重载，是否使用自定义NavgationBar,相对于系统自定义的 
 */
-(BOOL)useCustomNavBar;

/** 
 * 使用默认底色 
 */
-(void)userDefaultBackground;
/** 
 * 配置 cs
 */
-(void)configcellstructs;
/** 
 * 需要重载，重新配置View
 */
-(void)viewOtherConfig;
/** 
 * 需要重载，重新配置cs 
 */
-(void)otherConfigCellStruct:(HBCellStruct *)cs;


//设置自定义navigationbar
-(void)showhbnavigationbarBackItem:(BOOL)show;
/**
 * 监听点击事件
 */
-(void)observeTapgestureWithSuperView:(UIView *)superview target:(id)target sel:(SEL)seletor;

/** 
 * 返回上一级
 */
-(IBAction)backtoparent:(id)sender;

/** 
 * 返回上一级
 */
-(IBAction)backtoparent:(id)sender animate:(BOOL)animate;



/**
 *  从PLIST 文件中加载配置信息
 *
 *  @param plistname plist文件的名字
 */
-(void)loadplistConfig:(NSString *)plistname;

/**
 *  从PLIST 文件中加载配置信息放到一个字典中而不是直接对datadictionary赋值
 *
 *  @param plistname plist文件的名字
 */
-(NSMutableDictionary *)loadplistConfigToDictionary:(NSString *)plistname;


/**
 *  从json文件中配置信息
 *
 *  @param jsonfilename  json文件存放的路径名
 */
-(void)loadjsonfileConfig:(NSString *)jsonfilename;

/** 
 * 加载plist文件 
 */
-(void)loadplistConfig:(NSString *)plistname filepath:(NSString *)filepath;

/** 
 * 根据plist文件获取字典 
 */
-(NSMutableDictionary *)loadplistConfigToDictionary:(NSString *)plistname filepath:(NSString *)filepath;

/** 
 * 加载json文件 
 */
-(void)loadjsonfileConfig:(NSString *)jsonfilename filepath:(NSString *)filepath;


//改变背景颜色
-(void)changeBackGroundWithBackImage:(UIImage *)Image;
-(void)changeBackGroundWithBackImgName:(NSString *)imgname ofType:(NSString *)type;
-(void)changeBackGroundWithBackImgName:(NSString *)imgname;
-(void)changeFaceStyle:(int)style view:(UIView *)View;
-(void)changeBackGroundWithBackColor:(UIColor *)color;
@end
#endif /* HBBaseViewControllerDelegate_h */
