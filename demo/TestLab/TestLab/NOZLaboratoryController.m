//
//  NOZLaboratoryController.m
//  SODA
//
//  Created by peng jun on 2017/12/5.
//Copyright © 2017年 YY.Inc. All rights reserved.
//

#import "NOZLaboratoryController.h"
#if __has_include( <HBTesterKit/HBTesterKit.h>)
#import <HBTesterKit/HBTesterKit.h>
#elif  __has_include( <HBKit/HBKit.h>)
#import <HBKit/HBKit.h>
#endif
#import "NOZLaboratoryService.h"
#import "NOZLabCommon.h"


@interface NOZLaboratoryController ()
@end

@implementation NOZLaboratoryController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSString * plistName = @"NOZLaboratoryViewController";
    NSString * filepath = [[[NSBundle mainBundle] pathForResource:@"libresource.bundle" ofType:nil] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",plistName]];
    [self loadplistConfig:plistName filepath:filepath];
    
    if(NOZLaboratoryService.sharedInstance.dataSource && [NOZLaboratoryService.sharedInstance.dataSource respondsToSelector:@selector(lab_dictionary:)]){
       self.dataDictionary = [NOZLaboratoryService.sharedInstance.dataSource lab_dictionary:self.dataDictionary];
    }
    [self loadCacheData];
    [self.tableView reloadData];
}


- (void)loadCacheData{
    
    NSDictionary * dic = @{};
    if([[NOZLaboratoryService sharedInstance].dataSource respondsToSelector:@selector(lab_userConfigDictionary)]){
        dic = [[NOZLaboratoryService sharedInstance].dataSource lab_userConfigDictionary];
    }
    [self.dataDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, HBCellStruct * obj, BOOL * _Nonnull stop) {
        if ([obj.cellclass isEqualToString:@"OnOffTableViewCell"]) {
            BOOL show =[[NSUserDefaults standardUserDefaults] boolForKey:obj.title];
            obj.detailtitle = show?@"√":@"x";
            [self configcellstructs:obj];
        }
        if(dic[obj.title] && [obj.cellclass isEqualToString:@"ShowValueTableViewCell"]){
            obj.detailtitle = dic[obj.title];
            obj.value = dic[obj.title];
        }
    }];
    [self.tableView reloadData];
}


-(void)configcellstructs:(HBCellStruct *)cs{
    
    if ([cs.title isEqualToString:@"切换开发测试环境"]) {
        bool show =  [[NOZLaboratoryService sharedInstance] e].isConnecTestServer;
        cs.detailtitle = show?@"√":@"x";
    }
    else if([cs.title isEqualToString:@"海度测试服务器datatest.hiido.com"]){
        NSString * show =  [[NOZLaboratoryService sharedInstance] e].hiidoTestDomain;
        cs.detailtitle = show>0?@"√":@"x";
    }
}

-(void)gotoNavViewController:(HBCellStruct *)cs{
    
    if (cs.value) {
        Class cls = NSClassFromString(cs.value);
        if (cls) {
            UIViewController * ctr = [[cls alloc] init];
            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:ctr];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
    else{
        NSLog(@"请填写value");
    }
}

-(void)selectAction:(HBCellStruct *)cs{
    
    NSLog(@"select: %@",cs.title);
    
    NOZLabCallBackObject * notify = [NOZLabCallBackObject notifyWithType:cs.title from:self cs:cs param:nil];
    
    if ([cs.title isEqualToString:@"切换测试服务器"]) {
        
        bool show =  [[NOZLaboratoryService sharedInstance] e].isConnecTestServer;
        show = !show;
        [[NOZLaboratoryService sharedInstance] e].isConnecTestServer =  show;
        cs.detailtitle = show?@"√":@"x";
        [self.tableView reloadData];
    }else if ([cs.title isEqualToString:@"海度测试服务器datatest.hiido.com"]) {
        
            NSString * show =  [[NOZLaboratoryService sharedInstance] e].hiidoTestDomain;
            show = show.length>0?@"":@"http://datatest.hiido.com/c.gif";
            [[NOZLaboratoryService sharedInstance] e].hiidoTestDomain =  show;
            cs.detailtitle = show.length>0?@"√":@"x";
            [self.tableView reloadData];
   }
    else if([cs.title isEqualToString:@"通用UI库"]){
        Class CLS = NSClassFromString(cs.value);
        if (CLS) {// NOZLabCommonUIController
            UIViewController * ctr = [CLS new];
            [self.navigationController pushViewController:ctr animated:YES];
        }
    } else if ([cs.title isEqualToString:@"清空缓存"]) {
        
        [NOZLabCommon clearCacheData];
        
    } else if ([cs.title isEqualToString:@"清空字典缓存"]) {
        [NOZLabCommon clearUserDefaultData];
        
    } else if ([cs.title isEqualToString:@"崩溃"]) {
        NSException *e = [NSException exceptionWithName:@"这是一个主动崩溃"
                                                 reason:@"The crash is trigger by developer manual."
                                               userInfo:nil];
        @throw e;
    }else if ([cs.cellclass isEqualToString:@"OnOffTableViewCell"]){
        
        BOOL show =[[NSUserDefaults standardUserDefaults] boolForKey:cs.title];
        show = !show;
        [[NSUserDefaults standardUserDefaults] setBool:show forKey:cs.title];
        cs.detailtitle = show?@"√":@"x";
        [self.tableView reloadData];
    }
    
    if([cs.cellclass isEqualToString:@"ShowValueTableViewCell"]){
        [UIPasteboard generalPasteboard].string = cs.value;
        NSLog(@"[LAB] 已复制 %@: %@",cs.title,cs.value);
    }
    [self dispatchNotifyObject:cs];
    
}

-(void)backtoparent:(id)sender{
    [super backtoparent:sender];
   
}


#pragma mark - life cycle

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Route

-(void)openweburl:(HBCellStruct *)cs{
    
    if (@available(iOS 8.0, *)) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"提示"
                                                                                  message: @"请输入网址，然后点确认"
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"请输入网址";
            textField.textColor = [UIColor blueColor];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.borderStyle = UITextBorderStyleRoundedRect;
        }];
          
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"cancel");
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSArray * textfields = alertController.textFields;
            UITextField * namefield = textfields[0];
            //        UITextField * passwordfiled = textfields[1];
            NSLog(@"input url: %@",namefield.text);
            cs.value = namefield.text;
            [self dispatchNotifyObject:cs];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        // Fallback on earlier versions
    }
}


- (void)dispatchNotifyObject:(HBCellStruct *)cs{
    
    NOZLabCallBackObject * notify = [NOZLabCallBackObject notifyWithType:cs.title from:self cs:cs param:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:klab_notify_name object:notify];
    if(NOZLaboratoryService.sharedInstance.delegate){
        [NOZLaboratoryService.sharedInstance.delegate lab_configSelectedWithNotifyObject:notify];
    }
}



#pragma mark - push

-(void)gotoPushViewController:(HBCellStruct *)cs{
    
    if (cs.value) {
        Class cls = NSClassFromString(cs.value);
        if (cls) {
            UIViewController * ctr = [[cls alloc] init];
            [self.navigationController pushViewController:ctr animated:YES];
        }
    }
    else{
        NSLog(@"请填写value");
    }
}
#pragma mark - present

-(void)gotoPresentNavViewController:(HBCellStruct *)cs{
    
    if (cs.value) {
        Class cls = NSClassFromString(cs.value);
        if (cls) {
            UIViewController * ctr = [[cls alloc] init];
            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:ctr];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
    else{
        NSLog(@"请填写value");
    }
}


@end 
