//
//  ViewController.m
//  TestLab
//
//  Created by boob on 2019/5/16.
//  Copyright © 2019年 boob. All rights reserved.
//

#import "ViewController.h"
#import "NOZLabHelper.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)gotolab:(id)sender
{
    
    [[NOZLabHelper sharedInstance] showRootLab];
}

@end
