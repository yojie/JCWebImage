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

#pragma mark -
@interface UIImage (Size)

- (UIImage *)imageResize:(CGSize)size;

@end

#pragma mark -
static void * JCKeyLoaderManager = NULL;

@implementation UIImageView (Loader)

#pragma mark - method swizzling
+ (void)load {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		Class cls = [self class];
		SEL oriSEL = @selector(layoutSubviews);
		SEL repSEL = @selector(jc_layoutSubviews);
		Method  method = class_getInstanceMethod(cls, oriSEL);
		Method _method = class_getInstanceMethod(cls, repSEL);
		BOOL success = class_addMethod(cls, oriSEL, method_getImplementation(_method), method_getTypeEncoding(_method));
		if (success) {
			class_replaceMethod(cls, repSEL, method_getImplementation(method), method_getTypeEncoding(method));
			
		} else {
			method_exchangeImplementations(method, _method);
		}
	});
}

- (void)jc_layoutSubviews {
	[self jc_layoutSubviews];
	[self jc_layoutLoaderProgressView];
}

#pragma mark - public method
- (void)jc_loadUrl:(NSString *)url {
	[self jc_loadUrl:url block:nil];
}

- (void)jc_loadUrl:(NSString *)url block:(void (^)(UIImage *, NSString *))block {
	[self jc_loadUrl:url placeholder:nil thumbnail:0 block:block];
}

- (void)jc_loadUrl:(NSString *)url placeholder:(UIImage *)placeholder {
	[self jc_loadUrl:url placeholder:placeholder thumbnail:0 block:nil];
}

- (void)jc_loadUrl:(NSString *)url placeholder:(UIImage *)placeholder thumbnail:(CGFloat)thumbnail block:(void (^)(UIImage *, NSString *))block {
	[self jc_fade];
	if (placeholder) {
		[self setImage:placeholder];
	}
	else {
		[self setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:1.0f]];
	}
	
	[self jc_layoutLoaderProgressView];
	
	__weak __typeof(&*self) wself = self;
	[[self loaderManager] loadWithUrl:url complete:^(UIImage *image) {
		if (thumbnail > 0.0f && thumbnail < 1.0f) {
			[wself setImage:[image imageResize:CGSizeMake(image.size.width*thumbnail, image.size.height*thumbnail)]];
		}
		else {
			[wself setImage:image];
		}
		[wself jc_fade];
		if (block) {
			block(image, url);
		}
	}];
}

- (void)jc_loadUrl:(NSString *)url thumbnail:(CGFloat)thumbnail {
	[self jc_loadUrl:url placeholder:nil thumbnail:thumbnail];
}

- (void)jc_loadUrl:(NSString *)url thumbnail:(CGFloat)thumbnail block:(void (^)(UIImage *, NSString *))block {
	[self jc_loadUrl:url placeholder:nil thumbnail:thumbnail block:block];
}

- (void)jc_loadUrl:(NSString *)url placeholder:(UIImage *)placeholder thumbnail:(CGFloat)thumbnail {
	[self jc_loadUrl:url placeholder:placeholder thumbnail:thumbnail block:nil];
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

- (void)jc_layoutLoaderProgressView {
	JCProgressView * view = [[self loaderManager] progressView];
	if (![view superview]) {
		[self addSubview:view];
	}
	view.center = CGPointMake(CGRectGetWidth(self.frame)*0.5f, CGRectGetHeight(self.frame)*0.5f);
}

#pragma mark - animation
- (void)jc_fade {
	CATransition * animation = [CATransition animation];
	animation.type = kCATransitionFade;
	animation.duration = 0.5f;
	[self.layer addAnimation:animation forKey:@"fade"];
}

@end

#pragma mark -
@implementation UIImage (Size)

- (UIImage *)imageResize:(CGSize)size {
	UIImage *newimage = nil;
	UIGraphicsBeginImageContext(size);
	[self drawInRect:CGRectMake(0, 0, size.width, size.height)];
	newimage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newimage;
}

@end
















































