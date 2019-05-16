//
//  BaseCollectionViewController.h
//  PENG
//
//  Created by zeno on 15/11/18.
//  Copyright © 2015年 YY.COM All rights reserved.
//
#import "HBCollectionFallFLayout.h"
#import "HBBaseViewController.h"
#import "HBCollectionViewModel.h"

@interface HBBaseCollectionViewController : HBBaseViewController<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,HBCollectionViewControllerConfig,HBWaterFLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) HBCollectionFallFLayout *collectionViewFlowLayout;

@property (nonatomic, assign) BOOL    nodeselectRow;
@property (nonatomic, assign, readonly) CGFloat itemWidth;

- (void)viewDidCurrentView;
- (CGRect)adjustContentOffSet:(CGFloat)top bottom:(CGFloat)bottom; 
@end
