//
//  BaseCollectionViewCell.h
//  PENG
//
//  Created by BOOB on 15/10/20.
//  Copyright © 2015年 YY.COM All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBBaseCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) NSIndexPath         * indexPath;
@property (nonatomic,assign) id                  delegate;
@property (nonatomic,weak  ) id                  object;
@property (nonatomic, assign) NSInteger          columncount;
@property (nonatomic,retain) NSMutableDictionary * dictionary;
-(void)setcelldictionary:(NSMutableDictionary *)dictionary;
//-(void)setcellimageRight:(BOOL)imageRight;
-(void)setcellpicturecolor:(NSString *)picturecolor;
-(void)setcellobject:(id)object;
-(void)setcellobject2:(id)object;
-(void)setcelldelegate:(id)delegate;
-(void)setcellPicture:(NSString *)profile;
-(void)setcellTitle:(NSString *)title;
-(void)setcellTitleColor:(NSString *)color;
-(void)setcelldetailtitle:(NSString *)detail;
-(void)setcellValue:(NSString *)value;

@end
