//
//  HBBaseViewModel.h
//  HBKit
//
//  Created by boob on 2018/9/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HBBaseTableViewCell;


//注册cell
#define TABLEVIEW_REGISTERXIBCELL_CLASS(TABLEVIEW,CELLCLSSTR) {[TABLEVIEW registerClass:NSClassFromString(CELLCLSSTR) forCellReuseIdentifier:CELLCLSSTR];\
[TABLEVIEW registerNib:[UINib nibWithNibName:CELLCLSSTR bundle:nil] forCellReuseIdentifier:CELLCLSSTR];}

#undef TABLEVIEW_REGISTER_CELLCLASS
#define TABLEVIEW_REGISTER_CELLCLASS(TABLEVIEW,CELLCLSSTR) {[TABLEVIEW registerClass:NSClassFromString(CELLCLSSTR) forCellReuseIdentifier:CELLCLSSTR];}

#undef TABLEVIEW_CELL_SEPARATOR_NONE
#define TABLEVIEW_CELL_SEPARATOR_NONE self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

@interface HBTableViewModel : NSObject

+ (void)configTableView:(UITableView *)tableView dataDictionary:(NSDictionary *)dataDictionary;

+ (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView dataDictionary:(NSDictionary *)dataDictionary;

+ (NSInteger)tableView:(UITableView *)tableView  dataDictionary:(NSDictionary *)dataDictionary numberOfRowsInSection:(NSInteger)section;

+ (void)tableView:(UITableView *)tableView  dataDictionary:(NSDictionary *)dataDictionary didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

+ (UIView *)tableView:(UITableView *)tableView dataDictionary:(NSDictionary *)dataDictionary viewForFooterInSection:(NSInteger)section;


+ (UIView *)tableView:(UITableView *)tableView dataDictionary:(NSDictionary *)dataDictionary viewForHeaderInSection:(NSInteger)section;
 
+ (void)drawCell:(HBBaseTableViewCell *)cell delegate:(id)delegate dataDictionary:(NSDictionary *)dataDictionary withIndexPath:(NSIndexPath *)indexPath;

+ (HBBaseTableViewCell *)tableview:(UITableView *)tableView
                   dataDictionary:(NSDictionary *)dataDictionary
                cellWithIndexPath:(NSIndexPath *)indexPath;

@end
