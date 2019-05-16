//
//  BaseCollectionViewController.m
//  PENG
//
//  Created by zeno on 15/11/18.
//  Copyright © 2015年 YY.COM All rights reserved.
//

#import "HBBaseCollectionViewController.h"
#import "HBBaseCollectionViewCell.h"
#import "HBCollectionFallFLayout.h"
#import "HBCellStruct.h"
#import "HBCellStruct_Common.h"
#import "HBBaseSectionCollectionReusableView.h"


@interface HBBaseCollectionViewController ()
{
    BOOL config;
}
@end

@implementation HBBaseCollectionViewController

-(NSInteger)configColumnCount
{
    return 10;
}
-(UIEdgeInsets)configSectionInset
{
    return UIEdgeInsetsZero;
}

-(UIEdgeInsets)configInsetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

-(CGFloat)configMinimumColumnSpacing
{
    return 5.;
}

-(CGFloat)configMinimumInteritemSpacing
{
    return 5.;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView ColumnCountOfSection:(NSInteger)section
{
    CELL_STRUCT *cell_struce = [self.dataDictionary cellstructobjectForKey:KEY_INDEXPATH(section, 0)];
    if (cell_struce.columncount > 0) {
        return cell_struce.columncount;
    }
    return 2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {//这个是需要的
        self.edgesForExtendedLayout = UIRectEdgeAll;//UIRectEdgeNone;
    }
     self.collectionView.backgroundColor = [UIColor clearColor];
     self.showBackItem = YES;
}
 

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#define UISCREEN_BOUNDS [UIScreen mainScreen].bounds

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        _collectionView = [HBCollectionViewModel createCollectionView:self size:self.view.bounds.size minimumColumnSpacing:[self configMinimumColumnSpacing]
                                              minimumInteritemSpacing:[self configMinimumInteritemSpacing] configSectionInset:[self configSectionInset] columnCount:self.configColumnCount];
         [self.view addSubview:_collectionView];
    }
    return _collectionView;
}


-(void)viewDidCurrentView{

}

-(CGRect)adjustContentOffSet:(CGFloat)top bottom:(CGFloat)bottom
{
    self.collectionView.frame = CGRectMake(0, top, self.view.bounds.size.width ,self.view.bounds.size.height - top - bottom);
    return self.collectionView.frame;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.nodeselectRow) {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
    [HBCollectionViewModel collectionView:collectionView didSelectItemAtIndexPath:indexPath dataDictionary:self.dataDictionary];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [HBCollectionViewModel collectionView:self.collectionView numberOfItemsInSection:section dataDictionary:self.dataDictionary];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [HBCollectionViewModel numberOfSectionsInCollectionView:collectionView dataDictionary:self.dataDictionary];
}

-(NSString *)valiateCellClass:(NSString *)cellclass
{
    if ([cellclass isEqualToString:@"HBBaseTableViewCell"]) {
            return @"HBBaseCollectionViewCell";
    }
    return cellclass;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [HBCollectionViewModel collectionView:collectionView dataDictionary:self.dataDictionary delegate:self cellForItemAtIndexPath:indexPath];
}


-(CGFloat)itemWidth
{
    return  (self.view.bounds.size.width - 5 * (self.configColumnCount + 1)) / self.configColumnCount;;
}
#pragma mark - UICollectionViewDelegateFlowLayout
 
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets edgeinset = [self configInsetForSectionAtIndex:indexPath.section];
     CELL_STRUCT * cellstruct = [self.dataDictionary cellstructobjectForKey:KEY_INDEXPATH(indexPath.section, indexPath.row)];
    NSInteger realcolumcount = self.configColumnCount;
    if ([self respondsToSelector:@selector(collectionView:ColumnCountOfSection:)]) {
        realcolumcount = [self collectionView:collectionView ColumnCountOfSection:indexPath.section];
    }
    CGFloat cellSideLength = (self.view.bounds.size.width - edgeinset.left * (realcolumcount + 1)) / realcolumcount;
    CGFloat itemheight = (cellstruct.cellheight>0) ? cellstruct.cellheight:cellSideLength;
    CGSize cellSize = CGSizeMake(cellSideLength, itemheight);
    return cellSize;
     
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return [self configInsetForSectionAtIndex:section];//UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section
{
    CELL_STRUCT *cell_struce = [self.dataDictionary cellstructobjectForKey:KEY_INDEXPATH(section, 0)];
    return cell_struce.sectionheight;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return [HBCollectionViewModel collectionView:collectionView dataDictionary:self.dataDictionary viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
}

-(NSString *)collectionView:(UICollectionView *)collectionView HeaderReuseIdentifierWithSection:(NSInteger)section
{
    return UICollectionElementKindSectionHeader;
}
 
@end
