//
//  TestCollectionViewController.m
//  demo
//
//  Created by zeno on 15/12/14.
//  Copyright © 2015年 YY.COM All rights reserved.
//
#import "cell_struct.h"
#import "TestCollectionViewController.h"
#import "TestCollectionViewCell.h"
#import "TestSectionCollectionReusableView.h"
#import "Test2CollectionReusableView.h"
#import "cell_struct_common.h"
@interface TestCollectionViewController ()<HBCollectionViewControllerConfig,HBWaterFLayoutDelegate>

@end

@implementation TestCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    COLLECTIONVIEW_REGISTER_XIB_FORSUPPLEMENTARYVIEW(self.collectionView, @"TestSectionCollectionReusableView");
 
    [self.collectionView registerClass:[Test2CollectionReusableView class] forSupplementaryViewOfKind:@"Test2CollectionReusableView" withReuseIdentifier:@"Test2CollectionReusableView"];
    
    COLLECTIONVIEW_REGISTER_XIB_CELLCLASS(self.collectionView, @"TestCollectionViewCell");
    for (int index = 0; index < 15; index ++) {
        cell_struct *cellstruct = [cell_struct cell_x_x_struct:@"" detailvalue:@"" target:self selectAction:DEFAULT_CELL_SELECT_ACTION];
        cellstruct.cellclass = @"TestCollectionViewCell";
//        cellstruct.isXib = YES;
        cellstruct.cellheight = 10*(index%5) + 50;
        cellstruct.sectionheight = 50;
        [cellstruct.dictionary setObject:[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1] forKey:key_cellstruct_background];
        [self.dataDictionary setObject:cellstruct forKey:KEY_INDEXPATH(0, index)];
    }
   
    for (int index = 0; index < 5; index ++) {
        cell_struct *cellstruct = [cell_struct cell_x_x_struct:@"" detailvalue:@"" target:self selectAction:DEFAULT_CELL_SELECT_ACTION];
        cellstruct.cellclass = @"TestCollectionViewCell";
//        cellstruct.isXib = YES;
        cellstruct.cellheight = 10*(index%5) + 50;
        cellstruct.sectionheight = 50;
        [cellstruct.dictionary setObject:[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1] forKey:key_cellstruct_background];
        [self.dataDictionary setObject:cellstruct forKey:KEY_INDEXPATH(2, index)];
    }
    
    for (int index = 0; index < 20; index ++) {
        cell_struct *cellstruct = [cell_struct cell_x_x_struct:@"" detailvalue:@"" target:self selectAction:DEFAULT_CELL_SELECT_ACTION];
        cellstruct.cellclass = @"TestCollectionViewCell";
//        cellstruct.isXib =  YES;
        cellstruct.cellheight = 200;
        cellstruct.sectionheight = 50;
        [cellstruct.dictionary setObject:[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1] forKey:key_cellstruct_background];
        [self.dataDictionary setObject:cellstruct forKey:KEY_INDEXPATH(1, index)];
    }
    [self adjustContentOffSet:0 bottom:0];
}

- (NSInteger)configColumnCount
{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView ColumnCountOfSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    else if (section == 1) {    return 1;
    }
    else
        return 2;
}

- (UIEdgeInsets)configSectionInset
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UIEdgeInsets)configInsetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)configMinimumColumnSpacing
{
    return 0;
}

- (CGFloat)configMinimumInteritemSpacing
{
    return 0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:@"TestSectionCollectionReusableView"]) {
        TestSectionCollectionReusableView *sectionview = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"TestSectionCollectionReusableView" forIndexPath:indexPath];
        return sectionview;
    }
    else if ([kind isEqualToString:@"Test2CollectionReusableView"]) {
        Test2CollectionReusableView *reuseview = [collectionView  dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Test2CollectionReusableView" forIndexPath:indexPath];
        return reuseview;
    }
    return nil;
}

- (NSString *)collectionView:(UICollectionView *)collectionView HeaderReuseIdentifierWithSection:(NSInteger)section
{
    if (section) {
        return @"Test2CollectionReusableView";
    }
    else
    return @"TestSectionCollectionReusableView";
}

- (IBAction)selectAction:(HBCellStruct *)cellstruct
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 

@end
