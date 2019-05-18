## HBKit 

*  create a list(tableview or collectionview) by plist or json file
*  create a list by one line

## 用法
 
 ```
 pod 'HBKit'
```

other pods based on HBKit

```
 pod 'HBKitRefresh'  #for pull refresh or load more 

 pod 'HBKitWatchDog' #add watchdog to real refresh list

 pod 'HBLaboratory' # laboratory 
 
```

[HBLaboratory](HBLaboratory/README.MD)

[HBKitWatchDog](tools/HBKitWatchDog/README.MD)

[HBKitRefresh](tools/HBKitRefresh/README.MD)



![HBKit use case](HBKit/snapshoot/sgdir.gif)



### load from plist

```objc
 
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadplistConfig:@"TestPlist" watch_directory:@"resource"];
}

```

### laod from json file

```objc
 
- (void)viewDidLoad {
    [super viewDidLoad]; 
    [self loadjsonfileConfig:@"TestJson" watch_directory:@"resource"]; 
}
```


### 代码加载



![HBKit 示例](HBKit/snapshoot/list.png)


``` oc


@interface RootViewController ()
//step 1
 @property(nonatomic, retain) CELL_STRUCT *cell_struct_normal;
 @property(nonatomic, retain) CELL_STRUCT *cell_struct_sys;
 @property(nonatomic, retain) CELL_STRUCT *cell_struct_xib;
 @property(nonatomic, retain) CELL_STRUCT *cell_struct_plist;
 @property(nonatomic, retain) CELL_STRUCT *cell_struct_autoheight;
 @property(nonatomic, retain) CELL_STRUCT *cell_struct_refresh;
 @property(nonatomic, retain) CELL_STRUCT *cell_struct_normalcollection;
 @property(nonatomic, retain) CELL_STRUCT *cell_struct_collection;
 @property(nonatomic, retain) CELL_STRUCT *cell_struct_kvo;
 @property(nonatomic, retain) CELL_STRUCT *cell_struct_drawcell;
 @property(nonatomic, retain) CELL_STRUCT *cell_struct_copy;
 @property(nonatomic, retain) CELL_STRUCT *cell_struct_testjson;

@property(nonatomic, retain) CELL_STRUCT *cell_struct_testanode;

@end


@implementation RootViewController
DEF_CELL_STRUCT_WITH(testanode, @"测试asyndisplaynode");

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"HBKit-快速开发引擎";
    [self loadCellstructConfig];
}

- (void)loadCellstructConfig
{
    
    NSInteger rowIndex = 0;
    NSInteger sectionIndex = 0;
    
    self.cell_struct_normal.sectionheight = 30;
    self.cell_struct_normal.sectiontitle = @"常规列表和瀑布流创建方法";
    [self.dataDictionary setObject:self.cell_struct_normal forKey:KEY_INDEXPATH(sectionIndex, rowIndex++)];
    [self.dataDictionary setObject:self.cell_struct_normalcollection forKey:KEY_INDEXPATH(sectionIndex, rowIndex++)];
    
    sectionIndex++,rowIndex = 0;
    self.cell_struct_sys.sectionheight = 20;
    self.cell_struct_sys.sectiontitle = @"HBKit列表和瀑布流创建方法";
    
    [self.dataDictionary setObject:self.cell_struct_sys forKey:KEY_INDEXPATH(sectionIndex, rowIndex++)];
    [self.dataDictionary setObject:self.cell_struct_plist forKey:KEY_INDEXPATH(sectionIndex, rowIndex++)];
    [self.dataDictionary setObject:self.cell_struct_testjson forKey:KEY_INDEXPATH(sectionIndex, rowIndex++)];
    [self.dataDictionary setObject:self.cell_struct_xib forKey:KEY_INDEXPATH(sectionIndex, rowIndex++)]; 
    [self.tableView reloadData];
}

/**
*  响应的CELselect的方法
*/
//step 3

- (IBAction)selectAction:(CELL_STRUCT *)cellstruct
{
    if (cellstruct == self.cell_struct_sys) {
        
        TestSystyleviewController *ctr = [[TestSystyleviewController alloc] init];
        [self.navigationController pushViewController:ctr animated:YES];
    }
    else if (cellstruct == self.cell_struct_xib) {
        TestXibViewController *ctr = [[TestXibViewController alloc] init];
        [self.navigationController pushViewController:ctr animated:YES];
    }
}

//step4 OK

``` 




