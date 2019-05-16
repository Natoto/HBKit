//
//  UITableView+autoHeight.h
//  HBKit
//
//  Created by boob on 2018/9/21.
//

#import <UIKit/UIKit.h>

@interface UITableView(autoHeight)

/**
 *  计算CELL的高度 实现的方法需要在cell的具体实现里面重载sizeThatFit:
 *
 *  @param identifier    identifier
 *  @param configuration cell加载数据的
 *
 *  @return 高度
 */
- (CGFloat)hb_heightForCellWithIdentifier:(NSString *)identifier configuration:(void (^)(id cell))configuration;
@end
