//
//  JCLoaderManager.h
//  JCWorks
//
//  Created by Jai on 2018/7/10.
//  Copyright © 2018年 Jai Chow. All rights reserved.
//

#import "JCProgressView.h"

@interface JCLoaderManager : NSObject

@property (nonatomic, readonly) JCProgressView * progressView;

+ (instancetype)manager;

- (void)loadWithUrl:(NSString*)url complete:(void(^)(UIImage*image))complete;

@end



















































