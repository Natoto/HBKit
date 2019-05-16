//
//  HBCollectionViewModel.m
//  HBKit
//
//  Created by boob on 2018/9/21.
//

#import "HBCollectionViewModel.h"
#import "HBCellStruct.h"
#import "HBBaseCollectionViewCell.h"
#import "HBCellStruct_Common.h"
#import "HBBaseSectionCollectionReusableView.h"
#import "HBCollectionFallFLayout.h"

@implementation HBCollectionViewModel


+ (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath   dataDictionary:(NSDictionary *)dataDictionary
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

+ (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
             dataDictionary:(NSDictionary *)dataDictionary
{
    //    return self.dataDictionary.allKeys.count;
    NSArray *keys = dataDictionary.allKeys;
    NSString *sectionx = KEY_SECTION_MARK(section);
    NSInteger rowcount = 0;
    for (int index = 0; index < keys.count; index ++) {
        NSString *key =[keys objectAtIndex:index];
        if ([key rangeOfString:sectionx].location != NSNotFound) {
            rowcount ++;
        }
    }
    return rowcount;
}

+ (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
                               dataDictionary:(NSDictionary *)dataDictionary
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

+ (UICollectionView *)createCollectionView:(id)delegate
                                     size:(CGSize)size
                     minimumColumnSpacing:(CGFloat)minimumColumnSpacing
                  minimumInteritemSpacing:(CGFloat)minimumInteritemSpacing
                       configSectionInset:(UIEdgeInsets)configSectionInset
                              columnCount:(NSInteger)columnCount
{
    UICollectionView * _collectionView;
    CGRect collectionViewFrame = CGRectMake(0,\
                                            0,\
                                            size.width,\
                                            size.height);
    
    HBCollectionFallFLayout *collectionViewFlowLayout = [[HBCollectionFallFLayout alloc] init];
    collectionViewFlowLayout.delegate = delegate;
    collectionViewFlowLayout.headerHeight = 0;
    collectionViewFlowLayout.minimumColumnSpacing = minimumColumnSpacing;
    collectionViewFlowLayout.minimumInteritemSpacing = minimumInteritemSpacing;
    collectionViewFlowLayout.sectionInset = configSectionInset;
    collectionViewFlowLayout.columnCount = columnCount;
//    collectionViewFlowLayout = collectionViewFlowLayout;
    _collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:collectionViewFlowLayout];
    _collectionView.dataSource = delegate;
    _collectionView.delegate = delegate;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.contentInset = UIEdgeInsetsMake(64., 0, 0, 0);
    [_collectionView registerClass:[HBBaseCollectionViewCell class] forCellWithReuseIdentifier:@"HBBaseCollectionViewCell"];
    [_collectionView registerClass:[HBBaseSectionCollectionReusableView class] forSupplementaryViewOfKind:@"UICollectionElementKindSectionHeader" withReuseIdentifier:@"HBBaseSectionCollectionReusableView"];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    return _collectionView;
}


+ (NSString *)valiateCellClass:(NSString *)cellclass
{
    if ([cellclass isEqualToString:@"HBBaseTableViewCell"]) {
        return @"HBBaseCollectionViewCell";
    }
    return cellclass;
}


+ (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
                              dataDictionary:(NSDictionary *)dataDictionary viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        HBBaseSectionCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HBBaseSectionCollectionReusableView" forIndexPath:indexPath];
        CELL_STRUCT *cell_struce = [dataDictionary cellstructobjectForKey:KEY_INDEXPATH(indexPath.section, 0)];
        
        view.titleLabel.text = cell_struce.sectiontitle;
        CGFloat sectionfont = (cell_struce.sectionfont > 0)?cell_struce.sectionfont:12;
        view.titleLabel.font = [UIFont systemFontOfSize:sectionfont];
        view.titleLabel.textColor = [CELL_STRUCT_Common colorWithStructKey:cell_struce.sectioncolor];
        view.titleLabel.textAlignment = NSTextAlignmentLeft;
        UIColor *bgcolor =  [CELL_STRUCT_Common colorWithStructKey:cell_struce.sectionbgcolor];
        view.backgroundColor = bgcolor?bgcolor:collectionView.backgroundColor;
        
        return view;
    }
    return nil;
}

+ (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                          dataDictionary:(NSDictionary *)dataDictionary
                                delegate:(id)delegate
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CELL_STRUCT *cellstruct = [dataDictionary cellstructobjectForKey:KEY_INDEXPATH(indexPath.section, indexPath.row)];
    CELL_STRUCT *cellstruct0 = [dataDictionary cellstructobjectForKey:KEY_INDEXPATH(indexPath.section, 0)];
    NSString *identifier01 =  [[self class] valiateCellClass:cellstruct.cellclass];
    HBBaseCollectionViewCell *cell ;
    @try {
        cell =  [collectionView dequeueReusableCellWithReuseIdentifier:identifier01 forIndexPath:indexPath];
    }
    @catch (NSException *exception) {
        NSLog(@"😫-->没有注册？重用的cell %@找不到\n%@",identifier01,exception);
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier01 forIndexPath:indexPath];
    }
    @finally {
    }
    if (!cell) {
        cell = [[HBBaseCollectionViewCell alloc] init];
    }
    if ([[cell class] isSubclassOfClass:[HBBaseCollectionViewCell class]]) {
        if (!cellstruct.delegate) {
            cellstruct.delegate = delegate;
        }
        cell.delegate = cellstruct.delegate;
        cell.indexPath = indexPath;
        cell.columncount = cellstruct0.columncount;
        [cell setcelldetailtitle:cellstruct.detailtitle];
        [cell setcellTitle:cellstruct.title];
        [cell setcellPicture:cellstruct.picture];
        [cell setcellobject:cellstruct.object];
        [cell setcellobject2:cellstruct.object2];
        [cell setcellTitleColor:cellstruct.titlecolor];
        [cell setcelldictionary:cellstruct.dictionary];
        [cell setcellValue:cellstruct.value];
    }
    return cell;
}



