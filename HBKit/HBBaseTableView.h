//
//  BaseTableViewController.h
//  PetAirbnb
//
//  Created by nonato on 14-11-25.
//  Copyright (c) 2014年 YY.COM All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBBaseTableViewCell.h" 
#import "HBBaseViewControllerDelegate.h" 
#import "HBCellStruct.h"
#import "HBTableViewModel.h"
#import "UITableView+autoHeight.h"

@interface HBBaseTableView : UIView<UITableViewDataSource,UITableViewDelegate,HBBaseViewControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
//不自动配置tableview
@property (nonatomic, assign) BOOL                       noAutoConfigTableView;
//点击之后不自动变回未选状态
@property (nonatomic, assign) BOOL                       nodeselectRow;


- (NSMutableDictionary<NSString *,HBCellStruct *> *)dataDictionary;


- (void)viewDidCurrentView;

- (CGRect)adjustContentOffSet:(CGFloat)top bottom:(CGFloat)bottom;

- (CGRect)adjustContentOffLeft:(CGFloat)left right:(CGFloat)right;

- (void)observeTapgesture;

//配置tableview 一般情况下自动配置 配合 noautoconfigtableview 使用
- (void)configTableView;

/**
 * 配置顶部navigationbar 和 tableview的位置
 */
- (void)tableViewDefaultConfigWithTitle:(NSString *)title;

/**
 * 使用默认配置 供子类调用
 */
- (void)userDefaultConfigWithTitle:(NSString *)title;

/**
 * 根据keyindexpath 刷新该cell
 */
- (void)reloadTableViewCellWithKeyindexpath:(NSString *)keyindexpath;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end


