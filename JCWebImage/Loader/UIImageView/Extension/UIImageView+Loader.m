//
//  UIImageView+Loader.m
//  JCWorks
//
//  Created by Jai on 2018/7/10.
//  Copyright © 2018年 Jai Chow. All rights reserved.
//

#import "UIImageView+Loader.h"
#import "JCLoaderManager.h"
#import <objc/runtime.h>

static void * JCKeyLoaderManager = NULL;

@implementation UIImageView (Loader)

#pragma mark - public method
- (void)jc_loadUrl:(NSString *)url {
	[self jc_loadUrl:url block:nil];
}

- (void)jc_loadUrl:(NSString *)url block:(void (^)(UIImage *, NSString *))block {
	[self jc_loadUrl:url placeholder:nil block:block];
}

- (void)jc_loadUrl:(NSString *)url placeholder:(UIImage *)placeholder {
	[self jc_loadUrl:url placeholder:placeholder block:nil];
}

- (void)jc_loadUrl:(NSString *)url placeholder:(UIImage *)placeholder block:(void (^)(UIImage *, NSString *))block {
	[self jc_fade];
	if (placeholder) {
		[self setImage:placeholder];
	}
	else {
		[self setBackgroundColor:[UIColor blackColor]];
	}
	
	CGRect frame = self.frame;
	JCProgressView * view = [[self loaderManager] progressView];
	[view setCenter:CGPointMake(CGRectGetWidth(frame)*0.5f, CGRectGetHeight(frame)*0.5f)];
	if (view.superview == nil) {
		[self addSubview:view];
	}
	
	__weak __typeof(&*self) wself = self;
	[[self loaderManager] loadWithUrl:url complete:^(UIImage *image) {
		[wself setImage:image];
		[wself jc_fade];
		if (block) {
			block(image, url);
		}
	}];
}

#pragma mark - getter/setter
- (JCLoaderManager*)loaderManager {
	JCLoaderManager * manager = objc_getAssociatedObject(self, &JCKeyLoaderManager);
	if (!manager) {
		manager = [JCLoaderManager manager];
		[self setLoaderManager:manager];
	}
	return manager;
}

- (void)setLoaderManager:(JCLoaderManager*)loaderManager {
	objc_setAssociatedObject(self, &JCKeyLoaderManager, loaderManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - animation
- (void)jc_fade {
	CATransition * animation = [CATransition animation];
	animation.type = kCATransitionFade;
	animation.duration = 0.5f;
	[self.layer addAnimation:animation forKey:@"fade"];
}

@end


















































