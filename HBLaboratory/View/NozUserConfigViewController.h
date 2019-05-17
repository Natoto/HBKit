//
//  NozUserConfigViewController.h
//  NOZLaboratory
//
//  Created by boob on 2019/5/17.
//

#import "HBBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NozUserConfigViewController : HBBaseTableViewController
 
+ (instancetype)configWithPlistName:(NSString *)plistName bundle:(NSString *)boundle;
@end

NS_ASSUME_NONNULL_END
