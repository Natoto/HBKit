//
//  BaseTableViewController.m
//  PetAirbnb
//
//  Created by nonato on 14-11-25.
//  Copyright (c) 2014年 YY.COM All rights reserved.
//
#import "HBCellStruct.h" 
#import "HBBaseTableViewController.h"
#import <objc/runtime.h>
#import "HBCellStruct_Common.h"
#import "HBTableViewModel.h"

@interface HBBaseTableViewController()

@end;

@implementation HBBaseTableViewController


- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _tableView = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.noAutoConfigTableView) {
        [self configTableView];
    }
}

- (void)configTableView
{
    [HBTableViewModel configTableView:self.tableView dataDictionary:self.dataDictionary];
}

/**
 * 使用默认配置 供子类调用
 */
- (void)tableViewDefaultConfigWithTitle:(NSString *)title
{
//TODO:默认设置标题等
}

/**
 * 使用默认配置 供子类调用
 */
- (void)userDefaultConfigWithTitle:(NSString *)title
{
    [self tableViewDefaultConfigWithTitle:title];
}

- (void)observeTapgesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTap:)];
    [self.tableView addGestureRecognizer:tap];
}

- (void)tableViewTap:(UIGestureRecognizer *)gesture
{
     [[NSNotificationCenter defaultCenter] postNotificationName:notify_basetableview_tap object:gesture];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tag = TAG_TABLEVIEW;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (void)viewDidCurrentView
{
    
}


- (void)reloadTableViewCellWithKeyindexpath:(NSString *)keyindexpath
{
    if (!keyindexpath || ![keyindexpath containsString:@"section"]) {
        return;
    }
    NSString *sectionstr = KEY_INDEXPATH_SECTION_STR(keyindexpath);
    NSString *rowstr = KEY_INDEXPATH_ROW_STR(keyindexpath);
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:rowstr.intValue inSection:sectionstr.intValue]] withRowAnimation:UITableViewRowAnimationAutomatic];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 响应cell选择
- (void)cellDidSelect:(id)sender
{
    NSLog(@"%@",sender);
 
}

- (CGRect)adjustContentOffSet:(CGFloat)top bottom:(CGFloat)bottom
{
    self.tableView.frame = CGRectMake(0, top, [UIScreen mainScreen].bounds.size.width ,[UIScreen mainScreen].bounds.size.height - top - bottom);
    return self.tableView.frame;
}

- (CGRect)adjustContentOffLeft:(CGFloat)left right:(CGFloat)right
{
    self.tableView.frame = CGRectMake(left, self.tableView.frame.origin.y, [UIScreen mainScreen].bounds.size.width - right - right ,self.tableView.frame.size.height);
    return self.tableView.frame;
}
#pragma mark - Table view data source
 
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CELL_STRUCT *cell_struce = [self.dataDictionary cellstructobjectForKey:KEY_INDEXPATH(section, 0)];
    return cell_struce.sectionheight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CELL_STRUCT *cell_struce = [self.dataDictionary cellstructobjectForKey:KEY_INDEXPATH(section, 0)];
    return cell_struce.sectionfooterheight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [HBTableViewModel tableView:tableView dataDictionary:self.dataDictionary viewForHeaderInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [HBTableViewModel tableView:tableView dataDictionary:self.dataDictionary viewForFooterInSection:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [HBTableViewModel numberOfSectionsInTableView:tableView dataDictionary:self.dataDictionary];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [HBTableViewModel tableView:tableView dataDictionary:self.dataDictionary numberOfRowsInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HBBaseTableViewCell *cell;
    cell = [HBTableViewModel tableview:self.tableView dataDictionary:self.dataDictionary cellWithIndexPath:indexPath];
    if ([[cell class] isSubclassOfClass:[HBBaseTableViewCell class]]) {
        [HBTableViewModel drawCell:cell delegate:self dataDictionary:self.dataDictionary withIndexPath:indexPath];
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.nodeselectRow) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    [HBTableViewModel tableView:tableView dataDictionary:self.dataDictionary didSelectRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CELL_STRUCT *cellstruct = [self.dataDictionary  cellstructobjectForKey:KEY_INDEXPATH(indexPath.section, indexPath.row)];
    return cellstruct.cellheight;
}

@end

 
