//
//  HBBaseViewModel.m
//  HBKit
//
//  Created by boob on 2018/9/21.
//

#import "HBTableViewModel.h"
#import "HBCellStruct.h"
#import "HBBaseTableViewCell.h"
#import "HBCellStruct_Common.h"

@implementation HBTableViewModel


//注册
+ (void)configTableView:(UITableView *)tableView dataDictionary:(NSDictionary *)dataDictionary
{
    if (tableView) {
        [[self class] setExtraCellLineHidden:tableView];
        //注册CELL 目前只考虑到两种情况 2个 section不同的时候 注册 其他的自己添加
        CELL_STRUCT *cell0struct= [dataDictionary cellstructobjectForKey:KEY_INDEXPATH(0, 0)];
        if (cell0struct.isXib) {
            TABLEVIEW_REGISTERXIBCELL_CLASS(tableView, cell0struct.cellclass)
        } else {
            TABLEVIEW_REGISTER_CELLCLASS(tableView, cell0struct.cellclass);
        }
        CELL_STRUCT *cellstruct1 = [dataDictionary cellstructobjectForKey:KEY_INDEXPATH(1, 0)];
        if (cellstruct1) {
            if (cellstruct1.isXib) {
                TABLEVIEW_REGISTERXIBCELL_CLASS(tableView, cellstruct1.cellclass)
            } else {
                TABLEVIEW_REGISTER_CELLCLASS(tableView, cellstruct1.cellclass);
            }
        }
    }
}

+ (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}



+ (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView dataDictionary:(NSDictionary *)dataDictionary
{
    NSArray *keys = dataDictionary.allKeys;
    NSInteger maxsection = 1;
    for (int index = 0; index < keys.count; index ++) {
        NSString *key =[keys objectAtIndex:index];
        
        NSString *sectionstr = KEY_SECTION_INDEX_STR(key);
        if ((sectionstr.integerValue +1) > maxsection) {
            maxsection = (sectionstr.integerValue + 1);
        }
    }
    return maxsection;
}

+ (NSInteger)tableView:(UITableView *)tableView  dataDictionary:(NSDictionary *)dataDictionary numberOfRowsInSection:(NSInteger)section
{
    NSArray *keys = dataDictionary.allKeys;
    NSString *sectionx = KEY_SECTION_MARK(section);
    
    NSInteger sectioncount = 0;
    for (int index = 0; index < keys.count; index ++) {
        NSString *key =[keys objectAtIndex:index];
        if ([key rangeOfString:sectionx].location != NSNotFound) {
            sectioncount ++;
        }
    }
    return sectioncount;
}


+ (void)tableView:(UITableView *)tableView  dataDictionary:(NSDictionary *)dataDictionary didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CELL_STRUCT *cellstruct = [dataDictionary  cellstructobjectForKey:KEY_INDEXPATH(indexPath.section, indexPath.row)];
    if (cellstruct.sel_selector && [cellstruct.delegate respondsToSelector:cellstruct.sel_selector]) {
        [cellstruct.delegate performSelector:cellstruct.sel_selector withObject:cellstruct afterDelay:0];
    }
    else {
        NSString *sel_selector = cellstruct.sel_selector_str;
        SEL selector = NSSelectorFromString(sel_selector);
        if (sel_selector  && [cellstruct.delegate respondsToSelector:selector]) {
            [cellstruct.delegate performSelector:selector withObject:cellstruct afterDelay:0];
        }
    }
}


+ (UIView *)tableView:(UITableView *)tableView dataDictionary:(NSDictionary *)dataDictionary viewForHeaderInSection:(NSInteger)section
{
    CELL_STRUCT *cell_struce = [dataDictionary cellstructobjectForKey:KEY_INDEXPATH(section, 0)];
    if (cell_struce.sectionheight>0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, cell_struce.sectionheight)];
        view.userInteractionEnabled = NO;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, view.bounds.size.width - 20, cell_struce.sectionheight)];
        label.center = CGPointMake(view.frame.origin.x + view.frame.size.width/2, view.frame.origin.y + view.frame.size.height/2);
        label.text = cell_struce.sectiontitle;
        CGFloat sectionfont = (cell_struce.sectionfont > 0)?cell_struce.sectionfont:12;
        label.font = [UIFont systemFontOfSize:sectionfont];
        label.textColor = [CELL_STRUCT_Common colorWithStructKey:cell_struce.sectioncolor];
        label.textAlignment = NSTextAlignmentLeft;
        UIColor *bgcolor =  [CELL_STRUCT_Common colorWithStructKey:cell_struce.sectionbgcolor];
        view.backgroundColor = bgcolor?bgcolor:tableView.backgroundColor;
        [view addSubview:label];
        return view;
    } else {
        UIView *view = [UIView new];
        view.userInteractionEnabled = NO;
        return view;
    }
}

