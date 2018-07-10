//
//  JCRequestImageOperation.m
//  JCWorks
//
//  Created by Jai on 2018/7/10.
//  Copyright © 2018年 Jai Chow. All rights reserved.
//

#import "JCRequestImageOperation.h"

@interface JCRequestImageOperation () <NSURLConnectionDataDelegate, NSURLSessionDataDelegate>

@property (nonatomic, strong) NSMutableData * imageData;
@property (nonatomic, assign) CGFloat total;

@end

@implementation JCRequestImageOperation

#pragma mark - create
+ (instancetype)createWithImageUrl:(NSString *)imageUrl {
	return [self createWithImageUrl:imageUrl progress:nil block:nil];
}

+ (instancetype)createWithImageUrl:(NSString *)imageUrl progress:(void(^)(CGFloat progress))progress block:(void (^)(UIImage *))block {
	JCRequestImageOperation * operation = [[JCRequestImageOperation alloc] initWithImageUrl:imageUrl progress:progress block:block];
	return operation;
}

#pragma mark - init
- (instancetype)initWithImageUrl:(NSString *)imageUrl {
	return [self initWithImageUrl:imageUrl progress:nil block:nil];
}

- (instancetype)initWithImageUrl:(NSString *)imageUrl progress:(void(^)(CGFloat progress))progress block:(void (^)(UIImage *))block {
	self = [super init];
	if (self) {
		self.imageUrl = imageUrl;
		self.callback = block;
		self.progress = progress;
	}
	return self;
}

#pragma mark - runloop
- (void)main {
	if (self.imageUrl.length == 0) {
		self.callback ? self.callback(nil) : nil;
		return;
	}
#if DEBUG
	NSLog(@"want to load: %@", self.imageUrl);
#endif
	NSURL * url = [NSURL URLWithString:self.imageUrl];
	
	if (@available(iOS 7.0, *)) {
		[self jc_requestUsingSessionWithUrl:url];
	}
	else {
		[self jc_requestUsingConnectionWithUrl:url];
	}
}

- (void)jc_requestUsingSessionWithUrl:(NSURL*)url {
	NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
	configuration.timeoutIntervalForRequest = 20.0f;
	configuration.allowsCellularAccess = YES;
	
	NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue currentQueue]];
	NSURLSessionTask * task = [session dataTaskWithURL:url];
	[task resume];
}

- (void)jc_requestUsingConnectionWithUrl:(NSURL*)url {
	NSURLRequest * request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20.0f];
	[NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
#if DEBUG
	NSLog(@"dataTaskWithURL: %@\nerror: %@", self.imageUrl, error);
#endif
	[self jc_handleImage:nil];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	self.imageData = [NSMutableData data];
	self.total = (CGFloat)response.expectedContentLength;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self jc_handleData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	UIImage * image = [UIImage imageWithData:self.imageData];
	[self jc_handleImage:image];
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
	UIImage * image = nil;
	if (error) {
#if DEBUG
		NSLog(@"dataTaskWithURL: %@\nerror: %@", self.imageUrl, error);
#endif
	}
	else {
		image = [UIImage imageWithData:self.imageData];
	}
	[self jc_handleImage:image];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
	[self jc_handleData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
	self.imageData = [NSMutableData data];
	self.total = (CGFloat)response.expectedContentLength;
	completionHandler(NSURLSessionResponseAllow);
}

#pragma mark - handle
- (void)jc_handleData:(NSData*)data {
	[self.imageData appendData:data];
	if (self.progress) {
		CGFloat current = (CGFloat)[self.imageData length];
		CGFloat progress = current/self.total;
#if DEBUG
		NSLog(@"progress: %f%%", progress);
#endif
		__weak __typeof(&*self) wself = self;
		dispatch_async(dispatch_get_main_queue(), ^{
			wself.progress(progress);
		});
	}
}

- (void)jc_handleImage:(UIImage*)image {
	if (self.callback) {
		__weak __typeof(&*self) wself = self;
		dispatch_async(dispatch_get_main_queue(), ^{
			wself.callback(image);
		});
	}
	self.imageData = nil;
}

@end


















