@end






//#import "HBBaseCollectionViewCell.h"
//#import "HBBaseSectionCollectionReusableView.h"
//#import "HBCellStruct.h"
//#import "HBCellStruct_KEY.h"
//#import "HBCellStruct_Common.h"

@implementation HBCProtocol


+ (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath background:(UIColor *)backgroundColor dataDictionary:(NSMutableDictionary *)dataDictionary
{
    if (kind == UICollectionElementKindSectionHeader) {
        HBBaseSectionCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HBBaseSectionCollectionReusableView" forIndexPath:indexPath];
        CELL_STRUCT *cell_struce = [dataDictionary cellstructobjectForKey:KEY_INDEXPATH(indexPath.section, 0)];
        
        view.titleLabel.text = cell_struce.sectiontitle;
        CGFloat sectionfont = (cell_struce.sectionfont > 0)?cell_struce.sectionfont:12;
        view.titleLabel.font = [UIFont systemFontOfSize:sectionfont];
        view.titleLabel.textColor = [CELL_STRUCT_Common colorWithStructKey:cell_struce.sectioncolor];
        view.titleLabel.textAlignment = NSTextAlignmentLeft;
        UIColor *bgcolor =  [CELL_STRUCT_Common colorWithStructKey:cell_struce.sectionbgcolor];
        view.backgroundColor =  bgcolor?bgcolor:backgroundColor;
        
        return view;
    }
    return nil;
}

+ (UICollectionView *)createCollectionView:(id<HBCollectionViewControllerConfig,HBWaterFLayoutDelegate,UICollectionViewDataSource,UICollectionViewDelegate>)target frame:(CGRect)frame
{
    
    CGRect collectionViewFrame = frame;
    HBCollectionFallFLayout *collectionViewFlowLayout = [[HBCollectionFallFLayout alloc] init];
    collectionViewFlowLayout.delegate = target;
    collectionViewFlowLayout.headerHeight = 0;
    collectionViewFlowLayout.minimumColumnSpacing = target.configMinimumColumnSpacing;
    collectionViewFlowLayout.minimumInteritemSpacing = target.configMinimumInteritemSpacing;
    collectionViewFlowLayout.sectionInset = target.configSectionInset;
    collectionViewFlowLayout.columnCount = target.configColumnCount;
    
    target.collectionViewFlowLayout = collectionViewFlowLayout;
    UICollectionView *_collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:collectionViewFlowLayout];
    _collectionView.dataSource = target;
    _collectionView.delegate = target;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.contentInset = UIEdgeInsetsMake(64., 0, 0, 0);
    [_collectionView registerClass:[HBBaseCollectionViewCell class] forCellWithReuseIdentifier:@"HBBaseCollectionViewCell"];
    [_collectionView registerClass:[HBBaseSectionCollectionReusableView class] forSupplementaryViewOfKind:@"UICollectionElementKindSectionHeader" withReuseIdentifier:@"HBBaseSectionCollectionReusableView"];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    return _collectionView;
    
    
}
@end