+ (UIView *)tableView:(UITableView *)tableView dataDictionary:(NSDictionary *)dataDictionary viewForFooterInSection:(NSInteger)section
{
    CELL_STRUCT *cell_struce = [dataDictionary cellstructobjectForKey:KEY_INDEXPATH(section, 0)];
    if (cell_struce.sectionfooterheight>0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, cell_struce.sectionfooterheight)];
        view.userInteractionEnabled = NO;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, view.bounds.size.width - 20, cell_struce.sectionfooterheight)];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.center = CGPointMake(view.frame.origin.x + view.frame.size.width/2, view.frame.origin.y + view.frame.size.height/2);
        label.text = cell_struce.sectionfooter;
        CGFloat sectionfont = (cell_struce.sectionfooterfont >0)?cell_struce.sectionfooterfont:12;
        label.font = [UIFont systemFontOfSize:sectionfont];
        label.textColor = [CELL_STRUCT_Common colorWithStructKey:cell_struce.sectionfootercolor];
        label.textAlignment = NSTextAlignmentLeft;
        UIColor *bgcolor =  [CELL_STRUCT_Common colorWithStructKey:cell_struce.sectionfootercolor];
        view.backgroundColor = bgcolor?bgcolor:tableView.backgroundColor;
        [view addSubview:label];
        return view;
    } else {
        UIView *view = [UIView new];
        view.userInteractionEnabled = NO;
        return view;
    }
}

+ (HBBaseTableViewCell *)tableview:(UITableView *)tableView
                   dataDictionary:(NSDictionary *)dataDictionary
             cellWithIndexPath:(NSIndexPath *)indexPath
{
    
    CELL_STRUCT *cellstruct = [dataDictionary cellstructobjectForKey:KEY_INDEXPATH(indexPath.section, indexPath.row)];
    NSString *identifier01 = cellstruct.cellclass;
    HBBaseTableViewCell *cell ;
    if (cellstruct.isXib) {
        cell =  [tableView dequeueReusableCellWithIdentifier:identifier01 forIndexPath:indexPath ];
    }

    if (!cell) {
        NSString *Classname = [NSString stringWithFormat:@"%@",cellstruct.cellclass];
        Class cls = NSClassFromString(Classname);
        if (cellstruct.isXib) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellstruct.cellclass owner:self options:nil] lastObject];
        }
        else {
            UITableViewCellStyle cellstyle = UITableViewCellStyleValue1;
            switch (cellstruct.cellStyleValue) {
                case 4:
                    cellstyle = UITableViewCellStyleDefault;
                    break;
                case 1:
                    cellstyle = UITableViewCellStyleValue1;
                    break;
                case 2:
                    cellstyle = UITableViewCellStyleValue2;
                    break;
                case 3:
                    cellstyle = UITableViewCellStyleSubtitle;
                    break;
                    
                default:
                    cellstyle = UITableViewCellStyleValue1;
                    break;
            }
            cell = [[cls alloc]  initWithStyle:cellstyle reuseIdentifier:identifier01 plistdic:cellstruct.dictionary];
            if (!cell) {
                cell = [[HBBaseTableViewCell alloc]  initWithStyle:cellstyle reuseIdentifier:identifier01 plistdic:cellstruct.dictionary];
            }
        }
    }
    return cell;
}



+ (void)drawCell:(HBBaseTableViewCell *)cell delegate:(id)delegate dataDictionary:(NSDictionary *)dataDictionary withIndexPath:(NSIndexPath *)indexPath
{
    CELL_STRUCT *cellstruct = [dataDictionary cellstructobjectForKey:KEY_INDEXPATH(indexPath.section, indexPath.row)];
//    NSString * identifier01 = cellstruct.cellclass;
    
    if ([[cell class] isSubclassOfClass:[HBBaseTableViewCell class]]) {
        if (!cellstruct.delegate) {
            cellstruct.delegate = delegate;
        }
        cell.delegate = cellstruct.delegate;
        cell.showTopLine = cellstruct.showTopLine;
        cell.showBottomLine = cellstruct.showBottomLine;
        cell.indexPath = indexPath;
        cell.selector = cellstruct.sel_selector;
        cell.selectionStyle = cellstruct.selectionStyle?UITableViewCellSelectionStyleDefault:UITableViewCellSelectionStyleNone;
        cell.accessoryType = cellstruct.accessory?UITableViewCellAccessoryDisclosureIndicator:UITableViewCellAccessoryNone;
        [cell setcellTitleLabelNumberOfLines:cellstruct.titleLabelNumberOfLines];
        [cell setcelldetailtitle:cellstruct.detailtitle];
        [cell setcellplaceholder:cellstruct.placeHolder];
        [cell setcellTitle:cellstruct.title];
        [cell setcellTitleFontsize:cellstruct.titlefontsize];
        [cell setcellTitleFont:cellstruct.titleFont];
        [cell setcellAttributeTitle:cellstruct.attributeTitle];
        [cell setcellValue2:cellstruct.subvalue2];
        [cell setcellPicture:cellstruct.picture];
        //        [cell setcellpicturecolor:cellstruct.picturecolor];
        [cell setcellValue:cellstruct.value];
        //        [cell setcellRightValue:cellstruct.rightValue];
        [cell setcellobject:cellstruct.object];
        [cell setcellobject2:cellstruct.object2];
        [cell setcellTitleColor:cellstruct.titlecolor];
        [cell setcelldictionary:cellstruct.dictionary];
        [cell setcellArray:cellstruct.array];
        [cell setcellimageCornerRadius:cellstruct.imageCornerRadius];
    }
}

@end
