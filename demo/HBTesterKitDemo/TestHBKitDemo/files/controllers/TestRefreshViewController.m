//
//  TestRefreshViewController.m
//  demo
//
//  Created by HUANGBO on 15/8/11.
//  Copyright (c) 2015年 YY.COM All rights reserved.
//
#import "HBTesterKit.h"
#import "TestRefreshViewController.h"
#import "cell_struct_common.h"

//上下拉需要解开
//#define USERMJREFRESH 1 //0不用到MJRefresh 1 用到了MJRefresh
@interface TestRefreshViewController ()

@end

@implementation TestRefreshViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.noHeaderFreshView = NO;
    self.noFooterView = NO;
    [self refreshView];
}

- (void)refreshView
{
    [self.dataDictionary removeAllObjects];
    for (int index = 0; index < 10; index ++) {
        NSString *string = [NSString stringWithFormat:@"cell %d",index];
        cell_struct *cellstruct = [self createcellstruct:string];
        [self.dataDictionary setObject:cellstruct forKey:KEY_INDEXPATH(0, index)];
    }
    [self performSelector:@selector(FinishedLoadData) withObject:nil afterDelay:2];
    [self.tableView reloadData];
}

- (void)getNextPageView
{
    const int startIndex = (int)self.dataDictionary.count-1;
    for (int index = startIndex  ; index < startIndex + 10; index ++) {
        NSString *string = [NSString stringWithFormat:@"cell %d",index];
        cell_struct *cellstruct = [self createcellstruct:string];
        [self.dataDictionary setObject:cellstruct forKey:KEY_INDEXPATH(0, index)];
    }
    [self performSelector:@selector(FinishedLoadData) withObject:nil afterDelay:2];
    [self.tableView reloadData];
}
- (IBAction)selectAction:(HBCellStruct *)cellstruct
{
    
}

- (void)FinishedLoadData
{
    
}
- (cell_struct *)createcellstruct:(NSString *)title
{
    cell_struct *cellstruct = [cell_struct_common cell_x_x_struct:title detailvalue:nil target:self selectAction:DEFAULT_CELL_SELECT_ACTION];
    return cellstruct;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
