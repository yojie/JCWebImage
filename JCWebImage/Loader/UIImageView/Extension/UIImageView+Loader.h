//
//  UIImageView+Loader.h
//  JCWorks
//
//  Created by Jai on 2018/7/10.
//  Copyright © 2018年 Jai Chow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Loader)

/**
 加载网络图片

 @param url 网络地址
 */
- (void)jc_loadUrl:(NSString*)url;
/**
 加载网络图片

 @param url 网络地址
 @param block 设置回调
 */
- (void)jc_loadUrl:(NSString *)url block:(void(^)(UIImage*image,NSString*url))block;
/**
 加载网络图片
 
 @param url 网络地址
 @param placeholder 预览图片
 */
- (void)jc_loadUrl:(NSString *)url placeholder:(UIImage*)placeholder;
/**
 加载网络图片
 
 @param url 网络地址
 @param placeholder 预览图片
 @param thumbnail 缩略图比率(0..1)
 @param block 设置回调
 */
- (void)jc_loadUrl:(NSString *)url placeholder:(UIImage*)placeholder thumbnail:(CGFloat)thumbnail block:(void(^)(UIImage*image,NSString*url))block;
/**
 加载网络图片

 @param url 网络地址
 @param thumbnail 缩略图比率(0..1)
 */
- (void)jc_loadUrl:(NSString *)url thumbnail:(CGFloat)thumbnail;
/**
 加载网络图片
 
 @param url 网络地址
 @param thumbnail 缩略图比率(0..1)
 @param block 设置回调
 */
- (void)jc_loadUrl:(NSString *)url thumbnail:(CGFloat)thumbnail block:(void(^)(UIImage*image,NSString*url))block;
/**
 加载网络图片
 
 @param url 网络地址
 @param placeholder 预览图片
 @param thumbnail 缩略图比率(0..1)
 */
- (void)jc_loadUrl:(NSString *)url placeholder:(UIImage*)placeholder thumbnail:(CGFloat)thumbnail;

@end


















































