
# 实验室模块

实验室模块是开发模式下专用，用于完成以下功能

> * 切换正式测试环境
> * 切换统计环境
> * 清理内存空间
> * 清空userdefault数据
> * 查看沙盒文件夹目录
> * 查看/复制用户uid
> * 查看/复制设备号
> * 显示帧率
> * 打开网页
> * 打点
> * 扩展定制其他功能
> 

----
接入方式 

```
pod 'NOZLaboratory',:path=>'./LocalPod/NOZLaboratory.podspec', :configurations => ['Debug','Release']
pod 'FLEX','2.4.0', :configurations => ['Debug','Release']

```

## 使用步骤

###  1. 唤起方式---> 摇一摇手机


###  2. 监听内部事件,并相应处理

包含，测试环境，打开网页，fps开闭等

labhelper.m

```

@implementation NOZLabHelper

+(void)load{
    [NOZLabHelper sharedInstance];
}

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addLabNotifyObserver];
        
        [NOZLaboratoryService sharedInstance].dataSource = self;
        
        if ([[NOZLaboratoryService sharedInstance] e].showfpslabel) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self handle_klab_notify_openfps:nil];
            });
        }
    }
    return self;
}

-(void)addLabNotifyObserver{
     
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handle_klab_notify_clearcachedata:) name:klab_notify_clearcachedata object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handle_klab_notify_openweburl:) name:klab_notify_openweburl object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handle_klab_notify_openfps:) name:klab_notify_openfps object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handle_klab_notify_showlaunchcost:) name:klab_notify_showlaunchcost object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handle_klab_notify_ofemojidebug:) name:klab_notify_ofemojidebug object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handle_klab_notify_ofeffectdebug:) name:klab_notify_ofeffectdebug object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handel_klab_notify_openwebhtml:) name:klab_notify_openwebhtml object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handel_klab_notify_clickcell:) name:klab_notify_clickcell object:nil];
}

//...

@end
```  

###  实现数据源

```
#pragma mark - datasource

-(NSNumber *)lab_getuid{
    return @([MOSUserModel shareInstance].uid);//@([GetViperService(NOZAuthServiceProtocol_routable) getUserId]);
}

-(NSString *)lab_getHdid{
    return  [HiidoSDK getHDID];//@"";//[YYUtility HDID];
}


```

### 配置实时更新实验室UI

仅限模拟器更新,这个选项是boundle放在位置

```

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<string>$(SRCROOT)/$(TARGET_NAME)/Tester</string>
</plist>


```
