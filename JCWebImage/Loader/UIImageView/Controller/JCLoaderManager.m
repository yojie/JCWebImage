//
//  JCLoaderManager.m
//  JCWorks
//
//  Created by Jai on 2018/7/10.
//  Copyright © 2018年 Jai Chow. All rights reserved.
//

#import "JCLoaderManager.h"
#import "JCRequestImageOperation.h"
#import "JCCacheManager.h"

@interface JCLoaderManager ()

@property (nonatomic, strong) JCProgressView * progressView;
@property (nonatomic, copy) void(^callback)(UIImage*image);
@property (nonatomic, strong) NSOperationQueue * loadQueue;
@property (nonatomic, strong) JCCacheManager * cacheManager;

@end

@implementation JCLoaderManager

#pragma mark - create
+ (instancetype)manager {
	return [[JCLoaderManager alloc] init];
}

#pragma mark - setup
- (JCProgressView *)progressView {
	if (!_progressView) {
		_progressView = [[JCProgressView alloc] initWithFrame:CGRectMake(0, 0, JCDimmerProgress, JCDimmerProgress)];
	}
	return _progressView;
}

- (NSOperationQueue *)loadQueue {
	if (!_loadQueue) {
		_loadQueue = [[NSOperationQueue alloc] init];
	}
	return _loadQueue;
}

- (JCCacheManager *)cacheManager {
	if (!_cacheManager) {
		_cacheManager = [JCCacheManager manager];
	}
	return _cacheManager;
}

#pragma mark - load
- (void)loadWithUrl:(NSString *)url complete:(void (^)(UIImage *))complete {
	UIImage * image = [self.cacheManager imageForKey:url];
	if (image) {
		self.progressView.hidden = YES;
		dispatch_async(dispatch_get_main_queue(), ^{
			complete ? complete(image) : nil;
		});
		return;
	}
	
	self.progressView.hidden = NO;
	__weak __typeof(&*self) wself = self;
	JCRequestImageOperation * operation = [JCRequestImageOperation createWithImageUrl:url progress:^(CGFloat progress) {
		wself.progressView.progress = progress;
	} block:^(UIImage *image) {
		dispatch_async(dispatch_get_main_queue(), ^{
			complete ? complete(image) : nil;
		});
		dispatch_async(dispatch_get_global_queue(0, 0), ^{
			[wself.cacheManager cacheImage:image key:url];
		});
	}];
	
	[self.loadQueue addOperation:operation];
}

@end



















































