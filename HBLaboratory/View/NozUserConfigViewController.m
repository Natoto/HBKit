//
//  NozUserConfigViewController.m
//  NOZLaboratory
//
//  Created by boob on 2019/5/17.
//

#import "NOZLaboratoryService.h"
#import "NozUserConfigViewController.h"
#import "OnOffTableViewCell.h"


@interface NozUserConfigViewController ()

@property (nonatomic, strong) NSString *plistName;
@property (nonatomic, assign) NSString *boundle;
@end

@implementation NozUserConfigViewController

+ (instancetype)configWithPlistName:(NSString *)plistName bundle:(NSString *)boundle
{
    
    NozUserConfigViewController *ctr = [NozUserConfigViewController new];
    if ([plistName hasSuffix:@"plist"]) {
        plistName = [plistName stringByReplacingOccurrencesOfString:@".plist" withString:@""];
    }
    NSLog(@"准备打开：%@",plistName);
    ctr.boundle = boundle.length>0?boundle:@"";
    ctr.plistName = plistName.length>0?plistName:@"TesterRooterViewController";
    return ctr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *plistName = self.plistName;//@"NozUserConfigViewController";
    if (!self.boundle) {
        self.boundle = @"libresource.bundle";
    }
    NSString *filepath = [[[NSBundle mainBundle] pathForResource:self.boundle ofType:nil] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",plistName]];
    [self loadplistConfig:plistName filepath:filepath];
    
    [self loadCacheData];
    
    NSNumber *offsetleft = [self.viewConfigDictionary objectForKey:@"contentrightwidth"];
    if (offsetleft) {
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.contentInset = UIEdgeInsetsZero;
        [self adjustContentOffLeft:[UIScreen mainScreen].bounds.size.width - offsetleft.floatValue right:0];
    }
}

- (void)loadCacheData
{
    
    NSDictionary *dic = @{};
    if ([[NOZLaboratoryService sharedInstance].dataSource respondsToSelector:@selector(lab_userConfigDictionary)]) {
         dic = [[NOZLaboratoryService sharedInstance].dataSource lab_userConfigDictionary];
    }
    [self.dataDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, HBCellStruct * obj, BOOL * _Nonnull stop) {
        if ([obj.cellclass isEqualToString:NSStringFromClass(OnOffTableViewCell.class)]) {
            BOOL show =[[NSUserDefaults standardUserDefaults] boolForKey:obj.title];
            obj.detailtitle = show?@"√":@"x";
        }
        if (dic && [obj.cellclass isEqualToString:NSStringFromClass(ShowValueTableViewCell.class)]) {
            obj.detailtitle = dic[obj.title];
        }
    }];
    [self.tableView reloadData];
}

- (void)dispatchNotifyObject:(HBCellStruct *)cs
{
    
    NOZLabCallBackObject *notify = [NOZLabCallBackObject notifyWithType:cs.title from:self cs:cs param:cs.value];
    [[NSNotificationCenter defaultCenter] postNotificationName:klab_notify_name object:notify];
    if (NOZLaboratoryService.sharedInstance.delegate) {
        [NOZLaboratoryService.sharedInstance.delegate lab_configSelectedWithNotifyObject:notify];
    }
}


- (void)selectAction:(HBCellStruct *)cs
{
    if ([cs.cellclass isEqualToString:@"OnOffTableViewCell"]) {
        [self switchOnOff:cs];
    }
    
    if ([cs.title isEqualToString:@"登录"]) {
        cs.value = @"还原不了了 。。。。。。。";
    }
}

- (void)switchOnOff:(HBCellStruct *)cs
{
    
    bool show =  [[NSUserDefaults standardUserDefaults] boolForKey:cs.title];
    show = !show;
    [[NSUserDefaults standardUserDefaults] setBool:show forKey:cs.title];
    cs.detailtitle = show?@"√":@"x";
    
    [self.tableView reloadData];
}

- (void)showLaboratory
{
    
    NozUserConfigViewController *ctr = [NozUserConfigViewController configWithPlistName:@"LaboratoryViewController" bundle:@""];
    [self presentViewController:ctr animated:YES completion:nil];
}
- (void)gotoNavViewController:(HBCellStruct *)cs
{    
    if (cs.value) {
        Class cls = NSClassFromString(cs.value);
        if (cls) {
            UIViewController *ctr ;
            if ([cs.value isEqualToString:@"NozUserConfigViewController"]) {
               ctr = [NozUserConfigViewController configWithPlistName:cs.subvalue2 bundle:self.boundle];
            } else {
               ctr = [[cls alloc] init];
            }
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctr];
            [self presentViewController:nav animated:YES completion:nil];
        } else {
            NSLog(@"没有这个类 %@",cs.value);
        }
    }
    else {
        NSLog(@"请填写value");
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    HBCellStruct *cs = [self.dataDictionary  objectForKey:KEY_INDEXPATH(indexPath.section, indexPath.row)];
    [self dispatchNotifyObject:cs];
}

@end
