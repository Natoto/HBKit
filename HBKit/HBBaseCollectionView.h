//
//  HBBaseCollectionView.h
//  HBKit
//
//  Created by boob on 2017/9/22.
//

#import "HBCollectionFallFLayout.h"
#import <UIKit/UIKit.h>
#import "HBCProtocol.h"
#import "HBCollectionViewModel.h"
#import "HBBaseViewControllerDelegate.h"
@interface HBBaseCollectionView : UIView<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,HBCollectionViewControllerConfig,HBWaterFLayoutDelegate,HBBaseViewControllerDelegate>

//@property (nonatomic, strong) NSMutableDictionary * dataDictionary;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) HBCollectionFallFLayout *collectionViewFlowLayout;
@property (nonatomic, assign) BOOL    nodeselectRow;
@property (nonatomic, assign, readonly) CGFloat itemWidth;

- (void)reloadData;

- (void)viewDidCurrentView;

- (CGRect)adjustContentOffSet:(CGFloat)top bottom:(CGFloat)bottom; 
 
- (void)registerClass:(nullable Class)cellClass;

- (void)registerNib:(nullable UINib *)nib;

@end
