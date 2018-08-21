//
//  JCCacheManager.m
//  JCWorks
//
//  Created by Jai on 2018/7/10.
//  Copyright © 2018年 Jai Chow. All rights reserved.
//

#import "JCCacheManager.h"
#import <CommonCrypto/CommonDigest.h>

#define JCDirName @"jc_image_cache"

@interface NSString (md5)

- (NSString*)md5;

@end

@interface JCCacheManager ()

@property (nonatomic, copy) NSString * dirPath;
@property (nonatomic, strong) NSFileManager * fileManager;

@end

@implementation JCCacheManager

#pragma mark - init
+ (instancetype)manager {
	return [JCCacheManager new];
}

#pragma mark - getter
- (NSFileManager *)fileManager {
	if (!_fileManager) {
		_fileManager = [[NSFileManager alloc] init];
	}
	return _fileManager;
}

- (NSString *)dirPath {
	if (!_dirPath) {
		NSString * path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
		_dirPath = [path stringByAppendingPathComponent:JCDirName];
		if (![self.fileManager fileExistsAtPath:_dirPath]) {
			[self.fileManager createDirectoryAtPath:_dirPath withIntermediateDirectories:YES attributes:nil error:nil];
		}
	}
	return _dirPath;
}

#pragma mark - load
- (UIImage*)imageForKey:(NSString *)key {
	UIImage * image = nil;
	if (key.length == 0) {
		return image;
	}
	
	NSString * file = [self.dirPath stringByAppendingPathComponent:[key md5]];
#if DEBUG
	NSLog(@"cached file: %@", file);
#endif
	if ([self.fileManager fileExistsAtPath:file]) {
		image = [UIImage imageWithContentsOfFile:file];
	}
	return image;
}

- (void)cacheImage:(UIImage *)image key:(NSString *)key {
	if (!image || key.length == 0) {
		return;
	}
	NSString * pathExtension = [key pathExtension];
	NSData * data = nil;
#if DEBUG
	NSLog(@"pathExtension: %@", pathExtension);
#endif
	if ([[pathExtension lowercaseString] isEqualToString:@"png"]
		|| [[key lowercaseString] containsString:@".png"]) {
		data = UIImagePNGRepresentation(image);
	}
	else {
		data = UIImageJPEGRepresentation(image, 1.0f);
	}
	NSString * file = [self.dirPath stringByAppendingPathComponent:[key md5]];
#if DEBUG
	NSLog(@"caching file: %@", file);
#endif
	[data writeToFile:file atomically:YES];
}

@end

@implementation NSString (md5)

- (NSString *)md5 {
	const char *cStr = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(cStr, (uint32_t)strlen(cStr), result);
	return [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
			];
}

@end

















































