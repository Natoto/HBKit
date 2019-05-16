//
//  SGDirObserver.h
//  DirectoryObserver
//
//  Copyright (c) 2011 Simon Grätzer.
//

#import <Foundation/Foundation.h>

@interface HBDirWatchdog : NSObject

@property (nonatomic, readonly) NSString *path;
@property (nonatomic, copy) void (^update)(void);

+ (NSString *)documentsPath;
+ (id)watchtdogOnDocumentsDir:(void (^)(void))update;

- (id)initWithPath:(NSString *)path update:(void (^)(void))update;

- (void)start;
- (void)stop;

@end
