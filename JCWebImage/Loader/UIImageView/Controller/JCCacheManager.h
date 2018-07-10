//
//  JCCacheManager.h
//  JCWorks
//
//  Created by Jai on 2018/7/10.
//  Copyright © 2018年 Jai Chow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCCacheManager : NSObject

+ (instancetype)manager;
- (UIImage*)imageForKey:(NSString*)key;
- (void)cacheImage:(UIImage*)image key:(NSString*)key;

@end

















































