//
//  HBBaseCollectionView.m
//  HBKit
//
//  Created by boob on 2017/9/22.
//

#import "HBBaseCollectionView.h"
#import "HBCellStruct.h"
#import "HBBaseCollectionViewCell.h"
#import "HBBaseSectionCollectionReusableView.h"
#import "HBCellStruct_Common.h"
#import "HBCellStruct_KEY.h"

@implementation HBBaseCollectionView

- (void)configcellstructs
{};
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self.collectionView registerClass:HBBaseCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass([HBBaseCollectionViewCell class])];
    }
    return self;
}
- (void)registerClass:(nullable Class)cellClass
{
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
}
- (void)registerNib:(nullable UINib *)nib
{
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([nib class])];
}

- (NSInteger)configColumnCount
{
    return 10;
}
- (UIEdgeInsets)configSectionInset
{
    return UIEdgeInsetsZero;
}

- (UIEdgeInsets)configInsetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGFloat)configMinimumColumnSpacing
{
    return 5.;
}

- (CGFloat)configMinimumInteritemSpacing
{
    return 5.;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView ColumnCountOfSection:(NSInteger)section
{
    CELL_STRUCT *cell_struce = [self.dataDictionary cellstructobjectForKey:KEY_INDEXPATH(section, 0)];
    if (cell_struce.columncount > 0) {
        return cell_struce.columncount;
    }
    return 2;
}


#define UISCREEN_BOUNDS [UIScreen mainScreen].bounds

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        CGRect collectionViewFrame = CGRectMake(0,\
                                                0,\
                                                self.bounds.size.width,\
                                                self.bounds.size.height);
        _collectionView = [HBCProtocol createCollectionView:self frame:collectionViewFrame];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self addSubview:_collectionView];
    }
    return _collectionView;
}


- (void)viewDidCurrentView
{
    
}

- (CGRect)adjustContentOffSet:(CGFloat)top bottom:(CGFloat)bottom
{
    self.collectionView.frame = CGRectMake(0, top, self.bounds.size.width ,self.bounds.size.height - top - bottom);
    return self.collectionView.frame;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.nodeselectRow) {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
    [HBCollectionViewModel collectionView:collectionView didSelectItemAtIndexPath:indexPath dataDictionary:self.dataDictionary];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [HBCollectionViewModel collectionView:collectionView numberOfItemsInSection:section dataDictionary:self.dataDictionary];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [HBCollectionViewModel numberOfSectionsInCollectionView:collectionView dataDictionary:self.dataDictionary];
}
- (void)reloadData
{
    return [self.collectionView reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [HBCollectionViewModel collectionView:collectionView dataDictionary:self.dataDictionary delegate:self cellForItemAtIndexPath:indexPath];
}


- (CGFloat)itemWidth
{
    return  (self.bounds.size.width - 5 * (self.configColumnCount + 1)) / self.configColumnCount;;
}
#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets edgeinset = [self configInsetForSectionAtIndex:indexPath.section];
    CELL_STRUCT *cellstruct = [self.dataDictionary cellstructobjectForKey:KEY_INDEXPATH(indexPath.section, indexPath.row)];
    NSInteger realcolumcount = self.configColumnCount;
    if ([self respondsToSelector:@selector(collectionView:ColumnCountOfSection:)]) {
        realcolumcount = [self collectionView:collectionView ColumnCountOfSection:indexPath.section];
    }
    CGFloat cellSideLength = (self.bounds.size.width - edgeinset.left * (realcolumcount + 1)) / realcolumcount;
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

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section
{
    CELL_STRUCT *cell_struce = [self.dataDictionary cellstructobjectForKey:KEY_INDEXPATH(section, 0)];
    return cell_struce.sectionheight;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *view = [HBCProtocol collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath background:self.backgroundColor dataDictionary:self.dataDictionary];
        return view;
    }
    return nil;
}
- (NSString *)collectionView:(UICollectionView *)collectionView HeaderReuseIdentifierWithSection:(NSInteger)section
{
    return UICollectionElementKindSectionHeader;
}

//- (NSMutableDictionary *)dataDictionary {
//    if (!_dataDictionary) {
//        _dataDictionary = [[NSMutableDictionary alloc] init];
//    }
//    return _dataDictionary;
//}


@end

