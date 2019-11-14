//
//  TestAutoHeightViewController.m
//  demo
//
//  Created by HUANGBO on 15/8/11.
//  Copyright (c) 2015年 YY.COM All rights reserved.
//
 
#import "HBTesterKit.h"
#import "TestAutoHeightViewController.h"
#import "CF_CrowdFoundHeaderCell.h"
#import "CF_SupporterTableViewCell.h"

@interface TestAutoHeightViewController ()

@end

@implementation TestAutoHeightViewController

- (IBAction)selectAction:(HBCellStruct *)cellstruct
{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    TABLEVIEW_REGISTERXIBCELL_CLASS(self.tableView, @"CF_SupporterTableViewCell");
    [self cellstructDataChange];
    // Do any additional setup after loading the view.
}

- (void)cellstructDataChange
{
    for (int index = 0; index < 10; index++) {
        cell_struct *cellstruct = [self createcellstruct];
        [self.dataDictionary setObject:cellstruct forKey:KEY_INDEXPATH(0, index)];
    }
}

- (IBAction)cellselector:(cell_struct *)sender
{
    
}
- (cell_struct *)createcellstruct
{
    int randnumber = arc4random_uniform(2);
    NSString *title = randnumber?[self teststring1]:[self teststring2];
    cell_struct *cellstruct = [[cell_struct alloc] initWithtitle:title cellclass:@"CF_SupporterTableViewCell" placeholder:nil accessory:NO sel_selctor:@selector(cellselector:) delegate:self];
    cellstruct.cellheight = [self.tableView hb_heightForCellWithIdentifier:@"CF_SupporterTableViewCell" configuration:^(HBBaseTableViewCell * cell) {
        [cell setcellTitle:title];
    }];//auto
    cellstruct.xibvalue = @"CF_SupporterTableViewCell";
    return cellstruct;
}

- (NSString *)teststring1
{
    return @"asfsfs jfaslfjasdlf sjldf asjflskfslfas lfksajf sladf asflasdfjsalf ajslf sjdfl sajflas djfsdalfjsalkfjsadfklflasjglasgjsl safasldlskfslfas lfksajf sladf asflasdfjsalf ajslf sjdfl sajflas djfsdalfjsalkfjsadfklflasjglasgjsl safasldlskfslfas lfksajf sladf asflasdfjsalf ajslf sjdfl sajflas djfsdalfjsalkfjsadfklflasjglasgjsl safasldlskfslfas lfksajf sladf asflasdfjsalf ajslf sjdfl sajflas djfsdalfjsalkfjsadfklflasjglasgjsl safasldlskfslfas lfksajf sladf asflasdfjsalf ajslf sjdfl sajflas djfsdalfjsalkfjsadfklflasjglasgjsl safasldjglag safafa fafss";
}
- (NSString *)teststring2
{
    return @"asfsfs jfaslfjasdlf s ags";
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
