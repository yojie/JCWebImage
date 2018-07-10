//
//  JCRequestImageOperation.h
//  JCWorks
//
//  Created by Jai on 2018/7/10.
//  Copyright © 2018年 Jai Chow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JCRequestImageOperation : NSOperation

@property (nonatomic, copy) NSString * imageUrl;
@property (nonatomic, copy) void(^callback)(UIImage*image);
@property (nonatomic, copy) void(^progress)(CGFloat progress);

- (instancetype)initWithImageUrl:(NSString*)imageUrl;
- (instancetype)initWithImageUrl:(NSString*)imageUrl progress:(void(^)(CGFloat progress))progress block:(void(^)(UIImage*image))block;

+ (instancetype)createWithImageUrl:(NSString*)imageUrl;
+ (instancetype)createWithImageUrl:(NSString*)imageUrl progress:(void(^)(CGFloat progress))progress block:(void(^)(UIImage*image))block;

@end


















































